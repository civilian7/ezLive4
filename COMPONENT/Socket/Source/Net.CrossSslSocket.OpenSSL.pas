{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit Net.CrossSslSocket.OpenSSL;

interface

uses
  System.SysUtils,
  System.Classes,
  Net.CrossSocket.Base,
  Net.CrossSocket,
  Net.CrossSslSocket.Base,
  Net.OpenSSL;

type
  TCrossOpenSslConnection = class(TCrossConnection)
  private
    FSsl: PSSL;
    FBIOIn: PBIO;
    FBIOOut: PBIO;
    FSslLock: TObject;

    function  _SslHandshake: Boolean;
    procedure _SslLock; inline;
    procedure _SslUnlock; inline;
    procedure _WriteBioToSocket(const ACallback: TCrossConnectionCallback = nil);
  protected
    procedure DirectSend(const ABuffer: Pointer; const ACount: Integer; const ACallback: TCrossConnectionCallback = nil); override;
  public
    constructor Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType); override;
    destructor Destroy; override;
  end;

  TCrossOpenSslSocket = class(TCrossSocket, ICrossSslSocket)
  private
    const
      SSL_BUF_SIZE = 32768;
    class threadvar
      FSslInBuf: array [0..SSL_BUF_SIZE-1] of Byte;
  private
    FSslCtx: PSSL_CTX;

    procedure _FreeSslCtx;
    procedure _InitSslCtx;
  protected
    function  CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection; override;
    procedure TriggerConnected(const AConnection: ICrossConnection); override;
    procedure TriggerReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer); override;
  public
    constructor Create(const AIoThreads: Integer); override;
    destructor Destroy; override;

    procedure SetCertificate(const ACertBuf: Pointer; const ACertBufSize: Integer); overload;
    procedure SetCertificate(const ACertStr: string); overload;
    procedure SetCertificateFile(const ACertFile: string);
    procedure SetPrivateKey(const APKeyBuf: Pointer; const APKeyBufSize: Integer); overload;
    procedure SetPrivateKey(const APKeyStr: string); overload;
    procedure SetPrivateKeyFile(const APKeyFile: string);
  end;

implementation

{ TCrossOpenSslConnection }

constructor TCrossOpenSslConnection.Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType);
begin
  inherited;

  FSslLock := TObject.Create;

  FSsl := SSL_new(TCrossOpenSslSocket(Owner).FSslCtx);
  FBIOIn := BIO_new(BIO_s_mem());
  FBIOOut := BIO_new(BIO_s_mem());
  SSL_set_bio(FSsl, FBIOIn, FBIOOut);

  if (ConnectType = ctAccept) then
    SSL_set_accept_state(FSsl)
  else
    SSL_set_connect_state(FSsl);
end;

destructor TCrossOpenSslConnection.Destroy;
begin
  _SslLock;
  try
    if (SSL_shutdown(FSsl) = 0) then
      SSL_shutdown(FSsl);
    SSL_free(FSsl);
  finally
    _SslUnlock;
  end;
  FreeAndNil(FSslLock);

  inherited;
end;

procedure TCrossOpenSslConnection._WriteBioToSocket(const ACallback: TCrossConnectionCallback);
var
  LConnection: ICrossConnection;
  ret, error: Integer;
  LBuffer: TBytesStream;

  procedure _Success;
  begin
    if (LBuffer <> nil) then
      FreeAndNil(LBuffer);
    if Assigned(ACallback) then
      ACallback(LConnection, True);
  end;

  procedure _Failed;
  begin
    if (LBuffer <> nil) then
      FreeAndNil(LBuffer);

    LConnection.Close;
    if Assigned(ACallback) then
      ACallback(LConnection, False);
  end;

