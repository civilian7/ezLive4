{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit Net.CrossSocket.Iocp;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Net.Winsock2,
  Net.Wship6,
  Net.SocketAPI,
  Net.CrossSocket.Base;

type
  TIocpListen = class(TAbstractCrossListen)
  end;

  TIocpConnection = class(TAbstractCrossConnection)
  end;

  TIocpCrossSocket = class(TAbstractCrossSocket)
  private
    const
      SHUTDOWN_FLAG = ULONG_PTR(-1);
      SO_UPDATE_CONNECT_CONTEXT = $7010;
      IPV6_V6ONLY = 27;
      ERROR_ABANDONED_WAIT_0 = $02DF;
    type
      TAddrUnion = record
        case Integer of
          0: (IPv4: TSockAddrIn);
          1: (IPv6: TSockAddrIn6);
      end;

      TAddrBuffer = record
        Addr: TAddrUnion;
        Extra: array [0..15] of Byte;
      end;

      TAcceptExBuffer = array[0..SizeOf(TAddrBuffer) * 2 - 1] of Byte;

      TPerIoBufUnion = record
        case Integer of
          0: (DataBuf: WSABUF);
          1: (AcceptExBuffer: TAcceptExBuffer);
      end;

      TIocpAction = (ioAccept, ioConnect, ioRead, ioWrite);

      PPerIoData = ^TPerIoData;
      TPerIoData = record
        Overlapped: TWSAOverlapped;
        Buffer: TPerIoBufUnion;
        Action: TIocpAction;
        Socket: THandle;
        CrossData: ICrossData;
        Callback: TCrossConnectionCallback;
      end;
  private
    FIocpHandle: THandle;
    FIoThreads: TArray<TIoEventThread>;
    FPerIoDataCount: NativeInt;

    procedure _FreeIoData(const P: PPerIoData); inline;
    procedure _HandleAccept(const APerIoData: PPerIoData);
    procedure _HandleConnect(const APerIoData: PPerIoData);
    procedure _HandleRead(const APerIoData: PPerIoData);
    procedure _HandleWrite(const APerIoData: PPerIoData);
    procedure _NewAccept(const AListen: ICrossListen);
    function  _NewIoData: PPerIoData; inline;
    function  _NewReadZero(const AConnection: ICrossConnection): Boolean;
  protected
    procedure Connect(const AHost: string; const APort: Word; const ACallback: TCrossConnectionCallback = nil); override;
    function  CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection; override;
    function  CreateListen(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer): ICrossListen; override;
    procedure Listen(const AHost: string; const APort: Word; const ACallback: TCrossListenCallback = nil); override;
    function  ProcessIoEvent: Boolean; override;
    procedure Send(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback = nil); override;
    procedure StartLoop; override;
    procedure StopLoop; override;
  end;

implementation

{ TIocpCrossSocket }

procedure TIocpCrossSocket._FreeIoData(const P: PPerIoData);
begin
  if (P = nil) then
    Exit;

  P.CrossData := nil;
  P.Callback := nil;
  FreeMem(P, SizeOf(TPerIoData));

  AtomicDecrement(FPerIoDataCount);
end;

procedure TIocpCrossSocket._HandleAccept(const APerIoData: PPerIoData);
var
  LListen: ICrossListen;
  LConnection: ICrossConnection;
  LClientSocket, LListenSocket: THandle;
begin
  if (APerIoData.CrossData = nil) then
    Exit;

  LListen := APerIoData.CrossData as ICrossListen;

  _NewAccept(LListen);

  LClientSocket := APerIoData.Socket;
  LListenSocket := LListen.Socket;

  if (TSocketAPI.SetSockOpt<THandle>(LClientSocket, SOL_SOCKET, SO_UPDATE_ACCEPT_CONTEXT, LListenSocket) < 0) then
  begin
    {$IFDEF DEBUG}
    _LogLastOsError('TIocpCrossSocket._HandleAccept.SetSockOpt');
    {$ENDIF}
    TSocketAPI.CloseSocket(LClientSocket);
    Exit;
  end;

  if (CreateIoCompletionPort(LClientSocket, FIocpHandle, ULONG_PTR(LClientSocket), 0) = 0) then
  begin
    {$IFDEF DEBUG}
    _LogLastOsError('TIocpCrossSocket._HandleAccept.CreateIoCompletionPort');
    {$ENDIF}
    TSocketAPI.CloseSocket(LClientSocket);
    Exit;
  end;

  LConnection := CreateConnection(Self, LClientSocket, ctAccept);
  TriggerConnecting(LConnection);
  TriggerConnected(LConnection);

  if not _NewReadZero(LConnection) then
    LConnection.Close;
end;

procedure TIocpCrossSocket._HandleConnect(const APerIoData: PPerIoData);
var
  LClientSocket: THandle;
  LConnection: ICrossConnection;
  LSuccess: Boolean;

  procedure _Failed1;
  begin
    {$IFDEF DEBUG}
    _LogLastOsError('TIocpCrossSocket._HandleConnect');
    {$ENDIF}

    if Assigned(APerIoData.Callback) then
      APerIoData.Callback(nil, False);

    TSocketAPI.CloseSocket(LClientSocket);
  end;
begin
  LClientSocket := APerIoData.Socket;

  if (TSocketAPI.GetError(LClientSocket) <> 0) then
  begin
    _Failed1;
    Exit;
  end;

  if (TSocketAPI.SetSockOpt<Integer>(LClientSocket, SOL_SOCKET, SO_UPDATE_CONNECT_CONTEXT, 1) < 0) then
  begin
    _Failed1;
    Exit;
  end;

  LConnection := CreateConnection(Self, LClientSocket, ctConnect);
  TriggerConnecting(LConnection);
  TriggerConnected(LConnection);

  LSuccess := _NewReadZero(LConnection);

  if Assigned(APerIoData.Callback) then
    APerIoData.Callback(LConnection, LSuccess);

  if not LSuccess then
    LConnection.Close;
end;

procedure TIocpCrossSocket._HandleRead(const APerIoData: PPerIoData);
var
  LConnection: ICrossConnection;
  LRcvd, LError: Integer;
begin
  if (APerIoData.CrossData = nil) then
  begin
    if Assigned(APerIoData.Callback) then
      APerIoData.Callback(nil, False);
    Exit;
  end;

  LConnection := APerIoData.CrossData as ICrossConnection;

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

      if (LError = WSAEINTR) then
        Continue
      else
      if (LError = WSAEWOULDBLOCK) or (LError = WSAEINPROGRESS) then
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

  if not _NewReadZero(LConnection) then
    LConnection.Close;
end;

procedure TIocpCrossSocket._HandleWrite(const APerIoData: PPerIoData);
begin
  if Assigned(APerIoData.Callback) then
    APerIoData.Callback(APerIoData.CrossData as ICrossConnection, True);
end;

function TIocpCrossSocket._NewIoData: PPerIoData;
begin
  GetMem(Result, SizeOf(TPerIoData));
  FillChar(Result^, SizeOf(TPerIoData), 0);

  AtomicIncrement(FPerIoDataCount);
end;

procedure TIocpCrossSocket._NewAccept(const AListen: ICrossListen);
var
  LClientSocket: THandle;
  LPerIoData: PPerIoData;
  LBytes: Cardinal;
begin
  LClientSocket := WSASocket(AListen.Family, AListen.SockType, AListen.Protocol, nil, 0, WSA_FLAG_OVERLAPPED);
  if (LClientSocket = INVALID_SOCKET) then
  begin
    {$IFDEF DEBUG}
    _LogLastOsError('TIocpCrossSocket._NewAccept.WSASocket');
    {$ENDIF}
    Exit;
  end;

  TSocketAPI.SetNonBlock(LClientSocket, True);
  SetKeepAlive(LClientSocket);

  LPerIoData := _NewIoData;
  LPerIoData.Action := ioAccept;
  LPerIoData.Socket := LClientSocket;
  LPerIoData.CrossData := AListen;

  if (not AcceptEx(AListen.Socket, LClientSocket, @LPerIoData.Buffer.AcceptExBuffer, 0, SizeOf(TAddrBuffer), SizeOf(TAddrBuffer), LBytes, POverlapped(LPerIoData))) and (WSAGetLastError <> WSA_IO_PENDING) then
  begin
    {$IFDEF DEBUG}
    _LogLastOsError('TIocpCrossSocket._NewAccept.AcceptEx');
    {$ENDIF}
    TSocketAPI.CloseSocket(LClientSocket);
    _FreeIoData(LPerIoData);
  end;
end;

function TIocpCrossSocket._NewReadZero(const AConnection: ICrossConnection): Boolean;
var
  LPerIoData: PPerIoData;
  LBytes, LFlags: Cardinal;
begin
  LPerIoData := _NewIoData;
  LPerIoData.Buffer.DataBuf.buf := nil;
  LPerIoData.Buffer.DataBuf.len := 0;
  LPerIoData.Action := ioRead;
  LPerIoData.Socket := AConnection.Socket;
  LPerIoData.CrossData := AConnection;

  LFlags := 0;
  LBytes := 0;
  if (WSARecv(AConnection.Socket, @LPerIoData.Buffer.DataBuf, 1, LBytes, LFlags, PWSAOverlapped(LPerIoData), nil) < 0)
    and (WSAGetLastError <> WSA_IO_PENDING) then
  begin
    {$IFDEF DEBUG}
    _LogLastOsError('TIocpCrossSocket._NewReadZero.WSARecv');
    {$ENDIF}
    _FreeIoData(LPerIoData);
    Exit(False);
  end;

  Result := True;
end;

procedure TIocpCrossSocket.Connect(const AHost: string; const APort: Word; const ACallback: TCrossConnectionCallback);
var
  LHints: TRawAddrInfo;
  P, LAddrInfo: PRawAddrInfo;
  LSocket: THandle;

  procedure _Failed1;
  begin
    if Assigned(ACallback) then
      ACallback(nil, False);
  end;

  function _Connect(ASocket: THandle; AAddr: PRawAddrInfo): Boolean;
    procedure _Failed2;
    begin
      if Assigned(ACallback) then
        ACallback(nil, False);
      TSocketAPI.CloseSocket(ASocket);
    end;
  var
    LSockAddr: TRawSockAddrIn;
    LPerIoData: PPerIoData;
    LBytes: Cardinal;
  begin
    LSockAddr.AddrLen := AAddr.ai_addrlen;
    Move(AAddr.ai_addr^, LSockAddr.Addr, AAddr.ai_addrlen);
    if (AAddr.ai_family = AF_INET6) then
    begin
      LSockAddr.Addr6.sin6_addr := in6addr_any;
      LSockAddr.Addr6.sin6_port := 0;
    end
    else
    begin
      LSockAddr.Addr.sin_addr.S_addr := INADDR_ANY;
      LSockAddr.Addr.sin_port := 0;
    end;

    if (TSocketAPI.Bind(ASocket, @LSockAddr.Addr, LSockAddr.AddrLen) < 0) then
    begin
      _Failed2;
      Exit(False);
    end;

    if (CreateIoCompletionPort(ASocket, FIocpHandle, ULONG_PTR(ASocket), 0) = 0) then
    begin
      _Failed2;
      Exit(False);
    end;

    LPerIoData := _NewIoData;
    LPerIoData.Action := ioConnect;
    LPerIoData.Socket := ASocket;
    LPerIoData.Callback := ACallback;
    if not ConnectEx(ASocket, AAddr.ai_addr, AAddr.ai_addrlen, nil, 0, LBytes, PWSAOverlapped(LPerIoData)) and (WSAGetLastError <> WSA_IO_PENDING) then
    begin
      _FreeIoData(LPerIoData);
      _Failed2;
      Exit(False);
    end;

    Result := True;
  end;

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
      LSocket := WSASocket(LAddrInfo.ai_family, LAddrInfo.ai_socktype, LAddrInfo.ai_protocol, nil, 0, WSA_FLAG_OVERLAPPED);
      if (LSocket = INVALID_SOCKET) then
      begin
        _Failed1;
        Exit;
      end;

      TSocketAPI.SetNonBlock(LSocket, True);
      SetKeepAlive(LSocket);

      if _Connect(LSocket, LAddrInfo) then
        Exit;

      LAddrInfo := PRawAddrInfo(LAddrInfo.ai_next);
    end;
  finally
    TSocketAPI.FreeAddrInfo(P);
  end;

  _Failed1;
end;

function TIocpCrossSocket.CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection;
begin
  Result := TIocpConnection.Create(AOwner, AClientSocket, AConnectType);
end;

function TIocpCrossSocket.CreateListen(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer): ICrossListen;
begin
  Result := TIocpListen.Create(AOwner, AListenSocket, AFamily, ASockType, AProtocol);
end;

procedure TIocpCrossSocket.Listen(const AHost: string; const APort: Word; const ACallback: TCrossListenCallback);
var
  LHints: TRawAddrInfo;
  P, LAddrInfo: PRawAddrInfo;
  LListenSocket: THandle;
  LListen: ICrossListen;
  I: Integer;

  procedure _Failed;
  begin
    if Assigned(ACallback) then
      ACallback(LListen, False);

    if (LListen <> nil) then
      LListen.Close;
  end;

  procedure _Success;
  begin
    TriggerListened(LListen);

    if Assigned(ACallback) then
      ACallback(LListen, True);
  end;
begin
  LListen := nil;
  FillChar(LHints, SizeOf(TRawAddrInfo), 0);

  LHints.ai_flags := AI_PASSIVE;
  LHints.ai_family := AF_UNSPEC;
  LHints.ai_socktype := SOCK_STREAM;
  LHints.ai_protocol := IPPROTO_TCP;
  LAddrInfo := TSocketAPI.GetAddrInfo(AHost, APort, LHints);
  if (LAddrInfo = nil) then
  begin
    {$IFDEF DEBUG}
    _LogLastOsError('TIocpCrossSocket.Listen.GetAddrInfo');
    {$ENDIF}
    _Failed;
    Exit;
  end;

  P := LAddrInfo;
  try
    while (LAddrInfo <> nil) do
    begin
      LListenSocket := WSASocket(LAddrInfo.ai_family, LAddrInfo.ai_socktype, LAddrInfo.ai_protocol, nil, 0, WSA_FLAG_OVERLAPPED);
      if (LListenSocket = INVALID_SOCKET) then
      begin
        {$IFDEF DEBUG}
        _LogLastOsError('TIocpCrossSocket.Listen.WSASocket');
        {$ENDIF}
        _Failed;
        Exit;
      end;

      TSocketAPI.SetNonBlock(LListenSocket, True);
      TSocketAPI.SetReUseAddr(LListenSocket, True);

      if (LAddrInfo.ai_family = AF_INET6) then
        TSocketAPI.SetSockOpt<Integer>(LListenSocket, IPPROTO_IPV6, IPV6_V6ONLY, 1);

      if (TSocketAPI.Bind(LListenSocket, LAddrInfo.ai_addr, LAddrInfo.ai_addrlen) < 0) or (TSocketAPI.Listen(LListenSocket) < 0) then
      begin
        {$IFDEF DEBUG}
        _LogLastOsError('TIocpCrossSocket.Listen.Bind');
        {$ENDIF}
        _Failed;
        Exit;
      end;

      LListen := CreateListen(Self, LListenSocket, LAddrInfo.ai_family,
        LAddrInfo.ai_socktype, LAddrInfo.ai_protocol);

      if (CreateIoCompletionPort(LListenSocket, FIocpHandle, ULONG_PTR(LListenSocket), 0) = 0) then
      begin
        {$IFDEF DEBUG}
        _LogLastOsError('TIocpCrossSocket.Listen.CreateIoCompletionPort');
        {$ENDIF}
        _Failed;
        Exit;
      end;

      for I := 1 to GetIoThreads do
        _NewAccept(LListen);

      _Success;

      if (APort = 0) and (LAddrInfo.ai_next <> nil) then
        LAddrInfo.ai_next.ai_addr.sin_port := LListen.LocalPort;

      LAddrInfo := PRawAddrInfo(LAddrInfo.ai_next);
    end;
  finally
    TSocketAPI.FreeAddrInfo(P);
  end;
end;

function TIocpCrossSocket.ProcessIoEvent: Boolean;
var
  LBytes: Cardinal;
  LSocket: THandle;
  LPerIoData: PPerIoData;
  LConnection: ICrossConnection;
  {$IFDEF DEBUG}
  LErrNo: Cardinal;
  {$ENDIF}
begin
  if not GetQueuedCompletionStatus(FIocpHandle, LBytes, ULONG_PTR(LSocket), POverlapped(LPerIoData), INFINITE) then
  begin
    {$IFDEF DEBUG}
    LErrNo := GetLastError;
    if (LErrNo <> ERROR_INVALID_HANDLE) and (LErrNo <> ERROR_ABANDONED_WAIT_0) then
      _LogLastOsError('TIocpCrossSocket.ProcessIoEvent.GetQueuedCompletionStatus');
    {$ENDIF}

    if (LPerIoData = nil) then
      Exit(False);

    try
      if (LPerIoData.CrossData <> nil) then
      begin
        if (LPerIoData.Action = ioAccept) then
        begin
          if (LPerIoData.Socket <> 0) then
            TSocketAPI.CloseSocket(LPerIoData.Socket);

          if (GetLastError <> WSA_OPERATION_ABORTED) then
            _NewAccept(LPerIoData.CrossData as ICrossListen);
        end
        else
        begin
          if Assigned(LPerIoData.Callback) then
          begin
            if (LPerIoData.CrossData is TIocpConnection) then
              LConnection := LPerIoData.CrossData as ICrossConnection
            else
              LConnection := nil;

            LPerIoData.Callback(LConnection, False);
          end;

          LPerIoData.CrossData.Close;
        end;
      end
      else
      begin
        if Assigned(LPerIoData.Callback) then
          LPerIoData.Callback(nil, False);

        if (LPerIoData.Socket <> 0) then
          TSocketAPI.CloseSocket(LPerIoData.Socket);
      end;
    finally
      _FreeIoData(LPerIoData);
    end;

    Exit(True);
  end;

  if (LBytes = 0) and (ULONG_PTR(LPerIoData) = SHUTDOWN_FLAG) then
    Exit(False);

  if (LPerIoData = nil) then
    Exit(True);

  try
    case LPerIoData.Action of
      ioAccept:
        _HandleAccept(LPerIoData);
      ioConnect:
        _HandleConnect(LPerIoData);
      ioRead:
        _HandleRead(LPerIoData);
      ioWrite:
        _HandleWrite(LPerIoData);
    end;
  finally
    _FreeIoData(LPerIoData);
  end;

  Result := True;
end;

procedure TIocpCrossSocket.Send(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback);
var
  LPerIoData: PPerIoData;
  LBytes, LFlags: Cardinal;
begin
  LPerIoData := _NewIoData;
  LPerIoData.Buffer.DataBuf.buf := ABuf;
  LPerIoData.Buffer.DataBuf.len := ALen;
  LPerIoData.Action := ioWrite;
  LPerIoData.Socket := AConnection.Socket;
  LPerIoData.CrossData := AConnection;
  LPerIoData.Callback := ACallback;

  LFlags := 0;
  LBytes := 0;
  if (WSASend(AConnection.Socket, @LPerIoData.Buffer.DataBuf, 1, LBytes, LFlags, PWSAOverlapped(LPerIoData), nil) < 0) and (WSAGetLastError <> WSA_IO_PENDING) then
  begin
    _FreeIoData(LPerIoData);

    if Assigned(ACallback) then
      ACallback(AConnection, False);

    AConnection.Close;
  end;
end;

procedure TIocpCrossSocket.StartLoop;
var
  LCrossSocket: ICrossSocket;
begin
  if (FIoThreads <> nil) then
    Exit;

  FIocpHandle := CreateIoCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 0);
  LCrossSocket := Self;
  SetLength(FIoThreads, GetIoThreads);
  for var I := 0 to Length(FIoThreads) - 1 do
    FIoThreads[I] := TIoEventThread.Create(LCrossSocket);
