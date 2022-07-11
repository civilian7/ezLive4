unit UDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, AudioCS, uLibOpus;

const
  UM_STOP = WM_APP + 1;
  
type
  TFormDemo = class(TForm)
    LabelInput: TLabel;
    ComboBoxInput: TComboBox;
    LabelOutput: TLabel;
    ComboBoxOutput: TComboBox;
    LabelSamplesPerSecond: TLabel;
    ComboBoxSamplesPerSecond: TComboBox;
    ButtonRecord: TButton;
    ButtonPlay: TButton;
    ButtonStop: TButton;
    ButtonPause: TButton;
    ButtonResume: TButton;
    LabelBitsPerSample: TLabel;
    ComboBoxBitsPerSample: TComboBox;
    LabelChannels: TLabel;
    ComboBoxChannels: TComboBox;
    TrackBarLeftVolume: TTrackBar;
    TrackBarRightVolume: TTrackBar;
    LabelLeftVolume: TLabel;
    LabelRightVolume: TLabel;
    LabelSamples: TLabel;
    Timer: TTimer;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRecordClick(Sender: TObject);
    procedure ButtonPlayClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonPauseClick(Sender: TObject);
    procedure ButtonResumeClick(Sender: TObject);
    procedure TrackBarLeftVolumeChange(Sender: TObject);
    procedure TrackBarRightVolumeChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Player: TPlayer;
    Recorder: TRecorder;
    OpusDecoder: TOpusDecoder;
    OpusEncoder: TOpusEncoder;

    procedure DisableComboBoxes;
    procedure EnableComboBoxes;
    procedure GetComboBoxes(DataFormat: TAudioDataFormat);
    procedure SetComboBoxes(SamplesPerSecond: LongWord; BitsPerSample: Word; Channels: Word);
    procedure PlayerBufferNeeded(Sender: TObject; var Buffer: Pointer; var Size: Cardinal);
    procedure PlayerBufferReleased(Sender: TObject; Buffer: Pointer; Size: Cardinal);
    procedure RecorderBufferNeeded(Sender: TObject; var Buffer: Pointer; var Size: Cardinal);
    procedure RecorderBufferReleased(Sender: TObject; Buffer: Pointer; Size: Cardinal);
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;

    procedure Stop(var Msg: TMessage); message UM_STOP;
  end;

var
  FormDemo: TFormDemo;

implementation

{$R *.dfm}

uses Types;

const
  cFRAME_SIZE = 960;
  cSAMPLE_RATE = 48000;
  cCHANNELS = 1;
  cAPPLICATION = OPUS_APPLICATION_AUDIO;
  cBITRATE = 64000;
  cMAX_FRAME_SIZE = 6 * 960;
  cMAX_PACKET_SIZE = 3 * 1276;

type
  TBuffer = array [0..1920*cCHANNELS-1] of Byte;

var
  Buffers: TList; // audio data stored as list of buffers
  RecordSize: Integer; // lengh of recorded audio data
  PlaySize: Integer; // current size of played audio data
  PlayBuffer: Integer; // current buffer when playing audio
  PCMIn: array [0..cFRAME_SIZE * cCHANNELS - 1] of SmallInt;
  PCMOut: array [0..cMAX_FRAME_SIZE * cCHANNELS - 1] of SmallInt;
  cbits: array [0..cMAX_PACKET_SIZE - 1] of Byte;
  pcm_bytes: array [0..cMAX_FRAME_SIZE * cCHANNELS * SizeOf(SmallInt) - 1] of Byte;
  ss : TFileStream;
  zz: TFileStream;

constructor TFormDemo.Create(Aowner: TComponent);
begin
  inherited;

  LoadLibOpus;

  var err: Integer;
  OpusEncoder := opus_encoder_create(cSAMPLE_RATE, cCHANNELS, OPUS_APPLICATION_AUDIO, err);
  if err < 0 then
    raise Exception.Create('Error Message');

  err := opus_encoder_ctl(OpusEncoder, OPUS_SET_BITRATE(cBITRATE));
  if err < 0 then
    raise Exception.Create('Error Message');

  OpusDecoder := opus_decoder_create(cSAMPLE_RATE, cCHANNELS, err);
  if err < 0 then
    raise Exception.Create('Error Message');

  Player := TPlayer.Create(Self);
  //Player.OnBufferNeeded := PlayerBufferNeeded;
  //Player.OnBufferReleased := PlayerBufferReleased;

  Recorder := TRecorder.Create(Self);
  Recorder.OnBufferNeeded := RecorderBufferNeeded;
  Recorder.OnBufferReleased := RecorderBufferReleased;
end;

destructor TFormDemo.Destroy;
begin
  Opus_encoder_destroy(OpusEncoder);
  Opus_decoder_Destroy(OpusDecoder);

  Player.Free;
  Recorder.Free;

  inherited;
end;

