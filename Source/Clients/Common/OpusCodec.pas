unit OpusCodec;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  OpusAPI;

type
  IAudioCodec = interface
    ['{84C544D8-2D40-42BA-8FEA-45D150D65BD5}']
    function  GetBitRate: Integer;
    function  GetChannels: Integer;
    function  GetCodecName: string;
    function  GetSampleRate: Integer;
    function  GetVersion: string;
    procedure SetBitRate(const Value: Integer);
    procedure SetChannels(const Value: Integer);
    procedure SetSampleRate(const Value: Integer);

    property BitRate: Integer read GetBitRate write SetBitRate;
    property Channels: Integer read GetChannels write SetChannels;
    property CodecName: string read GetCodecName;
    property SampleRate: Integer read GetSampleRate write SetSampleRate;
    property Version: string read GetVersion;
  end;

  TAudioCodec = class(TInterfacedObject, IAudioCodec)
  private
    FBitRate: Integer;
    FChannels: Integer;
    FSampleRate: Integer;

    function  GetBitRate: Integer;
    function  GetChannels: Integer;
    function  GetSampleRate: Integer;
    procedure SetBitRate(const Value: Integer);
    procedure SetChannels(const Value: Integer);
    procedure SetSampleRate(const Value: Integer);
  protected
    function  GetCodecName: string; virtual; abstract;
    function  GetVersion: string; virtual; abstract;
  public
    constructor Create(const ASampleRate, AChannels, ABitRate: Integer); virtual;
    destructor Destroy; override;

    property BitRate: Integer read GetBitRate write SetBitRate;
    property Channels: Integer read GetChannels write SetChannels;
    property SampleRate: Integer read GetSampleRate write SetSampleRate;
    property CodecName: string read GetCodecName;
    property Version: string read GetVersion;
  end;

  IAudioDecoder = interface(IAudioCodec)
    ['{765EDE13-13FC-4ECA-8F1A-9A8E00CA9126}']
  end;

  TAudioDecoder = class(TAudioCodec, IAudioDecoder)
  private
    FDecoder: TOpusDecoder;
  protected
    function  GetCodecName: string; override;
    function  GetVersion: string; override;
  public
    constructor Create(const ASampleRate, AChannels, ABitRate: Integer); virtual;
    destructor Destroy; override;
  end;

  IAudioEncoder = interface(IAudioCodec)
    ['{C7308861-0164-4B0F-BC3D-8234741A0BE0}']
    function Encode(AInBuffer: Pointer; AInSize: Integer; var AOutBuffer: Pointer; var AOutSize: Integer): Integer;
  end;

  TAudioEncoder = class(TAudioCodec, IAudioEncoder)
  private
    MaxFrameSize: Integer;
    MaxPacketSize: Integer;
    pcm_bytes: TBytes;
    PCMIn: TArray<SmallInt>;
    Encoder: TOpusEncoder;
  protected
    function  GetCodecName: string; override;
    function  GetVersion: string; override;
  public
    constructor Create(const ASampleRate, AChannel, ABitRate: Integer); virtual;
    destructor Destroy; override;

    function Encode(AInBuffer: Pointer; AInSize: Integer; var AOutBuffer: Pointer; var AOutSize: Integer): Integer;
  end;

  IAudioPlayer = interface
    ['{F4DFFA60-CF38-430E-A386-FDF35BC1D3A0}']
  end;

  TAudioPlayer = class(TInterfacedObject, IAudioPlayer)
  private
    FDecoder: IAudioDecoder;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Play(const ABuffer: Pointer; ASize: Integer; const AChannel: Integer = 0);

    property Decoder: IAudioDecoder read FDecoder;
  end;

  IAudioRecorder = interface
    ['{E73E7311-7C6B-43A5-8588-06F0F64CE9BE}']
  end;

  TAudioRecorder = class(TInterfacedObject, IAudioRecorder)
  private
  end;

