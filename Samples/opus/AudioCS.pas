unit AudioCS;

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 23}
    {$define DXE2PLUS}
  {$ifend}
{$endif CONDITIONALEXPRESSIONS}

interface

uses
  Windows,
  Messages,
  Classes,
  SysUtils,
  MMSystem,
  Types;

{$ifndef DXE2PLUS}

const
{$EXTERNALSYM WAVE_FORMAT_44M08}
  WAVE_FORMAT_44M08 = $00000100; // 44.1 kHz, Mono, 8-bit
{$EXTERNALSYM WAVE_FORMAT_44S08}
  WAVE_FORMAT_44S08 = $00000200; // 44.1 kHz, Stereo, 8-bit
{$EXTERNALSYM WAVE_FORMAT_44M16}
  WAVE_FORMAT_44M16 = $00000400; // 44.1 kHz, Mono, 16-bit
{$EXTERNALSYM WAVE_FORMAT_44S16}
  WAVE_FORMAT_44S16 = $00000800; // 44.1 kHz, Stereo, 16-bit
{$EXTERNALSYM WAVE_FORMAT_48M08}
  WAVE_FORMAT_48M08 = $00001000; // 48 kHz, Mono, 8-bit
{$EXTERNALSYM WAVE_FORMAT_48S08}
  WAVE_FORMAT_48S08 = $00002000; // 48 kHz, Stereo, 8-bit
{$EXTERNALSYM WAVE_FORMAT_48M16}
  WAVE_FORMAT_48M16 = $00004000; // 48 kHz, Mono, 16-bit
{$EXTERNALSYM WAVE_FORMAT_48S16}
  WAVE_FORMAT_48S16 = $00008000; // 48 kHz, Stereo, 16-bit
{$EXTERNALSYM WAVE_FORMAT_96M08}
  WAVE_FORMAT_96M08 = $00010000; // 96 kHz, Mono, 8-bit
{$EXTERNALSYM WAVE_FORMAT_96S08}
  WAVE_FORMAT_96S08 = $00020000; // 96 kHz, Stereo, 8-bit
{$EXTERNALSYM WAVE_FORMAT_96M16}
  WAVE_FORMAT_96M16 = $00040000; // 96 kHz, Mono, 16-bit
{$EXTERNALSYM WAVE_FORMAT_96S16}
  WAVE_FORMAT_96S16 = $00080000; // 96 kHz, Stereo, 16-bit

type
  DWORD_PTR = Cardinal;

{$endif DXE2PLUS}

const
  MapperDevice = -1;
  MapperDeviceName = 'Mapper';

