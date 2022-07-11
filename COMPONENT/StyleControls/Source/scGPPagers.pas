{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       StyleControls                                               }
{       Version 5.06                                                }
{                                                                   }
{       Copyright (c) 2014-2022 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit scGPPagers;

{$I scdefine.inc}
{$R-}

interface
  uses System.Variants, Winapi.Windows, System.SysUtils, Winapi.Messages,
     Vcl.Controls, System.Classes, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls, Vcl.Themes,
     Vcl.ImgList, Vcl.Mask, Vcl.Buttons,
     scDrawUtils, scGPUtils, scControls, scGPControls,  scGPExtControls,
     WinApi.GdipObj, WinApi.GdipApi;

  type

  TscGPPageControl = class;
  TscGPPageControlTab = class;
  TscGPPageControlPage = class;
  TscGPTabStyle = (gptsShape, gptsBottomLine, gptsLine, gptsRoundedLine);

  TscGPTabOptions = class(TPersistent)
  private
    FNormalColor: TColor;
    FActiveColor: TColor;
    FMouseInColor: TColor;
    FFocusedColor: TColor;
    FFrameNormalColor: TColor;
    FFrameActiveColor: TColor;
    FFrameMouseInColor: TColor;
    FFrameFocusedColor: TColor;
    FFrameWidth: Integer;
    FFontNormalColor: TColor;
    FFontActiveColor: TColor;
    FFontMouseInColor: TColor;
    FFontFocusedColor: TColor;

    FNormalColorAlpha: Byte;
    FActiveColorAlpha: Byte;
    FMouseInColorAlpha: Byte;
    FFocusedColorAlpha: Byte;

    FFrameNormalColorAlpha: Byte;
    FFrameActiveColorAlpha: Byte;
    FFrameMouseInColorAlpha: Byte;
    FFrameFocusedColorAlpha: Byte;

    FStyleColors: Boolean;
    FState: TscsCtrlState;
    FOnChange: TNotifyEvent;


    FGradientColorOffset: Byte;
    FShapeFillStyle: TscGPShapeFillStyle;
    FShapeFillGradientAngle: Integer;

    FTabStyle: TscGPTabStyle;

    procedure SetTabStyle(Value: TscGPTabStyle);

    procedure SetShapeFillStyle(Value: TscGPShapeFillStyle);
    procedure SetShapeFillGradientAngle(Value: Integer);
    procedure SetGradientColorOffset(Value: Byte);

    procedure SetShapeCornerRadius(Value: Integer);
    procedure SetLineWidth(Value: Integer);

    function GetColor: TColor;
    function GetFrameColor: TColor;
    function GetFontColor: TColor;
    function GetColorAlpha: Byte;
    function GetFrameColorAlpha: Byte;

    procedure SetNormalColor(Value: TColor);
    procedure SetActiveColor(Value: TColor);
    procedure SetMouseInColor(Value: TColor);
    procedure SetFocusedColor(Value: TColor);

    procedure SetNormalColorAlpha(Value: Byte);
    procedure SetActiveColorAlpha(Value: Byte);
    procedure SetMouseInColorAlpha(Value: Byte);
    procedure SetFocusedColorAlpha(Value: Byte);

    procedure SetFrameNormalColor(Value: TColor);
    procedure SetFrameActiveColor(Value: TColor);
    procedure SetFrameMouseInColor(Value: TColor);
    procedure SetFrameFocusedColor(Value: TColor);
    procedure SetFrameNormalColorAlpha(Value: Byte);
    procedure SetFrameActiveColorAlpha(Value: Byte);
    procedure SetFrameMouseInColorAlpha(Value: Byte);
    procedure SetFrameFocusedColorAlpha(Value: Byte);

    procedure SetFontNormalColor(Value: TColor);
    procedure SetFontActiveColor(Value: TColor);
    procedure SetFontMouseInColor(Value: TColor);
    procedure SetFontFocusedColor(Value: TColor);
    procedure SetFrameWidth(Value: Integer);
    procedure SetStyleColors(Value: Boolean);

    procedure Changed;
  protected
    FShapeCornerRadius: Integer;
    FLineWidth: Integer;
  public
    {$IFDEF VER340_UP}
    FControl: TControl;
    {$ENDIF}
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;

    property State: TscsCtrlState read FState write FState;
    property Color: TColor read GetColor;
    property FrameColor: TColor read GetFrameColor;
    property FontColor: TColor read GetFontColor;
    property ColorAlpha: Byte read GetColorAlpha;
    property FrameColorAlpha: Byte read GetFrameColorAlpha;

  published
    property NormalColor: TColor read FNormalColor write SetNormalColor;
    property ActiveColor: TColor read FActiveColor write SetActiveColor;
    property MouseInColor: TColor read FMouseInColor write SetMouseInColor;
    property FocusedColor: TColor read FFocusedColor write SetFocusedColor;

    property NormalColorAlpha: Byte read FNormalColorAlpha write SetNormalColorAlpha;
    property ActiveColorAlpha: Byte read FActiveColorAlpha write SetActiveColorAlpha;
    property MouseInColorAlpha: Byte read FMouseInColorAlpha write SetMouseInColorAlpha;
    property FocusedColorAlpha: Byte read FFocusedColorAlpha write SetFocusedColorAlpha;

    property FrameNormalColor: TColor read FFrameNormalColor write SetFrameNormalColor;
    property FrameActiveColor: TColor read FFrameActiveColor write SetFrameActiveColor;
    property FrameMouseInColor: TColor read FFrameMouseInColor write SetFrameMouseInColor;
    property FrameFocusedColor: TColor read FFrameFocusedColor write SetFrameFocusedColor;
    property FrameWidth: Integer read FFrameWidth write SetFrameWidth;

    property FrameNormalColorAlpha: Byte read FFrameNormalColorAlpha write SetFrameNormalColorAlpha;
    property FrameActiveColorAlpha: Byte read FFrameActiveColorAlpha write SetFrameActiveColorAlpha;
    property FrameMouseInColorAlpha: Byte read FFrameMouseInColorAlpha write SetFrameMouseInColorAlpha;
    property FrameFocusedColorAlpha: Byte read FFrameFocusedColorAlpha write SetFrameFocusedColorAlpha;

    property FontNormalColor: TColor read FFontNormalColor write SetFontNormalColor;
    property FontActiveColor: TColor read FFontActiveColor write SetFontActiveColor;
    property FontMouseInColor: TColor read FFontMouseInColor write SetFontMouseInColor;
    property FontFocusedColor: TColor read FFontFocusedColor write SetFontFocusedColor;

    property TabStyle: TscGPTabStyle read FTabStyle write SetTabStyle;

    property LineWidth: Integer read FLineWidth write SetLineWidth;

    property ShapeFillStyle: TscGPShapeFillStyle
      read FShapeFillStyle write SetShapeFillStyle default scgpsfColor;
    property ShapeFillGradientAngle: Integer
        read FShapeFillGradientAngle write SetShapeFillGradientAngle;
    property GradientColorOffset: Byte
      read FGradientColorOffset write SetGradientColorOffset;

    property ShapeCornerRadius: Integer
      read FShapeCornerRadius write SetShapeCornerRadius;

    property StyleColors: Boolean read FStyleColors write SetStyleColors;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TscGPTabCloseButtonShapeKind = (scgptcbRounded, scgptcbRect);

  TscGPTabCloseButtonOptions = class(TPersistent)
  private
    FNormalColor: TColor;
    FNormalColorAlpha: Byte;
    FHotColor: TColor;
    FHotColorAlpha: Byte;
    FPressedColor: TColor;
    FPressedColorAlpha: Byte;
    FDisabledColor: TColor;
    FDisabledColorAlpha: Byte;
    FGlyphNormalColor: TColor;
    FGlyphNormalColorAlpha: Byte;
    FGlyphHotColor: TColor;
    FGlyphHotColorAlpha: Byte;
    FGlyphPressedColor: TColor;
    FGlyphPressedColorAlpha: Byte;
    FGlyphDisabledColor: TColor;
    FGlyphDisabledColorAlpha: Byte;
    FShapeKind: TscGPTabCloseButtonShapeKind;
    FState: TscsCtrlState;
    FOnChange: TNotifyEvent;
    FStyleColors: Boolean;

    procedure Changed;

    function GetColor: TColor;
    function GetGlyphColor: TColor;
    function GetColorAlpha: Byte;
    function GetGlyphColorAlpha: Byte;

    procedure SetNormalColor(Value: TColor);
    procedure SetHotColor(Value: TColor);
    procedure SetPressedColor(Value: TColor);
    procedure SetDisabledColor(Value: TColor);

    procedure SetNormalColorAlpha(Value: Byte);
    procedure SetHotColorAlpha(Value: Byte);
    procedure SetPressedColorAlpha(Value: Byte);
    procedure SetDisabledColorAlpha(Value: Byte);

    procedure SetGlyphNormalColor(Value: TColor);
    procedure SetGlyphHotColor(Value: TColor);
    procedure SetGlyphPressedColor(Value: TColor);
    procedure SetGlyphDisabledColor(Value: TColor);

    procedure SetGlyphNormalColorAlpha(Value: Byte);
    procedure SetGlyphHotColorAlpha(Value: Byte);
    procedure SetGlyphPressedColorAlpha(Value: Byte);
    procedure SetGlyphDisabledColorAlpha(Value: Byte);

    procedure SetStyleColors(Value: Boolean);
    procedure SetShapeKind(Value: TscGPTabCloseButtonShapeKind);

  public
    {$IFDEF VER340_UP}
    FControl: TControl;
    {$ENDIF}

    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;

    property Color: TColor read GetColor;
    property ColorAlpha: Byte read GetColorAlpha;
    property GlyphColor: TColor read GetGlyphColor;
    property GlyphColorAlpha: Byte read GetGlyphColorAlpha;
    property State: TscsCtrlState read FState write FState;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property NormalColor: TColor read FNormalColor write SetNormalColor;
    property HotColor: TColor read FHotColor write SetHotColor;
    property PressedColor: TColor read FPressedColor write SetPressedColor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor;

    property NormalColorAlpha: Byte read FNormalColorAlpha write SetNormalColorAlpha;
    property HotColorAlpha: Byte read FHotColorAlpha write SetHotColorAlpha;
    property PressedColorAlpha: Byte read FPressedColorAlpha write SetPressedColorAlpha;
    property DisabledColorAlpha: Byte read FDisabledColorAlpha write SetDisabledColorAlpha;

    property GlyphNormalColor: TColor read FGlyphNormalColor write SetGlyphNormalColor;
    property GlyphHotColor: TColor read FGlyphHotColor write SetGlyphHotColor;
    property GlyphPressedColor: TColor read FGlyphPressedColor write SetGlyphPressedColor;
    property GlyphDisabledColor: TColor read FGlyphDisabledColor write SetGlyphDisabledColor;

    property GlyphNormalColorAlpha: Byte read FGlyphNormalColorAlpha write SetGlyphNormalColorAlpha;
    property GlyphHotColorAlpha: Byte read FGlyphHotColorAlpha write SetGlyphHotColorAlpha;
    property GlyphPressedColorAlpha: Byte read FGlyphPressedColorAlpha write SetGlyphPressedColorAlpha;
    property GlyphDisabledColorAlpha: Byte read FGlyphDisabledColorAlpha write SetGlyphDisabledColorAlpha;

    property ShapeKind: TscGPTabCloseButtonShapeKind
      read FShapeKind write SetShapeKind;

    property StyleColros: Boolean
      read FStyleColors write SetStyleColors;
  end;

  TscGPPageControlTab = class(TCollectionItem)
  protected
    FOnClick: TNotifyEvent;
    FPage: TscGPPageControlPage;
    FVisible: Boolean;
    FEnabled: Boolean;
    FImageIndex: Integer;
    FCaption: String;
    FCustomOptions: TscGPTabOptions;
    FUseCustomOptions: Boolean;
    FCustomFrameColor: TColor;
    FCustomFrameColorAlpha: Byte;
    FCustomGlowEffect: TscButtonGlowEffect;
    FShowCloseButton: Boolean;
    procedure SetShowCloseButton(Value: Boolean);
    procedure SetPage(const Value: TscGPPageControlPage);
    procedure SetCaption(Value: String);
    procedure SetEnabled(Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure SetUseCustomOptions(Value: Boolean);
    procedure SetCustomFrameColor(Value: TColor);
    procedure SetCustomFrameColorAlpha(Value: Byte);
    procedure OnOptionsChange(Sender: TObject);
  public
    Active: Boolean;
    TabRect: TRect;
    CloseButtonRect: TRect;
    CloseButtonMouseIn, CloseButtonMouseDown:Boolean;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Page: TscGPPageControlPage read FPage write SetPage;
    property Visible: Boolean read FVisible write SetVisible;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Caption: String read FCaption write SetCaption;
    property CustomOptions: TscGPTabOptions
      read FCustomOptions write FCustomOptions;
    property CustomGlowEffect: TscButtonGlowEffect read
      FCustomGlowEffect write FCustomGlowEffect;
    property CustomFrameColor: TColor
      read FCustomFrameColor write SetCustomFrameColor;
    property CustomFrameColorAlpha: Byte
      read FCustomFrameColorAlpha write SetCustomFrameColorAlpha;
    property ShowCloseButton: Boolean
      read FShowCloseButton write SetShowCloseButton;
    property UseCustomOptions: Boolean
      read FUseCustomOptions write SetUseCustomOptions;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TscGPPageControlTabs = class(TCollection)
  private
    function GetItem(Index: Integer):  TscGPPageControlTab;
    procedure SetItem(Index: Integer; Value:  TscGPPageControlTab);
  protected
    FClearing: Boolean;
    Pager: TscGPPageControl;
    DestroyPage: TscGPPageControlPage;
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(APager: TscGPPageControl);
    function Add: TscGPPageControlTab;
    function Insert(Index: Integer): TscGPPageControlTab;
    procedure Delete(Index: Integer);
    procedure Clear;
    property Items[Index: Integer]: TscGPPageControlTab read GetItem write SetItem; default;
  end;

  TscGPPageBGStyle = (scgppsForm, scgppsColor);

  TscGPPageControlPage = class(TscCustomScrollBox)
  protected
    FDestroyFromPager: Boolean;
    FBGStyle: TscGPPageBGStyle;
    procedure SetBGStyle(Value: TscGPPageBGStyle);
  public
    Pager: TscGPPageControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
      AHeight: Integer); override;
  published
    property AutoScroll default False;
    property BGStyle: TscGPPageBGStyle
      read FBGStyle write SetBGStyle;
    property FullUpdate default False;
    property Wallpapers;
    property WallpaperIndex;
    property CustomImages;
    property CustomBackgroundImageIndex;
  end;

  TscGPTabScrollButton = class(TscGPGlyphButton)
  protected
    FRight: Boolean;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMLButtonUp(var Msg: TWMMouse); message WM_LBUTTONUP;
  public
    procedure UpdateOptions(AColor, AArrowColor: TColor; AArrowThickness: Byte; ATransparent: Boolean);
    constructor CreateEx(AOwner: TComponent; AColor, AArrowColor: TColor; AArrowThickness: Byte; ATransparent: Boolean);
  end;

  TscGPTabControlBorderStyle = (scgpbsFrame, scgpbsLine, scgpbsLineTopBottom, scgpbsNone);
  TscGPGetAdvTabDrawParamsEvent = procedure(ATabIndex: Integer; ATabState: TscsCtrlState;
    ACanvas: TCanvas) of object;

  TscGPOnGetTabImageEvent = procedure(ATabIndex: Integer; var AImageList: TCustomImageList; var AImageIndex: Integer) of object;

  TscGPPageControl = class(TscCustomControl)
  private
    FEnableDragReorderTabs: Boolean;
    FDragSourceTab: TscGPPageControlTab;
    FTabsBGFillColor: TColor;
    FTabsBGFillColorAlpha: Byte;
    FFrameWidth: Integer;
    FFrameScaleWidth: Boolean;
    FFrameColor: TColor;
    FFrameColorAlpha: Byte;
    FTabOptions: TscGPTabOptions;
    FTabCloseButtonOptions: TscGPTabCloseButtonOptions;
    FShowCloseButtons: Boolean;
    FBorderStyle: TscGPTabControlBorderStyle;
    FMouseWheelSupport: Boolean;
    FShowInActiveTab: Boolean;
    FScrollOffset: Integer;
    FScrollVisible: Boolean;
    FOldWidth: Integer;
    FMouseIn: Boolean;
    FTabIndex: Integer;
    FTabIndexBeforeFocused, FTabIndexAfterFocused: Integer;
    FTabs: TscGPPageControlTabs;
    FLeftOffset, FRightOffset: Integer;
    FOldTabActive, FTabActive: Integer;
    FActivePage: TscGPPageControlPage;
    FTabHeight: Integer;
    FTabImages: TCustomImageList;
    FOnChangePage: TNotifyEvent;
    FOnChangingPage: TNotifyEvent;
    FOnCanChangePage: TscCanChangePageEvent;
    FShowCloseButtonOnActiveTabOnly: Boolean;
    FStopCloseTab: Boolean;

    FTabSpacing,
    FTabMargin,
    FTabWidth: Integer;

    FTabGlowEffect: TscButtonGlowEffect;

    FTabsLeftOffset,
    FTabsRightOffset, FTabsTopOffset: Integer;
    FLeftScrollButton, FRightScrollButton: TscGPTabScrollButton;
    FLeftTabIndex, FRightTabIndex: Integer;
    FShowFocusRect: Boolean;
    FFreeOnClose: Boolean;
    FOnClose: TscTabCloseEvent;
    FOnGetTabDrawParams: TscGPGetAdvTabDrawParamsEvent;

    FScrollButtonWidth: Integer;
    FScrollButtonArrowColor: TColor;
    FScrollButtonArrowThickness: Byte;
    FScrollButtonColor: TColor;
    FScrollButtonTransparent: Boolean;


    FCloseButtonSize: Integer;

    FTabsScaling: Boolean;
    FStopSetFocus: Boolean;
    FSaveFocusOnActiveControl: Boolean;

    FTabsRect: TRect;
    FPageRect: TRect;

    FOnGetTabImage: TscGPOnGetTabImageEvent;
    FOnTabsAreaClick: TNotifyEvent;

    procedure SetShowCloseButtonOnActiveTabOnly(Value: Boolean);
    procedure SetTabWidth(Value: Integer);
    procedure SetTabsBGFillColor(Value: TColor);
    procedure SetTabsBGFillColorAlpha(Value: Byte);

    procedure SetFrameWidth(Value: Integer);
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameColorAlpha(Value: Byte);

    procedure SetScrollButtonWidth(Value: Integer);
    procedure SetScrollButtonArrowColor(Value: TColor);
    procedure SetScrollButtonArrowThickness(Value: Byte);
    procedure SetScrollButtonColor(Value: TColor);
    procedure SetScrollButtonTransparent(Value: Boolean);

    procedure SetShowCloseButtons(Value: Boolean);
    procedure SetBorderStyle(Value: TscGPTabControlBorderStyle);
    procedure SetShowInActiveTab(Value: Boolean);
    procedure SetShowFocusRect(Value: Boolean);
    procedure SetTabsTopOffset(Value: Integer);
    procedure SetTabsLeftOffset(Value: Integer);
    procedure SetTabsRightOffset(Value: Integer);
    procedure SetTabSpacing(Value: Integer);
    procedure SetTabMargin(Value: Integer);
    procedure SetTabs(AValue: TscGPPageControlTabs);
    procedure SetActivePage(const Value: TscGPPageControlPage);
    function GetPageBoundsRect: TRect;
    procedure SetTabIndex(Value: Integer);
    procedure SetTabHeight(Value: Integer);
    procedure SetTabImages(Value: TCustomImageList);
    procedure OnControlChange(Sender: TObject);
    procedure ShowScrollButtons;
    procedure HideScrollButtons;
    procedure OnLeftScrollButtonClick(Sender: TObject);
    procedure OnRightScrollButtonClick(Sender: TObject);
    procedure AdjustScrollButtons;
    procedure UpdateScrollButtons;
  protected
    procedure ChangeScale(M, D: Integer{$IFDEF VER310_UP}; isDpiChange: Boolean{$ENDIF}); override;
    procedure SetTransparentBackground(Value: Boolean); override;
    procedure DrawCloseButton(ACanvas: TCanvas; G: TGPGraphics; ARect: TRect; AIndex: Integer; AColor: TColor);
    procedure ScrollToLeft;
    procedure ScrollToRight;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMOUSEWHEEL(var Message: TWMMOUSEWHEEL); message WM_MOUSEWHEEL;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure TestActive(X, Y: Integer);
    procedure Loaded; override;
    function GetTabWidth(AIndex: Integer): Integer;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CalcTabRects;
    procedure DrawTab(ACanvas: TCanvas; G: TGPGraphics; Index: Integer; AFirst: Boolean);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure GetScrollInfo;

    procedure ScrollToTab(AIndex: Integer);
    procedure Draw(ACanvas: TCanvas; ACtrlState: TscsCtrlState); override;

    function FindDrawNextTabFromIndex(AIndex: Integer): Integer;
    function FindDrawPriorTabFromIndex(AIndex: Integer): Integer;

    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
  public
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

    procedure DoClose;
    procedure FindNextTab;
    procedure FindPriorTab;
    procedure FindFirstTab;
    procedure FindLastTab;
    function FindNextTabFromIndex(AIndex: Integer): Integer;
    function FindPriorTabFromIndex(AIndex: Integer): Integer;
    function GetPageIndex(Value: TscGPPageControlPage): Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CreatePage: TscGPPageControlPage;
    procedure UpdateTabs;
    procedure UpdateControls; override;
    function TabFromPoint(P: TPoint): Integer;

    property SaveFocusOnActiveControl: Boolean
       read FSaveFocusOnActiveControl write FSaveFocusOnActiveControl;
  published
    property Align;
    property Font;
    property Color;
    property DrawTextMode;
    property EnableDragReorderTabs: Boolean
      read FEnableDragReorderTabs write FEnableDragReorderTabs;
    property TabsBGFillColor: TColor
      read FTabsBGFillColor write SetTabsBGFillColor;
    property TabsBGFillColorAlpha: Byte
      read FTabsBGFillColorAlpha write SetTabsBGFillColorAlpha;

    property TransparentBackground;
    property FrameWidth: Integer
      read FFrameWidth write SetFrameWidth;
    property FrameScaleWidth: Boolean
      read FFrameScaleWidth write FFrameScaleWidth;
    property FrameColor: TColor
      read FFrameColor write SetFrameColor;
    property FrameColorAlpha: Byte
      read FFrameColorAlpha write SetFrameColorAlpha;
    property BorderStyle: TscGPTabControlBorderStyle
      read FBorderStyle write SetBorderStyle;
    property MouseWheelSupport: Boolean
      read FMouseWheelSupport write FMouseWheelSupport;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect;
    property ShowInActiveTab: Boolean read FShowInactiveTab write SetShowInActiveTab;
    property ShowCloseButtons: Boolean read FShowCloseButtons write SetShowCloseButtons;
    property ShowCloseButtonOnActiveTabOnly: Boolean
      read FShowCloseButtonOnActiveTabOnly write SetShowCloseButtonOnActiveTabOnly;
    property TabsLeftOffset: Integer
      read FTabsLeftOffset write SetTabsLeftOffset;
    property TabsRightOffset: Integer
      read FTabsRightOffset write SetTabsRightOffset;
    property TabsTopOffset: Integer
      read FTabsTopOffset write SetTabsTopOffset;
    property TabGlowEffect: TscButtonGlowEffect read FTabGlowEffect write FTabGlowEffect;
    property TabOptions: TscGPTabOptions read FTabOptions write FTabOptions;
    property TabCloseButtonOptions: TscGPTabCloseButtonOptions read FTabCloseButtonOptions write FTabCloseButtonOptions;

    property TabSpacing: Integer read FTabSpacing write SetTabSpacing;
    property TabMargin: Integer read FTabMargin write SetTabMargin;
    property TabWidth: Integer read FTabWidth write SetTabWidth;

    property ScrollButtonWidth: Integer
      read FScrollButtonWidth write SetScrollButtonWidth;
    property ScrollButtonArrowColor: TColor
      read FScrollButtonArrowColor write SetScrollButtonArrowColor;
    property ScrollButtonArrowThickness: Byte
      read FScrollButtonArrowThickness write SetScrollButtonArrowThickness;
    property ScrollButtonColor: TColor
      read FScrollButtonColor write SetScrollButtonColor;
    property ScrollButtonTransparent: Boolean
      read FScrollButtonTransparent write SetScrollButtonTransparent;

    property TabHeight: Integer read FTabHeight write SetTabHeight;
    property Tabs: TscGPPageControlTabs read FTabs write SetTabs;
    property TabIndex: Integer read FTabIndex write SetTabIndex;
    property ActivePage: TscGPPageControlPage read FActivePage write SetActivePage;
    property TabImages: TCustomImageList
      read FTabImages write SetTabImages;

    property StorePaintBuffer;

    property FreeOnClose: Boolean read FFreeOnClose write FFreeOnClose;
    property OnChangingPage: TNotifyEvent read FOnChangingPage write FOnChangingPage;
    property OnChangePage: TNotifyEvent read FOnChangePage write FOnChangePage;
    property OnCanChangePage: TscCanChangePageEvent
      read FOnCanChangePage write FOnCanChangePage;
    property OnClose: TscTabCloseEvent read FOnClose write FOnClose;
    property OnGetTabDrawParams: TscGPGetAdvTabDrawParamsEvent
      read FOnGetTabDrawParams write FOnGetTabDrawParams;

    property OnGetTabImage: TscGPOnGetTabImageEvent
      read FOnGetTabImage write FOnGetTabImage;
    property OnTabsAreaClick: TNotifyEvent
      read FOnTabsAreaClick write FOnTabsAreaClick;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;


  TscGPTabControl = class;

  TscGPTabControlTab = class(TCollectionItem)
  protected
    FOnClick: TNotifyEvent;
    FTabIndex: Integer;
    FVisible: Boolean;
    FEnabled: Boolean;
    FImageIndex: Integer;
    FCaption: String;
    FCustomOptions: TscGPTabOptions;
    FUseCustomOptions: Boolean;
    FCustomFrameColor: TColor;
    FCustomFrameColorAlpha: Byte;
    FCustomGlowEffect: TscButtonGlowEffect;
    FShowCloseButton: Boolean;
    procedure SetShowCloseButton(Value: Boolean);
    procedure SetCaption(Value: String);
    procedure SetEnabled(Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure SetUseCustomOptions(Value: Boolean);
    procedure SetCustomFrameColor(Value: TColor);
    procedure SetCustomFrameColorAlpha(Value: Byte);
    procedure OnOptionsChange(Sender: TObject);
  public
    Active: Boolean;
    TabRect: TRect;
    CloseButtonRect: TRect;
    CloseButtonMouseIn, CloseButtonMouseDown:Boolean;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Caption: String read FCaption write SetCaption;
    property CustomOptions: TscGPTabOptions
      read FCustomOptions write FCustomOptions;
    property CustomGlowEffect: TscButtonGlowEffect read
      FCustomGlowEffect write FCustomGlowEffect;
    property CustomFrameColor: TColor
      read FCustomFrameColor write SetCustomFrameColor;
    property CustomFrameColorAlpha: Byte
      read FCustomFrameColorAlpha write SetCustomFrameColorAlpha;
    property ShowCloseButton: Boolean
      read FShowCloseButton write SetShowCloseButton;
    property UseCustomOptions: Boolean
      read FUseCustomOptions write SetUseCustomOptions;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TscGPTabControlTabs = class(TCollection)
  private
    function GetItem(Index: Integer):  TscGPTabControlTab;
    procedure SetItem(Index: Integer; Value:  TscGPTabControlTab);
  protected
    TabControl: TscGPTabControl;
    DestroyTab: TscGPTabControlTab;
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ATabControl: TscGPTabControl);
    function Add: TscGPTabControlTab;
    function Insert(Index: Integer): TscGPTabControlTab;
    procedure Delete(Index: Integer);
    procedure Clear;
    property Items[Index: Integer]: TscGPTabControlTab read GetItem write SetItem; default;
  end;


  TscGPTabControl = class(TscCustomControl)
  private
    FEnableDragReorderTabs: Boolean;
    FDragSourceTab: TscGPTabControlTab;
    FTabsBGFillColor: TColor;
    FTabsBGFillColorAlpha: Byte;
    FFrameWidth: Integer;
    FFrameScaleWidth: Boolean;
    FFrameColor: TColor;
    FFrameColorAlpha: Byte;
    FTabOptions: TscGPTabOptions;
    FTabCloseButtonOptions: TscGPTabCloseButtonOptions;
    FShowCloseButtons: Boolean;
    FBorderStyle: TscGPTabControlBorderStyle;
    FMouseWheelSupport: Boolean;
    FShowInActiveTab: Boolean;
    FScrollOffset: Integer;
    FScrollVisible: Boolean;
    FOldWidth: Integer;
    FMouseIn: Boolean;
    FTabIndex: Integer;
    FTabIndexBeforeFocused, FTabIndexAfterFocused: Integer;
    FTabs: TscGPTabControlTabs;
    FLeftOffset, FRightOffset: Integer;
    FOldTabActive, FTabActive: Integer;
    FTabHeight: Integer;
    FTabImages: TCustomImageList;
    FOnChangeTab: TNotifyEvent;
    FOnChangingTab: TNotifyEvent;
    FOnCanChangeTab: TscCanChangePageEvent;
    FShowCloseButtonOnActiveTabOnly:  Boolean;
    FStopCloseTab: Boolean;

    FTabSpacing,
    FTabMargin, FTabWidth: Integer;

    FTabGlowEffect: TscButtonGlowEffect;

    FTabsLeftOffset,
    FTabsRightOffset, FTabsTopOffset: Integer;
    FLeftScrollButton, FRightScrollButton: TscGPTabScrollButton;
    FLeftTabIndex, FRightTabIndex: Integer;
    FShowFocusRect: Boolean;
    FDeleteOnClose: Boolean;
    FOnClose: TscTabCloseEvent;
    FOnGetTabDrawParams: TscGPGetAdvTabDrawParamsEvent;

    FScrollButtonWidth: Integer;
    FScrollButtonArrowColor: TColor;
    FScrollButtonArrowThickness: Byte;
    FScrollButtonColor: TColor;
    FScrollButtonTransparent: Boolean;

    FCloseButtonSize: Integer;

    FTabsScaling: Boolean;

    FTabsRect: TRect;

    FOnGetTabImage: TscGPOnGetTabImageEvent;
    FOnTabsAreaClick: TNotifyEvent;

    procedure SetShowCloseButtonOnActiveTabOnly(Value: Boolean);
    procedure SetTabWidth(Value: Integer);
    procedure SetTabsBGFillColor(Value: TColor);
    procedure SetTabsBGFillColorAlpha(Value: Byte);

    procedure SetFrameWidth(Value: Integer);
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameColorAlpha(Value: Byte);

    procedure SetScrollButtonWidth(Value: Integer);
    procedure SetScrollButtonArrowColor(Value: TColor);
    procedure SetScrollButtonArrowThickness(Value: Byte);
    procedure SetScrollButtonColor(Value: TColor);
    procedure SetScrollButtonTransparent(Value: Boolean);

    procedure SetShowCloseButtons(Value: Boolean);
    procedure SetBorderStyle(Value: TscGPTabControlBorderStyle);
    procedure SetShowInActiveTab(Value: Boolean);
    procedure SetShowFocusRect(Value: Boolean);
    procedure SetTabsTopOffset(Value: Integer);
    procedure SetTabsLeftOffset(Value: Integer);
    procedure SetTabsRightOffset(Value: Integer);
    procedure SetTabSpacing(Value: Integer);
    procedure SetTabMargin(Value: Integer);
    procedure SetTabs(AValue: TscGPTabControlTabs);
    function GetPageBoundsRect: TRect;
    procedure SetTabIndex(Value: Integer);
    procedure SetTabHeight(Value: Integer);
    procedure SetTabImages(Value: TCustomImageList);
    procedure OnControlChange(Sender: TObject);
    procedure ShowScrollButtons;
    procedure HideScrollButtons;
    procedure OnLeftScrollButtonClick(Sender: TObject);
    procedure OnRightScrollButtonClick(Sender: TObject);
    procedure AdjustScrollButtons;
    procedure UpdateScrollButtons;
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure ChangeScale(M, D: Integer{$IFDEF VER310_UP}; isDpiChange: Boolean{$ENDIF}); override;
    procedure SetTransparentBackground(Value: Boolean); override;
    procedure DrawCloseButton(ACanvas: TCanvas; G: TGPGraphics; ARect: TRect; AIndex: Integer; AColor: TColor);
    procedure ScrollToLeft;
    procedure ScrollToRight;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMOUSEWHEEL(var Message: TWMMOUSEWHEEL); message WM_MOUSEWHEEL;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure TestActive(X, Y: Integer);
    procedure Loaded; override;
    function GetTabWidth(AIndex: Integer): Integer;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CalcTabRects;
    procedure DrawTab(ACanvas: TCanvas; G: TGPGraphics; Index: Integer; AFirst: Boolean);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure GetScrollInfo;

    procedure ScrollToTab(AIndex: Integer);
    procedure Draw(ACanvas: TCanvas; ACtrlState: TscsCtrlState); override;

    function FindDrawNextTabFromIndex(AIndex: Integer): Integer;
    function FindDrawPriorTabFromIndex(AIndex: Integer): Integer;

    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
  public
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

    procedure DoClose;
    procedure FindNextTab;
    procedure FindPriorTab;
    procedure FindFirstTab;
    procedure FindLastTab;
    function FindNextTabFromIndex(AIndex: Integer): Integer;
    function FindPriorTabFromIndex(AIndex: Integer): Integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateControls; override;
    procedure UpdateTabs;
    function TabFromPoint(P: TPoint): Integer;
  published
    property Align;
    property Font;
    property Color;
    property DrawTextMode;

    property EnableDragReorderTabs: Boolean
      read FEnableDragReorderTabs write FEnableDragReorderTabs;

    property TabsBGFillColor: TColor
      read FTabsBGFillColor write SetTabsBGFillColor;
    property TabsBGFillColorAlpha: Byte
      read FTabsBGFillColorAlpha write SetTabsBGFillColorAlpha;

    property TransparentBackground;
    property FrameWidth: Integer
      read FFrameWidth write SetFrameWidth;
    property FrameScaleWidth: Boolean
      read FFrameScaleWidth write FFrameScaleWidth;
    property FrameColor: TColor
      read FFrameColor write SetFrameColor;
    property FrameColorAlpha: Byte
      read FFrameColorAlpha write SetFrameColorAlpha;
    property BorderStyle: TscGPTabControlBorderStyle
      read FBorderStyle write SetBorderStyle;
    property MouseWheelSupport: Boolean
      read FMouseWheelSupport write FMouseWheelSupport;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect;
    property ShowInActiveTab: Boolean read FShowInactiveTab write SetShowInActiveTab;
    property ShowCloseButtons: Boolean read FShowCloseButtons write SetShowCloseButtons;
    property ShowCloseButtonOnActiveTabOnly: Boolean
      read FShowCloseButtonOnActiveTabOnly write SetShowCloseButtonOnActiveTabOnly;
    property TabsLeftOffset: Integer
      read FTabsLeftOffset write SetTabsLeftOffset;
    property TabsRightOffset: Integer
      read FTabsRightOffset write SetTabsRightOffset;
    property TabsTopOffset: Integer
      read FTabsTopOffset write SetTabsTopOffset;
    property TabGlowEffect: TscButtonGlowEffect read FTabGlowEffect write FTabGlowEffect;
    property TabOptions: TscGPTabOptions read FTabOptions write FTabOptions;
    property TabCloseButtonOptions: TscGPTabCloseButtonOptions read FTabCloseButtonOptions write FTabCloseButtonOptions;

    property TabSpacing: Integer read FTabSpacing write SetTabSpacing;
    property TabMargin: Integer read FTabMargin write SetTabMargin;
    property TabWidth: Integer read FTabWidth write SetTabWidth;

    property ScrollButtonWidth: Integer
      read FScrollButtonWidth write SetScrollButtonWidth;
    property ScrollButtonArrowColor: TColor
      read FScrollButtonArrowColor write SetScrollButtonArrowColor;
    property ScrollButtonArrowThickness: Byte
      read FScrollButtonArrowThickness write SetScrollButtonArrowThickness;
    property ScrollButtonColor: TColor
      read FScrollButtonColor write SetScrollButtonColor;
    property ScrollButtonTransparent: Boolean
      read FScrollButtonTransparent write SetScrollButtonTransparent;

    property TabHeight: Integer read FTabHeight write SetTabHeight;
    property Tabs: TscGPTabControlTabs read FTabs write SetTabs;
    property TabIndex: Integer read FTabIndex write SetTabIndex;
    property TabImages: TCustomImageList
      read FTabImages write SetTabImages;
    property DeleteOnClose: Boolean read FDeleteOnClose write FDeleteOnClose;

    property StorePaintBuffer;

    property OnChangingTab: TNotifyEvent read FOnChangingTab write FOnChangingTab;
    property OnChangeTab: TNotifyEvent read FOnChangeTab write FOnChangeTab;
    property OnCanChangeTab: TscCanChangePageEvent
      read FOnCanChangeTab write FOnCanChangeTab;
    property OnClose: TscTabCloseEvent read FOnClose write FOnClose;
    property OnGetTabDrawParams: TscGPGetAdvTabDrawParamsEvent
      read FOnGetTabDrawParams write FOnGetTabDrawParams;

    property OnGetTabImage: TscGPOnGetTabImageEvent
      read FOnGetTabImage write FOnGetTabImage;
    property OnTabsAreaClick: TNotifyEvent
      read FOnTabsAreaClick write FOnTabsAreaClick;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TscGPToolPager = class;
  TscGPToolPagerPage = class(TscGPScrollPanel)
  protected
    FDestroyFromPager: Boolean;
  public
    Pager: TscGPToolPager;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
      AHeight: Integer); override;
  end;

  TscGPToolPagerTab = class(TCollectionItem)
  protected
    FOnClick: TNotifyEvent;
    FPage: TscGPToolPagerPage;
    FVisible: Boolean;
    FEnabled: Boolean;
    FImageIndex: Integer;
    FCaption: String;
    FCustomOptions: TscGPTabOptions;
    FUseCustomOptions: Boolean;
    FCustomFrameColor: TColor;
    FCustomFrameColorAlpha: Byte;
    FCustomGlowEffect: TscButtonGlowEffect;
    FShowCloseButton: Boolean;
    procedure SetShowCloseButton(Value: Boolean);
    procedure SetPage(const Value: TscGPToolPagerPage);
    procedure SetCaption(Value: String);
    procedure SetEnabled(Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure SetUseCustomOptions(Value: Boolean);
    procedure SetCustomFrameColor(Value: TColor);
    procedure SetCustomFrameColorAlpha(Value: Byte);
    procedure OnOptionsChange(Sender: TObject);
  public
    Active: Boolean;
    TabRect: TRect;
    CloseButtonRect: TRect;
    CloseButtonMouseIn, CloseButtonMouseDown:Boolean;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Page: TscGPToolPagerPage read FPage write SetPage;
    property Visible: Boolean read FVisible write SetVisible;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Caption: String read FCaption write SetCaption;
    property CustomOptions: TscGPTabOptions
      read FCustomOptions write FCustomOptions;
    property CustomGlowEffect: TscButtonGlowEffect read
      FCustomGlowEffect write FCustomGlowEffect;
    property CustomFrameColor: TColor
      read FCustomFrameColor write SetCustomFrameColor;
    property CustomFrameColorAlpha: Byte
      read FCustomFrameColorAlpha write SetCustomFrameColorAlpha;
    property ShowCloseButton: Boolean
      read FShowCloseButton write SetShowCloseButton;
    property UseCustomOptions: Boolean
      read FUseCustomOptions write SetUseCustomOptions;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TscGPToolPagerTabs = class(TCollection)
  private
    function GetItem(Index: Integer):  TscGPToolPagerTab;
    procedure SetItem(Index: Integer; Value:  TscGPToolPagerTab);
  protected
    FClearing: Boolean;
    Pager: TscGPToolPager;
    DestroyPage: TscGPToolPagerPage;
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(APager: TscGPToolPager);
    function Add: TscGPToolPagerTab;
    function Insert(Index: Integer): TscGPToolPagerTab;
    procedure Delete(Index: Integer);
    procedure Clear;
    property Items[Index: Integer]: TscGPToolPagerTab read GetItem write SetItem; default;
  end;

  TscGPToolPager = class(TscCustomControl)
  private
    FEnableDragReorderTabs: Boolean;
    FDragSourceTab: TscGPToolPagerTab;
    FTabsScaling: Boolean;
    FTabsBGFillColor: TColor;
    FTabsBGFillColorAlpha: Byte;
    FFrameWidth: Integer;
    FFrameScaleWidth: Boolean;
    FFrameColor: TColor;
    FFrameColorAlpha: Byte;
    FTabOptions: TscGPTabOptions;
    FTabCloseButtonOptions: TscGPTabCloseButtonOptions;
    FShowCloseButtons: Boolean;
    FBorderStyle: TscGPTabControlBorderStyle;
    FMouseWheelSupport: Boolean;
    FShowInActiveTab: Boolean;
    FScrollOffset: Integer;
    FScrollVisible: Boolean;
    FOldWidth: Integer;
    FMouseIn: Boolean;
    FTabIndex: Integer;
    FTabIndexBeforeFocused, FTabIndexAfterFocused: Integer;
    FTabs: TscGPToolPagerTabs;
    FLeftOffset, FRightOffset: Integer;
    FOldTabActive, FTabActive: Integer;
    FActivePage: TscGPToolPagerPage;
    FTabHeight: Integer;
    FTabImages: TCustomImageList;
    FOnChangePage: TNotifyEvent;
    FOnChangingPage: TNotifyEvent;
    FOnCanChangePage: TscCanChangePageEvent;

    FTabSpacing,
    FTabMargin: Integer;

    FTabGlowEffect: TscButtonGlowEffect;

    FTabsLeftOffset,
    FTabsRightOffset, FTabsTopOffset: Integer;
    FLeftScrollButton, FRightScrollButton: TscGPTabScrollButton;
    FLeftTabIndex, FRightTabIndex: Integer;
    FShowFocusRect: Boolean;
    FFreeOnClose: Boolean;
    FOnClose: TscTabCloseEvent;
    FOnGetTabDrawParams: TscGPGetAdvTabDrawParamsEvent;

    FScrollButtonWidth: Integer;
    FScrollButtonArrowColor: TColor;
    FScrollButtonArrowThickness: Byte;
    FScrollButtonColor: TColor;
    FScrollButtonTransparent: Boolean;

    FCloseButtonSize: Integer;
    FStopSetFocus: Boolean;
    FSaveFocusOnActiveControl: Boolean;

    FTabsRect: TRect;
    FPageRect: TRect;

    FOnGetTabImage: TscGPOnGetTabImageEvent;
    FOnTabsAreaClick: TNotifyEvent;

    procedure SetTabsBGFillColor(Value: TColor);
    procedure SetTabsBGFillColorAlpha(Value: Byte);

    procedure SetFrameWidth(Value: Integer);
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameColorAlpha(Value: Byte);

    procedure SetScrollButtonWidth(Value: Integer);
    procedure SetScrollButtonArrowColor(Value: TColor);
    procedure SetScrollButtonArrowThickness(Value: Byte);
    procedure SetScrollButtonColor(Value: TColor);
    procedure SetScrollButtonTransparent(Value: Boolean);

    procedure SetShowCloseButtons(Value: Boolean);
    procedure SetBorderStyle(Value: TscGPTabControlBorderStyle);
    procedure SetShowInActiveTab(Value: Boolean);
    procedure SetShowFocusRect(Value: Boolean);
    procedure SetTabsTopOffset(Value: Integer);
    procedure SetTabsLeftOffset(Value: Integer);
    procedure SetTabsRightOffset(Value: Integer);
    procedure SetTabSpacing(Value: Integer);
    procedure SetTabMargin(Value: Integer);
    procedure SetTabs(AValue: TscGPToolPagerTabs);
    procedure SetActivePage(const Value: TscGPToolPagerPage);
    function GetPageBoundsRect: TRect;
    procedure SetTabIndex(Value: Integer);
    procedure SetTabHeight(Value: Integer);
    procedure SetTabImages(Value: TCustomImageList);
    procedure OnControlChange(Sender: TObject);
    procedure ShowScrollButtons;
    procedure HideScrollButtons;
    procedure OnLeftScrollButtonClick(Sender: TObject);
    procedure OnRightScrollButtonClick(Sender: TObject);
    procedure AdjustScrollButtons;
    procedure UpdateScrollButtons;
  protected
    procedure ChangeScale(M, D: Integer{$IFDEF VER310_UP}; isDpiChange: Boolean{$ENDIF}); override;
    procedure SetTransparentBackground(Value: Boolean); override;
    procedure DrawCloseButton(ACanvas: TCanvas; G: TGPGraphics; ARect: TRect; AIndex: Integer; AColor: TColor);
    procedure ScrollToLeft;
    procedure ScrollToRight;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WMSETFOCUS(var Message: TWMSETFOCUS); message WM_SETFOCUS;
    procedure WMKILLFOCUS(var Message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMOUSEWHEEL(var Message: TWMMOUSEWHEEL); message WM_MOUSEWHEEL;
    procedure WMTimer(var Message: TWMTimer); message WM_Timer;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure TestActive(X, Y: Integer);
    procedure Loaded; override;
    function GetTabWidth(AIndex: Integer): Integer;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CalcTabRects;
    procedure DrawTab(ACanvas: TCanvas; G: TGPGraphics; Index: Integer; AFirst: Boolean);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure GetScrollInfo;

    procedure ScrollToTab(AIndex: Integer);
    procedure Draw(ACanvas: TCanvas; ACtrlState: TscsCtrlState); override;

    function FindDrawNextTabFromIndex(AIndex: Integer): Integer;
    function FindDrawPriorTabFromIndex(AIndex: Integer): Integer;

    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
  public
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

    procedure DoClose;
    procedure FindNextTab;
    procedure FindPriorTab;
    procedure FindFirstTab;
    procedure FindLastTab;
    function FindNextTabFromIndex(AIndex: Integer): Integer;
    function FindPriorTabFromIndex(AIndex: Integer): Integer;
    function GetPageIndex(Value: TscGPToolPagerPage): Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CreatePage: TscGPToolPagerPage;
    procedure UpdateTabs;
    procedure UpdateControls; override;
    function TabFromPoint(P: TPoint): Integer;

    property SaveFocusOnActiveControl: Boolean
      read FSaveFocusOnActiveControl write FSaveFocusOnActiveControl;
  published
    property Align;
    property Font;
    property Color;
    property DrawTextMode;

    property EnableDragReorderTabs: Boolean
      read FEnableDragReorderTabs write FEnableDragReorderTabs;

    property TabsBGFillColor: TColor
      read FTabsBGFillColor write SetTabsBGFillColor;
    property TabsBGFillColorAlpha: Byte
      read FTabsBGFillColorAlpha write SetTabsBGFillColorAlpha;

    property TransparentBackground;
    property FrameWidth: Integer
      read FFrameWidth write SetFrameWidth;
    property FrameScaleWidth: Boolean
      read FFrameScaleWidth write FFrameScaleWidth;
    property FrameColor: TColor
      read FFrameColor write SetFrameColor;
    property FrameColorAlpha: Byte
      read FFrameColorAlpha write SetFrameColorAlpha;
    property BorderStyle: TscGPTabControlBorderStyle
      read FBorderStyle write SetBorderStyle;
    property MouseWheelSupport: Boolean
      read FMouseWheelSupport write FMouseWheelSupport;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect;
    property ShowInActiveTab: Boolean read FShowInactiveTab write SetShowInActiveTab;
    property ShowCloseButtons: Boolean read FShowCloseButtons write SetShowCloseButtons;
    property TabsLeftOffset: Integer
      read FTabsLeftOffset write SetTabsLeftOffset;
    property TabsRightOffset: Integer
      read FTabsRightOffset write SetTabsRightOffset;
    property TabsTopOffset: Integer
      read FTabsTopOffset write SetTabsTopOffset;
    property TabGlowEffect: TscButtonGlowEffect read FTabGlowEffect write FTabGlowEffect;
    property TabOptions: TscGPTabOptions read FTabOptions write FTabOptions;
    property TabCloseButtonOptions: TscGPTabCloseButtonOptions read FTabCloseButtonOptions write FTabCloseButtonOptions;

    property TabSpacing: Integer read FTabSpacing write SetTabSpacing;
    property TabMargin: Integer read FTabMargin write SetTabMargin;

    property ScrollButtonWidth: Integer
      read FScrollButtonWidth write SetScrollButtonWidth;
    property ScrollButtonArrowColor: TColor
      read FScrollButtonArrowColor write SetScrollButtonArrowColor;
    property ScrollButtonArrowThickness: Byte
      read FScrollButtonArrowThickness write SetScrollButtonArrowThickness;
    property ScrollButtonColor: TColor
      read FScrollButtonColor write SetScrollButtonColor;
    property ScrollButtonTransparent: Boolean
      read FScrollButtonTransparent write SetScrollButtonTransparent;

    property TabHeight: Integer read FTabHeight write SetTabHeight;
    property Tabs: TscGPToolPagerTabs read FTabs write SetTabs;
    property TabIndex: Integer read FTabIndex write SetTabIndex;
    property ActivePage: TscGPToolPagerPage read FActivePage write SetActivePage;
    property TabImages: TCustomImageList
      read FTabImages write SetTabImages;
    property FreeOnClose: Boolean read FFreeOnClose write FFreeOnClose;

    property StorePaintBuffer;

    property OnChangingPage: TNotifyEvent read FOnChangingPage write FOnChangingPage;
    property OnChangePage: TNotifyEvent read FOnChangePage write FOnChangePage;
    property OnCanChangePage: TscCanChangePageEvent
      read FOnCanChangePage write FOnCanChangePage;
    property OnClose: TscTabCloseEvent read FOnClose write FOnClose;
    property OnGetTabDrawParams: TscGPGetAdvTabDrawParamsEvent
      read FOnGetTabDrawParams write FOnGetTabDrawParams;

    property OnGetTabImage: TscGPOnGetTabImageEvent
      read FOnGetTabImage write FOnGetTabImage;
    property OnTabsAreaClick: TNotifyEvent
      read FOnTabsAreaClick write FOnTabsAreaClick;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TscGPToolGroupPanel = class(TscCustomActiveControl)
  private
    FCaptionHeight: Integer;
    FShowDialogButton: Boolean;
    FOnDialogButtonClick: TNotifyEvent;
    FCaptionFontColor: TColor;
    FCaptionFontDisabledColor: TColor;
    FSeparatorColor: TColor;
    FSeparatorColorAlpha: Byte;
    FDialogButtonColor: TColor;
    procedure SetDialogButtonColor(Value: TColor);
    procedure SetSeparatorColor(Value: TColor);
    procedure SetSeparatorColorAlpha(Value: Byte);
    procedure SetCaptionHeight(Value: Integer);
    procedure SetShowDialogButton(Value: Boolean);
    procedure SetCaptionFontColor(Value: TColor);
    procedure SetCaptionFontDisabledColor(Value: TColor);
  protected
    FButtonRect: TRect;
    FButtonMouseIn: Boolean;
    FButtonPressed: Boolean;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure Draw(ACanvas: TCanvas; ACtrlState: TscsCtrlState); override;
    procedure DrawDialogButton(ACanvas: TCanvas; G: TGPGraphics);
    procedure DoMouseLeave; override;
    procedure ChangeScale(M, D: Integer{$IFDEF VER310_UP}; isDpiChange: Boolean{$ENDIF}); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption;
    property CaptionHeight: Integer read FCaptionHeight write SetCaptionHeight;
    property CaptionFontColor: TColor read
      FCaptionFontColor write SetCaptionFontColor;
    property CaptionFontDisabledColor: TColor read
      FCaptionFontDisabledColor write SetCaptionFontDisabledColor;
    property DrawTextMode;
    property DialogButtonColor: TColor
      read FDialogButtonColor write SetDialogButtonColor;
    property ShowDialogButton: Boolean read FShowDialogButton write SetShowDialogButton;
    property StorePaintBuffer;
    property SeparatorColor: TColor
      read FSeparatorColor write SetSeparatorColor;
    property SeparatorColorAlpha: Byte
      read FSeparatorColorAlpha write SetSeparatorColorAlpha;
    property OnDialogButtonClick: TNotifyEvent
      read FOnDialogButtonClick write FOnDialogButtonClick;
  end;

  TscGPPageViewer = class;
  TscGPPageViewerItem = class;
  TscGPPageViewerPage = class;

  TscGPPageViewerItem = class(TCollectionItem)
  protected
    FPage: TscGPPageViewerPage;
    procedure SetPage(const Value: TscGPPageViewerPage);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Page: TscGPPageViewerPage read FPage write SetPage;
  end;

  TscGPPageViewerItems = class(TCollection)
  private
    function GetItem(Index: Integer):  TscGPPageViewerItem;
    procedure SetItem(Index: Integer; Value:  TscGPPageViewerItem);
  protected
    PageViewer: TscGPPageViewer;
    DestroyPage: TscGPPageViewerPage;
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(APageViewer: TscGPPageViewer);
    function Add: TscGPPageViewerItem;
    function Insert(Index: Integer): TscGPPageViewerItem;
    procedure Delete(Index: Integer);
    property Items[Index: Integer]: TscGPPageViewerItem read GetItem write SetItem; default;
  end;

  TscGPPageViewerPage = class(TscGPPanel)
  public
    PageViewer: TscGPPageViewer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
      AHeight: Integer); override;
  end;

  TscGPPageViewer = class(TscCustomControl)
  private
    FPageIndex: Integer;
    FPages: TscGPPageViewerItems;
    FActivePage: TscGPPageViewerPage;
    FOnChangePage: TNotifyEvent;
    FOnChangingPage: TNotifyEvent;
    FOnCanChangePage: TscCanChangePageEvent;
    procedure SetPages(AValue: TscGPPageViewerItems);
    procedure SetActivePage(const Value: TscGPPageViewerPage);
    procedure SetPageIndex(Value: Integer);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Loaded; override;
    function GetPageBoundsRect: TRect;
    procedure WMSIZE(var Message: TWMSIZE); message WM_SIZE;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure GetParentBG; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateControls; override;
    procedure Paint; override;
    function GetPageIndex(Value: TscGPPageViewerPage): Integer;
    function CreatePage: TscGPPageViewerPage;
  published
    property Align;
    property Font;
    property Color;
    property PageIndex: Integer read FPageIndex write SetPageIndex;
    property Pages: TscGPPageViewerItems read FPages write SetPages;
    property ActivePage: TscGPPageViewerPage read FActivePage write SetActivePage;
    property OnChangePage: TNotifyEvent read FOnChangePage write FOnChangePage;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

implementation

  Uses System.Types, System.Math, System.UITypes, Vcl.Clipbrd,
    Vcl.Dialogs, Vcl.Menus;

const
  DefPagerTabWidth = 200;
  DefPagerTabHeight = 30;
  DefDividerTabHeight = 20;
  TAB_CLOSE_SIZE = 16;


constructor TscGPTabCloseButtonOptions.Create;
begin
  inherited;
  {$IFDEF VER340_UP}
  FControl := nil;
  {$ENDIF}
  FNormalColor := clBtnText;
  FNormalColorAlpha := 0;
  FHotColor := clRed;
  FHotColorAlpha := 220;
  FPressedColor := clRed;
  FPressedColorAlpha := 200;
  FDisabledColor := clBtnText;
  FDisabledColorAlpha := 0;
  FGlyphNormalColor := clBtnText;
  FGlyphNormalColorAlpha := 200;
  FGlyphHotColor := clWhite;
  FGlyphHotColorAlpha := 255;
  FGlyphPressedColor := clWhite;
  FGlyphPressedColorAlpha := 200;
  FGlyphDisabledColor := clBtnText;
  FGlyphDisabledColorAlpha := 100;
  FShapeKind := scgptcbRounded;
  FStyleColors := True;
end;

procedure TscGPTabCloseButtonOptions.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TscGPTabCloseButtonOptions.SetShapeKind(Value: TscGPTabCloseButtonShapeKind);
begin
  if FShapeKind <> Value then
  begin
    FShapeKind := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetStyleColors(Value: Boolean);
begin
  if FStyleColors <> Value then
  begin
    FStyleColors := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetNormalColor(Value: TColor);
begin
  if FNormalColor <> Value then
  begin
    FNormalColor := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetPressedColor(Value: TColor);
begin
  if FPressedColor <> Value then
  begin
    FPressedColor := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetNormalColorAlpha(Value: Byte);
begin
   if FNormalColorAlpha <> Value then
  begin
    FNormalColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetHotColorAlpha(Value: Byte);
begin
   if FHotColorAlpha <> Value then
  begin
    FHotColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetPressedColorAlpha(Value: Byte);
begin
   if FPressedColorAlpha <> Value then
  begin
    FPressedColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetDisabledColorAlpha(Value: Byte);
begin
   if FDisabledColorAlpha <> Value then
  begin
    FDisabledColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetGlyphNormalColor(Value: TColor);
begin
  if FGlyphNormalColor <> Value then
  begin
    FGlyphNormalColor := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetGlyphHotColor(Value: TColor);
begin
  if FGlyphHotColor <> Value then
  begin
    FGlyphHotColor := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetGlyphPressedColor(Value: TColor);
begin
  if FGlyphPressedColor <> Value then
  begin
    FGlyphPressedColor := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetGlyphDisabledColor(Value: TColor);
begin
  if FGlyphDisabledColor <> Value then
  begin
    FGlyphDisabledColor := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetGlyphNormalColorAlpha(Value: Byte);
begin
   if FGlyphNormalColorAlpha <> Value then
  begin
    FGlyphNormalColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetGlyphHotColorAlpha(Value: Byte);
begin
   if FGlyphHotColorAlpha <> Value then
  begin
    FGlyphHotColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetGlyphPressedColorAlpha(Value: Byte);
begin
   if FGlyphPressedColorAlpha <> Value then
  begin
    FGlyphPressedColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.SetGlyphDisabledColorAlpha(Value: Byte);
begin
   if FGlyphDisabledColorAlpha <> Value then
  begin
    FGlyphDisabledColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabCloseButtonOptions.Assign(Source: TPersistent);
begin
  if Source is TscGPTabCloseButtonOptions then
  begin
    FNormalColor := TscGPTabCloseButtonOptions(Source).FNormalColor;
    FNormalColorAlpha := TscGPTabCloseButtonOptions(Source).FNormalColorAlpha;
    FHotColor := TscGPTabCloseButtonOptions(Source).FHotColor;
    FHotColorAlpha := TscGPTabCloseButtonOptions(Source).FHotColorAlpha;
    FPressedColor := TscGPTabCloseButtonOptions(Source).FPressedColor;
    FPressedColorAlpha := TscGPTabCloseButtonOptions(Source).FPressedColorAlpha;
    FDisabledColor := TscGPTabCloseButtonOptions(Source).FDisabledColor;
    FDisabledColorAlpha := TscGPTabCloseButtonOptions(Source).FDisabledColorAlpha;
    FGlyphNormalColor := TscGPTabCloseButtonOptions(Source).FGlyphNormalColor;
    FGlyphNormalColorAlpha := TscGPTabCloseButtonOptions(Source).FGlyphNormalColorAlpha;
    FGlyphHotColor := TscGPTabCloseButtonOptions(Source).FGlyphHotColor;
    FGlyphHotColorAlpha := TscGPTabCloseButtonOptions(Source).FGlyphHotColorAlpha;
    FGlyphPressedColor := TscGPTabCloseButtonOptions(Source).FGlyphPressedColor;
    FGlyphPressedColorAlpha := TscGPTabCloseButtonOptions(Source).FGlyphPressedColorAlpha;
    FGlyphDisabledColor := TscGPTabCloseButtonOptions(Source).FGlyphDisabledColor;
    FGlyphDisabledColorAlpha := TscGPTabCloseButtonOptions(Source).FGlyphDisabledColorAlpha;
    FShapeKind := TscGPTabCloseButtonOptions(Source).FShapeKind;
    FStyleColors := TscGPTabCloseButtonOptions(Source).FStyleColors;
  end
  else
    inherited Assign(Source);
end;

function TscGPTabCloseButtonOptions.GetColor: TColor;
begin
  Result := FNormalColor;
  case FState of
    scsHot: Result := FHotColor;
    scsPressed: Result := FPressedColor;
    scsDisabled: Result := FDisabledColor;
  end;
  if FStyleColors then
    Result := GetStyleColor(Result{$IFDEF VER340_UP}, FControl{$ENDIF});
end;

function TscGPTabCloseButtonOptions.GetGlyphColor: TColor;
begin
  Result := FGlyphNormalColor;
  case FState of
    scsHot: Result := FGlyphHotColor;
    scsPressed: Result := FGlyphPressedColor;
    scsDisabled: Result := FGlyphDisabledColor;
  end;
  if FStyleColors then
    Result := GetStyleColor(Result{$IFDEF VER340_UP}, FControl{$ENDIF});
end;

function TscGPTabCloseButtonOptions.GetColorAlpha: Byte;
begin
  Result := FNormalColorAlpha;
  case FState of
    scsHot: Result := FHotColorAlpha;
    scsPressed: Result := FPressedColorAlpha;
    scsDisabled: Result := FDisabledColorAlpha;
  end;
end;

function TscGPTabCloseButtonOptions.GetGlyphColorAlpha: Byte;
begin
  Result := FGlyphNormalColorAlpha;
  case FState of
    scsHot: Result := FGlyphHotColorAlpha;
    scsPressed: Result := FGlyphPressedColorAlpha;
    scsDisabled: Result := FGlyphDisabledColorAlpha;
  end;
end;

constructor TscGPTabOptions.Create;
begin
  inherited;
  {$IFDEF VER340_UP}
  FControl := nil;
  {$ENDIF}
  FTabStyle := gptsShape;
  FShapeFillStyle := scgpsfColor;
  FShapeFillGradientAngle := 90;
  FGradientColorOffset := 30;

  FNormalColor := clBtnShadow;
  FActiveColor := clBtnFace;
  FFocusedColor := clBtnFace;
  FMouseInColor := clBtnShadow;

  FNormalColorAlpha := 70;
  FMouseInColorAlpha := 40;
  FFocusedColorAlpha := 255;
  FActiveColorAlpha := 230;


  FFrameNormalColor := clBtnText;
  FFrameActiveColor := clBtnText;
  FFrameMouseInColor := clBtnText;
  FFrameFocusedColor := clBtnText;

  FFrameNormalColorAlpha := 50;
  FFrameActiveColorAlpha := 80;
  FFrameMouseInColorAlpha := 60;
  FFrameFocusedColorAlpha := 80;

  FFontNormalColor := clBtnText;
  FFontActiveColor := clBtnText;
  FFontMouseInColor := clBtnText;
  FFontFocusedColor := clBtnText;

  FFrameWidth := 2;

  FStyleColors := True;
  FOnChange := nil;
  FState := scsNormal;

  FShapeCornerRadius := 5;
  FLineWidth := 0;
end;

procedure TscGPTabOptions.Assign(Source: TPersistent);
begin
  if Source is TscGPTabOptions then
  begin
    FNormalColor := TscGPTabOptions(Source).FNormalColor;
    FActiveColor := TscGPTabOptions(Source).FActiveColor;
    FMouseInColor := TscGPTabOptions(Source).FMouseInColor;
    FFocusedColor := TscGPTabOptions(Source).FFocusedColor;
    FFrameNormalColor := TscGPTabOptions(Source).FFrameNormalColor;
    FFrameActiveColor := TscGPTabOptions(Source).FFrameActiveColor;
    FFrameMouseInColor := TscGPTabOptions(Source).FFrameMouseInColor;
    FFrameFocusedColor := TscGPTabOptions(Source).FFrameFocusedColor;
    FFrameWidth := TscGPTabOptions(Source).FFrameWidth;
    FFontNormalColor := TscGPTabOptions(Source).FFontNormalColor;
    FFontActiveColor := TscGPTabOptions(Source).FFontActiveColor;
    FFontMouseInColor := TscGPTabOptions(Source).FFontMouseInColor;
    FFontFocusedColor := TscGPTabOptions(Source).FFontFocusedColor;
    FNormalColorAlpha := TscGPTabOptions(Source).FNormalColorAlpha;
    FActiveColorAlpha := TscGPTabOptions(Source).FActiveColorAlpha;
    FMouseInColorAlpha := TscGPTabOptions(Source).FMouseInColorAlpha;
    FFocusedColorAlpha := TscGPTabOptions(Source).FFocusedColorAlpha;
    FFrameNormalColorAlpha := TscGPTabOptions(Source).FFrameNormalColorAlpha;
    FFrameActiveColorAlpha := TscGPTabOptions(Source).FFrameActiveColorAlpha;
    FFrameMouseInColorAlpha := TscGPTabOptions(Source).FFrameMouseInColorAlpha;
    FFrameFocusedColorAlpha := TscGPTabOptions(Source).FFrameFocusedColorAlpha;
    FShapeCornerRadius := TscGPTabOptions(Source).FShapeCornerRadius;
    FShapeFillStyle :=  TscGPTabOptions(Source).FShapeFillStyle;
    FGradientColorOffset := TscGPTabOptions(Source).FGradientColorOffset;
    FStyleColors := TscGPTabOptions(Source).FStyleColors;
    FLineWidth :=  TscGPTabOptions(Source).FLineWidth;
  end
  else
    inherited Assign(Source);
end;

 function TscGPTabOptions.GetColorAlpha: Byte;
 begin
   Result := FNormalColorAlpha;
   case FState of
     scsHot: Result := FMouseInColorAlpha;
     scsPressed: Result := FActiveColorAlpha;
     scsFocused: Result := FFocusedColorAlpha;
   end;
 end;

 function TscGPTabOptions.GetFrameColorAlpha: Byte;
 begin
   Result := FFrameNormalColorAlpha;
   case FState of
     scsHot: Result := FFrameMouseInColorAlpha;
     scsPressed: Result := FFrameActiveColorAlpha;
     scsFocused: Result := FFrameFocusedColorAlpha;
   end;
 end;

procedure TscGPTabOptions.SetGradientColorOffset(Value: Byte);
begin
  if (FGradientColorOffset <> Value) and (Value <= 100) then
  begin
    FGradientColorOffset := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetShapeFillGradientAngle(Value: Integer);
begin
  if (Value >= -360) and (Value <= 360) and
     (FShapeFillGradientAngle <> Value) then
  begin
    FShapeFillGradientAngle := Value;
    if FShapeFillStyle = scgpsfGradient then
      Changed;
  end;
end;

procedure TscGPTabOptions.SetTabStyle(Value: TscGPTabStyle);
begin
  if FTabStyle <> Value then
  begin
    FTabStyle := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetShapeFillStyle(Value: TscGPShapeFillStyle);
begin
  if FShapeFillStyle <> Value then
  begin
    FShapeFillStyle := Value;
    Changed;
  end;
end;

function TscGPTabOptions.GetColor: TColor;
begin
  Result := FNormalColor;
  case FState of
    scsHot: Result := FMouseInColor;
    scsPressed: Result := FActiveColor;
    scsFocused: Result := FFocusedColor;
  end;
  if FStyleColors then
    Result := GetStyleColor(Result{$IFDEF VER340_UP}, FControl{$ENDIF});
end;

function TscGPTabOptions.GetFrameColor: TColor;
begin
  Result := FFrameNormalColor;
  case FState of
    scsHot: Result := FFrameMouseInColor;
    scsPressed: Result := FFrameActiveColor;
    scsFocused: Result := FFrameFocusedColor;
  end;
  if FStyleColors then
    Result := GetStyleColor(Result{$IFDEF VER340_UP}, FControl{$ENDIF});
end;

function TscGPTabOptions.GetFontColor: TColor;
begin
  Result := FFontNormalColor;
  case FState of
    scsHot: Result := FFontMouseInColor;
    scsPressed: Result := FFontActiveColor;
    scsFocused: Result := FFontFocusedColor;
  end;
  if FStyleColors then
    Result := GetStyleColor(Result{$IFDEF VER340_UP}, FControl{$ENDIF});
end;

procedure TscGPTabOptions.SetShapeCornerRadius(Value: Integer);
begin
  if (FShapeCornerRadius <> Value) and (Value >= 0) then
  begin
    FShapeCornerRadius := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetLineWidth(Value: Integer);
begin
  if (FLineWidth <> Value) and (Value >= 0) then
  begin
    FLineWidth := Value;
    Changed;
  end;
end;


procedure TscGPTabOptions.SetNormalColor(Value: TColor);
begin
  if FNormalColor <> Value then
  begin
    FNormalColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetActiveColor(Value: TColor);
begin
  if FActiveColor <> Value then
  begin
    FActiveColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetMouseInColor(Value: TColor);
begin
  if FMouseInColor <> Value then
  begin
    FMouseInColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFocusedColor(Value: TColor);
begin
  if FFocusedColor <> Value then
  begin
    FFocusedColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetNormalColorAlpha(Value: Byte);
begin
   if FNormalColorAlpha <> Value then
  begin
    FNormalColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetActiveColorAlpha(Value: Byte);
begin
  if FActiveColorAlpha <> Value then
  begin
    FActiveColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetMouseInColorAlpha(Value: Byte);
begin
  if FMouseInColorAlpha <> Value then
  begin
    FMouseInColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFocusedColorAlpha(Value: Byte);
begin
  if FFocusedColorAlpha <> Value then
  begin
    FFocusedColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameNormalColor(Value: TColor);
begin
  if FFrameNormalColor <> Value then
  begin
    FFrameNormalColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameActiveColor(Value: TColor);
begin
  if FFrameActiveColor <> Value then
  begin
    FFrameActiveColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameMouseInColor(Value: TColor);
begin
  if FFrameMouseInColor <> Value then
  begin
    FFrameMouseInColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameFocusedColor(Value: TColor);
begin
  if FFrameFocusedColor <> Value then
  begin
    FFrameFocusedColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameNormalColorAlpha(Value: Byte);
begin
   if FFrameNormalColorAlpha <> Value then
  begin
    FFrameNormalColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameActiveColorAlpha(Value: Byte);
begin
  if FFrameActiveColorAlpha <> Value then
  begin
    FFrameActiveColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameMouseInColorAlpha(Value: Byte);
begin
  if FFrameMouseInColorAlpha <> Value then
  begin
    FFrameMouseInColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameFocusedColorAlpha(Value: Byte);
begin
  if FFrameFocusedColorAlpha <> Value then
  begin
    FFrameFocusedColorAlpha := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFontNormalColor(Value: TColor);
begin
  if FFontNormalColor <> Value then
  begin
    FFontNormalColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFontActiveColor(Value: TColor);
begin
  if FFontActiveColor <> Value then
  begin
    FFontActiveColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFontMouseInColor(Value: TColor);
begin
  if FFontMouseInColor <> Value then
  begin
    FFontMouseInColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFontFocusedColor(Value: TColor);
begin
  if FFontFocusedColor <> Value then
  begin
    FFontFocusedColor := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetFrameWidth(Value: Integer);
begin
  if (FFrameWidth <> Value) and (Value > 0) then
  begin
    FFrameWidth := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.SetStyleColors(Value: Boolean);
begin
  if FStyleColors <> Value then
  begin
    FStyleColors := Value;
    Changed;
  end;
end;

procedure TscGPTabOptions.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

constructor TscGPPageControlTab.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FCustomOptions := TscGPTabOptions.Create;
  FCustomOptions.OnChange := OnOptionsChange;
  {$IFDEF VER340_UP}
  FCustomOptions.FControl := TscGPPageControlTabs(Collection).Pager;
  {$ENDIF}
  FCustomGlowEffect := TscButtonGlowEffect.Create;
  {$IFDEF VER340_UP}
  FCustomGlowEffect.FControl := TscGPPageControlTabs(Collection).Pager;
  {$ENDIF}
  FCustomGlowEffect.States := [scsFocused];
  FCustomGlowEffect.OnChange := OnOptionsChange;
  FShowCloseButton := True;
  FUseCustomOptions := False;
  FCustomFrameColor := clNone;
  FCustomFrameColorAlpha := 255;
  Active := False;
  CloseButtonMouseIn := False;
  CloseButtonMouseDown := False;
  CloseButtonRect := Rect(0, 0, 0, 0);
  FEnabled := True;
  FVisible := True;
  FPage := nil;
  FCaption := 'TscGPPageControlTab' + IntToStr(Index + 1);
  FImageIndex := -1;
  if (TscGPPageControlTabs(Collection).Pager <> nil) and
     (csDesigning in  TscGPPageControlTabs(Collection).Pager.ComponentState) and
      not (csLoading in TscGPPageControlTabs(Collection).Pager.ComponentState) and
      not (csUpdating in TscGPPageControlTabs(Collection).Pager.ComponentState) and
      not (csReading in TscGPPageControlTabs(Collection).Pager.ComponentState) and
      not (csWriting in TscGPPageControlTabs(Collection).Pager.ComponentState)
  then
  begin
    FPage := TscGPPageControlTabs(Collection).Pager.CreatePage;
    TscGPPageControlTabs(Collection).Pager.ActivePage := FPage;
  end;
end;

destructor TscGPPageControlTab.Destroy;
begin
  if TscGPPageControlTabs(Collection).FClearing and
     (TscGPPageControlTabs(Collection).Pager <> nil)
     and not (csLoading in  TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csDestroying in TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csUpdating in TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csReading in TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csWriting in TscGPPageControlTabs(Collection).Pager.ComponentState)
     and (FPage <> nil)
  then
  begin
    FPage.FDestroyFromPager := True;
    FreeAndNil(FPage);
  end
  else
  if (TscGPPageControlTabs(Collection).Pager <> nil)
     and (csDesigning in  TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csLoading in  TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csDestroying in TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csUpdating in TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csReading in TscGPPageControlTabs(Collection).Pager.ComponentState)
     and not (csWriting in TscGPPageControlTabs(Collection).Pager.ComponentState)
     and (FPage <> nil)
  then
    TscGPPageControlTabs(Collection).DestroyPage := FPage;
  FCustomOptions.Free;
  FCustomGlowEffect.Free;
  inherited;
end;

procedure TscGPPageControlTab.Assign(Source: TPersistent);

  function FindControl(AControl: TWinControl): TscGPPageControlPage;
  begin
    if (AControl <> nil) and (TscGPPageControlTabs(Collection).Pager <> nil) and
       (TscGPPageControlTabs(Collection).Pager.Owner <> nil)
    then
      Result := TscGPPageControlTabs(Collection).Pager.Owner.FindComponent(AControl.Name) as TscGPPageControlPage
    else
      Result := nil;
  end;

begin
  if Source is TscGPPageControlTab then
  begin
    FPage := FindControl(TscGPPageControlTab(Source).Page);
    FCaption := TscGPPageControlTab(Source).Caption;
    FImageIndex := TscGPPageControlTab(Source).ImageIndex;
    FVisible := TscGPPageControlTab(Source).Visible;
    FEnabled := TscGPPageControlTab(Source).Enabled;
    FShowCloseButton := TscGPPageControlTab(Source).ShowCloseButton;
    FUseCustomOptions := TscGPPageControlTab(Source).UseCustomOptions;
    FCustomOptions.Assign(TscGPPageControlTab(Source).CustomOptions);
    FCustomFrameColor := TscGPPageControlTab(Source).CustomFrameColor;
    FCustomFrameColorAlpha := TscGPPageControlTab(Source).CustomFrameColorAlpha;
  end
  else
    inherited Assign(Source);
end;

procedure TscGPPageControlTab.OnOptionsChange(Sender: TObject);
begin
  Changed(False);
end;

procedure TscGPPageControlTab.SetCustomFrameColor(Value: TColor);
begin
  if FCustomFrameColor <> Value then
  begin
    FCustomFrameColor := Value;
    Changed(False);
  end;
end;

procedure TscGPPageControlTab.SetCustomFrameColorAlpha(Value: Byte);
begin
  if FCustomFrameColorAlpha <> Value then
  begin
    FCustomFrameColorAlpha := Value;
    Changed(False);
  end;
end;

procedure TscGPPageControlTab.SetShowCloseButton(Value: Boolean);
begin
  if FShowCloseButton <> Value then
  begin
    FShowCloseButton := Value;
    Changed(False);
  end;
end;

procedure TscGPPageControlTab.SetUseCustomOptions(Value: Boolean);
begin
  if FUseCustomOptions <> Value then
  begin
    FUseCustomOptions := Value;
    Changed(False);
  end;
end;

procedure TscGPPageControlTab.SetCaption(Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TscGPPageControlTab.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value
  then
    begin
      FEnabled := Value;
      Changed(False);
    end;
end;

procedure TscGPPageControlTab.SetImageIndex(Value: Integer);
begin
  if FImageIndex <> Value
  then
    begin
      FImageIndex := Value;
      Changed(False);
    end;
end;

procedure TscGPPageControlTab.SetVisible(Value: Boolean);
var
  B: Boolean;
  i, j: Integer;
  FPager: TscGPPageControl;
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(False);
    FPager := TscGPPageControlTabs(Collection).Pager;
    if (FPager <> nil) and (Page = FPager.ActivePage) and not FVisible
       and not (csLoading in FPager.ComponentState)
    then
    begin
      j := Index;
      B := False;
      if j < FPager.Tabs.Count then
        for i := j to FPager.Tabs.Count - 1 do
        begin
          if (i >= 0) and (i < FPager.Tabs.Count) then
            if FPager.Tabs[i].Visible and FPager.Tabs[i].Enabled then
             begin
               FPager.FTabIndex := -1;
               FPager.TabIndex := i;
               B := True;
               Break;
             end;
         end;

      if not B and (j >= 0) then
        for i := j downto 0 do
        begin
          if (i >= 0) and (i < FPager.Tabs.Count) then
            if FPager.Tabs[i].Visible and FPager.Tabs[i].Enabled then
            begin
              FPager.FTabIndex := -1;
              FPager.TabIndex := i;
              Break;
            end;
        end;
       if FPage <> nil then FPage.Visible := False;
       FPager.AdjustScrollButtons;
     end;
  end;
end;

procedure TscGPPageControlTab.SetPage(const Value: TscGPPageControlPage);
begin
  if FPage <> Value then
  begin
    FPage := Value;
    if (FPage <> nil) and (FPage.Pager <> nil) then
      FPage.Pager.ActivePage := FPage;
  end;
end;

constructor TscGPPageControlTabs.Create;
begin
  inherited Create(TscGPPageControlTab);
  FClearing := False;
  Pager := APager;
  DestroyPage := nil;
end;

function TscGPPageControlTabs.GetOwner: TPersistent;
begin
  Result := Pager;
end;

procedure TscGPPageControlTabs.Clear;
begin
  FClearing := True;
  try
    inherited;
  finally
    if Pager <> nil then
      Pager.FTabIndex := -1;
    FClearing := False;
  end;
end;

function TscGPPageControlTabs.Add: TscGPPageControlTab;
begin
  Result := TscGPPageControlTab(inherited Add);
  if (Pager <> nil)
     and not (csDesigning in Pager.ComponentState)
     and not (csLoading in Pager.ComponentState)
  then
  begin
    Result.Page := Pager.CreatePage;
    Pager.ActivePage := Result.Page;
  end;

  if (Pager <> nil) and
     not (csLoading in Pager.ComponentState) then
  begin
    Pager.FScrollOffset := 0;
    Pager.GetScrollInfo;
    Pager.AdjustScrollButtons;
    Pager.ScrollToTab(Pager.TabIndex);
  end;
end;

function TscGPPageControlTabs.Insert(Index: Integer): TscGPPageControlTab;
begin
  Result := TscGPPageControlTab(inherited Insert(Index));
  if (Pager <> nil)
     and not (csDesigning in Pager.ComponentState)
     and not (csLoading in Pager.ComponentState)
  then
  begin
    Result.Page := Pager.CreatePage;
    Pager.FScrollOffset := 0;
    Pager.GetScrollInfo;
    Pager.AdjustScrollButtons;
  end;
end;

procedure TscGPPageControlTabs.Delete(Index: Integer);
begin
   if (Pager <> nil)
      and not (csDesigning in Pager.ComponentState)
      and not (csLoading in Pager.ComponentState)
      and (Items[Index].FPage <> nil)
  then
    FreeAndNil(Items[Index].FPage);
  inherited Delete(Index);
  if (Pager <> nil) and
     not (csLoading in Pager.ComponentState) then
  begin
    if Pager.TabIndex > Index then
      Dec(Pager.FTabIndex);
    Pager.FScrollOffset := 0;
    Pager.CalcTabRects;
    Pager.GetScrollInfo;
    Pager.ScrollToTab(Pager.TabIndex);
  end;
end;

procedure TscGPPageControlTabs.Update(Item: TCollectionItem);
var
  F: TCustomForm;
begin
  inherited;
  if Pager = nil then
    Exit;

  if (DestroyPage <> nil) and
     (csDesigning in Pager.ComponentState) and
     not (csLoading in  Pager.ComponentState) and
     not (csDestroying in Pager.ComponentState)
  then
  begin
    FreeAndNil(DestroyPage);
    F := GetParentForm(Pager);
    if F <> nil then
      F.Designer.Modified;
  end;

  Pager.UpdateTabs;
end;

function TscGPPageControlTabs.GetItem(Index: Integer):  TscGPPageControlTab;
begin
  Result := TscGPPageControlTab(inherited GetItem(Index));
end;

procedure TscGPPageControlTabs.SetItem(Index: Integer; Value:  TscGPPageControlTab);
begin
  inherited SetItem(Index, Value);
end;

constructor TscGPPageControlPage.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csNoDesignVisible];
  Color := clBtnFace;
  BackgroundStyle := scsbsFormBackground;
  FBGStyle := scgppsForm;
  FDestroyFromPager := False;
  BorderStyle := bsNone;
  AutoScroll := False;
  FullUpdate := False;
  ParentFont := False;
  ParentColor := False;
end;

destructor TscGPPageControlPage.Destroy;
var
  i, j: Integer;
  B: Boolean;
begin
  if (Pager <> nil) and not FDestroyFromPager
     and not (csLoading in Pager.ComponentState)
     and not (csDestroying in Pager.ComponentState)
     and not (csUpdating in Pager.ComponentState)
     and not (csReading in Pager.ComponentState)
     and not (csWriting in Pager.ComponentState)
  then
    begin
      j := Pager.GetPageIndex(Self);
      if j <> -1
      then
        begin
          Pager.Tabs[j].Page := nil;
          Pager.Tabs.Delete(j);
          if Pager.TabIndex = j
          then
            begin
              B := False;
              if j < Pager.Tabs.Count then
              for i := j to Pager.Tabs.Count - 1 do
              begin
                if (i >= 0) and (i < Pager.Tabs.Count) then
                if Pager.Tabs[i].Visible and Pager.Tabs[i].Enabled
                then
                  begin
                    Pager.FTabIndex := -1;
                    Pager.TabIndex := i;
                    B := True;
                    Break;
                  end;
              end;
              if not B and (j >= 0)
              then
                for i := j downto 0 do
                begin
                  if (i >= 0) and (i < Pager.Tabs.Count) then
                  if Pager.Tabs[i].Visible and Pager.Tabs[i].Enabled
                  then
                    begin
                      Pager.FTabIndex := -1;
                      Pager.TabIndex := i;
                      Break;
                    end;
                end;
            end;
          Pager.FScrollOffset := 0;
          Pager.CalcTabRects;
          Pager.AdjustScrollButtons;
          Pager.ScrollToTab(Pager.TabIndex);
          Pager.RePaintControl;
        end
      else
        begin
          if Pager.TabIndex > Pager.Tabs.Count - 1
          then
            Pager.TabIndex := Pager.Tabs.Count - 1
          else
            Pager.TabIndex := Pager.TabIndex;
          Pager.FScrollOffset := 0;
          Pager.CalcTabRects;
          Pager.AdjustScrollButtons;
          Pager.ScrollToTab(Pager.TabIndex);
          Pager.RePaintControl;
        end;
    end;
  inherited;
end;

procedure TscGPPageControlPage.SetBGStyle(Value: TscGPPageBGStyle);
begin
  if Value <> FBGStyle then
  begin
    FBGStyle := Value;
    case FBGStyle of
      scgppsForm:
        BackgroundStyle := scsbsFormBackground;
      scgppsColor:
        BackgroundStyle := scsbsPanel;
    end;
  end;
end;

procedure TscGPPageControlPage.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  R: TRect;
begin
  if (Parent <> nil) and (Pager <> nil)
  then
    begin
      R := Pager.GetPageBoundsRect;
      inherited SetBounds(R.Left, R.Top, R.Right, R.Bottom);
    end
  else
    inherited;
end;

constructor TscGPTabScrollButton.CreateEx(AOwner: TComponent; AColor, AArrowColor: TColor; AArrowThickness: Byte; ATransparent: Boolean);
begin
  inherited Create(AOwner);
  FMinMargins := True;
  FTransparentBackground := ATransparent;
  Options.FrameNormalColor := clNone;
  Options.FrameNormalColorAlpha := 0;
  Options.FrameNormalColor := clNone;
  Options.FrameNormalColorAlpha := 0;
  Options.FrameHotColor := clNone;
  Options.FrameHotColorAlpha := 0;
  Options.FramePressedColor := clNone;
  Options.FramePressedColorAlpha := 0;
  UpdateOptions(AColor, AArrowColor, AArrowThickness, ATransparent);
end;

procedure TscGPTabScrollButton.UpdateOptions(AColor, AArrowColor: TColor; AArrowThickness: Byte; ATransparent: Boolean);
begin
  TransparentBackground := ATransparent;
  Options.NormalColor := AColor;
  if ATransparent then
  begin
    Options.NormalColorAlpha := 20;
    Options.HotColorAlpha := 50;
    Options.PressedColorAlpha := 70;
  end
  else
  begin
    Options.NormalColorAlpha := 15;
    Options.HotColorAlpha := 40;
    Options.PressedColorAlpha := 60;
  end;
  Options.HotColor := AColor;
  Options.PressedColor := AColor;
  GlyphOptions.NormalColor := AArrowColor;
  GlyphOptions.HotColor := AArrowColor;
  GlyphOptions.PressedColor := AArrowColor;
  GlyphOptions.DisabledColor := AArrowColor;
  GlyphOptions.Thickness := AArrowThickness;
end;

procedure TscGPTabScrollButton.CMDesignHitTest;
begin
  Message.Result := 1;
end;

procedure TscGPTabScrollButton.WMLButtonUp(var Msg: TWMMouse);
begin
  inherited;
  if (csDesigning in ComponentState) then
  begin
    if Parent is TscGPPageControl then
    begin
      if FRight then
        TscGPPageControl(Parent).ScrollToRight
      else
        TscGPPageControl(Parent).ScrollToLeft;
    end
    else
    if Parent is TscGPTabControl then
    begin
      if FRight then
        TscGPTabControl(Parent).ScrollToRight
      else
        TscGPTabControl(Parent).ScrollToLeft;
    end
    else
    if Parent is TscGPToolPager then
    begin
      if FRight then
        TscGPToolPager(Parent).ScrollToRight
      else
        TscGPToolPager(Parent).ScrollToLeft;
    end
  end;
end;

constructor TscGPPageControl.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls];
  Color := clBtnFace;
  FDragSourceTab := nil;
  FEnableDragReorderTabs := False;
  FStopSetFocus := False;
  FSaveFocusOnActiveControl := False;
  FStopCloseTab := False;
  FTabsBGFillColor := clNone;
  FTabsBGFillColorAlpha := 255;
  FTabsScaling := False;

  FScrollButtonArrowColor := clBtnText;
  FScrollButtonArrowThickness := 2;
  FScrollButtonColor := clBtnText;
  FScrollButtonTransparent := False;

  ParentBackground := False;
  ParentColor := False;
  FTabs := TscGPPageControlTabs.Create(Self);
  FTabOptions := TscGPTabOptions.Create;
  {$IFDEF VER340_UP}
  FTabOptions.FControl := Self;
  {$ENDIF}
  FTabOptions.OnChange := OnControlChange;
  FTabCloseButtonOptions := TscGPTabCloseButtonOptions.Create;
  {$IFDEF VER340_UP}
  FTabCloseButtonOptions.FControl := Self;
  {$ENDIF}
  FTabCloseButtonOptions.OnChange := OnControlChange;
  FFrameWidth := 2;
  FFrameScaleWidth := False;
  FFrameColor := clBtnText;
  FFrameColorAlpha := 80;
  FTabIndex := -1;
  FScrollButtonWidth := 20;
  FCloseButtonSize := TAB_CLOSE_SIZE;
  FBorderStyle := scgpbsFrame;
  FShowInactiveTab := True;
  FTabGlowEffect := TscButtonGlowEffect.Create;
  {$IFDEF VER340_UP}
  FTabGlowEffect.FControl := Self;
  {$ENDIF}
  FTabGlowEffect.States := [scsFocused];
  FTabGlowEffect.OnChange := OnControlChange;
  FMouseWheelSupport := True;
  FShowCloseButtons := False;
  FShowCloseButtonOnActiveTabOnly := False;
  FTabMargin := 10;
  FTabSpacing := 10;
  FTabWidth := 0;
  FFreeOnClose := False;
  FTabHeight := DefPagerTabHeight;
  FTabImages := nil;
  FTransparentBackground := False;

  FMouseIn := False;
  FScrollOffset := 0;
  FLeftOffset := 6;
  FRightOffset := 5;
  Width := 300;
  Height := 150;
  FOldTabActive := -1;
  FTabActive := -1;
  FOldWidth := -1;
  FTabsTopOffset := 0;
  FTabsLeftOffset := 15;
  FTabsRightOffset := 15;
  FLeftScrollButton := nil;
  FRightScrollButton := nil;
  FShowFocusRect := True;
