{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit Net.CrossSocket.Epoll;

interface

{$IF DEFINED(LINUX) OR DEFINED(ANDROID)}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Posix.SysSocket,
  Posix.NetinetIn,
  Posix.UniStd,
  Posix.NetDB,
  Posix.Pthread,
  Posix.Errno,
  Linux.epoll,
  Net.SocketAPI,
  Net.CrossSocket.Base;

type
  TIoEvent = (ieRead, ieWrite);
  TIoEvents = set of TIoEvent;

  TEpollListen = class(TAbstractCrossListen)
  private
    FLock: TObject;
    FIoEvents: TIoEvents;
    FOpCode: Integer;

    procedure _Lock; inline;
    procedure _Unlock; inline;

    function _ReadEnabled: Boolean; inline;
    function _UpdateIoEvent(const AIoEvents: TIoEvents): Boolean;
  public
    constructor Create(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer); override;
    destructor Destroy; override;
  end;

  PSendItem = ^TSendItem;
  TSendItem = record
    Data: PByte;
    Size: Integer;
    Callback: TCrossConnectionCallback;
  end;

  TSendQueue = class(TList<PSendItem>)
  protected
    procedure Notify(const Value: PSendItem; Action: TCollectionNotification); override;
  end;

  TEpollConnection = class(TAbstractCrossConnection)
  private
    FLock: TObject;
    FSendQueue: TSendQueue;
    FIoEvents: TIoEvents;
    FConnectCallback: TCrossConnectionCallback;
    FOpCode: Integer;

    procedure _Lock; inline;
    procedure _Unlock; inline;
    function _ReadEnabled: Boolean; inline;
    function _WriteEnabled: Boolean; inline;
    function _UpdateIoEvent(const AIoEvents: TIoEvents): Boolean;
  public
    constructor Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType); override;
    destructor Destroy; override;
  end;

  TEpollCrossSocket = class(TAbstractCrossSocket)
  private const
    MAX_EVENT_COUNT = 2048;
    SHUTDOWN_FLAG   = UInt64(-1);
  private class threadvar
    FEventList: array [0..MAX_EVENT_COUNT-1] of TEPoll_Event;
  private
    FEpollHandle: THandle;
    FIoThreads: TArray<TIoEventThread>;
    FIdleHandle: THandle;
    FIdleLock: TObject;
    FStopHandle: THandle;

    procedure _OpenStopHandle; inline;
    procedure _PostStopCommand; inline;
    procedure _CloseStopHandle; inline;
    procedure _OpenIdleHandle; inline;
    procedure _CloseIdleHandle; inline;
    procedure _HandleAccept(const AListen: ICrossListen);
    procedure _HandleConnect(const AConnection: ICrossConnection);
    procedure _HandleRead(const AConnection: ICrossConnection);
    procedure _HandleWrite(const AConnection: ICrossConnection);
  protected
    function CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection; override;
    function CreateListen(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer): ICrossListen; override;
    procedure StartLoop; override;
    procedure StopLoop; override;
    procedure Listen(const AHost: string; const APort: Word; const ACallback: TCrossListenCallback = nil); override;
    procedure Connect(const AHost: string; const APort: Word; const ACallback: TCrossConnectionCallback = nil); override;
    procedure Send(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback = nil); override;
    function ProcessIoEvent: Boolean; override;
  public
    constructor Create(const AIoThreads: Integer); override;
    destructor Destroy; override;
  end;

implementation

{$I Net.Posix.inc}

{ TEpollListen }

constructor TEpollListen.Create(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer);
begin
  inherited;

  FLock := TObject.Create;
  FOpCode := EPOLL_CTL_ADD;
end;

destructor TEpollListen.Destroy;
begin
  FreeAndNil(FLock);

  inherited;
end;

procedure TEpollListen._Lock;
begin
  System.TMonitor.Enter(FLock);
end;

function TEpollListen._ReadEnabled: Boolean;
begin
  Result := (ieRead in FIoEvents);
end;

procedure TEpollListen._Unlock;
begin
  System.TMonitor.Exit(FLock);
end;

