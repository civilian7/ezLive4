unit Net.PacketServer;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.SyncObjs,
  Net.CrossSocket.Base,
  Net.CrossSocket,
  Net.PacketSocket;

type
  TPacketStream = class(TBytesStream)

  end;

  IPacketServerConnection = interface(IPacketConnection)
    ['{6E986D44-7CC7-4B40-BCC0-A90A357613F9}']
  end;

  TPacketServerConnection = class(TPacketConnection, IPacketServerConnection)
  private
    FAuthorized: Boolean;
    FCreated: TDateTime;
    FLastAccess: TDateTime;
    FUserID: string;

    function  GetAuthorized: Boolean;
    function  GetCreated: TDateTime;
    function  GetLastAccess: TDateTime;
    function  GetUserID: string;
    procedure SetAuthorized(const Value: Boolean);
    procedure SetLastAccess(const Value: TDateTime);
    procedure SetUserID(const Value: string);
  public
    constructor Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType); override;
    destructor Destroy; override;

    property Authorized: Boolean read GetAuthorized write SetAuthorized;
    property Created: TDateTime read GetCreated;
    property LastAccess: TDateTime read GetLastAccess write SetLastAccess;
    property UserID: string read GetUserID write SetUserID;
  end;

  IServerPacket = interface;
  TPacketCommand = WORD;
  TPacketProc = reference to procedure(const APacket: IServerPacket);

  IPacketRouter = interface
    ['{68137621-D067-462E-9E3E-52CDCDC6F1FC}']
    procedure Add(const ACommand: TPacketCommand; AProc: TPacketProc);
    procedure Clear;
    procedure Execute(const APacket: IServerPacket);
    procedure Remove(const ACommand: TPacketCommand);
  end;

  TPacketRouter = class(TInterfacedObject, IPacketRouter)
  private
    FItems: TDictionary<TPacketCommand, TPacketProc>;

    function  Find(const ACommand: TPacketCommand; out AProc: TPacketProc): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(const ACommand: TPacketCommand; AProc: TPacketProc);
    procedure Clear;
    procedure Execute(const APacket: IServerPacket);
    procedure Remove(const ACommand: TPacketCommand);
  end;

  IServerPacket = interface
    ['{85C71958-EC48-485F-9A01-572E4BAD8FED}']
    function  GetCommand: TPacketCommand;
    function  GetConnection: IPacketConnection;
    function  GetErrorCode: Integer;
    function  GetErrorMessage: string;
    procedure SetCommand(const Value: TPacketCommand);
    procedure SetConnection(const Value: IPacketConnection);
    procedure SetErrorCode(const Value: Integer);
    procedure SetErrorMessage(const Value: string);
    function  ToBytes: TBytes;
    function  ToStream: TPacketStream;

    property Command: TPacketCommand read GetCommand write SetCommand;
    property Connection: IPacketConnection read GetConnection write SetConnection;
    property ErrorCode: Integer read GetErrorCode write SetErrorCode;
    property ErrorMessage: string read GetErrorMessage write SetErrorMessage;
  end;

  TServerPacket = class(TInterfacedObject, IServerPacket)
  private
    FCommand: TPacketCommand;
    FConnection: IPacketConnection;
    FErrorCode: Integer;
    FErrorMessage: string;

    function  GetCommand: TPacketCommand;
    function  GetConnection: IPacketConnection;
    function  GetErrorCode: Integer;
    function  GetErrorMessage: string;
    procedure SetCommand(const Value: TPacketCommand);
    procedure SetConnection(const Value: IPacketConnection);
    procedure SetErrorCode(const Value: Integer);
    procedure SetErrorMessage(const Value: string);
  public
    constructor Create(const ACommand: TPacketCommand = 0);
    destructor Destroy; override;

    class function From(const ABuffer: Pointer; const ASize): IServerPacket; overload;
    class function From(const AStream: TPacketStream): IServerPacket; overload;
    function  ToBytes: TBytes;
    function  ToStream: TPacketStream;

    property Command: TPacketCommand read GetCommand write SetCommand;
    property Connection: IPacketConnection read GetConnection write SetConnection;
    property ErrorCode: Integer read GetErrorCode write SetErrorCode;
    property ErrorMessage: string read GetErrorMessage write SetErrorMessage;
  end;

  ISession = interface
    ['{47D0990F-9F73-4612-ABA3-6FACF700BDDE}']
    function  GetSessionID: string;
    procedure SetSessionID(const Value: string);

    property SessionID: string read GetSessionID write SetSessionID;
  end;

  TSession = class(TInterfacedObject, ISession)
  private
    FSessionID: string;

    function  GetSessionID: string;
    procedure SetSessionID(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    property SessionID: string read GetSessionID write SetSessionID;
  end;

  TSessions = class
  private
    FItems: TDictionary<string, ISession>;
    FLocker: TLightweightMREW;

    function  GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(const ASessionID: string; ASession: ISession);
    procedure Clear;
    function  Find(const ASessionID: string): ISession; overload;
    function  Find(const ASessionID: string; out ASession: ISession): Boolean; overload;
    procedure ForEach(AProc: TProc<ISession>);
    procedure Remove(const ASessionID: string);

    property Count: Integer read GetCount;
  end;

  IPacketServer = interface(IPacketSocket)
    ['{5151D00E-116A-41BE-A88C-D153CA5ADB03}']
    procedure Broadcast(const APacket: IServerPacket);
    //function  GetOptions: TOptions;
    procedure SendPacket(const APacket: IServerPacket; const ATarget: IPacketConnection);

    //property Options: TOptions read GetOptions;
  end;

  TPacketServer = class(TPacketSocket, IPacketServer)
  strict private
    const
      _ONE_SECOND_ = 1000;
      _ONE_MINUTE_ = 60 * _ONE_SECOND_;

      CMD_WELCOME = 0;

    type
      TOptions = class
      private
        FAuthorizedOnly: Boolean;
        FGhostInterval: Integer;
        FGhostTimeOut: Integer;
        FMaxClients: Integer;
      public
        constructor Create;
        destructor Destroy; override;

        property AuthorizedOnly: Boolean read FAuthorizedOnly write FAuthorizedOnly;
        property GhostInterval: Integer read FGhostInterval write FGhostInterval;
        property GhostTimeOut: Integer read FGhostTimeOut write FGhosttimeOut;
        property MaxClients: Integer read FMaxClients write FMaxClients;
      end;
  private
    FOptions: TOptions;
    FRouter: IPacketRouter;

    function  GetOptions: TOptions;
  protected
    function  CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection; override;
    procedure LogicConnected(const AConnection: ICrossConnection); override;
    procedure LogicDisconnected(const AConnection: ICrossConnection); override;
    procedure LogicPacket(const AConnection: ICrossConnection; const APacket: TDataPacket); override;
  public
    constructor Create(const AIoThreads: Integer); override;
    destructor Destroy; override;

    procedure Broadcast(const APacket: IServerPacket);
    procedure SendPacket(const APacket: IServerPacket; const ATarget: IPacketConnection);

    property Options: TOptions read GetOptions;
  end;

implementation

{ TServerPacket }

constructor TServerPacket.Create(const ACommand: TPacketCommand);
begin
  FCommand := ACommand;
  FConnection := nil;
  FErrorCode := 0;
  FErrorMessage := '';
end;

destructor TServerPacket.Destroy;
begin
  FConnection := nil;

  inherited;
end;

class function TServerPacket.From(const AStream: TPacketStream): IServerPacket;
begin
  Result := TServerPacket.Create;
end;

class function TServerPacket.From(const ABuffer: Pointer; const ASize): IServerPacket;
begin
  Result := TServerPacket.Create;
end;

function TServerPacket.GetCommand: TPacketCommand;
begin
  Result := FCommand;
end;

function TServerPacket.GetConnection: IPacketConnection;
begin
  Result := FConnection;
end;

function TServerPacket.GetErrorCode: Integer;
begin
  Result := FErrorCode;
end;

function TServerPacket.GetErrorMessage: string;
begin
  Result := FErrorMessage;
end;

procedure TServerPacket.SetCommand(const Value: TPacketCommand);
begin
  FCommand := Value;
end;

procedure TServerPacket.SetConnection(const Value: IPacketConnection);
begin
  FConnection := Value;
end;

procedure TServerPacket.SetErrorCode(const Value: Integer);
begin
  FErrorCode := Value;
end;

procedure TServerPacket.SetErrorMessage(const Value: string);
begin
  FErrorMessage := Value;
end;

function TServerPacket.ToBytes: TBytes;
begin
  var LStream := ToStream;
  try
    SetLength(Result, LStream.Size);
    Move(LStream.Bytes[0], Result[0], LStream.Size);
  finally
    LStream.Free;
  end;
end;

function TServerPacket.ToStream: TPacketStream;
begin
  Result := TPacketStream.Create;
  Result.Write(FCommand, SizeOf(FCommand));
end;

{ TPacketRouter }

constructor TPacketRouter.Create;
begin
  FItems := TDictionary<TPacketCommand, TPacketProc>.Create;
end;

destructor TPacketRouter.Destroy;
begin
  FItems.Free;

  inherited;
end;

procedure TPacketRouter.Add(const ACommand: TPacketCommand; AProc: TPacketProc);
begin
  FItems.AddorSetValue(ACommand, AProc);
end;

procedure TPacketRouter.Clear;
begin
  FItems.Clear;
end;

procedure TPacketRouter.Execute(const APacket: IServerPacket);
var
  LProc: TPacketProc;
begin
  if Find(APacket.Command, LProc) then
    LProc(APacket);
end;

function TPacketRouter.Find(const ACommand: TPacketCommand; out AProc: TPacketProc): Boolean;
begin
  Result := Fitems.TryGetValue(ACommand, AProc);
end;

procedure TPacketRouter.Remove(const ACommand: TPacketCommand);
begin
  FItems.Remove(ACommand);
end;

{ TPacketServerConnection }

constructor TPacketServerConnection.Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType);
begin
  inherited;