end;

destructor TscGPPageControl.Destroy;
begin
  FTabOptions.Free;
  FTabGlowEffect.Free;
  FTabCloseButtonOptions.Free;
  FTabs.Free;
  FTabs := nil;
  inherited;
end;

procedure TscGPPageControl.ChangeScale(M, D: Integer{$IFDEF VER310_UP}; isDpiChange: Boolean{$ENDIF});
begin
  if FFrameScaleWidth then
    FFrameWidth := MulDiv(FFrameWidth, M, D);

  if (FTabOptions.TabStyle <> gptsShape) or FFrameScaleWidth then
    FTabOptions.FrameWidth := MulDiv(FTabOptions.FrameWidth, M, D);

  if FTabWidth > 0 then
    FTabWidth := MulDiv(FTabWidth, M, D);
  FScrollButtonArrowThickness := MulDiv(FScrollButtonArrowThickness, M, D);
  FTabOptions.FShapeCornerRadius := MulDiv(FTabOptions.FShapeCornerRadius, M, D);
  FCloseButtonSize := MulDiv(FCloseButtonSize, M, D);
  FTabMargin := MulDiv(FTabMargin, M, D);
  FScrollButtonWidth := MulDiv(FScrollButtonWidth, M, D);
  FTabsTopOffset := MulDiv(FTabsTopOffset, M, D);
  FTabsLeftOffset := MulDiv(FTabsLeftOffset, M, D);
  FTabsRightOffset := MulDiv(FTabsRightOffset, M, D);
  FTabHeight := MulDiv(FTabHeight, M, D);
  if not (csLoading in ComponentState) then
    FTabsScaling := True;
  inherited;
  SetTimer(Handle, 1, 100, nil);