begin
  LConnection := Self;
  LBuffer := nil;

  ret := BIO_pending(FBIOOut);
  if (ret <= 0) then
  begin
    _Success;
    Exit;
  end;

  LBuffer := TBytesStream.Create(nil);
  while (ret > 0) do
  begin
    LBuffer.Size := LBuffer.Size + ret;

    ret := BIO_read(FBIOOut, PByte(LBuffer.Memory) + LBuffer.Position, ret);
    error := SSL_get_error(FSsl, ret);
    if ssl_is_fatal_error(error) then
    begin
      _Failed;
      Exit;
    end;

    if (ret <= 0) then
      Break;

    LBuffer.Position := LBuffer.Position + ret;

    ret := BIO_pending(FBIOOut);
  end;

  if (LBuffer.Memory = nil) or (LBuffer.Size <= 0) then
  begin
    _Success;
    Exit;
  end;

  inherited DirectSend(LBuffer.Memory, LBuffer.Size,
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      FreeAndNil(LBuffer);
      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossOpenSslConnection.DirectSend(const ABuffer: Pointer; const ACount: Integer; const ACallback: TCrossConnectionCallback);
var
  LConnection: ICrossConnection;
  ret, error: Integer;

  procedure _Failed;
  begin
    if Assigned(ACallback) then
      ACallback(LConnection, False);
  end;

begin
  LConnection := Self;

  _SslLock;
  try
    ret := SSL_write(FSsl, ABuffer, ACount);
    if (ret > 0) then
      _WriteBioToSocket(ACallback)
    else
    begin
      error := SSL_get_error(FSsl, ret);
      _Log('SSL_write error %d %s', [error, ssl_error_message(error)]);

      case error of
        SSL_ERROR_WANT_READ:;
        SSL_ERROR_WANT_WRITE: _WriteBioToSocket;
      else
        _Failed;
      end;
    end;
  finally
    _SslUnlock;
  end;
end;

procedure TCrossOpenSslConnection._SslLock;
begin
  TMonitor.Enter(FSslLock);
end;

procedure TCrossOpenSslConnection._SslUnlock;
begin
  TMonitor.Exit(FSslLock);
end;

function TCrossOpenSslConnection._SslHandshake: Boolean;
var
  ret, error: Integer;
begin
  Result := False;

  _SslLock;
  try
    ret := SSL_do_handshake(FSsl);
    if (ret = 1) then
    begin
      _WriteBioToSocket;
      Exit(True);
    end;

    error := SSL_get_error(FSsl, ret);
    if ssl_is_fatal_error(error) then
    begin
      {$IFDEF DEBUG}
      _Log('SSL_do_handshake error %s', [ssl_error_message(error)]);
      {$ENDIF}
      Close;
    end else
      _WriteBioToSocket;
  finally
    _SslUnlock;
  end;
end;

{ TCrossOpenSslSocket }

constructor TCrossOpenSslSocket.Create(const AIoThreads: Integer);
begin
  inherited;

  TSSLTools.LoadSSL;
  _InitSslCtx;
end;

destructor TCrossOpenSslSocket.Destroy;
begin
  inherited;

  _FreeSslCtx;
  TSSLTools.UnloadSSL;
end;

function TCrossOpenSslSocket.CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection;
begin
  Result := TCrossOpenSslConnection.Create(AOwner, AClientSocket, AConnectType);
end;

procedure TCrossOpenSslSocket._InitSslCtx;
var
  LEcdh: PEC_KEY;
begin
  if (FSslCtx <> nil) then
    Exit;

  FSslCtx := TSSLTools.NewCTX(SSLv23_method());

  SSL_CTX_set_verify(FSslCtx, SSL_VERIFY_NONE, nil);
  SSL_CTX_set_mode(FSslCtx, SSL_MODE_AUTO_RETRY);
  SSL_CTX_set_options(FSslCtx,
    SSL_OP_NO_SSLv2 or SSL_OP_NO_SSLv3 or
    SSL_OP_ALL or
    SSL_OP_SINGLE_ECDH_USE or
    SSL_OP_CIPHER_SERVER_PREFERENCE
  );

  SSL_CTX_set_cipher_list(FSslCtx,
    'ECDHE-ECDSA-AES128-GCM-SHA256:' +
    'ECDHE-RSA-AES128-GCM-SHA256:' +
    'ECDHE-RSA-AES256-GCM-SHA384:' +
    'ECDHE-ECDSA-AES256-GCM-SHA384:' +
    'DHE-RSA-AES128-GCM-SHA256:' +
    'ECDHE-RSA-AES128-SHA256:' +
    'DHE-RSA-AES128-SHA256:' +
    'ECDHE-RSA-AES256-SHA384:' +
    'DHE-RSA-AES256-SHA384:' +
    'ECDHE-RSA-AES256-SHA256:' +
    'DHE-RSA-AES256-SHA256:' +
    'HIGH:' +
    '!aNULL:' +
    '!eNULL:' +
    '!EXPORT:' +
    '!DES:' +
    '!RC4:' +
    '!MD5:' +
    '!PSK:' +
    '!SRP:' +
    '!CAMELLIA'
  );

  LEcdh := EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);
  if (LEcdh <> nil) then
  begin
    SSL_CTX_set_tmp_ecdh(FSslCtx, LEcdh);
    EC_KEY_free(LEcdh);
  end;