end;

destructor TPacketServerConnection.Destroy;
begin

  inherited;
end;

function TPacketServerConnection.GetAuthorized: Boolean;
begin
  Result := FAuthorized;
end;

function TPacketServerConnection.GetCreated: TDateTime;
begin
  Result := FCreated;
end;

function TPacketServerConnection.GetLastAccess: TDateTime;
begin
  Result := FLastAccess;
end;

function TPacketServerConnection.GetUserID: string;
begin
  Result := FUserID;
end;

procedure TPacketServerConnection.SetAuthorized(const Value: Boolean);
begin
  FAuthorized := Value;
end;

procedure TPacketServerConnection.SetLastAccess(const Value: TDateTime);
begin
  FLastAccess := Value;
end;

procedure TPacketServerConnection.SetUserID(const Value: string);
begin
  FUserID := Value;
end;

{ TPacketServer.TOptions }

constructor TPacketServer.TOptions.Create;
begin
  FAuthorizedOnly := False;
  FGhostInterval := 30 * _ONE_SECOND_;
  FGhostTimeOut := 5 * _ONE_MINUTE_;
  FMaxClients := 0;
end;

destructor TPacketServer.TOptions.Destroy;
begin
  inherited;
end;

{ TPacketServer }

constructor TPacketServer.Create(const AIoThreads: Integer);
begin
  inherited;

  FOptions := TOptions.Create;