end;

procedure TscGPPageControl.SetTabsBGFillColor(Value: TColor);
begin
  if FTabsBGFillColor <> Value then
  begin
    FTabsBGFillColor := Value;
    RePaintControl;
    UpdateControls;
  end;
end;

procedure TscGPPageControl.SetTabsBGFillColorAlpha(Value: Byte);
begin
  if FTabsBGFillColorAlpha <> Value then
  begin
    FTabsBGFillColorAlpha := Value;
    RePaintControl;
    UpdateControls;
  end;
end;

procedure TscGPPageControl.UpdateScrollButtons;
begin
  if (FLeftScrollButton <> nil) and FLeftScrollButton.Visible then
  begin
    FLeftScrollButton.UpdateOptions(FScrollButtonColor, FScrollButtonArrowColor,
      FScrollButtonArrowThickness, FScrollButtonTransparent);
    FLeftScrollButton.Repaint;
  end;
  if (FRightScrollButton <> nil) and FRightScrollButton.Visible then
  begin
    FRightScrollButton.UpdateOptions(FScrollButtonColor, FScrollButtonArrowColor,
      FScrollButtonArrowThickness, FScrollButtonTransparent);
    FRightScrollButton.RePaint;
  end;
end;

procedure TscGPPageControl.SetScrollButtonArrowColor(Value: TColor);
begin
  if FScrollButtonArrowColor <> Value then
  begin
    FScrollButtonArrowColor := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPPageControl.SetScrollButtonArrowThickness(Value: Byte);
begin
  if (FScrollButtonArrowThickness <> Value) and (Value >= 1) then
  begin
    FScrollButtonArrowThickness := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPPageControl.SetScrollButtonColor(Value: TColor);
begin
  if FScrollButtonColor <> Value then
  begin
    FScrollButtonColor := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPPageControl.SetScrollButtonTransparent(Value: Boolean);
begin
  if FScrollButtonTransparent <> Value then
  begin
    FScrollButtonTransparent := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPPageControl.SetScrollButtonWidth(Value: Integer);
begin
  if (Value >= 20) and (FScrollButtonWidth <> Value) then
  begin
    FScrollButtonWidth := Value;
    GetScrollInfo;
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.DoClose;
var
  FPage: TscGPPageControlPage;
  CanClose: Boolean;
  P: TPoint;
  PIndex: Integer;
begin
  FPage := FActivePage;
  if FPage = nil then Exit;
  CanClose := True;
  if Assigned(FOnClose) then FOnClose(FPage, CanClose);
  if CanClose then
  begin
    PIndex := GetPageIndex(FPage);
    FScrollOffset := 0;
    FTabs[PIndex].Visible := False;
    if FFreeOnClose then
    begin
      FTabs[PIndex].Page.FDestroyFromPager := True;
      FTabs.Delete(PIndex);
      if FTabs.Count = 0 then
      begin
        FActivePage := nil;
        FTabIndex := -1;
        FTabActive := -1;
      end;
    end;
  end;
  if not CanClose then
  begin
    GetCursorPos(P);
    if (WinApi.Windows.WindowFromPoint(P) <> Self.Handle) and (FTabActive <> -1) then
    begin
      FTabs[FTabActive].CloseButtonMouseIn := False;
      FTabs[FTabActive].CloseButtonMouseDown := False;
      RePaintControl;
    end;
  end;
end;

procedure TscGPPageControl.DrawCloseButton(ACanvas: TCanvas;
  G: TGPGraphics;
  ARect: TRect; AIndex: Integer;  AColor: TColor);
var
  X, Y: Integer;
  ButtonR: TRect;
  GlyphColor, FillColor: Cardinal;
  R: TGPRectF;
  B: TGPSolidBrush;
begin
  X := ARect.Left + ARect.Width div 2 - FCloseButtonSize div 2;
  Y := ARect.Top + ARect.Height div 2 - FCloseButtonSize div 2 + FFrameWidth;
  ButtonR := Rect(X, Y, X + FCloseButtonSize, Y + FCloseButtonSize);
  R := RectToGPRect(ButtonR);
  Tabs[AIndex].CloseButtonRect := ButtonR;

  if not Tabs[AIndex].Enabled then
    FTabCloseButtonOptions.State := scsDisabled
  else
  if Tabs[AIndex].CloseButtonMouseDown then
    FTabCloseButtonOptions.State := scsPressed
  else
  if Tabs[AIndex].CloseButtonMouseIn then
    FTabCloseButtonOptions.State := scsHot
  else
    FTabCloseButtonOptions.State := scsNormal;

  if FTabCloseButtonOptions.ColorAlpha <> 0 then
  begin
    FillColor := ColorToGPColor(FTabCloseButtonOptions.Color, FTabCloseButtonOptions.ColorAlpha);
    B := TGPSolidBrush.Create(FillColor);
    case FTabCloseButtonOptions.ShapeKind of
      scgptcbRounded:
        G.FillEllipse(B, R);
      scgptcbRect:
        G.FillRectangle(B, R);
    end;
    B.Free;
  end;

  GlyphColor := ColorToGPColor(FTabCloseButtonOptions.GlyphColor, FTabCloseButtonOptions.GlyphColorAlpha);

  InflateGPRect(R, -FCloseButtonSize div 4, -FCloseButtonSize div 4);
  scGPUtils.GPDrawClearGlyph
    (G, R, GlyphColor, FScaleFactor, 2);
end;

procedure TscGPPageControl.SetShowCloseButtonOnActiveTabOnly(Value: Boolean);
begin
  if FShowCloseButtonOnActiveTabOnly <> Value then
  begin
    FShowCloseButtonOnActiveTabOnly := Value;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.SetShowCloseButtons(Value: Boolean);
begin
  if FShowCloseButtons <> Value then
  begin
    FShowCloseButtons := Value;
    GetScrollInfo;
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.SetFrameWidth(Value: Integer);
begin
  if Value <> FFrameWidth then
  begin
    FFrameWidth := Value;
    RePaintControl;
    if FActivePage <> nil then
      FActivePage.SetBounds(FActivePage.Left, FActivePage.Top,
        FActivePage.Width, FActivePage.Height);
  end;
end;

procedure TscGPPageControl.SetFrameColor(Value: TColor);
begin
  if Value <> FFrameColor then
  begin
    FFrameColor := Value;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.SetFrameColorAlpha(Value: Byte);
begin
  if Value <> FFrameColorAlpha then
  begin
    FFrameColorAlpha := Value;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.SetTabsTopOffset(Value: Integer);
begin
  if Value <> FTabsTopOffset then
  begin
    FTabsTopOffset := Value;
    RePaintControl;
    if FActivePage <> nil then
      FActivePage.SetBounds(FActivePage.Left, FActivePage.Top,
        FActivePage.Width, FActivePage.Height);
  end;
end;

procedure TscGPPageControl.SetBorderStyle(Value: TscGPTabControlBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RePaintControl;
    if FActivePage <> nil then
      FActivePage.SetBounds(FActivePage.Left, FActivePage.Top,
        FActivePage.Width, FActivePage.Height);
  end;
end;

procedure TscGPPageControl.UpdateControls;
var
  I: Integer;
begin
  if FFullUpdating then
    inherited
  else
  for I := 0 to ControlCount - 1 do
  begin
    if (Controls[i] is TWinControl) and not (Controls[i] is TscGPPageControlPage)
    then
      SendMessage(TWinControl(Controls[I]).Handle, WM_CHECKPARENTBG, 0, 0)
    else
    if Controls[i] is TGraphicControl
     then
       TGraphicControl(Controls[I]).Perform(WM_CHECKPARENTBG, 0, 0);
  end;
end;

procedure TscGPPageControl.SetTabsLeftOffset(Value: Integer);
begin
  if (Value <> FTabsLeftOffset) and (Value >= 0) then
  begin
    FTabsLeftOffset := Value;
    RePaintControl;
    AdjustScrollButtons;
    ScrollToTab(FTabIndex);
  end;
end;

procedure TscGPPageControl.SetShowInActiveTab(Value: Boolean);
begin
  if Value <> FShowInActiveTab then
  begin
    FShowInActiveTab := Value;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.SetTabsRightOffset(Value: Integer);
begin
  if (Value <> FTabsRightOffset) and (Value >= 0) then
  begin
    FTabsRightOffset := Value;
    RePaintControl;
    AdjustScrollButtons;
    ScrollToTab(FTabIndex);
  end;
end;

procedure TscGPPageControl.OnControlChange(Sender: TObject);
begin
  RePaintControl;
end;

procedure TscGPPageControl.SetShowFocusRect(Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.Draw(ACanvas: TCanvas; ACtrlState: TscsCtrlState);
var
  FFirst: Boolean;
  FFirstVisible: Boolean;
  I: Integer;
  SaveIndex: Integer;
  G: TGPGraphics;
  P: TGPPen;
  C: Cardinal;
  R, R1: TGPRectF;
  W: Integer;
  B: TGPSolidBrush;
  FScrollBWidth: Integer;
begin
  FTabsRect := Rect(0, 0, Width, FTabHeight + FTabsTopOffset);
  FPageRect := Rect(0, FTabHeight + FTabsTopOffset, Width, Height);

  // draw background
  if not FTransparentBackground then
    with ACanvas do
    begin
      if seClient in StyleElements then
        Brush.Color := GetStyleColor(Color{$IFDEF VER340_UP}, Self{$ENDIF})
      else
        Brush.Color := Color;
      FillRect(FPageRect);
      if seClient in StyleElements then
        Brush.Color := GetStyleColor(Color{$IFDEF VER340_UP}, Self{$ENDIF})
      else
        Brush.Color := Color;
      FillRect(FTabsRect);
    end;

  // draw border
  G := TGPGraphics.Create(ACanvas.Handle);
  G.SetSmoothingMode(SmoothingModeHighQuality);
  G.SetPixelOffsetMode(PixelOffsetModeHalf);

  if (FTabsBGFillColor <> clNone) and (FTabsBGFillColorAlpha > 0) then
  begin
    C := ColorToGPColor(GetStyleCOlor(FTabsBGFillColor{$IFDEF VER340_UP}, Self{$ENDIF}), FTabsBGFillColorAlpha);
    B := TGPSolidBrush.Create(C);
    R := RectToGPRect(FTabsRect);
    G.FillRectangle(B, R);
    B.Free;
  end;

  if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and (FTabs[FTabIndex].CustomFrameColor <> clNone) then
    C := ColorToGPColor(GetStyleColor(FTabs[FTabIndex].CustomFrameColor{$IFDEF VER340_UP}, Self{$ENDIF}), FTabs[FTabIndex].CustomFrameColorAlpha)
  else
    C := ColorToGPColor(GetStyleColor(FFrameColor{$IFDEF VER340_UP}, Self{$ENDIF}), FFrameColorAlpha);

  P := TGPPen.Create(C, FFrameWidth);
  if not FGetControlBG then
    CalcTabRects;

  if (FBorderStyle <> scgpbsNone) and not FGetControlBG and (FFrameWidth > 0) then
  begin
    if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and FTabs[FTabIndex].Visible then
    begin
      if FScrollVisible then
        W := FTabsLeftOffset + FScrollButtonWidth
      else
        W := FTabsLeftOffset;
      R1 := RectToGPRect(FTabs[FTabIndex].TabRect);
      if FBorderStyle <> scgpbsNone then
        R1.Height := R1.Height + FFrameWidth;
      if R1.X < W then
      begin
        R1.Width := R1.Width - (W - R1.X);
        R1.X := W;
      end;

      if FScrollVisible then
        W := FTabsRightOffset + FScrollButtonWidth
      else
        W := FTabsRightOffset;

      if R1.X + R1.Width > Width - W then
      begin
        R1.Width := R1.Width - (R1.X + R1.Width - (Width - W));
      end;
      if (R1.Width > 0) and (R1.X <= Width - W) then
        G.ExcludeClip(R1);
    end;
    R := RectToGPRect(FPageRect);
    InflateGPRect(R, -FFrameWidth / 2, -FFrameWidth / 2);
    if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
    begin
      R.X := 0;
      R.Width := Width;
    end;
    if FBorderStyle = scgpbsFrame then
      G.DrawRectangle(P, R)
    else
    if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
    begin
      G.DrawLine(P, R.X, R.Y, R.X + R.Width, R.Y);
      if FBorderStyle = scgpbsLineTopBottom then
        G.DrawLine(P, R.X, R.Y + R.Height, R.X + R.Width, R.Y + R.Height);
    end;
   if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and FTabs[FTabIndex].Visible and (R1.Width > 0) and (R1.X <= Width - FTabsRightOffset) then
      G.ResetClip;
  end
  else
  if not FGetControlBG and (FBorderStyle = scgpbsNone) then
  begin
    C := ColorToGPColor(clBlack, 0);
    P.SetColor(C);
    G.DrawLine(P, 0, 0, 1, 1);
  end;

  if Tabs.Count = 0 then
  begin
    P.Free;
    G.Free;
    Exit;
  end;

  // draw items

  FTabIndexBeforeFocused := FindDrawPriorTabFromIndex(FTabIndex);
  FTabIndexAfterFocused := FindDrawNextTabFromIndex(FTabIndex);

  SaveIndex := SaveDC(ACanvas.Handle);
  try
    if not FGetControlBG then
    begin
      if (FLeftScrollButton <> nil) and FLeftScrollButton.Visible then
        FScrollBWidth := FScrollButtonWidth
      else
        FScrollBWidth := 0;
      IntersectClipRect(ACanvas.Handle,
        FTabsLeftOffset + FScrollBWidth, FTabsTopOffset, Width - FTabsRightOffset - FScrollBWidth, FTabsTopOffset + FTabHeight + 2);

      FFirstVisible := False;
      for I := 0 to FTabs.Count - 1  do
      begin
        if FTabs[I].Visible then
        begin
          FFirst := (FTabsLeftOffset = 0) and (FTabs[I].TabRect.Left = 0);
          if not FFirstVisible and (I = FTabIndex) and not FTabs[I].Enabled then
          begin
            FFirst := True;
            FFirstVisible := True;
          end
          else
          if not FFirstVisible and (I <> FTabIndex) then
          begin
            FFirst := True;
            FFirstVisible := True;
          end
          else
          if not FShowInActiveTab then
            FFirst := (I <> FTabIndex);
          if (I = TabIndex) and FTabs[I].Enabled then
            FFirstVisible := True;
          DrawTab(ACanvas, G, I, FFirst);
        end;
      end;
    end;
  finally
    RestoreDC(ACanvas.Handle, SaveIndex);
  end;

  G.Free;
  P.Free;
end;

procedure TscGPPageControl.SetTabImages(Value: TCustomImageList);
begin
  if FTabImages <> Value then
  begin
    FTabImages := Value;
    UpdateTabs;
  end;
end;

procedure TscGPPageControl.SetTabHeight;
var
  I: Integer;
  R: TRect;
begin
  if FTabHeight <> Value then
  begin
    FTabHeight := Value;
    R := GetPageBoundsRect;
    for I := 0 to ControlCount - 1 do
      if Controls[I] is TscGPPageControlPage then
      Controls[I].SetBounds(R.Left, R.Top, R.Right, R.Bottom);
    RePaintControl;
    AdjustScrollButtons;
  end;
end;

procedure TscGPPageControl.SetTabMargin(Value: Integer);
begin
  if (Value > 0) and (FTabMargin <> Value) then
  begin
    FTabMargin := Value;
    UpdateTabs;
  end;
end;

procedure TscGPPageControl.SetTabWidth(Value: Integer);
begin
  if (Value >= 0) and (FTabWidth <> Value) then
  begin
    FTabWidth := Value;
    UpdateTabs;
  end;
end;

procedure TscGPPageControl.SetTabSpacing(Value: Integer);
begin
  if (Value > 0) and (FTabSpacing <> Value) then
  begin
    FTabSpacing := Value;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.SetTabIndex;
var
  LPage: TscGPPageControlPage;
  LPrevTabIndex: Integer;
  B: Boolean;
  LForm: TCustomForm;
begin

  if Value = -1 then
  begin
    FTabIndex := Value;
    if not (csLoading in ComponentState) then
      RePaintControl;
    Exit;
  end;

  if (Value < 0) or (Value > Tabs.Count - 1) then
    Exit;

  if Assigned(FOnCanChangePage) and not (csLoading in ComponentState) then
  begin
    B := True;
    FOnCanChangePage(Value, B);
    if not B then Exit;
  end;

  if (FTabIndex <> Value) and (Value >= 0) and (Value < Tabs.Count) and
     not (csDesigning in ComponentState) and
     not (csLoading in ComponentState) then
  begin
    LForm := GetParentForm(Self);
    if (LForm <> nil) and (FActivePage <> nil) and (LForm.ActiveControl <> nil)
       and FActivePage.ContainsControl(LForm.ActiveControl) then
    begin
      LForm.ActiveControl := nil;
      if LForm.ActiveControl <> nil then
      begin
        FStopSetFocus := True;
        Exit;
      end;
    end;
  end;

  if not Tabs[Value].FVisible then Tabs[Value].FVisible := True;

  if (FTabIndex <> Value) and (Value >= 0) and (Value < Tabs.Count)
  then
    begin
      LPrevTabIndex := FTabIndex;
      FTabIndex := Value;
      if not (csLoading in ComponentState) then
        if Assigned(FOnChangingPage) then FOnChangingPage(Self);
      if (FTabIndex > -1) and (FTabs[FTabIndex].Page <> nil)
      then
        begin
          LPage := FTabs[FTabIndex].Page;
          LPage.Parent := Self;
          LPage.SetBounds(LPage.Left, LPage.Top, LPage.Width, LPage.Height);
          LPage.Visible := True;
          LPage.BringToFront;
          FActivePage := LPage;
          if FScrollVisible then
            ScrollToTab(FTabIndex);
        end;
      if (LPrevTabIndex > -1) and (FTabs.Count > LPrevTabIndex) and
         (FTabs[LPrevTabIndex].Page <> nil) and
         (FTabs[LPrevTabIndex].Page <> nil)
      then
        FTabs[LPrevTabIndex].Page.Visible := False;
      if not (csLoading in ComponentState) then
        if Assigned(FOnChangePage) then FOnChangePage(Self);
    end
  else
    begin
      if Tabs[Value].FPage <> nil
      then
      begin
        if not Tabs[Value].FPage.Visible then
          Tabs[Value].FPage.Visible := True;
        FActivePage := Tabs[Value].FPage;
      end;
    end;
  RePaintControl;
end;

function TscGPPageControl.TabFromPoint;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Tabs.Count -1 do
    if Tabs[I].Visible and PtInRect(Tabs[I].TabRect, P) then
    begin
      Result := I;
      Break;
    end;
end;


procedure TscGPPageControl.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateTabs;
end;

procedure TscGPPageControl.CMDesignHitTest;
var
  P: TPoint;
  I: Integer;
  F: TCustomForm;
begin
  inherited;
  P := SmallPointToPoint(Message.Pos);
  if (Message.Keys = MK_LBUTTON) and (TabFromPoint(P) <> -1)
  then
    begin
      I := TabFromPoint(P);
      if Tabs[I].Page <> nil then ActivePage := Tabs[I].Page;
      F := GetParentForm(Self);
      if F <> nil then
        F.Designer.Modified;
    end;
end;

procedure TscGPPageControl.SetTransparentBackground(Value: Boolean);
begin
  if FTransparentBackground <> Value then
  begin
    FTransparentBackground := Value;
    GetParentBG;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
    with Params.WindowClass do
      Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TscGPPageControl.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FActivePage) then
    FActivePage := nil;
  if (Operation = opRemove) and (AComponent = FTabImages) then
    FTabImages := nil;
end;

function TscGPPageControl.FindNextTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPPageControl.FindPriorTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPPageControl.FindDrawNextTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPPageControl.FindDrawPriorTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;


  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

procedure TscGPPageControl.FindNextTab;
var
  i, j, k: Integer;
begin
  j := TabIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPPageControl.FindPriorTab;
var
  i, j, k: Integer;
begin
  j := TabIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPPageControl.FindFirstTab;
var
  i, k: Integer;
begin
  k := -1;
  for i := 0 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPPageControl.FindLastTab;
var
  i, k: Integer;
begin
  k := -1;
  for i := Tabs.Count - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPPageControl.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if Message.TimerID = 1 then
  begin
    FTabsScaling := False;
    UpdateTabs;
    KillTimer(Handle, 1);
  end;
end;

procedure TscGPPageControl.WMMOUSEWHEEL(var Message: TWMMOUSEWHEEL);
begin
  if FMouseWheelSupport then
     if BidiMode <> bdRightToLeft then
     begin
       if Message.WheelDelta < 0 then FindNextTab else FindPriorTab;
     end
     else
     begin
       if Message.WheelDelta > 0 then FindNextTab else FindPriorTab;
     end;
end;

procedure TscGPPageControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    if (FTabIndex >= 0) and (FTabIndex < Tabs.Count) then
    begin
      if Assigned(FTabs[FTabIndex].OnClick) then
        FTabs[FTabIndex].OnClick(Self);
    end;
  end
  else
  if BidiMode <> bdRightToLeft then
  begin
    if (Key = VK_NEXT)
    then
      FindLastTab
    else
    if (Key = VK_PRIOR)
    then
      FindFirstTab
    else
    if (Key = VK_LEFT) or (Key = VK_UP)
    then
      FindPriorTab
    else
    if (Key = VK_RIGHT) or (Key = VK_DOWN)
    then
      FindNextTab;
  end
  else
  begin
    if (Key = VK_NEXT)
    then
      FindFirstTab
    else
    if (Key = VK_PRIOR)
    then
      FindLastTab
    else
    if (Key = VK_LEFT) or (Key = VK_UP)
    then
      FindNextTab
    else
    if (Key = VK_RIGHT) or (Key = VK_DOWN)
    then
      FindPriorTab;
  end;
end;

procedure TscGPPageControl.WMGetDlgCode;
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TscGPPageControl.WMSETFOCUS;
begin
  inherited;
  if not (csLoading in ComponentState) then
    if not FTransparentBackground then
      RePaintControl
    else
    begin
      FUpdateParentBuffer := True;
      if DrawTextMode = scdtmGDIPlus then
       Invalidate
     else
       RePaint;
    end;
end;

procedure TscGPPageControl.WMKILLFOCUS;
begin
  inherited;
  if not (csLoading in ComponentState) then
    RePaintControl;
end;

procedure TscGPPageControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  TestActive(X, Y);
end;

procedure TscGPPageControl.DragDrop(Source: TObject; X, Y: Integer);
var
  Index: Integer;
begin
  inherited;
  if (Source = Self) and (FDragSourceTab <> nil) then
  begin
    Index := TabFromPoint(Point(X, Y));
    if (Index <> -1) and (Index <> FDragSourceTab.Index) then
    begin
      FDragSourceTab.Index := Index;
      TabIndex := Index;
      Abort;
    end;
  end;
  FDragSourceTab := nil;
end;

procedure TscGPPageControl.DragOver(Source: TObject; X, Y: Integer; State: TDragState;
    var Accept: Boolean);
begin
  inherited;
  Accept := (Source <> nil) and (Source = Self) and  (FDragSourceTab <> nil);
end;

procedure TscGPPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer);
var
  WasFocused: Boolean;
  OldTabIndex: Integer;