end;

procedure TCrossOpenSslSocket._FreeSslCtx;
begin
  if (FSslCtx = nil) then
    Exit;

  TSSLTools.FreeCTX(FSslCtx);
end;

procedure TCrossOpenSslSocket.SetCertificate(const ACertBuf: Pointer; const ACertBufSize: Integer);
begin
  TSSLTools.SetCertificate(FSslCtx, ACertBuf, ACertBufSize);
end;

procedure TCrossOpenSslSocket.SetCertificate(const ACertStr: string);
begin
  TSSLTools.SetCertificate(FSslCtx, ACertStr);
end;

procedure TCrossOpenSslSocket.SetCertificateFile(const ACertFile: string);
begin
  TSSLTools.SetCertificateFile(FSslCtx, ACertFile);
end;

procedure TCrossOpenSslSocket.SetPrivateKey(const APKeyBuf: Pointer; const APKeyBufSize: Integer);
begin
  TSSLTools.SetPrivateKey(FSslCtx, APKeyBuf, APKeyBufSize);
end;

procedure TCrossOpenSslSocket.SetPrivateKey(const APKeyStr: string);
begin
  TSSLTools.SetPrivateKey(FSslCtx, APKeyStr);
end;

procedure TCrossOpenSslSocket.SetPrivateKeyFile(const APKeyFile: string);
begin
  TSSLTools.SetPrivateKeyFile(FSslCtx, APKeyFile);
end;

procedure TCrossOpenSslSocket.TriggerConnected(const AConnection: ICrossConnection);
var
  LConnection: TCrossOpenSslConnection;
begin
  LConnection := AConnection as TCrossOpenSslConnection;

  LConnection._SslLock;
  try
    LConnection.ConnectStatus := csHandshaking;

    if LConnection._SslHandshake then
    begin
      LConnection.ConnectStatus := csConnected;
      inherited TriggerConnected(AConnection);
    end;
  finally
    LConnection._SslUnlock;
  end;
end;

procedure TCrossOpenSslSocket.TriggerReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer);
var
  LConnection: TCrossOpenSslConnection;
  ret, error: Integer;
  LBuffer: TBytesStream;
begin
  LConnection := AConnection as TCrossOpenSslConnection;
  LConnection._SslLock;
  try
    while True do
    begin
      ret := BIO_write(LConnection.FBIOIn, ABuf, ALen);
      if (ret > 0) then
        Break;

      if not BIO_should_retry(LConnection.FBIOIn) then
      begin
        LConnection.Close;
        Exit;
      end;
    end;

    if not SSL_is_init_finished(LConnection.FSsl) then
    begin
      if LConnection._SslHandshake and (LConnection.ConnectStatus = csHandshaking) then
      begin
        LConnection.ConnectStatus := csConnected;
        inherited TriggerConnected(AConnection);
      end;
      Exit;
    end;

    LBuffer := TBytesStream.Create(nil);
    try
      while True do
      begin
        ret := SSL_read(LConnection.FSsl, @FSslInBuf[0], SSL_BUF_SIZE);
        if (ret > 0) then
          LBuffer.Write(FSslInBuf[0], ret)
        else
        begin
          error := SSL_get_error(LConnection.FSsl, ret);

          if ssl_is_fatal_error(error) then
          begin
            {$IFDEF DEBUG}
            _Log('SSL_read error %d %s', [error, ssl_error_message(error)]);
            {$ENDIF}
            LConnection.Close;
          end;
          Break;
        end;
      end;

      if (LBuffer.Size > 0) then
        inherited TriggerReceived(AConnection, LBuffer.Memory, LBuffer.Size);
    finally
      FreeAndNil(LBuffer);
    end;
  finally
    LConnection._SslUnlock;
  end;
end;

end.