end;

destructor TPacketServer.Destroy;
begin
  FOptions.Free;

  inherited;
end;

function TPacketServer.GetOptions: TOptions;
begin
  Result := FOptions;
end;

procedure TPacketServer.Broadcast(const APacket: IServerPacket);
begin

end;

function TPacketServer.CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection;
begin
  Result := TPacketServerConnection.Create(AOwner, AClientSocket, AConnectType);
end;

procedure TPacketServer.LogicConnected(const AConnection: ICrossConnection);
begin
  var LPacket := TServerPacket.Create(CMD_WELCOME);
  if (FOptions.MaxClients <> 0) and (ConnectionsCount > FOptions.MaxClients) then
  begin
    LPacket.ErrorCode := -1;
    LPacket.ErrorMessage := '최대 접속사용자를 초과했습니다';

    //(AConnection as IPacketSocket).Send(LPacket);

    AConnection.Disconnect;
  end
  else
  begin
    //(AConnection as IPacketSocket).Send(LPacket);
  end;
end;

procedure TPacketServer.LogicDisconnected(const AConnection: ICrossConnection);
begin
  inherited;
end;

procedure TPacketServer.LogicPacket(const AConnection: ICrossConnection; const APacket: TDataPacket);
begin
  var LPacket := TServerPacket.From(APacket.Data, APacket.Header.Size);
  FRouter.Execute(LPacket);