begin
  inherited;

  if Button <> mbLeft then Exit;
  TestActive(X, Y);

  WasFocused := Focused;

  OldTabIndex := TabIndex;
  FStopCloseTab := False;
  FStopSetFocus := False;

  if (FTabActive <> TabIndex) and (FTabActive <> -1) then
  begin
    TabIndex := FTabActive;
    FStopCloseTab := FShowCloseButtonOnActiveTabOnly;
  end;

  if not FStopSetFocus then
    FStopSetFocus := FSaveFocusOnActiveControl;

  if not WasFocused and not FStopSetFocus then
    SetFocus;

  FStopSetFocus := False;
  FSaveFocusOnActiveControl := False;

  if (FTabs.Count > 0) and (FTabActive <> -1) and (FTabActive < FTabs.Count) and FShowCloseButtons and
     (FTabs[FTabActive].ShowCloseButton and
     (not FShowCloseButtonOnActiveTabOnly or (FShowCloseButtonOnActiveTabOnly and (OldTabIndex = FTabActive))))
     and not (csDesigning in ComponentState)
  then
    with FTabs[FTabActive] do
    begin
      if PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := True;
        CloseButtonMouseDown := True;
        RePaintControl;
      end
      else
      if not PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := False;
        CloseButtonMouseDown := False;
      end;
   end;

  if (FTabs.Count > 0) and FEnableDragReorderTabs and (Button = mbLeft) and (FTabActive <> -1) then
  begin
    FDragSourceTab := Tabs[FTabActive];
    if not FDragSourceTab.CloseButtonMouseIn and DragDetect(Handle, Mouse.CursorPos) then
      BeginDrag(False, 3)
    else
      FDragSourceTab := nil;
  end
  else
    FDragSourceTab := nil;
end;

procedure TscGPPageControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer);
begin
  inherited;
  if Button <> mbLeft then Exit;

  if PtInRect(FTabsRect, Point(X, Y)) and Assigned(FOnTabsAreaClick) then
    FOnTabsAreaClick(Self);

  TestActive(X, Y);
  if (FTabIndex >= 0) and (FTabIndex < Tabs.Count) and (FTabIndex = FTabActive) then
  begin
    if Assigned(FTabs[FTabIndex].OnClick) then
        FTabs[FTabIndex].OnClick(Self);
  end;

  if (FTabs.Count > 0) and (FTabActive <> -1) and FShowCloseButtons and
    (FTabs[FTabActive].ShowCloseButton and
    (not FShowCloseButtonOnActiveTabOnly or (ShowCloseButtonOnActiveTabOnly and (TabIndex = FTabActive))))
    and not (csDesigning in ComponentState)
  then
    with FTabs[FTabActive] do
    begin
      if PtInRect(CloseButtonRect, Point(X, Y)) and not FStopCloseTab then
      begin
        CloseButtonMouseIn := True;
        CloseButtonMouseDown := False;
        RePaintControl;
        DoClose;
      end
      else
      if not PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := False;
        CloseButtonMouseDown := False;
      end;
   end;
  FStopCloseTab := False;
end;

procedure TscGPPageControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  TestActive(-1, -1);
end;

procedure TscGPPageControl.TestActive(X, Y: Integer);
var
  i: Integer;
begin
  if Tabs.Count = 0 then Exit;

  FOldTabActive:= FTabActive;
  FTabActive := -1;

  for i := 0 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled and PtInRect(Tabs[i].TabRect, Point(X, Y)) and
       (X >= FTabsLeftOffset) and (X < Width - FTabsRightOffset)
    then
      begin
        FTabActive := i;
        Break;
      end;
  end;

  if (FTabActive <> FOldTabActive)
  then
    begin
      if (FOldTabActive <> - 1) and (FOldTabActive < Tabs.Count)
      then
      begin
        Tabs[FOldTabActive].Active := False;
        Tabs[FOldTabActive].CloseButtonMouseIn := False;
        Tabs[FOldTabActive].CloseButtonMouseDown := False;
      end;
      if (FTabActive <> - 1)
      then
        Tabs[FTabActive].Active := True;
      RePaintControl;
    end;

  if (FTabActive <> -1) and FShowCloseButtons and
     (FTabs[FTabActive].ShowCloseButton and
     (not FShowCloseButtonOnActiveTabOnly or (ShowCloseButtonOnActiveTabOnly and (TabIndex = FTabActive)))) then
  with Tabs[FTabActive] do
  begin
    if PtInRect(CloseButtonRect, Point(X, Y)) and not CloseButtonMouseIn then
    begin
      CloseButtonMouseIn := True;
      RePaintControl;
    end
    else
    if not PtInRect(CloseButtonRect, Point(X, Y)) and CloseButtonMouseIn then
    begin
      CloseButtonMouseIn := False;
      CloseButtonMouseDown := False;
      RePaintControl;
    end;
  end;

end;

procedure TscGPPageControl.ScrollToTab(AIndex: Integer);
var
  R: TRect;
  Offset, SW: Integer;
begin
  if (AIndex < 0) or (AIndex > Tabs.Count - 1) then Exit;

  R := Tabs[AIndex].TabRect;
  if FScrollVisible then
    SW := FScrollButtonWidth
  else
    SW := 0;
  if R.Left < FTabsLeftOffset + SW then
  begin
    Offset := Abs(FTabsLeftOffset - R.Left);
    Inc(Offset, SW);

    if BidiMode <> bdRightToLeft then
      FScrollOffset := FScrollOffset - Offset
    else
      FScrollOffset := FScrollOffset + Offset;

    if FScrollOffset < 0 then FScrollOffset := 0;
    RePaintControl;
  end
  else
  if R.Right > Width - FTabsRightOffset - SW then
  begin
    Offset := R.Right - (Width - FTabsRightOffset);
    Inc(Offset, SW);

    if BidiMode <> bdRightToLeft then
      FScrollOffset := FScrollOffset + Offset
    else
      FScrollOffset := FScrollOffset - Offset;

    if FScrollOffset < 0 then FScrollOffset := 0;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.ScrollToLeft;
begin
  CalcTabRects;
  if FLeftTabIndex >= 0 then
    ScrollToTab(FLeftTabIndex);
end;

procedure TscGPPageControl.ScrollToRight;
begin
  CalcTabRects;
  if FRightTabIndex >= 0 then
    ScrollToTab(FRightTabIndex);
end;

procedure TscGPPageControl.OnLeftScrollButtonClick(Sender: TObject);
begin
  ScrollToLeft;
end;

procedure TscGPPageControl.OnRightScrollButtonClick(Sender: TObject);
begin
  ScrollToRight;
end;

procedure TscGPPageControl.ShowScrollButtons;
var
  B: Boolean;
begin
  B := False;
  if FLeftScrollButton = nil then
  begin
    FLeftScrollButton := TscGPTabScrollButton.CreateEx(Self,
      FScrollButtonColor, FScrollButtonArrowColor, FScrollButtonArrowThickness, FScrollButtonTransparent);
    FLeftScrollButton.OnClick := OnLeftScrollButtonClick;
    FLeftScrollButton.Visible := False;
    FLeftScrollButton.RepeatClick := True;
    FLeftScrollButton.CanFocused := False;
    FLeftScrollButton.GlyphOptions.Kind := scgpbgkLeftArrow;

    FLeftScrollButton.Parent := Self;
    FLeftScrollButton.SetBounds(FTabsLeftOffset, FTabsTopOffset,
      FScrollButtonWidth, FTabHeight);

    FLeftScrollButton.Visible := True;
    B := True;
  end
  else
    FLeftScrollButton.SetBounds(FTabsLeftOffset, FTabsTopOffset,
      FScrollButtonWidth, FTabHeight);
  if FRightScrollButton = nil then
  begin
    FRightScrollButton := TscGPTabScrollButton.CreateEx(Self,
      FScrollButtonColor, FScrollButtonArrowColor, FScrollButtonArrowThickness, FScrollButtonTransparent);
    FRightScrollButton.Visible := False;
    FRightScrollButton.FRight := True;
    FRightScrollButton.OnClick := OnRightScrollButtonClick;
    FRightScrollButton.RepeatClick := True;
    FRightScrollButton.CanFocused := False;
    FRightScrollButton.GlyphOptions.Kind := scgpbgkRightArrow;
    FRightScrollButton.Parent := Self;
    FRightScrollButton.SetBounds(Width - FTabsRightOffset - FScrollButtonWidth,
      FTabsTopOffset, FScrollButtonWidth, FTabHeight);
    FRightScrollButton.Visible := True;
    B := True;
  end
  else
    FRightScrollButton.SetBounds(Width - FTabsRightOffset - FScrollButtonWidth,
      FTabsTopOffset, FScrollButtonWidth, FTabHeight);

  if B and not(csLoading in ComponentState) then
    RePaintControl;
end;

procedure TscGPPageControl.HideScrollButtons;
begin
  if FLeftScrollButton <> nil then
  begin
    FLeftScrollButton.Visible := False;
    FLeftScrollButton.Free;
    FLeftScrollButton := nil;
  end;
  if FRightScrollButton <> nil then
  begin
    FRightScrollButton.Visible := False;
    FRightScrollButton.Free;
    FRightScrollButton := nil;
  end;
end;

procedure TscGPPageControl.AdjustScrollButtons;
begin
  if FTabsScaling then
    Exit;

  if FScrollVisible then
    ShowScrollButtons
  else
    HideScrollButtons;
end;

procedure TscGPPageControl.GetScrollInfo;
var
  I, X: Integer;
begin
  X := FTabsLeftOffset;
  for I := 0 to Tabs.Count - 1 do
    if Tabs[I].Visible then
    begin
      X := X + GetTabWidth(I);
    end;
  FScrollVisible := X > Width - FTabsRightOffset;
end;

function TscGPPageControl.GetTabWidth(AIndex: Integer): Integer;
var
  R: TRect;
  IIndex: Integer;
  IImages: TCustomImageList;
begin
  if FTabWidth > 0 then
  begin
    Result := FTabWidth;
    Exit;
  end;
  Result := FTabMargin * 2;
  if Result < 10 then Result := 10;
  R := Rect(0, 0, 0, 0);
  if Assigned(FOnGetTabDrawParams) then
  begin
    Canvas.Font := Self.Font;
    FOnGetTabDrawParams(AIndex, scsNormal, Canvas);
  end;

  if DrawTextMode = scdtmGDIPlus then
    GPDrawText (nil, nil, Canvas, R,
      Tabs[AIndex].Caption,  DT_LEFT or DT_CALCRECT)
  else
    DrawText(Canvas.Handle, PChar(Tabs[AIndex].Caption),
     Length(Tabs[AIndex].Caption), R,
      DT_LEFT or DT_CALCRECT);

  Result := Result + R.Width;

  IIndex := Tabs[AIndex].ImageIndex;
  IImages := FTabImages;

 if Assigned(FOnGetTabImage) then
   FOnGetTabImage(AIndex, IImages, IIndex);

  if (IImages <> nil) and (IIndex >= 0) and (IIndex < IImages.Count) then
    Result := Result + FTabSpacing + IImages.Width;

  if FShowCloseButtons and Tabs[AIndex].ShowCloseButton then
    Inc(Result, FCloseButtonSize + 6);
end;

procedure TscGPPageControl.UpdateTabs;
begin
  if not (csLoading in ComponentState) and
     not (csDestroying in ComponentState) then
  begin
    FScrollOffset := 0;
    CalcTabRects;
    GetScrollInfo;
    ScrollToTab(FTabIndex);
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPPageControl.CalcTabRects;
var
  I, X, Y, W, ScrollW: Integer;
begin
  GetScrollInfo;

  if BidiMode <> bdRightToLeft then
  begin
    X := FTabsLeftOffset - FScrollOffset;
    if FScrollVisible then
      Inc(X, FScrollButtonWidth);
  end
  else
  begin
    X := Width - FTabsRightOffset + FScrollOffset;
    if FScrollVisible then
      Dec(X, FScrollButtonWidth);
  end;

  Y := FTabsTopOffset;
  Canvas.Font := Self.Font;
  FLeftTabIndex := -1;
  FRightTabIndex := -1;

  if FScrollVisible then
    ScrollW := FScrollButtonWidth
  else
    ScrollW := 0;

  for I := 0 to Tabs.Count - 1 do
    if Tabs[I].Visible then
    begin
      W := GetTabWidth(I);
      if BidiMode <> bdRightToLeft then
      begin
        Tabs[I].TabRect := Rect(X, Y, X + W, Y + FTabHeight);
        X := X + W;
        if Tabs[I].TabRect.Left < FTabsLeftOffset + ScrollW
        then
          FLeftTabIndex := I;
        if (Tabs[I].TabRect.Right > Width - FTabsRightOffset - ScrollW) and
           (FRightTabIndex = -1)
        then
          FRightTabIndex := I;
       end
      else
      begin
        Tabs[I].TabRect := Rect(X - W, Y, X, Y + FTabHeight);
        X := X - W;
        if (Tabs[I].TabRect.Left < FTabsLeftOffset + ScrollW) and
           (FLeftTabIndex = -1)
        then
          FLeftTabIndex := I;
        if Tabs[I].TabRect.Right > Width - FTabsRightOffset - ScrollW
        then
          FRightTabIndex := I;
      end;
    end;
end;

procedure TscGPPageControl.SetTabs(AValue: TscGPPageControlTabs);
begin
  FTabs.Assign(AValue);
  RePaintControl;
end;

procedure TscGPPageControl.SetActivePage(const Value: TscGPPageControlPage);
var
  i: Integer;
begin
  if Value <> nil
  then
    begin
      i := GetPageIndex(Value);
      if (i <> -1) and not (Tabs[i].FVisible) then Tabs[i].FVisible := True;
      TabIndex := i;
    end
  else
  begin
    if FActivePage <> nil then
    begin
      FActivePage.Visible := False;
      TabIndex := -1;
    end;
  end;
end;

function TscGPPageControl.GetPageIndex(Value: TscGPPageControlPage): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Tabs.Count - 1 do
    if Tabs[i].Page = Value
    then
       begin
         Result := i;
         Break;
       end;
end;

procedure TscGPPageControl.Loaded;
var
  i: Integer;
begin
  inherited;
  if Tabs.Count > 0 then
    for i := 0 to Tabs.Count - 1 do
    if Tabs[i].Page <> nil then
    begin
      Tabs[i].Page.Pager := Self;
      Tabs[i].Page.Visible := Tabs[i].Page = FActivePage;
    end;

  CalcTabRects;
  GetScrollInfo;
  ScrollToTab(FTabIndex);
  AdjustScrollButtons;

  if FActivePage <> nil then
    FActivePage.SetBounds(FActivePage.Left, FActivePage.Top,
      FActivePage.Width, FActivePage.Height);


end;

function TscGPPageControl.GetPageBoundsRect: TRect;
begin
  Result.Left := 0;
  Result.Top := FTabHeight + FTabsTopOffset;
  Result.Bottom := Height - FTabHeight - FTabsTopOffset;
  Result.Right := Width;
  if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
  begin
    Inc(Result.Top, FFrameWidth);
    Dec(Result.Bottom, FFrameWidth);
    if FBorderStyle = scgpbsLineTopBottom then
      Dec(Result.Bottom, FFrameWidth);
  end
  else
  if FBorderStyle = scgpbsFrame then
  begin
    Inc(Result.Top, FFrameWidth);
    Inc(Result.Left, FFrameWidth);
    Dec(Result.Bottom, FFrameWidth * 2);
    Dec(Result.Right, FFrameWidth * 2);
  end
end;

procedure TscGPPageControl.WMSIZE(var Message: TWMSIZE);
var
  B: Boolean;
begin
  B := FScrollVisible;

  inherited;

  if (FOldWidth <> Width) and (FOldWidth <> -1)
  then
    begin
      GetScrollInfo;
      AdjustScrollButtons;
      if FScrollOffset > 0
      then
        FScrollOffset := FScrollOffset - (Width - FOldWidth);
      if FScrollOffset < 0 then FScrollOffset := 0;
    end;

  if (ActivePage <> nil) and (Tabs.Count > 0)
  then
    with ActivePage do
    begin
      SetBounds(Left, Top, Width, Height);
    end;

  FOldWidth := Width;

  if B <> FScrollVisible then
  begin
    FScrollOffset := 0;
    ScrollToTab(FTabIndex);
  end;

  RePaintControl;
end;

procedure TscGPPageControl.DrawTab(ACanvas: TCanvas; G: TGPGraphics; Index: Integer; AFirst: Boolean);
const
  GlyphLayout: array[Boolean] of TButtonLayout = (blGlyphLeft, blGlyphRight);
var
  FC: TColor;
  TabState: TscsCtrlState;
  R, CR: TRect;
  IIndex: Integer;
  IImages: TCustomImageList;
  FGlowColor: TColor;
  FillR, FrameR, GPR, TabR: TGPRectF;
  TabFillC, TabFrameC, C1, C2: Cardinal;
  FramePath, FillPath: TGPGraphicsPath;
  P: TGPPen;
  l, t, w, d: Single;
  B, LB: TGPBrush;
  SW: Integer;
  FOptions: TscGPTabOptions;
  FGlowEffect: TscButtonGlowEffect;
  Flags: Integer;
begin

  R := FTabs[Index].TabRect;

  if Index = FTabIndex then
    Inc(R.Bottom, FFrameWidth);

  TabR := RectToGPRect(R);

  if FLeftScrollButton <> nil then
     SW := FTabsLeftOffset + FScrollButtonWidth
   else
     SW := FTabsLeftOffset;
  if TabR.X < SW then
  begin
    TabR.Width := TabR.Width - (SW - TabR.X);
    TabR.X := SW;
  end;
  if FRightScrollButton <> nil then
    SW := FTabsRightOffset + FScrollButtonWidth
  else
    SW := FTabsRightOffset;
  if TabR.X + TabR.Width > Width - SW then
  begin
    TabR.Width := TabR.Width - (TabR.X + TabR.Width - (Width - SW));
  end;

  if TabR.Width <= 0 then Exit;

  if Tabs[Index].UseCustomOptions then
    FOptions := Tabs[Index].CustomOptions
  else
    FOptions := FTabOptions;


  R.Bottom := R.Bottom + FFrameWidth * 2;

  if (Tabs[Index].Page = ActivePage) and (ActivePage <> nil) and
      Tabs[Index].Enabled and Tabs[Index].Visible
  then
  begin
    if Focused then
      TabState := scsFocused
    else
      TabState := scsPressed;
  end
  else
  if FTabs[Index].Active then
    TabState := scsHot
  else
  if FTabs[Index].Enabled then
    TabState := scsNormal
  else
    TabState := scsDisabled;

  FOptions.State := TabState;
  FC := FOptions.FontColor;

  if TabState = scsDisabled then
  begin
    if IsLightColor(FC) then
      FC := DarkerColor(FC, 40)
    else
      FC := LighterColor(FC, 40);
  end;


  // draw tab shape
  if not (((TabState = scsNormal) or (TabState = scsDisabled)) and not FShowInActiveTab) then
  begin
    FillR := RectToGPRect(R);
    FrameR := RectToGPRect(R);

    if TabState = scsDisabled then
    begin
      TabFillC := ColorToGPColor(FOptions.Color, FOptions.ColorAlpha div 2);
      TabFrameC := ColorToGPColor(FOptions.FrameColor, FOptions.FrameColorAlpha div 2);
    end
    else
    begin
      TabFillC := ColorToGPColor(FOptions.Color, FOptions.ColorAlpha);
      TabFrameC := ColorToGPColor(FOptions.FrameColor, FOptions.FrameColorAlpha);
    end;
    if FOptions.ShapeFillStyle = scgpsfColor then
       B := TGPSolidBrush.Create(TabFillC)
    else
    begin
      C1 := ColorToGPColor(LighterColor(FOptions.Color, FOptions.GradientColorOffset), FOptions.ColorAlpha);
      C2 := TabFillC;
      GPR := FillR;
      InflateGPRect(GPR, FOptions.FrameWidth, FOptions.FrameWidth);
      B := TGPLinearGradientBrush.Create(GPR, C1, C2, FOptions.FShapeFillGradientAngle);
    end;

    P := TGPPen.Create(TabFrameC, FTabOptions.FrameWidth);
    FramePath := TGPGraphicsPath.Create;
    FillPath := TGPGraphicsPath.Create;
    if (FTabOptions.FrameWidth > 0) and (FTabOptions.FTabStyle = gptsShape) then
    begin
      InflateGPRect(FillR, -FTabOptions.FrameWidth + 0.2, -FTabOptions.FrameWidth + 0.2);
      InflateGPRect(FrameR, -FTabOptions.FrameWidth / 2, -FTabOptions.FrameWidth / 2);
    end;

    LB := nil;
    if FTabOptions.FTabStyle = gptsRoundedLine then
    begin
      LB := TGPSolidBrush.Create(TabFrameC);
      GPFillRoundedRectPath(FillPath, FillR, FTabOptions.ShapeCornerRadius);
      if FTabOptions.LineWidth <= 0 then
        scGPUtils.GPDrawHVRoundedLinePath(FramePath, FTabOptions.FrameWidth,
          FrameR.X + FTabOptions.ShapeCornerRadius,
          FrameR.Y + FrameR.Height - FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width - FTabOptions.ShapeCornerRadius,
          FrameR.Y + FrameR.Height - FTabOptions.FFrameWidth)
      else
        scGPUtils.GPDrawHVRoundedLinePath(FramePath, FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width / 2 - FTabOptions.LineWidth div 2,
          FrameR.Y + FrameR.Height - FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width / 2 + FTabOptions.LineWidth div 2,
          FrameR.Y + FrameR.Height - FTabOptions.FFrameWidth)
    end
    else
    if (FTabOptions.FShapeCornerRadius = 0) or (FTabOptions.FTabStyle in [gptsBottomLine, gptsLine]) then
    begin
      FillPath.AddRectangle(FillR);
      if FTabOptions.FTabStyle in [gptsBottomLine, gptsLine] then
      begin
        InflateGPRect(FrameR, -FTabOptions.FrameWidth / 2, -FTabOptions.FrameWidth / 2);
        FrameR.X := FillR.X;
        FrameR.Width := FillR.Width;
        if FTabOptions.LineWidth <= 0 then
          FramePath.AddLine(MakePoint(FrameR.X, FrameR.Y + FrameR.Height),
            MakePoint(FrameR.X + FrameR.Width, FrameR.Y + FrameR.Height))
        else
          FramePath.AddLine(MakePoint(FrameR.X + FrameR.Width / 2 - FTabOptions.LineWidth div 2,
            FrameR.Y + FrameR.Height),
            MakePoint(FrameR.X + FrameR.Width / 2 + FTabOptions.LineWidth div 2,
            FrameR.Y + FrameR.Height));
      end
      else
        FramePath.AddRectangle(FrameR);
    end
    else
    begin
      l := FillR.X;
      t := FillR.y;
      w := FillR.Width;
      d := FTabOptions.ShapeCornerRadius * 2 - FOptions.FrameWidth;
      if d < 1 then d := 1;
      FillPath.StartFigure;
      FillPath.AddArc(l, t, d, d, 180, 90);
      FillPath.AddArc(l + w - d, t, d, d, 270, 90);
      FillPath.AddLine(MakePoint(FillR.X + FillR.Width, FillR.Y + FillR.Height),
      MakePoint(FillR.X, FillR.Y + FillR.Height));
      FillPath.CloseFigure;
      l := FrameR.X;
      t := FrameR.y;
      w := FrameR.Width;
      d := FTabOptions.ShapeCornerRadius * 2;
      FramePath.StartFigure;
      FramePath.AddArc(l, t, d, d, 180, 90);
      FramePath.AddArc(l + w - d, t, d, d, 270, 90);
      FramePath.AddLine(MakePoint(FrameR.X + FrameR.Width, FrameR.Y + FrameR.Height),
      MakePoint(FrameR.X, FrameR.Y + FrameR.Height));
      FramePath.CloseFigure;
    end;

    G.IntersectClip(TabR);
    G.FillPath(B, FillPath);
    if LB <> nil then
    begin
      G.FillPath(LB, FramePath);
      LB.Free;
    end
    else
      G.DrawPath(P, FramePath);
    G.ResetClip;

    B.Free;
    P.Free;
    FramePath.Free;
    FillPath.Free;
  end;

  // draw image and text
  ACanvas.Font := Self.Font;
  ACanvas.Font.Color := FC;

 if Tabs[Index].CustomGlowEffect.Enabled then
   FGlowEffect := Tabs[Index].CustomGlowEffect
 else
   FGlowEffect := FTabGlowEffect;

 FGlowColor := FGlowEffect.GetColor;
 case TabState of
   scsHot: FGlowColor := FGlowEffect.GetHotColor;
   scsPressed: FGlowColor := FGlowEffect.GetPressedColor;
   scsFocused: FGlowColor := FGlowEffect.GetFocusedColor;
 end;
 if FGlowColor = clNone then
   FGlowColor := FGlowEffect.GetColor;

 ACanvas.Brush.Style := bsClear;
 ACanvas.Font.Color := FC;

 R := FTabs[Index].TabRect;
 Inc(R.Top, FFrameWidth);

 if FTabWidth = 0 then
 begin
   if IsRightToLeft then
     Dec(R.Right, FTabMargin)
   else
     Inc(R.Left, FTabMargin);
 end
 else
 begin
   Inc(R.Left, FTabMargin);
   Dec(R.Right, FTabMargin);

   if FShowCloseButtons and
      (FTabs[Index].ShowCloseButton and
      (not FShowCloseButtonOnActiveTabOnly or (FShowCloseButtonOnActiveTabOnly and (TabIndex = Index)))) then
   begin
     if IsRightToLeft then
     begin
       Inc(R.Left,  FCloseButtonSize + 15);
       Dec(R.Left, FTabMargin);
     end
     else
     begin
       Dec(R.Right,  FCloseButtonSize + 15);
       Inc(R.Right, FTabMargin);
     end;
   end;
 end;

 IIndex := FTabs[Index].ImageIndex;
 IImages := FTabImages;

 if Assigned(FOnGetTabImage) then
   FOnGetTabImage(Index, IImages, IIndex);

 if not Focused and (TabState = scsFocused) then
    TabState := scsPressed;

 if Assigned(FOnGetTabDrawParams) then
   FOnGetTabDrawParams(Index, TabState, ACanvas);

 if FDrawTextMode = scdtmGDIPlus then
 begin
   if (IImages <> nil) and (IIndex >= 0) and  (IIndex < IImages.Count) then
   begin
     if FTabWidth = 0 then
     begin
       GPDrawImageAndText(G, ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
          FTabs[Index].Caption, IIndex, IImages,
          FTabs[Index].Enabled and Self.Enabled, False, IsRightToLeft, True, 1, False);
     end
     else
     begin
       GPDrawImageAndText(G, ACanvas, R, 0, -101, GlyphLayout[IsRightToLeft],
         FTabs[Index].Caption, IIndex, IImages,
         FTabs[Index].Enabled and Self.Enabled, False, IsRightToLeft, True, 1, False, True);
     end;
   end
   else
   begin
     CR := R;

     if FTabWidth = 0 then
       Flags := DT_LEFT or DT_VCENTER
     else
       Flags := DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS;

     OffsetRect(CR, 0, 2);
     GPDrawText(G, nil, ACanvas, CR, FTabs[Index].Caption,
       scDrawTextBidiModeFlags(Flags, BidiMode = bdRightToLeft));
   end;
 end
 else
 if (IImages <> nil) and (IIndex >= 0) and
    (IIndex < IImages.Count) then
 begin
   if FTabWidth = 0 then
   begin
     if FGlowEffect.Enabled and (TabState in FGlowEffect.States) then
        DrawImageAndTextWithGlow2(ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
          FTabs[Index].Caption, IIndex, IImages,
          FTabs[Index].Enabled and Self.Enabled, False, clBlack,
          FGlowEffect.Offset, FGlowColor,
          FGlowEffect.GlowSize, FGlowEffect.Intensive,
          FGlowEffect.GetAlphaValue, True,
          False, IsRightToLeft, True)
      else
        DrawImageAndText2(ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
          FTabs[Index].Caption, IIndex, IImages,
          FTabs[Index].Enabled and Self.Enabled, False, clBlack, False, IsRightToLeft, True);
   end
   else
   begin
     if FGlowEffect.Enabled and (TabState in FGlowEffect.States) then
       DrawImageAndTextWithGlow2(ACanvas, R, 0, -101, GlyphLayout[IsRightToLeft],
         FTabs[Index].Caption, IIndex, IImages,
         FTabs[Index].Enabled and Self.Enabled, False, clBlack,
         FGlowEffect.Offset, FGlowColor,
         FGlowEffect.GlowSize, FGlowEffect.Intensive,
         FGlowEffect.GetAlphaValue, True,
         False, IsRightToLeft, True, 1, False, True)
     else
       DrawImageAndText2(ACanvas, R, 0, -101, GlyphLayout[IsRightToLeft],
         FTabs[Index].Caption, IIndex, IImages,
         FTabs[Index].Enabled and Self.Enabled, False, clBlack, False, IsRightToLeft, True, 1, False, True);

   end;
  end
  else
  begin
    CR := R;

    if FTabWidth = 0 then
      Flags := DT_LEFT or DT_VCENTER or DT_SINGLELINE
    else
      Flags := DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_SINGLELINE;

    OffsetRect(CR, 0, 1);

    if FGlowEffect.Enabled and (TabState in FGlowEffect.States) then
      DrawTextWithGlow(ACanvas, CR, FTabs[Index].Caption, Flags,
        FGlowEffect.Offset, FGlowColor, FGlowEffect.GlowSize,
        FGlowEffect.Intensive, FGlowEffect.GetAlphaValue, IsRightToLeft, True)
    else
      DrawText(ACanvas.Handle, PChar(FTabs[Index].Caption),
        Length(FTabs[Index].Caption), CR,
        scDrawTextBidiModeFlags(Flags , BidiMode = bdRightToLeft));
   end;

  if FShowCloseButtons and
    (FTabs[Index].ShowCloseButton and
    (not FShowCloseButtonOnActiveTabOnly or (FShowCloseButtonOnActiveTabOnly and (TabIndex = Index)))) then
  begin
    R := FTabs[Index].TabRect;
    if IsRightToLeft then
      R.Right := R.Left + FCloseButtonSize + 15
    else
      R.Left := R.Right - FCloseButtonSize - 15;

    DrawCloseButton(ACanvas, G, R, Index, FC);
  end;

end;

function TscGPPageControl.CreatePage: TscGPPageControlPage;
var
  LPage: TscGPPageControlPage;
  R: TRect;
begin
  LPage := TscGPPageControlPage.Create(Self.Owner);
  LPage.Parent := Self;
  LPage.Pager := Self;
  R := GetPageBoundsRect;
  LPage.SetBounds(R.Left, R.Top, R.Right, R.Bottom);
  LPage.Name := SC_GetUniqueName('scGPPageControlPage%d', Self.Owner);
  ActivePage := LPage;
  Result := LPage;

  if not (csLoading in ComponentState) then
  begin
    FScrollOffset := 0;
    GetScrollInfo;
    AdjustScrollButtons;
    FTabIndex := GetPageIndex(FActivePage);
    ScrollToTab(FTabIndex);
  end;

  RePaintControl;
end;

constructor TscGPTabControlTab.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FCustomOptions := TscGPTabOptions.Create;
  {$IFDEF VER340_UP}
  FCustomOptions.FControl := TscGPTabControlTabs(Collection).TabControl;
  {$ENDIF}
  FCustomOptions.OnChange := OnOptionsChange;
  FCustomGlowEffect := TscButtonGlowEffect.Create;
  {$IFDEF VER340_UP}
  FCustomGlowEffect.FControl := TscGPTabControlTabs(Collection).TabControl;
  {$ENDIF}
  FCustomGlowEffect.States := [scsFocused];
  FCustomGlowEffect.OnChange := OnOptionsChange;
  FShowCloseButton := True;
  FUseCustomOptions := False;
  FCustomFrameColor := clNone;
  FCustomFrameColorAlpha := 255;
  Active := False;
  CloseButtonMouseIn := False;
  CloseButtonMouseDown := False;
  CloseButtonRect := Rect(0, 0, 0, 0);
  FEnabled := True;
  FVisible := True;
  FCaption := 'TscGPTabControlTab' + IntToStr(Index + 1);
  FImageIndex := -1;
end;

destructor TscGPTabControlTab.Destroy;
begin
  FCustomOptions.Free;
  FCustomGlowEffect.Free;
  inherited;
end;

procedure TscGPTabControlTab.Assign(Source: TPersistent);
begin
  if Source is TscGPTabControlTab then
  begin
    FCaption := TscGPTabControlTab(Source).Caption;
    FImageIndex := TscGPTabControlTab(Source).ImageIndex;
    FVisible := TscGPTabControlTab(Source).Visible;
    FEnabled := TscGPTabControlTab(Source).Enabled;
    FShowCloseButton := TscGPTabControlTab(Source).ShowCloseButton;
    FUseCustomOptions := TscGPTabControlTab(Source).UseCustomOptions;
    FCustomOptions.Assign(TscGPTabControlTab(Source).CustomOptions);
    FCustomFrameColor := TscGPTabControlTab(Source).CustomFrameColor;
    FCustomFrameColorAlpha := TscGPTabControlTab(Source).CustomFrameColorAlpha;
  end
  else
   inherited Assign(Source);
end;

procedure TscGPTabControlTab.OnOptionsChange(Sender: TObject);
begin
  Changed(False);
end;

procedure TscGPTabControlTab.SetShowCloseButton(Value: Boolean);
begin
  if FShowCloseButton <> Value then
  begin
    FShowCloseButton := Value;
    Changed(False);
  end;
end;

procedure TscGPTabControlTab.SetCustomFrameColor(Value: TColor);
begin
  if FCustomFrameColor <> Value then
  begin
    FCustomFrameColor := Value;
    Changed(False);
  end;
end;

procedure TscGPTabControlTab.SetCustomFrameColorAlpha(Value: Byte);
begin
  if FCustomFrameColorAlpha <> Value then
  begin
    FCustomFrameColorAlpha := Value;
    Changed(False);
  end;
