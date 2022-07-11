// ---------------------------------------------------------------------
//
// Audio Component Suite
//
// Copyright (c) 2012-2021 WINSOFT
//
// ---------------------------------------------------------------------

unit AudioCSE;

{$ifdef VER110} // C++ Builder 3
{$ObjExportAll On}
{$endif VER110}

{$ifdef CONDITIONALEXPRESSIONS}
  {$if CompilerVersion >= 14}
    {$define D6PLUS} // Delphi 6 or higher
  {$ifend}
{$endif}

interface

uses AudioCS;

procedure Register;

implementation

{$ifdef FPC}
uses Classes, TypInfo, SysUtils, PropEdits, ComponentEditors, Dialogs, lresources, Variants;
{$else}
uses Classes, {$ifdef D6PLUS} DesignIntf, DesignEditors {$else} DsgnIntf {$endif D6PLUS}, SysUtils, TypInfo;
{$endif FPC}

// ---------------------------------------------------------------------
//
// TDeviceProperty
//

type
  TDeviceProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

function TDeviceProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TDeviceProperty.GetValues(Proc: TGetStrProc);
var
  i: Integer;
begin
  Proc(MapperDeviceName);

  if GetComponent(0) is TPlayer then
    with GetComponent(0) as TPlayer do
      for i := 0 to DeviceCount - 1 do
        Proc(IntToStr(i));

  if GetComponent(0) is TRecorder then
    with GetComponent(0) as TRecorder do
      for i := 0 to DeviceCount - 1 do
        Proc(IntToStr(i));
end;

function TDeviceProperty.GetValue: string;
begin
  Result := inherited GetValue;
  if Result = '-1' then
    Result := MapperDeviceName;
end;

procedure TDeviceProperty.SetValue(const Value: string);
begin
  if Value = MapperDeviceName then
    inherited SetValue('-1')
  else
    inherited
end;

// ---------------------------------------------------------------------
//
// TCheckedIntegerProperty
//

type
  TCheckedIntegerProperty = class(TIntegerProperty)
  public
    function GetValue: string; override;
  end;

function TCheckedIntegerProperty.GetValue: string;
begin
  try
    Result := inherited GetValue;
  except
    on E: Exception do
      Result := '(' + E.Message + ')';
  end;
end;

// ---------------------------------------------------------------------
//
// TCheckedSetElementProperty
//

type
  TCheckedSetElementProperty = class(TSetElementProperty)
    function GetValue: string; override;
  end;

function TCheckedSetElementProperty.GetValue: string;
begin
  try
    Result := inherited GetValue;
  except
    on E: Exception do
      Result := '(' + E.Message + ')';
  end;
end;

// ---------------------------------------------------------------------
//
// TCheckedSetProperty
//

type
  TCheckedSetProperty = class(TSetProperty)
  public
{$ifdef D6PLUS}
    procedure GetProperties(Proc: TGetPropProc); override;
{$else}
    procedure GetProperties(Proc: TGetPropEditProc); override;
{$endif D6PLUS}
    function GetValue: string; override;
  end;

{$ifdef D6PLUS}
procedure TCheckedSetProperty.GetProperties(Proc: TGetPropProc);
{$else}
procedure TCheckedSetProperty.GetProperties(Proc: TGetPropEditProc);
{$endif D6PLUS}
var
  i: Integer;
begin
  with GetTypeData(GetTypeData(GetPropType)^.CompType{$ifndef FPC} ^ {$endif FPC})^ do
    for i := MinValue to MaxValue do
      Proc(TCheckedSetElementProperty.Create(Self, i));
end;

function TCheckedSetProperty.GetValue: string;
begin
  try
    Result := inherited GetValue;
  except
    on E: Exception do
      Result := '(' + E.Message + ')';
  end;
end;

// ---------------------------------------------------------------------
//
// TCheckedStringProperty
//

type
  TCheckedStringProperty = class(TStringProperty)
  public
    function GetValue: string; override;
  end;

function TCheckedStringProperty.GetValue: string;
begin
  try
    Result := inherited GetValue;
  except
    on E: Exception do
      Result := '(' + E.Message + ')';
  end;
end;

// mapper used because registering set properties seems to be ignored in Delphi XE2
function SetMapper(Obj: TPersistent; PropInfo: PPropInfo): TPropertyEditorClass;
begin
  Result := nil;
  if PropInfo.PropType^.Kind = tkSet then
    if PropInfo.Name = 'Formats' then
      Result := TCheckedSetProperty
    else if PropInfo.Name = 'Supports' then
      Result := TCheckedSetProperty;
end;

procedure Register;
begin
  RegisterComponents('System', [TPlayer, TRecorder]);
  RegisterPropertyEditor(TypeInfo(Integer), TPlayer, 'Device', TDeviceProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TPlayer, 'VolumeLeft', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TPlayer, 'VolumeRight', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Word), TPlayerCapabilities, 'Manufacturer', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Word), TPlayerCapabilities, 'Product', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(string), TPlayerCapabilities, 'ProductName', TCheckedStringProperty);
  RegisterPropertyEditor(TypeInfo(Byte), TPlayerCapabilities, 'DriverMajorVersion', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Byte), TPlayerCapabilities, 'DriverMinorVersion', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Word), TPlayerCapabilities, 'Channels', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TRecorder, 'Device', TDeviceProperty);
  RegisterPropertyEditor(TypeInfo(Word), TRecorderCapabilities, 'Manufacturer', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Word), TRecorderCapabilities, 'Product', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(string), TRecorderCapabilities, 'ProductName', TCheckedStringProperty);
  RegisterPropertyEditor(TypeInfo(Byte), TRecorderCapabilities, 'DriverMajorVersion', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Byte), TRecorderCapabilities, 'DriverMinorVersion', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Word), TRecorderCapabilities, 'Channels', TCheckedIntegerProperty);
  RegisterPropertyEditor(TypeInfo(TSupports), TRecorderCapabilities, 'Supports', TCheckedSetProperty);
  RegisterPropertyEditor(TypeInfo(TFormats), TPlayerCapabilities, 'Formats', TCheckedSetProperty);
  RegisterPropertyEditor(TypeInfo(TSupports), TPlayerCapabilities, 'Supports', TCheckedSetProperty);
  RegisterPropertyEditor(TypeInfo(TFormats), TRecorderCapabilities, 'Formats', TCheckedSetProperty);
{$ifndef FPC}
  RegisterPropertyMapper(SetMapper);
{$endif FPC}
end;

{$ifdef FPC}
initialization
  {$i audiocsp.lrs}
{$endif FPC}
end.