end;

procedure TIocpCrossSocket.StopLoop;

  procedure _FreeMissingPerIoDatas;
  var
    LBytes: Cardinal;
    LSocket: THandle;
    LPerIoData: PPerIoData;
    LConnection: ICrossConnection;
  begin
    while (AtomicCmpExchange(FPerIoDataCount, 0, 0) > 0) do
    begin
      GetQueuedCompletionStatus(FIocpHandle, LBytes, ULONG_PTR(LSocket), POverlapped(LPerIoData), 10);

      if (LPerIoData <> nil) then
      begin
        if Assigned(LPerIoData.Callback) then
        begin
          if (LPerIoData.CrossData <> nil)
            and (LPerIoData.CrossData is TIocpConnection) then
            LConnection := LPerIoData.CrossData as ICrossConnection
          else
            LConnection := nil;

          LPerIoData.Callback(LConnection, False);
        end;

        if (LPerIoData.CrossData <> nil) then
          LPerIoData.CrossData.Close
        else
          TSocketAPI.CloseSocket(LPerIoData.Socket);

        _FreeIoData(LPerIoData);
      end;
    end;
  end;

var
  I: Integer;
  LCurrentThreadID: TThreadID;
begin
  if (FIoThreads = nil) then
    Exit;

  CloseAll;

  while (ListensCount > 0) or (ConnectionsCount > 0) do Sleep(1);

  for I := 0 to Length(FIoThreads) - 1 do
    PostQueuedCompletionStatus(FIocpHandle, 0, 0, POverlapped(SHUTDOWN_FLAG));

  LCurrentThreadID := GetCurrentThreadId;
  for I := 0 to Length(FIoThreads) - 1 do
  begin
    if (FIoThreads[I].ThreadID = LCurrentThreadID) then
      raise ECrossSocket.Create('IOCP StopLoop!');

    FIoThreads[I].WaitFor;
    FreeAndNil(FIoThreads[I]);
  end;
  FIoThreads := nil;

  _FreeMissingPerIoDatas;
  CloseHandle(FIocpHandle);
end;

end.