type
  EAudioError = class(Exception)
  public
    ErrorCode: Integer;

    constructor Create(ErrorCode: Integer; const Msg: string);
  end;

  TBufferNeededEvent = procedure(Sender: TObject; var ABuffer: Pointer; var ASize: LongWord) of object;
  TBufferReleasedEvent = procedure(Sender: TObject; ABuffer: Pointer; ASize: LongWord) of object;

  TAudio = class;
  TPlayer = class;
  TRecorder = class;
  TAudioDataFormat = class;

  TAudioThread = class(TThread)
  private
    FAudio: TAudio;
    FEvent: THandle;
  protected
    constructor Create(Audio: TAudio);

    procedure CreateEvent;
    procedure DestroyEvent;
  public
    procedure Execute; override;
    procedure Stop;
  end;

  TAudio = class(TComponent)
  private
    FDataFormat: TAudioDataFormat;
    FHeaders: array [0 .. 1] of WAVEHDR;
    FHeadersSize: Integer;
    FHeadersStart: Integer;
    FThread: TAudioThread;

    function  HeadersCount: Integer;
    procedure HeadersInit;
    function  HeadersIsEmpty: Boolean;
    function  HeadersIsFull: Boolean;
    function  HeadersPeek: PWaveHdr;
    function  HeadersPop: PWaveHdr;
    function  HeadersPush: PWaveHdr;
    procedure HeadersUndoPush;
    procedure SetEmptyDataFormat(const Value: TAudioDataFormat);
  protected
    procedure ClearHeaders;
    procedure CreateThread;
    procedure DestroyThread;
    procedure DoProcessEvent(NewBuffers: Boolean); virtual; abstract;
    procedure ProcessEvent;
  published
    property DataFormat: TAudioDataFormat read FDataFormat write SetEmptyDataFormat;
  end;

  TFormat = (
    fo11kHz8bitMono,
    fo11kHz8bitStereo,
    fo11kHz16bitMono,
    fo11kHz16bitStereo,
    fo22kHz8bitMono,
    fo22kHz8bitStereo,
    fo22kHz16bitMono,
    fo22kHz16bitStereo,
    fo44kHz8bitMono,
    fo44kHz8bitStereo,
    fo44kHz16bitMono,
    fo44kHz16bitStereo,
    fo48kHz8bitMono,
    fo48kHz8bitStereo,
    fo48kHz16bitMono,
    fo48kHz16bitStereo,
    fo96kHz8bitMono,
    fo96kHz8bitStereo,
    fo96kHz16bitMono,
    fo96kHz16bitStereo
  );
  TFormats = set of TFormat;

  TSupport = (
    suPitchControl,
    suPlaybackRateControl,
    suVolumeControl,
    suSeparateVolumes,
    suSynchronous,
    suAccurateSamplePosition,
    suDirectSound
  );
  TSupports = set of TSupport;

  TPlayerCapabilities = class(TPersistent)
  private
    FPlayer: TPlayer;

    function  GetDriverMajorVersion: Byte;
    function  GetDriverMinorVersion: Byte;
    function  GetFormats: TFormats;
    function  GetChannels: Word;
    function  GetManufacturer: Word;
    function  GetProduct: Word;
    function  GetProductName: string;
    function  GetSupports: TSupports;
    procedure SetEmptyByte(const Value: Byte);
    procedure SetEmptyWord(const Value: Word);
    procedure SetEmptyFormats(const Value: TFormats);
    procedure SetEmptyString(const Value: string);
    procedure SetEmptySupports(const Value: TSupports);
  public
    constructor Create(Player: TPlayer);
  published
    property Channels: Word read GetChannels write SetEmptyWord stored False;
    property DriverMajorVersion: Byte read GetDriverMajorVersion write SetEmptyByte stored False;
    property DriverMinorVersion: Byte read GetDriverMinorVersion write SetEmptyByte stored False;
    property Formats: TFormats read GetFormats write SetEmptyFormats stored False;
    property Manufacturer: Word read GetManufacturer write SetEmptyWord stored False;
    property Product: Word read GetProduct write SetEmptyWord stored False;
    property ProductName: string read GetProductName write SetEmptyString stored False;
    property Supports: TSupports read GetSupports write SetEmptySupports stored False;
  end;

  TRecorderCapabilities = class(TPersistent)
  private
    FRecorder: TRecorder;

    function  GetDriverMajorVersion: Byte;
    function  GetDriverMinorVersion: Byte;
    function  GetFormats: TFormats;
    function  GetChannels: Word;
    function  GetManufacturer: Word;
    function  GetProduct: Word;
    function  GetProductName: string;
    procedure SetEmptyByte(Value: Byte);
    procedure SetEmptyWord(Value: Word);
    procedure SetEmptyFormats(const Value: TFormats);
    procedure SetEmptyString(const Value: string);
  public
    constructor Create(Recorder: TRecorder);
  published
    property Channels: Word read GetChannels write SetEmptyWord stored False;
    property DriverMajorVersion: Byte read GetDriverMajorVersion write SetEmptyByte stored False;
    property DriverMinorVersion: Byte read GetDriverMinorVersion write SetEmptyByte stored False;
    property Formats: TFormats read GetFormats write SetEmptyFormats stored False;
    property Manufacturer: Word read GetManufacturer write SetEmptyWord stored False;
    property Product: Word read GetProduct write SetEmptyWord stored False;
    property ProductName: string read GetProductName write SetEmptyString stored False;
  end;

  TAudioDataFormat = class(TPersistent)
  private
    FWaveFormat: tWAVEFORMATEX;

    function  GetBitsPerSample: Word;
    function  GetChannels: Word;
    function  GetSamplesPerSecond: LongWord;
    procedure SetBitsPerSample(Value: Word);
    procedure SetChannels(Value: Word);
    procedure SetSamplesPerSecond(Value: LongWord);
    procedure UpdateWaveFormat;
  protected
    function  GetWaveFormat: PWaveFormatEx;
  public
    constructor Create;

    procedure Assign(Source: TPersistent); override;
  published
    property BitsPerSample: Word read GetBitsPerSample write SetBitsPerSample default 16;
    property Channels: Word read GetChannels write SetChannels default 2;
    property SamplesPerSecond: LongWord read GetSamplesPerSecond write SetSamplesPerSecond default 8000;
  end;

  TPlayer = class(TAudio)
  private
    FActive: Boolean;
    FCapabilities: TPlayerCapabilities;
    FDevice: Integer;
    FHandle: HWAVEOUT;
    FVolumeLeft: Integer;
    FVolumeRight: Integer;

    FOnBufferNeeded: TBufferNeededEvent;
    FOnBufferReleased: TBufferReleasedEvent;

    procedure CheckActive;
    procedure CheckInactive;
    function  GetActive: Boolean;
    function  GetDeviceCount: Integer;
    function  GetDeviceName(Device: Integer): string;
    procedure SetActive(Value: Boolean);
    function  GetPitch: Double;
    function  GetPitchValue: LongWord;
    function  GetPlaybackRate: Double;
    function  GetPlaybackRateValue: LongWord;
    function  GetVolume: LongWord;
    function  GetVolumeLeft: Integer;
    function  GetVolumeRight: Integer;
    procedure SetEmptyCapabilities(const Value: TPlayerCapabilities);
    procedure SetPitch(Value: Double);
    procedure SetPitchValue(Value: LongWord);
    procedure SetPlaybackRate(Value: Double);
    procedure SetPlaybackRateValue(Value: LongWord);
    procedure SetVolume(Value: LongWord);
    procedure SetVolumeLeft(Value: Integer);
    procedure SetVolumeRight(Value: Integer);
  protected
    function  BufferNeeded(HeaderPtr: PWaveHdr): Boolean;
    procedure Check(Value: MMRESULT);
    procedure DoProcessEvent(NewBuffers: Boolean); override;
    function  GetErrorText(Error: MMRESULT): string;
    procedure Loaded; override;
    procedure RetrieveBuffers;
    procedure UnprepareHeaders;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure BreakLoop;
    procedure Close;
    procedure Open;
    procedure Pause;
    procedure Play; overload;
    procedure Play(const ABuffer: Pointer; const ASize: Integer); overload;
    function  PositionInBytes: LongWord;
    function  PositionInMidiTime: LongWord;
    function  PositionInMilliSeconds: LongWord;
    function  PositionInSamples: LongWord;
    procedure PositionInSmpte(var Hours, Minutes, Seconds, Frames, FramesPerSeconds: Byte);
    function  PositionInTicks: LongWord;
    procedure Resume;
    procedure Stop;

    property DeviceCount: Integer read GetDeviceCount stored False;
    property DeviceName[Device: Integer]: string read GetDeviceName;
    property Handle: HWAVEOUT read FHandle stored False;
    property Pitch: Double read GetPitch write SetPitch stored False;
    property PitchValue: LongWord read GetPitchValue write SetPitchValue stored False;
    property PlaybackRate: Double read GetPlaybackRate write SetPlaybackRate stored False;
    property PlaybackRateValue: LongWord read GetPlaybackRateValue write SetPlaybackRateValue stored False;
    property Volume: LongWord read GetVolume write SetVolume stored False;
  published
    property Active: Boolean read GetActive write SetActive default False;
    property Capabilities: TPlayerCapabilities read FCapabilities write SetEmptyCapabilities stored False;
    property Device: Integer read FDevice write FDevice default -1;
    property VolumeLeft: Integer read GetVolumeLeft write SetVolumeLeft default -1;
    property VolumeRight: Integer read GetVolumeRight write SetVolumeRight default -1;

    property OnBufferNeeded: TBufferNeededEvent read FOnBufferNeeded write FOnBufferNeeded;
    property OnBufferReleased: TBufferReleasedEvent read FOnBufferReleased write FOnBufferReleased;
  end;

  TAudioManager = class
  private
    FDataFormat: TAudioDataFormat;
    FDevice: Integer;
    FHandle: THandle;
    FPlayerCapabilities: TPlayerCapabilities;
    FRecordCapabilities: TRecorderCapabilities;

    function  GetDeviceCount: Integer;
    function  GetDeviceName(const AIndex: Integer): string;
  protected
    procedure WndProc(var msg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;

    property Device: Integer read FDevice write FDevice;
    property DeviceCount: Integer read GetDeviceCount;
    property DeviceName[const AIndex: Integer]: string read GetDeviceName;
    property Handle: THandle read FHandle;
  end;

  TRecorder = class(TAudio)
  private
    FActive: Boolean;
    FCapabilities: TRecorderCapabilities;
    FDevice: Integer;
    FHandle: HWAVEIN;

    FOnBufferNeeded: TBufferNeededEvent;
    FOnBufferReleased: TBufferReleasedEvent;

    procedure CheckActive;
    procedure CheckInactive;
    function  GetActive: Boolean;
    function  GetDeviceCount: Integer;
    function  GetDeviceName(Device: Integer): string;
    procedure SetActive(Value: Boolean);
    procedure SetEmptyCapabilities(const Value: TRecorderCapabilities);
  protected
    function  BufferNeeded(HeaderPtr: PWaveHdr): Boolean;
    procedure Check(Value: MMRESULT);
    procedure DoProcessEvent(NewBuffers: Boolean); override;
    function  GetErrorText(Error: MMRESULT): string;
    procedure Loaded; override;
    procedure RetrieveBuffers;
    procedure UnprepareHeaders;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Close;
    procedure Open;
    function  PositionInBytes: LongWord;
    function  PositionInMidiTime: LongWord;
    function  PositionInMilliSeconds: LongWord;
    function  PositionInSamples: LongWord;
    procedure PositionInSmpte(var Hours, Minutes, Seconds, Frames, FramesPerSeconds: Byte);
    function  PositionInTicks: LongWord;
    procedure Reset;
    procedure Start;
    procedure Stop;

    property DeviceCount: Integer read GetDeviceCount stored False;
    property DeviceName[Device: Integer]: string read GetDeviceName;
    property Handle: HWAVEIN read FHandle stored False;
  published
    property Active: Boolean read GetActive write SetActive default False;
    property Capabilities: TRecorderCapabilities read FCapabilities write SetEmptyCapabilities stored False;
    property Device: Integer read FDevice write FDevice default -1;

    property OnBufferNeeded: TBufferNeededEvent read FOnBufferNeeded write FOnBufferNeeded;
    property OnBufferReleased: TBufferReleasedEvent read FOnBufferReleased write FOnBufferReleased;
  end;

  procedure Check(Value: MMRESULT);
  function  Load(const FileName: string; var SamplesPerSecond: LongWord; var BitsPerSample, Channels: Word): TByteDynArray;
  procedure Save(const FileName: string; SamplesPerSecond: LongWord; BitsPerSample, Channels: Word; const Data: TByteDynArray);

implementation

uses
  Forms;

{$REGION 'SUPPORTS'}

procedure RaiseError(Code: Integer; const Message: string);
begin
  raise EAudioError.Create(Code, Message);
end;

procedure Check(Value: MMRESULT);
begin
  if Value <> MMSYSERR_NOERROR then
    RaiseError(Value, 'Unknown error ' + IntToStr(Value) + '.');
end;

procedure CheckLastError(Value: Boolean);
var
  LastError: DWord;
begin
  if not Value then
  begin
    LastError := GetLastError;
    if LastError <> 0 then
    begin
      SetLastError(0);
      RaiseError(LastError, SysErrorMessage(LastError));
    end;
  end;
end;

function ConvertFormats(Formats: LongWord): TFormats;
const
  Items: array [TFormat] of LongWord = (
    WAVE_FORMAT_1M08,
    WAVE_FORMAT_1S08,
    WAVE_FORMAT_1M16,
    WAVE_FORMAT_1S16,
    WAVE_FORMAT_2M08,
    WAVE_FORMAT_2S08,
    WAVE_FORMAT_2M16,
    WAVE_FORMAT_2S16,
    WAVE_FORMAT_44M08,
    WAVE_FORMAT_44S08,
    WAVE_FORMAT_44M16,
    WAVE_FORMAT_44S16,
    WAVE_FORMAT_48M08,
    WAVE_FORMAT_48S08,
    WAVE_FORMAT_48M16,
    WAVE_FORMAT_48S16,
    WAVE_FORMAT_96M08,
    WAVE_FORMAT_96S08,
    WAVE_FORMAT_96M16,
    WAVE_FORMAT_96S16
  );
var
  Format: TFormat;
begin
  Result := [];
  for Format := Low(TFormat) to High(TFormat) do
    if Formats and Items[Format] <> 0 then
      Result := Result + [Format];
end;

function ConvertSupports(Supports: LongWord): TSupports;
const
  Items: array [TSupport] of LongWord = (
    WAVECAPS_PITCH,
    WAVECAPS_PLAYBACKRATE,
    WAVECAPS_VOLUME,
    WAVECAPS_LRVOLUME,
    WAVECAPS_SYNC,
    WAVECAPS_SAMPLEACCURATE,
    WAVECAPS_DIRECTSOUND
  );
var
  Support: TSupport;
begin
  Result := [];
  for Support := Low(TSupport) to High(TSupport) do
    if Supports and Items[Support] <> 0 then
      Result := Result + [Support];
end;

const
  RiffID = $46464952;
  WaveID = $45564157;
  FmtID  = $20746d66;
  DataID = $61746164;

type
  TChunk = packed record
    ID: DWord;
    Size: DWord;
  end;

  THeader = packed record
    Wave: DWord; // 'WAVE'
  end;

  TFmt = packed record
    AudioFormat: Word;    // PCM = 1 (Linear quantization)
    NumChannels: Word;    // Mono = 1, Stereo = 2
    SampleRate: DWord;    // 8000, 44100, etc.
    ByteRate: DWord;      // SampleRate * NumChannels * BitsPerSample / 8
    BlockAlign: Word;     // NumChannels * BitsPerSample / 8
    BitsPerSample: Word;  // 8 bits = 8, etc.
  end;

procedure CheckWav(Assert: Boolean);
begin
  if not Assert then
    RaiseError(0, 'Unrecognized PCM wav file');
end;

function Load(const FileName: string; var SamplesPerSecond: LongWord; var BitsPerSample, Channels: Word): TByteDynArray;
var
  Chunk: TChunk;
  Header: THeader;
  Fmt: TFmt;
  WasFmtChunk, WasDataChunk: Boolean;
begin
  with TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone) do
  try
    ReadBuffer(Chunk, SizeOf(Chunk));
    CheckWav(Chunk.ID = RiffID);
    CheckWav(Chunk.Size = Size - SizeOf(TChunk));

    ReadBuffer(Header, SizeOf(Header));
    CheckWav(Header.Wave = WaveID);

    WasFmtChunk := False;
    WasDataChunk := False;
    while Position + SizeOf(Chunk) <= Size do
    begin
      ReadBuffer(Chunk, SizeOf(Chunk));
      if not WasFmtChunk and (Chunk.ID = FmtID) then
      begin
        CheckWav(Chunk.Size >= SizeOf(Fmt));
        ReadBuffer(Fmt, SizeOf(Fmt));
        CheckWav(Fmt.AudioFormat = 1);
        Channels := Fmt.NumChannels;
        SamplesPerSecond := Fmt.SampleRate;
        BitsPerSample := Fmt.BitsPerSample;
        Seek(Chunk.Size - SizeOf(Fmt), soCurrent);
        WasFmtChunk := True;
      end
      else
      if not WasDataChunk and (Chunk.ID = DataID) then
      begin
        SetLength(Result, Chunk.Size);
        ReadBuffer(Result[0], Chunk.Size);
        WasDataChunk := True;
      end
      else
        Seek(Chunk.Size, soCurrent);
    end;

    CheckWav(WasFmtChunk and WasDataChunk);
  finally
    Free;
  end;
