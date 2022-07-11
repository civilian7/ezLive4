{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit Net.CrossSocket.Kqueue;

interface

{$IF DEFINED(IOS) OR DEFINED(MACOS)}

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
  BSD.kqueue,
  Net.SocketAPI,
  Net.CrossSocket.Base;

type
  TIoEvent = (ieRead, ieWrite);
  TIoEvents = set of TIoEvent;

  TKqueueListen = class(TAbstractCrossListen)
  private
    FLock: TObject;
    FIoEvents: TIoEvents;

    procedure _Lock; inline;
    function  _ReadEnabled: Boolean; inline;
    procedure _Unlock; inline;
    function  _UpdateIoEvent(const AIoEvents: TIoEvents): Boolean;
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

  TKqueueConnection = class(TAbstractCrossConnection)
  private
    FLock: TObject;
    FSendQueue: TSendQueue;
    FIoEvents: TIoEvents;
    FConnectCallback: TCrossConnectionCallback;

    procedure _Lock; inline;
    function  _ReadEnabled: Boolean; inline;
    procedure _Unlock; inline;
    function  _UpdateIoEvent(const AIoEvents: TIoEvents): Boolean;
    function  _WriteEnabled: Boolean; inline;
  public
    constructor Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType); override;
    destructor Destroy; override;

    procedure Close; override;
  end;

  TKqueueCrossSocket = class(TAbstractCrossSocket)
  private
    const
      MAX_EVENT_COUNT = 2048;
      SHUTDOWN_FLAG   = Pointer(-1);
    class threadvar
      FEventList: array [0..MAX_EVENT_COUNT-1] of TKEvent;
  private
    FIdleHandle: THandle;
    FIdleLock: TObject;
    FIoThreads: TArray<TIoEventThread>;
    FKqueueHandle: THandle;
    FStopHandle: TPipeDescriptors;

    procedure _CloseIdleHandle; inline;
    procedure _CloseStopHandle; inline;
    procedure _HandleAccept(const AListen: ICrossListen);
    procedure _HandleConnect(const AConnection: ICrossConnection);
    procedure _HandleRead(const AConnection: ICrossConnection);
    procedure _HandleWrite(const AConnection: ICrossConnection);
    procedure _OpenIdleHandle; inline;
    procedure _OpenStopHandle; inline;
    procedure _PostStopCommand; inline;
    procedure _SetNoSigPipe(ASocket: THandle); inline;
  protected
    procedure Connect(const AHost: string; const APort: Word; const ACallback: TCrossConnectionCallback = nil); override;
    function  CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection; override;
    function  CreateListen(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer): ICrossListen; override;
    procedure Listen(const AHost: string; const APort: Word; const ACallback: TCrossListenCallback = nil); override;
    function  ProcessIoEvent: Boolean; override;
    procedure Send(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback = nil); override;
    procedure StartLoop; override;
    procedure StopLoop; override;
  public
    constructor Create(const AIoThreads: Integer); override;
    destructor Destroy; override;
  end;

implementation

{$I Net.Posix.inc}

{ TKqueueListen }

constructor TKqueueListen.Create(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer);
begin
  inherited;

  FLock := TObject.Create;
end;

destructor TKqueueListen.Destroy;
begin
  FreeAndNil(FLock);

  inherited;
end;

procedure TKqueueListen._Lock;
begin
  System.TMonitor.Enter(FLock);
end;

function TKqueueListen._ReadEnabled: Boolean;
begin
  Result := (ieRead in FIoEvents);
end;

procedure TKqueueListen._Unlock;
begin
  System.TMonitor.Exit(FLock);
end;

function TKqueueListen._UpdateIoEvent(const AIoEvents: TIoEvents): Boolean;
var
  LOwner: TKqueueCrossSocket;
  LCrossData: Pointer;
  LEvents: array [0..1] of TKEvent;
  N: Integer;
