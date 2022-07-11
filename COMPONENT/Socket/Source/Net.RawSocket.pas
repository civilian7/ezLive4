unit Net.RawSocket;

interface

uses
  System.SysUtils,
  Net.SocketAPI,
  {$IFDEF POSIX}
  Posix.Base,
  Posix.SysSocket,
  Posix.NetinetIn
  {$ELSE}
  Winapi.Windows,
  Net.Winsock2,
  Net.Wship6
  {$ENDIF};

type
  TRawSocket = class
  private
    FSocket: THandle;
    FSockAddr: TRawSockAddrIn;
    FPeerAddr: string;
    FPeerPort: Word;
  public
    function  Accept(Addr: PSockAddr; AddrLen: PInteger): THandle;
    function  Bind(const Addr: string; APort: Word): Integer;
    procedure Close;
    function  Connect(const AHost: string; APort: Word): Integer;
    function  IsValid: Boolean;
    function  Listen(backlog: Integer = SOMAXCONN): Integer;
    function  Recv(var Buf; len: Integer; flags: Integer = 0): Integer;
    function  RecvFrom(const Addr: PSockAddr; var AddrLen: Integer; var Buf; len: Integer; flags: Integer = 0): Integer;
    function  Send(const Buf; len: Integer; flags: Integer = 0): Integer;
    function  SendTo(const Addr: PSockAddr; AddrLen: Integer; const Buf; len: Integer; flags: Integer = 0): Integer;

    property PeerAddr: string read FPeerAddr;
    property PeerPort: Word read FPeerPort;
    property SockAddr: TRawSockAddrIn read FSockAddr;
    property Socket: THandle read FSocket;
  end;

implementation

{ TRawSocket }

function TRawSocket.Accept(Addr: PSockAddr; AddrLen: PInteger): THandle;
begin
  Result := TSocketAPI.Accept(FSocket, Addr, AddrLen);
end;

function TRawSocket.Bind(const Addr: string; APort: Word): Integer;
var
  LHints: TRawAddrInfo;
  LAddrInfo: PRawAddrInfo;
begin
  FillChar(LHints, SizeOf(TRawAddrInfo), 0);
  LHints.ai_family := AF_UNSPEC;
  LHints.ai_socktype := SOCK_STREAM;
  LHints.ai_protocol := IPPROTO_TCP;

  LAddrInfo := TSocketAPI.GetAddrInfo(Addr, APort.ToString, LHints);
  if (LAddrInfo = nil) then
    Exit(-1);

  FSockAddr.AddrLen := LAddrInfo.ai_addrlen;
  Move(LAddrInfo.ai_addr^, FSockAddr.Addr, LAddrInfo.ai_addrlen);
  TSocketAPI.FreeAddrInfo(LAddrInfo);

  TSocketAPI.ExtractAddrInfo(@FSockAddr.Addr, FSockAddr.AddrLen, FPeerAddr, FPeerPort);

  Result := TSocketAPI.Bind(FSocket, @FSockAddr.Addr, FSockAddr.AddrLen);
end;

procedure TRawSocket.Close;
begin
  if (FSocket = INVALID_HANDLE_VALUE) then
    Exit;

  TSocketAPI.CloseSocket(FSocket);
  FSocket := INVALID_HANDLE_VALUE;
end;

function TRawSocket.Connect(const AHost: string; APort: Word): Integer;
var
  LHints: TRawAddrInfo;
  LAddrInfo: PRawAddrInfo;
begin
  FillChar(LHints, SizeOf(TRawAddrInfo), 0);

  LHints.ai_family := AF_UNSPEC;
  LHints.ai_socktype := SOCK_STREAM;
  LHints.ai_protocol := IPPROTO_TCP;
  LAddrInfo := TSocketAPI.GetAddrInfo(AHost, APort.ToString, LHints);

  if (LAddrInfo = nil) then
    Exit(-1);

  try
    FSocket := TSocketAPI.NewSocket(LAddrInfo.ai_family, LAddrInfo.ai_socktype, LAddrInfo.ai_protocol);
    if (FSocket = INVALID_HANDLE_VALUE) then
      Exit(-1);

    FSockAddr.AddrLen := LAddrInfo.ai_addrlen;
    Move(LAddrInfo.ai_addr^, FSockAddr.Addr, LAddrInfo.ai_addrlen);
    TSocketAPI.ExtractAddrInfo(@FSockAddr.Addr, FSockAddr.AddrLen, FPeerAddr, FPeerPort);

    TSocketAPI.SetKeepAlive(FSocket, 5, 3, 5);
    Result := TSocketAPI.Connect(FSocket, @FSockAddr.Addr, FSockAddr.AddrLen);
  finally
    TSocketAPI.FreeAddrInfo(LAddrInfo);
  end;
end;

function TRawSocket.IsValid: Boolean;
begin
  Result := TSocketAPI.IsValidSocket(FSocket);
end;

function TRawSocket.Listen(backlog: Integer): Integer;
begin
  Result := TSocketAPI.Listen(FSocket, backlog);
end;

function TRawSocket.Recv(var Buf; len, flags: Integer): Integer;
begin
  Result := TSocketAPI.Recv(FSocket, Buf, len, flags);
end;

function TRawSocket.RecvFrom(const Addr: PSockAddr; var AddrLen: Integer; var Buf; len, flags: Integer): Integer;
begin
  Result := TSocketAPI.RecvFrom(FSocket, Addr, AddrLen, Buf, len, flags);
end;

function TRawSocket.Send(const Buf; len, flags: Integer): Integer;
begin
  Result := TSocketAPI.Send(FSocket, Buf, len, flags);
end;

function TRawSocket.SendTo(const Addr: PSockAddr; AddrLen: Integer; const Buf; len: Integer; flags: Integer): Integer;
begin
  Result := TSocketAPI.SendTo(FSocket, Addr, AddrLen, Buf, len, flags);
end;

end.
