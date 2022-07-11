unit Net.PacketSocket;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.SyncObjs,
  Net.CrossSocket.Base,
  Net.CrossSocket;

type
  PPacketHeader = ^TPacketHeader;
  TPacketHeader = packed record
    MagicNumber: WORD;
    ProtocolVersion: Byte;
    Size: Integer;
  end;

  PDataPacket = ^TDataPacket;
  TDataPacket = packed record
    Header: TPacketHeader;
    Data: Pointer;
  end;

  IPacketConnection = interface;

  IPacketConnection = interface(ICrossConnection)
    ['{89574267-1A06-402C-BD7A-5EAEEABC4D31}']
    procedure Parse(const ABuffer: Pointer; const ASize: Integer);
  end;

  TPacketConnection = class(TCrossConnection, IPacketConnection)
  private
    procedure ClearPacket;
    function  MakeHeader(const ABuffer: Pointer; const ASize: Integer): TPacketHeader;
    function  PackData(const ABuffer: Pointer; const ASize: Integer): TBytes;
  protected
    RecvedPacket: PDataPacket;
    RecvedBytes: Integer;

    procedure Parse(const ABuffer: Pointer; const ASize: Integer); virtual;
  public
    constructor Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType); override;
    destructor Destroy; override;

    procedure Send(const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback = nil); overload;
  end;

  IPacketSocket = interface(ICrossSocket)
    ['{5FF8F27D-D16B-4370-8617-88F5F03AFD94}']
    function  GetProtocolVersion: Byte;
    procedure LogicPacket(const AConnection: ICrossConnection; const APacket: TDataPacket);
    procedure SetProtocolVersion(const Value: Byte);

    property ProtocolVersion: Byte read GetProtocolVersion write SetProtocolVersion;
  end;

  TPacketSocket = class(TCrossSocket, IPacketSocket)
  strict private
    class var
      FMagicNumber: WORD;

      class constructor Create;
  private
    FProtocolVersion: Byte;

    FOnError: TProc<IPacketSocket, IPacketConnection, Integer>;
    FOnPacket: TProc<IPacketSocket, IPacketConnection, TDataPacket>;

    function  GetProtocolVersion: Byte;
    procedure SetProtocolVersion(const Value: Byte);
  protected
    function  CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection; override;
    procedure LogicPacket(const AConnection: ICrossConnection; const APacket: TDataPacket); virtual;
    procedure LogicReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer); override;
  public
    constructor Create(const AIoThreads: Integer); override;
    destructor Destroy; override;

    class property MagicNumber: WORD read FMagicNumber write FMagicNumber;
    property ProtocolVersion: Byte read GetProtocolVersion write SetProtocolVersion;

    property OnError: TProc<IPacketSocket, IPacketConnection, Integer> read FOnError write FOnError;
    property OnPacket: TProc<IPacketSocket, IPacketConnection, TDataPacket> read FOnPacket write FOnPacket;
  end;

implementation

uses
  System.Math;

{$REGION 'TPacketConnection'}

constructor TPacketConnection.Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType);
begin
  inherited;

  ClearPacket;
end;

destructor TPacketConnection.Destroy;
begin
  ClearPacket;

  inherited;
end;

procedure TPacketConnection.ClearPacket;
begin
  RecvedBytes := 0;
  if Assigned(RecvedPacket) then
  begin
    if RecvedPacket.Data <> nil then
    begin
      FreeMem(RecvedPacket.Data);
      RecvedPacket.Data := nil;
    end;

    Dispose(RecvedPacket);
    RecvedPacket := nil;
  end;
end;

function TPacketConnection.MakeHeader(const ABuffer: Pointer; const ASize: Integer): TPacketHeader;
begin
  Result.MagicNumber := TPacketSocket.MagicNumber;
  Result.ProtocolVersion := (Owner as IPacketSocket).ProtocolVersion;
  Result.Size := ASize;
end;

function TPacketConnection.PackData(const ABuffer: Pointer; const ASize: Integer): TBytes;
begin
  SetLength(Result, ASize + SizeOf(TPacketHeader));
  var LHeader := MakeHeader(ABuffer, ASize);
  Move(LHeader, Result[0], SizeOf(ASize));
  Move(ABuffer^, Result[SizeOf(TPacketHeader)], ASize);
end;

procedure TPacketConnection.Parse(const ABuffer: Pointer; const ASize: Integer);
var
  LData: PByte;
  LPosition: Integer;
  LHeaderSize: Integer;
begin
  // 헤더의 길이
  LHeaderSize := SizeOf(TPacketHeader);

  // 헤더가 생성되지 않았으면 헤더 생성
  if RecvedPacket = nil then
  begin
    New(RecvedPacket);
  end;

  if (RecvedBytes < LHeaderSize) then
  begin
    LData := @RecvedPacket.Header;
    Inc(LData, RecvedBytes);
    LPosition := System.Math.Min(LHeaderSize - RecvedBytes, ASize);
    Move(ABuffer^, LData^, LPosition);
    Inc(RecvedBytes, LPosition);

    if (ASize > LPosition) then
    begin
      LData := ABuffer;
      Inc(LData, LPosition);
      Parse(LData, ASize - LPosition);
    end;
  end
  else
  begin
    if RecvedPacket.Data = nil then
    begin
      try
        GetMem(RecvedPacket.Data, RecvedPacket.Header.Size);
      except
        Dispose(RecvedPacket);
        Disconnect;
        Exit;
      end;
    end;

    LData := RecvedPacket.Data;
    Inc(LData, RecvedBytes - LHeaderSize);
    LPosition := System.Math.Min(ASize, LHeaderSize + RecvedPacket.Header.Size - RecvedBytes);
    Move(ABuffer^, LData^, LPosition);
    Inc(RecvedBytes, LPosition);

    if (RecvedBytes >= LHeaderSize + RecvedPacket.Header.Size) then
    begin
      (Owner as IPacketSocket).LogicPacket(Self, RecvedPacket^);

      ClearPacket;

      if (ASize > LPosition) then
      begin
        LData := ABuffer;
        Inc(LData, LPosition);
        Parse(LData, ASize - LPosition);
      end;
    end;
  end;
end;

procedure TPacketConnection.Send(const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback);
begin
  var LBuffer := PackData(ABuf, ALen);
  SendBuf(PByte(LBuffer), Length(LBuffer), ACallback);
end;

{$ENDREGION}

{$REGION 'TPacketSocket'}

class constructor TPacketSocket.Create;
begin
  FMagicNumber := $F0F0;
end;

constructor TPacketSocket.Create(const AIoThreads: Integer);
begin
  inherited;

  FProtocolVersion := 1;
  FOnPacket := nil;
end;

destructor TPacketSocket.Destroy;
begin
  inherited;
end;

function TPacketSocket.GetProtocolVersion: Byte;
begin
  Result := FProtocolVersion;
end;

function TPacketSocket.CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection;
begin
  Result := TPacketConnection.Create(AOwner, AClientSocket, AConnectType);
end;

procedure TPacketSocket.LogicPacket(const AConnection: ICrossConnection; const APacket: TDataPacket);
begin
  if Assigned(FOnPacket) then
    FOnPacket(Self, (AConnection as IPacketConnection), APacket);
end;

procedure TPacketSocket.LogicReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer);
begin
  (AConnection as IPacketConnection).Parse(ABuf, ALen);
end;

procedure TPacketSocket.SetProtocolVersion(const Value: Byte);
begin
  FProtocolVersion := Value;
end;

{$ENDREGION}

end.