begin
  FIoEvents := AIoEvents;

  if (FIoEvents = []) or IsClosed then
    Exit(False);

  LOwner := TKqueueCrossSocket(Owner);
  LCrossData := Pointer(Self);
  N := 0;

  if _ReadEnabled then
  begin
    EV_SET(@LEvents[N], Socket, EVFILT_READ, EV_ADD or EV_ONESHOT or EV_CLEAR or EV_DISPATCH, 0, 0, Pointer(LCrossData));

    Inc(N);
  end;

  if (N <= 0) then
    Exit(False);

  Result := (kevent(LOwner.FKqueueHandle, @LEvents, N, nil, 0, nil) >= 0);

  {$IFDEF DEBUG}
  if not Result then
    _Log('listen %d kevent error %d', [Socket, GetLastError]);
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

{ TKqueueConnection }

constructor TKqueueConnection.Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType);
begin
  inherited;

  FSendQueue := TSendQueue.Create;
  FLock := TObject.Create;
end;

destructor TKqueueConnection.Destroy;
var
  LConnection: ICrossConnection;
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
      for var LSendItem in FSendQueue do
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

procedure TKqueueConnection.Close;
begin
  if (_SetConnectStatus(csClosed) = csClosed) then
    Exit;

  TSocketAPI.Shutdown(Socket, 2);
end;

procedure TKqueueConnection._Lock;
begin
  System.TMonitor.Enter(FLock);
end;

function TKqueueConnection._ReadEnabled: Boolean;
begin
  Result := (ieRead in FIoEvents);
end;

procedure TKqueueConnection._Unlock;
begin
  System.TMonitor.Exit(FLock);
end;

function TKqueueConnection._UpdateIoEvent(const AIoEvents: TIoEvents): Boolean;
var
  LOwner: TKqueueCrossSocket;
  LCrossData: Pointer;
  LEvents: array [0..1] of TKEvent;
  N: Integer;
begin
  FIoEvents := AIoEvents;

  if (FIoEvents = []) or IsClosed then
    Exit(False);

  LOwner := TKqueueCrossSocket(Owner);
  LCrossData := Pointer(Self);
  N := 0;

  if _ReadEnabled then
  begin
    Self._AddRef;

    EV_SET(@LEvents[N], Socket, EVFILT_READ, EV_ADD or EV_ONESHOT or EV_CLEAR or EV_DISPATCH, 0, 0, Pointer(LCrossData));

    Inc(N);
  end;

  if _WriteEnabled then
  begin
    Self._AddRef;

    EV_SET(@LEvents[N], Socket, EVFILT_WRITE, EV_ADD or EV_ONESHOT or EV_CLEAR or EV_DISPATCH, 0, 0, Pointer(LCrossData));

    Inc(N);
  end;

  if (N <= 0) then
    Exit(False);

  Result := (kevent(LOwner.FKqueueHandle, @LEvents, N, nil, 0, nil) >= 0);

  if not Result then
  begin
    {$IFDEF DEBUG}
    _Log('connection %d kevent error %d', [Socket, GetLastError]);
    {$ENDIF}

    while (N > 0) do
    begin
      Self._Release;
      Dec(N);
    end;
  end;
end;

function TKqueueConnection._WriteEnabled: Boolean;
begin
  Result := (ieWrite in FIoEvents);
end;

{ TKqueueCrossSocket }

constructor TKqueueCrossSocket.Create(const AIoThreads: Integer);
begin
  inherited;

  FIdleLock := TObject.Create;
end;

destructor TKqueueCrossSocket.Destroy;
begin
  FreeAndNil(FIdleLock);

  inherited;
end;

procedure TKqueueCrossSocket._CloseIdleHandle;
begin
  FileClose(FIdleHandle);
end;

procedure TKqueueCrossSocket._CloseStopHandle;
begin
  FileClose(FStopHandle.ReadDes);
  FileClose(FStopHandle.WriteDes);
end;

