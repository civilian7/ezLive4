object scSelPathDlgForm: TscSelPathDlgForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  ClientHeight = 450
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCanResize = FormCanResize
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    450
    450)
  PixelsPerInch = 96
  TextHeight = 13
  object ShellTreeView: TscShellTreeView
    Left = 10
    Top = 10
    Width = 429
    Height = 385
    FluentUIOpaque = False
    ButtonCollapseImageIndex = 0
    ButtonExpandImageIndex = 1
    SelectionStyle = scstStyled
    SelectionColor = clNone
    SelectionTextColor = clHighlightText
    ShowFocusRect = True
    DefaultDraw = True
    ButtonStyle = scebsArrow
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoRefresh = False
    HideSelection = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowLines = False
    ShowRoot = False
    TabOrder = 0
    OnChange = ShellTreeViewChange
  end
  object CreateButton: TscButton
    Left = 8
    Top = 409
    Width = 120
    Height = 29
    Anchors = [akLeft, akBottom]
    FluentUIOpaque = False
    TabOrder = 1
    TabStop = True
    OnClick = CreateButtonClick
    Animation = True
    Caption = 'Create'
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
    ToggleMode = False
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
  object OKButton: TscButton
    Left = 227
    Top = 409
    Width = 100
    Height = 29
    Anchors = [akRight, akBottom]
    FluentUIOpaque = False
    TabOrder = 2
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
    Default = True
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
    ToggleMode = False
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
    Left = 339
    Top = 409
    Width = 100
    Height = 29
    Anchors = [akRight, akBottom]
    FluentUIOpaque = False
    TabOrder = 3
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
    ToggleMode = False
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
  object scStyledForm1: TscStyledForm
    FluentUIBackground = scfuibNone
    FluentUIAcrylicColor = clBtnFace
    FluentUIAcrylicColorAlpha = 100
    FluentUIBorder = True
    FluentUIInactiveAcrylicColorOpaque = False
    DWMClientShadow = False
    DWMClientShadowHitTest = False
    DropDownForm = False
    DropDownAnimation = False
    DropDownBorderColor = clBtnShadow
    StylesMenuSorted = False
    ShowStylesMenu = False
    StylesMenuCaption = 'Styles'
    ClientWidth = 0
    ClientHeight = 0
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
    CaptionWallpaperIndex = -1
    CaptionWallpaperInActiveIndex = -1
    CaptionWallpaperLeftMargin = 1
    CaptionWallpaperTopMargin = 1
    CaptionWallpaperRightMargin = 1
    CaptionWallpaperBottomMargin = 1
    Left = 368
    Top = 32
  end
end
