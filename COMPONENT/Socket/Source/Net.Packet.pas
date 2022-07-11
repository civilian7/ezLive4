unit Net.Packet;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TCommand = WORD;

  TPacketStream = class(TBytesStream)
  public
  end;

  IPacket = interface
    ['{6339B827-10F2-4E58-B91A-6C6D504597D4}']
  end;

  TPacket = class(TInterfacedObject, IPacket)
  strict private
    class var
      FDefaultCompress: Byte;
      FDefaultCrypt: Byte;

      class constructor Create;
  private
    FCommand: TCommand;
    FCompress: Byte;
    FCrypt: Byte;
    FData: TPacketStream;
    FErrorCode: Integer;
    FErrorMessage: string;

    {$REGION 'GETTER/SETTER'}
    function  GetCommand: TCommand;
    function  GetCompress: Byte;
    function  GetCrypt: Byte;
    function  GetData: TPacketStream;
    function  GetErrorCode: Integer;
    function  GetErrorMessage: string;
    procedure SetCommand(const Value: TCommand);
    procedure SetCompress(const Value: Byte);
    procedure SetCrypt(const Value: Byte);
    procedure SetErrorCode(const Value: Integer);
    procedure SetErrorMessage(const Value: string);
    {$ENDREGION}
  public
    constructor Create(const ACommand: TCommand = 0); virtual;
    destructor Destroy; override;

    function  ToBytes: TBytes;
    function  ToStream: TBytesStream;

    class property DefaultCompress: Byte read FDefaultCompress write FDefaultCompress;
    class property DefaultCrypt: Byte read FDefaultCrypt write FDefaultCrypt;

    property Command: TCommand read GetCommand write SetCommand;
    property Compress: Byte read GetCompress write SetCompress;
    property Crypt: Byte read GetCrypt write SetCrypt;
    property Data: TPacketStream read GetData;
    property ErrorCode: Integer read GetErrorCode write SetErrorCode;
    property ErrorMessage: string read GetErrorMessage write SetErrorMessage;
  end;

implementation

{ TPacket }

class constructor TPacket.Create;
begin
  FDefaultCompress := 0;
  FDefaultCrypt := 0;
end;

constructor TPacket.Create(const ACommand: TCommand);
begin
  FCommand := ACommand;
  FCompress := FDefaultCompress;
  FCrypt := FDefaultCrypt;
  FData := TPacketStream.Create;
  FErrorCode := 0;
  FErrorMessage := '';
end;

destructor TPacket.Destroy;
begin
  FData.Free;

  inherited;
end;

function TPacket.GetCommand: TCommand;
begin
  Result := FCommand;
end;

function TPacket.GetCompress: Byte;
begin
  Result := FCompress;
end;

function TPacket.GetCrypt: Byte;
begin
  Result := FCrypt;
end;

function TPacket.GetData: TPacketStream;
begin
  Result := FData;
end;

function TPacket.GetErrorCode: Integer;
begin

end;

function TPacket.GetErrorMessage: string;
begin

end;

procedure TPacket.SetCommand(const Value: TCommand);
begin
  FCommand := Value;
end;

procedure TPacket.SetCompress(const Value: Byte);
begin
  FCompress := Value;
end;

procedure TPacket.SetCrypt(const Value: Byte);
begin
  FCrypt := Value;
end;

procedure TPacket.SetErrorCode(const Value: Integer);
begin

end;

procedure TPacket.SetErrorMessage(const Value: string);
begin

end;

function TPacket.ToBytes: TBytes;
begin
  var LStream := ToStream;
  try
    SetLength(Result, LStream.Size);
    Move(PByte(LStream.Bytes)^, PByte(Result)^, LStream.Size);
  finally
    LStream.Free;
  end;
end;

function TPacket.ToStream: TBytesStream;
begin
  Result := TBytesStream.Create;
  Result.WriteData(FCommand);
end;

end.