function TEpollListen._UpdateIoEvent(const AIoEvents: TIoEvents): Boolean;
var
  LOwner: TEpollCrossSocket;
  LEvent: TEPoll_Event;
begin
  FIoEvents := AIoEvents;

  if (FIoEvents = []) or IsClosed then Exit(False);

  LOwner := TEpollCrossSocket(Owner);

  LEvent.Events := EPOLLET or EPOLLONESHOT;
  LEvent.Data.u64 := Self.UID;

  if _ReadEnabled then
    LEvent.Events := LEvent.Events or EPOLLIN;

  Result := (epoll_ctl(LOwner.FEpollHandle, FOpCode, Socket, @LEvent) >= 0);
  FOpCode := EPOLL_CTL_MOD;

  {$IFDEF DEBUG}
  if not Result then
    _Log('listen %d epoll_ctl error %d', [UID, GetLastError]);
  {$ENDIF}
end;

{ TSendQueue }

procedure TSendQueue.Notify(const Value: PSendItem; Action: TCollectionNotification);
begin
  inherited;

  if (Action = TCollectionNotification.cnRemoved) then
  begin
    if (Value <> nil) then
    begin
      Value.Callback := nil;
      FreeMem(Value, SizeOf(TSendItem));
    end;
  end;
end;

{ TEpollConnection }

constructor TEpollConnection.Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType);
begin
  inherited;

  FSendQueue := TSendQueue.Create;
  FLock := TObject.Create;

  FOpCode := EPOLL_CTL_ADD;
end;

destructor TEpollConnection.Destroy;
var
  LConnection: ICrossConnection;
  LSendItem: PSendItem;
begin
  LConnection := Self;

  _Lock;
  try
    if Assigned(FConnectCallback) then
    begin
      FConnectCallback(LConnection, False);
      FConnectCallback := nil;
    end;

    if (FSendQueue.Count > 0) then
    begin
      for LSendItem in FSendQueue do
        if Assigned(LSendItem.Callback) then
          LSendItem.Callback(LConnection, False);

      FSendQueue.Clear;
    end;

    FreeAndNil(FSendQueue);
  finally
    _Unlock;
  end;

  FreeAndNil(FLock);

  inherited;
end;

procedure TEpollConnection._Lock;
begin
  System.TMonitor.Enter(FLock);
end;

function TEpollConnection._ReadEnabled: Boolean;
begin
  Result := (ieRead in FIoEvents);
end;

procedure TEpollConnection._Unlock;
begin
  System.TMonitor.Exit(FLock);
end;

function TEpollConnection._UpdateIoEvent(const AIoEvents: TIoEvents): Boolean;
var
  LOwner: TEpollCrossSocket;
  LEvent: TEPoll_Event;
begin
  FIoEvents := AIoEvents;

  if (FIoEvents = []) or IsClosed then Exit(False);

  LOwner := TEpollCrossSocket(Owner);

  LEvent.Events := EPOLLET or EPOLLONESHOT;
  LEvent.Data.u64 := Self.UID;

  if _ReadEnabled then
    LEvent.Events := LEvent.Events or EPOLLIN;

  if _WriteEnabled then
    LEvent.Events := LEvent.Events or EPOLLOUT;

  Result := (epoll_ctl(LOwner.FEpollHandle, FOpCode, Socket, @LEvent) >= 0);
  FOpCode := EPOLL_CTL_MOD;

  {$IFDEF DEBUG}
  if not Result then
    _Log('connection %.16x epoll_ctl socket=%d events=0x%.8x error %d', [UID, LEvent.Events, Socket, GetLastError]);
  {$ENDIF}
end;

function TEpollConnection._WriteEnabled: Boolean;
begin
  Result := (ieWrite in FIoEvents);
end;

{ TEpollCrossSocket }

constructor TEpollCrossSocket.Create(const AIoThreads: Integer);
begin
  inherited;

  FIdleLock := TObject.Create;
end;

destructor TEpollCrossSocket.Destroy;
begin
  FreeAndNil(FIdleLock);

  inherited;
end;

procedure TEpollCrossSocket._CloseIdleHandle;
begin
  FileClose(FIdleHandle);
end;

procedure TEpollCrossSocket._CloseStopHandle;
begin
  FileClose(FStopHandle);