end;

procedure Save(const FileName: string; SamplesPerSecond: LongWord; BitsPerSample, Channels: Word; const Data: TByteDynArray);
var
  Chunk: TChunk;
  Header: THeader;
  Fmt: TFmt;
begin
  with TFileStream.Create(FileName, fmCreate) do
  try
    // RIFF chunk
    Chunk.ID := RiffID;
    Chunk.Size := SizeOf(Header) + SizeOf(Chunk) + SizeOf(Fmt) + SizeOf(Chunk) + Length(Data);
    WriteBuffer(Chunk, SizeOf(Chunk));

    Header.Wave := WaveID;
    WriteBuffer(Header, SizeOf(Header));

    // FMT chunk
    Chunk.ID := FmtID;
    Chunk.Size := SizeOf(Fmt);
    WriteBuffer(Chunk, SizeOf(Chunk));

    Fmt.AudioFormat := 1;
    Fmt.NumChannels := Channels;
    Fmt.SampleRate := SamplesPerSecond;
    Fmt.ByteRate := Fmt.SampleRate * Fmt.NumChannels * BitsPerSample div 8;
    Fmt.BlockAlign := Channels * BitsPerSample div 8;
    Fmt.BitsPerSample := BitsPerSample;
    WriteBuffer(Fmt, SizeOf(Fmt));

    // DATA chunk
    Chunk.ID := DataID;
    Chunk.Size := Length(Data);
    WriteBuffer(Chunk, SizeOf(Chunk));

    WriteBuffer(Data[0], Length(Data));
  finally
    Free;
  end;