procedure TFormDemo.DisableComboBoxes;
begin
  ComboBoxInput.Enabled := False;
  ComboBoxOutput.Enabled := False;
  ComboBoxSamplesPerSecond.Enabled := False;
  ComboBoxBitsPerSample.Enabled := False;
  ComboBoxChannels.Enabled := False;
end;

procedure TFormDemo.EnableComboBoxes;
begin
  ComboBoxInput.Enabled := True;
  ComboBoxOutput.Enabled := True;
  ComboBoxSamplesPerSecond.Enabled := True;
  ComboBoxBitsPerSample.Enabled := True;
  ComboBoxChannels.Enabled := True;
end;

procedure TFormDemo.GetComboBoxes(DataFormat: TAudioDataFormat);
begin
  DataFormat.SamplesPerSecond := StrToInt(ComboBoxSamplesPerSecond.Text);
  DataFormat.BitsPerSample := StrToInt(ComboBoxBitsPerSample.Text);
  DataFormat.Channels := StrToInt(ComboBoxChannels.Text);
end;

procedure TFormDemo.SetComboBoxes(SamplesPerSecond: LongWord; BitsPerSample: Word; Channels: Word);
begin
  with ComboBoxSamplesPerSecond do
    ItemIndex := Items.IndexOf(IntToStr(SamplesPerSecond));

  with ComboBoxBitsPerSample do
    ItemIndex := Items.IndexOf(IntToStr(BitsPerSample));

  with ComboBoxChannels do
    ItemIndex := Items.IndexOf(IntToStr(Channels));
end;

procedure ClearBuffers;
var
  i: Integer;
  Buffer: ^TBuffer;
begin
  for i := 0 to Buffers.Count - 1 do
  begin
    Buffer := Buffers[i];
    Dispose(Buffer);
  end;
  Buffers.Clear;
end;

procedure TFormDemo.FormCreate(Sender: TObject);
var i: Integer;
begin
  Buffers := TList.Create;

  ComboBoxInput.Items.Add(AudioCS.MapperDeviceName);
  for i := 0 to Recorder.DeviceCount - 1 do
    ComboBoxInput.Items.Add(Recorder.DeviceName[i]);
  ComboBoxInput.ItemIndex := 0;

  ComboBoxOutput.Items.Add(AudioCS.MapperDeviceName);
  for i := 0 to Player.DeviceCount - 1 do
    ComboBoxOutput.Items.Add(Player.DeviceName[i]);
  ComboBoxOutput.ItemIndex := 0;

  TrackBarLeftVolume.Position := Player.VolumeLeft;
  TrackBarRightVolume.Position := Player.VolumeRight;
end;

procedure TFormDemo.ButtonRecordClick(Sender: TObject);
begin
ss := TFileStream.Create('d:\1111.opus', fmCreate);
zz := TFileStream.Create('d:\1111.pcm', fmCreate);



  ButtonRecord.Enabled := False;
  ButtonPlay.Enabled := False;
  ButtonStop.Enabled := True;
  DisableComboBoxes;
  ClearBuffers;
  RecordSize := 0;
  Recorder.Device := ComboBoxInput.ItemIndex - 1;
  GetComboBoxes(Recorder.DataFormat);
  Recorder.Open;
  SetComboBoxes(Recorder.DataFormat.SamplesPerSecond, Recorder.DataFormat.BitsPerSample, Recorder.DataFormat.Channels);
  Recorder.Start;

  Player.Device := ComboBoxOutput.ItemIndex - 1;
  GetComboBoxes(Player.DataFormat);

  Player.Open;
end;

procedure TFormDemo.ButtonPlayClick(Sender: TObject);
begin
  ButtonRecord.Enabled := False;
  ButtonPlay.Enabled := False;
  ButtonStop.Enabled := True;
  ButtonPause.Enabled := True;
  DisableComboBoxes;
  PlaySize := 0;
  PlayBuffer := 0;
  Player.Device := ComboBoxOutput.ItemIndex - 1;
  GetComboBoxes(Player.DataFormat);
  Player.Open;
  TrackBarLeftVolume.Position := Player.VolumeLeft;
  TrackBarRightVolume.Position := Player.VolumeRight;
  Player.Play;
end;

procedure TFormDemo.ButtonStopClick(Sender: TObject);
begin
ss.Free;
ss := nil;

zz.Free;
zz := nil;
  if Recorder.Active then
    Recorder.Active := False;
  if Player.Active then
    Player.Active := False;
  ButtonRecord.Enabled := True;
  ButtonPlay.Enabled := True;
  ButtonStop.Enabled := False;
  ButtonPause.Enabled := False;
  ButtonResume.Enabled := False;
  ButtonSave.Enabled := RecordSize > 0;
  EnableComboBoxes;
end;

procedure TFormDemo.ButtonPauseClick(Sender: TObject);
begin
  Player.Pause;
  ButtonPause.Enabled := False;
  ButtonResume.Enabled := True;
end;

procedure TFormDemo.ButtonResumeClick(Sender: TObject);
begin
  Player.Resume;
  ButtonPause.Enabled := True;
  ButtonResume.Enabled := False;
end;