end;

procedure TEpollCrossSocket._HandleAccept(const AListen: ICrossListen);
var
  LListen: ICrossListen;
  LConnection: ICrossConnection;
  LEpConnection: TEpollConnection;
  LSocket, LError: Integer;
  LListenSocket, LClientSocket: THandle;
  LSuccess: Boolean;
begin
  LListen := AListen;
  LListenSocket := LListen.Socket;

  while True do
  begin
    LSocket := TSocketAPI.Accept(LListenSocket, nil, nil);

    if (LSocket < 0) then
    begin
      LError := GetLastError;

      if (LError = EMFILE) then
      begin
        System.TMonitor.Enter(FIdleLock);
        try
          _CloseIdleHandle;
          LSocket := TSocketAPI.Accept(LListenSocket, nil, nil);
          TSocketAPI.CloseSocket(LSocket);
          _OpenIdleHandle;
        finally
          System.TMonitor.Exit(FIdleLock);
        end;
      end;

      Break;
    end;

    LClientSocket := LSocket;
    TSocketAPI.SetNonBlock(LClientSocket, True);
    SetKeepAlive(LClientSocket);

    LConnection := CreateConnection(Self, LClientSocket, ctAccept);
    TriggerConnecting(LConnection);
    TriggerConnected(LConnection);

    LEpConnection := LConnection as TEpollConnection;
    LEpConnection._Lock;
    try
      LSuccess := LEpConnection._UpdateIoEvent([ieRead]);
    finally
      LEpConnection._Unlock;
    end;

    if not LSuccess then
      LConnection.Close;
  end;
end;

procedure TEpollCrossSocket._HandleConnect(const AConnection: ICrossConnection);
var
  LConnection: ICrossConnection;
  LEpConnection: TEpollConnection;
  LConnectCallback: TCrossConnectionCallback;
begin
  LConnection := AConnection;

  if (TSocketAPI.GetError(LConnection.Socket) <> 0) then
  begin
    {$IFDEF DEBUG}
    _LogLastOsError;
    {$ENDIF}
    LConnection.Close;
    Exit;
  end;

  LEpConnection := LConnection as TEpollConnection;

  LEpConnection._Lock;
  try
    LConnectCallback := LEpConnection.FConnectCallback;
    LEpConnection.FConnectCallback := nil;
  finally
    LEpConnection._Unlock;
  end;

  TriggerConnected(LConnection);

  if Assigned(LConnectCallback) then
    LConnectCallback(LConnection, True);
end;

procedure TEpollCrossSocket._HandleRead(const AConnection: ICrossConnection);
var
  LConnection: ICrossConnection;
  LRcvd, LError: Integer;
begin
  LConnection := AConnection;

  while True do
  begin
    LRcvd := TSocketAPI.Recv(LConnection.Socket, FRecvBuf[0], RCV_BUF_SIZE);

    if (LRcvd = 0) then
    begin
      LConnection.Close;
      Exit;
    end;

    if (LRcvd < 0) then
    begin
      LError := GetLastError;

      if (LError = EINTR) then
        Continue
      else
      if (LError = EAGAIN) or (LError = EWOULDBLOCK) then
        Break
      else
      begin
        LConnection.Close;
        Exit;
      end;
    end;

    TriggerReceived(LConnection, @FRecvBuf[0], LRcvd);

    if (LRcvd < RCV_BUF_SIZE) then Break;
  end;
end;

procedure TEpollCrossSocket._HandleWrite(const AConnection: ICrossConnection);
var
  LConnection: ICrossConnection;
  LEpConnection: TEpollConnection;
  LSendItem: PSendItem;
  LCallback: TCrossConnectionCallback;
  LSent: Integer;