end;

{$ENDREGION}

{$REGION 'EAudioError'}

constructor EAudioError.Create(ErrorCode: Integer; const Msg: string);
begin
  inherited Create(Msg);
  Self.ErrorCode := ErrorCode;
end;

{$ENDREGION}

{$REGION 'TAudioThread'}

constructor TAudioThread.Create(Audio: TAudio);
begin
  FAudio := Audio;
  CreateEvent;
  inherited Create(False);
  Priority := tpHighest;
end;

procedure TAudioThread.CreateEvent;
begin
  FEvent := Windows.CreateEvent(nil, False, False, nil);
  CheckLastError(FEvent <> 0);
end;

procedure TAudioThread.DestroyEvent;
begin
  if FEvent <> 0 then
    CloseHandle(FEvent);
  FEvent := 0;
end;

procedure TAudioThread.Execute;
begin
  while not Terminated do
  begin
    if WaitForSingleObject(FEvent, INFINITE) = WAIT_OBJECT_0 then
      if not Terminated then
        Synchronize(FAudio.ProcessEvent);
  end;

  DestroyEvent;
end;

procedure TAudioThread.Stop;
begin
  Terminate;

  if FEvent <> 0 then
    SetEvent(FEvent);
end;

{$ENDREGION}

{$REGION 'TAudioDataFormat'}

constructor TAudioDataFormat.Create;
begin
  inherited;

  FWaveFormat.wFormatTag := WAVE_FORMAT_PCM;
  FWaveFormat.cbSize := 0;
  FWaveFormat.nChannels := 1;
  FWaveFormat.nSamplesPerSec := 48000;
  FWaveFormat.wBitsPerSample := 16;
  UpdateWaveFormat;
end;

procedure TAudioDataFormat.Assign(Source: TPersistent);
begin
  if (Source is TAudioDataFormat) then
  begin
    BitsPerSample := TAudioDataFormat(Source).BitsPerSample;
    Channels := TAudioDataFormat(Source).Channels;
    SamplesPerSecond := TAudioDataFormat(Source).SamplesPerSecond;
    UpdateWaveFormat;
  end;
end;

function TAudioDataFormat.GetBitsPerSample: Word;
begin
  Result := FWaveFormat.wBitsPerSample;
end;

function TAudioDataFormat.GetChannels: Word;
begin
  Result := FWaveFormat.nChannels;
end;

function TAudioDataFormat.GetWaveFormat: PWaveFormatEx;
begin
  Result := @FWaveFormat;
end;

function TAudioDataFormat.GetSamplesPerSecond: LongWord;
begin
  Result := FWaveFormat.nSamplesPerSec;
end;

procedure TAudioDataFormat.SetBitsPerSample(Value: Word);
begin
  if Value <> BitsPerSample then
  begin
    FWaveFormat.wBitsPerSample := Value;
    UpdateWaveFormat;
  end;
end;

procedure TAudioDataFormat.SetChannels(Value: Word);
begin
  if Value <> Channels then
  begin
    FWaveFormat.nChannels := Value;
    UpdateWaveFormat;
  end;
end;

procedure TAudioDataFormat.SetSamplesPerSecond(Value: LongWord);
begin
  if Value <> SamplesPerSecond then
  begin
    FWaveFormat.nSamplesPerSec := Value;
    UpdateWaveFormat;
  end;
end;

procedure TAudioDataFormat.UpdateWaveFormat;
begin
  FWaveFormat.nBlockAlign := Channels * (BitsPerSample div 8);
  FWaveFormat.nAvgBytesPerSec := SamplesPerSecond * FWaveFormat.nBlockAlign;
end;

{$ENDREGION}

{$REGION 'TPlayerCapabilities'}

constructor TPlayerCapabilities.Create(Player: TPlayer);
begin
  inherited Create;

  FPlayer := Player;