procedure TFormDemo.RecorderBufferNeeded(Sender: TObject; var Buffer: Pointer; var Size: Cardinal);
var
  MyBuffer: ^TBuffer;
begin
  New(MyBuffer);
  Buffers.Add(MyBuffer);

  Buffer := MyBuffer;
  Size := SizeOf(TBuffer);

  Caption := InttoStr(GetTickCount);
end;

procedure TFormDemo.RecorderBufferReleased(Sender: TObject; Buffer: Pointer; Size: Cardinal);
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

  if Assigned(ss) then
    ss.Write(cBits[0], nBytes);

  frame_size := opus_decode(OpusDecoder, cbits, nBytes, PCMOut, cMAX_FRAME_SIZE, 0);
  nSamples := frame_size * cChannels;
  // Convert to little-endian ordering
  for var i := 0 to nSamples - 1 do
  begin
    pcm_bytes[2*i] := Lo(PCMOut[i]);
    pcm_bytes[2*i+1] := Hi(PCMOut[i]);
  end;

  nBytes := nSamples * SizeOf(SmallInt);
  Player.Play(@pcm_bytes[0], nBytes);
  if Assigned(zz) then
    zz.Write(pcm_bytes[0], nBytes);

//
//  Player.Play(Buffer, Size);
  Inc(RecordSize, Size);
end;

procedure TFormDemo.PlayerBufferNeeded(Sender: TObject; var Buffer: Pointer; var Size: Cardinal);
var
  RestSize: Integer;
begin
  if PlayBuffer >= Buffers.Count then
    Exit;

  Buffer := Buffers[PlayBuffer];
  Size := SizeOf(TBuffer);

  RestSize := RecordSize - PlayBuffer * SizeOf(TBuffer);
  if RestSize < 0 then
    RestSize := 0;
  if Integer(Size) > RestSize then
    Size := RestSize;

  Inc(PlayBuffer);
end;

procedure TFormDemo.PlayerBufferReleased(Sender: TObject; Buffer: Pointer; Size: Cardinal);
begin
  Inc(PlaySize, Size);

  if PlaySize >= RecordSize then
    PostMessage(Handle, UM_STOP, 0, 0); // call Stop method
end;

procedure TFormDemo.Stop(var Msg: TMessage);
begin
  ButtonStop.Click;
end;

procedure TFormDemo.TrackBarLeftVolumeChange(Sender: TObject);
begin
  Player.VolumeLeft := TrackBarLeftVolume.Position;
end;

procedure TFormDemo.TrackBarRightVolumeChange(Sender: TObject);
begin
  Player.VolumeRight := TrackBarRightVolume.Position;
end;

procedure TFormDemo.TimerTimer(Sender: TObject);
begin
//  if Player.Active then
//    LabelSamples.Caption := 'Samples: ' + IntToStr(Player.PositionInSamples)
//  else if Recorder.Active then
//    LabelSamples.Caption := 'Samples: ' + IntToStr(Recorder.PositionInSamples)
//  else
//    LabelSamples.Caption := '';
end;

procedure TFormDemo.ButtonSaveClick(Sender: TObject);
var
  Data: TByteDynArray;
  i, Index, Count: Integer;
begin
  if SaveDialog.Execute then
  begin
    // copy data from buffers
    SetLength(Data, RecordSize);
    Index := 0;
    for i := 0 to Buffers.Count - 1 do
    begin
      Count := RecordSize - Index;
      if Count > SizeOf(TBuffer) then
        Count := SizeOf(TBuffer);
      Move(Buffers[i]^, Data[Index], Count);
      Inc(Index, SizeOf(TBuffer));
    end;

    Save(SaveDialog.FileName, StrToInt(ComboBoxSamplesPerSecond.Text), StrToInt(ComboBoxBitsPerSample.Text), StrToInt(ComboBoxChannels.Text), Data);
  end;
end;

procedure TFormDemo.ButtonLoadClick(Sender: TObject);
var
  SamplesPerSecond: LongWord;
  BitsPerSample, Channels: Word;
  Data: TByteDynArray;
  MyBuffer: ^TBuffer;
  Index, Count: Integer;
begin
  if OpenDialog.Execute then
  begin
    Data := Load(OpenDialog.FileName, SamplesPerSecond, BitsPerSample, Channels);
    SetComboBoxes(SamplesPerSecond, BitsPerSample, Channels);

    // copy data to buffers
    RecordSize := Length(Data);
    ClearBuffers;
    Index := 0;
    while Index < RecordSize do
    begin
      New(MyBuffer);
      Buffers.Add(MyBuffer);
      Count := RecordSize - Index;
      if Count <= 0 then
        Break;
      if Count > SizeOf(TBuffer) then
        Count := SizeOf(TBuffer);
      Move(Data[Index], MyBuffer^, Count);
      Inc(Index, SizeOf(TBuffer));
    end;

    ButtonStopClick(nil);
  end;
end;

procedure TFormDemo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ButtonStopClick(Sender);
end;

end.