begin
  LConnection := AConnection;
  LEpConnection := LConnection as TEpollConnection;

  LEpConnection._Lock;
  try
    if (LEpConnection.FSendQueue.Count <= 0) then
    begin
      LEpConnection._UpdateIoEvent([]);
      Exit;
    end;

    LSendItem := LEpConnection.FSendQueue.Items[0];
    LSent := PosixSend(LConnection.Socket, LSendItem.Data, LSendItem.Size);

    if (LSent >= LSendItem.Size) then
    begin
      LCallback := LSendItem.Callback;

      if (LEpConnection.FSendQueue.Count > 0) then
        LEpConnection.FSendQueue.Delete(0);

      if (LEpConnection.FSendQueue.Count <= 0) then
        LEpConnection._UpdateIoEvent([]);

      if Assigned(LCallback) then
        LCallback(LConnection, True);

      Exit;
    end;

    if (LSent < 0) then Exit;

    Dec(LSendItem.Size, LSent);
    Inc(LSendItem.Data, LSent);
  finally
    LEpConnection._Unlock;
  end;
end;


procedure TEpollCrossSocket._OpenIdleHandle;
begin
  FIdleHandle := FileOpen('/dev/null', fmOpenRead);
end;

procedure TEpollCrossSocket._OpenStopHandle;
var
  LEvent: TEPoll_Event;
begin
  FStopHandle := eventfd(0, 0);
  LEvent.Events := EPOLLIN;
  LEvent.Data.u64 := SHUTDOWN_FLAG;
  epoll_ctl(FEpollHandle, EPOLL_CTL_ADD, FStopHandle, @LEvent);
end;

procedure TEpollCrossSocket._PostStopCommand;
var
  LStuff: UInt64;
begin
  LStuff := 1;
  Posix.UniStd.__write(FStopHandle, @LStuff, SizeOf(LStuff));
end;

procedure TEpollCrossSocket.StartLoop;
var
  I: Integer;
  LCrossSocket: ICrossSocket;
begin
  if (FIoThreads <> nil) then
    Exit;

  _OpenIdleHandle;

  FEpollHandle := epoll_create(MAX_EVENT_COUNT);
  LCrossSocket := Self;
  SetLength(FIoThreads, GetIoThreads);
  for I := 0 to Length(FIoThreads) - 1 do
    FIoThreads[I] := TIoEventThread.Create(LCrossSocket);

  _OpenStopHandle;
end;

procedure TEpollCrossSocket.StopLoop;
var
  I: Integer;
  LCurrentThreadID: TThreadID;
begin
  if (FIoThreads = nil) then Exit;

  CloseAll;

  while (FListensCount > 0) or (FConnectionsCount > 0) do Sleep(1);

  _PostStopCommand;

  LCurrentThreadID := GetCurrentThreadId;
  for I := 0 to Length(FIoThreads) - 1 do
  begin
    if (FIoThreads[I].ThreadID = LCurrentThreadID) then
      raise ECrossSocket.Create('不能在IO线程中执行StopLoop!');

    FIoThreads[I].WaitFor;
    FreeAndNil(FIoThreads[I]);
  end;
  FIoThreads := nil;

  FileClose(FEpollHandle);
  _CloseIdleHandle;
  _CloseStopHandle;
end;

procedure TEpollCrossSocket.Connect(const AHost: string; const APort: Word; const ACallback: TCrossConnectionCallback);

  procedure _Failed1;
  begin
    if Assigned(ACallback) then
      ACallback(nil, False);
  end;

  function _Connect(ASocket: THandle; AAddr: PRawAddrInfo): Boolean;
  var
    LConnection: ICrossConnection;
    LEpConnection: TEpollConnection;
  begin
    if (TSocketAPI.Connect(ASocket, AAddr.ai_addr, AAddr.ai_addrlen) = 0) or (GetLastError = EINPROGRESS) then
    begin
      LConnection := CreateConnection(Self, ASocket, ctConnect);
      TriggerConnecting(LConnection);
      LEpConnection := LConnection as TEpollConnection;

      LEpConnection._Lock;
      try
        LEpConnection.ConnectStatus := csConnecting;
        LEpConnection.FConnectCallback := ACallback;
        if not LEpConnection._UpdateIoEvent([ieWrite]) then
        begin
          if Assigned(ACallback) then
            ACallback(LConnection, False);
          LConnection.Close;
          Exit(False);
        end;
      finally
        LEpConnection._Unlock;
      end;
    end else
    begin
      if Assigned(ACallback) then
        ACallback(nil, False);
      TSocketAPI.CloseSocket(ASocket);
      Exit(False);
    end;

    Result := True;
  end;