end;

function TPlayerCapabilities.GetChannels: Word;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(FPlayer.Device, @Capabilities, SizeOf(Capabilities)));
  Result := Capabilities.wChannels;
end;

function TPlayerCapabilities.GetDriverMajorVersion: Byte;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(FPlayer.Device, @Capabilities, SizeOf(Capabilities)));
  Result := HiByte(Capabilities.vDriverVersion);
end;

function TPlayerCapabilities.GetDriverMinorVersion: Byte;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(FPlayer.Device, @Capabilities, SizeOf(Capabilities)));
  Result := LoByte(Capabilities.vDriverVersion);
end;

function TPlayerCapabilities.GetFormats: TFormats;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(FPlayer.Device, @Capabilities, SizeOf(Capabilities)));
  Result := ConvertFormats(Capabilities.dwFormats);
end;

function TPlayerCapabilities.GetManufacturer: Word;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(FPlayer.Device, @Capabilities, SizeOf(Capabilities)));
  Result := LoByte(Capabilities.wMid);
end;

function TPlayerCapabilities.GetProduct: Word;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(FPlayer.Device, @Capabilities, SizeOf(Capabilities)));
  Result := LoByte(Capabilities.wPid);
end;

function TPlayerCapabilities.GetProductName: string;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(FPlayer.Device, @Capabilities, SizeOf(Capabilities)));
  Result := Capabilities.szPname;
end;

function TPlayerCapabilities.GetSupports: TSupports;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(FPlayer.Device, @Capabilities, SizeOf(Capabilities)));
  Result := ConvertSupports(Capabilities.dwSupport);
end;

procedure TPlayerCapabilities.SetEmptyByte(const Value: Byte);
begin
end;

procedure TPlayerCapabilities.SetEmptyWord(const Value: Word);
begin
end;

procedure TPlayerCapabilities.SetEmptyFormats(const Value: TFormats);
begin
end;

procedure TPlayerCapabilities.SetEmptyString(const Value: string);
begin
end;

procedure TPlayerCapabilities.SetEmptySupports(const Value: TSupports);
begin
end;

{$ENDREGION}

{$REGION 'TRecorderCapabilities'}

constructor TRecorderCapabilities.Create(Recorder: TRecorder);
begin
  inherited Create;

  FRecorder := Recorder;
end;

function TRecorderCapabilities.GetChannels: Word;
var
  Capabilities: WAVEINCAPS;
begin
  Check(waveInGetDevCaps(FRecorder.Device, @Capabilities, SizeOf(Capabilities)));
  Result := Capabilities.wChannels;
end;

function TRecorderCapabilities.GetDriverMajorVersion: Byte;
var
  Capabilities: WAVEINCAPS;
begin
  Check(waveInGetDevCaps(FRecorder.Device, @Capabilities, SizeOf(Capabilities)));
  Result := HiByte(Capabilities.vDriverVersion);
end;

function TRecorderCapabilities.GetDriverMinorVersion: Byte;
var
  Capabilities: WAVEINCAPS;
begin
  Check(waveInGetDevCaps(FRecorder.Device, @Capabilities, SizeOf(Capabilities)));
  Result := LoByte(Capabilities.vDriverVersion);
end;

function TRecorderCapabilities.GetFormats: TFormats;
var
  Capabilities: WAVEINCAPS;
begin
  Check(waveInGetDevCaps(FRecorder.Device, @Capabilities, SizeOf(Capabilities)));
  Result := ConvertFormats(Capabilities.dwFormats);
end;

function TRecorderCapabilities.GetManufacturer: Word;
var
  Capabilities: WAVEINCAPS;
begin
  Check(waveInGetDevCaps(FRecorder.Device, @Capabilities, SizeOf(Capabilities)));
  Result := LoByte(Capabilities.wMid);
end;

function TRecorderCapabilities.GetProduct: Word;
var
  Capabilities: WAVEINCAPS;
begin
  Check(waveInGetDevCaps(FRecorder.Device, @Capabilities, SizeOf(Capabilities)));
  Result := LoByte(Capabilities.wPid);
end;

function TRecorderCapabilities.GetProductName: string;
var
  Capabilities: WAVEINCAPS;
begin
  Check(waveInGetDevCaps(FRecorder.Device, @Capabilities, SizeOf(Capabilities)));
  Result := Capabilities.szPname;
end;

procedure TRecorderCapabilities.SetEmptyByte(Value: Byte);
begin
end;

procedure TRecorderCapabilities.SetEmptyWord(Value: Word);
begin
end;

procedure TRecorderCapabilities.SetEmptyFormats(const Value: TFormats);
begin
end;

procedure TRecorderCapabilities.SetEmptyString(const Value: string);
begin
end;

{$ENDREGION}

{$REGION 'TAudio'}

procedure TAudio.ClearHeaders;
var
  i: Integer;
begin
  for i := Low(FHeaders) to High(FHeaders) do
    FillChar(FHeaders[i], SizeOf(FHeaders[i]), 0);
  HeadersInit;
end;

procedure TAudio.CreateThread;
begin
  if FThread = nil then
  begin
    FThread := TAudioThread.Create(Self);
    if FThread = nil then
      RaiseError(0, 'Can''t create thread');
  end;
end;

procedure TAudio.DestroyThread;
begin
  if FThread <> nil then
    try
      FThread.Stop;
    finally
      FThread := nil;
    end;
end;

procedure TAudio.ProcessEvent;
begin
  DoProcessEvent(True);
end;

procedure TAudio.HeadersInit;
begin
  FHeadersStart := 0;
  FHeadersSize := 0;
end;

function TAudio.HeadersCount: Integer;
begin
  Result := High(FHeaders) - Low(FHeaders) + 1;
end;

function TAudio.HeadersIsEmpty: Boolean;
begin
  Result := FHeadersSize = 0;
end;

function TAudio.HeadersIsFull: Boolean;
begin
  Result := FHeadersSize = HeadersCount;
end;

function TAudio.HeadersPush: PWaveHdr;
begin
  if HeadersIsFull then
    Result := nil
  else
  begin
    Result := @FHeaders[(FHeadersStart + FHeadersSize) mod HeadersCount];
    Inc(FHeadersSize);
  end
end;

procedure TAudio.HeadersUndoPush;
begin
  Dec(FHeadersSize);
end;

function TAudio.HeadersPop: PWaveHdr;
begin
  Result := HeadersPeek;
  if Result <> nil then
  begin
    FHeadersStart := (FHeadersStart + 1) mod HeadersCount;
    Dec(FHeadersSize);
  end