end;

procedure TscGPTabControlTab.SetUseCustomOptions(Value: Boolean);
begin
  if FUseCustomOptions <> Value then
  begin
    FUseCustomOptions := Value;
    Changed(False);
  end;
end;

procedure TscGPTabControlTab.SetCaption(Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TscGPTabControlTab.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value
  then
    begin
      FEnabled := Value;
      Changed(False);
    end;
end;

procedure TscGPTabControlTab.SetImageIndex(Value: Integer);
begin
  if FImageIndex <> Value
  then
    begin
      FImageIndex := Value;
      Changed(False);
    end;
end;

procedure TscGPTabControlTab.SetVisible(Value: Boolean);
var
  B: Boolean;
  i, j: Integer;
  FPager: TscGPTabControl;
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(False);
    FPager := TscGPTabControlTabs(Collection).TabControl;
    if (FPager <> nil) and (FPager.TabIndex = Index) and not FVisible
       and not (csLoading in FPager.ComponentState)
    then
    begin
      j := Index;
      B := False;
      if j < FPager.Tabs.Count then
        for i := j to FPager.Tabs.Count - 1 do
        begin
          if (i >= 0) and (i < FPager.Tabs.Count) then
            if FPager.Tabs[i].Visible and FPager.Tabs[i].Enabled then
             begin
               FPager.FTabIndex := -1;
               FPager.TabIndex := i;
               B := True;
               Break;
             end;
         end;

      if not B and (j >= 0) then
        for i := j downto 0 do
        begin
          if (i >= 0) and (i < FPager.Tabs.Count) then
            if FPager.Tabs[i].Visible and FPager.Tabs[i].Enabled then
            begin
              FPager.FTabIndex := -1;
              FPager.TabIndex := i;
              Break;
            end;
        end;
       FPager.AdjustScrollButtons;
     end;
  end;
end;

constructor TscGPTabControlTabs.Create;
begin
  inherited Create(TscGPTabControlTab);
  TabControl := ATabControl;
  DestroyTab := nil;
end;

function TscGPTabControlTabs.GetOwner: TPersistent;
begin
  Result := TabControl;
end;

procedure TscGPTabControlTabs.Clear;
begin
  if TabControl <> nil then
    TabControl.FTabIndex := -1;
  inherited;
end;

function TscGPTabControlTabs.Add: TscGPTabControlTab;
begin
  Result := TscGPTabControlTab(inherited Add);
  if (TabControl <> nil) and
     not (csLoading in TabControl.ComponentState) then
  begin
    TabControl.FScrollOffset := 0;
    TabControl.RePaintControl;
    TabControl.GetScrollInfo;
    TabControl.AdjustScrollButtons;
  end;
end;

function TscGPTabControlTabs.Insert(Index: Integer): TscGPTabControlTab;
begin
  Result := TscGPTabControlTab(inherited Insert(Index));
  if (TabControl <> nil)
     and not (csDesigning in TabControl.ComponentState)
     and not (csLoading in TabControl.ComponentState)
  then
  begin
    TabControl.FScrollOffset := 0;
    TabControl.RePaintControl;
    TabControl.GetScrollInfo;
    TabControl.AdjustScrollButtons;
  end;
end;

procedure TscGPTabControlTabs.Delete(Index: Integer);
begin
  inherited Delete(Index);
  if (TabControl <> nil) and
     not (csLoading in TabControl.ComponentState) then
  begin
    TabControl.FScrollOffset := 0;
    TabControl.RePaintControl;
    TabControl.GetScrollInfo;
    TabControl.AdjustScrollButtons;
    //
    if TabControl.TabIndex > Index then
      Dec(TabControl.FTabIndex);
    //
    if TabControl.TabIndex > Count - 1 then
      TabControl.TabIndex := Count - 1
    else
      TabControl.ScrollToTab(TabControl.TabIndex);
    //
  end;
end;

procedure TscGPTabControlTabs.Update(Item: TCollectionItem);
var
  F: TCustomForm;
begin
  inherited;
  if TabControl = nil then
    Exit;

  if (csDesigning in TabControl.ComponentState) and
     not (csLoading in  TabControl.ComponentState) and
     not (csDestroying in TabControl.ComponentState)
  then
  begin
    F := GetParentForm(TabControl);
    if F <> nil then
      F.Designer.Modified;
  end;

  TabControl.UpdateTabs;
end;

function TscGPTabControlTabs.GetItem(Index: Integer):  TscGPTabControlTab;
begin
  Result := TscGPTabControlTab(inherited GetItem(Index));
end;

procedure TscGPTabControlTabs.SetItem(Index: Integer; Value:  TscGPTabControlTab);
begin
  inherited SetItem(Index, Value);
end;

constructor TscGPTabControl.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FTabIndex := -1;
  FDragSourceTab := nil;
  FEnableDragReorderTabs := False;
  FTabsScaling := False;
  FStopCloseTab := False;
  FTabsBGFillColor := clNone;
  FTabsBGFillColorAlpha := 255;

  FScrollButtonArrowColor := clBtnText;
  FScrollButtonArrowThickness := 2;
  FScrollButtonColor := clBtnText;
  FScrollButtonTransparent := False;

  Color := clBtnFace;
  ParentBackground := False;
  ParentColor := False;
  FTabs := TscGPTabControlTabs.Create(Self);
  FTabOptions := TscGPTabOptions.Create;
  {$IFDEF VER340_UP}
  FTabOptions.FControl := Self;
  {$ENDIF}
  FTabOptions.OnChange := OnControlChange;
  FTabCloseButtonOptions := TscGPTabCloseButtonOptions.Create;
  {$IFDEF VER340_UP}
  FTabCloseButtonOptions.FControl := Self;
  {$ENDIF}
  FTabCloseButtonOptions.OnChange := OnControlChange;
  FFrameWidth := 2;
  FFrameScaleWidth := False;
  FFrameColor := clBtnText;
  FFrameColorAlpha := 80;
  FScrollButtonWidth := 20;
  FCloseButtonSize := TAB_CLOSE_SIZE;
  FBorderStyle := scgpbsFrame;
  FShowInactiveTab := True;
  FTabGlowEffect := TscButtonGlowEffect.Create;
  {$IFDEF VER340_UP}
  FTabGlowEffect.FControl := Self;
  {$ENDIF}
  FTabGlowEffect.States := [scsFocused];
  FTabGlowEffect.OnChange := OnControlChange;
  FMouseWheelSupport := True;
  FShowCloseButtons := False;
  FShowCloseButtonOnActiveTabOnly := False;
  FTabMargin := 10;
  FTabSpacing := 10;
  FTabWidth := 0;
  FDeleteOnClose := False;
  FTabHeight := DefPagerTabHeight;
  FTabImages := nil;
  FTransparentBackground := False;

  FMouseIn := False;
  FScrollOffset := 0;
  FLeftOffset := 6;
  FRightOffset := 5;
  Width := 300;
  Height := 150;
  FOldTabActive := -1;
  FTabActive := -1;
  FOldWidth := -1;
  FTabsTopOffset := 0;
  FTabsLeftOffset := 15;
  FTabsRightOffset := 15;
  FLeftScrollButton := nil;
  FRightScrollButton := nil;
  FShowFocusRect := True;
end;

destructor TscGPTabControl.Destroy;
begin
  FTabOptions.Free;
  FTabGlowEffect.Free;
  FTabCloseButtonOptions.Free;
  FTabs.Free;
  FTabs := nil;
  inherited;
end;

procedure TscGPTabControl.SetTabsBGFillColor(Value: TColor);
begin
  if FTabsBGFillColor <> Value then
  begin
    FTabsBGFillColor := Value;
    RePaintControl;
    UpdateControls;
  end;
end;

procedure TscGPTabControl.SetTabsBGFillColorAlpha(Value: Byte);
begin
  if FTabsBGFillColorAlpha <> Value then
  begin
    FTabsBGFillColorAlpha := Value;
    RePaintControl;
    UpdateControls;
  end;
end;

procedure TscGPTabControl.ChangeScale(M, D: Integer{$IFDEF VER310_UP}; isDpiChange: Boolean{$ENDIF});
begin
  if FFrameScaleWidth then
    FFrameWidth := MulDiv(FFrameWidth, M, D);

  if (FTabOptions.TabStyle <> gptsShape) or FFrameScaleWidth then
    FTabOptions.FrameWidth := MulDiv(FTabOptions.FrameWidth, M, D);

  if FTabWidth > 0 then
    FTabWidth := MulDiv(FTabWidth, M, D);
  FScrollButtonArrowThickness := MulDiv(FScrollButtonArrowThickness, M, D);
  FTabOptions.FShapeCornerRadius := MulDiv(FTabOptions.FShapeCornerRadius, M, D);
  FCloseButtonSize := MulDiv(FCloseButtonSize, M, D);
  FTabMargin := MulDiv(FTabMargin, M, D);
  FScrollButtonWidth := MulDiv(FScrollButtonWidth, M, D);
  FTabHeight := MulDiv(FTabHeight, M, D);
  FTabsTopOffset := MulDiv(FTabsTopOffset, M, D);
  FTabsLeftOffset := MulDiv(FTabsLeftOffset, M, D);
  FTabsRightOffset := MulDiv(FTabsRightOffset, M, D);
  if not (csLoading in ComponentState) then
    FTabsScaling := True;
  inherited;
  SetTimer(Handle, 1, 100, nil);
end;

procedure TscGPTabControl.UpdateScrollButtons;
begin
  if (FLeftScrollButton <> nil) and FLeftScrollButton.Visible then
  begin
    FLeftScrollButton.UpdateOptions(FScrollButtonColor, FScrollButtonArrowColor,
      FScrollButtonArrowThickness, FScrollButtonTransparent);
    FLeftScrollButton.Repaint;
  end;
  if (FRightScrollButton <> nil) and FRightScrollButton.Visible then
  begin
    FRightScrollButton.UpdateOptions(FScrollButtonColor, FScrollButtonArrowColor,
      FScrollButtonArrowThickness, FScrollButtonTransparent);
    FRightScrollButton.RePaint;
  end;
end;

procedure TscGPTabControl.SetScrollButtonArrowColor(Value: TColor);
begin
  if FScrollButtonArrowColor <> Value then
  begin
    FScrollButtonArrowColor := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPTabControl.SetScrollButtonArrowThickness(Value: Byte);
begin
  if (FScrollButtonArrowThickness <> Value) and (Value >= 1) then
  begin
    FScrollButtonArrowThickness := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPTabControl.SetScrollButtonColor(Value: TColor);
begin
  if FScrollButtonColor <> Value then
  begin
    FScrollButtonColor := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPTabControl.SetScrollButtonTransparent(Value: Boolean);
begin
  if FScrollButtonTransparent <> Value then
  begin
    FScrollButtonTransparent := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPTabControl.SetScrollButtonWidth(Value: Integer);
begin
  if (Value >= 20) and (FScrollButtonWidth <> Value) then
  begin
    FScrollButtonWidth := Value;
    GetScrollInfo;
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.DoClose;
var
  CanClose: Boolean;
  P: TPoint;
begin
  if (FTabIndex < 0) or (FTabIndex >= Tabs.Count) then
    Exit;

  CanClose := True;
  if Assigned(FOnClose) then FOnClose(Self, CanClose);

  if CanClose then
  begin
    FScrollOffset := 0;
    if FDeleteOnClose then
    begin
      FTabs.Delete(FTabIndex);
      if FTabs.Count = 0 then
      begin
        FTabIndex := -1;
        FTabActive := -1;
      end;
    end
    else
      FTabs[FTabIndex].Visible := False;
  end;

  if not CanClose then
  begin
    GetCursorPos(P);
    if (WinApi.Windows.WindowFromPoint(P) <> Self.Handle) and (FTabActive <> -1) then
    begin
      FTabs[FTabActive].CloseButtonMouseIn := False;
      FTabs[FTabActive].CloseButtonMouseDown := False;
      RePaintControl;
    end;
  end;

end;

procedure TscGPTabControl.DrawCloseButton(ACanvas: TCanvas;
  G: TGPGraphics;
  ARect: TRect; AIndex: Integer;  AColor: TColor);
var
  X, Y: Integer;
  ButtonR: TRect;
  GlyphColor, FillColor: Cardinal;
  R: TGPRectF;
  B: TGPSolidBrush;
begin
  X := ARect.Left + ARect.Width div 2 - FCloseButtonSize div 2;
  Y := ARect.Top + ARect.Height div 2 - FCloseButtonSize div 2 + FFrameWidth;
  ButtonR := Rect(X, Y, X + FCloseButtonSize, Y + FCloseButtonSize);
  R := RectToGPRect(ButtonR);
  Tabs[AIndex].CloseButtonRect := ButtonR;

  if not Tabs[AIndex].Enabled then
    FTabCloseButtonOptions.State := scsDisabled
  else
  if Tabs[AIndex].CloseButtonMouseDown then
    FTabCloseButtonOptions.State := scsPressed
  else
  if Tabs[AIndex].CloseButtonMouseIn then
    FTabCloseButtonOptions.State := scsHot
  else
    FTabCloseButtonOptions.State := scsNormal;

  if FTabCloseButtonOptions.ColorAlpha <> 0 then
  begin
    FillColor := ColorToGPColor(FTabCloseButtonOptions.Color, FTabCloseButtonOptions.ColorAlpha);
    B := TGPSolidBrush.Create(FillColor);
    case FTabCloseButtonOptions.ShapeKind of
      scgptcbRounded:
        G.FillEllipse(B, R);
      scgptcbRect:
        G.FillRectangle(B, R);
    end;
    B.Free;
  end;

  GlyphColor := ColorToGPColor(FTabCloseButtonOptions.GlyphColor, FTabCloseButtonOptions.GlyphColorAlpha);

  InflateGPRect(R, -FCloseButtonSize div 4, -FCloseButtonSize div 4);
  scGPUtils.GPDrawClearGlyph
    (G, R, GlyphColor, FScaleFactor, 2);
end;

procedure TscGPTabControl.SetShowCloseButtons(Value: Boolean);
begin
  if FShowCloseButtons <> Value then
  begin
    FShowCloseButtons := Value;
    GetScrollInfo;
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.UpdateControls;
var
  I: Integer;
begin
  for I := 0 to ControlCount - 1 do
  begin
    if (Controls[i] is TWinControl)
    then
      SendMessage(TWinControl(Controls[I]).Handle, WM_CHECKPARENTBG, 0, 0)
    else
    if Controls[i] is TGraphicControl
     then
       TGraphicControl(Controls[I]).Perform(WM_CHECKPARENTBG, 0, 0);
  end;
end;

procedure TscGPTabControl.AdjustClientRect(var Rect: TRect);
begin
  Rect := GetPageBoundsRect;
end;

procedure TscGPTabControl.SetFrameWidth(Value: Integer);
begin
  if Value <> FFrameWidth then
  begin
    FFrameWidth := Value;
    RePaintControl;
    ReAlign;
  end;
end;

procedure TscGPTabControl.SetFrameColor(Value: TColor);
begin
  if Value <> FFrameColor then
  begin
    FFrameColor := Value;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.SetFrameColorAlpha(Value: Byte);
begin
  if Value <> FFrameColorAlpha then
  begin
    FFrameColorAlpha := Value;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.SetTabsTopOffset(Value: Integer);
begin
  if Value <> FTabsTopOffset then
  begin
    FTabsTopOffset := Value;
    RePaintControl;
    ReAlign;
  end;
end;

procedure TscGPTabControl.SetBorderStyle(Value: TscGPTabControlBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RePaintControl;
    ReAlign;
  end;
end;

procedure TscGPTabControl.SetTabsLeftOffset(Value: Integer);
begin
  if (Value <> FTabsLeftOffset) and (Value >= 0) then
  begin
    FTabsLeftOffset := Value;
    RePaintControl;
    AdjustScrollButtons;
    ScrollToTab(FTabIndex);
  end;
end;

procedure TscGPTabControl.SetShowInActiveTab(Value: Boolean);
begin
  if Value <> FShowInActiveTab then
  begin
    FShowInActiveTab := Value;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.SetTabsRightOffset(Value: Integer);
begin
  if (Value <> FTabsRightOffset) and (Value >= 0) then
  begin
    FTabsRightOffset := Value;
    RePaintControl;
    AdjustScrollButtons;
    ScrollToTab(FTabIndex);
  end;
end;

procedure TscGPTabControl.OnControlChange(Sender: TObject);
begin
  RePaintControl;
end;

procedure TscGPTabControl.SetShowFocusRect(Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.Draw(ACanvas: TCanvas; ACtrlState: TscsCtrlState);
var
  TabRect: TRect;
  FFirst: Boolean;
  FFirstVisible: Boolean;
  I: Integer;
  SaveIndex: Integer;
  G: TGPGraphics;
  P: TGPPen;
  C: Cardinal;
  R, R1: TGPRectF;
  W: Integer;
  B: TGPSolidBrush;
  FScrollBWidth: Integer;
begin
  FTabsRect := Rect(0, 0, Width, FTabHeight + FTabsTopOffset);
  TabRect := Rect(0, FTabHeight + FTabsTopOffset, Width, Height);

  // draw background
  if not FTransparentBackground then
    with ACanvas do
    begin
      if seClient in StyleElements then
        Brush.Color := GetStyleColor(Color{$IFDEF VER340_UP}, Self{$ENDIF})
      else
        Brush.Color := Color;
      FillRect(TabRect);
      if seClient in StyleElements then
        Brush.Color := GetStyleColor(Color{$IFDEF VER340_UP}, Self{$ENDIF})
      else
        Brush.Color := Color;
      FillRect(FTabsRect);
    end;

  // draw border
  G := TGPGraphics.Create(ACanvas.Handle);
  G.SetSmoothingMode(SmoothingModeHighQuality);
  G.SetPixelOffsetMode(PixelOffsetModeHalf);

  if (FTabsBGFillColor <> clNone) and (FTabsBGFillColorAlpha > 0) then
  begin
    C := ColorToGPColor(GetStyleCOlor(FTabsBGFillColor{$IFDEF VER340_UP}, Self{$ENDIF}), FTabsBGFillColorAlpha);
    B := TGPSolidBrush.Create(C);
    R := RectToGPRect(FTabsRect);
    G.FillRectangle(B, R);
    B.Free;
  end;

  if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and (FTabs[FTabIndex].CustomFrameColor <> clNone) then
    C := ColorToGPColor(GetStyleColor(FTabs[FTabIndex].CustomFrameColor{$IFDEF VER340_UP}, Self{$ENDIF}), FTabs[FTabIndex].CustomFrameColorAlpha)
  else
    C := ColorToGPColor(GetStyleColor(FFrameColor{$IFDEF VER340_UP}, Self{$ENDIF}), FFrameColorAlpha);

  P := TGPPen.Create(C, FFrameWidth);
  if not FGetControlBG then
    CalcTabRects;

  if (FBorderStyle <> scgpbsNone) and not FGetControlBG and (FFrameWidth > 0) then
  begin
    if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and FTabs[FTabIndex].Visible then
    begin
      if FScrollVisible then
        W := FTabsLeftOffset + FScrollButtonWidth
      else
        W := FTabsLeftOffset;
      R1 := RectToGPRect(FTabs[FTabIndex].TabRect);
      if FBorderStyle <> scgpbsNone then
        R1.Height := R1.Height + FFrameWidth;
      if R1.X < W then
      begin
        R1.Width := R1.Width - (W - R1.X);
        R1.X := W;
      end;

      if FScrollVisible then
        W := FTabsRightOffset + FScrollButtonWidth
      else
        W := FTabsRightOffset;

      if R1.X + R1.Width > Width - W then
      begin
        R1.Width := R1.Width - (R1.X + R1.Width - (Width - W));
      end;
      if (R1.Width > 0) and (R1.X <= Width - W) then
        G.ExcludeClip(R1);
    end;
    R := RectToGPRect(TabRect);
    InflateGPRect(R, -FFrameWidth / 2, -FFrameWidth / 2);
    if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
    begin
      R.X := 0;
      R.Width := Width;
    end;
    if FBorderStyle = scgpbsFrame then
      G.DrawRectangle(P, R)
    else
    if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
    begin
      G.DrawLine(P, R.X, R.Y, R.X + R.Width, R.Y);
      if FBorderStyle = scgpbsLineTopBottom then
        G.DrawLine(P, R.X, R.Y + R.Height, R.X + R.Width, R.Y + R.Height);
    end;
    if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and FTabs[FTabIndex].Visible and (R1.Width > 0) and (R1.X <= Width - FTabsRightOffset) then
      G.ResetClip;
  end
  else
  if not FGetControlBG and (FBorderStyle = scgpbsNone) then
  begin
    C := ColorToGPColor(clBlack, 0);
    P.SetColor(C);
    G.DrawLine(P, 0, 0, 1, 1);
  end;

  if Tabs.Count = 0 then
  begin
    P.Free;
    G.Free;
    Exit;
  end;

  // draw items

  FTabIndexBeforeFocused := FindDrawPriorTabFromIndex(FTabIndex);
  FTabIndexAfterFocused := FindDrawNextTabFromIndex(FTabIndex);

  SaveIndex := SaveDC(ACanvas.Handle);
  try
    if not FGetControlBG then
    begin
      if (FLeftScrollButton <> nil) and FLeftScrollButton.Visible then
        FScrollBWidth := FScrollButtonWidth
      else
        FScrollBWidth := 0;
      IntersectClipRect(ACanvas.Handle,
        FTabsLeftOffset + FScrollBWidth, FTabsTopOffset, Width - FTabsRightOffset - FScrollBWidth, FTabsTopOffset + FTabHeight + 2);

      FFirstVisible := False;
      for I := 0 to FTabs.Count - 1  do
      begin
        if FTabs[I].Visible then
        begin
          FFirst := (FTabsLeftOffset = 0) and (FTabs[I].TabRect.Left = 0);
          if not FFirstVisible and (I = FTabIndex) and not FTabs[I].Enabled then
          begin
            FFirst := True;
            FFirstVisible := True;
          end
          else
          if not FFirstVisible and (I <> FTabIndex) then
          begin
            FFirst := True;
            FFirstVisible := True;
          end
          else
          if not FShowInActiveTab then
            FFirst := (I <> FTabIndex);
          if (I = TabIndex) and FTabs[I].Enabled then
            FFirstVisible := True;
          DrawTab(ACanvas, G, I, FFirst);
        end;
      end;
    end;
  finally
    RestoreDC(ACanvas.Handle, SaveIndex);
  end;

  G.Free;
  P.Free;
end;

procedure TscGPTabControl.SetTabImages(Value: TCustomImageList);
begin
  if FTabImages <> Value then
  begin
    FTabImages := Value;
    UpdateTabs;
  end;
end;

procedure TscGPTabControl.SetTabHeight;
begin
  if FTabHeight <> Value then
  begin
    FTabHeight := Value;
    ReAlign;
    RePaintControl;
    AdjustScrollButtons;
  end;
end;

procedure TscGPTabControl.SetTabMargin(Value: Integer);
begin
  if (Value > 0) and (FTabMargin <> Value) then
  begin
    FTabMargin := Value;
    UpdateTabs;
  end;
end;

procedure TscGPTabControl.SetTabWidth(Value: Integer);
begin
  if (Value >= 0) and (FTabWidth <> Value) then
  begin
    FTabWidth := Value;
    UpdateTabs;
  end;
end;

procedure TscGPTabControl.SetShowCloseButtonOnActiveTabOnly(Value: Boolean);
begin
  if FShowCloseButtonOnActiveTabOnly <> Value then
  begin
    FShowCloseButtonOnActiveTabOnly := Value;
    RePaintControl;
  end;
end;


procedure TscGPTabControl.SetTabSpacing(Value: Integer);
begin
  if (Value > 0) and (FTabSpacing <> Value) then
  begin
    FTabSpacing := Value;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.SetTabIndex;
var
  B: Boolean;
begin
  if Value = -1 then
  begin
    FTabIndex := Value;
    if not (csLoading in ComponentState) then
      RePaintControl;
    Exit;
  end;

  if (Value < 0) or (Value > Tabs.Count - 1) then
  begin
    if csLoading in ComponentState then
     FTabIndex := Value;
    Exit;
  end;

  if Assigned(FOnCanChangeTab) and not (csLoading in ComponentState) then
  begin
    B := True;
    FOnCanChangeTab(Value, B);
    if not B then Exit;
  end;

  if not Tabs[Value].FVisible then Tabs[Value].FVisible := True;

  if (FTabIndex <> Value) and (Value >= 0) and (Value < Tabs.Count)
  then
    begin
      FTabIndex := Value;
      if not (csLoading in ComponentState) then
        if Assigned(FOnChangingTab) then FOnChangingTab(Self);

      if FScrollVisible then
         ScrollToTab(FTabIndex);

      if not (csLoading in ComponentState) then
        if Assigned(FOnChangeTab) then FOnChangeTab(Self);
    end;

  RePaintControl;
end;


function TscGPTabControl.TabFromPoint;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Tabs.Count -1 do
    if Tabs[i].Visible and PtInRect(Tabs[i].TabRect, P)
    then
      begin
        Result := i;
        Break;
      end;
end;

procedure TscGPTabControl.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateTabs;
end;

procedure TscGPTabControl.CMDesignHitTest;
var
  P: TPoint;
  I: Integer;
  F: TCustomForm;
begin
  inherited;
  P := SmallPointToPoint(Message.Pos);
  I := TabFromPoint(P);
  if (Message.Keys = MK_LBUTTON) and (I <> -1) then
  begin
    TabIndex := I;
    F := GetParentForm(Self);
    if F <> nil then
      F.Designer.Modified;
  end;
end;

procedure TscGPTabControl.SetTransparentBackground(Value: Boolean);
begin
  if FTransparentBackground <> Value then
  begin
    FTransparentBackground := Value;
    GetParentBG;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
    with Params.WindowClass do
      Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TscGPTabControl.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FTabImages) then
    FTabImages := nil;
end;

function TscGPTabControl.FindNextTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPTabControl.FindPriorTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPTabControl.FindDrawNextTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPTabControl.FindDrawPriorTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

procedure TscGPTabControl.FindNextTab;
var
  i, j, k: Integer;
begin
  j := TabIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPTabControl.FindPriorTab;
var
  i, j, k: Integer;
begin
  j := TabIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPTabControl.FindFirstTab;
var
  i, k: Integer;
begin
  k := -1;
  for i := 0 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPTabControl.FindLastTab;
var
  i, k: Integer;
begin
  k := -1;
  for i := Tabs.Count - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPTabControl.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if Message.TimerID = 1 then
  begin
    FTabsScaling := False;
    UpdateTabs;
    KillTimer(Handle, 1);
  end;
end;

procedure TscGPTabControl.WMMOUSEWHEEL(var Message: TWMMOUSEWHEEL);
begin
  if FMouseWheelSupport then
    if BidiMode <> bdRightToLeft then
     begin
       if Message.WheelDelta < 0 then FindNextTab else FindPriorTab;
     end
     else
     begin
       if Message.WheelDelta > 0 then FindNextTab else FindPriorTab;
     end;
end;

procedure TscGPTabControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    if (FTabIndex >= 0) and (FTabIndex < Tabs.Count) then
    begin
      if Assigned(FTabs[FTabIndex].OnClick) then
        FTabs[FTabIndex].OnClick(Self);
    end;
  end
  else
  if BidiMode <> bdRightToLeft then
  begin
    if (Key = VK_NEXT)
    then
      FindLastTab
    else
    if (Key = VK_PRIOR)
    then
      FindFirstTab
    else
    if (Key = VK_LEFT) or (Key = VK_UP)
    then
      FindPriorTab
    else
    if (Key = VK_RIGHT) or (Key = VK_DOWN)
    then
      FindNextTab;
  end
  else
  begin
    if (Key = VK_NEXT)
    then
      FindFirstTab
    else
    if (Key = VK_PRIOR)
    then
      FindLastTab
    else
    if (Key = VK_LEFT) or (Key = VK_UP)
    then
      FindNextTab
    else
    if (Key = VK_RIGHT) or (Key = VK_DOWN)
    then
      FindPriorTab;
  end;
end;

procedure TscGPTabControl.WMGetDlgCode;
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TscGPTabControl.WMSETFOCUS;
begin
  inherited;
  if not (csLoading in ComponentState) then
    if not FTransparentBackground then
      RePaintControl
    else
    begin
      FUpdateParentBuffer := True;
      if DrawTextMode = scdtmGDIPlus then
        Invalidate
      else
        RePaint;
    end;
end;

procedure TscGPTabControl.WMKILLFOCUS;
begin
  inherited;
  if not (csLoading in ComponentState) then
    RePaintControl;
end;

procedure TscGPTabControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  TestActive(X, Y);
end;

procedure TscGPTabControl.DragDrop(Source: TObject; X, Y: Integer);
var
  Index: Integer;
begin
  inherited;
  if (Source = Self) and (FDragSourceTab <> nil) then
  begin
    Index := TabFromPoint(Point(X, Y));
    if (Index <> -1) and (Index <> FDragSourceTab.Index) then
    begin
      FDragSourceTab.Index := Index;
      TabIndex := Index;
      Abort;
    end;
  end;
  FDragSourceTab := nil;
end;

procedure TscGPTabControl.DragOver(Source: TObject; X, Y: Integer; State: TDragState;
    var Accept: Boolean);
begin
  inherited;
  Accept := (Source <> nil) and (Source = Self) and (FDragSourceTab <> nil);
end;

procedure TscGPTabControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer);
var
  WasFocused: Boolean;
  OldTabIndex: Integer;
begin
  inherited;
  if Button <> mbLeft then Exit;
  TestActive(X, Y);
  WasFocused := Focused;

  OldTabIndex := TabIndex;
  FStopCloseTab := False;

  if (FTabActive <> TabIndex) and (FTabActive <> -1) then
  begin
    TabIndex := FTabActive;
    FStopCloseTab := FShowCloseButtonOnActiveTabOnly;
  end;

  if not WasFocused then SetFocus;

  if (FTabs.Count > 0) and (FTabActive <> -1) and (FTabActive < FTabs.Count) and FShowCloseButtons and
     (FTabs[FTabActive].ShowCloseButton and
     (not FShowCloseButtonOnActiveTabOnly or (FShowCloseButtonOnActiveTabOnly and (OldTabIndex = FTabActive))))
     and not (csDesigning in ComponentState)
  then
    with FTabs[FTabActive] do
    begin
      if PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := True;
        CloseButtonMouseDown := True;
        RePaintControl;
      end
      else
      if not PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := False;
        CloseButtonMouseDown := False;
      end;
   end;

  if (FTabs.Count > 0) and FEnableDragReorderTabs and (Button = mbLeft) and (FTabActive <> -1) then
  begin
    FDragSourceTab := Tabs[FTabActive];
    if not FDragSourceTab.CloseButtonMouseIn and DragDetect(Handle, Mouse.CursorPos) then
      BeginDrag(False, 3)
    else
      FDragSourceTab := nil;
  end
  else
    FDragSourceTab := nil;
end;

procedure TscGPTabControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer);
begin
  inherited;
  if Button <> mbLeft then Exit;

  if PtInRect(FTabsRect, Point(X, Y)) and Assigned(FOnTabsAreaClick) then
    FOnTabsAreaClick(Self);

  TestActive(X, Y);
  if (FTabIndex >= 0) and (FTabIndex < Tabs.Count) and (FTabIndex = FTabActive) then
  begin
    if Assigned(FTabs[FTabIndex].OnClick) then
        FTabs[FTabIndex].OnClick(Self);
  end;

  if (FTabs.Count > 0) and (FTabActive <> -1) and FShowCloseButtons and
    (FTabs[FTabActive].ShowCloseButton and
    (not FShowCloseButtonOnActiveTabOnly or (ShowCloseButtonOnActiveTabOnly and (TabIndex = FTabActive))))
    and not (csDesigning in ComponentState)
  then
    with FTabs[FTabActive] do
    begin
      if PtInRect(CloseButtonRect, Point(X, Y)) and not FStopCloseTab then
      begin
        CloseButtonMouseIn := True;
        CloseButtonMouseDown := False;
        RePaintControl;
        DoClose;
      end
      else
      if not PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := False;
        CloseButtonMouseDown := False;
      end;
   end;
  FStopCloseTab := False;
end;

procedure TscGPTabControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  TestActive(-1, -1);
end;

procedure TscGPTabControl.TestActive(X, Y: Integer);
var
  i: Integer;
begin
  if Tabs.Count = 0 then Exit;

  FOldTabActive:= FTabActive;
  FTabActive := -1;

  for i := 0 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled and PtInRect(Tabs[i].TabRect, Point(X, Y)) and
       (X >= FTabsLeftOffset) and (X < Width - FTabsRightOffset)
    then
      begin
        FTabActive := i;
        Break;
      end;
  end;

  if (FTabActive <> FOldTabActive)
  then
    begin
      if (FOldTabActive <> - 1) and (FOldTabActive < Tabs.Count)
      then
      begin
        Tabs[FOldTabActive].Active := False;
        Tabs[FOldTabActive].CloseButtonMouseIn := False;
        Tabs[FOldTabActive].CloseButtonMouseDown := False;
      end;
      if (FTabActive <> - 1)
      then
        Tabs[FTabActive].Active := True;
      RePaintControl;
    end;

  if (FTabActive <> -1) and FShowCloseButtons and
     (FTabs[FTabActive].ShowCloseButton and
     (not FShowCloseButtonOnActiveTabOnly or (ShowCloseButtonOnActiveTabOnly and (TabIndex = FTabActive)))) then

  with Tabs[FTabActive] do
  begin
    if PtInRect(CloseButtonRect, Point(X, Y)) and not CloseButtonMouseIn then
    begin
      CloseButtonMouseIn := True;
      RePaintControl;
    end
    else
    if not PtInRect(CloseButtonRect, Point(X, Y)) and CloseButtonMouseIn then
    begin
      CloseButtonMouseIn := False;
      CloseButtonMouseDown := False;
      RePaintControl;
    end;
  end;

end;

procedure TscGPTabControl.ScrollToTab(AIndex: Integer);
var
  R: TRect;
  Offset, SW: Integer;
begin
  if (AIndex < 0) or (AIndex > Tabs.Count - 1) then Exit;

  R := Tabs[AIndex].TabRect;
  if FScrollVisible then
    SW := FScrollButtonWidth
  else
    SW := 0;
  if R.Left < FTabsLeftOffset + SW then
  begin
    Offset := Abs(FTabsLeftOffset - R.Left);
    Inc(Offset, SW);

    if BidiMode <> bdRightToLeft then
      FScrollOffset := FScrollOffset - Offset
    else
      FScrollOffset := FScrollOffset + Offset;

    if FScrollOffset < 0 then FScrollOffset := 0;
    RePaintControl;
  end
  else
  if R.Right > Width - FTabsRightOffset - SW then
  begin
    Offset := R.Right - (Width - FTabsRightOffset);
    Inc(Offset, SW);

    if BidiMode <> bdRightToLeft then
      FScrollOffset := FScrollOffset + Offset
    else
      FScrollOffset := FScrollOffset - Offset;

    if FScrollOffset < 0 then FScrollOffset := 0;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.ScrollToLeft;
begin
  CalcTabRects;
  if FLeftTabIndex >= 0 then
    ScrollToTab(FLeftTabIndex);
end;

procedure TscGPTabControl.ScrollToRight;
begin
  CalcTabRects;
  if FRightTabIndex >= 0 then
    ScrollToTab(FRightTabIndex);
end;

procedure TscGPTabControl.OnLeftScrollButtonClick(Sender: TObject);
begin
  ScrollToLeft;
end;

procedure TscGPTabControl.OnRightScrollButtonClick(Sender: TObject);
begin
  ScrollToRight;
end;

procedure TscGPTabControl.ShowScrollButtons;
var
  B: Boolean;
begin
  B := False;
  if FLeftScrollButton = nil then
  begin
    FLeftScrollButton := TscGPTabScrollButton.CreateEx(Self,
      FScrollButtonColor, FScrollButtonArrowColor, FScrollButtonArrowThickness, FScrollButtonTransparent);
    FLeftScrollButton.OnClick := OnLeftScrollButtonClick;
    FLeftScrollButton.Visible := False;
    FLeftScrollButton.RepeatClick := True;
    FLeftScrollButton.CanFocused := False;
    FLeftScrollButton.GlyphOptions.Kind := scgpbgkLeftArrow;

    FLeftScrollButton.Parent := Self;
    FLeftScrollButton.SetBounds(FTabsLeftOffset, FTabsTopOffset,
      FScrollButtonWidth, FTabHeight);

    FLeftScrollButton.Visible := True;
    B := True;
  end
  else
    FLeftScrollButton.SetBounds(FTabsLeftOffset, FTabsTopOffset,
      FScrollButtonWidth, FTabHeight);
  if FRightScrollButton = nil then
  begin
    FRightScrollButton := TscGPTabScrollButton.CreateEx(Self,
      FScrollButtonColor, FScrollButtonArrowColor, FScrollButtonArrowThickness, FScrollButtonTransparent);
    FRightScrollButton.Visible := False;
    FRightScrollButton.FRight := True;
    FRightScrollButton.OnClick := OnRightScrollButtonClick;
    FRightScrollButton.RepeatClick := True;
    FRightScrollButton.CanFocused := False;
    FRightScrollButton.GlyphOptions.Kind := scgpbgkRightArrow;
    FRightScrollButton.Parent := Self;
    FRightScrollButton.SetBounds(Width - FTabsRightOffset - FScrollButtonWidth,
      FTabsTopOffset, FScrollButtonWidth, FTabHeight);
    FRightScrollButton.Visible := True;
    B := True;
  end
  else
    FRightScrollButton.SetBounds(Width - FTabsRightOffset - FScrollButtonWidth,
      FTabsTopOffset, FScrollButtonWidth, FTabHeight);

  if B and not(csLoading in ComponentState) then
    RePaintControl;