var
  LHints: TRawAddrInfo;
  P, LAddrInfo: PRawAddrInfo;
  LSocket: THandle;
begin
  FillChar(LHints, SizeOf(TRawAddrInfo), 0);
  LHints.ai_family := AF_UNSPEC;
  LHints.ai_socktype := SOCK_STREAM;
  LHints.ai_protocol := IPPROTO_TCP;
  LAddrInfo := TSocketAPI.GetAddrInfo(AHost, APort, LHints);
  if (LAddrInfo = nil) then
  begin
    _Failed1;
    Exit;
  end;

  P := LAddrInfo;
  try
    while (LAddrInfo <> nil) do
    begin
      LSocket := TSocketAPI.NewSocket(LAddrInfo.ai_family, LAddrInfo.ai_socktype,
        LAddrInfo.ai_protocol);
      if (LSocket = INVALID_HANDLE_VALUE) then
      begin
        _Failed1;
        Exit;
      end;

      TSocketAPI.SetNonBlock(LSocket, True);
      SetKeepAlive(LSocket);

      if _Connect(LSocket, LAddrInfo) then Exit;

      LAddrInfo := PRawAddrInfo(LAddrInfo.ai_next);
    end;
  finally
    TSocketAPI.FreeAddrInfo(P);
  end;

  _Failed1;
end;

function TEpollCrossSocket.CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection;
begin
  Result := TEpollConnection.Create(AOwner, AClientSocket, AConnectType);
end;

function TEpollCrossSocket.CreateListen(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer): ICrossListen;
begin
  Result := TEpollListen.Create(AOwner, AListenSocket, AFamily, ASockType, AProtocol);
end;

procedure TEpollCrossSocket.Listen(const AHost: string; const APort: Word;
  const ACallback: TCrossListenCallback);
var
  LHints: TRawAddrInfo;
  P, LAddrInfo: PRawAddrInfo;
  LListenSocket: THandle;
  LListen: ICrossListen;
  LEpListen: TEpollListen;
  LSuccess: Boolean;

  procedure _Failed;
  begin
    if Assigned(ACallback) then
      ACallback(nil, False);
  end;

begin
  FillChar(LHints, SizeOf(TRawAddrInfo), 0);

  LHints.ai_flags := AI_PASSIVE;
  LHints.ai_family := AF_UNSPEC;
  LHints.ai_socktype := SOCK_STREAM;
  LHints.ai_protocol := IPPROTO_TCP;
  LAddrInfo := TSocketAPI.GetAddrInfo(AHost, APort, LHints);
  if (LAddrInfo = nil) then
  begin
    _Failed;
    Exit;
  end;

  P := LAddrInfo;
  try
    while (LAddrInfo <> nil) do
    begin
      LListenSocket := TSocketAPI.NewSocket(LAddrInfo.ai_family, LAddrInfo.ai_socktype,
        LAddrInfo.ai_protocol);
      if (LListenSocket = INVALID_HANDLE_VALUE) then
      begin
        _Failed;
        Exit;
      end;

      TSocketAPI.SetNonBlock(LListenSocket, True);
      TSocketAPI.SetReUseAddr(LListenSocket, True);

      if (LAddrInfo.ai_family = AF_INET6) then
        TSocketAPI.SetSockOpt<Integer>(LListenSocket, IPPROTO_IPV6, IPV6_V6ONLY, 1);

      if (TSocketAPI.Bind(LListenSocket, LAddrInfo.ai_addr, LAddrInfo.ai_addrlen) < 0)
        or (TSocketAPI.Listen(LListenSocket) < 0) then
      begin
        _Failed;
        Exit;
      end;

      LListen := CreateListen(Self, LListenSocket, LAddrInfo.ai_family, LAddrInfo.ai_socktype, LAddrInfo.ai_protocol);
      LEpListen := LListen as TEpollListen;

      LEpListen._Lock;
      try
        LSuccess := LEpListen._UpdateIoEvent([ieRead]);
      finally
        LEpListen._Unlock;
      end;

      if not LSuccess then
      begin
        _Failed;

        Exit;
      end;

      TriggerListened(LListen);
      if Assigned(ACallback) then
        ACallback(LListen, True);

      if (APort = 0) and (LAddrInfo.ai_next <> nil) then
        Psockaddr_in(LAddrInfo.ai_next.ai_addr).sin_port := LListen.LocalPort;

      LAddrInfo := PRawAddrInfo(LAddrInfo.ai_next);
    end;
  finally
    TSocketAPI.FreeAddrInfo(P);
  end;