end;

function TAudio.HeadersPeek: PWaveHdr;
begin
  if HeadersIsEmpty then
    Result := nil
  else
    Result := @FHeaders[FHeadersStart];
end;

procedure TAudio.SetEmptyDataFormat(const Value: TAudioDataFormat);
begin
end;

{$ENDREGION}

{$REGION 'TPlayer'}

constructor TPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCapabilities := TPlayerCapabilities.Create(Self);
  FDataFormat := TAudioDataFormat.Create;
  FDevice := MapperDevice;
  FVolumeLeft := -1;
  FVolumeRight := -1;
end;

destructor TPlayer.Destroy;
begin
  Close;
  FCapabilities.Free;
  FDataFormat.Free;

  inherited Destroy;
end;

procedure TPlayer.BreakLoop;
begin
  CheckActive;
  Check(waveOutBreakLoop(FHandle));
end;

function TPlayer.BufferNeeded(HeaderPtr: PWaveHdr): Boolean;
begin
  Result := False;
  if Assigned(FOnBufferNeeded) then
  begin
    FillChar(HeaderPtr^, SizeOf(HeaderPtr^), 0);
    FOnBufferNeeded(Self, Pointer(HeaderPtr.lpData), HeaderPtr.dwBufferLength);
    if (HeaderPtr.lpData <> nil) and (HeaderPtr.dwBufferLength <> 0) then
    begin
      Check(waveOutPrepareHeader(FHandle, HeaderPtr, SizeOf(HeaderPtr^)));
      Check(waveOutWrite(FHandle, HeaderPtr, SizeOf(HeaderPtr^)));
      Result := True;
    end;
  end;
end;

procedure TPlayer.Check(Value: MMRESULT);
var
  ErrorMessage: string;
begin
  if Value <> MMSYSERR_NOERROR then
  begin
    ErrorMessage := GetErrorText(Value);
    if ErrorMessage <> '' then
      raise EAudioError.Create(Value, ErrorMessage)
    else
      AudioCS.Check(Value);
  end;
end;

procedure TPlayer.CheckActive;
begin
  if not Active then
    RaiseError(0, 'Can''t perform this operation on a closed player');
end;

procedure TPlayer.CheckInactive;
begin
  if Active then
    RaiseError(0, 'Can''t perform this operation on an opened player');
end;

procedure TPlayer.Close;
begin
  if Active then
    try
      Stop;
      UnprepareHeaders;
      Check(waveOutClose(FHandle));
    finally
      FHandle := 0;
      DestroyThread;
    end;
end;

procedure TPlayer.DoProcessEvent(NewBuffers: Boolean);
var
  HeaderPtr: PWaveHdr;
begin
  repeat
    HeaderPtr := HeadersPeek;
    if HeaderPtr <> nil then
      if HeaderPtr.dwFlags and WHDR_DONE = WHDR_DONE then
      begin
        HeadersPop;
        Check(waveOutUnprepareHeader(FHandle, HeaderPtr, SizeOf(HeaderPtr^)));
        HeaderPtr.dwFlags := 0;
        FreeMem(HeaderPtr.lpData);
        Dispose(HeaderPtr);
      end
      else
        HeaderPtr := nil;
  until HeaderPtr = nil;
end;

function TPlayer.GetActive: Boolean;
begin
  if csDesigning in ComponentState then
    Result := FActive
  else
    Result := FHandle <> 0;
end;

function TPlayer.GetDeviceCount: Integer;
begin
  Result := waveOutGetNumDevs;
end;

function TPlayer.GetDeviceName(Device: Integer): string;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(Device, @Capabilities, SizeOf(Capabilities)));
  Result := Capabilities.szPname;
end;

function TPlayer.GetErrorText(Error: MMRESULT): string;
var
  Buffer: string;
begin
  SetLength(Buffer, MAXERRORLENGTH);
  Check(waveOutGetErrorText(Error, @Buffer[1], MAXERRORLENGTH));
  Result := PChar(Buffer);
end;

function TPlayer.GetPitch: Double;
begin
  Result := PitchValue / $10000;
end;

function TPlayer.GetPitchValue: LongWord;
begin
  CheckActive;
  Check(waveOutGetPitch(FHandle, @Result));
end;

function TPlayer.GetPlaybackRate: Double;
begin
  Result := PlaybackRateValue / $10000;
end;

function TPlayer.GetPlaybackRateValue: LongWord;
begin
  CheckActive;
  Check(waveOutGetPlaybackRate(FHandle, @Result));
end;

function TPlayer.GetVolume: LongWord;
begin
  if Active and not(csDesigning in ComponentState) then
    Check(waveOutGetVolume(FHandle, @Result))
  else
    Result := (FVolumeRight shl 16) or (FVolumeLeft and $FFFF);
end;

function TPlayer.GetVolumeLeft: Integer;
begin
  if Active and not(csDesigning in ComponentState) then
    Result := Volume and $FFFF
  else
    Result := FVolumeLeft
end;

function TPlayer.GetVolumeRight: Integer;
begin
  if Active and not(csDesigning in ComponentState) then
    Result := (Volume shr 16) and $FFFF
  else
    Result := FVolumeRight
end;

procedure TPlayer.Loaded;
begin
  inherited;

  SetActive(FActive);
end;

procedure TPlayer.Open;
begin
  CheckInactive;
  ClearHeaders;
  CreateThread;

  Check(waveOutOpen(@FHandle, Device, DataFormat.GetWaveFormat, FThread.FEvent, DWORD_PTR(Self), CALLBACK_EVENT));
  SetVolume((FVolumeRight shl 16) or (FVolumeLeft and $FFFF));
end;

procedure TPlayer.Pause;
begin
  CheckActive;
  Check(waveOutPause(FHandle));
end;

procedure TPlayer.Play;
begin
  CheckActive;
  RetrieveBuffers;
end;

procedure TPlayer.Play(const ABuffer: Pointer; const ASize: Integer);
var
  HeaderPtr: PWaveHdr;
begin
  New(HeaderPtr);
  FillChar(HeaderPtr^, SizeOf(HeaderPtr^), 0);
  GetMem(HeaderPtr.lpData, ASize);
  Move(ABuffer^, HeaderPtr.lpData^, ASize);
  HeaderPtr.dwBufferLength := ASize;

  Check(waveOutPrepareHeader(FHandle, HeaderPtr, SizeOf(HeaderPtr^)));
  Check(waveOutWrite(FHandle, HeaderPtr, SizeOf(HeaderPtr^)));
