{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit Net.CrossHttpParams;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.NetEncoding,
  System.IOUtils,
  System.RegularExpressions,
  System.SyncObjs,
  System.Diagnostics,
  System.DateUtils,
  Net.CrossHttpUtils;

type
  TNameValue = record
    Name, Value: string;
    constructor Create(const AName, AValue: string);
  end;

  TBaseParams = class(TEnumerable<TNameValue>)
  private
    FParams: TList<TNameValue>;

    function  GetCount: Integer;
    function  GetItem(AIndex: Integer): TNameValue;
    function  GetParam(const AName: string): string;
    function  GetParamIndex(const AName: string): Integer;
    procedure SetItem(AIndex: Integer; const AValue: TNameValue);
    procedure SetParam(const AName, AValue: string);
  protected
    function  DoGetEnumerator: TEnumerator<TNameValue>; override;
  public
    type
      TEnumerator = class(TEnumerator<TNameValue>)
      private
        FIndex: Integer;
        FList: TList<TNameValue>;
      protected
        function DoGetCurrent: TNameValue; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(const AList: TList<TNameValue>);
      end;
  public
    constructor Create; overload; virtual;
    constructor Create(const AEncodedParams: string); overload; virtual;
    destructor Destroy; override;

    procedure Add(const AName, AValue: string; ADupAllowed: Boolean = False); overload;
    procedure Add(const AEncodedParams: string); overload;
    procedure Clear;
    procedure Decode(const AEncodedParams: string; AClear: Boolean = True); virtual; abstract;
    function  Encode: string; virtual; abstract;
    function  ExistsParam(const AName: string): Boolean;
    function  GetParamValue(const AName: string; out AValue: string): Boolean;
    procedure Remove(const AName: string); overload;
    procedure Remove(AIndex: Integer); overload;
    procedure Sort(const AComparison: TComparison<TNameValue> = nil);

    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: TNameValue read GetItem write SetItem;
    property Params[const AName: string]: string read GetParam write SetParam; default;
  end;

  THttpUrlParams = class(TBaseParams)
  private
    FEncodeName: Boolean;
    FEncodeValue: Boolean;
  public
    constructor Create; override;

    procedure Decode(const AEncodedParams: string; AClear: Boolean = True); override;
    function  Encode: string; override;

    property EncodeName: Boolean read FEncodeName write FEncodeName;
    property EncodeValue: Boolean read FEncodeValue write FEncodeValue;
  end;

  THttpHeader = class(TBaseParams)
  public
    procedure Decode(const AEncodedParams: string; AClear: Boolean = True); override;
    function  Encode: string; override;
  end;

  TDelimitParams = class(TBaseParams)
  private
    FDelimiter: Char;
  public
    procedure Decode(const AEncodedParams: string; AClear: Boolean = True); override;
    function  Encode: string; override;

    property Delimiter: Char read FDelimiter write FDelimiter;
  end;

  TRequestCookies = class(TBaseParams)
  public
    procedure Decode(const AEncodedParams: string; AClear: Boolean = True); override;
    function  Encode: string; override;
  end;

  TResponseCookie = record
    Name: string;
    Value: string;
    MaxAge: Integer;
    Domain: string;
    Path: string;
    HttpOnly: Boolean;
    Secure: Boolean;

    constructor Create(const AName, AValue: string; AMaxAge: Integer; const APath: string = ''; const ADomain: string = ''; AHttpOnly: Boolean = False; ASecure: Boolean = False);

    function Encode: string;
  end;

  TResponseCookies = class(TList<TResponseCookie>)
  private
    function  GetCookie(const AName: string): TResponseCookie;
    function  GetCookieIndex(const AName: string): Integer;
    procedure SetCookie(const AName: string; const Value: TResponseCookie);
  public
    procedure AddOrSet(const AName, AValue: string; AMaxAge: Integer; const APath: string = ''; const ADomain: string = ''; AHttpOnly: Boolean = False; ASecure: Boolean = False);
    procedure Remove(const AName: string);

    property Cookies[const AName: string]: TResponseCookie read GetCookie write SetCookie;
  end;

  TFormField = class
  private
    FContentTransferEncoding: string;
    FContentType: string;
    FFileName: string;
    FFilePath: string;
    FName: string;
    FValue: TStream;
  public
    constructor Create;
    destructor Destroy; override;

    function  AsBytes: TBytes;
    function  AsString(AEncoding: TEncoding = nil): string;
    procedure FreeValue;

    property ContentTransferEncoding: string read FContentTransferEncoding;
    property ContentType: string read FContentType;
    property FileName: string read FFileName;
    property FilePath: string read FFilePath;
    property Name: string read FName;
    property Value: TStream read FValue;
  end;

  THttpMultiPartFormData = class(TEnumerable<TFormField>)
  public
    type
      TDecodeState = (
        dsBoundary,
        dsDetect,
        dsPartHeader,
        dsPartData
      );
  private
    const
      DETECT_HEADER_BYTES: array [0..1] of Byte = (13, 10);
      DETECT_END_BYTES: array [0..3] of Byte = (45, 45, 13, 10);
      MAX_PART_HEADER: Integer = 64 * 1024;
  private
    FAutoDeleteFiles: Boolean;
    FBoundary: string;
    FBoundaryBytes: TBytes;
    FBoundaryIndex: Integer;
    FCurrentPartField: TFormField;
    FCurrentPartHeader: TBytesStream;
    FDecodeState: TDecodeState;
    FDetectHeaderIndex: Integer;
    FDetectEndIndex: Integer;
    FLookbehind: TBytes;
    FPartDataBegin: Integer;
    FPartFields: TObjectList<TFormField>;
    FPrevIndex: Integer;
    FStoragePath: string;
    CR: Integer;
    LF: Integer;

    function GetCount: Integer;
    function GetDataSize: Integer;
    function GetField(const AName: string): TFormField;
    function GetItem(AIndex: Integer): TFormField;
    function GetItemIndex(const AName: string): Integer;
  protected
    function DoGetEnumerator: TEnumerator<TFormField>; override;
  public
    type
      TEnumerator = class(TEnumerator<TFormField>)
      private
        FIndex: Integer;
        FList: TList<TFormField>;
      protected
        function DoGetCurrent: TFormField; override;
        function DoMoveNext: Boolean; override;
      public
        constructor Create(const AList: TList<TFormField>);
      end;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Clear;
    function  Decode(const ABuf: Pointer; ALen: Integer): Integer;
    function  FindField(const AFieldName: string; out AField: TFormField): Boolean;
    procedure InitWithBoundary(const ABoundary: string);

    property AutoDeleteFiles: Boolean read FAutoDeleteFiles write FAutoDeleteFiles;
    property Boundary: string read FBoundary;
    property Count: Integer read GetCount;
    property DataSize: Integer read GetDataSize;
    property Fields[const AName: string]: TFormField read GetField;
    property Items[AIndex: Integer]: TFormField read GetItem;
    property StoragePath: string read FStoragePath write FStoragePath;
  end;

  ISessions = interface;

  ISession = interface
  ['{A3D525A1-C534-4CE6-969B-53C5B8CB77C3}']
    function  GetCreateTime: TDateTime;
    function  GetExpiryTime: Integer;
    function  GetLastAccessTime: TDateTime;
    function  GetOwner: ISessions;
    function  GetSessionID: string;
    function  GetValue(const AName: string): string;
    procedure SetCreateTime(const ACreateTime: TDateTime);
    procedure SetExpiryTime(const Value: Integer);
    procedure SetLastAccessTime(const ALastAccessTime: TDateTime);
    procedure SetSessionID(const ASessionID: string);
    procedure SetValue(const AName, AValue: string);
    function  Expired: Boolean;
    procedure Touch;

    property CreateTime: TDateTime read GetCreateTime write SetCreateTime;
    property ExpiryTime: Integer read GetExpiryTime write SetExpiryTime;
    property LastAccessTime: TDateTime read GetLastAccessTime write SetLastAccessTime;
    property Owner: ISessions read GetOwner;
    property SessionID: string read GetSessionID write SetSessionID;
    property Values[const AName: string]: string read GetValue write SetValue; default;
  end;

  TSessionBase = class abstract(TInterfacedObject, ISession)
  private
    [unsafe]FOwner: ISessions;

    function  GetOwner: ISessions;
  protected
    function  GetSessionID: string; virtual; abstract;
    function  GetCreateTime: TDateTime; virtual; abstract;
    function  GetLastAccessTime: TDateTime; virtual; abstract;
    function  GetExpiryTime: Integer; virtual; abstract;
    function  GetValue(const AName: string): string; virtual; abstract;
    procedure SetSessionID(const ASessionID: string); virtual; abstract;
    procedure SetCreateTime(const ACreateTime: TDateTime); virtual; abstract;
    procedure SetLastAccessTime(const ALastAccessTime: TDateTime); virtual; abstract;
    procedure SetExpiryTime(const Value: Integer); virtual; abstract;
    procedure SetValue(const AName, AValue: string); virtual; abstract;
  public
    constructor Create(const AOwner: ISessions; const ASessionID: string); virtual;

    function  Expired: Boolean; virtual;
    procedure Touch; virtual;

    property Owner: ISessions read GetOwner;

    property CreateTime: TDateTime read GetCreateTime write SetCreateTime;
    property ExpiryTime: Integer read GetExpiryTime write SetExpiryTime;
    property LastAccessTime: TDateTime read GetLastAccessTime write SetLastAccessTime;
    property SessionID: string read GetSessionID write SetSessionID;
    property Values[const AName: string]: string read GetValue write SetValue; default;
  end;

  TSession = class(TSessionBase)
  protected
    FCreateTime: TDateTime;
    FExpire: Integer;
    FLastAccessTime: TDateTime;
    FSessionID: string;
    FValues: TDictionary<string, string>;

    function  GetCreateTime: TDateTime; override;
    function  GetExpiryTime: Integer; override;
    function  GetLastAccessTime: TDateTime; override;
    function  GetSessionID: string; override;
    function  GetValue(const AName: string): string; override;
    procedure SetCreateTime(const ACreateTime: TDateTime); override;
    procedure SetExpiryTime(const AValue: Integer); override;
    procedure SetLastAccessTime(const ALastAccessTime: TDateTime); override;
    procedure SetSessionID(const ASessionID: string); override;
    procedure SetValue(const AName, AValue: string); override;
  public
    constructor Create(const AOwner: ISessions; const ASessionID: string); override;
    destructor Destroy; override;

    property CreateTime: TDateTime read GetCreateTime write SetCreateTime;
    property LastAccessTime: TDateTime read GetLastAccessTime write SetLastAccessTime;
    property SessionID: string read GetSessionID write SetSessionID;
    property Values[const AName: string]: string read GetValue write SetValue; default;
  end;

  TSessionClass = class of TSessionBase;

  ISessions = interface
  ['{5187CA76-4CC4-4986-B67B-BC3E76D6CD74}']
    function  AddSession(const ASessionID: string): ISession; overload;
    function  AddSession: ISession; overload;
    procedure AddSession(const ASessionID: string; ASession: ISession); overload;
    procedure BeginRead;
    procedure BeginWrite;
    procedure Clear;
    procedure EndRead;
    procedure EndWrite;
    function  ExistsSession(const ASessionID: string; var ASession: ISession): Boolean; overload;
    function  ExistsSession(const ASessionID: string): Boolean; overload;
    function  GetCount: Integer;
    function  GetEnumerator: TEnumerator<ISession>;
    function  GetExpiryTime: Integer;
    function  GetItem(const AIndex: Integer): ISession;
    function  GetSessionClass: TSessionClass;
    function  GetSession(const ASessionID: string): ISession;
    function  NewSessionID: string;
    procedure RemoveSession(const ASession: ISession); overload;
    procedure RemoveSession(const ASessionID: string); overload;
    procedure RemoveSessions(const ASessions: TArray<ISession>);
    procedure SetExpiryTime(const Value: Integer);
    procedure SetSessionClass(const Value: TSessionClass);

    property Count: Integer read GetCount;
    property ExpiryTime: Integer read GetExpiryTime write SetExpiryTime;
    property Items[const AIndex: Integer]: ISession read GetItem;
    property SessionClass: TSessionClass read GetSessionClass write SetSessionClass;
    property Sessions[const ASessionID: string]: ISession read GetSession; default;
  end;

  TSessionsBase = class abstract(TInterfacedObject, ISessions)
  protected
    function  GetCount: Integer; virtual; abstract;
    function  GetExpiryTime: Integer; virtual; abstract;
    function  GetItem(const AIndex: Integer): ISession; virtual; abstract;
    function  GetSession(const ASessionID: string): ISession; virtual; abstract;
    function  GetSessionClass: TSessionClass; virtual; abstract;
    procedure SetExpiryTime(const Value: Integer); virtual; abstract;
    procedure SetSessionClass(const Value: TSessionClass); virtual; abstract;
  public
    function  AddSession(const ASessionID: string): ISession; overload; virtual;
    function  AddSession: ISession; overload;
    procedure AddSession(const ASessionID: string; ASession: ISession); overload; virtual; abstract;
    procedure BeginRead; virtual; abstract;
    procedure BeginWrite; virtual; abstract;
    procedure Clear; virtual; abstract;
    procedure EndRead; virtual; abstract;
    procedure EndWrite; virtual; abstract;
    function  ExistsSession(const ASessionID: string; var ASession: ISession): Boolean; overload; virtual; abstract;
    function  ExistsSession(const ASessionID: string): Boolean; overload; virtual;
    function  GetEnumerator: TEnumerator<ISession>; virtual; abstract;
    function  NewSessionID: string; virtual; abstract;
    procedure RemoveSessions(const ASessions: TArray<ISession>); virtual; abstract;
    procedure RemoveSession(const ASession: ISession); overload; virtual;
    procedure RemoveSession(const ASessionID: string); overload; virtual;

    property Count: Integer read GetCount;
    property ExpiryTime: Integer read GetExpiryTime write SetExpiryTime;
    property Items[const AIndex: Integer]: ISession read GetItem;
    property SessionClass: TSessionClass read GetSessionClass write SetSessionClass;
    property Sessions[const ASessionID: string]: ISession read GetSession; default;
  end;

  TSessions = class(TSessionsBase)
  private
    FExpire: Integer;
    FExpiredProcRunning: Boolean;
    FLocker: TMultiReadExclusiveWriteSynchronizer;
    FNewGUIDFunc: TFunc<string>;
    FSessionClass: TSessionClass;
    FSessions: TDictionary<string, ISession>;
    FShutdown: Boolean;
  protected
    procedure AfterClearExpiredSessions; virtual;
    procedure BeforeClearExpiredSessions; virtual;
    procedure CreateExpiredProcThread;
    function  GetCount: Integer; override;
    function  GetExpiryTime: Integer; override;
    function  GetItem(const AIndex: Integer): ISession; override;
    function  GetSession(const ASessionID: string): ISession; override;
    function  GetSessionClass: TSessionClass; override;
    function  OnCheckExpiredSession(const ASession: ISession): Boolean; virtual;
    procedure SetExpiryTime(const Value: Integer); override;
    procedure SetSessionClass(const Value: TSessionClass); override;
  public
    constructor Create(ANewGUIDFunc: TFunc<string>); overload; virtual;
    constructor Create; overload; virtual;
    destructor Destroy; override;

    procedure AddSession(const ASessionID: string; ASession: ISession); override;
    procedure BeginRead; override;
    procedure BeginWrite; override;
    procedure Clear; override;
    procedure EndRead; override;
    procedure EndWrite; override;
    function  ExistsSession(const ASessionID: string; var ASession: ISession): Boolean; override;
    function  GetEnumerator: TEnumerator<ISession>; override;
    function  NewSessionID: string; override;
    procedure RemoveSessions(const ASessions: TArray<ISession>); override;

    property NewGUIDFunc: TFunc<string> read FNewGUIDFunc write FNewGUIDFunc;
  end;

implementation

uses
  Utils.Utils,
  Utils.DateTime;

{ TNameValue }

constructor TNameValue.Create(const AName, AValue: string);
begin
  Name := AName;
  Value := AValue;
end;

{ TBaseParams.TEnumerator }

constructor TBaseParams.TEnumerator.Create(const AList: TList<TNameValue>);
begin
  inherited Create;

  FList := AList;
  FIndex := -1;
end;

function TBaseParams.TEnumerator.DoGetCurrent: TNameValue;
begin
  Result := FList[FIndex];
end;

function TBaseParams.TEnumerator.DoMoveNext: Boolean;
begin
  if (FIndex >= FList.Count) then
    Exit(False);

  Inc(FIndex);
  Result := (FIndex < FList.Count);
end;

{ TBaseParams }

constructor TBaseParams.Create;
begin
  FParams := TList<TNameValue>.Create(TComparer<TNameValue>.Construct(
    function(const Left, Right: TNameValue): Integer
    begin
      Result := CompareText(Left.Name, Right.Name, TLocaleOptions.loUserLocale);
    end));
end;

constructor TBaseParams.Create(const AEncodedParams: string);
begin
  Create;
  Decode(AEncodedParams, True);
end;

destructor TBaseParams.Destroy;
begin
  FreeAndNil(FParams);
  inherited;
end;

procedure TBaseParams.Add(const AName, AValue: string; ADupAllowed: Boolean);
begin
  if ADupAllowed then
    FParams.Add(TNameValue.Create(AName, AValue))
  else
    SetParam(AName, AValue);
end;

procedure TBaseParams.Add(const AEncodedParams: string);
begin
  Decode(AEncodedParams, False);
end;

procedure TBaseParams.Clear;
begin
  FParams.Clear;
end;

function TBaseParams.GetParamIndex(const AName: string): Integer;
begin
  for var I := 0 to FParams.Count - 1 do
    if SameText(FParams[I].Name, AName) then
      Exit(I);

  Result := -1;
end;

function TBaseParams.GetParamValue(const AName: string; out AValue: string): Boolean;
begin
  var I := GetParamIndex(AName);
  if (I >= 0) then
  begin
    AValue := FParams[I].Value;
    Exit(True);
  end;

  Result := False;
end;

procedure TBaseParams.Remove(const AName: string);
begin
  var I := GetParamIndex(AName);
  if (I >= 0) then
    FParams.Delete(I);
end;

procedure TBaseParams.Remove(AIndex: Integer);
begin
  FParams.Delete(AIndex);
end;

function TBaseParams.GetCount: Integer;
begin
  Result := FParams.Count;
end;

function TBaseParams.GetItem(AIndex: Integer): TNameValue;
begin
  Result := FParams.Items[AIndex];
end;

function TBaseParams.DoGetEnumerator: TEnumerator<TNameValue>;
begin
  Result := TEnumerator.Create(FParams);
end;

function TBaseParams.ExistsParam(const AName: string): Boolean;
begin
  Result := (GetParamIndex(AName) >= 0);
end;

function TBaseParams.GetParam(const AName: string): string;
begin
  var I := GetParamIndex(AName);
  if (I >= 0) then
    Exit(FParams[I].Value);

  Result := '';
end;

procedure TBaseParams.SetItem(AIndex: Integer; const AValue: TNameValue);
begin
  FParams[AIndex] := AValue;
end;

procedure TBaseParams.SetParam(const AName, AValue: string);
begin
  var I := GetParamIndex(AName);
  if (I >= 0) then
  begin
    var LItem := FParams[I];
    LItem.Value := AValue;
    FParams[I] := LItem;
  end
  else
    FParams.Add(TNameValue.Create(AName, AValue));
end;

procedure TBaseParams.Sort(const AComparison: TComparison<TNameValue>);
begin
  if Assigned(AComparison) then
    FParams.Sort(TComparer<TNameValue>.Construct(AComparison))
  else
    FParams.Sort(TComparer<TNameValue>.Construct(
      function(const Left, Right: TNameValue): Integer
      begin
        Result := CompareStr(Left.Name, Right.Name, TLocaleOptions.loInvariantLocale);
      end));
end;

{ THttpUrlParams }

constructor THttpUrlParams.Create;
begin
  inherited Create;

  FEncodeName := False;
  FEncodeValue := True;
end;

procedure THttpUrlParams.Decode(const AEncodedParams: string; AClear: Boolean);
var
  p, q: PChar;
  LName, LValue: string;
  LSize: Integer;
begin
  if AClear then
    FParams.Clear;

  p := PChar(AEncodedParams);
  while (p^ <> #0) do
  begin
    q := p;
    LSize := 0;
    while (p^ <> #0) and (p^ <> '=') and (p^ <> '&') do
    begin
      Inc(LSize);
      Inc(p);
    end;
    SetLength(LName, LSize);
    Move(q^, Pointer(LName)^, LSize * SizeOf(Char));
    LName := TNetEncoding.URL.Decode(LName);
    while (p^ <> #0) and (p^ = '=') do
      Inc(p);

    q := p;
    LSize := 0;
    while (p^ <> #0) and (p^ <> '&') do
    begin
      Inc(LSize);
      Inc(p);
    end;
    SetLength(LValue, LSize);
    Move(q^, Pointer(LValue)^, LSize * SizeOf(Char));
    LValue := TNetEncoding.URL.Decode(LValue);
    while (p^ <> #0) and (p^ = '&') do
      Inc(p);

    Add(LName, LValue);
  end;
end;

function THttpUrlParams.Encode: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FParams.Count - 1 do
  begin
    if (I > 0) then
      Result := Result + '&';

    if FEncodeName then
      Result := Result + TNetEncoding.URL.Encode(FParams[I].Name)
    else
      Result := Result + FParams[I].Name;

    if FEncodeValue then
      Result := Result + '=' + TNetEncoding.URL.Encode(FParams[I].Value)
    else
      Result := Result + '=' + FParams[I].Value;
  end;
end;

{ THttpHeader }

procedure THttpHeader.Decode(const AEncodedParams: string; AClear: Boolean);
var
  p, q: PChar;
  LName, LValue: string;
  LSize: Integer;
begin
  if AClear then
    FParams.Clear;

  p := PChar(AEncodedParams);
  while (p^ <> #0) do
  begin
    q := p;
    LSize := 0;
    while (p^ <> #0) and (p^ <> ':') do
    begin
      Inc(LSize);
      Inc(p);
    end;
    SetLength(LName, LSize);
    Move(q^, Pointer(LName)^, LSize * SizeOf(Char));
    while (p^ <> #0) and ((p^ = ':') or (p^ = ' ')) do
      Inc(p);

    q := p;
    LSize := 0;
    while (p^ <> #0) and (p^ <> #13) do
    begin
      Inc(LSize);
      Inc(p);
    end;
    SetLength(LValue, LSize);
    Move(q^, Pointer(LValue)^, LSize * SizeOf(Char));
    while (p^ <> #0) and ((p^ = #13) or (p^ = #10)) do
      Inc(p);

    Add(LName, LValue);
  end;
end;

function THttpHeader.Encode: string;
begin
  Result := '';
  for var I := 0 to FParams.Count - 1 do
  begin
    Result := Result + FParams[I].Name;
    Result := Result + ': ' + FParams[I].Value + #13#10;
  end;
  Result := Result + #13#10;
end;

{ TDelimitParams }

procedure TDelimitParams.Decode(const AEncodedParams: string; AClear: Boolean);
var
  p, q: PChar;
  LName, LValue: string;
  LSize: Integer;
begin
  if AClear then
    FParams.Clear;

  p := PChar(AEncodedParams);
  while (p^ <> #0) do
  begin
    q := p;
    LSize := 0;
    while (p^ <> #0) and (p^ <> '=') do
    begin
      Inc(LSize);
      Inc(p);
    end;
    SetLength(LName, LSize);
    Move(q^, Pointer(LName)^, LSize * SizeOf(Char));
    while (p^ <> #0) and (p^ = '=') do
      Inc(p);

    q := p;
    LSize := 0;
    while (p^ <> #0) and (p^ <> FDelimiter) do
    begin
      Inc(LSize);
      Inc(p);
    end;
    SetLength(LValue, LSize);
    Move(q^, Pointer(LValue)^, LSize * SizeOf(Char));
    LValue := TNetEncoding.URL.Decode(LValue);
    while (p^ <> #0) and ((p^ = FDelimiter) or (p^ = ' ')) do
      Inc(p);

    Add(LName, LValue);
  end;
end;

function TDelimitParams.Encode: string;
begin
  Result := '';
  for var I := 0 to FParams.Count - 1 do
  begin
    if (I > 0) then
      Result := Result + FDelimiter + ' ';
    Result := Result + FParams[I].Name + '=' + TNetEncoding.URL.Encode(FParams[I].Value);
  end;
end;

{ TRequestCookies }

procedure TRequestCookies.Decode(const AEncodedParams: string; AClear: Boolean);
var
  p, q: PChar;
  LName, LValue: string;
  LSize: Integer;
begin
  if AClear then
    FParams.Clear;

  p := PChar(AEncodedParams);
  while (p^ <> #0) do
  begin
    q := p;
    LSize := 0;
    while (p^ <> #0) and (p^ <> '=') do
    begin
      Inc(LSize);
      Inc(p);
    end;
    SetLength(LName, LSize);
    Move(q^, Pointer(LName)^, LSize * SizeOf(Char));
    while (p^ <> #0) and (p^ = '=') do
      Inc(p);

    q := p;
    LSize := 0;
    while (p^ <> #0) and (p^ <> ';') do
    begin
      Inc(LSize);
      Inc(p);
    end;
    SetLength(LValue, LSize);
    Move(q^, Pointer(LValue)^, LSize * SizeOf(Char));
    LValue := TNetEncoding.URL.Decode(LValue);
    while (p^ <> #0) and ((p^ = ';') or (p^ = ' ')) do
      Inc(p);

    Add(LName, LValue);
  end;
end;

function TRequestCookies.Encode: string;
begin
  Result := '';
  for var I := 0 to FParams.Count - 1 do
  begin
    if (I > 0) then
      Result := Result + '; ';
    Result := Result + FParams[I].Name + '=' + TNetEncoding.URL.Encode(FParams[I].Value);
  end;
end;

{ TResponseCookie }

constructor TResponseCookie.Create(const AName, AValue: string; AMaxAge: Integer; const APath, ADomain: string; AHttpOnly, ASecure: Boolean);
begin
  Name := AName;
  Value := AValue;
  MaxAge := AMaxAge;
  Path := APath;
  Domain := ADomain;
  HttpOnly := AHttpOnly;
  Secure := ASecure;
end;

function TResponseCookie.Encode: string;
begin
  Result := Name + '=' + TNetEncoding.URL.Encode(Value);

  if (MaxAge > 0) then
  begin
    Result := Result + '; Max-Age=' + MaxAge.ToString;
    Result := Result + '; Expires=' + TCrossHttpUtils.RFC1123_DateToStr(Now.AddSeconds(MaxAge));
  end;

  if (Path <> '') then
    Result := Result + '; Path=' + Path;

  if (Domain <> '') then
    Result := Result + '; Domain=' + Domain;

  if HttpOnly then
    Result := Result + '; HttpOnly';

  if Secure then
    Result := Result + '; Secure';
end;

{ TFormField }

constructor TFormField.Create;
begin
end;

destructor TFormField.Destroy;
begin
  FreeValue;

  inherited;
end;

procedure TFormField.FreeValue;
begin
  if Assigned(FValue) then
    FreeAndNil(FValue);
end;

function TFormField.AsBytes: TBytes;
begin
  if (FValue = nil) or (FValue.Size <= 0) then
    Exit(nil);

  if (FValue is TBytesStream) then
  begin
    Result := TBytesStream(FValue).Bytes;
    SetLength(Result, FValue.Size);
  end
  else
  begin
    var LBytesStream := TBytesStream.Create;
    try
      LBytesStream.CopyFrom(FValue, 0);
      Result := LBytesStream.Bytes;
      SetLength(Result, LBytesStream.Size);
    finally
      FreeAndNil(LBytesStream);
    end;
  end;
end;

function TFormField.AsString(AEncoding: TEncoding): string;
begin
  if (AEncoding = nil) then
    AEncoding := TEncoding.UTF8;

  Result := AEncoding.GetString(AsBytes);
end;

{ THttpMultiPartFormData.TEnumerator }

constructor THttpMultiPartFormData.TEnumerator.Create(const AList: TList<TFormField>);
begin
  inherited Create;

  FList := AList;
  FIndex := -1;
end;

function THttpMultiPartFormData.TEnumerator.DoGetCurrent: TFormField;
begin
  Result := FList[FIndex];
end;

function THttpMultiPartFormData.TEnumerator.DoMoveNext: Boolean;
begin
  if (FIndex >= FList.Count) then
    Exit(False);

  Inc(FIndex);
  Result := (FIndex < FList.Count);
end;

{ THttpMultiPartFormData }

constructor THttpMultiPartFormData.Create;
begin
  FDecodeState := dsBoundary;
  FCurrentPartHeader := TBytesStream.Create(nil);
  FPartFields := TObjectList<TFormField>.Create(True);
end;

destructor THttpMultiPartFormData.Destroy;
begin
  Clear;
  FreeAndNil(FCurrentPartHeader);
  FreeAndNil(FPartFields);
  inherited;
end;

procedure THttpMultiPartFormData.Clear;
begin
  for var LField in FPartFields do
  begin
    if FAutoDeleteFiles and TFile.Exists(LField.FilePath) then
    begin
      LField.FreeValue;
      TFile.Delete(LField.FilePath);
    end;
  end;

  FPartFields.Clear;
end;

function THttpMultiPartFormData.DoGetEnumerator: TEnumerator<TFormField>;
begin
  Result := TEnumerator.Create(FPartFields);
end;

function THttpMultiPartFormData.FindField(const AFieldName: string; out AField: TFormField): Boolean;
begin
  var I := GetItemIndex(AFieldName);
  if (I >= 0) then
  begin
    AField := FPartFields[I];
    Exit(True);
  end;

  Result := False;
end;

function THttpMultiPartFormData.GetItem(AIndex: Integer): TFormField;
begin
  Result := FPartFields.Items[AIndex];
end;

function THttpMultiPartFormData.GetItemIndex(const AName: string): Integer;
begin
  for var I := 0 to FPartFields.Count - 1 do
    if SameText(FPartFields[I].Name, AName) then
      Exit(I);

  Result := -1;
end;

function THttpMultiPartFormData.GetCount: Integer;
begin
  Result := FPartFields.Count;
end;

function THttpMultiPartFormData.GetDataSize: Integer;
begin
  Result := 0;
  for var LPartField in FPartFields do
    Inc(Result, LPartField.FValue.Size);
end;

function THttpMultiPartFormData.GetField(const AName: string): TFormField;
begin
  var I := GetItemIndex(AName);
  if (I >= 0) then
    Exit(FPartFields[I]);

  Result := nil;
end;

procedure THttpMultiPartFormData.InitWithBoundary(const ABoundary: string);
begin
  Clear;
  FBoundary := ABoundary;
  FBoundaryBytes := TEncoding.ANSI.GetBytes(#13#10'--' + FBoundary);
  FDecodeState := dsBoundary;
  FBoundaryIndex := 0;
  FCurrentPartHeader.Clear;
  SetLength(FLookbehind, Length(FBoundaryBytes) + 8);
end;

function THttpMultiPartFormData.Decode(const ABuf: Pointer; ALen: Integer): Integer;
  function __NewFileID: string;
  begin
    Result := TUtils.GetGUID.ToLower;
  end;

  procedure __InitFormFieldByHeader(AFormField: TFormField; const AHeader: string);
  var
    LFieldHeader: THttpHeader;
    LContentDisposition: string;
    LMatch: TMatch;
  begin
    LFieldHeader := THttpHeader.Create;
    try
      LFieldHeader.Decode(AHeader);
      LContentDisposition := LFieldHeader['Content-Disposition'];
      if (LContentDisposition = '') then Exit;

      LMatch := TRegEx.Match(LContentDisposition, '\bname="(.*?)"(?=;|$)', [TRegExOption.roIgnoreCase]);
      if LMatch.Success then
        AFormField.FName := LMatch.Groups[1].Value;

      LMatch := TRegEx.Match(LContentDisposition, '\bfilename="(.*?)"(?=;|$)', [TRegExOption.roIgnoreCase]);
      if LMatch.Success then
      begin
        AFormField.FFileName := LMatch.Groups[1].Value;
        AFormField.FFilePath := TPath.Combine(FStoragePath, __NewFileID + TPath.GetExtension(AFormField.FFileName));
        if TFile.Exists(AFormField.FFilePath) then
          TFile.Delete(AFormField.FFilePath);
        AFormField.FValue := TFile.Open(AFormField.FFilePath, TFileMode.fmOpenOrCreate, TFileAccess.faReadWrite, TFileShare.fsRead);
      end
      else
        AFormField.FValue := TBytesStream.Create(nil);

      AFormField.FContentType := LFieldHeader['Content-Type'];
      AFormField.FContentTransferEncoding := LFieldHeader['Content-Transfer-Encoding'];
    finally
      FreeAndNil(LFieldHeader);
    end;
  end;
var
  C: Byte;
  I: Integer;
  P: PByteArray;
  LPartHeader: string;
begin
  if (FBoundaryBytes = nil) then
    Exit(0);

  P := ABuf;
  I := 0;
  while (I < ALen) do
  begin
    C := P[I];
    case FDecodeState of
      dsBoundary:
        begin
          if (C = FBoundaryBytes[2 + FBoundaryIndex]) then
            Inc(FBoundaryIndex)
          else
            FBoundaryIndex := 0;
          // --Boundary
          if (2 + FBoundaryIndex >= Length(FBoundaryBytes)) then
          begin
            FDecodeState := dsDetect;
            CR := 0;
            LF := 0;
            FBoundaryIndex := 0;
            FDetectHeaderIndex := 0;
            FDetectEndIndex := 0;
          end;
        end;
      dsDetect:
        begin
          if (C = DETECT_HEADER_BYTES[FDetectHeaderIndex]) then
            Inc(FDetectHeaderIndex)
          else
            FDetectHeaderIndex := 0;

          if (C = DETECT_END_BYTES[FDetectEndIndex]) then
            Inc(FDetectEndIndex)
          else
            FDetectEndIndex := 0;

          if (FDetectHeaderIndex = 0) and (FDetectEndIndex = 0) then
            Exit(I);

          if (FDetectEndIndex >= Length(DETECT_END_BYTES)) then
          begin
            FDecodeState := dsBoundary;
            CR := 0;
            LF := 0;
            FBoundaryIndex := 0;
            FDetectEndIndex := 0;
          end
          else
          if (FDetectHeaderIndex >= Length(DETECT_HEADER_BYTES)) then
          begin
            FCurrentPartHeader.Clear;
            FDecodeState := dsPartHeader;
            CR := 0;
            LF := 0;
            FBoundaryIndex := 0;
            FDetectHeaderIndex := 0;
          end;
        end;
      dsPartHeader:
        begin
          case C of
            13: Inc(CR);
            10: Inc(LF);
          else
            CR := 0;
            LF := 0;
          end;

          FCurrentPartHeader.Write(C, 1);
          if (FCurrentPartHeader.Size > MAX_PART_HEADER) then
            Exit(I);

          if (CR = 2) and (LF = 2) then
          begin
            LPartHeader := TEncoding.UTF8.GetString(FCurrentPartHeader.Bytes, 0, FCurrentPartHeader.Size - 4{#13#10#13#10});
            FCurrentPartHeader.Clear;
            FCurrentPartField := TFormField.Create;
            __InitFormFieldByHeader(FCurrentPartField, LPartHeader);
            FPartFields.Add(FCurrentPartField);

            FDecodeState := dsPartData;
            CR := 0;
            LF := 0;
            FPartDataBegin := -1;
            FBoundaryIndex := 0;
            FPrevIndex := 0;
          end;
        end;
      dsPartData:
        begin
          if (FPartDataBegin < 0) and (FPrevIndex = 0) then
            FPartDataBegin := I;

          if (C = FBoundaryBytes[FBoundaryIndex]) then
            Inc(FBoundaryIndex)
          else
          begin
            if (FBoundaryIndex > 0) then
            begin
              Dec(I);
              FBoundaryIndex := 0;
            end;

            if (FPartDataBegin < 0) then
              FPartDataBegin := I;
          end;

          if (FPrevIndex > 0) then
          begin
            if (FBoundaryIndex > 0) then
            begin
              FLookbehind[FPrevIndex] := C;
              Inc(FPrevIndex);
            end
            else
            begin
              FCurrentPartField.FValue.Write(FLookbehind[0], FPrevIndex);
              FPrevIndex := 0;
            end;
          end;

          if (I >= ALen - 1) or (FBoundaryIndex >= Length(FBoundaryBytes)) then
          begin
            if (FPartDataBegin >= 0) then
              FCurrentPartField.FValue.Write(P[FPartDataBegin], I - FPartDataBegin - FBoundaryIndex + 1);

            if (FBoundaryIndex >= Length(FBoundaryBytes)) then
            begin
              FCurrentPartField.FValue.Position := 0;
              FDecodeState := dsDetect;
              FBoundaryIndex := 0;
            end
            else
            if (FPrevIndex = 0) and (FBoundaryIndex > 0) then
            begin
              FPrevIndex := FBoundaryIndex;
              Move(P[I - FBoundaryIndex + 1], FLookbehind[0], FBoundaryIndex);
            end;

            FPartDataBegin := -1;
          end;
        end;
    end;

    Inc(I);
  end;

  Result := ALen;
end;

{ TResponseCookies }

procedure TResponseCookies.AddOrSet(const AName, AValue: string; AMaxAge: Integer; const APath, ADomain: string; AHttpOnly, ASecure: Boolean);
begin
  SetCookie(AName, TResponseCookie.Create(AName, AValue, AMaxAge, APath, ADomain, AHttpOnly, ASecure));
end;

function TResponseCookies.GetCookieIndex(const AName: string): Integer;
begin
  for var I := 0 to Count - 1 do
    if SameText(Items[I].Name, AName) then
      Exit(I);

  Result := -1;
end;

procedure TResponseCookies.Remove(const AName: string);
begin
  var I := GetCookieIndex(AName);
  if (I >= 0) then
    inherited Delete(I);
end;

function TResponseCookies.GetCookie(const AName: string): TResponseCookie;
begin
  var I := GetCookieIndex(AName);
  if (I >= 0) then
    Result := Items[I]
  else
  begin
    Result := TResponseCookie.Create(AName, '', 0);
    Add(Result);
  end;
end;

procedure TResponseCookies.SetCookie(const AName: string; const Value: TResponseCookie);
begin
  var I := GetCookieIndex(AName);
  if (I >= 0) then
    Items[I] := Value
  else
    Add(Value);
end;

{ TSessionBase }

constructor TSessionBase.Create(const AOwner: ISessions; const ASessionID: string);
begin
  var LNow := Now;

  FOwner := AOwner;

  SetSessionID(ASessionID);
  SetCreateTime(LNow);
  SetLastAccessTime(LNow);
end;

function TSessionBase.Expired: Boolean;
begin
  Result := (ExpiryTime > 0) and (Now.SecondsDiffer(LastAccessTime) >= ExpiryTime);
end;

function TSessionBase.GetOwner: ISessions;
begin
  Result := FOwner;
end;

procedure TSessionBase.Touch;
begin
  LastAccessTime := Now;
end;

{ TSession }

constructor TSession.Create(const AOwner: ISessions; const ASessionID: string);
begin
  FValues := TDictionary<string, string>.Create;

  inherited Create(AOwner, ASessionID);
end;

destructor TSession.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

function TSession.GetCreateTime: TDateTime;
begin
  Result := FCreateTime;
end;

function TSession.GetExpiryTime: Integer;
begin
  Result := FExpire;
end;

function TSession.GetLastAccessTime: TDateTime;
begin
  Result := FLastAccessTime;
end;

function TSession.GetSessionID: string;
begin
  Result := FSessionID;
end;

function TSession.GetValue(const AName: string): string;
begin
  if not FValues.TryGetValue(AName, Result) then
    Result := '';

  FLastAccessTime := Now;
end;

procedure TSession.SetCreateTime(const ACreateTime: TDateTime);
begin
  FCreateTime := ACreateTime;
end;

procedure TSession.SetExpiryTime(const AValue: Integer);
begin
  FExpire := AValue;
end;

procedure TSession.SetLastAccessTime(const ALastAccessTime: TDateTime);
begin
  FLastAccessTime := ALastAccessTime;
end;

procedure TSession.SetSessionID(const ASessionID: string);
begin
  FSessionID := ASessionID;
end;

procedure TSession.SetValue(const AName, AValue: string);
begin
  if (AValue <> '') then
    FValues.AddOrSetValue(AName, AValue)
  else
    FValues.Remove(AName);

  FLastAccessTime := Now;
end;

{ TSessionsBase }

function TSessionsBase.AddSession(const ASessionID: string): ISession;
begin
  Result := GetSessionClass.Create(Self, ASessionID);
  Result.ExpiryTime := ExpiryTime;
  AddSession(ASessionID, Result);
end;

function TSessionsBase.AddSession: ISession;
begin
  Result := AddSession(NewSessionID);
end;

function TSessionsBase.ExistsSession(const ASessionID: string): Boolean;
var
  LStuff: ISession;
begin
  Result := ExistsSession(ASessionID, LStuff);
end;

procedure TSessionsBase.RemoveSession(const ASessionID: string);
var
  LSession: ISession;
begin
  if ExistsSession(ASessionID, LSession) then
    RemoveSession(LSession);
end;

procedure TSessionsBase.RemoveSession(const ASession: ISession);
begin
  RemoveSessions([ASession]);
end;

{ TSessions }

constructor TSessions.Create(ANewGUIDFunc: TFunc<string>);
begin
  FNewGUIDFunc := ANewGUIDFunc;
  FSessions := TDictionary<string, ISession>.Create;
  FLocker := TMultiReadExclusiveWriteSynchronizer.Create;
  FSessionClass := TSession;
  CreateExpiredProcThread;
end;

constructor TSessions.Create;
begin
  Create(nil);
end;

destructor TSessions.Destroy;
begin
  FShutdown := True;
  while FExpiredProcRunning do Sleep(10);

  BeginWrite;
  FSessions.Clear;
  EndWrite;
  FreeAndNil(FLocker);
  FreeAndNil(FSessions);

  inherited;
end;

procedure TSessions.AddSession(const ASessionID: string; ASession: ISession);
begin
  if (ASession.ExpiryTime = 0) then
    ASession.ExpiryTime := ExpiryTime;
  FSessions.AddOrSetValue(ASessionID, ASession);
end;

procedure TSessions.AfterClearExpiredSessions;
begin

end;

procedure TSessions.BeforeClearExpiredSessions;
begin

end;

procedure TSessions.BeginRead;
begin
  FLocker.BeginRead;
end;

procedure TSessions.BeginWrite;
begin
  FLocker.BeginWrite;
end;

procedure TSessions.Clear;
begin
  FSessions.Clear;
end;

procedure TSessions.EndRead;
begin
  FLocker.EndRead;
end;

procedure TSessions.EndWrite;
begin
  FLocker.EndWrite;
end;

function TSessions.ExistsSession(const ASessionID: string; var ASession: ISession): Boolean;
begin
  Result := FSessions.TryGetValue(ASessionID, ASession);
  if Result then
    ASession.Touch;
end;

procedure TSessions.CreateExpiredProcThread;
begin
  TThread.CreateAnonymousThread(
    procedure
      procedure _ClearExpiredSessions;
      var
        LPair: TPair<string, ISession>;
        LDelSessions: TArray<ISession>;
      begin
        BeginWrite;
        try
          BeforeClearExpiredSessions;

          LDelSessions := nil;
          for LPair in FSessions do
          begin
            if FShutdown then
              Break;

            if OnCheckExpiredSession(LPair.Value) then
              LDelSessions := LDelSessions + [LPair.Value];
          end;
          RemoveSessions(LDelSessions);

          AfterClearExpiredSessions;
        finally
          EndWrite;
        end;
      end;
    var
      LWatch: TStopwatch;
    begin
      FExpiredProcRunning := True;
      try
        LWatch := TStopwatch.StartNew;
        while not FShutdown do
        begin
          if (FExpire > 0) and (LWatch.Elapsed.TotalMinutes >= 1) then
          begin
            _ClearExpiredSessions;
            LWatch.Reset;
            LWatch.Start;
          end;
          Sleep(10);
        end;
      finally
        FExpiredProcRunning := False;
      end;
    end).Start;
end;

function TSessions.NewSessionID: string;
begin
  if Assigned(FNewGUIDFunc) then
    Result := FNewGUIDFunc()
  else
    Result := TUtils.GetGUID.ToLower;
end;

function TSessions.OnCheckExpiredSession(const ASession: ISession): Boolean;
begin
  Result := ASession.Expired;
end;

function TSessions.GetCount: Integer;
begin
  Result := FSessions.Count;
end;

function TSessions.GetEnumerator: TEnumerator<ISession>;
begin
  Result := TDictionary<string, ISession>.TValueEnumerator.Create(FSessions);
end;

function TSessions.GetExpiryTime: Integer;
begin
  Result := FExpire;
end;

function TSessions.GetItem(const AIndex: Integer): ISession;
var
  LIndex: Integer;
  LPair: TPair<string, ISession>;
begin
  LIndex := 0;
  for LPair in FSessions do
  begin
    if (LIndex = AIndex) then
      Exit(LPair.Value);

    Inc(LIndex);
  end;
  Result := nil;
end;

function TSessions.GetSession(const ASessionID: string): ISession;
var
  LSessionID: string;
begin
  LSessionID := ASessionID;
  BeginWrite;
  try
    if (LSessionID = '') then
      LSessionID := NewSessionID;

    if not FSessions.TryGetValue(LSessionID, Result) then
    begin
      Result := FSessionClass.Create(Self, LSessionID);
      Result.ExpiryTime := ExpiryTime;
      AddSession(LSessionID, Result);
    end;
  finally
    EndWrite;
  end;

  Result.LastAccessTime := Now;
end;

function TSessions.GetSessionClass: TSessionClass;
begin
  Result := FSessionClass;
end;

procedure TSessions.RemoveSessions(const ASessions: TArray<ISession>);
var
  LSession: ISession;
begin
  for LSession in ASessions do
    FSessions.Remove(LSession.SessionID);
end;

procedure TSessions.SetExpiryTime(const Value: Integer);
begin
  FExpire := Value;
end;

procedure TSessions.SetSessionClass(const Value: TSessionClass);
begin
  FSessionClass := Value;
end;

end.