end;

procedure TEpollCrossSocket.Send(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback);
var
  LEpConnection: TEpollConnection;
  LSendItem: PSendItem;
begin
  GetMem(LSendItem, SizeOf(TSendItem));
  FillChar(LSendItem^, SizeOf(TSendItem), 0);
  LSendItem.Data := ABuf;
  LSendItem.Size := ALen;
  LSendItem.Callback := ACallback;

  LEpConnection := AConnection as TEpollConnection;

  LEpConnection._Lock;
  try
    LEpConnection.FSendQueue.Add(LSendItem);

    if not LEpConnection._WriteEnabled then
      LEpConnection._UpdateIoEvent([ieRead, ieWrite]);
  finally
    LEpConnection._Unlock;
  end;
end;

function TEpollCrossSocket.ProcessIoEvent: Boolean;
var
  LRet, I: Integer;
  LEvent: TEPoll_Event;
  LCrossUID: UInt64;
  LCrossTag: Byte;
  LListens: TCrossListens;
  LConnections: TCrossConnections;
  LListen: ICrossListen;
  LEpListen: TEpollListen;
  LConnection: ICrossConnection;
  LEpConnection: TEpollConnection;
  LSuccess: Boolean;
  LIoEvents: TIoEvents;
begin
  LRet := epoll_wait(FEpollHandle, @FEventList[0], MAX_EVENT_COUNT, -1);
  if (LRet < 0) then
  begin
    LRet := GetLastError;
    Exit(LRet = EINTR);
  end;

  for I := 0 to LRet - 1 do
  begin
    LEvent := FEventList[I];

    if (LEvent.Data.u64 = SHUTDOWN_FLAG) then Exit(False);

    LCrossUID := LEvent.Data.u64;
    LCrossTag := GetTagByUID(LCrossUID);
    LListen := nil;
    LConnection := nil;

    case LCrossTag of
      UID_LISTEN:
        begin
          LListens := LockListens;
          try
            if not LListens.TryGetValue(LCrossUID, LListen) then
              Continue;
          finally
            UnlockListens;
          end;
        end;
      UID_CONNECTION:
        begin
          LConnections := LockConnections;
          try
            if not LConnections.TryGetValue(LCrossUID, LConnection)
              or (LConnection = nil) then
              Continue;
          finally
            UnlockConnections;
          end;
        end;
    else
      Continue;
    end;

    if (LListen <> nil) then
    begin
      if (LEvent.Events and EPOLLIN <> 0) then
        _HandleAccept(LListen);

      LEpListen := LListen as TEpollListen;
      LEpListen._Lock;
      LEpListen._UpdateIoEvent([ieRead]);
      LEpListen._Unlock;
    end
    else
    if (LConnection <> nil) then
    begin
      if (LEvent.Events and EPOLLIN <> 0) then
        _HandleRead(LConnection);

      if (LEvent.Events and EPOLLOUT <> 0) then
      begin
        if (LConnection.ConnectStatus = csConnecting) then
          _HandleConnect(LConnection)
        else
          _HandleWrite(LConnection);
      end;

      if not LConnection.IsClosed then
      begin
        LEpConnection := LConnection as TEpollConnection;
        LEpConnection._Lock;
        try
          if (LEpConnection.FSendQueue.Count > 0) then
            LIoEvents := [ieRead, ieWrite]
          else
            LIoEvents := [ieRead];
          LSuccess := LEpConnection._UpdateIoEvent(LIoEvents);
        finally
          LEpConnection._Unlock;
        end;

        if not LSuccess then
          LConnection.Close;
      end;
    end;
  end;

  Result := True;
end;

{$ELSE}

implementation

{$IFEND}

end.