end;

procedure TscGPTabControl.HideScrollButtons;
begin
  if FLeftScrollButton <> nil then
  begin
    FLeftScrollButton.Visible := False;
    FLeftScrollButton.Free;
    FLeftScrollButton := nil;
  end;
  if FRightScrollButton <> nil then
  begin
    FRightScrollButton.Visible := False;
    FRightScrollButton.Free;
    FRightScrollButton := nil;
  end;
end;

procedure TscGPTabControl.AdjustScrollButtons;
begin
  if FTabsScaling then
    Exit;

  if FScrollVisible then
    ShowScrollButtons
  else
    HideScrollButtons;
end;

procedure TscGPTabControl.GetScrollInfo;
var
  I, X: Integer;
begin
  X := FTabsLeftOffset;
  for I := 0 to Tabs.Count - 1 do
    if Tabs[I].Visible then
    begin
      X := X + GetTabWidth(I);
    end;
  FScrollVisible := X > Width - FTabsRightOffset;
end;

function TscGPTabControl.GetTabWidth(AIndex: Integer): Integer;
var
  R: TRect;
  IIndex: Integer;
  IImages: TCustomImageList;
begin
  if FTabWidth > 0 then
  begin
    Result := FTabWidth;
    Exit;
  end;
  Result := FTabMargin * 2;
  if Result < 10 then Result := 10;
  R := Rect(0, 0, 0, 0);
  if Assigned(FOnGetTabDrawParams) then
  begin
    Canvas.Font := Self.Font;
    FOnGetTabDrawParams(AIndex, scsNormal, Canvas);
  end;
  DrawText(Canvas.Handle, PChar(Tabs[AIndex].Caption),
   Length(Tabs[AIndex].Caption), R,
   DT_LEFT or DT_CALCRECT);

  Result := Result + R.Width;

  IIndex := Tabs[AIndex].ImageIndex;
  IImages := FTabImages;

 if Assigned(FOnGetTabImage) then
   FOnGetTabImage(AIndex, IImages, IIndex);

  if (IImages <> nil) and (IIndex >= 0) and (IIndex < IImages.Count) then
    Result := Result + FTabSpacing + IImages.Width;

  if FShowCloseButtons and Tabs[AIndex].ShowCloseButton then
    Inc(Result, FCloseButtonSize + 6);
end;

procedure TscGPTabControl.UpdateTabs;
begin
  if not (csLoading in ComponentState) and
     not (csDestroying in ComponentState) then
  begin
    FScrollOffset := 0;
    CalcTabRects;
    GetScrollInfo;
    ScrollToTab(FTabIndex);
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPTabControl.CalcTabRects;
var
  I, X, Y, W, ScrollW: Integer;
begin
  GetScrollInfo;

  if BidiMode <> bdRightToLeft then
  begin
    X := FTabsLeftOffset - FScrollOffset;
    if FScrollVisible then
      Inc(X, FScrollButtonWidth);
  end
  else
  begin
    X := Width - FTabsRightOffset + FScrollOffset;
    if FScrollVisible then
      Dec(X, FScrollButtonWidth);
  end;

  Y := FTabsTopOffset;
  Canvas.Font := Self.Font;
  FLeftTabIndex := -1;
  FRightTabIndex := -1;
  if FScrollVisible then
    ScrollW := FScrollButtonWidth
  else
    ScrollW := 0;

  for I := 0 to Tabs.Count - 1 do
    if Tabs[I].Visible then
    begin
      W := GetTabWidth(I);
      if BidiMode <> bdRightToLeft then
      begin
        Tabs[I].TabRect := Rect(X, Y, X + W, Y + FTabHeight);
        X := X + W;
        if Tabs[I].TabRect.Left < FTabsLeftOffset + ScrollW
        then
          FLeftTabIndex := I;
        if (Tabs[I].TabRect.Right > Width - FTabsRightOffset - ScrollW) and
           (FRightTabIndex = -1)
        then
          FRightTabIndex := I;
       end
      else
      begin
        Tabs[I].TabRect := Rect(X - W, Y, X, Y + FTabHeight);
        X := X - W;
        if (Tabs[I].TabRect.Left < FTabsLeftOffset + ScrollW) and
           (FLeftTabIndex = -1)
        then
          FLeftTabIndex := I;
        if Tabs[I].TabRect.Right > Width - FTabsRightOffset - ScrollW
        then
          FRightTabIndex := I;
      end;
   end;
end;

procedure TscGPTabControl.SetTabs(AValue: TscGPTabControlTabs);
begin
  FTabs.Assign(AValue);
  RePaintControl;
end;

procedure TscGPTabControl.Loaded;
begin
  inherited;
  CalcTabRects;
  GetScrollInfo;
  AdjustScrollButtons;
  ScrollToTab(FTabIndex);
end;

function TscGPTabControl.GetPageBoundsRect: TRect;
begin
  Result.Left := 0;
  Result.Top := FTabHeight + FTabsTopOffset;
  Result.Bottom := Height;
  Result.Right := Width;
  if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
  begin
    Inc(Result.Top, FFrameWidth);
    if FBorderStyle = scgpbsLineTopBottom then
       Dec(Result.Bottom, FFrameWidth);
  end
  else
  if FBorderStyle = scgpbsFrame then
  begin
    Inc(Result.Top, FFrameWidth);
    Inc(Result.Left, FFrameWidth);
    Dec(Result.Bottom, FFrameWidth);
    Dec(Result.Right, FFrameWidth);
  end
end;

procedure TscGPTabControl.WMSIZE(var Message: TWMSIZE);
var
  B: Boolean;
begin
  B := FScrollVisible;

  inherited;

  if (FOldWidth <> Width) and (FOldWidth <> -1)
  then
    begin
      GetScrollInfo;
      AdjustScrollButtons;
      if FScrollOffset > 0
      then
        FScrollOffset := FScrollOffset - (Width - FOldWidth);
      if FScrollOffset < 0 then FScrollOffset := 0;
    end;

  FOldWidth := Width;

  if B <> FScrollVisible then
  begin
    FScrollOffset := 0;
    ScrollToTab(FTabIndex);
  end;

  RePaintControl;
end;

procedure TscGPTabControl.DrawTab(ACanvas: TCanvas; G: TGPGraphics; Index: Integer; AFirst: Boolean);
const
  GlyphLayout: array[Boolean] of TButtonLayout = (blGlyphLeft, blGlyphRight);
var
  FC: TColor;
  TabState: TscsCtrlState;
  R, CR: TRect;
  IIndex: Integer;
  IImages: TCustomImageList;

  FGlowColor: TColor;
  FillR, FrameR, GPR, TabR: TGPRectF;
  TabFillC, TabFrameC, C1, C2: Cardinal;
  FramePath, FillPath: TGPGraphicsPath;
  P: TGPPen;
  l, t, w, d: Single;
  B, LB: TGPBrush;
  SW: Integer;
  FOptions: TscGPTabOptions;
  FGlowEffect: TscButtonGlowEffect;
  Flags: Integer;
begin

  R := FTabs[Index].TabRect;

  if Index = FTabIndex then
    Inc(R.Bottom, FFrameWidth);

  TabR := RectToGPRect(R);

  if FLeftScrollButton <> nil then
     SW := FTabsLeftOffset + FScrollButtonWidth
   else
     SW := FTabsLeftOffset;
  if TabR.X < SW then
  begin
    TabR.Width := TabR.Width - (SW - TabR.X);
    TabR.X := SW;
  end;
  if FRightScrollButton <> nil then
    SW := FTabsRightOffset + FScrollButtonWidth
  else
    SW := FTabsRightOffset;
  if TabR.X + TabR.Width > Width - SW then
  begin
    TabR.Width := TabR.Width - (TabR.X + TabR.Width - (Width - SW));
  end;

  if TabR.Width <= 0 then Exit;

  if Tabs[Index].UseCustomOptions then
    FOptions := Tabs[Index].CustomOptions
  else
    FOptions := FTabOptions;


  R.Bottom := R.Bottom + FFrameWidth * 2;

  if (TabIndex = Index) and Tabs[Index].Enabled and Tabs[Index].Visible then
  begin
    if Focused then
      TabState := scsFocused
    else
      TabState := scsPressed;
  end
  else
  if FTabs[Index].Active then
    TabState := scsHot
  else
  if FTabs[Index].Enabled then
    TabState := scsNormal
  else
    TabState := scsDisabled;

  FOptions.State := TabState;
  FC := FOptions.FontColor;

  if TabState = scsDisabled then
  begin
    if IsLightColor(FC) then
      FC := DarkerColor(FC, 40)
    else
      FC := LighterColor(FC, 40);
  end;


  // draw tab shape
  if not (((TabState = scsNormal) or (TabState = scsDisabled)) and not FShowInActiveTab) then
  begin
    FillR := RectToGPRect(R);
    FrameR := RectToGPRect(R);

    if TabState = scsDisabled then
    begin
      TabFillC := ColorToGPColor(FOptions.Color, FOptions.ColorAlpha div 2);
      TabFrameC := ColorToGPColor(FOptions.FrameColor, FOptions.FrameColorAlpha div 2);
    end
    else
    begin
      TabFillC := ColorToGPColor(FOptions.Color, FOptions.ColorAlpha);
      TabFrameC := ColorToGPColor(FOptions.FrameColor, FOptions.FrameColorAlpha);
    end;
    if FOptions.ShapeFillStyle = scgpsfColor then
       B := TGPSolidBrush.Create(TabFillC)
    else
    begin
      C1 := ColorToGPColor(LighterColor(FOptions.Color, FOptions.GradientColorOffset), FOptions.ColorAlpha);
      C2 := TabFillC;
      GPR := FillR;
      InflateGPRect(GPR, FOptions.FrameWidth, FOptions.FrameWidth);
      B := TGPLinearGradientBrush.Create(GPR, C1, C2, FOptions.FShapeFillGradientAngle);
    end;

    P := TGPPen.Create(TabFrameC, FTabOptions.FrameWidth);
    FramePath := TGPGraphicsPath.Create;
    FillPath := TGPGraphicsPath.Create;
    if (FTabOptions.FrameWidth > 0) and (FTabOptions.FTabStyle = gptsShape) then
    begin
      InflateGPRect(FillR, -FTabOptions.FrameWidth + 0.2, -FTabOptions.FrameWidth + 0.2);
      InflateGPRect(FrameR, -FTabOptions.FrameWidth / 2, -FTabOptions.FrameWidth / 2);
    end;

    LB := nil;
    if FTabOptions.FTabStyle = gptsRoundedLine then
    begin
      LB := TGPSolidBrush.Create(TabFrameC);
      GPFillRoundedRectPath(FillPath, FillR, FTabOptions.ShapeCornerRadius);
      if FTabOptions.LineWidth <= 0 then
        scGPUtils.GPDrawHVRoundedLinePath(FramePath, FTabOptions.FrameWidth,
          FrameR.X + FTabOptions.ShapeCornerRadius,
          FrameR.Y + FrameR.Height - FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width - FTabOptions.ShapeCornerRadius,
          FrameR.Y + FrameR.Height - FTabOptions.FFrameWidth)
      else
        scGPUtils.GPDrawHVRoundedLinePath(FramePath, FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width / 2 - FTabOptions.LineWidth div 2,
          FrameR.Y + FrameR.Height - FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width / 2 + FTabOptions.LineWidth div 2,
          FrameR.Y + FrameR.Height - FTabOptions.FFrameWidth)
    end
    else
    if (FTabOptions.FShapeCornerRadius = 0) or (FTabOptions.FTabStyle in [gptsBottomLine, gptsLine]) then
    begin
      FillPath.AddRectangle(FillR);
      if FTabOptions.FTabStyle in [gptsBottomLine, gptsLine] then
      begin
        InflateGPRect(FrameR, -FTabOptions.FrameWidth / 2, -FTabOptions.FrameWidth / 2);
        FrameR.X := FillR.X;
        FrameR.Width := FillR.Width;
        if FTabOptions.LineWidth <= 0 then
          FramePath.AddLine(MakePoint(FrameR.X, FrameR.Y + FrameR.Height),
            MakePoint(FrameR.X + FrameR.Width, FrameR.Y + FrameR.Height))
        else
          FramePath.AddLine(MakePoint(FrameR.X + FrameR.Width / 2 - FTabOptions.LineWidth div 2,
            FrameR.Y + FrameR.Height),
            MakePoint(FrameR.X + FrameR.Width / 2 + FTabOptions.LineWidth div 2,
            FrameR.Y + FrameR.Height));
      end
      else
        FramePath.AddRectangle(FrameR);
    end
    else
    begin
      l := FillR.X;
      t := FillR.y;
      w := FillR.Width;
      d := FTabOptions.ShapeCornerRadius * 2 - FOptions.FrameWidth;
      if d < 1 then d := 1;
      FillPath.StartFigure;
      FillPath.AddArc(l, t, d, d, 180, 90);
      FillPath.AddArc(l + w - d, t, d, d, 270, 90);
      FillPath.AddLine(MakePoint(FillR.X + FillR.Width, FillR.Y + FillR.Height),
      MakePoint(FillR.X, FillR.Y + FillR.Height));
      FillPath.CloseFigure;
      l := FrameR.X;
      t := FrameR.y;
      w := FrameR.Width;
      d := FTabOptions.ShapeCornerRadius * 2;
      FramePath.StartFigure;
      FramePath.AddArc(l, t, d, d, 180, 90);
      FramePath.AddArc(l + w - d, t, d, d, 270, 90);
      FramePath.AddLine(MakePoint(FrameR.X + FrameR.Width, FrameR.Y + FrameR.Height),
      MakePoint(FrameR.X, FrameR.Y + FrameR.Height));
      FramePath.CloseFigure;
    end;

    G.IntersectClip(TabR);
    G.FillPath(B, FillPath);
    if LB <> nil then
    begin
      G.FillPath(LB, FramePath);
      LB.Free;
    end
    else
      G.DrawPath(P, FramePath);
    G.ResetClip;

    B.Free;
    P.Free;
    FramePath.Free;
    FillPath.Free;
  end;

  // draw image and text
  ACanvas.Font := Self.Font;
  ACanvas.Font.Color := FC;

 if Tabs[Index].CustomGlowEffect.Enabled then
   FGlowEffect := Tabs[Index].CustomGlowEffect
 else
   FGlowEffect := FTabGlowEffect;

 FGlowColor := FGlowEffect.GetColor;
 case TabState of
   scsHot: FGlowColor := FGlowEffect.GetHotColor;
   scsPressed: FGlowColor := FGlowEffect.GetPressedColor;
   scsFocused: FGlowColor := FGlowEffect.GetFocusedColor;
 end;
 if FGlowColor = clNone then
   FGlowColor := FGlowEffect.GetColor;

 ACanvas.Brush.Style := bsClear;
 ACanvas.Font.Color := FC;

 R := FTabs[Index].TabRect;
 Inc(R.Top, FFrameWidth);

 if FTabWidth = 0 then
 begin
   if IsRightToLeft then
     Dec(R.Right, FTabMargin)
   else
     Inc(R.Left, FTabMargin);
 end
 else
 begin
   Inc(R.Left, FTabMargin);
   Dec(R.Right, FTabMargin);

   if FShowCloseButtons and
      (FTabs[Index].ShowCloseButton and
      (not FShowCloseButtonOnActiveTabOnly or (FShowCloseButtonOnActiveTabOnly and (TabIndex = Index)))) then
   begin
     if IsRightToLeft then
     begin
       Inc(R.Left,  FCloseButtonSize + 15);
       Dec(R.Left, FTabMargin);
     end
     else
     begin
       Dec(R.Right,  FCloseButtonSize + 15);
       Inc(R.Right, FTabMargin);
     end;
   end;
 end;

 IIndex := FTabs[Index].ImageIndex;
 IImages := FTabImages;

 if Assigned(FOnGetTabImage) then
   FOnGetTabImage(Index, IImages, IIndex);

 if not Focused and (TabState = scsFocused) then
    TabState := scsPressed;

 if Assigned(FOnGetTabDrawParams) then
   FOnGetTabDrawParams(Index, TabState, ACanvas);

 if FDrawTextMode = scdtmGDIPlus then
 begin
   if (IImages <> nil) and (IIndex >= 0) and  (IIndex < IImages.Count) then
   begin
     if FTabWidth = 0 then
     begin
       GPDrawImageAndText(G, ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
          FTabs[Index].Caption, IIndex, IImages,
          FTabs[Index].Enabled and Self.Enabled, False, IsRightToLeft, True, 1, False);
     end
     else
     begin
       GPDrawImageAndText(G, ACanvas, R, 0, -101, GlyphLayout[IsRightToLeft],
         FTabs[Index].Caption, IIndex, IImages,
         FTabs[Index].Enabled and Self.Enabled, False, IsRightToLeft, True, 1, False, True);
     end;
   end
   else
   begin
     CR := R;

     if FTabWidth = 0 then
       Flags := DT_LEFT or DT_VCENTER
     else
       Flags := DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS;

     OffsetRect(CR, 0, 2);
     GPDrawText(G, nil, ACanvas, CR, FTabs[Index].Caption,
       scDrawTextBidiModeFlags(Flags, BidiMode = bdRightToLeft));
   end;
 end
 else
 if (IImages <> nil) and (IIndex >= 0) and
    (IIndex < IImages.Count) then
 begin
   if FTabWidth = 0 then
   begin
     if FGlowEffect.Enabled and (TabState in FGlowEffect.States) then
        DrawImageAndTextWithGlow2(ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
          FTabs[Index].Caption, IIndex, IImages,
          FTabs[Index].Enabled and Self.Enabled, False, clBlack,
          FGlowEffect.Offset, FGlowColor,
          FGlowEffect.GlowSize, FGlowEffect.Intensive,
          FGlowEffect.GetAlphaValue, True,
          False, IsRightToLeft, True)
      else
        DrawImageAndText2(ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
          FTabs[Index].Caption, IIndex, IImages,
          FTabs[Index].Enabled and Self.Enabled, False, clBlack, False, IsRightToLeft, True);
   end
   else
   begin
     if FGlowEffect.Enabled and (TabState in FGlowEffect.States) then
       DrawImageAndTextWithGlow2(ACanvas, R, 0, -101, GlyphLayout[IsRightToLeft],
         FTabs[Index].Caption, IIndex, IImages,
         FTabs[Index].Enabled and Self.Enabled, False, clBlack,
         FGlowEffect.Offset, FGlowColor,
         FGlowEffect.GlowSize, FGlowEffect.Intensive,
         FGlowEffect.GetAlphaValue, True,
         False, IsRightToLeft, True, 1, False, True)
     else
       DrawImageAndText2(ACanvas, R, 0, -101, GlyphLayout[IsRightToLeft],
         FTabs[Index].Caption, IIndex, IImages,
         FTabs[Index].Enabled and Self.Enabled, False, clBlack, False, IsRightToLeft, True, 1, False, True);

   end;
  end
  else
  begin
    CR := R;

    if FTabWidth = 0 then
      Flags := DT_LEFT or DT_VCENTER or DT_SINGLELINE
    else
      Flags := DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_SINGLELINE;

    OffsetRect(CR, 0, 1);

    if FGlowEffect.Enabled and (TabState in FGlowEffect.States) then
      DrawTextWithGlow(ACanvas, CR, FTabs[Index].Caption, Flags,
        FGlowEffect.Offset, FGlowColor, FGlowEffect.GlowSize,
        FGlowEffect.Intensive, FGlowEffect.GetAlphaValue, IsRightToLeft, True)
    else
      DrawText(ACanvas.Handle, PChar(FTabs[Index].Caption),
        Length(FTabs[Index].Caption), CR,
        scDrawTextBidiModeFlags(Flags , BidiMode = bdRightToLeft));
   end;

  if FShowCloseButtons and
    (FTabs[Index].ShowCloseButton and
    (not FShowCloseButtonOnActiveTabOnly or (FShowCloseButtonOnActiveTabOnly and (TabIndex = Index)))) then
  begin
    R := FTabs[Index].TabRect;
    if IsRightToLeft then
      R.Right := R.Left + FCloseButtonSize + 15
    else
      R.Left := R.Right - FCloseButtonSize - 15;

    DrawCloseButton(ACanvas, G, R, Index, FC);
  end;

end;

constructor TscGPToolPagerTab.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FCustomOptions := TscGPTabOptions.Create;
  {$IFDEF VER340_UP}
  FCustomOptions.FControl := TscGPToolPagerTabs(Collection).Pager;
  {$ENDIF}
  FCustomOptions.OnChange := OnOptionsChange;
  FCustomGlowEffect := TscButtonGlowEffect.Create;
  {$IFDEF VER340_UP}
  FCustomGlowEffect.FControl := TscGPToolPagerTabs(Collection).Pager;
  {$ENDIF}
  FCustomGlowEffect.States := [scsFocused];
  FCustomGlowEffect.OnChange := OnOptionsChange;
  FShowCloseButton := True;
  FUseCustomOptions := False;
  FCustomFrameColor := clNone;
  FCustomFrameColorAlpha := 255;
  Active := False;
  CloseButtonMouseIn := False;
  CloseButtonMouseDown := False;
  CloseButtonRect := Rect(0, 0, 0, 0);
  FEnabled := True;
  FVisible := True;
  FPage := nil;
  FCaption := 'TscGPToolPagerTab' + IntToStr(Index + 1);
  FImageIndex := -1;
  if (TscGPToolPagerTabs(Collection).Pager <> nil) and
     (csDesigning in  TscGPToolPagerTabs(Collection).Pager.ComponentState) and
      not (csLoading in TscGPToolPagerTabs(Collection).Pager.ComponentState) and
      not (csUpdating in TscGPToolPagerTabs(Collection).Pager.ComponentState) and
      not (csReading in  TscGPToolPagerTabs(Collection).Pager.ComponentState) and
      not (csWriting in TscGPToolPagerTabs(Collection).Pager.ComponentState)
  then
  begin
    FPage := TscGPToolPagerTabs(Collection).Pager.CreatePage;
    TscGPToolPagerTabs(Collection).Pager.ActivePage := FPage;
  end;
end;

destructor TscGPToolPagerTab.Destroy;
begin
   if TscGPToolPagerTabs(Collection).FClearing and
      (TscGPToolPagerTabs(Collection).Pager <> nil)
      and not (csLoading in  TscGPToolPagerTabs(Collection).Pager.ComponentState)
      and not (csDestroying in TscGPToolPagerTabs(Collection).Pager.ComponentState)
      and not (csUpdating in TscGPToolPagerTabs(Collection).Pager.ComponentState)
      and not (csReading in TscGPToolPagerTabs(Collection).Pager.ComponentState)
      and not (csWriting in TscGPToolPagerTabs(Collection).Pager.ComponentState)
      and (FPage <> nil)
  then
  begin
    FPage.FDestroyFromPager := True;
    FreeAndNil(FPage);
  end
  else
  if (TscGPToolPagerTabs(Collection).Pager <> nil)
     and (csDesigning in  TscGPToolPagerTabs(Collection).Pager.ComponentState)
     and not (csLoading in  TscGPToolPagerTabs(Collection).Pager.ComponentState)
     and not (csDestroying in TscGPToolPagerTabs(Collection).Pager.ComponentState)
     and not (csUpdating in TscGPToolPagerTabs(Collection).Pager.ComponentState)
     and not (csReading in TscGPToolPagerTabs(Collection).Pager.ComponentState)
     and not (csWriting in TscGPToolPagerTabs(Collection).Pager.ComponentState)
     and (FPage <> nil)
  then
    TscGPToolPagerTabs(Collection).DestroyPage := FPage;
  FCustomOptions.Free;
  FCustomGlowEffect.Free;
  inherited;
end;

procedure TscGPToolPagerTab.Assign(Source: TPersistent);

  function FindControl(AControl: TWinControl): TscGPToolPagerPage;
  begin
    if (AControl <> nil) and (TscGPToolPagerTabs(Collection).Pager <> nil) and
       (TscGPToolPagerTabs(Collection).Pager.Owner <> nil)
    then
      Result := TscGPToolPagerTabs(Collection).Pager.Owner.FindComponent(AControl.Name) as TscGPToolPagerPage
    else
      Result := nil;
  end;

begin
  if Source is TscGPToolPagerTab then
  begin
    FPage := FindControl(TscGPToolPagerTab(Source).Page);
    FCaption := TscGPToolPagerTab(Source).Caption;
    FImageIndex := TscGPToolPagerTab(Source).ImageIndex;
    FVisible := TscGPToolPagerTab(Source).Visible;
    FEnabled := TscGPToolPagerTab(Source).Enabled;
    FShowCloseButton := TscGPToolPagerTab(Source).ShowCloseButton;
    FUseCustomOptions := TscGPToolPagerTab(Source).UseCustomOptions;
    FCustomOptions.Assign(TscGPToolPagerTab(Source).CustomOptions);
    FCustomFrameColor := TscGPToolPagerTab(Source).CustomFrameColor;
    FCustomFrameColorAlpha := TscGPToolPagerTab(Source).CustomFrameColorAlpha;
  end
  else
    inherited Assign(Source);
end;

procedure TscGPToolPagerTab.OnOptionsChange(Sender: TObject);
begin
  Changed(False);
end;

procedure TscGPToolPagerTab.SetShowCloseButton(Value: Boolean);
begin
  if FShowCloseButton <> Value then
  begin
    FShowCloseButton := Value;
    Changed(False);
  end;
end;

procedure TscGPToolPagerTab.SetCustomFrameColor(Value: TColor);
begin
  if FCustomFrameColor <> Value then
  begin
    FCustomFrameColor := Value;
    Changed(False);
  end;
end;

procedure TscGPToolPagerTab.SetCustomFrameColorAlpha(Value: Byte);
begin
  if FCustomFrameColorAlpha <> Value then
  begin
    FCustomFrameColorAlpha := Value;
    Changed(False);
  end;
end;

procedure TscGPToolPagerTab.SetUseCustomOptions(Value: Boolean);
begin
  if FUseCustomOptions <> Value then
  begin
    FUseCustomOptions := Value;
    Changed(False);
  end;
end;

procedure TscGPToolPagerTab.SetCaption(Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TscGPToolPagerTab.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value
  then
    begin
      FEnabled := Value;
      Changed(False);
    end;
end;

procedure TscGPToolPagerTab.SetImageIndex(Value: Integer);
begin
  if FImageIndex <> Value
  then
    begin
      FImageIndex := Value;
      Changed(False);
    end;
end;

procedure TscGPToolPagerTab.SetVisible(Value: Boolean);
var
  B: Boolean;
  i, j: Integer;
  FPager: TscGPToolPager;
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(False);
    FPager := TscGPToolPagerTabs(Collection).Pager;
    if (FPager <> nil) and (Page = FPager.ActivePage) and not FVisible
       and not (csLoading in FPager.ComponentState)
    then
    begin
      j := Index;
      B := False;
      if j < FPager.Tabs.Count then
        for i := j to FPager.Tabs.Count - 1 do
        begin
          if (i >= 0) and (i < FPager.Tabs.Count) then
            if FPager.Tabs[i].Visible and FPager.Tabs[i].Enabled then
             begin
               FPager.FTabIndex := -1;
               FPager.TabIndex := i;
               B := True;
               Break;
             end;
         end;

      if not B and (j >= 0) then
        for i := j downto 0 do
        begin
          if (i >= 0) and (i < FPager.Tabs.Count) then
            if FPager.Tabs[i].Visible and FPager.Tabs[i].Enabled then
            begin
              FPager.FTabIndex := -1;
              FPager.TabIndex := i;
              Break;
            end;
        end;
       if FPage <> nil then FPage.Visible := False;
       FPager.AdjustScrollButtons;
     end;
  end;
end;

procedure TscGPToolPagerTab.SetPage(const Value: TscGPToolPagerPage);
begin
  if FPage <> Value then
  begin
    FPage := Value;
    if (FPage <> nil) and (FPage.Pager <> nil) then
      FPage.Pager.ActivePage := FPage;
  end;
end;

constructor TscGPToolPagerTabs.Create;
begin
  inherited Create(TscGPToolPagerTab);
  Pager := APager;
  DestroyPage := nil;
  FClearing := False;
end;

function TscGPToolPagerTabs.GetOwner: TPersistent;
begin
  Result := Pager;
end;

procedure TscGPToolPagerTabs.Clear;
begin
  FClearing := True;
  try
    inherited;
  finally
    if Pager <> nil then
      Pager.FTabIndex := -1;
    FClearing := False;
  end;
end;

function TscGPToolPagerTabs.Add: TscGPToolPagerTab;
begin
  Result := TscGPToolPagerTab(inherited Add);
  if (Pager <> nil)
     and not (csDesigning in Pager.ComponentState)
     and not (csLoading in Pager.ComponentState)
  then
  begin
    Result.Page := Pager.CreatePage;
    Pager.ActivePage := Result.Page;
  end;

  if (Pager <> nil) and
     not (csLoading in Pager.ComponentState) then
  begin
    Pager.FScrollOffset := 0;
    Pager.GetScrollInfo;
    Pager.AdjustScrollButtons;
    Pager.ScrollToTab(Pager.TabIndex);
  end;
end;

function TscGPToolPagerTabs.Insert(Index: Integer): TscGPToolPagerTab;
begin
  Result := TscGPToolPagerTab(inherited Insert(Index));
  if (Pager <> nil)
     and not (csDesigning in Pager.ComponentState)
     and not (csLoading in Pager.ComponentState)
  then
  begin
    Result.Page := Pager.CreatePage;
    Pager.FScrollOffset := 0;
    Pager.GetScrollInfo;
    Pager.AdjustScrollButtons;
  end;
end;

procedure TscGPToolPagerTabs.Delete(Index: Integer);
begin
   if (Pager <> nil)
      and not (csDesigning in Pager.ComponentState)
      and not (csLoading in Pager.ComponentState)
      and (Items[Index].FPage <> nil)
  then
    FreeAndNil(Items[Index].FPage);
  inherited Delete(Index);
  if (Pager <> nil) and
     not (csLoading in Pager.ComponentState) then
  begin
    if Pager.TabIndex > Index then
      Dec(Pager.FTabIndex);
    Pager.FScrollOffset := 0;
    Pager.CalcTabRects;
    Pager.GetScrollInfo;
    Pager.ScrollToTab(Pager.TabIndex);
  end;
end;

procedure TscGPToolPagerTabs.Update(Item: TCollectionItem);
var
  F: TCustomForm;
begin
  inherited;
  if Pager = nil then
    Exit;

  if (DestroyPage <> nil) and
     (csDesigning in Pager.ComponentState) and
     not (csLoading in  Pager.ComponentState) and
     not (csDestroying in Pager.ComponentState)
  then
  begin
    FreeAndNil(DestroyPage);
    F := GetParentForm(Pager);
    if F <> nil then
      F.Designer.Modified;
  end;

  Pager.UpdateTabs;
end;

function TscGPToolPagerTabs.GetItem(Index: Integer):  TscGPToolPagerTab;
begin
  Result := TscGPToolPagerTab(inherited GetItem(Index));
end;

procedure TscGPToolPagerTabs.SetItem(Index: Integer; Value:  TscGPToolPagerTab);
begin
  inherited SetItem(Index, Value);
end;


constructor TscGPToolPagerPage.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csNoDesignVisible];
  Color := clBtnFace;
  FDestroyFromPager := False;
  ParentFont := False;
  ParentColor := False;
end;

destructor TscGPToolPagerPage.Destroy;
var
  i, j: Integer;
  B: Boolean;
begin
  if (Pager <> nil) and not FDestroyFromPager
     and not (csLoading in Pager.ComponentState)
     and not (csDestroying in Pager.ComponentState)
     and not (csUpdating in Pager.ComponentState)
     and not (csReading in Pager.ComponentState)
     and not (csWriting in Pager.ComponentState)
  then
    begin
      j := Pager.GetPageIndex(Self);
      if j <> -1
      then
        begin
          Pager.Tabs[j].Page := nil;
          Pager.Tabs.Delete(j);
          if Pager.TabIndex = j
          then
            begin
              B := False;
              if j < Pager.Tabs.Count then
              for i := j to Pager.Tabs.Count - 1 do
              begin
                if (i >= 0) and (i < Pager.Tabs.Count) then
                if Pager.Tabs[i].Visible and Pager.Tabs[i].Enabled
                then
                  begin
                    Pager.FTabIndex := -1;
                    Pager.TabIndex := i;
                    B := True;
                    Break;
                  end;
              end;
              if not B and (j >= 0)
              then
                for i := j downto 0 do
                begin
                  if (i >= 0) and (i < Pager.Tabs.Count) then
                  if Pager.Tabs[i].Visible and Pager.Tabs[i].Enabled
                  then
                    begin
                      Pager.FTabIndex := -1;
                      Pager.TabIndex := i;
                      Break;
                    end;
                end;
            end;
          Pager.FScrollOffset := 0;
          Pager.CalcTabRects;
          Pager.AdjustScrollButtons;
          Pager.ScrollToTab(Pager.TabIndex);
          Pager.RePaintControl;
        end
      else
        begin
          if Pager.TabIndex > Pager.Tabs.Count - 1
          then
            Pager.TabIndex := Pager.Tabs.Count - 1
          else
            Pager.TabIndex := Pager.TabIndex;
          Pager.FScrollOffset := 0;
          Pager.CalcTabRects;
          Pager.AdjustScrollButtons;
          Pager.ScrollToTab(Pager.TabIndex);
          Pager.RePaintControl;
        end;
    end;
  inherited;
end;

procedure TscGPToolPagerPage.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  R: TRect;
begin
  if (Parent <> nil) and (Pager <> nil)
  then
    begin
      R := Pager.GetPageBoundsRect;
      inherited SetBounds(R.Left, R.Top, R.Right, R.Bottom);
    end
  else
    inherited;
end;

constructor TscGPToolPager.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FDragSourceTab := nil;
  FEnableDragReorderTabs := False;
  Color := clBtnFace;
  FStopSetFocus := False;
  FSaveFocusOnActiveControl := False;
  FTabsBGFillColor := clNone;
  FTabsBGFillColorAlpha := 255;
  FTabsScaling := False;
  ParentBackground := False;
  ParentColor := False;

  FScrollButtonArrowColor := clBtnText;
  FScrollButtonArrowThickness := 2;
  FScrollButtonColor := clBtnText;
  FScrollButtonTransparent := False;

  FTabs := TscGPToolPagerTabs.Create(Self);
  FTabOptions := TscGPTabOptions.Create;
  {$IFDEF VER340_UP}
  FTabOptions.FControl := Self;
  {$ENDIF}
  FTabOptions.OnChange := OnControlChange;
  FTabCloseButtonOptions := TscGPTabCloseButtonOptions.Create;
  {$IFDEF VER340_UP}
  FTabCloseButtonOptions.FControl := Self;
  {$ENDIF}
  FTabCloseButtonOptions.OnChange := OnControlChange;
  FFrameWidth := 2;
  FFrameScaleWidth := False;
  FFrameColor := clBtnText;
  FFrameColorAlpha := 80;
  FTabIndex := -1;
  FScrollButtonWidth := 20;
  FCloseButtonSize := TAB_CLOSE_SIZE;
  FBorderStyle := scgpbsFrame;
  FShowInactiveTab := False;
  FTabGlowEffect := TscButtonGlowEffect.Create;
  {$IFDEF VER340_UP}
  FTabGlowEffect.FControl := Self;
  {$ENDIF}
  FTabGlowEffect.States := [scsFocused];
  FTabGlowEffect.OnChange := OnControlChange;
  FMouseWheelSupport := True;
  FShowCloseButtons := False;
  FTabMargin := 10;
  FTabSpacing := 10;
  FFreeOnClose := False;
  FTabHeight := DefPagerTabHeight;
  FTabImages := nil;
  FTransparentBackground := False;

  FMouseIn := False;
  FScrollOffset := 0;
  FLeftOffset := 6;
  FRightOffset := 5;
  Width := 300;
  Height := 150;
  FOldTabActive := -1;
  FTabActive := -1;
  FOldWidth := -1;
  FTabsTopOffset := 0;
  FTabsLeftOffset := 15;
  FTabsRightOffset := 15;
  FLeftScrollButton := nil;
  FRightScrollButton := nil;
  FShowFocusRect := True;
end;

destructor TscGPToolPager.Destroy;
begin
  FTabOptions.Free;
  FTabGlowEffect.Free;
  FTabCloseButtonOptions.Free;
  FTabs.Free;
  FTabs := nil;
  inherited;
end;