end;

function TPlayer.PositionInBytes: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_BYTES;
  Check(waveOutGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_BYTES then
    Result := Time.cb
  else
    Result := 0
end;

function TPlayer.PositionInMidiTime: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_MIDI;
  Check(waveOutGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_MIDI then
    Result := Time.songptrpos
  else
    Result := 0
end;

function TPlayer.PositionInMilliSeconds: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_MS;
  Check(waveOutGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_MS then
    Result := Time.ms
  else
    Result := 0
end;

function TPlayer.PositionInSamples: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_SAMPLES;
  Check(waveOutGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_SAMPLES then
    Result := Time.sample
  else
    Result := 0
end;

function TPlayer.PositionInTicks: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_TICKS;
  Check(waveOutGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_TICKS then
    Result := Time.ticks
  else
    Result := 0
end;

procedure TPlayer.PositionInSmpte(var Hours, Minutes, Seconds, Frames, FramesPerSeconds: Byte);
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_SMPTE;
  Check(waveOutGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_SMPTE then
  begin
  {$ifdef FPC}
    Hours := Time.smpte.hour;
    Minutes := Time.smpte.min;
    Seconds := Time.smpte.sec;
    Frames := Time.smpte.frame;
    FramesPerSeconds := Time.smpte.fps;
  {$else}
    Hours := Time.hour;
    Minutes := Time.min;
    Seconds := Time.sec;
    Frames := Time.frame;
    FramesPerSeconds := Time.fps;
  {$endif FPC}
  end
  else
  begin
    Hours := 0;
    Minutes := 0;
    Seconds := 0;
    Frames := 0;
    FramesPerSeconds := 0;
  end;
end;

procedure TPlayer.Resume;
begin
  CheckActive;
  Check(waveOutRestart(FHandle));
end;

procedure TPlayer.RetrieveBuffers;
var
  HeaderPtr: PWaveHdr;
begin
  if Active then
    repeat
      HeaderPtr := HeadersPush;
      if HeaderPtr <> nil then
        if not BufferNeeded(HeaderPtr) then
        begin
          HeadersUndoPush;
          HeaderPtr := nil;
        end;
    until HeaderPtr = nil;
end;

procedure TPlayer.SetActive(Value: Boolean);
begin
  if Value <> Active then
    if not(csReading in ComponentState) then
      if not(csDesigning in ComponentState) then
        if Value then
          Open
        else
          Close;

  FActive := Value;
end;

procedure TPlayer.SetEmptyCapabilities(const Value: TPlayerCapabilities);
begin
end;

procedure TPlayer.SetPitch(Value: Double);
begin
  PitchValue := Round(Value * $10000);
end;

procedure TPlayer.SetPitchValue(Value: LongWord);
begin
  CheckActive;
  Check(waveOutSetPitch(FHandle, Value));
end;

procedure TPlayer.SetPlaybackRate(Value: Double);
begin
  PlaybackRateValue := Round(Value * $10000)
end;

procedure TPlayer.SetPlaybackRateValue(Value: LongWord);
begin
  CheckActive;
  Check(waveOutSetPlaybackRate(FHandle, Value));
end;

procedure TPlayer.SetVolume(Value: LongWord);
begin
  if Active and not(csDesigning in ComponentState) then
    Check(waveOutSetVolume(FHandle, Value));
end;

procedure TPlayer.SetVolumeLeft(Value: Integer);
begin
  if Value <> FVolumeLeft then
  begin
    FVolumeLeft := Value;
    if FVolumeLeft <> -1 then
      Volume := (VolumeRight shl 16) or Value;
  end
end;

procedure TPlayer.SetVolumeRight(Value: Integer);
begin
  if Value <> FVolumeRight then
  begin
    FVolumeRight := Value;
    if FVolumeRight <> -1 then
      Volume := (Value shl 16) or VolumeLeft;
  end
end;

procedure TPlayer.Stop;
begin
  CheckActive;
  Check(waveOutReset(FHandle));
  DoProcessEvent(False);
  ClearHeaders;
end;

procedure TPlayer.UnprepareHeaders;
begin
  for var i := Low(FHeaders) to High(FHeaders) do
    if FHeaders[i].dwFlags and WHDR_PREPARED = WHDR_PREPARED then
      Check(waveOutUnprepareHeader(FHandle, @FHeaders[i], SizeOf(FHeaders[i])));
  ClearHeaders;
end;

{$ENDREGION'}

{$REGION 'TRecorder'}

constructor TRecorder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCapabilities := TRecorderCapabilities.Create(Self);
  FDataFormat := TAudioDataFormat.Create;
  FDevice := MapperDevice;
end;

destructor TRecorder.Destroy;
begin
  Close;
  FCapabilities.Free;
  FDataFormat.Free;

  inherited Destroy;
end;

function TRecorder.BufferNeeded(HeaderPtr: PWaveHdr): Boolean;
begin
  Result := False;

  if Assigned(FOnBufferNeeded) then
  begin
    FillChar(HeaderPtr^, SizeOf(HeaderPtr^), 0);
    FOnBufferNeeded(Self, Pointer(HeaderPtr.lpData), HeaderPtr.dwBufferLength);
    if (HeaderPtr.lpData <> nil) and (HeaderPtr.dwBufferLength <> 0) then
    begin
      Check(waveInPrepareHeader(FHandle, HeaderPtr, SizeOf(HeaderPtr^)));
      Check(waveInAddBuffer(FHandle, HeaderPtr, SizeOf(HeaderPtr^)));
      Result := True;
    end;
  end;
end;

procedure TRecorder.Check(Value: MMRESULT);
var
  ErrorMessage: string;
begin
  if Value <> MMSYSERR_NOERROR then
  begin
    ErrorMessage := GetErrorText(Value);
    if ErrorMessage <> '' then
      raise EAudioError.Create(Value, ErrorMessage)
    else
      AudioCS.Check(Value);
  end;
end;

procedure TRecorder.CheckActive;
begin
  if not Active then
    raise EAudioError.Create(0, 'Can''t perform this operation on a closed recorder');
end;

procedure TRecorder.CheckInactive;
begin
  if Active then
    raise EAudioError.Create(0, 'Can''t perform this operation on an opened recorder');
end;

procedure TRecorder.Close;
begin
  if Active then
    try
      Reset;
      UnprepareHeaders;
      Check(waveInClose(FHandle));
    finally
      FHandle := 0;
      DestroyThread;
    end;
end;

procedure TRecorder.DoProcessEvent(NewBuffers: Boolean);
var
  HeaderPtr: PWaveHdr;
begin
  repeat
    HeaderPtr := HeadersPeek;
    if HeaderPtr <> nil then
      if HeaderPtr.dwFlags and WHDR_DONE = WHDR_DONE then
      begin
        HeadersPop;
        Check(waveInUnprepareHeader(FHandle, HeaderPtr, SizeOf(HeaderPtr^)));
        HeaderPtr.dwFlags := 0;
        if Assigned(FOnBufferReleased) then
          FOnBufferReleased(Self, HeaderPtr.lpData, HeaderPtr.dwBytesRecorded);
      end
      else
        HeaderPtr := nil;
  until HeaderPtr = nil;

  if NewBuffers then
    RetrieveBuffers;
end;

function TRecorder.GetActive: Boolean;
begin
  if csDesigning in ComponentState then
    Result := FActive
  else
    Result := FHandle <> 0;
end;

function TRecorder.GetDeviceCount: Integer;
begin
  Result := waveInGetNumDevs;
end;

function TRecorder.GetDeviceName(Device: Integer): string;
var
  Capabilities: WAVEINCAPS;
begin
  Check(waveInGetDevCaps(Device, @Capabilities, SizeOf(Capabilities)));
  Result := Capabilities.szPname;
end;

function TRecorder.GetErrorText(Error: MMRESULT): string;
var
  Buffer: string;
begin
  SetLength(Buffer, MAXERRORLENGTH);
  Check(waveInGetErrorText(Error, @Buffer[1], MAXERRORLENGTH));
  Result := PChar(Buffer);
end;

procedure TRecorder.Loaded;
begin
  inherited;

  SetActive(FActive);
end;

procedure TRecorder.Open;
begin
  CheckInactive;
  ClearHeaders;
  CreateThread;
  Check(waveInOpen(@FHandle, Device, DataFormat.GetWaveFormat, FThread.FEvent, DWORD_PTR(Self), CALLBACK_EVENT));
end;

function TRecorder.PositionInBytes: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_BYTES;
  Check(waveInGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_BYTES then
    Result := Time.cb
  else
    Result := 0
end;

function TRecorder.PositionInMidiTime: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_MIDI;
  Check(waveInGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_MIDI then
    Result := Time.songptrpos
  else
    Result := 0
end;

function TRecorder.PositionInMilliSeconds: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_MS;
  Check(waveInGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_MS then
    Result := Time.ms
  else
    Result := 0
end;

function TRecorder.PositionInSamples: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_SAMPLES;
  Check(waveInGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_SAMPLES then
    Result := Time.sample
  else
    Result := 0
end;

procedure TRecorder.PositionInSmpte(var Hours, Minutes, Seconds, Frames, FramesPerSeconds: Byte);
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_SMPTE;
  Check(waveInGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_SMPTE then
  begin
  {$ifdef FPC}
    Hours := Time.smpte.hour;
    Minutes := Time.smpte.min;
    Seconds := Time.smpte.sec;
    Frames := Time.smpte.frame;
    FramesPerSeconds := Time.smpte.fps;
  {$else}
    Hours := Time.hour;
    Minutes := Time.min;
    Seconds := Time.sec;
    Frames := Time.frame;
    FramesPerSeconds := Time.fps;
  {$endif FPC}
  end
  else
  begin
    Hours := 0;
    Minutes := 0;
    Seconds := 0;
    Frames := 0;
    FramesPerSeconds := 0;
  end
end;

function TRecorder.PositionInTicks: LongWord;
var
  Time: MMTIME;
begin
  CheckActive;
  Time.wType := TIME_TICKS;
  Check(waveInGetPosition(FHandle, @Time, SizeOf(Time)));
  if Time.wType = TIME_TICKS then
    Result := Time.ticks
  else
    Result := 0
end;

procedure TRecorder.Reset;
begin
  CheckActive;
  Check(waveInReset(FHandle));
  DoProcessEvent(False);
  ClearHeaders;
end;

procedure TRecorder.RetrieveBuffers;
var
  HeaderPtr: PWaveHdr;
begin
  if Active then
    repeat
      HeaderPtr := HeadersPush;
      if HeaderPtr <> nil then
        if not BufferNeeded(HeaderPtr) then
        begin
          HeadersUndoPush;
          HeaderPtr := nil;
        end;
    until HeaderPtr = nil;
end;

procedure TRecorder.SetActive(Value: Boolean);
begin
  if Value <> Active then
    if not(csReading in ComponentState) then
      if not(csDesigning in ComponentState) then
        if Value then
          Open
        else
          Close;

  FActive := Value;
end;

procedure TRecorder.SetEmptyCapabilities(const Value: TRecorderCapabilities);
begin
end;

procedure TRecorder.Start;
begin
  CheckActive;
  Check(waveInStart(FHandle));
  RetrieveBuffers;
end;

procedure TRecorder.Stop;
begin
  CheckActive;
  Check(waveInStop(FHandle));
  DoProcessEvent(False);
  ClearHeaders;
end;

procedure TRecorder.UnprepareHeaders;
var
  i: Integer;
begin
  for i := Low(FHeaders) to High(FHeaders) do
    if FHeaders[i].dwFlags and WHDR_PREPARED = WHDR_PREPARED then
      Check(waveInUnprepareHeader(FHandle, @FHeaders[i], SizeOf(FHeaders[i])));
  ClearHeaders;
end;

{$ENDREGION}

{ TAudioManager }

constructor TAudioManager.Create;
begin
  FDataFormat := TAudioDataFormat.Create;
  FDevice := -1;
  FHandle := AllocateHWnd(WndProc);
end;

destructor TAudioManager.Destroy;
begin
  FDataFormat.Free;
  DeallocateHWnd(FHandle);

  inherited;
end;

function TAudioManager.GetDeviceCount: Integer;
begin
  Result := waveOutGetNumDevs;
end;

function TAudioManager.GetDeviceName(const AIndex: Integer): string;
var
  Capabilities: WAVEOUTCAPS;
begin
  Check(waveOutGetDevCaps(Device, @Capabilities, SizeOf(Capabilities)));
  Result := Capabilities.szPname;
end;

procedure TAudioManager.WndProc(var msg: TMessage);
begin
  if Msg.Msg = WM_USER then
  else
    DefWindowProc(FHandle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

end.