procedure TKqueueCrossSocket._HandleAccept(const AListen: ICrossListen);
var
  LListen: ICrossListen;
  LKqListen: TKqueueListen;
  LConnection: ICrossConnection;
  LKqConnection: TKqueueConnection;
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
    _SetNoSigPipe(LClientSocket);

    LConnection := CreateConnection(Self, LClientSocket, ctAccept);
    TriggerConnecting(LConnection);
    TriggerConnected(LConnection);

    LKqConnection := LConnection as TKqueueConnection;
    LKqConnection._Lock;
    try
      LSuccess := LKqConnection._UpdateIoEvent([ieRead]);
    finally
      LKqConnection._Unlock;
    end;

    if not LSuccess then
      LConnection.Close;
  end;

  LKqListen := LListen as TKqueueListen;
  LKqListen._Lock;
  LKqListen._UpdateIoEvent([ieRead]);
  LKqListen._Unlock;
end;

procedure TKqueueCrossSocket._HandleConnect(const AConnection: ICrossConnection);
var
  LConnection: ICrossConnection;
  LKqConnection: TKqueueConnection;
  LConnectCallback: TCrossConnectionCallback;
  LSuccess: Boolean;
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

  TriggerConnected(LConnection);

  LKqConnection := LConnection as TKqueueConnection;

  LKqConnection._Lock;
  try
    LConnectCallback := LKqConnection.FConnectCallback;
    LKqConnection.FConnectCallback := nil;
    LSuccess := LKqConnection._UpdateIoEvent([ieRead]);
  finally
    LKqConnection._Unlock;
  end;

  if Assigned(LConnectCallback) then
    LConnectCallback(LConnection, LSuccess);

  if not LSuccess then
    LConnection.Close;
end;

procedure TKqueueCrossSocket._HandleRead(const AConnection: ICrossConnection);
var
  LConnection: ICrossConnection;
  LRcvd, LError: Integer;
  LKqConnection: TKqueueConnection;
  LSuccess: Boolean;
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

    if (LRcvd < RCV_BUF_SIZE) then
      Break;
  end;

  LKqConnection := LConnection as TKqueueConnection;
  LKqConnection._Lock;
  try
    LSuccess := LKqConnection._UpdateIoEvent([ieRead]);
  finally
    LKqConnection._Unlock;
  end;

  if not LSuccess then
    LConnection.Close;
end;

procedure TKqueueCrossSocket._HandleWrite(const AConnection: ICrossConnection);
var
  LConnection: ICrossConnection;
  LKqConnection: TKqueueConnection;
  LSendItem: PSendItem;
  LCallback: TCrossConnectionCallback;
  LSent: Integer;
begin
  LConnection := AConnection;
  LKqConnection := LConnection as TKqueueConnection;

  LKqConnection._Lock;
  try
    if (LKqConnection.FSendQueue.Count <= 0) then
    begin
      LKqConnection._UpdateIoEvent([]);
      Exit;
    end;

    LSendItem := LKqConnection.FSendQueue.Items[0];

    LSent := PosixSend(LConnection.Socket, LSendItem.Data, LSendItem.Size);

    if (LSent >= LSendItem.Size) then
    begin
      LCallback := LSendItem.Callback;
      if (LKqConnection.FSendQueue.Count > 0) then
        LKqConnection.FSendQueue.Delete(0);

      if (LKqConnection.FSendQueue.Count <= 0) then
        LKqConnection._UpdateIoEvent([]);

      if Assigned(LCallback) then
        LCallback(LConnection, True);

      Exit;
    end;

    if (LSent < 0) then
      Exit;

    Dec(LSendItem.Size, LSent);
    Inc(LSendItem.Data, LSent);

    LKqConnection._UpdateIoEvent([ieWrite]);
  finally
    LKqConnection._Unlock;
  end;
end;


procedure TKqueueCrossSocket._OpenIdleHandle;
begin
  FIdleHandle := FileOpen('/dev/null', fmOpenRead);
end;

procedure TKqueueCrossSocket._OpenStopHandle;
var
  LEvent: TKEvent;
begin
  pipe(FStopHandle);

  EV_SET(@LEvent, FStopHandle.ReadDes, EVFILT_READ, EV_ADD, 0, 0, SHUTDOWN_FLAG);
  kevent(FKqueueHandle, @LEvent, 1, nil, 0, nil);