procedure TscGPToolPager.ChangeScale(M, D: Integer{$IFDEF VER310_UP}; isDpiChange: Boolean{$ENDIF});
begin
  if FFrameScaleWidth then
    FFrameWidth := MulDiv(FFrameWidth, M, D);

  if (FTabOptions.TabStyle <> gptsShape) or FFrameScaleWidth then
    FTabOptions.FrameWidth := MulDiv(FTabOptions.FrameWidth, M, D);

  FScrollButtonArrowThickness := MulDiv(FScrollButtonArrowThickness, M, D);
  FTabOptions.FShapeCornerRadius := MulDiv(FTabOptions.FShapeCornerRadius, M, D);
  FTabOptions.FLineWidth := MulDiv(FTabOptions.FLineWidth, M, D);
  FCloseButtonSize := MulDiv(FCloseButtonSize, M, D);
  FTabMargin := MulDiv(FTabMargin, M, D);
  FScrollButtonWidth := MulDiv(FScrollButtonWidth, M, D);
  FTabHeight := MulDiv(FTabHeight, M, D);
  FTabsTopOffset := MulDiv(FTabsTopOffset, M, D);
  TabsLeftOffset := MulDiv(FTabsLeftOffset, M, D);
  FTabsRightOffset := MulDiv(FTabsRightOffset, M, D);
  if not (csLoading in ComponentState) then
    FTabsScaling := True;
  inherited;
  SetTimer(Handle, 1, 100, nil);
end;

procedure TscGPToolPager.SetTabsBGFillColor(Value: TColor);
begin
  if FTabsBGFillColor <> Value then
  begin
    FTabsBGFillColor := Value;
    RePaintControl;
    UpdateControls;
  end;
end;

procedure TscGPToolPager.SetTabsBGFillColorAlpha(Value: Byte);
begin
  if FTabsBGFillColorAlpha <> Value then
  begin
    FTabsBGFillColorAlpha := Value;
    RePaintControl;
    UpdateControls;
  end;
end;

procedure TscGPToolPager.UpdateScrollButtons;
begin
  if (FLeftScrollButton <> nil) and FLeftScrollButton.Visible then
  begin
    FLeftScrollButton.UpdateOptions(FScrollButtonColor, FScrollButtonArrowColor,
      FScrollButtonArrowThickness, FScrollButtonTransparent);
    FLeftScrollButton.Repaint;
  end;
  if (FRightScrollButton <> nil) and FRightScrollButton.Visible then
  begin
    FRightScrollButton.UpdateOptions(FScrollButtonColor, FScrollButtonArrowColor,
      FScrollButtonArrowThickness, FScrollButtonTransparent);
    FRightScrollButton.RePaint;
  end;
end;

procedure TscGPToolPager.SetScrollButtonArrowColor(Value: TColor);
begin
  if FScrollButtonArrowColor <> Value then
  begin
    FScrollButtonArrowColor := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPToolPager.SetScrollButtonArrowThickness(Value: Byte);
begin
  if (FScrollButtonArrowThickness <> Value) and (Value >= 1) then
  begin
    FScrollButtonArrowThickness := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPToolPager.SetScrollButtonColor(Value: TColor);
begin
  if FScrollButtonColor <> Value then
  begin
    FScrollButtonColor := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPToolPager.SetScrollButtonTransparent(Value: Boolean);
begin
  if FScrollButtonTransparent <> Value then
  begin
    FScrollButtonTransparent := Value;
    UpdateScrollButtons;
  end;
end;

procedure TscGPToolPager.SetScrollButtonWidth(Value: Integer);
begin
  if (Value >= 20) and (FScrollButtonWidth <> Value) then
  begin
    FScrollButtonWidth := Value;
    GetScrollInfo;
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.DoClose;
var
  FPage: TscGPToolPagerPage;
  CanClose: Boolean;
  P: TPoint;
  PIndex: Integer;
begin
  FPage := FActivePage;
  if FPage = nil then Exit;
  CanClose := True;
  if Assigned(FOnClose) then FOnClose(FPage, CanClose);
  if CanClose then
  begin
    PIndex := GetPageIndex(FPage);
    FScrollOffset := 0;
    FTabs[PIndex].Visible := False;
    if FFreeOnClose then
    begin
      FTabs[PIndex].Page.FDestroyFromPager := True;
      FTabs.Delete(PIndex);
      if FTabs.Count = 0 then
      begin
        FActivePage := nil;
        FTabIndex := -1;
        FTabActive := -1;
      end;
    end;
  end;
  if CanClose = False then
  begin
    GetCursorPos(P);
    if (WinApi.Windows.WindowFromPoint(P) <> Self.Handle) and (FTabActive <> -1) then
    begin
      FTabs[FTabActive].CloseButtonMouseIn := False;
      FTabs[FTabActive].CloseButtonMouseDown := False;
      RePaintControl;
    end;
  end;
end;

procedure TscGPToolPager.DrawCloseButton(ACanvas: TCanvas;
  G: TGPGraphics;
  ARect: TRect; AIndex: Integer;  AColor: TColor);
var
  X, Y: Integer;
  ButtonR: TRect;
  GlyphColor, FillColor: Cardinal;
  R: TGPRectF;
  B: TGPSolidBrush;
begin
  X := ARect.Left + ARect.Width div 2 - FCloseButtonSize div 2;
  Y := ARect.Top + ARect.Height div 2 - FCloseButtonSize div 2 + FFrameWidth;
  ButtonR := Rect(X, Y, X + FCloseButtonSize, Y + FCloseButtonSize);
  R := RectToGPRect(ButtonR);
  Tabs[AIndex].CloseButtonRect := ButtonR;

  if not Tabs[AIndex].Enabled then
    FTabCloseButtonOptions.State := scsDisabled
  else
  if Tabs[AIndex].CloseButtonMouseDown then
    FTabCloseButtonOptions.State := scsPressed
  else
  if Tabs[AIndex].CloseButtonMouseIn then
    FTabCloseButtonOptions.State := scsHot
  else
    FTabCloseButtonOptions.State := scsNormal;

  if FTabCloseButtonOptions.ColorAlpha <> 0 then
  begin
    FillColor := ColorToGPColor(FTabCloseButtonOptions.Color, FTabCloseButtonOptions.ColorAlpha);
    B := TGPSolidBrush.Create(FillColor);
    case FTabCloseButtonOptions.ShapeKind of
      scgptcbRounded:
        G.FillEllipse(B, R);
      scgptcbRect:
        G.FillRectangle(B, R);
    end;
    B.Free;
  end;

  GlyphColor := ColorToGPColor(FTabCloseButtonOptions.GlyphColor, FTabCloseButtonOptions.GlyphColorAlpha);

  InflateGPRect(R, -FCloseButtonSize div 4, -FCloseButtonSize div 4);
  scGPUtils.GPDrawClearGlyph
    (G, R, GlyphColor, FScaleFactor, 2);
end;

procedure TscGPToolPager.SetShowCloseButtons(Value: Boolean);
begin
  if FShowCloseButtons <> Value then
  begin
    FShowCloseButtons := Value;
    GetScrollInfo;
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.SetFrameWidth(Value: Integer);
begin
  if Value <> FFrameWidth then
  begin
    FFrameWidth := Value;
    RePaintControl;
    if FActivePage <> nil then
      FActivePage.SetBounds(FActivePage.Left, FActivePage.Top,
        FActivePage.Width, FActivePage.Height);
  end;
end;

procedure TscGPToolPager.SetFrameColor(Value: TColor);
begin
  if Value <> FFrameColor then
  begin
    FFrameColor := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.SetFrameColorAlpha(Value: Byte);
begin
  if Value <> FFrameColorAlpha then
  begin
    FFrameColorAlpha := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.SetTabsTopOffset(Value: Integer);
begin
  if Value <> FTabsTopOffset then
  begin
    FTabsTopOffset := Value;
    RePaintControl;
    if FActivePage <> nil then
      FActivePage.SetBounds(FActivePage.Left, FActivePage.Top,
        FActivePage.Width, FActivePage.Height);
  end;
end;

procedure TscGPToolPager.SetBorderStyle(Value: TscGPTabControlBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RePaintControl;
    if FActivePage <> nil then
      FActivePage.SetBounds(FActivePage.Left, FActivePage.Top,
        FActivePage.Width, FActivePage.Height);
  end;
end;

procedure TscGPToolPager.UpdateControls;
var
  I: Integer;
begin
  if FFullUpdating then
    inherited
  else
    for I := 0 to ControlCount - 1 do
    begin
      if (Controls[i] is TWinControl) and not (Controls[i] is TscGPToolPagerPage)
      then
        SendMessage(TWinControl(Controls[I]).Handle, WM_CHECKPARENTBG, 0, 0)
      else
      if Controls[i] is TGraphicControl
       then
         TGraphicControl(Controls[I]).Perform(WM_CHECKPARENTBG, 0, 0);
    end;
end;

procedure TscGPToolPager.SetTabsLeftOffset(Value: Integer);
begin
  if (Value <> FTabsLeftOffset) and (Value >= 0) then
  begin
    FTabsLeftOffset := Value;
    RePaintControl;
    AdjustScrollButtons;
    ScrollToTab(FTabIndex);
  end;
end;

procedure TscGPToolPager.SetShowInActiveTab(Value: Boolean);
begin
  if Value <> FShowInActiveTab then
  begin
    FShowInActiveTab := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.SetTabsRightOffset(Value: Integer);
begin
  if (Value <> FTabsRightOffset) and (Value >= 0) then
  begin
    FTabsRightOffset := Value;
    RePaintControl;
    AdjustScrollButtons;
    ScrollToTab(FTabIndex);
  end;
end;

procedure TscGPToolPager.OnControlChange(Sender: TObject);
begin
  RePaintControl;
end;

procedure TscGPToolPager.SetShowFocusRect(Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.Draw(ACanvas: TCanvas; ACtrlState: TscsCtrlState);
var
  FFirst: Boolean;
  FFirstVisible: Boolean;
  I: Integer;
  SaveIndex: Integer;
  G: TGPGraphics;
  P: TGPPen;
  C: Cardinal;
  R, R1: TGPRectF;
  W: Integer;
  B: TGPSolidBrush;
  FScrollBWidth: Integer;
begin
  FTabsRect := Rect(0, 0, Width, FTabHeight + FTabsTopOffset);
  FPageRect := Rect(0, FTabHeight + FTabsTopOffset, Width, Height);

  // draw background
  if not FTransparentBackground then
    with ACanvas do
    begin
      if seClient in StyleElements then
        Brush.Color := GetStyleColor(Color{$IFDEF VER340_UP}, Self{$ENDIF})
      else
        Brush.Color := Color;
      FillRect(FPageRect);
      if seClient in StyleElements then
        Brush.Color := GetStyleColor(Color{$IFDEF VER340_UP}, Self{$ENDIF})
      else
        Brush.Color := Color;
      FillRect(FTabsRect);
    end;

  // draw border
  G := TGPGraphics.Create(ACanvas.Handle);

  G.SetSmoothingMode(SmoothingModeHighQuality);
  G.SetPixelOffsetMode(PixelOffsetModeHalf);

  if (FTabsBGFillColor <> clNone) and (FTabsBGFillColorAlpha > 0) then
  begin
    C := ColorToGPColor(GetStyleCOlor(FTabsBGFillColor{$IFDEF VER340_UP}, Self{$ENDIF}), FTabsBGFillColorAlpha);
    B := TGPSolidBrush.Create(C);
    R := RectToGPRect(FTabsRect);
    G.FillRectangle(B, R);
    B.Free;
  end;

  if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and (FTabs[FTabIndex].CustomFrameColor <> clNone) then
    C := ColorToGPColor(GetStyleColor(FTabs[FTabIndex].CustomFrameColor{$IFDEF VER340_UP}, Self{$ENDIF}), FTabs[FTabIndex].CustomFrameColorAlpha)
  else
    C := ColorToGPColor(GetStyleColor(FFrameColor{$IFDEF VER340_UP}, Self{$ENDIF}), FFrameColorAlpha);

  P := TGPPen.Create(C, FFrameWidth);

  if not FGetControlBG then
    CalcTabRects;

  if (FBorderStyle <> scgpbsNone) and not FGetControlBG and (FFrameWidth > 0) then
  begin
    if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and FTabs[FTabIndex].Visible then
    begin
      if FScrollVisible then
        W := FTabsLeftOffset + FScrollButtonWidth
      else
        W := FTabsLeftOffset;
      R1 := RectToGPRect(FTabs[FTabIndex].TabRect);
      if FBorderStyle <> scgpbsNone then
        R1.Height := R1.Height + FFrameWidth;
      if R1.X < W then
      begin
        R1.Width := R1.Width - (W - R1.X);
        R1.X := W;
      end;

      if FScrollVisible then
        W := FTabsRightOffset + FScrollButtonWidth
      else
        W := FTabsRightOffset;

      if R1.X + R1.Width > Width - W then
      begin
        R1.Width := R1.Width - (R1.X + R1.Width - (Width - W));
      end;
      if (R1.Width > 0) and (R1.X <= Width - W) then
        G.ExcludeClip(R1);
    end;
    R := RectToGPRect(FPageRect);
    InflateGPRect(R, -FFrameWidth / 2, -FFrameWidth / 2);
   if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
    begin
      R.X := 0;
      R.Width := Width;
    end;
    if FBorderStyle = scgpbsFrame then
      G.DrawRectangle(P, R)
    else
    if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
    begin
      G.DrawLine(P, R.X, R.Y, R.X + R.Width, R.Y);
      if FBorderStyle = scgpbsLineTopBottom then
        G.DrawLine(P, R.X, R.Y + R.Height, R.X + R.Width, R.Y + R.Height);
    end;
    if (FTabIndex <> -1) and (FTabIndex < FTabs.Count) and FTabs[FTabIndex].Visible and (R1.Width > 0) and (R1.X <= Width - FTabsRightOffset) then
      G.ResetClip;
  end
  else
  if not FGetControlBG and (FBorderStyle = scgpbsNone) then
  begin
    C := ColorToGPColor(clBlack, 0);
    P.SetColor(C);
    G.DrawLine(P, 0, 0, 1, 1);
  end;

  // draw items

  if Tabs.Count = 0 then
  begin
    G.Free;
    P.Free;
    Exit;
  end;


  FTabIndexBeforeFocused := FindDrawPriorTabFromIndex(FTabIndex);
  FTabIndexAfterFocused := FindDrawNextTabFromIndex(FTabIndex);

  SaveIndex := SaveDC(ACanvas.Handle);
  try
    if not FGetControlBG then
    begin
      if (FLeftScrollButton <> nil) and FLeftScrollButton.Visible then
        FScrollBWidth := FScrollButtonWidth
      else
        FScrollBWidth := 0;
      IntersectClipRect(ACanvas.Handle,
        FTabsLeftOffset + FScrollBWidth, FTabsTopOffset, Width - FTabsRightOffset - FScrollBWidth, FTabsTopOffset + FTabHeight + 2);

      FFirstVisible := False;
      for I := 0 to FTabs.Count - 1  do
      begin
        if FTabs[I].Visible then
        begin
          FFirst := (FTabsLeftOffset = 0) and (FTabs[I].TabRect.Left = 0);
          if not FFirstVisible and (I = FTabIndex) and not FTabs[I].Enabled then
          begin
            FFirst := True;
            FFirstVisible := True;
          end
          else
          if not FFirstVisible and (I <> FTabIndex) then
          begin
            FFirst := True;
            FFirstVisible := True;
          end
          else
          if not FShowInActiveTab then
            FFirst := (I <> FTabIndex);
          if (I = TabIndex) and FTabs[I].Enabled then
            FFirstVisible := True;
          DrawTab(ACanvas, G, I, FFirst);
        end;
      end;
    end;
  finally
    RestoreDC(ACanvas.Handle, SaveIndex);
  end;

  G.Free;
  P.Free;
end;

procedure TscGPToolPager.SetTabImages(Value: TCustomImageList);
begin
  if FTabImages <> Value then
  begin
    FTabImages := Value;
    UpdateTabs;
  end;
end;

procedure TscGPToolPager.SetTabHeight;
var
  I: Integer;
  R: TRect;
begin
  if FTabHeight <> Value then
  begin
    FTabHeight := Value;
    R := GetPageBoundsRect;
    for I := 0 to ControlCount - 1 do
      if Controls[I] is TscGPToolPagerPage then
      Controls[I].SetBounds(R.Left, R.Top, R.Right, R.Bottom);
    RePaintControl;
    AdjustScrollButtons;
  end;
end;

procedure TscGPToolPager.SetTabMargin(Value: Integer);
begin
  if (Value > 0) and (FTabMargin <> Value) then
  begin
    FTabMargin := Value;
    UpdateTabs;
  end;
end;

procedure TscGPToolPager.SetTabSpacing(Value: Integer);
begin
  if (Value > 0) and (FTabSpacing <> Value) then
  begin
    FTabSpacing := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.SetTabIndex;
var
  LPage: TscGPToolPagerPage;
  LPrevTabIndex: Integer;
  B: Boolean;
  LForm: TCustomForm;
begin
  if Value = -1 then
  begin
    FTabIndex := Value;
    if not (csLoading in ComponentState) then
      RePaintControl;
    Exit;
  end;

  if (Value < 0) or (Value > Tabs.Count - 1) then
    Exit;

  if Assigned(FOnCanChangePage) and not (csLoading in ComponentState) then
  begin
    B := True;
    FOnCanChangePage(Value, B);
    if not B then Exit;
  end;

  if (FTabIndex <> Value) and (Value >= 0) and (Value < Tabs.Count) and
     not (csDesigning in ComponentState) and
     not (csLoading in ComponentState) then
  begin
    LForm := GetParentForm(Self);
    if (LForm <> nil) and (FActivePage <> nil) and (LForm.ActiveControl <> nil)
       and FActivePage.ContainsControl(LForm.ActiveControl) then
    begin
      LForm.ActiveControl := nil;
      if LForm.ActiveControl <> nil then
      begin
        FStopSetFocus := True;
        Exit;
      end;
    end;
  end;

  if not Tabs[Value].FVisible then Tabs[Value].FVisible := True;

  if (FTabIndex <> Value) and (Value >= 0) and (Value < Tabs.Count)
  then
    begin
      LPrevTabIndex := FTabIndex;
      FTabIndex := Value;
      if not (csLoading in ComponentState) then
        if Assigned(FOnChangingPage) then FOnChangingPage(Self);
      if (FTabIndex > -1) and (FTabs[FTabIndex].Page <> nil)
      then
        begin
          LPage := FTabs[FTabIndex].Page;
          LPage.Parent := Self;
          LPage.SetBounds(LPage.Left, LPage.Top, LPage.Width, LPage.Height);
          LPage.Visible := True;
          LPage.BringToFront;
          FActivePage := LPage;
          if FScrollVisible then
            ScrollToTab(FTabIndex);
        end;
      if (LPrevTabIndex > -1) and (FTabs.Count > LPrevTabIndex) and
         (FTabs[LPrevTabIndex].Page <> nil) and
         (FTabs[LPrevTabIndex].Page <> nil)
      then
        FTabs[LPrevTabIndex].Page.Visible := False;
      if not (csLoading in ComponentState) then
        if Assigned(FOnChangePage) then FOnChangePage(Self);
    end
  else
    begin
      if Tabs[Value].FPage <> nil
      then
      begin
        if not Tabs[Value].FPage.Visible then
          Tabs[Value].FPage.Visible := True;
        FActivePage := Tabs[Value].FPage;
      end;
    end;
  RePaintControl;
end;

function TscGPToolPager.TabFromPoint;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Tabs.Count -1 do
    if Tabs[i].Visible and PtInRect(Tabs[i].TabRect, P)
    then
      begin
        Result := i;
        Break;
      end;
end;

procedure TscGPToolPager.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateTabs;
end;

procedure TscGPToolPager.CMDesignHitTest;
var
  P: TPoint;
  I: Integer;
  F: TCustomForm;
begin
  inherited;
  P := SmallPointToPoint(Message.Pos);
  if (Message.Keys = MK_LBUTTON) and (TabFromPoint(P) <> -1)
  then
    begin
      I := TabFromPoint(P);
      if Tabs[I].Page <> nil then ActivePage := Tabs[I].Page;
      F := GetParentForm(Self);
      if F <> nil then
        F.Designer.Modified;
    end;
end;

procedure TscGPToolPager.SetTransparentBackground(Value: Boolean);
begin
  if FTransparentBackground <> Value then
  begin
    FTransparentBackground := Value;
    GetParentBG;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
    with Params.WindowClass do
      Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TscGPToolPager.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FActivePage) then
    FActivePage := nil;
  if (Operation = opRemove) and (AComponent = FTabImages) then
    FTabImages := nil;
end;

function TscGPToolPager.FindNextTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPToolPager.FindPriorTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPToolPager.FindDrawNextTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;


  j := AIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

function TscGPToolPager.FindDrawPriorTabFromIndex(AIndex: Integer): Integer;
var
  i, j, k: Integer;
begin
  Result := -1;

  if Tabs.Count = 0 then
    Exit;

  j := AIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then Result := k;
end;

procedure TscGPToolPager.FindNextTab;
var
  i, j, k: Integer;
begin
  j := TabIndex;
  if (j = -1) or (j = Tabs.Count - 1) then Exit;
  k := -1;
  for i := j + 1 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPToolPager.FindPriorTab;
var
  i, j, k: Integer;
begin
  j := TabIndex;
  if (j = -1) or (j = 0) then Exit;
  k := -1;
  for i := j - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPToolPager.FindFirstTab;
var
  i, k: Integer;
begin
  k := -1;
  for i := 0 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPToolPager.FindLastTab;
var
  i, k: Integer;
begin
  k := -1;
  for i := Tabs.Count - 1 downto 0 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled
    then
      begin
        k := i;
        Break;
      end;
  end;
  if k <> -1 then TabIndex := k;
end;

procedure TscGPToolPager.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if Message.TimerID = 1 then
  begin
    FTabsScaling := False;
    UpdateTabs;
    KillTimer(Handle, 1);
  end;
end;

procedure TscGPToolPager.WMMOUSEWHEEL(var Message: TWMMOUSEWHEEL);
begin
  if FMouseWheelSupport then
    if BidiMode <> bdRightToLeft then
     begin
       if Message.WheelDelta < 0 then FindNextTab else FindPriorTab;
     end
     else
     begin
       if Message.WheelDelta > 0 then FindNextTab else FindPriorTab;
     end;
end;

procedure TscGPToolPager.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_SPACE)
  then
    begin
      if (FTabIndex >= 0) and (FTabIndex < Tabs.Count) then
      begin
        if Assigned(FTabs[FTabIndex].OnClick) then
          FTabs[FTabIndex].OnClick(Self);
      end;
    end
  else
  if BidiMode <> bdRightToLeft then
  begin
    if (Key = VK_NEXT)
    then
      FindLastTab
    else
    if (Key = VK_PRIOR)
    then
      FindFirstTab
    else
    if (Key = VK_LEFT) or (Key = VK_UP)
    then
      FindPriorTab
    else
    if (Key = VK_RIGHT) or (Key = VK_DOWN)
    then
      FindNextTab;
  end
  else
  begin
    if (Key = VK_NEXT)
    then
      FindFirstTab
    else
    if (Key = VK_PRIOR)
    then
      FindLastTab
    else
    if (Key = VK_LEFT) or (Key = VK_UP)
    then
      FindNextTab
    else
    if (Key = VK_RIGHT) or (Key = VK_DOWN)
    then
      FindPriorTab;
  end;
end;

procedure TscGPToolPager.WMGetDlgCode;
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TscGPToolPager.WMSETFOCUS;
begin
  inherited;
  if not (csLoading in ComponentState) then
    if not FTransparentBackground then
      RePaintControl
    else
    begin
      FUpdateParentBuffer := True;
      if DrawTextMode = scdtmGDIPlus then
       Invalidate
     else
       RePaint;
    end;
end;

procedure TscGPToolPager.WMKILLFOCUS;
begin
  inherited;
  if not (csLoading in ComponentState) then
    RePaintControl;
end;

procedure TscGPToolPager.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  TestActive(X, Y);
end;

procedure TscGPToolPager.DragDrop(Source: TObject; X, Y: Integer);
var
  Index: Integer;
begin
  inherited;
  if (Source = Self) and (FDragSourceTab <> nil) then
  begin
    Index := TabFromPoint(Point(X, Y));
    if (Index <> -1) and (Index <> FDragSourceTab.Index) then
    begin
      FDragSourceTab.Index := Index;
      TabIndex := Index;
      Abort;
    end;
  end;
  FDragSourceTab := nil;
end;

procedure TscGPToolPager.DragOver(Source: TObject; X, Y: Integer; State: TDragState;
    var Accept: Boolean);
begin
  inherited;
  Accept := (Source <> nil) and (Source = Self) and (FDragSourceTab <> nil);
end;

procedure TscGPToolPager.MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer);
var
  WasFocused: Boolean;
begin
  inherited;
  if Button <> mbLeft then Exit;
  TestActive(X, Y);

  WasFocused := Focused;
  FStopSetFocus := False;

  if (FTabActive <> TabIndex) and (FTabActive <> -1) then
    TabIndex := FTabActive;

  if not FStopSetFocus then
    FStopSetFocus := FSaveFocusOnActiveControl;


  if not WasFocused and not FStopSetFocus then
    SetFocus;

  FStopSetFocus := False;
  FSaveFocusOnActiveControl := False;

  if (FTabs.Count > 0) and (FTabActive <> -1) and (FTabActive < FTabs.Count) and FShowCloseButtons and FTabs[FTabActive].ShowCloseButton and
    not (csDesigning in ComponentState)
  then
    with FTabs[FTabActive] do
    begin
      if PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := True;
        CloseButtonMouseDown := True;
        RePaintControl;
      end
      else
      if not PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := False;
        CloseButtonMouseDown := False;
      end;
   end;

  if (FTabs.Count > 0) and FEnableDragReorderTabs and (Button = mbLeft) and (FTabActive <> -1) then
  begin
    FDragSourceTab := Tabs[FTabActive];
    if not FDragSourceTab.CloseButtonMouseIn and DragDetect(Handle, Mouse.CursorPos) then
      BeginDrag(False, 3)
    else
      FDragSourceTab := nil;
  end
  else
    FDragSourceTab := nil;
end;

procedure TscGPToolPager.MouseUp(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer);
begin
  inherited;
  if Button <> mbLeft then Exit;

  if PtInRect(FTabsRect, Point(X, Y)) and Assigned(FOnTabsAreaClick) then
    FOnTabsAreaClick(Self);

  TestActive(X, Y);
  if (FTabIndex >= 0) and (FTabIndex < Tabs.Count) and (FTabIndex = FTabActive) then
  begin
    if Assigned(FTabs[FTabIndex].OnClick) then
        FTabs[FTabIndex].OnClick(Self);
  end;

  if (FTabs.Count > 0) and (FTabActive <> -1) and FShowCloseButtons and FTabs[FTabActive].ShowCloseButton
     and not (csDesigning in ComponentState)
  then
    with FTabs[FTabActive] do
    begin
      if PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := True;
        CloseButtonMouseDown := False;
        RePaintControl;
        DoClose;
      end
      else
      if not PtInRect(CloseButtonRect, Point(X, Y)) then
      begin
        CloseButtonMouseIn := False;
        CloseButtonMouseDown := False;
      end;
   end;
end;

procedure TscGPToolPager.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  TestActive(-1, -1);
end;

procedure TscGPToolPager.TestActive(X, Y: Integer);
var
  i: Integer;
begin
  if Tabs.Count = 0 then Exit;

  FOldTabActive:= FTabActive;
  FTabActive := -1;

  for i := 0 to Tabs.Count - 1 do
  begin
    if Tabs[i].Visible and Tabs[i].Enabled and PtInRect(Tabs[i].TabRect, Point(X, Y)) and
       (X >= FTabsLeftOffset) and (X < Width - FTabsRightOffset)
    then
      begin
        FTabActive := i;
        Break;
      end;
  end;

  if (FTabActive <> FOldTabActive)
  then
    begin
      if (FOldTabActive <> - 1) and (FOldTabActive < Tabs.Count)
      then
      begin
        Tabs[FOldTabActive].Active := False;
        Tabs[FOldTabActive].CloseButtonMouseIn := False;
        Tabs[FOldTabActive].CloseButtonMouseDown := False;
      end;
      if (FTabActive <> - 1)
      then
        Tabs[FTabActive].Active := True;
      RePaintControl;
    end;

  if (FTabActive <> -1) and FShowCloseButtons and Tabs[FTabActive].ShowCloseButton then
  with Tabs[FTabActive] do
  begin
    if PtInRect(CloseButtonRect, Point(X, Y)) and not CloseButtonMouseIn then
    begin
      CloseButtonMouseIn := True;
      RePaintControl;
    end
    else
    if not PtInRect(CloseButtonRect, Point(X, Y)) and CloseButtonMouseIn then
    begin
      CloseButtonMouseIn := False;
      CloseButtonMouseDown := False;
      RePaintControl;
    end;
  end;

end;

procedure TscGPToolPager.ScrollToTab(AIndex: Integer);
var
  R: TRect;
  Offset, SW: Integer;
begin
  if (AIndex < 0) or (AIndex > Tabs.Count - 1) then Exit;

  R := Tabs[AIndex].TabRect;
  if FScrollVisible then
    SW := FScrollButtonWidth
  else
    SW := 0;
  if R.Left < FTabsLeftOffset + SW then
  begin
    Offset := Abs(FTabsLeftOffset - R.Left);
    Inc(Offset, SW);

    if BidiMode <> bdRightToLeft then
      FScrollOffset := FScrollOffset - Offset
    else
      FScrollOffset := FScrollOffset + Offset;


    if FScrollOffset < 0 then FScrollOffset := 0;
    RePaintControl;
  end
  else
  if R.Right > Width - FTabsRightOffset - SW then
  begin
    Offset := R.Right - (Width - FTabsRightOffset);
    Inc(Offset, SW);

    if BidiMode <> bdRightToLeft then
      FScrollOffset := FScrollOffset + Offset
    else
      FScrollOffset := FScrollOffset - Offset;

    if FScrollOffset < 0 then FScrollOffset := 0;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.ScrollToLeft;
begin
  CalcTabRects;
  if FLeftTabIndex >= 0 then
    ScrollToTab(FLeftTabIndex);
end;

procedure TscGPToolPager.ScrollToRight;
begin
  CalcTabRects;
  if FRightTabIndex >= 0 then
    ScrollToTab(FRightTabIndex);
end;

procedure TscGPToolPager.OnLeftScrollButtonClick(Sender: TObject);
begin
  ScrollToLeft;
end;

procedure TscGPToolPager.OnRightScrollButtonClick(Sender: TObject);
begin
  ScrollToRight;
end;

procedure TscGPToolPager.ShowScrollButtons;
var
  B: Boolean;
begin
  B := False;
  if FLeftScrollButton = nil then
  begin
    FLeftScrollButton := TscGPTabScrollButton.CreateEx(Self,
      FScrollButtonColor, FScrollButtonArrowColor, FScrollButtonArrowThickness, FScrollButtonTransparent);
    FLeftScrollButton.OnClick := OnLeftScrollButtonClick;
    FLeftScrollButton.Visible := False;
    FLeftScrollButton.RepeatClick := True;
    FLeftScrollButton.CanFocused := False;
    FLeftScrollButton.GlyphOptions.Kind := scgpbgkLeftArrow;

    FLeftScrollButton.Parent := Self;
    FLeftScrollButton.SetBounds(FTabsLeftOffset, FTabsTopOffset,
      FScrollButtonWidth, FTabHeight);

    FLeftScrollButton.Visible := True;
    B := True;
  end
  else
    FLeftScrollButton.SetBounds(FTabsLeftOffset, FTabsTopOffset,
      FScrollButtonWidth, FTabHeight);
  if FRightScrollButton = nil then
  begin
    FRightScrollButton := TscGPTabScrollButton.CreateEx(Self,
      FScrollButtonColor, FScrollButtonArrowColor, FScrollButtonArrowThickness, FScrollButtonTransparent);
    FRightScrollButton.Visible := False;
    FRightScrollButton.FRight := True;
    FRightScrollButton.OnClick := OnRightScrollButtonClick;
    FRightScrollButton.RepeatClick := True;
    FRightScrollButton.CanFocused := False;
    FRightScrollButton.GlyphOptions.Kind := scgpbgkRightArrow;
    FRightScrollButton.Parent := Self;
    FRightScrollButton.SetBounds(Width - FTabsRightOffset - FScrollButtonWidth,
      FTabsTopOffset, FScrollButtonWidth, FTabHeight);
    FRightScrollButton.Visible := True;
    B := True;
  end
  else
    FRightScrollButton.SetBounds(Width - FTabsRightOffset - FScrollButtonWidth,
      FTabsTopOffset, FScrollButtonWidth, FTabHeight);

  if B and not(csLoading in ComponentState) then
    RePaintControl;
end;

procedure TscGPToolPager.HideScrollButtons;
begin
  if FLeftScrollButton <> nil then
  begin
    FLeftScrollButton.Visible := False;
    FLeftScrollButton.Free;
    FLeftScrollButton := nil;
  end;
  if FRightScrollButton <> nil then
  begin
    FRightScrollButton.Visible := False;
    FRightScrollButton.Free;
    FRightScrollButton := nil;
  end;
end;

procedure TscGPToolPager.AdjustScrollButtons;
begin
  if FTabsScaling then
    Exit;

  if FScrollVisible then
    ShowScrollButtons
  else
    HideScrollButtons;
end;

procedure TscGPToolPager.GetScrollInfo;
var
  I, X: Integer;
begin
  X := FTabsLeftOffset;
  for I := 0 to Tabs.Count - 1 do
    if Tabs[I].Visible then
    begin
      X := X + GetTabWidth(I);
    end;
  FScrollVisible := X > Width - FTabsRightOffset;
end;

function TscGPToolPager.GetTabWidth(AIndex: Integer): Integer;
var
  R: TRect;
  IIndex: Integer;
  IImages: TCustomImageList;
begin
  Result := FTabMargin * 2;
  if Result < 10 then Result := 10;
  R := Rect(0, 0, 0, 0);
  if Assigned(FOnGetTabDrawParams) then
  begin
    Canvas.Font := Self.Font;
    FOnGetTabDrawParams(AIndex, scsNormal, Canvas);
  end;
  DrawText(Canvas.Handle, PChar(Tabs[AIndex].Caption),
   Length(Tabs[AIndex].Caption), R,
   DT_LEFT or DT_CALCRECT);
  Result := Result + R.Width;

  IIndex := Tabs[AIndex].ImageIndex;
  IImages := FTabImages;

  if Assigned(FOnGetTabImage) then
    FOnGetTabImage(AIndex, IImages, IIndex);

  if (IImages <> nil) and (IIndex >= 0) and (IIndex < IImages.Count) then
    Result := Result + FTabSpacing + IImages.Width;

  if FShowCloseButtons and Tabs[AIndex].ShowCloseButton then
    Inc(Result, FCloseButtonSize + 6);
end;

procedure TscGPToolPager.UpdateTabs;
begin
  if not (csLoading in ComponentState) and
     not (csDestroying in ComponentState) then
  begin
    FScrollOffset := 0;
    CalcTabRects;
    GetScrollInfo;
    ScrollToTab(FTabIndex);
    AdjustScrollButtons;
    RePaintControl;
  end;
end;

procedure TscGPToolPager.CalcTabRects;
var
  I, X, Y, W, ScrollW: Integer;
begin
  GetScrollInfo;

  if BidiMode <> bdRightToLeft then
  begin
    X := FTabsLeftOffset - FScrollOffset;
    if FScrollVisible then
      Inc(X, FScrollButtonWidth);
  end
  else
  begin
    X := Width - FTabsRightOffset + FScrollOffset;
    if FScrollVisible then
      Dec(X, FScrollButtonWidth);
  end;

  Y := FTabsTopOffset;
  Canvas.Font := Self.Font;
  FLeftTabIndex := -1;
  FRightTabIndex := -1;
  if FScrollVisible then
    ScrollW := FScrollButtonWidth
  else
    ScrollW := 0;

  for I := 0 to Tabs.Count - 1 do
    if Tabs[I].Visible then
    begin
      W := GetTabWidth(I);
      if BidiMode <> bdRightToLeft then
      begin
        Tabs[I].TabRect := Rect(X, Y, X + W, Y + FTabHeight);
        X := X + W;
        if Tabs[I].TabRect.Left < FTabsLeftOffset + ScrollW
        then
          FLeftTabIndex := I;
        if (Tabs[I].TabRect.Right > Width - FTabsRightOffset - ScrollW) and
           (FRightTabIndex = -1)
        then
          FRightTabIndex := I;
       end
      else
      begin
        Tabs[I].TabRect := Rect(X - W, Y, X, Y + FTabHeight);
        X := X - W;
        if (Tabs[I].TabRect.Left < FTabsLeftOffset + ScrollW) and
           (FLeftTabIndex = -1)
        then
          FLeftTabIndex := I;
        if Tabs[I].TabRect.Right > Width - FTabsRightOffset - ScrollW
        then
          FRightTabIndex := I;
      end;
    end;
end;

procedure TscGPToolPager.SetTabs(AValue: TscGPToolPagerTabs);
begin
  FTabs.Assign(AValue);
  RePaintControl;
end;

procedure TscGPToolPager.SetActivePage(const Value: TscGPToolPagerPage);
var
  i: Integer;
