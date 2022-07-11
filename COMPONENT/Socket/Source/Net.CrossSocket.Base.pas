{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit Net.CrossSocket.Base;

{.$DEFINE __LITTLE_PIECE__}

{$IF defined(DEBUG) or defined(madExcept)}
  {$DEFINE __DEBUG__}
{$ENDIF}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  System.Generics.Collections,
  Net.SocketAPI;

const
  UID_RAW        = $0;
  UID_LISTEN     = $1;
  UID_CONNECTION = $2;

  UID_MASK       = UInt64($3FFFFFFFFFFFFFFF);

  IPv4_ALL   = '0.0.0.0';
  IPv6_ALL   = '::';
  IPv4v6_ALL = '';
  IPv4_LOCAL = '127.0.0.1';
  IPv6_LOCAL = '::1';

type
  ECrossSocket = class(Exception);

  ICrossSocket = interface;
  ICrossListen = interface;
  ICrossConnection = interface;
  TAbstractCrossSocket = class;
  TIoEventThread = class;

  TConnectType = (
    ctUnknown,
    ctAccept,
    ctConnect
  );

  TConnectStatus = (
    csUnknown,
    csConnecting,
    csHandshaking,
    csConnected,
    csDisconnected,
    csClosed
  );

  TCrossConnectionCallback = reference to procedure(const AConnection: ICrossConnection; const AResult: Boolean);
  TCrossListenCallback = reference to procedure(const AListen: ICrossListen; const AResult: Boolean);

  ICrossData = interface
  ['{988404A3-D297-4C6D-9A76-16E50553596E}']
    procedure Close;
    function  GetIsClosed: Boolean;
    function  GetLocalAddr: string;
    function  GetLocalPort: Word;
    function  GetOwner: ICrossSocket;
    function  GetSocket: THandle;
    function  GetTag: Integer;
    function  GetUID: UInt64;
    function  GetUserData: Pointer;
    function  GetUserObject: TObject;
    function  GetUserInterface: IInterface;
    procedure SetTag(const AValue: Integer);
    procedure SetUserData(const AValue: Pointer);
    procedure SetUserObject(const AValue: TObject);
    procedure SetUserInterface(const AValue: IInterface);
    procedure UpdateAddr;

    property IsClosed: Boolean read GetIsClosed;
    property LocalAddr: string read GetLocalAddr;
    property LocalPort: Word read GetLocalPort;
    property Owner: ICrossSocket read GetOwner;
    property Socket: THandle read GetSocket;
    property Tag: Integer read GetTag write SetTag;
    property UID: UInt64 read GetUID;
    property UserData: Pointer read GetUserData write SetUserData;
    property UserObject: TObject read GetUserObject write SetUserObject;
    property UserInterface: IInterface read GetUserInterface write SetUserInterface;
  end;

  TCrossDatas = TDictionary<UInt64, ICrossData>;

  ICrossListen = interface(ICrossData)
  ['{4008919E-8F16-4BBD-A68D-2FD1DE630702}']
    function GetFamily: Integer;
    function GetProtocol: Integer;
    function GetSockType: Integer;

    property Family: Integer read GetFamily;
    property Protocol: Integer read GetProtocol;
    property SockType: Integer read GetSockType;
  end;

  TCrossListens = TDictionary<UInt64, ICrossListen>;

  ICrossConnection = interface(ICrossData)
  ['{13C2A39E-C918-49B9-BBD3-A99110F94D1B}']
    procedure Disconnect;
    function  GetConnectStatus: TConnectStatus;
    function  GetConnectType: TConnectType;
    function  GetPeerAddr: string;
    function  GetPeerPort: Word;
    procedure SendBuf(const ABuffer: Pointer; const ACount: Integer; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendBuf(const ABuffer; const ACount: Integer; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendBytes(const ABytes: TBytes; const AOffset, ACount: Integer; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendBytes(const ABytes: TBytes; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendStream(const AStream: TStream; const ACallback: TCrossConnectionCallback = nil);
    procedure SetConnectStatus(const AValue: TConnectStatus);

    property ConnectStatus: TConnectStatus read GetConnectStatus write SetConnectStatus;
    property ConnectType: TConnectType read GetConnectType;
    property PeerAddr: string read GetPeerAddr;
    property PeerPort: Word read GetPeerPort;
  end;
  TCrossConnections = TDictionary<UInt64, ICrossConnection>;

  TCrossConnectEvent = procedure(const Sender: TObject; const AConnection: ICrossConnection) of object;
  TCrossDataEvent = procedure(const Sender: TObject; const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer) of object;
  TCrossIoThreadEvent = procedure(const Sender: TObject; const AIoThread: TIoEventThread) of object;
  TCrossListenEvent = procedure(const Sender: TObject; const AListen: ICrossListen) of object;

  ICrossSocket = interface
  ['{2371CC3F-EB38-4C5D-8FA9-C913B9CD37A0}']
    function  GetConnectionsCount: Integer;
    function  GetIoThreads: Integer;
    function  GetListensCount: Integer;
    function  GetOnConnected: TCrossConnectEvent;
    function  GetOnDisconnected: TCrossConnectEvent;
    function  GetOnIoThreadBegin: TCrossIoThreadEvent;
    function  GetOnIoThreadEnd: TCrossIoThreadEvent;
    function  GetOnListened: TCrossListenEvent;
    function  GetOnListenEnd: TCrossListenEvent;
    function  GetOnReceived: TCrossDataEvent;
    function  GetOnSent: TCrossDataEvent;
    procedure SetOnIoThreadBegin(const AValue: TCrossIoThreadEvent);
    procedure SetOnIoThreadEnd(const AValue: TCrossIoThreadEvent);
    procedure SetOnConnected(const AValue: TCrossConnectEvent);
    procedure SetOnDisconnected(const AValue: TCrossConnectEvent);
    procedure SetOnListened(const AValue: TCrossListenEvent);
    procedure SetOnListenEnd(const AValue: TCrossListenEvent);
    procedure SetOnReceived(const AValue: TCrossDataEvent);
    procedure SetOnSent(const AValue: TCrossDataEvent);

    procedure CloseAll;
    procedure CloseAllConnections;
    procedure CloseAllListens;
    procedure Connect(const AHost: string; const APort: Word; const ACallback: TCrossConnectionCallback = nil);
    function  CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection;
    function  CreateListen(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer): ICrossListen;
    procedure DisconnectAll;
    procedure Listen(const AHost: string; const APort: Word; const ACallback: TCrossListenCallback = nil);
    function  LockConnections: TCrossConnections;
    function  LockListens: TCrossListens;
    function  ProcessIoEvent: Boolean;
    procedure Send(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback = nil);
    procedure StartLoop;
    procedure StopLoop;
    procedure TriggerConnecting(const AConnection: ICrossConnection);
    procedure TriggerConnected(const AConnection: ICrossConnection);
    procedure TriggerDisconnected(const AConnection: ICrossConnection);
    procedure TriggerIoThreadBegin(const AIoThread: TIoEventThread);
    procedure TriggerIoThreadEnd(const AIoThread: TIoEventThread);
    procedure TriggerListened(const AListen: ICrossListen);
    procedure TriggerListenEnd(const AListen: ICrossListen);
    procedure UnlockConnections;
    procedure UnlockListens;

    property ConnectionsCount: Integer read GetConnectionsCount;
    property IoThreads: Integer read GetIoThreads;
    property ListensCount: Integer read GetListensCount;

    property OnConnected: TCrossConnectEvent read GetOnConnected write SetOnConnected;
    property OnDisconnected: TCrossConnectEvent read GetOnDisconnected write SetOnDisconnected;
    property OnIoThreadBegin: TCrossIoThreadEvent read GetOnIoThreadBegin write SetOnIoThreadBegin;
    property OnIoThreadEnd: TCrossIoThreadEvent read GetOnIoThreadEnd write SetOnIoThreadEnd;
    property OnListened: TCrossListenEvent read GetOnListened write SetOnListened;
    property OnListenEnd: TCrossListenEvent read GetOnListenEnd write SetOnListenEnd;
    property OnReceived: TCrossDataEvent read GetOnReceived write SetOnReceived;
    property OnSent: TCrossDataEvent read GetOnSent write SetOnSent;
  end;

  TCrossData = class abstract(TInterfacedObject, ICrossData)
  private
    class var
      FCrossUID: UInt64;
  private
    FLocalAddr: string;
    FLocalPort: Word;
    [unsafe]FOwner: ICrossSocket;
    FSocket: THandle;
    FTag: Integer;
    FUID: UInt64;
    FUserData: Pointer;
    FUserObject: TObject;
    FUserInterface: IInterface;
  protected
    function  GetIsClosed: Boolean; virtual; abstract;
    function  GetLocalAddr: string;
    function  GetLocalPort: Word;
    function  GetOwner: ICrossSocket;
    function  GetTag: Integer;
    function  GetUID: UInt64;
    function  GetUIDTag: Byte; virtual;
    function  GetSocket: THandle;
    procedure SetTag(const Value: Integer);
    function  GetUserData: Pointer;
    function  GetUserInterface: IInterface;
    function  GetUserObject: TObject;
    procedure SetUserData(const AValue: Pointer);
    procedure SetUserInterface(const AValue: IInterface);
    procedure SetUserObject(const AValue: TObject);
  public
    constructor Create(const AOwner: ICrossSocket; const ASocket: THandle); virtual;
    destructor Destroy; override;

    procedure Close; virtual; abstract;
    procedure UpdateAddr; virtual;

    property IsClosed: Boolean read GetIsClosed;
    property LocalAddr: string read GetLocalAddr;
    property LocalPort: Word read GetLocalPort;
    property Owner: ICrossSocket read GetOwner;
    property Socket: THandle read GetSocket;
    property Tag: Integer read GetTag write SetTag;
    property UID: UInt64 read GetUID;
    property UserData: Pointer read GetUserData write SetUserData;
    property UserInterface: IInterface read GetUserInterface write SetUserInterface;
    property UserObject: TObject read GetUserObject write SetUserObject;
  end;

  TAbstractCrossListen = class(TCrossData, ICrossListen)
  private
    FClosed: Integer;
    FFamily: Integer;
    FProtocol: Integer;
    FSockType: Integer;
  protected
    function  GetFamily: Integer;
    function  GetIsClosed: Boolean; override;
    function  GetProtocol: Integer;
    function  GetSockType: Integer;
    function  GetUIDTag: Byte; override;
  public
    constructor Create(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer); reintroduce; virtual;

    procedure Close; override;

    property IsClosed: Boolean read GetIsClosed;
    property LocalAddr: string read GetLocalAddr;
    property LocalPort: Word read GetLocalPort;
    property Owner: ICrossSocket read GetOwner;
    property Socket: THandle read GetSocket;
  end;

  TAbstractCrossConnection = class(TCrossData, ICrossConnection)
  public const
    SND_BUF_SIZE = 32768;
  private
    FConnectStatus: Integer;
    FConnectType: TConnectType;
    FPeerAddr: string;
    FPeerPort: Word;
  protected
    procedure DirectSend(const ABuffer: Pointer; const ACount: Integer; const ACallback: TCrossConnectionCallback = nil); virtual;
    function  GetConnectStatus: TConnectStatus;
    function  GetConnectType: TConnectType;
    function  GetIsClosed: Boolean; override;
    function  GetPeerAddr: string;
    function  GetPeerPort: Word;
    function  GetUIDTag: Byte; override;
    function _SetConnectStatus(const AStatus: TConnectStatus): TConnectStatus; inline;
    procedure SetConnectStatus(const AValue: TConnectStatus);
  public
    constructor Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType); reintroduce; virtual;

    procedure Close; override;
    procedure Disconnect; virtual;
    procedure SendBuf(const ABuffer: Pointer; const ACount: Integer; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendBuf(const ABuffer; const ACount: Integer; const ACallback: TCrossConnectionCallback = nil); overload; inline;
    procedure SendBytes(const ABytes: TBytes; const AOffset, ACount: Integer; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendBytes(const ABytes: TBytes; const ACallback: TCrossConnectionCallback = nil); overload; inline;
    procedure SendStream(const AStream: TStream; const ACallback: TCrossConnectionCallback = nil);
    procedure UpdateAddr; override;

    property ConnectStatus: TConnectStatus read GetConnectStatus write SetConnectStatus;
    property ConnectType: TConnectType read GetConnectType;
    property IsClosed: Boolean read GetIsClosed;
    property LocalAddr: string read GetLocalAddr;
    property LocalPort: Word read GetLocalPort;
    property Owner: ICrossSocket read GetOwner;
    property PeerAddr: string read GetPeerAddr;
    property PeerPort: Word read GetPeerPort;
    property Socket: THandle read GetSocket;
  end;

  TIoEventThread = class(TThread)
  private
    [unsafe]FCrossSocket: ICrossSocket;
  protected
    procedure Execute; override;
  public
    constructor Create(const ACrossSocket: ICrossSocket); reintroduce;
  end;

  TAbstractCrossSocket = class abstract(TInterfacedObject, ICrossSocket)
  protected
    const
      RCV_BUF_SIZE = 32768;
  protected
    class threadvar
      FRecvBuf: array [0..RCV_BUF_SIZE-1] of Byte;
  protected
    FIoThreads: Integer;

    function SetKeepAlive(const ASocket: THandle): Integer;
  private
    FConnections: TCrossConnections;
    FConnectionsLock: TObject;
    FListens: TCrossListens;
    FListensLock: TObject;

    FOnConnected: TCrossConnectEvent;
    FOnDisconnected: TCrossConnectEvent;
    FOnListened: TCrossListenEvent;
    FOnListenEnd: TCrossListenEvent;
    FOnIoThreadBegin: TCrossIoThreadEvent;
    FOnIoThreadEnd: TCrossIoThreadEvent;
    FOnReceived: TCrossDataEvent;
    FOnSent: TCrossDataEvent;

    procedure _LockConnections; inline;
    procedure _LockListens; inline;
    procedure _UnlockConnections; inline;
    procedure _UnlockListens; inline;
    function  GetConnectionsCount: Integer;
    function  GetListensCount: Integer;
    function  GetOnConnected: TCrossConnectEvent;
    function  GetOnDisconnected: TCrossConnectEvent;
    function  GetOnIoThreadBegin: TCrossIoThreadEvent;
    function  GetOnIoThreadEnd: TCrossIoThreadEvent;
    function  GetOnListened: TCrossListenEvent;
    function  GetOnListenEnd: TCrossListenEvent;
    function  GetOnReceived: TCrossDataEvent;
    function  GetOnSent: TCrossDataEvent;
    procedure SetOnConnected(const AValue: TCrossConnectEvent);
    procedure SetOnDisconnected(const AValue: TCrossConnectEvent);
    procedure SetOnIoThreadBegin(const AValue: TCrossIoThreadEvent);
    procedure SetOnIoThreadEnd(const AValue: TCrossIoThreadEvent);
    procedure SetOnListened(const AValue: TCrossListenEvent);
    procedure SetOnListenEnd(const AValue: TCrossListenEvent);
    procedure SetOnReceived(const AValue: TCrossDataEvent);
    procedure SetOnSent(const AValue: TCrossDataEvent);
  protected
    FConnectionsCount: Integer;
    FListensCount: Integer;

    procedure CloseAll; virtual;
    procedure CloseAllConnections; virtual;
    procedure CloseAllListens; virtual;
    procedure Connect(const AHost: string; const APort: Word; const ACallback: TCrossConnectionCallback = nil); virtual; abstract;
    function  CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection; virtual; abstract;
    function  CreateListen(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer): ICrossListen; virtual; abstract;
    procedure DisconnectAll; virtual;
    function  GetIoThreads: Integer; virtual;
    procedure Listen(const AHost: string; const APort: Word; const ACallback: TCrossListenCallback = nil); virtual; abstract;
    procedure LogicConnected(const AConnection: ICrossConnection); virtual;
    procedure LogicDisconnected(const AConnection: ICrossConnection); virtual;
    procedure LogicReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer); virtual;
    procedure LogicSent(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer); virtual;
    function  ProcessIoEvent: Boolean; virtual; abstract;
    procedure Send(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer; const ACallback: TCrossConnectionCallback = nil); virtual; abstract;
    procedure StartLoop; virtual; abstract;
    procedure StopLoop; virtual; abstract;
    procedure TriggerConnected(const AConnection: ICrossConnection); virtual;
    procedure TriggerConnecting(const AConnection: ICrossConnection); virtual;
    procedure TriggerDisconnected(const AConnection: ICrossConnection); virtual;
    procedure TriggerIoThreadBegin(const AIoThread: TIoEventThread); virtual;
    procedure TriggerIoThreadEnd(const AIoThread: TIoEventThread); virtual;
    procedure TriggerListened(const AListen: ICrossListen); virtual;
    procedure TriggerListenEnd(const AListen: ICrossListen); virtual;
    procedure TriggerReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer); virtual;
    procedure TriggerSent(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer); virtual;
  public
    constructor Create(const AIoThreads: Integer); virtual;
    destructor Destroy; override;

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function  LockConnections: TCrossConnections;
    function  LockListens: TCrossListens;
    procedure UnlockConnections;
    procedure UnlockListens;

    property ConnectionsCount: Integer read GetConnectionsCount;
    property IoThreads: Integer read GetIoThreads;
    property ListensCount: Integer read GetListensCount;

    property OnConnected: TCrossConnectEvent read GetOnConnected write SetOnConnected;
    property OnDisconnected: TCrossConnectEvent read GetOnDisconnected write SetOnDisconnected;
    property OnIoThreadBegin: TCrossIoThreadEvent read GetOnIoThreadBegin write SetOnIoThreadBegin;
    property OnIoThreadEnd: TCrossIoThreadEvent read GetOnIoThreadEnd write SetOnIoThreadEnd;
    property OnListened: TCrossListenEvent read GetOnListened write SetOnListened;
    property OnListenEnd: TCrossListenEvent read GetOnListenEnd write SetOnListenEnd;
    property OnReceived: TCrossDataEvent read GetOnReceived write SetOnReceived;
    property OnSent: TCrossDataEvent read GetOnSent write SetOnSent;
  end;

  function  GetTagByUID(const AUID: UInt64): Byte;
  procedure _LogLastOsError(const ATag: string = '');
  procedure _Log(const S: string); overload;
  procedure _Log(const Fmt: string; const Args: array of const); overload;

implementation

uses
  Utils.Logger;

{$REGION 'Utilites'}

function GetTagByUID(const AUID: UInt64): Byte;
begin
  Result := (AUID shr 62) and $03;
end;

procedure _Log(const S: string); overload;
begin
  if IsConsole then
    Writeln(S)
  else
    AppendLog(S);
end;

procedure _Log(const Fmt: string; const Args: array of const); overload;
begin
  _Log(Format(Fmt, Args));
end;

procedure _LogLastOsError(const ATag: string);
{$IFDEF __DEBUG__}
var
  LError: Integer;
  LErrMsg: string;
{$ENDIF}
begin
  {$IFDEF __DEBUG__}
  LError := GetLastError;
  if (ATag <> '') then
    LErrMsg := ATag + ' : '
  else
    LErrMsg := '';

  LErrMsg := LErrMsg + Format('System Error.  Code: %0:d(%0:.4x), %1:s', [LError, SysErrorMessage(LError)]);
  _Log(LErrMsg);
  {$ENDIF}
end;

{$ENDREGION}

{ TIoEventThread }

constructor TIoEventThread.Create(const ACrossSocket: ICrossSocket);
begin
  inherited Create(True);

  FCrossSocket := ACrossSocket;
  Suspended := False;
end;

procedure TIoEventThread.Execute;
var
  LCrossSocketObj: TAbstractCrossSocket;
begin
  LCrossSocketObj := FCrossSocket as TAbstractCrossSocket;
  try
    LCrossSocketObj.TriggerIoThreadBegin(Self);
    while not Terminated do
    begin
      try
        if not LCrossSocketObj.ProcessIoEvent then
          Break;
      except
        {$IFDEF __DEBUG__}
        on e: Exception do
          _Log('%s Io ThreadID %d, Exception: %s, %s', [LCrossSocketObj.ClassName, Self.ThreadID, e.ClassName, e.Message]);
        {$ENDIF}
      end;
    end;
  finally
    LCrossSocketObj.TriggerIoThreadEnd(Self);
  end;
end;

{ TAbstractCrossSocket }

procedure TAbstractCrossSocket.CloseAll;
begin
  CloseAllListens;
  CloseAllConnections;
end;

procedure TAbstractCrossSocket.CloseAllConnections;
var
  LLConnectionArr: TArray<ICrossConnection>;
  LConnection: ICrossConnection;
begin
  _LockConnections;
  try
    LLConnectionArr := FConnections.Values.ToArray;
  finally
    _UnlockConnections;
  end;

  for LConnection in LLConnectionArr do
    LConnection.Close;
end;

procedure TAbstractCrossSocket.CloseAllListens;
var
  LListenArr: TArray<ICrossListen>;
begin
  _LockListens;
  try
    LListenArr := FListens.Values.ToArray;
  finally
    _UnlockListens;
  end;

  for var LListen in LListenArr do
    LListen.Close;
end;

constructor TAbstractCrossSocket.Create(const AIoThreads: Integer);
begin
  FIoThreads := AIoThreads;

  FListens := TCrossListens.Create;
  FListensLock := TObject.Create;

  FConnections := TCrossConnections.Create;
  FConnectionsLock := TObject.Create;
end;

destructor TAbstractCrossSocket.Destroy;
begin
  FreeAndNil(FListens);
  FreeAndNil(FListensLock);

  FreeAndNil(FConnections);
  FreeAndNil(FConnectionsLock);

  inherited;
end;

procedure TAbstractCrossSocket.DisconnectAll;
var
  LLConnectionArr: TArray<ICrossConnection>;
  LConnection: ICrossConnection;
begin
  _LockConnections;
  try
    LLConnectionArr := FConnections.Values.ToArray;
  finally
    _UnlockConnections;
  end;

  for LConnection in LLConnectionArr do
    LConnection.Disconnect;
end;

procedure TAbstractCrossSocket.AfterConstruction;
begin
  StartLoop;
  inherited AfterConstruction;
end;

procedure TAbstractCrossSocket.BeforeDestruction;
begin
  StopLoop;
  inherited BeforeDestruction;
end;

function TAbstractCrossSocket.GetConnectionsCount: Integer;
begin
  Result := FConnectionsCount;
end;

function TAbstractCrossSocket.GetIoThreads: Integer;
begin
  if (FIoThreads > 0) then
    Result := FIoThreads
  else
    Result := CPUCount * 2 + 1;
end;

function TAbstractCrossSocket.GetListensCount: Integer;
begin
  Result := FListensCount;
end;

function TAbstractCrossSocket.GetOnConnected: TCrossConnectEvent;
begin
  Result := FOnConnected;
end;

function TAbstractCrossSocket.GetOnDisconnected: TCrossConnectEvent;
begin
  Result := FOnDisconnected;
end;

function TAbstractCrossSocket.GetOnIoThreadBegin: TCrossIoThreadEvent;
begin
  Result := FOnIoThreadBegin;
end;

function TAbstractCrossSocket.GetOnIoThreadEnd: TCrossIoThreadEvent;
begin
  Result := FOnIoThreadEnd;
end;

function TAbstractCrossSocket.GetOnListened: TCrossListenEvent;
begin
  Result := FOnListened;
end;

function TAbstractCrossSocket.GetOnListenEnd: TCrossListenEvent;
begin
  Result := FOnListenEnd;
end;

function TAbstractCrossSocket.GetOnReceived: TCrossDataEvent;
begin
  Result := FOnReceived;
end;

function TAbstractCrossSocket.GetOnSent: TCrossDataEvent;
begin
  Result := FOnSent;
end;

function TAbstractCrossSocket.LockConnections: TCrossConnections;
begin
  _LockConnections;
  Result := FConnections;
end;

function TAbstractCrossSocket.LockListens: TCrossListens;
begin
  _LockListens;
  Result := FListens;
end;

procedure TAbstractCrossSocket.LogicConnected(const AConnection: ICrossConnection);
begin

end;

procedure TAbstractCrossSocket.LogicDisconnected(const AConnection: ICrossConnection);
begin

end;

procedure TAbstractCrossSocket.LogicReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer);
begin

end;

procedure TAbstractCrossSocket.LogicSent(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer);
begin

end;

function TAbstractCrossSocket.SetKeepAlive(const ASocket: THandle): Integer;
begin
  Result := TSocketAPI.SetKeepAlive(ASocket, 5, 3, 5);
end;

procedure TAbstractCrossSocket.SetOnConnected(const AValue: TCrossConnectEvent);
begin
  FOnConnected := AValue;
end;

procedure TAbstractCrossSocket.SetOnDisconnected(const AValue: TCrossConnectEvent);
begin
  FOnDisconnected := AValue;
end;

procedure TAbstractCrossSocket.SetOnIoThreadBegin(const AValue: TCrossIoThreadEvent);
begin
  FOnIoThreadBegin := AValue;
end;

procedure TAbstractCrossSocket.SetOnIoThreadEnd(const AValue: TCrossIoThreadEvent);
begin
  FOnIoThreadEnd := AValue;
end;

procedure TAbstractCrossSocket.SetOnListened(const AValue: TCrossListenEvent);
begin
  FOnListened := AValue;
end;

procedure TAbstractCrossSocket.SetOnListenEnd(const AValue: TCrossListenEvent);
begin
  FOnListenEnd := AValue;
end;

procedure TAbstractCrossSocket.SetOnReceived(const AValue: TCrossDataEvent);
begin
  FOnReceived := AValue;
end;

procedure TAbstractCrossSocket.SetOnSent(const AValue: TCrossDataEvent);
begin
  FOnSent := AValue;
end;

procedure TAbstractCrossSocket.TriggerConnecting(const AConnection: ICrossConnection);
begin
  AConnection.ConnectStatus := csConnecting;

  _LockConnections;
  try
    FConnections.AddOrSetValue(AConnection.UID, AConnection);
    FConnectionsCount := FConnections.Count;
  finally
    _UnlockConnections;
  end;
end;

procedure TAbstractCrossSocket.TriggerConnected(const AConnection: ICrossConnection);
begin
  AConnection.UpdateAddr;
  AConnection.ConnectStatus := csConnected;

  LogicConnected(AConnection);

  if Assigned(FOnConnected) then
    FOnConnected(Self, AConnection);
end;

procedure TAbstractCrossSocket.TriggerDisconnected(const AConnection: ICrossConnection);
begin
  AConnection.ConnectStatus := csClosed;

  _LockConnections;
  try
    FConnections.Remove(AConnection.UID);
    FConnectionsCount := FConnections.Count;
  finally
    _UnlockConnections;
  end;

  LogicDisconnected(AConnection);

  if Assigned(FOnDisconnected) then
    FOnDisconnected(Self, AConnection);
end;

procedure TAbstractCrossSocket.TriggerIoThreadBegin(const AIoThread: TIoEventThread);
begin
  if Assigned(FOnIoThreadBegin) then
    FOnIoThreadBegin(Self, AIoThread);
end;

procedure TAbstractCrossSocket.TriggerIoThreadEnd(const AIoThread: TIoEventThread);
begin
  if Assigned(FOnIoThreadEnd) then
    FOnIoThreadEnd(Self, AIoThread);
end;

procedure TAbstractCrossSocket.TriggerListened(const AListen: ICrossListen);
begin
  AListen.UpdateAddr;

  _LockListens;
  try
    FListens.AddOrSetValue(AListen.UID, AListen);
    FListensCount := FListens.Count;
  finally
    _UnlockListens;
  end;

  if Assigned(FOnListened) then
    FOnListened(Self, AListen);
end;

procedure TAbstractCrossSocket.TriggerListenEnd(const AListen: ICrossListen);
begin
  _LockListens;
  try
    FListens.Remove(AListen.UID);
    FListensCount := FListens.Count;
  finally
    _UnlockListens;
  end;

  if Assigned(FOnListenEnd) then
    FOnListenEnd(Self, AListen);
end;

procedure TAbstractCrossSocket.TriggerReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer);
begin
  LogicReceived(AConnection, ABuf, ALen);

  if Assigned(FOnReceived) then
    FOnReceived(Self, AConnection, ABuf, ALen);
end;

procedure TAbstractCrossSocket.TriggerSent(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer);
begin
  LogicSent(AConnection, ABuf, ALen);

  if Assigned(FOnSent) then
    FOnSent(Self, AConnection, ABuf, ALen);
end;

procedure TAbstractCrossSocket.UnlockConnections;
begin
  _UnlockConnections;
end;

procedure TAbstractCrossSocket.UnlockListens;
begin
  _UnlockListens;
end;

procedure TAbstractCrossSocket._LockConnections;
begin
  System.TMonitor.Enter(FConnectionsLock);
end;

procedure TAbstractCrossSocket._LockListens;
begin
  System.TMonitor.Enter(FListensLock);
end;

procedure TAbstractCrossSocket._UnlockConnections;
begin
  System.TMonitor.Exit(FConnectionsLock);
end;

procedure TAbstractCrossSocket._UnlockListens;
begin
  System.TMonitor.Exit(FListensLock);
end;

{ TCrossData }

constructor TCrossData.Create(const AOwner: ICrossSocket; const ASocket: THandle);
begin
  FUID := (UInt64(GetUIDTag and $03) shl 62) or (UID_MASK and AtomicIncrement(FCrossUID));
  FOwner := AOwner;
  FSocket := ASocket;
  FTag := 0;
end;

destructor TCrossData.Destroy;
begin
  if (FSocket <> INVALID_HANDLE_VALUE) then
  begin
    TSocketAPI.CloseSocket(FSocket);
    FSocket := INVALID_HANDLE_VALUE;
  end;

  inherited;
end;

function TCrossData.GetLocalAddr: string;
begin
  Result := FLocalAddr;
end;

function TCrossData.GetLocalPort: Word;
begin
  Result := FLocalPort;
end;

function TCrossData.GetOwner: ICrossSocket;
begin
  Result := FOwner;
end;

function TCrossData.GetSocket: THandle;
begin
  Result := FSocket;
end;

function TCrossData.GetTag: Integer;
begin
  Result := FTag;
end;

function TCrossData.GetUID: UInt64;
begin
  Result := FUID;
end;

function TCrossData.GetUIDTag: Byte;
begin
  Result := UID_RAW;
end;

function TCrossData.GetUserData: Pointer;
begin
  Result := FUserData;
end;

function TCrossData.GetUserInterface: IInterface;
begin
  Result := FUserInterface;
end;

function TCrossData.GetUserObject: TObject;
begin
  Result := FUserObject;
end;

procedure TCrossData.SetTag(const Value: Integer);
begin
  FTag := Value;
end;

procedure TCrossData.SetUserData(const AValue: Pointer);
begin
  FUserData := AValue;
end;

procedure TCrossData.SetUserInterface(const AValue: IInterface);
begin
  FUserInterface := AValue;
end;

procedure TCrossData.SetUserObject(const AValue: TObject);
begin
  FUserObject := AValue;
end;

procedure TCrossData.UpdateAddr;
var
  LAddr: TRawSockAddrIn;
begin
  FillChar(LAddr, SizeOf(TRawSockAddrIn), 0);
  LAddr.AddrLen := SizeOf(LAddr.Addr6);
  if (TSocketAPI.GetSockName(FSocket, @LAddr.Addr, LAddr.AddrLen) = 0) then
    TSocketAPI.ExtractAddrInfo(@LAddr.Addr, LAddr.AddrLen, FLocalAddr, FLocalPort);
end;

{ TAbstractCrossListen }

constructor TAbstractCrossListen.Create(const AOwner: ICrossSocket; const AListenSocket: THandle; const AFamily, ASockType, AProtocol: Integer);
begin
  inherited Create(AOwner, AListenSocket);

  FFamily := AFamily;
  FSockType := ASockType;
  FProtocol := AProtocol;

  FClosed := 0;
end;

procedure TAbstractCrossListen.Close;
begin
  if (AtomicExchange(FClosed, 1) = 1) then
    Exit;

  if (FSocket <> INVALID_HANDLE_VALUE) then
  begin
    TSocketAPI.CloseSocket(FSocket);
    FOwner.TriggerListenEnd(Self);
    FSocket := INVALID_HANDLE_VALUE;
  end;
end;

function TAbstractCrossListen.GetFamily: Integer;
begin
  Result := FFamily;
end;

function TAbstractCrossListen.GetIsClosed: Boolean;
begin
  Result := (FClosed = 1);
end;

function TAbstractCrossListen.GetProtocol: Integer;
begin
  Result := FProtocol;
end;

function TAbstractCrossListen.GetSockType: Integer;
begin
  Result := FSockType;
end;

function TAbstractCrossListen.GetUIDTag: Byte;
begin
  Result := UID_LISTEN;
end;

{ TAbstractCrossConnection }

constructor TAbstractCrossConnection.Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType);
begin
  inherited Create(AOwner, AClientSocket);

  FConnectType := AConnectType;
end;

procedure TAbstractCrossConnection.SetConnectStatus(const AValue: TConnectStatus);
begin
  _SetConnectStatus(AValue);
end;

procedure TAbstractCrossConnection.Close;
begin
  if (_SetConnectStatus(csClosed) = csClosed) then
    Exit;

  if (FSocket <> INVALID_HANDLE_VALUE) then
  begin
    TSocketAPI.CloseSocket(FSocket);
    FOwner.TriggerDisconnected(Self);
    FSocket := INVALID_HANDLE_VALUE;
  end;
end;

procedure TAbstractCrossConnection.DirectSend(const ABuffer: Pointer; const ACount: Integer; const ACallback: TCrossConnectionCallback);
begin
  if (FSocket = INVALID_HANDLE_VALUE) or IsClosed then
  begin
    if Assigned(ACallback) then
      ACallback(Self, False);
    Exit;
  end;

  var LBuffer := ABuffer;
  FOwner.Send(Self, LBuffer, ACount,
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      if ASuccess then
        (FOwner as TAbstractCrossSocket).TriggerSent(AConnection, LBuffer, ACount);

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TAbstractCrossConnection.Disconnect;
begin
  if (_SetConnectStatus(csDisconnected) in [csDisconnected, csClosed]) then
    Exit;

  TSocketAPI.Shutdown(FSocket, 2);
end;

function TAbstractCrossConnection.GetConnectStatus: TConnectStatus;
begin
  Result := TConnectStatus(AtomicCmpExchange(FConnectStatus, 0, 0));
end;

function TAbstractCrossConnection.GetConnectType: TConnectType;
begin
  Result := FConnectType;
end;

function TAbstractCrossConnection.GetIsClosed: Boolean;
begin
  Result := (GetConnectStatus = csClosed);
end;

function TAbstractCrossConnection.GetPeerAddr: string;
begin
  Result := FPeerAddr;
end;

function TAbstractCrossConnection.GetPeerPort: Word;
begin
  Result := FPeerPort;
end;

function TAbstractCrossConnection.GetUIDTag: Byte;
begin
  Result := UID_CONNECTION;
end;

procedure TAbstractCrossConnection.SendBuf(const ABuffer: Pointer; const ACount: Integer; const ACallback: TCrossConnectionCallback);
{$IF defined(POSIX) or not defined(__LITTLE_PIECE__)}
begin
  DirectSend(ABuffer, ACount, ACallback);
end;
{$ELSE} // MSWINDOWS
var
  P: PByte;
  LSize: Integer;
  LSender: TCrossConnectionCallback;
begin
  P := ABuffer;
  LSize := ACount;

  LSender :=
    procedure(AConnection: ICrossConnection; ASuccess: Boolean)
    var
      LData: Pointer;
      LCount: Integer;
    begin
      if not ASuccess then
      begin
        LSender := nil;

        if Assigned(ACallback) then
          ACallback(AConnection, False);

        AConnection.Close;

        Exit;
      end;

      LData := P;
      LCount := Min(LSize, SND_BUF_SIZE);

      if (LSize > LCount) then
      begin
        Inc(P, LCount);
        Dec(LSize, LCount);
      end
      else
      begin
        LSize := 0;
        P := nil;
      end;

      if (LData = nil) or (LCount <= 0) then
      begin
        LSender := nil;

        if Assigned(ACallback) then
          ACallback(AConnection, True);

        Exit;
      end;

      TAbstractCrossConnection(AConnection).DirectSend(LData, LCount, LSender);
    end;

  LSender(Self, True);
end;
{$ENDIF}

procedure TAbstractCrossConnection.SendBuf(const ABuffer; const ACount: Integer; const ACallback: TCrossConnectionCallback);
begin
  SendBuf(@ABuffer, ACount, ACallback);
end;

procedure TAbstractCrossConnection.SendBytes(const ABytes: TBytes; const AOffset, ACount: Integer; const ACallback: TCrossConnectionCallback);
begin
  var LBytes := ABytes;
  SendBuf(@LBytes[AOffset], ACount,
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LBytes := nil;

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TAbstractCrossConnection.SendBytes(const ABytes: TBytes; const ACallback: TCrossConnectionCallback);
begin
  SendBytes(ABytes, 0, Length(ABytes), ACallback);
end;

procedure TAbstractCrossConnection.SendStream(const AStream: TStream; const ACallback: TCrossConnectionCallback);
var
  LBuffer: TBytes;
  LSender: TCrossConnectionCallback;
begin
  if (AStream is TBytesStream) then
  begin
    SendBytes(
      TBytesStream(AStream).Bytes,
      TBytesStream(AStream).Position,
      TBytesStream(AStream).Size - TBytesStream(AStream).Position,
      ACallback);
    Exit;
  end;

  SetLength(LBuffer, SND_BUF_SIZE);

  LSender :=
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    var
      LData: Pointer;
      LCount: Integer;
    begin
      if not ASuccess then
      begin
        LSender := nil;
        LBuffer := nil;

        if Assigned(ACallback) then
          ACallback(AConnection, False);

        AConnection.Close;

        Exit;
      end;

      LData := @LBuffer[0];
      LCount := AStream.Read(LBuffer[0], SND_BUF_SIZE);

      if (LData = nil) or (LCount <= 0) then
      begin
        LSender := nil;
        LBuffer := nil;

        if Assigned(ACallback) then
          ACallback(AConnection, True);

        Exit;
      end;

      TAbstractCrossConnection(AConnection).DirectSend(LData, LCount, LSender);
    end;

  LSender(Self, True);
end;

procedure TAbstractCrossConnection.UpdateAddr;
var
  LAddr: TRawSockAddrIn;
begin
  inherited;

  FillChar(LAddr, SizeOf(TRawSockAddrIn), 0);
  LAddr.AddrLen := SizeOf(LAddr.Addr6);
  if (TSocketAPI.GetPeerName(FSocket, @LAddr.Addr, LAddr.AddrLen) = 0) then
    TSocketAPI.ExtractAddrInfo(@LAddr.Addr, LAddr.AddrLen, FPeerAddr, FPeerPort);
end;

function TAbstractCrossConnection._SetConnectStatus(const AStatus: TConnectStatus): TConnectStatus;
begin
  Result := TConnectStatus(AtomicExchange(FConnectStatus, Integer(AStatus)));
end;

end.
