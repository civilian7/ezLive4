object FormDemo: TFormDemo
  Left = 442
  Top = 303
  ActiveControl = ButtonRecord
  BorderStyle = bsDialog
  Caption = 'Audio Component Suite example'
  ClientHeight = 278
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object LabelInput: TLabel
    Left = 16
    Top = 16
    Width = 24
    Height = 13
    Caption = 'Input'
    FocusControl = ComboBoxInput
  end
  object LabelOutput: TLabel
    Left = 240
    Top = 16
    Width = 32
    Height = 13
    Caption = 'Output'
    FocusControl = ComboBoxOutput
  end
  object LabelSamplesPerSecond: TLabel
    Left = 16
    Top = 64
    Width = 96
    Height = 13
    Caption = 'Samples per second'
    FocusControl = ComboBoxSamplesPerSecond
  end
  object LabelBitsPerSample: TLabel
    Left = 168
    Top = 64
    Width = 71
    Height = 13
    Caption = 'Bits per sample'
    FocusControl = ComboBoxBitsPerSample
  end
  object LabelChannels: TLabel
    Left = 320
    Top = 64
    Width = 44
    Height = 13
    Caption = 'Channels'
    FocusControl = ComboBoxChannels
  end
  object LabelLeftVolume: TLabel
    Left = 16
    Top = 112
    Width = 55
    Height = 13
    Caption = 'Left volume'
    FocusControl = TrackBarLeftVolume
  end
  object LabelRightVolume: TLabel
    Left = 240
    Top = 112
    Width = 62
    Height = 13
    Caption = 'Right volume'
    FocusControl = TrackBarRightVolume
  end
  object LabelSamples: TLabel
    Left = 16
    Top = 184
    Width = 425
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object ComboBoxInput: TComboBox
    Left = 16
    Top = 32
    Width = 201
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object ComboBoxOutput: TComboBox
    Left = 240
    Top = 32
    Width = 201
    Height = 21
    Style = csDropDownList
    TabOrder = 1
  end
  object ComboBoxSamplesPerSecond: TComboBox
    Left = 8
    Top = 83
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = '8000'
    Items.Strings = (
      '8000'
      '11025'
      '22050'
      '44100'
      '48000'
      '96000')
  end
  object ButtonRecord: TButton
    Left = 16
    Top = 203
    Width = 75
    Height = 25
    Caption = 'Record'
    TabOrder = 5
    OnClick = ButtonRecordClick
  end
  object ButtonPlay: TButton
    Left = 111
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Play'
    Enabled = False
    TabOrder = 6
    OnClick = ButtonPlayClick
  end
  object ButtonStop: TButton
    Left = 192
    Top = 203
    Width = 75
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 7
    OnClick = ButtonStopClick
  end
  object ButtonPause: TButton
    Left = 280
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Pause'
    Enabled = False
    TabOrder = 8
    OnClick = ButtonPauseClick
  end
  object ButtonResume: TButton
    Left = 368
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Resume'
    Enabled = False
    TabOrder = 9
    OnClick = ButtonResumeClick
  end
  object ComboBoxBitsPerSample: TComboBox
    Left = 168
    Top = 80
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemIndex = 1
    TabOrder = 3
    Text = '16'
    Items.Strings = (
      '8'
      '16')
  end
  object ComboBoxChannels: TComboBox
    Left = 320
    Top = 80
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = '1'
    Items.Strings = (
      '1'
      '2')
  end
  object TrackBarLeftVolume: TTrackBar
    Left = 8
    Top = 128
    Width = 217
    Height = 45
    Max = 65535
    TabOrder = 10
    OnChange = TrackBarLeftVolumeChange
  end
  object TrackBarRightVolume: TTrackBar
    Left = 232
    Top = 128
    Width = 217
    Height = 45
    Max = 65535
    TabOrder = 11
    OnChange = TrackBarRightVolumeChange
  end
  object ButtonLoad: TButton
    Left = 280
    Top = 245
    Width = 75
    Height = 25
    Caption = 'Load...'
    TabOrder = 12
    OnClick = ButtonLoadClick
  end
  object ButtonSave: TButton
    Left = 368
    Top = 245
    Width = 75
    Height = 25
    Caption = 'Save...'
    Enabled = False
    TabOrder = 13
    OnClick = ButtonSaveClick
  end
  object Button1: TButton
    Left = 16
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 14
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 328
    Top = 16
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.wav'
    Filter = 'Wave files (*.wav)|*.wav'
    Left = 312
    Top = 160
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.wav'
    Filter = 'Wave files (*.wav)|*.wav'
    Left = 264
    Top = 160
  end
end
