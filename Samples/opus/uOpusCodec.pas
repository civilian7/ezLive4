unit uOpusCodec;

interface

uses
  Windows,
  SysUtils,
  Classes,
  uLibOpus;

const
  FRAME_SIZE = 960;
  MAX_FRAME_SIZE = 6 * 960;
  MAX_PACKET_SIZE = 3 * 1276;
  BIT_RATE = 64000;

type
  TOpusCodec = class
  private
    FChannels: Integer;
    FSampleRate: Integer;
  public
    constructor Create(const ASampleRate, AChannels: Integer); virtual;
    destructor Destroy; override;

    property Channels: Integer read FChannels;
    property SampleRate: Integer read FSampleRate;
  end;

  TOpusEncoder = class(TOpusCodec)
  private
    FEncoder: TOpusEncoder;
  protected
    PCMIn: array [0..FRAME_SIZE * 2 - 1] of SmallInt;
  public
    constructor Create(const ASampleRate, AChannels: Integer); override;
    destructor Destroy; override;

    procedure Encoder(AInBuffer: Pointer; AInSize: Integer; var AOutBuffer: Pointer; var AOutSize: Integer);
  end;

  TOpusDecoder = class(TOpusCodec)
  private
    FDecoder: TOpusEncoder;
  public
    constructor Create(const ASampleRate, AChannels: Integer); override;
    destructor Destroy; override;

    procedure Decoder(AInBuffer: Pointer; AInSize: Integer; var AOutBuffer: Pointer; var AOutSize: Integer);
  end;

implementation

{ TOpusCodec }

constructor TOpusCodec.Create(const ASampleRate, AChannels: Integer);
begin
  FChannels := AChannels;
  FSampleRate := ASampleRate;
end;

destructor TOpusCodec.Destroy;
begin
  inherited;
end;

{ TOpusEncoder }

constructor TOpusEncoder.Create(const ASampleRate, AChannels: Integer);
var
  LError: Integer;
begin
  inherited;

  FEncoder := opus_encoder_create(SampleRate, Channels, OPUS_APPLICATION_AUDIO, LError);
  if (LError < 0) then
    raise Exception.Createfmt('Create OpusEncoder Fail: %d', [LError]);

  LError := opus_encoder_ctl(FEncoder, OPUS_SET_BITRATE(BIT_RATE));
  if (LError < 0) then
    raise Exception.CreateFmt('OpusEncoder Set bitrate Fail: %d', [LError]);
end;

destructor TOpusEncoder.Destroy;
begin
  if Assigned(FEncoder) then
    opus_encoder_destroy(FEncoder);

  inherited;
end;

procedure TOpusEncoder.Encoder(AInBuffer: Pointer; AInSize: Integer; var AOutBuffer: Pointer; var AOutSize: Integer);
begin
{
var
  nBytes: Integer;
  nsamples: Integer;
  frame_size: Integer;
begin
  //Move(Buffer^, pcm_bytes[0], size);
  nSamples := Size div SizeOf(SmallInt);
  // Convert from little-endian ordering.
  for var i := 0 to nSamples-1 do
    //PCMIn[i] := (pcm_bytes[2*i+1] shl 8) or pcm_bytes[2*i];
    PCMIn[i] := (PByte(Buffer)[2*i+1] shl 8) or PByte(Buffer)[2*i];

  frame_size := nSamples div cChannels;
  if frame_size < cFRAME_SIZE then
  begin
    // pad frame to cFRAME_SIZE
    for var i := nSamples to cFRAME_SIZE * cCHANNELS - 1 do
      PCMIn[i] := 0;
  end;

  nBytes := opus_encode(OpusEncoder, PCMIn, cFRAME_SIZE, cbits, cMAX_PACKET_SIZE);
  if (nBytes<0) then
  begin
    raise Exception.CreateFmt('encode failed: %s', [opus_strerror(nBytes)]);
  end;
}
  var LSamples := (AInSize div SizeOf(SmallInt));
  for var i := 0 to LSamples-1 do
  begin
    PCMIn[i] := (PByte(AInBuffer)[2*i+1] shl 8) or PByte(AInBuffer)[2*i];
  end;

  var LFrameSize := LSamples div FChannels;
  AOutSize := opus_encode(FEncoder, PCMIn, FRAME_SIZE, AOutBuffer, MAX_FRAME_SIZE);
end;

{ TOpusDecoder }

constructor TOpusDecoder.Create(const ASampleRate, AChannels: Integer);
var
  LError: Integer;
begin
  inherited;

  FDecoder := opus_decoder_create(SampleRate, Channels, LError);
  if (LError < 0) then
    raise Exception.Createfmt('Create OpusEncoder Fail: %d', [LError]);
end;

destructor TOpusDecoder.Destroy;
begin
  if Assigned(FDecoder) then
    opus_decoder_destroy(FDecoder);

  inherited;
end;

procedure TOpusDecoder.Decoder(AInBuffer: Pointer; AInSize: Integer; var AOutBuffer: Pointer; var AOutSize: Integer);
begin

end;

end.