end;

procedure TKqueueCrossSocket._PostStopCommand;
var
  LStuff: UInt64;
begin
  LStuff := 1;
  Posix.UniStd.__write(FStopHandle.WriteDes, @LStuff, SizeOf(LStuff));
end;

procedure TKqueueCrossSocket._SetNoSigPipe(ASocket: THandle);
begin
  TSocketAPI.SetSockOpt<Integer>(ASocket, SOL_SOCKET, SO_NOSIGPIPE, 1);
end;

procedure TKqueueCrossSocket.StartLoop;
var
  LCrossSocket: ICrossSocket;
begin
  if (FIoThreads <> nil) then
    Exit;

  _OpenIdleHandle;

  FKqueueHandle := kqueue();
  LCrossSocket := Self;
  SetLength(FIoThreads, GetIoThreads);
  for var I := 0 to Length(FIoThreads) - 1 do
    FIoThreads[i] := TIoEventThread.Create(LCrossSocket);

  _OpenStopHandle;
end;

procedure TKqueueCrossSocket.StopLoop;
var
  LCurrentThreadID: TThreadID;
begin
  if (FIoThreads = nil) then
    Exit;

  CloseAll;

  while (ListensCount > 0) or (ConnectionsCount > 0) do
    Sleep(1);

  _PostStopCommand;

  LCurrentThreadID := GetCurrentThreadId;
  for var I := 0 to Length(FIoThreads) - 1 do
  begin
    if (FIoThreads[I].ThreadID = LCurrentThreadID) then
      raise ECrossSocket.Create('StopLoop Fail');

    FIoThreads[I].WaitFor;
    FreeAndNil(FIoThreads[I]);
  end;
  FIoThreads := nil;

  FileClose(FKqueueHandle);
  _CloseIdleHandle;
  _CloseStopHandle;
end;

procedure TKqueueCrossSocket.Connect(const AHost: string; const APort: Word; const ACallback: TCrossConnectionCallback);

  procedure _Failed1;
  begin
    if Assigned(ACallback) then
      ACallback(nil, False);
  end;

  function _Connect(const ASocket: THandle; const AAddr: PRawAddrInfo): Boolean;
  begin
    if (TSocketAPI.Connect(ASocket, AAddr.ai_addr, AAddr.ai_addrlen) = 0) or (GetLastError = EINPROGRESS) then
    begin
      var LConnection := CreateConnection(Self, ASocket, ctConnect);
      TriggerConnecting(LConnection);
      var LKqConnection := LConnection as TKqueueConnection;

      LKqConnection._Lock;
      try
        LKqConnection.ConnectStatus := csConnecting;
        LKqConnection.FConnectCallback := ACallback;
        if not LKqConnection._UpdateIoEvent([ieWrite]) then
        begin
          LConnection.Close;
          if Assigned(ACallback) then
            ACallback(LConnection, False);
          Exit(False);
        end;
      finally
        LKqConnection._Unlock;
      end;
    end
    else
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
      LSocket := TSocketAPI.NewSocket(LAddrInfo.ai_family, LAddrInfo.ai_socktype, LAddrInfo.ai_protocol);
      if (LSocket = INVALID_HANDLE_VALUE) then
      begin
        _Failed1;
        Exit;
      end;

      TSocketAPI.SetNonBlock(LSocket, True);
      SetKeepAlive(LSocket);
      _SetNoSigPipe(LSocket);

      if _Connect(LSocket, LAddrInfo) then Exit;

      LAddrInfo := PRawAddrInfo(LAddrInfo.ai_next);
    end;
  finally
    TSocketAPI.FreeAddrInfo(P);
  end;

  _Failed1;
end;

function TKqueueCrossSocket.CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection;
begin
  Result := TKqueueConnection.Create(AOwner, AClientSocket, AConnectType);
end;

function TKqueueCrossSocket.CreateListen(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer): ICrossListen;
begin
  Result := TKqueueListen.Create(AOwner, AListenSocket, AFamily, ASockType, AProtocol);
end;