begin
  if Value <> nil then
  begin
    i := GetPageIndex(Value);
    if (i <> -1) and not (Tabs[i].FVisible) then Tabs[i].FVisible := True;
    TabIndex := i;
  end
  else
   begin
    if FActivePage <> nil then
    begin
      FActivePage.Visible := False;
      TabIndex := -1;
    end;
  end;
end;

function TscGPToolPager.GetPageIndex(Value: TscGPToolPagerPage): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Tabs.Count - 1 do
    if Tabs[i].Page = Value
    then
       begin
         Result := i;
         Break;
       end;
end;

procedure TscGPToolPager.Loaded;
var
  i: Integer;
begin
  inherited;
  if Tabs.Count > 0 then
    for i := 0 to Tabs.Count - 1 do
    if Tabs[i].Page <> nil then
    begin
      Tabs[i].Page.Pager := Self;
      Tabs[i].Page.Visible := Tabs[i].Page = FActivePage;
    end;

  CalcTabRects;
  GetScrollInfo;
  AdjustScrollButtons;
  ScrollToTab(FTabIndex);

  if FActivePage <> nil then
    FActivePage.SetBounds(FActivePage.Left, FActivePage.Top,
      FActivePage.Width, FActivePage.Height);
end;

function TscGPToolPager.GetPageBoundsRect: TRect;
begin
  Result.Left := 0;
  Result.Top := FTabHeight + FTabsTopOffset;
  Result.Bottom := Height - FTabHeight - FTabsTopOffset;
  Result.Right := Width;
  if (FBorderStyle = scgpbsLine) or (FBorderStyle = scgpbsLineTopBottom) then
  begin
    Inc(Result.Top, FFrameWidth);
    Dec(Result.Bottom, FFrameWidth);
    if FBorderStyle = scgpbsLineTopBottom then
      Dec(Result.Bottom, FFrameWidth);
  end
  else
  if FBorderStyle = scgpbsFrame then
  begin
    Inc(Result.Top, FFrameWidth);
    Inc(Result.Left, FFrameWidth);
    Dec(Result.Bottom, FFrameWidth * 2);
    Dec(Result.Right, FFrameWidth * 2);
  end
end;

procedure TscGPToolPager.WMSIZE(var Message: TWMSIZE);
var
  B: Boolean;
begin
  B := FScrollVisible;

  inherited;

  if (FOldWidth <> Width) and (FOldWidth <> -1)
  then
    begin
      GetScrollInfo;
      AdjustScrollButtons;
      if FScrollOffset > 0
      then
        FScrollOffset := FScrollOffset - (Width - FOldWidth);
      if FScrollOffset < 0 then FScrollOffset := 0;
    end;

  if (ActivePage <> nil) and (Tabs.Count > 0)
  then
    with ActivePage do
    begin
      SetBounds(Left, Top, Width, Height);
    end;

  FOldWidth := Width;

  if B <> FScrollVisible then
  begin
    FScrollOffset := 0;
    ScrollToTab(FTabIndex);
  end;

  RePaintControl;
end;

procedure TscGPToolPager.DrawTab(ACanvas: TCanvas; G: TGPGraphics; Index: Integer; AFirst: Boolean);
const
  GlyphLayout: array[Boolean] of TButtonLayout = (blGlyphLeft, blGlyphRight);
var
  FC: TColor;
  TabState: TscsCtrlState;
  R, R1: TRect;
  IIndex, TX, TY: Integer;
  IImages: TCustomImageList;

  FGlowColor: TColor;
  FillR, FrameR, GPR, TabR: TGPRectF;
  TabFillC, TabFrameC, C1, C2: Cardinal;
  FramePath, FillPath: TGPGraphicsPath;
  P: TGPPen;
  l, t, w, d: Single;
  B, LB: TGPBrush;
  SW: Integer;
  FOptions: TscGPTabOptions;
  FGlowEffect: TscButtonGlowEffect;
begin

  R := FTabs[Index].TabRect;

  if Index = FTabIndex then
    Inc(R.Bottom, FFrameWidth);

  TabR := RectToGPRect(R);

  if FLeftScrollButton <> nil then
     SW := FTabsLeftOffset + FScrollButtonWidth
   else
     SW := FTabsLeftOffset;
  if TabR.X < SW then
  begin
    TabR.Width := TabR.Width - (SW - TabR.X);
    TabR.X := SW;
  end;
  if FRightScrollButton <> nil then
    SW := FTabsRightOffset + FScrollButtonWidth
  else
    SW := FTabsRightOffset;
  if TabR.X + TabR.Width > Width - SW then
  begin
    TabR.Width := TabR.Width - (TabR.X + TabR.Width - (Width - SW));
  end;

  if TabR.Width <= 0 then Exit;

  if Tabs[Index].UseCustomOptions then
    FOptions := Tabs[Index].CustomOptions
  else
    FOptions := FTabOptions;


  R.Bottom := R.Bottom + FFrameWidth * 2;

  if (Tabs[Index].Page = ActivePage) and (ActivePage <> nil) and
      Tabs[Index].Enabled and Tabs[Index].Visible
  then
  begin
    if Focused then
      TabState := scsFocused
    else
      TabState := scsPressed;
  end
  else
  if FTabs[Index].Active then
    TabState := scsHot
  else
  if FTabs[Index].Enabled then
    TabState := scsNormal
  else
    TabState := scsDisabled;

  FOptions.State := TabState;
  FC := FOptions.FontColor;

  if TabState = scsDisabled then
  begin
    if IsLightColor(FC) then
      FC := DarkerColor(FC, 40)
    else
      FC := LighterColor(FC, 40);
  end;


  // draw tab shape
  if not (((TabState = scsNormal) or (TabState = scsDisabled)) and not FShowInActiveTab) then
  begin
    FillR := RectToGPRect(R);
    FrameR := RectToGPRect(R);

    if TabState = scsDisabled then
    begin
      TabFillC := ColorToGPColor(FOptions.Color, FOptions.ColorAlpha div 2);
      TabFrameC := ColorToGPColor(FOptions.FrameColor, FOptions.FrameColorAlpha div 2);
    end
    else
    begin
      TabFillC := ColorToGPColor(FOptions.Color, FOptions.ColorAlpha);
      TabFrameC := ColorToGPColor(FOptions.FrameColor, FOptions.FrameColorAlpha);
    end;
    if FOptions.ShapeFillStyle = scgpsfColor then
       B := TGPSolidBrush.Create(TabFillC)
    else
    begin
      C1 := ColorToGPColor(LighterColor(FOptions.Color, FOptions.GradientColorOffset), FOptions.ColorAlpha);
      C2 := TabFillC;
      GPR := FillR;
      InflateGPRect(GPR, FOptions.FrameWidth, FOptions.FrameWidth);
      B := TGPLinearGradientBrush.Create(GPR, C1, C2, FOptions.FShapeFillGradientAngle);
    end;

    P := TGPPen.Create(TabFrameC, FTabOptions.FrameWidth);
    FramePath := TGPGraphicsPath.Create;
    FillPath := TGPGraphicsPath.Create;

    if (FTabOptions.FrameWidth > 0) and (FTabOptions.FTabStyle = gptsShape) then
    begin
      InflateGPRect(FillR, -FTabOptions.FrameWidth + 0.2, -FTabOptions.FrameWidth + 0.2);
      InflateGPRect(FrameR, -FTabOptions.FrameWidth / 2, -FTabOptions.FrameWidth / 2);
    end;

    LB := nil;
    if FTabOptions.FTabStyle = gptsRoundedLine then
    begin
      LB := TGPSolidBrush.Create(TabFrameC);
      GPFillRoundedRectPath(FillPath, FillR, FTabOptions.ShapeCornerRadius);
      if FTabOptions.LineWidth <= 0 then
        scGPUtils.GPDrawHVRoundedLinePath(FramePath, FTabOptions.FrameWidth,
          FrameR.X + FTabOptions.ShapeCornerRadius,
          FrameR.Y + FrameR.Height - FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width - FTabOptions.ShapeCornerRadius,
          FrameR.Y + FrameR.Height - FTabOptions.FFrameWidth)
      else
        scGPUtils.GPDrawHVRoundedLinePath(FramePath, FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width / 2 - FTabOptions.LineWidth div 2,
          FrameR.Y + FrameR.Height - FTabOptions.FrameWidth,
          FrameR.X + FrameR.Width / 2 + FTabOptions.LineWidth div 2,
          FrameR.Y + FrameR.Height - FTabOptions.FFrameWidth)
    end
    else
    if (FTabOptions.FShapeCornerRadius = 0) or (FTabOptions.FTabStyle in [gptsBottomLine, gptsLine]) then
    begin
      FillPath.AddRectangle(FillR);
      if FTabOptions.FTabStyle in [gptsBottomLine, gptsLine] then
      begin
        InflateGPRect(FrameR, -FTabOptions.FrameWidth / 2, -FTabOptions.FrameWidth / 2);
        FrameR.X := FillR.X;
        FrameR.Width := FillR.Width;
        if FTabOptions.LineWidth <= 0 then
          FramePath.AddLine(MakePoint(FrameR.X, FrameR.Y + FrameR.Height),
            MakePoint(FrameR.X + FrameR.Width, FrameR.Y + FrameR.Height))
        else
          FramePath.AddLine(MakePoint(FrameR.X + FrameR.Width / 2 - FTabOptions.LineWidth div 2,
            FrameR.Y + FrameR.Height),
            MakePoint(FrameR.X + FrameR.Width / 2 + FTabOptions.LineWidth div 2,
            FrameR.Y + FrameR.Height));
      end
      else
        FramePath.AddRectangle(FrameR);
    end
    else
    begin
      l := FillR.X;
      t := FillR.y;
      w := FillR.Width;
      d := FTabOptions.ShapeCornerRadius * 2 - FOptions.FrameWidth;
      if d < 1 then d := 1;
      FillPath.StartFigure;
      FillPath.AddArc(l, t, d, d, 180, 90);
      FillPath.AddArc(l + w - d, t, d, d, 270, 90);
      FillPath.AddLine(MakePoint(FillR.X + FillR.Width, FillR.Y + FillR.Height),
      MakePoint(FillR.X, FillR.Y + FillR.Height));
      FillPath.CloseFigure;
      l := FrameR.X;
      t := FrameR.y;
      w := FrameR.Width;
      d := FTabOptions.ShapeCornerRadius * 2;
      FramePath.StartFigure;
      FramePath.AddArc(l, t, d, d, 180, 90);
      FramePath.AddArc(l + w - d, t, d, d, 270, 90);
      FramePath.AddLine(MakePoint(FrameR.X + FrameR.Width, FrameR.Y + FrameR.Height),
      MakePoint(FrameR.X, FrameR.Y + FrameR.Height));
      FramePath.CloseFigure;
    end;

    G.IntersectClip(TabR);
    G.FillPath(B, FillPath);
    if LB <> nil then
    begin
      G.FillPath(LB, FramePath);
      LB.Free;
    end
    else
      G.DrawPath(P, FramePath);
    G.ResetClip;

    B.Free;
    P.Free;
    FramePath.Free;
    FillPath.Free;
  end;

  // draw image and text
  ACanvas.Font := Self.Font;
  ACanvas.Font.Color := FC;


 if Tabs[Index].CustomGlowEffect.Enabled then
   FGlowEffect := Tabs[Index].CustomGlowEffect
 else
   FGlowEffect := FTabGlowEffect;

 FGlowColor := FGlowEffect.GetColor;
 case TabState of
   scsHot: FGlowColor := FGlowEffect.GetHotColor;
   scsPressed: FGlowColor := FGlowEffect.GetPressedColor;
   scsFocused: FGlowColor := FGlowEffect.GetFocusedColor;
 end;
 if FGlowColor = clNone then
   FGlowColor := FGlowEffect.GetColor;

 ACanvas.Brush.Style := bsClear;
 ACanvas.Font.Color := FC;

 R := FTabs[Index].TabRect;
 Inc(R.Top, FFrameWidth);

 if IsRightToLeft then
   Dec(R.Right, FTabMargin)
 else
   Inc(R.Left, FTabMargin);

 IIndex := FTabs[Index].ImageIndex;
 IImages := FTabImages;

 if Assigned(FOnGetTabImage) then
   FOnGetTabImage(Index, IImages, IIndex);

 if not Focused and (TabState = scsFocused) then
    TabState := scsPressed;

 if Assigned(FOnGetTabDrawParams) then
   FOnGetTabDrawParams(Index, TabState, ACanvas);

 if FDrawTextMode = scdtmGDIPlus then
 begin
   if (IImages <> nil) and (IIndex >= 0) and  (IIndex < IImages.Count) then
     GPDrawImageAndText(G, ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
        FTabs[Index].Caption, IIndex, IImages,
        FTabs[Index].Enabled and Self.Enabled, False, IsRightToLeft, True)
   else
   begin
     R1 := FTabs[Index].TabRect;
     GPDrawText(G, nil, ACanvas, R1, FTabs[Index].Caption,
       scDrawTextBidiModeFlags(DT_CENTER or DT_VCENTER, BidiMode = bdRightToLeft));
   end;
 end
 else
 if (IImages <> nil) and (IIndex >= 0) and
    (IIndex < IImages.Count) then
 begin
   if FGlowEffect.Enabled and (TabState in FGlowEffect.States) then
      DrawImageAndTextWithGlow2(ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
        FTabs[Index].Caption, IIndex, IImages,
        FTabs[Index].Enabled and Self.Enabled, False, clBlack,
        FGlowEffect.Offset, FGlowColor,
        FGlowEffect.GlowSize, FGlowEffect.Intensive,
        FGlowEffect.GetAlphaValue, True,
        False, IsRightToLeft, True)
    else
      DrawImageAndText2(ACanvas, R, 0, FTabSpacing, GlyphLayout[IsRightToLeft],
        FTabs[Index].Caption, IIndex, IImages,
        FTabs[Index].Enabled and Self.Enabled, False, clBlack, False, IsRightToLeft, True)
  end
  else
  begin
    R1 := Rect(0, 0, R.Width, R.Height);
    DrawText(ACanvas.Handle, PChar(FTabs[Index].Caption),
      Length(FTabs[Index].Caption), R1,
      DT_LEFT or DT_CALCRECT);
    TX := R.Left;
    TY := R.Top + R.Height div 2 - R1.Height div 2;
    if TY < R.Top then TY := R.Top;
    R := Rect(TX, TY, R.Right - 2, TY + R1.Height);
    if FGlowEffect.Enabled and (TabState in FGlowEffect.States) then
      DrawTextWithGlow(ACanvas, R, FTabs[Index].Caption, DT_LEFT,
        FGlowEffect.Offset, FGlowColor, FGlowEffect.GlowSize,
        FGlowEffect.Intensive, FGlowEffect.GetAlphaValue, IsRightToLeft, True)
    else
      DrawText(ACanvas.Handle, PChar(FTabs[Index].Caption),
        Length(FTabs[Index].Caption), R,
        scDrawTextBidiModeFlags(DT_LEFT, BidiMode = bdRightToLeft));
  end;

  if FShowCloseButtons and FTabs[Index].ShowCloseButton then
  begin
    R := FTabs[Index].TabRect;
    if IsRightToLeft then
      R.Right := R.Left + FCloseButtonSize + 15
    else
      R.Left := R.Right - FCloseButtonSize - 15;
    DrawCloseButton(ACanvas, G, R, Index, FC);
  end;

end;

function TscGPToolPager.CreatePage: TscGPToolPagerPage;
var
  LPage: TscGPToolPagerPage;
  R: TRect;
begin
  LPage := TscGPToolPagerPage.Create(Self.Owner);
  LPage.Parent := Self;
  LPage.Pager := Self;
  R := GetPageBoundsRect;
  LPage.SetBounds(R.Left, R.Top, R.Right, R.Bottom);
  LPage.Name := SC_GetUniqueName('scGPToolPagerPage%d', Self.Owner);
  ActivePage := LPage;
  Result := LPage;

  if not (csLoading in ComponentState) then
  begin
    FScrollOffset := 0;
    GetScrollInfo;
    AdjustScrollButtons;
    FTabIndex := GetPageIndex(FActivePage);
    ScrollToTab(FTabIndex);
  end;

  RePaintControl;
end;

constructor TscGPToolGroupPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  FCaptionHeight := 17;
  FCaptionFontColor := clNone;
  FCaptionFontDisabledColor := clNone;
  FDialogButtonColor := clNone;
  FStorePaintBuffer := True;
  FShowDialogButton := False;
  FButtonRect := Rect(0, 0, 0, 0);
  FButtonMouseIn := False;
  FButtonPressed := False;
  FSeparatorColor := clNone;
  FSeparatorColorAlpha := 255;
  Width := 150;
  Height := 130;
end;

destructor TscGPToolGroupPanel.Destroy;
begin
  inherited;
end;

procedure TscGPToolGroupPanel.SetDialogButtonColor(Value: TColor);
begin
  if Value <> FDialogButtonColor then
  begin
    FDialogButtonColor := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolGroupPanel.SetSeparatorColor(Value: TColor);
begin
  if Value <> FSeparatorColor then
  begin
    FSeparatorColor := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolGroupPanel.SetSeparatorColorAlpha(Value: Byte);
begin
  if Value <> FSeparatorColorAlpha then
  begin
    FSeparatorColorAlpha := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolGroupPanel.SetCaptionFontDisabledColor(Value: TColor);
begin
  if Value <> FCaptionFontDisabledColor then
  begin
    FCaptionFontDisabledColor := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolGroupPanel.SetCaptionFontColor(Value: TColor);
begin
  if Value <> FCaptionFontColor then
  begin
    FCaptionFontColor := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolGroupPanel.SetCaptionHeight(Value: Integer);
begin
  if (FCaptionHeight <> Value) and (Value > 15) then
  begin
    FCaptionHeight := Value;
    RePaintControl;
    Realign;
  end;
end;

procedure TscGPToolGroupPanel.SetShowDialogButton(Value: Boolean);
begin
  if FShowDialogButton <> Value then
  begin
    FShowDialogButton := Value;
    RePaintControl;
  end;
end;

procedure TscGPToolGroupPanel.Draw(ACanvas: TCanvas; ACtrlState: TscsCtrlState);
var
  R: TRect;
  R1: TGPRectF;
  C: TColor;
  C1: Cardinal;
  G: TGPGraphics;
  GBrush: TGPSolidBrush;
begin
  // draw caption
  ACanvas.Font.Assign(Font);
  if FDrawTextMode = scdtmGDIPlus then
  begin
    if FCaptionFontColor = clNone then
      C := GetGroupBoxTextColor(scsNormal)
    else
      C := GetStyleColor(FCaptionFontColor{$IFDEF VER340_UP}, Self{$ENDIF});
  end
  else
  if FCaptionFontColor = clNone then
  begin
    C := GetGroupBoxTextColor(CtrlState);
    if Enabled then
      C := MiddleColor(C, GetStyleColor(clBtnFace{$IFDEF VER340_UP}, Self{$ENDIF}));
  end
  else
  begin
    C := GetStyleColor(FCaptionFontColor{$IFDEF VER340_UP}, Self{$ENDIF});
    if not Enabled then
    begin
      if FCaptionFontDisabledColor <> clNone then
        C := GetStyleColor(FCaptionFontDisabledColor{$IFDEF VER340_UP}, Self{$ENDIF})
      else
        C := MiddleColor(C, GetStyleColor(clBtnFace{$IFDEF VER340_UP}, Self{$ENDIF}));
    end;
  end;
  ACanvas.Font.Color := C;
  R := Rect(0, Height - FCaptionHeight - 1, Width, Height);
  ACanvas.Brush.Style := bsClear;
  if DrawTextMode = scdtmGDI  then
    scDrawUtils.DrawTextAlignment(ACanvas, Caption, R, taCenter);
  // draw separator
  G := TGPGraphics.Create(ACanvas.Handle);
  G.SetSmoothingMode(SmoothingModeHighQuality);

  if DrawTextMode = scdtmGDIPlus then
  begin
    if Enabled then
      GPDrawText(G, nil, ACanvas, R, Caption, scDrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER, IsRightToLeft), 130)
    else
      GPDrawText(G, nil, ACanvas, R, Caption, scDrawTextBiDiModeFlags(DT_CENTER or DT_VCENTER, IsRightToLeft), 100);
  end;

  G.SetPixelOffsetMode(PixelOffsetModeHighQuality);
  if FSeparatorColor = clNone then
    C1 := ColorToGPColor(GetStyleColor(clBtnText{$IFDEF VER340_UP}, Self{$ENDIF}), 50)
  else
    C1 := ColorToGPColor(GetStyleColor(FSeparatorColor{$IFDEF VER340_UP}, Self{$ENDIF}), FSeparatorColorAlpha);
  R := ClientRect;
  Inc(R.Top, FCaptionHeight div 2);
  Dec(R.Bottom, FCaptionHeight div 2);
  R1 := RectToGPRect(R);

  if BidiMode <> bdRightToLeft then
    R1.X := R.Right - 1;

  R1.Width := 1;
  GBrush := TGPSolidBrush.Create(C1);
  G.FillRectangle(GBrush, R1);
  // draw dialog button
  if FShowDialogButton then
    DrawDialogButton(ACanvas, G);
  //
  GBrush.Free;
  G.Free;
end;

procedure TscGPToolGroupPanel.DrawDialogButton(ACanvas: TCanvas; G: TGPGraphics);
var
  C, GC: Cardinal;
  Color: TColor;
  B: TGPSolidBrush;
  R: TGPRectF;
begin
  if BidiMode <> bdRightToLeft then
    FButtonRect := Rect(Width - FCaptionHeight - 1,
      Height - FCaptionHeight, Width - 1, Height)
  else
    FButtonRect := Rect(1,
      Height - FCaptionHeight, FCaptionHeight + 1, Height);

  if FDialogButtonColor = clNone then
    Color := GetStyleColor(clBtnText{$IFDEF VER340_UP}, Self{$ENDIF})
  else
    Color := GetStyleColor(FDialogButtonColor{$IFDEF VER340_UP}, Self{$ENDIF});

  R := RectToGPRect(FButtonRect);
  if FButtonMouseIn and FButtonPressed then
  begin
    C := ColorToGPColor(Color, 60);
    GC := ColorToGPColor(Color, 255);
  end
  else
  if FButtonMouseIn then
  begin
    C := ColorToGPColor(Color, 40);
    if FDialogButtonColor = clNone then
      GC := ColorToGPColor(Color, 220)
    else
      GC := ColorToGPColor(Color, 255);
  end
  else
  begin
    C := 0;
    if FDialogButtonColor = clNone then
      GC := ColorToGPColor(Color, 150)
    else
      GC := ColorToGPColor(Color, 220);
  end;
  if C <> 0 then
  begin
    B := TGPSolidBrush.Create(C);
    G.FillRectangle(B, R);
    B.Free;
  end;
  InflateGPRect(R, -R.Width / 4, -R.Width / 4);
  scGPUtils.GPDrawToolDialogGlyph(G, R, GC, FScaleFactor, 1);
end;

procedure TscGPToolGroupPanel.ChangeScale(M, D: Integer{$IFDEF VER310_UP}; isDpiChange: Boolean{$ENDIF});
begin
  inherited;
  FCaptionHeight := MulDiv(FCaptionHeight , M, D);
end;

procedure TscGPToolGroupPanel.DoMouseLeave;
begin
  inherited;
  if FButtonMouseIn then
  begin
    FButtonMouseIn := False;
    RePaintControl;
  end;
end;

procedure TscGPToolGroupPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FShowDialogButton then
    if FButtonRect.Contains(Point(X, Y)) and not FButtonMouseIn then
    begin
      FButtonMouseIn := True;
      RePaintControl;
    end
    else
    if not FButtonRect.Contains(Point(X, Y)) and FButtonMouseIn then
    begin
      FButtonMouseIn := False;
      RePaintControl;
    end;
end;

procedure TscGPToolGroupPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
   if FShowDialogButton then
    if FButtonRect.Contains(Point(X, Y)) and not FButtonPressed then
    begin
      FButtonPressed := True;
      RePaintControl;
    end;
end;

procedure TscGPToolGroupPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if FShowDialogButton then
    if FButtonPressed then
    begin
      FButtonPressed := False;
      RePaintControl;
      if FButtonMouseIn and Assigned(FOnDialogButtonClick) then
        FOnDialogButtonClick(Self);
    end;
end;

procedure TscGPToolGroupPanel.CMTextChanged(var Message: TMessage);
begin
  inherited;
  RePaintControl;
end;

procedure TscGPToolGroupPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  Dec(Rect.Bottom, FCaptionHeight);
  InflateRect(Rect, -3, -3);
end;

// TscGPPageViewer ==============================================================

constructor TscGPPageViewerItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPage := nil;

  if (TscGPPageViewerItems(Collection).PageViewer <> nil) and
     (csDesigning in  TscGPPageViewerItems(Collection).PageViewer.ComponentState) and
      not (csLoading in TscGPPageViewerItems(Collection).PageViewer.ComponentState) and
      not (csReading in TscGPPageViewerItems(Collection).PageViewer.ComponentState) and
      not (csUpdating in TscGPPageViewerItems(Collection).PageViewer.ComponentState) and
      not (csWriting in TscGPPageViewerItems(Collection).PageViewer.ComponentState)
  then
  begin
    FPage := TscGPPageViewerItems(Collection).PageViewer.CreatePage;
    TscGPPageViewerItems(Collection).PageViewer.ActivePage := FPage;
  end;
end;

destructor TscGPPageViewerItem.Destroy;
begin
  if (TscGPPageViewerItems(Collection).PageViewer <> nil)
     and (csDesigning in  TscGPPageViewerItems(Collection).PageViewer.ComponentState)
     and not (csLoading in  TscGPPageViewerItems(Collection).PageViewer.ComponentState)
     and (FPage <> nil)
     and not (csDestroying in TscGPPageViewerItems(Collection).PageViewer.ComponentState)
     and not (csReading in TscGPPageViewerItems(Collection).PageViewer.ComponentState)
     and not (csUpdating in TscGPPageViewerItems(Collection).PageViewer.ComponentState)
     and not (csWriting in TscGPPageViewerItems(Collection).PageViewer.ComponentState)
  then
    TscGPPageViewerItems(Collection).DestroyPage := FPage;
  inherited;
end;

procedure TscGPPageViewerItem.Assign(Source: TPersistent);

  function FindControl(AControl: TWinControl): TscGPPageViewerPage;
  begin
    if (AControl <> nil) and (TscGPPageViewerItems(Collection).PageViewer <> nil) and
       (TscGPPageViewerItems(Collection).PageViewer.Owner <> nil)
    then
      Result := TscGPPageViewerItems(Collection).PageViewer.Owner.FindComponent(AControl.Name) as TscGPPageViewerPage
    else
      Result := nil;
  end;


begin
  if Source is TscGPPageViewerItem then
  begin
    FPage := FindControl(TscGPPageViewerItem(Source).Page);
  end
  else
    inherited Assign(Source);
end;

procedure TscGPPageViewerItem.SetPage(const Value: TscGPPageViewerPage);
begin
  if FPage <> Value then
  begin
    FPage := Value;
    if (FPage <> nil) and (FPage.PageViewer <> nil) then
      FPage.PageViewer.ActivePage := FPage;
  end;
end;

constructor TscGPPageViewerItems.Create;
begin
  inherited Create(TscGPPageViewerItem);
  PageViewer := APageViewer;
  DestroyPage := nil;
end;

function TscGPPageViewerItems.GetOwner: TPersistent;
begin
  Result := PageViewer;
end;

function TscGPPageViewerItems.Add: TscGPPageViewerItem;
begin
  Result := TscGPPageViewerItem(inherited Add);
  if (PageViewer <> nil)
     and not (csDesigning in PageViewer.ComponentState)
     and not (csLoading in PageViewer.ComponentState)
  then
  begin
    Result.Page := PageViewer.CreatePage;
    PageViewer.ActivePage := Result.Page;
  end;

end;

function TscGPPageViewerItems.Insert(Index: Integer): TscGPPageViewerItem;
begin
  Result := TscGPPageViewerItem(inherited Insert(Index));
  if (PageViewer <> nil)
     and not (csDesigning in PageViewer.ComponentState)
     and not (csLoading in PageViewer.ComponentState)
  then
    Result.Page := PageViewer.CreatePage;
end;

procedure TscGPPageViewerItems.Delete(Index: Integer);
begin
   if (PageViewer <> nil)
      and not (csDesigning in PageViewer.ComponentState)
      and not (csLoading in PageViewer.ComponentState)
      and (Items[Index].FPage <> nil)
  then
    FreeAndNil(Items[Index].FPage);
  inherited Delete(Index);
end;

procedure TscGPPageViewerItems.Update(Item: TCollectionItem);
var
  F: TCustomForm;
begin
  inherited;
  if PageViewer = nil then
    Exit;
  if (DestroyPage <> nil) and
     (csDesigning in PageViewer.ComponentState) and
     not (csLoading in  PageViewer.ComponentState) and
     not (csDestroying in PageViewer.ComponentState)
  then
  begin
    FreeAndNil(DestroyPage);
    F := GetParentForm(PageViewer);
    if F <> nil then
      F.Designer.Modified;
  end;
end;

function TscGPPageViewerItems.GetItem(Index: Integer):  TscGPPageViewerItem;
begin
  Result := TscGPPageViewerItem(inherited GetItem(Index));
end;

procedure TscGPPageViewerItems.SetItem(Index: Integer; Value:  TscGPPageViewerItem);
begin
  inherited SetItem(Index, Value);
end;

constructor TscGPPageViewerPage.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csNoDesignVisible];
  FUseOnlyParentBackground := True;
  FFrameWidth := 0;
  ParentFont := False;
  ParentColor := False;
  Align := alClient;
end;

destructor TscGPPageViewerPage.Destroy;
var
  i, j: Integer;
  B: Boolean;
begin
  if (PageViewer <> nil)
     and not (csLoading in PageViewer.ComponentState)
     and not (csDestroying in PageViewer.ComponentState)
     and not (csUpdating in PageViewer.ComponentState)
     and not (csReading in PageViewer.ComponentState)
     and not (csWriting in PageViewer.ComponentState)
  then
    begin
      j := PageViewer.GetPageIndex(Self);
      if j <> -1
      then
        begin
          PageViewer.Pages[j].Page := nil;
          PageViewer.Pages.Delete(j);
          if PageViewer.PageIndex = j
          then
            begin
              B := False;
              if j < PageViewer.Pages.Count then
              for i := j to PageViewer.Pages.Count - 1 do
              begin
                if (i >= 0) and (i < PageViewer.Pages.Count) then
                begin
                  PageViewer.FPageIndex := -1;
                  PageViewer.PageIndex := i;
                  B := True;
                  Break;
                end;
              end;
              if not B and (j >= 0)
              then
                for i := j downto 0 do
                begin
                  if (i >= 0) and (i < PageViewer.Pages.Count) then
                  begin
                    PageViewer.FPageIndex := -1;
                    PageViewer.PageIndex := i;
                    Break;
                  end;
                end;
            end;
        end
      else
        begin
          if PageViewer.PageIndex > PageViewer.Pages.Count - 1
          then
            PageViewer.PageIndex := PageViewer.Pages.Count - 1
          else
            PageViewer.PageIndex := PageViewer.PageIndex;
        end;
    end;
  inherited;
end;

procedure TscGPPageViewerPage.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  R: TRect;
begin
  if Align = alClient then
    inherited
  else
  begin
    if PageViewer = nil then
      if (Parent <> nil) and (Parent is TscGPPageViewer) then
        PageViewer := TscGPPageViewer(Parent);
     if (Parent <> nil) and (PageViewer <> nil)
     then
      begin
         R := PageViewer.GetPageBoundsRect;
         inherited SetBounds(R.Left, R.Top, R.Right, R.Bottom);
      end
    else
      inherited;
  end;
end;

constructor TscGPPageViewer.Create(AOwner: TComponent);
begin
  inherited;
  TabStop := False;
  FTransparentBackground := True;
  ControlStyle := ControlStyle + [csAcceptsControls, csNoDesignVisible];
  FPages := TscGPPageViewerItems.Create(Self);
  FPageIndex := -1;
  Width := 300;
  Height := 300;
end;

procedure TscGPPageViewer.UpdateControls;
begin
  if FActivePage <> nil then
    SendMessage(FActivePage.Handle, WM_CHECKPARENTBG, 0, 0)
end;

procedure TscGPPageViewer.GetParentBG;
begin
  if Pages.Count <> 0 then
  begin
    if ParentBGBuffer.Width * ParentBGBuffer.Height <> 0 then
      ParentBGBuffer.SetSize(0, 0);
  end
  else
    inherited;
end;

destructor TscGPPageViewer.Destroy;
begin
  FPages.Free;
  FPages := nil;
  inherited;
end;

procedure TscGPPageViewer.Paint;
begin
  if Pages.Count = 0 then
    inherited;
end;

procedure TscGPPageViewer.SetPageIndex;
var
  LPage: TscGPPageViewerPage;
  LPrevPageIndex: Integer;
  B: Boolean;
  LForm: TCustomForm;
begin
  if (Value < 0) or (Value > Pages.Count - 1) then
    Exit;

  if Assigned(FOnCanChangePage) and not (csLoading in ComponentState) then
  begin
    B := True;
    FOnCanChangePage(Value, B);
    if not B then Exit;
  end;

  if (FPageIndex <> Value) and (Value >= 0) and (Value < Pages.Count) and
     not (csDesigning in ComponentState) and
     not (csLoading in ComponentState) then
  begin
    LForm := GetParentForm(Self);
    if (LForm <> nil) and (FActivePage <> nil) and (LForm.ActiveControl <> nil)
       and FActivePage.ContainsControl(LForm.ActiveControl) then
    begin
      LForm.ActiveControl := nil;
      if LForm.ActiveControl <> nil then
        Exit;
    end;
  end;

  if (FPageIndex <> Value) and (Value >= 0) and (Value < Pages.Count)
  then
    begin
      LPrevPageIndex := FPageIndex;
      FPageIndex := Value;
      if not (csLoading in ComponentState) then
        if Assigned(FOnChangingPage) then FOnChangingPage(Self);
      if (FPageIndex > -1) and (FPages[FPageIndex].Page <> nil)
      then
        begin
          LPage := FPages[FPageIndex].Page;
          LPage.Parent := Self;
          LPage.Visible := True;
          LPage.BringToFront;
          FActivePage := LPage;
          LPage.SetBounds(LPage.Left, LPage.Top, LPage.Width, LPage.Height);
        end;
      if (LPrevPageIndex > -1) and (FPages.Count > LPrevPageIndex) and
         (FPages[LPrevPageIndex].Page <> nil) and
         (FPages[LPrevPageIndex].Page <> nil)
      then
        FPages[LPrevPageIndex].Page.Visible := False;
      if not (csLoading in ComponentState) then
        if Assigned(FOnChangePage) then FOnChangePage(Self);
    end
  else
    begin
      if Pages[Value].FPage <> nil
      then
        if not Pages[Value].FPage.Visible then Pages[Value].FPage.Visible := True;
    end;
end;

procedure TscGPPageViewer.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
    with Params.WindowClass do
      Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TscGPPageViewer.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FActivePage) then
    FActivePage := nil;
end;

procedure TscGPPageViewer.SetPages(AValue: TscGPPageViewerItems);
begin
  FPages.Assign(AValue);
end;

procedure TscGPPageViewer.SetActivePage(const Value: TscGPPageViewerPage);
begin
  if Value <> nil then
    PageIndex := GetPageIndex(Value);
end;

function TscGPPageViewer.GetPageIndex(Value: TscGPPageViewerPage): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Pages.Count - 1 do
    if Pages[i].Page = Value
    then
       begin
         Result := i;
         Break;
       end;
end;

procedure TscGPPageViewer.Loaded;
var
  i: Integer;
begin
  inherited;
  if Pages.Count > 0 then
  begin
    for i := 0 to Pages.Count - 1 do
    if Pages[i].Page <> nil then
    begin
      Pages[i].Page.PageViewer := Self;
      if Pages[i].Page = FActivePage
      then
        Pages[i].Page.Visible := True
      else
        Pages[i].Page.Visible := False;
    end;
  end;
end;

function TscGPPageViewer.GetPageBoundsRect: TRect;
begin
  Result := Rect(0, 0, Width, Height);
end;

procedure TscGPPageViewer.WMSIZE(var Message: TWMSIZE);
begin
  inherited;
  if (ActivePage <> nil) and (ActivePage.Align <> alClient) and (Pages.Count > 0) then
    with ActivePage do
      SetBounds(Left, Top, Width, Height);
end;

function TscGPPageViewer.CreatePage: TscGPPageViewerPage;
var
  LPage: TscGPPageViewerPage;
  R: TRect;
begin
  LPage := TscGPPageViewerPage.Create(Self.Owner);
  LPage.Parent := Self;
  LPage.PageViewer := Self;
  R := GetPageBoundsRect;
  LPage.SetBounds(R.Left, R.Top, R.Right, R.Bottom);
  LPage.Name := SC_GetUniqueName('scGPPageViewerPage%d', Self.Owner);
  ActivePage := LPage;
  Result := LPage;
end;

initialization

  TCustomStyleEngine.RegisterStyleHook(TscGPPageControlPage, TscScrollBoxStyleHook);

finalization

  {$IFNDEF VER230}
  TCustomStyleEngine.UnRegisterStyleHook(TscGPPageControlPage, TscScrollBoxStyleHook);
  {$ENDIF}


end.