end;

procedure TPacketServer.SendPacket(const APacket: IServerPacket; const ATarget: IPacketConnection);
begin
  var LBuffer := APacket.ToBytes;
  try
    ATarget.SendBuf(PByte(LBuffer), Length(LBuffer),
      procedure(const AConnection: ICrossConnection; const AResult: Boolean)
      begin
        // 전송이 실패한 경우, 해당 컨넥션의 연결을 종료한다
        if not AResult then
          AConnection.Disconnect;
      end
    );
  finally
    LBuffer := nil;
  end;
end;

{ TSessions }

constructor TSessions.Create;
begin
  FItems := TDictionary<string, ISession>.Create;
end;

destructor TSessions.Destroy;
begin

  inherited;
end;

procedure TSessions.Add(const ASessionID: string; ASession: ISession);
begin
  FLocker.BeginWrite;
  try
    FItems.AddorSetValue(ASessionID.ToUpper, ASession);
  finally
    FLocker.EndWrite;
  end;
end;

procedure TSessions.Clear;
begin
  FLocker.BeginWrite;
  try
    FItems.Clear;
  finally
    FLocker.EndWrite;
  end;
end;

function TSessions.Find(const ASessionID: string): ISession;
begin
  FLocker.BeginRead;
  try
    FItems.TryGetValue(ASessionID.ToUpper, Result);
  finally
    FLocker.EndRead;
  end;
end;

function TSessions.Find(const ASessionID: string; out ASession: ISession): Boolean;
begin
  FLocker.BeginRead;
  try
    Result := FItems.TryGetValue(ASessionID.ToUpper, ASession);
  finally
    FLocker.EndRead;
  end;
end;

procedure TSessions.ForEach(AProc: TProc<ISession>);
begin
  FLocker.BeginRead;
  try
    for var LSession in Fitems.Values.ToArray do
      AProc(LSession);
  finally
    FLocker.EndRead;
  end;
end;

function TSessions.GetCount: Integer;
begin
  FLocker.BeginRead;
  try
    Result := FItems.Count;
  finally
    FLocker.EndRead;
  end;
end;

procedure TSessions.Remove(const ASessionID: string);
begin
  FLocker.BeginWrite;
  try
    FItems.Remove(ASessionID.ToUpper);
  finally
    FLocker.EndWrite;
  end;
end;

{ TSession }

constructor TSession.Create;
begin
  FSessionID := '';
end;

destructor TSession.Destroy;
begin

  inherited;
end;

function TSession.GetSessionID: string;
begin
  Result := FSessionID;
end;

procedure TSession.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

end.