procedure TKqueueCrossSocket.Listen(const AHost: string; const APort: Word; const ACallback: TCrossListenCallback);
var
  LHints: TRawAddrInfo;
  P, LAddrInfo: PRawAddrInfo;
  LListenSocket: THandle;
  LListen: ICrossListen;
  LKqListen: TKqueueListen;
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
      LListenSocket := TSocketAPI.NewSocket(LAddrInfo.ai_family, LAddrInfo.ai_socktype, LAddrInfo.ai_protocol);
      if (LListenSocket = INVALID_HANDLE_VALUE) then
      begin
        _Failed;
        Exit;
      end;

      TSocketAPI.SetNonBlock(LListenSocket, True);
      TSocketAPI.SetReUseAddr(LListenSocket, True);

      if (LAddrInfo.ai_family = AF_INET6) then
        TSocketAPI.SetSockOpt<Integer>(LListenSocket, IPPROTO_IPV6, IPV6_V6ONLY, 1);

      if (TSocketAPI.Bind(LListenSocket, LAddrInfo.ai_addr, LAddrInfo.ai_addrlen) < 0) or (TSocketAPI.Listen(LListenSocket) < 0) then
      begin
        _Failed;
        Exit;
      end;

      LListen := CreateListen(Self, LListenSocket, LAddrInfo.ai_family, LAddrInfo.ai_socktype, LAddrInfo.ai_protocol);
      LKqListen := LListen as TKqueueListen;

      LKqListen._Lock;
      try
        LSuccess := LKqListen._UpdateIoEvent([ieRead]);
      finally
        LKqListen._Unlock;
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

procedure TKqueueCrossSocket.Send(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback);
var
  LKqConnection: TKqueueConnection;
  LSendItem: PSendItem;
begin
  GetMem(LSendItem, SizeOf(TSendItem));
  FillChar(LSendItem^, SizeOf(TSendItem), 0);
  LSendItem.Data := ABuf;
  LSendItem.Size := ALen;
  LSendItem.Callback := ACallback;

  LKqConnection := AConnection as TKqueueConnection;

  LKqConnection._Lock;
  try
    LKqConnection.FSendQueue.Add(LSendItem);

    if not LKqConnection._WriteEnabled then
      LKqConnection._UpdateIoEvent([ieWrite]);
  finally
    LKqConnection._Unlock;
  end;
end;

function TKqueueCrossSocket.ProcessIoEvent: Boolean;
var
  LRet, I: Integer;
  LEvent: TKEvent;
  LCrossData: TCrossData;
  LListen: ICrossListen;
  LConnection: ICrossConnection;
begin
  LRet := kevent(FKqueueHandle, nil, 0, @FEventList[0], MAX_EVENT_COUNT, nil);
  if (LRet < 0) then
  begin
    LRet := GetLastError;
    Exit(LRet = EINTR);
  end;

  for I := 0 to LRet - 1 do
  begin
    LEvent := FEventList[I];

    if (LEvent.uData = SHUTDOWN_FLAG) then
      Exit(False);

    if (LEvent.uData = nil) then
      Continue;

    LCrossData := TCrossData(LEvent.uData);

    if (LCrossData is TKqueueListen) then
      LListen := LCrossData as ICrossListen
    else
      LListen := nil;

    if (LCrossData is TKqueueConnection) then
      LConnection := LCrossData as ICrossConnection
    else
      LConnection := nil;

    if (LListen <> nil) then
    begin
      if (LEvent.Filter = EVFILT_READ) then
        _HandleAccept(LListen);
    end
    else
    if (LConnection <> nil) then
    begin
      LConnection._Release;

      if (LEvent.Filter = EVFILT_READ) then
        _HandleRead(LConnection)
      else
      if (LEvent.Filter = EVFILT_WRITE) then
      begin
        if (LConnection.ConnectStatus = csConnecting) then
          _HandleConnect(LConnection)
        else
          _HandleWrite(LConnection);
      end;
    end;
  end;

  Result := True;
end;

{$ELSE}

implementation

{$IFEND}

end.
