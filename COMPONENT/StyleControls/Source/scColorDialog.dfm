object scColorDlgFrm: TscColorDlgFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Color'
  ClientHeight = 400
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OKButton: TscButton
    Left = 257
    Top = 358
    Width = 100
    Height = 29
    TabOrder = 0
    TabStop = True
    Animation = True
    Caption = 'OK'
    CanFocused = True
    CustomDropDown = False
    Margin = -1
    Spacing = 1
    Layout = blGlyphLeft
    ImageIndex = -1
    ImageMargin = 0
    TransparentBackground = True
    ColorOptions.NormalColor = clBtnFace
    ColorOptions.HotColor = clBtnFace
    ColorOptions.PressedColor = clBtnShadow
    ColorOptions.FocusedColor = clBtnFace
    ColorOptions.DisabledColor = clBtnFace
    ColorOptions.FrameNormalColor = clBtnShadow
    ColorOptions.FrameHotColor = clHighlight
    ColorOptions.FramePressedColor = clHighlight
    ColorOptions.FrameFocusedColor = clHighlight
    ColorOptions.FrameDisabledColor = clBtnShadow
    ColorOptions.FrameWidth = 1
    ColorOptions.FontNormalColor = clBtnText
    ColorOptions.FontHotColor = clBtnText
    ColorOptions.FontPressedColor = clBtnText
    ColorOptions.FontFocusedColor = clBtnText
    ColorOptions.FontDisabledColor = clBtnShadow
    ColorOptions.TitleFontNormalColor = clBtnText
    ColorOptions.TitleFontHotColor = clBtnText
    ColorOptions.TitleFontPressedColor = clBtnText
    ColorOptions.TitleFontFocusedColor = clBtnText
    ColorOptions.TitleFontDisabledColor = clBtnShadow
    ColorOptions.StyleColors = True
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    HotImageIndex = -1
    ModalResult = 1
    ModalSetting = True
    FocusedImageIndex = -1
    PressedImageIndex = -1
    StyleKind = scbsPushButton
    UseGalleryMenuImage = False
    UseGalleryMenuCaption = False
    CustomImageNormalIndex = -1
    CustomImageHotIndex = -1
    CustomImagePressedIndex = -1
    CustomImageDisabledIndex = -1
    CustomImageFocusedIndex = -1
    ScaleMarginAndSpacing = False
    WidthWithCaption = 0
    WidthWithoutCaption = 0
    UseFontColorToStyleColor = False
    RepeatClick = False
    RepeatClickInterval = 100
    GlowEffect.Enabled = False
    GlowEffect.Color = clHighlight
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    GlowEffect.HotColor = clNone
    GlowEffect.PressedColor = clNone
    GlowEffect.FocusedColor = clNone
    GlowEffect.PressedGlowSize = 7
    GlowEffect.PressedAlphaValue = 255
    GlowEffect.States = [scsHot, scsPressed, scsFocused]
    ImageGlow = True
    ShowGalleryMenuFromTop = False
    ShowGalleryMenuFromRight = False
    ShowMenuArrow = True
    SplitButton = False
    ShowFocusRect = False
    Down = False
    GroupIndex = 0
    AllowAllUp = False
  end
  object CancelButton: TscButton
    Left = 372
    Top = 358
    Width = 100
    Height = 29
    TabOrder = 1
    TabStop = True
    Animation = True
    Caption = 'Cancel'
    CanFocused = True
    CustomDropDown = False
    Margin = -1
    Spacing = 1
    Layout = blGlyphLeft
    ImageIndex = -1
    ImageMargin = 0
    TransparentBackground = True
    Cancel = True
    ColorOptions.NormalColor = clBtnFace
    ColorOptions.HotColor = clBtnFace
    ColorOptions.PressedColor = clBtnShadow
    ColorOptions.FocusedColor = clBtnFace
    ColorOptions.DisabledColor = clBtnFace
    ColorOptions.FrameNormalColor = clBtnShadow
    ColorOptions.FrameHotColor = clHighlight
    ColorOptions.FramePressedColor = clHighlight
    ColorOptions.FrameFocusedColor = clHighlight
    ColorOptions.FrameDisabledColor = clBtnShadow
    ColorOptions.FrameWidth = 1
    ColorOptions.FontNormalColor = clBtnText
    ColorOptions.FontHotColor = clBtnText
    ColorOptions.FontPressedColor = clBtnText
    ColorOptions.FontFocusedColor = clBtnText
    ColorOptions.FontDisabledColor = clBtnShadow
    ColorOptions.TitleFontNormalColor = clBtnText
    ColorOptions.TitleFontHotColor = clBtnText
    ColorOptions.TitleFontPressedColor = clBtnText
    ColorOptions.TitleFontFocusedColor = clBtnText
    ColorOptions.TitleFontDisabledColor = clBtnShadow
    ColorOptions.StyleColors = True
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    HotImageIndex = -1
    ModalResult = 2
    ModalSetting = True
    FocusedImageIndex = -1
    PressedImageIndex = -1
    StyleKind = scbsPushButton
    UseGalleryMenuImage = False
    UseGalleryMenuCaption = False
    CustomImageNormalIndex = -1
    CustomImageHotIndex = -1
    CustomImagePressedIndex = -1
    CustomImageDisabledIndex = -1
    CustomImageFocusedIndex = -1
    ScaleMarginAndSpacing = False
    WidthWithCaption = 0
    WidthWithoutCaption = 0
    UseFontColorToStyleColor = False
    RepeatClick = False
    RepeatClickInterval = 100
    GlowEffect.Enabled = False
    GlowEffect.Color = clHighlight
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    GlowEffect.HotColor = clNone
    GlowEffect.PressedColor = clNone
    GlowEffect.FocusedColor = clNone
    GlowEffect.PressedGlowSize = 7
    GlowEffect.PressedAlphaValue = 255
    GlowEffect.States = [scsHot, scsPressed, scsFocused]
    ImageGlow = True
    ShowGalleryMenuFromTop = False
    ShowGalleryMenuFromRight = False
    ShowMenuArrow = True
    SplitButton = False
    ShowFocusRect = False
    Down = False
    GroupIndex = 0
    AllowAllUp = False
  end
  object scLabel1: TscLabel
    Left = 406
    Top = 274
    Width = 11
    Height = 13
    TabOrder = 2
    DragForm = False
    GlowEffect.Enabled = False
    GlowEffect.Color = clBtnShadow
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    AutoSize = True
    UseFontColorToStyleColor = False
    Caption = 'R:'
  end
  object scLabel2: TscLabel
    Left = 405
    Top = 301
    Width = 11
    Height = 13
    TabOrder = 3
    DragForm = False
    GlowEffect.Enabled = False
    GlowEffect.Color = clBtnShadow
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    AutoSize = True
    UseFontColorToStyleColor = False
    Caption = 'G:'
  end
  object scLabel3: TscLabel
    Left = 406
    Top = 327
    Width = 10
    Height = 13
    TabOrder = 4
    DragForm = False
    GlowEffect.Enabled = False
    GlowEffect.Color = clBtnShadow
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    AutoSize = True
    UseFontColorToStyleColor = False
    Caption = 'B:'
  end
  object scLabel4: TscLabel
    Left = 333
    Top = 274
    Width = 11
    Height = 13
    TabOrder = 5
    DragForm = False
    GlowEffect.Enabled = False
    GlowEffect.Color = clBtnShadow
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    AutoSize = True
    UseFontColorToStyleColor = False
    Caption = 'H:'
  end
  object scLabel5: TscLabel
    Left = 333
    Top = 301
    Width = 10
    Height = 13
    TabOrder = 6
    DragForm = False
    GlowEffect.Enabled = False
    GlowEffect.Color = clBtnShadow
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    AutoSize = True
    UseFontColorToStyleColor = False
    Caption = 'S:'
  end
  object scLabel6: TscLabel
    Left = 333
    Top = 327
    Width = 9
    Height = 13
    TabOrder = 7
    DragForm = False
    GlowEffect.Enabled = False
    GlowEffect.Color = clBtnShadow
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    AutoSize = True
    UseFontColorToStyleColor = False
    Caption = 'L:'
  end
  object scButton1: TscButton
    Left = 208
    Top = 272
    Width = 40
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    TabStop = True
    OnClick = scButton1Click
    Animation = True
    Caption = '+'
    CanFocused = True
    CustomDropDown = False
    Margin = -1
    Spacing = 1
    Layout = blGlyphTop
    ImageIndex = -1
    ImageMargin = 0
    TransparentBackground = True
    ColorOptions.NormalColor = clBtnFace
    ColorOptions.HotColor = clBtnFace
    ColorOptions.PressedColor = clBtnShadow
    ColorOptions.FocusedColor = clBtnFace
    ColorOptions.DisabledColor = clBtnFace
    ColorOptions.FrameNormalColor = clBtnShadow
    ColorOptions.FrameHotColor = clHighlight
    ColorOptions.FramePressedColor = clHighlight
    ColorOptions.FrameFocusedColor = clHighlight
    ColorOptions.FrameDisabledColor = clBtnShadow
    ColorOptions.FrameWidth = 1
    ColorOptions.FontNormalColor = clBtnText
    ColorOptions.FontHotColor = clBtnText
    ColorOptions.FontPressedColor = clBtnText
    ColorOptions.FontFocusedColor = clBtnText
    ColorOptions.FontDisabledColor = clBtnShadow
    ColorOptions.TitleFontNormalColor = clBtnText
    ColorOptions.TitleFontHotColor = clBtnText
    ColorOptions.TitleFontPressedColor = clBtnText
    ColorOptions.TitleFontFocusedColor = clBtnText
    ColorOptions.TitleFontDisabledColor = clBtnShadow
    ColorOptions.StyleColors = True
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    HotImageIndex = -1
    FocusedImageIndex = -1
    PressedImageIndex = -1
    StyleKind = scbsPushButton
    UseGalleryMenuImage = False
    UseGalleryMenuCaption = False
    CustomImageNormalIndex = -1
    CustomImageHotIndex = -1
    CustomImagePressedIndex = -1
    CustomImageDisabledIndex = -1
    CustomImageFocusedIndex = -1
    ScaleMarginAndSpacing = False
    WidthWithCaption = 0
    WidthWithoutCaption = 0
    UseFontColorToStyleColor = False
    RepeatClick = False
    RepeatClickInterval = 100
    GlowEffect.Enabled = False
    GlowEffect.Color = clHighlight
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    GlowEffect.HotColor = clNone
    GlowEffect.PressedColor = clNone
    GlowEffect.FocusedColor = clNone
    GlowEffect.PressedGlowSize = 7
    GlowEffect.PressedAlphaValue = 255
    GlowEffect.States = [scsHot, scsPressed, scsFocused]
    ImageGlow = True
    ShowGalleryMenuFromTop = False
    ShowGalleryMenuFromRight = False
    ShowMenuArrow = True
    SplitButton = False
    ShowFocusRect = False
    Down = False
    GroupIndex = 0
    AllowAllUp = False
  end
  object ColorsPanel: TscPanel
    Left = 260
    Top = 272
    Width = 62
    Height = 62
    TabOrder = 9
    CustomImageIndex = -1
    StyleKind = scpsPanel
    ShowCaption = False
    BorderStyle = scpbsFlat
    WallpaperIndex = -1
    LightBorderColor = clBtnHighlight
    ShadowBorderColor = clBtnShadow
    CaptionGlowEffect.Enabled = False
    CaptionGlowEffect.Color = clBtnShadow
    CaptionGlowEffect.AlphaValue = 255
    CaptionGlowEffect.GlowSize = 7
    CaptionGlowEffect.Offset = 0
    CaptionGlowEffect.Intensive = True
    CaptionGlowEffect.StyleColors = True
    Color = clBtnFace
    Caption = 'ColorsPanel'
    StorePaintBuffer = False
    object ColorViewer: TscPanel
      Left = 1
      Top = 1
      Width = 60
      Height = 30
      Align = alTop
      TabOrder = 0
      StyleElements = []
      CustomImageIndex = -1
      StyleKind = scpsPanel
      ShowCaption = False
      BorderStyle = scpbsNone
      WallpaperIndex = -1
      LightBorderColor = clBtnHighlight
      ShadowBorderColor = clBtnShadow
      CaptionGlowEffect.Enabled = False
      CaptionGlowEffect.Color = clBtnShadow
      CaptionGlowEffect.AlphaValue = 255
      CaptionGlowEffect.GlowSize = 7
      CaptionGlowEffect.Offset = 0
      CaptionGlowEffect.Intensive = True
      CaptionGlowEffect.StyleColors = True
      Color = clWhite
      Caption = 'ColorViewer'
      StorePaintBuffer = False
    end
    object OldColorViewer: TscPanel
      Left = 1
      Top = 31
      Width = 60
      Height = 30
      Align = alClient
      TabOrder = 1
      StyleElements = []
      CustomImageIndex = -1
      StyleKind = scpsPanel
      ShowCaption = False
      BorderStyle = scpbsNone
      WallpaperIndex = -1
      LightBorderColor = clBtnHighlight
      ShadowBorderColor = clBtnShadow
      CaptionGlowEffect.Enabled = False
      CaptionGlowEffect.Color = clBtnShadow
      CaptionGlowEffect.AlphaValue = 255
      CaptionGlowEffect.GlowSize = 7
      CaptionGlowEffect.Offset = 0
      CaptionGlowEffect.Intensive = True
      CaptionGlowEffect.StyleColors = True
      Color = clBlack
      Caption = 'ColorPanel'
      StorePaintBuffer = False
    end
  end
  object HEdit: TscTrackEdit
    Left = 349
    Top = 271
    Width = 48
    Height = 21
    UseFontColorToStyleColor = False
    ContentMarginLeft = 0
    ContentMarginRight = 0
    ContentMarginTop = 0
    ContentMarginBottom = 0
    CustomBackgroundImageNormalIndex = -1
    CustomBackgroundImageHotIndex = -1
    CustomBackgroundImageDisabledIndex = -1
    PromptTextColor = clNone
    WallpaperIndex = -1
    Increment = 1
    DblClickShowTrackBar = True
    SupportUpDownKeys = True
    PopupKind = sctbpLeft
    JumpWhenClick = True
    TrackBarWidth = 150
    TrackBarHeight = 0
    MinValue = 0
    MaxValue = 239
    Value = 0
    LeftButton.ComboButton = False
    LeftButton.Enabled = True
    LeftButton.Visible = False
    LeftButton.ShowHint = False
    LeftButton.ShowEllipses = False
    LeftButton.StyleKind = scbsPushButton
    LeftButton.Width = 18
    LeftButton.ImageIndex = -1
    LeftButton.ImageHotIndex = -1
    LeftButton.ImagePressedIndex = -1
    LeftButton.RepeatClick = False
    LeftButton.RepeatClickInterval = 200
    LeftButton.CustomImageNormalIndex = -1
    LeftButton.CustomImageHotIndex = -1
    LeftButton.CustomImagePressedIndex = -1
    LeftButton.CustomImageDisabledIndex = -1
    RightButton.ComboButton = True
    RightButton.Enabled = True
    RightButton.Visible = True
    RightButton.ShowHint = False
    RightButton.ShowEllipses = False
    RightButton.StyleKind = scbsPushButton
    RightButton.Width = 15
    RightButton.ImageIndex = -1
    RightButton.ImageHotIndex = -1
    RightButton.ImagePressedIndex = -1
    RightButton.RepeatClick = False
    RightButton.RepeatClickInterval = 200
    RightButton.CustomImageNormalIndex = -1
    RightButton.CustomImageHotIndex = -1
    RightButton.CustomImagePressedIndex = -1
    RightButton.CustomImageDisabledIndex = -1
    Transparent = False
    BorderKind = scebFrame
    TabOrder = 10
  end
  object SEdit: TscTrackEdit
    Left = 349
    Top = 298
    Width = 48
    Height = 21
    UseFontColorToStyleColor = False
    ContentMarginLeft = 0
    ContentMarginRight = 0
    ContentMarginTop = 0
    ContentMarginBottom = 0
    CustomBackgroundImageNormalIndex = -1
    CustomBackgroundImageHotIndex = -1
    CustomBackgroundImageDisabledIndex = -1
    PromptTextColor = clNone
    WallpaperIndex = -1
    Increment = 1
    DblClickShowTrackBar = True
    SupportUpDownKeys = True
    PopupKind = sctbpLeft
    JumpWhenClick = True
    TrackBarWidth = 150
    TrackBarHeight = 0
    MinValue = 0
    MaxValue = 240
    Value = 0
    LeftButton.ComboButton = False
    LeftButton.Enabled = True
    LeftButton.Visible = False
    LeftButton.ShowHint = False
    LeftButton.ShowEllipses = False
    LeftButton.StyleKind = scbsPushButton
    LeftButton.Width = 18
    LeftButton.ImageIndex = -1
    LeftButton.ImageHotIndex = -1
    LeftButton.ImagePressedIndex = -1
    LeftButton.RepeatClick = False
    LeftButton.RepeatClickInterval = 200
    LeftButton.CustomImageNormalIndex = -1
    LeftButton.CustomImageHotIndex = -1
    LeftButton.CustomImagePressedIndex = -1
    LeftButton.CustomImageDisabledIndex = -1
    RightButton.ComboButton = True
    RightButton.Enabled = True
    RightButton.Visible = True
    RightButton.ShowHint = False
    RightButton.ShowEllipses = False
    RightButton.StyleKind = scbsPushButton
    RightButton.Width = 15
    RightButton.ImageIndex = -1
    RightButton.ImageHotIndex = -1
    RightButton.ImagePressedIndex = -1
    RightButton.RepeatClick = False
    RightButton.RepeatClickInterval = 200
    RightButton.CustomImageNormalIndex = -1
    RightButton.CustomImageHotIndex = -1
    RightButton.CustomImagePressedIndex = -1
    RightButton.CustomImageDisabledIndex = -1
    Transparent = False
    BorderKind = scebFrame
    TabOrder = 11
  end
  object LEdit: TscTrackEdit
    Left = 349
    Top = 324
    Width = 48
    Height = 21
    UseFontColorToStyleColor = False
    ContentMarginLeft = 0
    ContentMarginRight = 0
    ContentMarginTop = 0
    ContentMarginBottom = 0
    CustomBackgroundImageNormalIndex = -1
    CustomBackgroundImageHotIndex = -1
    CustomBackgroundImageDisabledIndex = -1
    PromptTextColor = clNone
    WallpaperIndex = -1
    Increment = 1
    DblClickShowTrackBar = True
    SupportUpDownKeys = True
    PopupKind = sctbpLeft
    JumpWhenClick = True
    TrackBarWidth = 150
    TrackBarHeight = 0
    MinValue = 0
    MaxValue = 240
    Value = 0
    LeftButton.ComboButton = False
    LeftButton.Enabled = True
    LeftButton.Visible = False
    LeftButton.ShowHint = False
    LeftButton.ShowEllipses = False
    LeftButton.StyleKind = scbsPushButton
    LeftButton.Width = 18
    LeftButton.ImageIndex = -1
    LeftButton.ImageHotIndex = -1
    LeftButton.ImagePressedIndex = -1
    LeftButton.RepeatClick = False
    LeftButton.RepeatClickInterval = 200
    LeftButton.CustomImageNormalIndex = -1
    LeftButton.CustomImageHotIndex = -1
    LeftButton.CustomImagePressedIndex = -1
    LeftButton.CustomImageDisabledIndex = -1
    RightButton.ComboButton = True
    RightButton.Enabled = True
    RightButton.Visible = True
    RightButton.ShowHint = False
    RightButton.ShowEllipses = False
    RightButton.StyleKind = scbsPushButton
    RightButton.Width = 15
    RightButton.ImageIndex = -1
    RightButton.ImageHotIndex = -1
    RightButton.ImagePressedIndex = -1
    RightButton.RepeatClick = False
    RightButton.RepeatClickInterval = 200
    RightButton.CustomImageNormalIndex = -1
    RightButton.CustomImageHotIndex = -1
    RightButton.CustomImagePressedIndex = -1
    RightButton.CustomImageDisabledIndex = -1
    Transparent = False
    BorderKind = scebFrame
    TabOrder = 12
  end
  object REdit: TscTrackEdit
    Left = 422
    Top = 271
    Width = 50
    Height = 21
    UseFontColorToStyleColor = False
    ContentMarginLeft = 0
    ContentMarginRight = 0
    ContentMarginTop = 0
    ContentMarginBottom = 0
    CustomBackgroundImageNormalIndex = -1
    CustomBackgroundImageHotIndex = -1
    CustomBackgroundImageDisabledIndex = -1
    PromptTextColor = clNone
    WallpaperIndex = -1
    Increment = 1
    DblClickShowTrackBar = True
    SupportUpDownKeys = True
    PopupKind = sctbpLeft
    JumpWhenClick = True
    TrackBarWidth = 150
    TrackBarHeight = 0
    MinValue = 0
    MaxValue = 255
    Value = 0
    LeftButton.ComboButton = False
    LeftButton.Enabled = True
    LeftButton.Visible = False
    LeftButton.ShowHint = False
    LeftButton.ShowEllipses = False
    LeftButton.StyleKind = scbsPushButton
    LeftButton.Width = 18
    LeftButton.ImageIndex = -1
    LeftButton.ImageHotIndex = -1
    LeftButton.ImagePressedIndex = -1
    LeftButton.RepeatClick = False
    LeftButton.RepeatClickInterval = 200
    LeftButton.CustomImageNormalIndex = -1
    LeftButton.CustomImageHotIndex = -1
    LeftButton.CustomImagePressedIndex = -1
    LeftButton.CustomImageDisabledIndex = -1
    RightButton.ComboButton = True
    RightButton.Enabled = True
    RightButton.Visible = True
    RightButton.ShowHint = False
    RightButton.ShowEllipses = False
    RightButton.StyleKind = scbsPushButton
    RightButton.Width = 15
    RightButton.ImageIndex = -1
    RightButton.ImageHotIndex = -1
    RightButton.ImagePressedIndex = -1
    RightButton.RepeatClick = False
    RightButton.RepeatClickInterval = 200
    RightButton.CustomImageNormalIndex = -1
    RightButton.CustomImageHotIndex = -1
    RightButton.CustomImagePressedIndex = -1
    RightButton.CustomImageDisabledIndex = -1
    Transparent = False
    BorderKind = scebFrame
    TabOrder = 13
  end
  object GEdit: TscTrackEdit
    Left = 422
    Top = 298
    Width = 50
    Height = 21
    UseFontColorToStyleColor = False
    ContentMarginLeft = 0
    ContentMarginRight = 0
    ContentMarginTop = 0
    ContentMarginBottom = 0
    CustomBackgroundImageNormalIndex = -1
    CustomBackgroundImageHotIndex = -1
    CustomBackgroundImageDisabledIndex = -1
    PromptTextColor = clNone
    WallpaperIndex = -1
    Increment = 1
    DblClickShowTrackBar = True
    SupportUpDownKeys = True
    PopupKind = sctbpLeft
    JumpWhenClick = True
    TrackBarWidth = 150
    TrackBarHeight = 0
    MinValue = 0
    MaxValue = 255
    Value = 0
    LeftButton.ComboButton = False
    LeftButton.Enabled = True
    LeftButton.Visible = False
    LeftButton.ShowHint = False
    LeftButton.ShowEllipses = False
    LeftButton.StyleKind = scbsPushButton
    LeftButton.Width = 18
    LeftButton.ImageIndex = -1
    LeftButton.ImageHotIndex = -1
    LeftButton.ImagePressedIndex = -1
    LeftButton.RepeatClick = False
    LeftButton.RepeatClickInterval = 200
    LeftButton.CustomImageNormalIndex = -1
    LeftButton.CustomImageHotIndex = -1
    LeftButton.CustomImagePressedIndex = -1
    LeftButton.CustomImageDisabledIndex = -1
    RightButton.ComboButton = True
    RightButton.Enabled = True
    RightButton.Visible = True
    RightButton.ShowHint = False
    RightButton.ShowEllipses = False
    RightButton.StyleKind = scbsPushButton
    RightButton.Width = 15
    RightButton.ImageIndex = -1
    RightButton.ImageHotIndex = -1
    RightButton.ImagePressedIndex = -1
    RightButton.RepeatClick = False
    RightButton.RepeatClickInterval = 200
    RightButton.CustomImageNormalIndex = -1
    RightButton.CustomImageHotIndex = -1
    RightButton.CustomImagePressedIndex = -1
    RightButton.CustomImageDisabledIndex = -1
    Transparent = False
    BorderKind = scebFrame
    TabOrder = 14
  end
  object BEdit: TscTrackEdit
    Left = 422
    Top = 324
    Width = 50
    Height = 21
    UseFontColorToStyleColor = False
    ContentMarginLeft = 0
    ContentMarginRight = 0
    ContentMarginTop = 0
    ContentMarginBottom = 0
    CustomBackgroundImageNormalIndex = -1
    CustomBackgroundImageHotIndex = -1
    CustomBackgroundImageDisabledIndex = -1
    PromptTextColor = clNone
    WallpaperIndex = -1
    Increment = 1
    DblClickShowTrackBar = True
    SupportUpDownKeys = True
    PopupKind = sctbpLeft
    JumpWhenClick = True
    TrackBarWidth = 150
    TrackBarHeight = 0
    MinValue = 0
    MaxValue = 255
    Value = 0
    LeftButton.ComboButton = False
    LeftButton.Enabled = True
    LeftButton.Visible = False
    LeftButton.ShowHint = False
    LeftButton.ShowEllipses = False
    LeftButton.StyleKind = scbsPushButton
    LeftButton.Width = 18
    LeftButton.ImageIndex = -1
    LeftButton.ImageHotIndex = -1
    LeftButton.ImagePressedIndex = -1
    LeftButton.RepeatClick = False
    LeftButton.RepeatClickInterval = 200
    LeftButton.CustomImageNormalIndex = -1
    LeftButton.CustomImageHotIndex = -1
    LeftButton.CustomImagePressedIndex = -1
    LeftButton.CustomImageDisabledIndex = -1
    RightButton.ComboButton = True
    RightButton.Enabled = True
    RightButton.Visible = True
    RightButton.ShowHint = False
    RightButton.ShowEllipses = False
    RightButton.StyleKind = scbsPushButton
    RightButton.Width = 15
    RightButton.ImageIndex = -1
    RightButton.ImageHotIndex = -1
    RightButton.ImagePressedIndex = -1
    RightButton.RepeatClick = False
    RightButton.RepeatClickInterval = 200
    RightButton.CustomImageNormalIndex = -1
    RightButton.CustomImageHotIndex = -1
    RightButton.CustomImagePressedIndex = -1
    RightButton.CustomImageDisabledIndex = -1
    Transparent = False
    BorderKind = scebFrame
    TabOrder = 15
  end
  object scCustomColorGrid1: TscCustomColorGrid
    Left = 8
    Top = 268
    Width = 190
    Height = 60
    TabOrder = 16
    CustomImageIndex = -1
    StyleKind = scpsTransparent
    ShowCaption = False
    BorderStyle = scpbsNone
    WallpaperIndex = -1
    LightBorderColor = clBtnHighlight
    ShadowBorderColor = clBtnShadow
    CaptionGlowEffect.Enabled = False
    CaptionGlowEffect.Color = clBtnShadow
    CaptionGlowEffect.AlphaValue = 255
    CaptionGlowEffect.GlowSize = 7
    CaptionGlowEffect.Offset = 0
    CaptionGlowEffect.Intensive = True
    CaptionGlowEffect.StyleColors = True
    Color = clBtnFace
    Caption = 'scCustomColorGrid1'
    StorePaintBuffer = False
    RowCount = 2
    ColCount = 6
  end
  object scColorGrid1: TscColorGrid
    Left = 8
    Top = 12
    Width = 190
    Height = 240
    TabOrder = 17
    CustomImageIndex = -1
    StyleKind = scpsTransparent
    ShowCaption = False
    BorderStyle = scpbsNone
    WallpaperIndex = -1
    LightBorderColor = clBtnHighlight
    ShadowBorderColor = clBtnShadow
    CaptionGlowEffect.Enabled = False
    CaptionGlowEffect.Color = clBtnShadow
    CaptionGlowEffect.AlphaValue = 255
    CaptionGlowEffect.GlowSize = 7
    CaptionGlowEffect.Offset = 0
    CaptionGlowEffect.Intensive = True
    CaptionGlowEffect.StyleColors = True
    Color = clBtnFace
    Caption = 'scColorGrid1'
    StorePaintBuffer = False
    RowCount = 8
    ColCount = 6
    ColorValue = clBlack
  end
  object scLColorPicker1: TscLColorPicker
    Left = 456
    Top = 8
    Width = 22
    Height = 252
    TabOrder = 18
  end
  object scHSColorPicker1: TscHSColorPicker
    Left = 207
    Top = 13
    Width = 240
    Height = 240
    TabOrder = 19
  end
  object scStyledForm1: TscStyledForm
    DWMClientShadow = False
    DropDownForm = False
    DropDownAnimation = False
    StylesMenuSorted = False
    ShowStylesMenu = False
    StylesMenuCaption = 'Styles'
    ClientWidth = 485
    ClientHeight = 400
    ShowHints = True
    Buttons = <>
    ButtonFont.Charset = DEFAULT_CHARSET
    ButtonFont.Color = clWindowText
    ButtonFont.Height = -11
    ButtonFont.Name = 'Tahoma'
    ButtonFont.Style = []
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Tahoma'
    CaptionFont.Style = [fsBold]
    CaptionAlignment = taLeftJustify
    InActiveClientColor = clWindow
    InActiveClientColorAlpha = 100
    InActiveClientBlurAmount = 5
    Tabs = <>
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clWindowText
    TabFont.Height = -11
    TabFont.Name = 'Tahoma'
    TabFont.Style = []
    ShowButtons = True
    ShowTabs = True
    TabIndex = 0
    TabsPosition = sctpLeft
    ShowInactiveTab = True
    Left = 40
    Top = 345
  end
end