implementation

{ TAudioCodec }

constructor TAudioCodec.Create(const ASampleRate, AChannels, ABitRate: Integer);
begin
  FSampleRate := ASampleRate;
  FChannels := AChannels;
  FBitRate := ABitRate;
end;

destructor TAudioCodec.Destroy;
begin
  inherited;
end;

function TAudioCodec.GetBitRate: Integer;
begin
  Result := FBitRate;
end;

function TAudioCodec.GetChannels: Integer;
begin
  Result := FChannels;
end;

function TAudioCodec.GetSampleRate: Integer;
begin
  Result := FSampleRate;
end;

procedure TAudioCodec.SetBitRate(const Value: Integer);
begin
  FBitRate := Value;
end;

procedure TAudioCodec.SetChannels(const Value: Integer);
begin
  FChannels := Value;
end;

procedure TAudioCodec.SetSampleRate(const Value: Integer);
begin
  FSampleRate := Value;
end;

{ TAudioDecoder }

constructor TAudioDecoder.Create(const ASampleRate, AChannels, ABitRate: Integer);
begin
  inherited;

  var LError: Integer;

  FDecoder := opus_decoder_create(SampleRate, Channels, LError);
end;

destructor TAudioDecoder.Destroy;
begin
  opus_decoder_destroy(FDecoder);

  inherited;
end;

function TAudioDecoder.GetCodecName: string;
begin
  Result := 'Opus Decoder';
end;

function TAudioDecoder.GetVersion: string;
begin
  Result := String(opus_get_version_string);
end;

{ TAudioEncoder }

constructor TAudioEncoder.Create(const ASampleRate, AChannel, ABitRate: Integer);
var
  LError: Integer;
begin
  inherited;

  //MaxFrameSize := FrameSize * 6;

  Encoder := opus_encoder_create(ASampleRate, AChannel, OPUS_APPLICATION_AUDIO, LError);
  if LError < 0 then
    raise Exception.CreateFmt('Failed to create : %s', [opus_strerror(LError)]);

  LError := opus_encoder_ctl(Encoder, OPUS_SET_BITRATE(BitRate));
  if LError < 0 then
    raise Exception.CreateFmt('Failed to set bitrate: %s', [opus_strerror(LError)]);

  SetLength(PCMIn, SampleRate * Channels - 1);
end;

destructor TAudioEncoder.Destroy;
begin
  opus_encoder_destroy(Encoder);

  inherited;
end;

function TAudioEncoder.Encode(AInBuffer: Pointer; AInSize: Integer; var AOutBuffer: Pointer; var AOutSize: Integer): Integer;
var
  LSamples: Integer;
begin
  LSamples := AInSize div SizeOf(SmallInt);
  for var i := 0 to LSamples-1 do
    PCMIn[i] := (AInBuffer[2*i+1] shl 8) or AInBuffer[2*i];

  var LFrameSize := LSamples div Channels;
  if (LFrameSize < FrameSize) then
    for var i := Samples to FrameSize * Channels - 1 do
      PCMIn[i] := 0;

  var LError := opus_encode(Encoder, AInBuffer, AInSize, AOutBuffer, AOutSize);
  if (LError < 0) then
    raise Exception.CreateFmt('Failed to create an encoder: %s', [opus_strerror(LError)]);
end;

function TAudioEncoder.GetCodecName: string;
begin
  Result := 'Opus Encoder';
end;

function TAudioEncoder.GetVersion: string;
begin
  Result := String(opus_get_version_string);
end;

{ TAudioPlayer }

constructor TAudioPlayer.Create;
begin

end;

destructor TAudioPlayer.Destroy;
begin

  inherited;
end;

procedure TAudioPlayer.Play(const ABuffer: Pointer; ASize: Integer; const AChannel: Integer);
begin

end;

initialization
  LoadLibOpus;
finalization
  FreeLibOpus;
end.
