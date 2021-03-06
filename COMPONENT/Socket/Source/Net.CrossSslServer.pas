{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit Net.CrossSslServer;

interface

uses
  System.SysUtils,
  Net.SocketAPI,
  Net.CrossSocket.Base,
  Net.CrossSslSocket.Base,
  Net.CrossSslSocket;

type
  ICrossSslServer = interface(ICrossSslSocket)
  ['{DAEB2898-1EC4-4BCF-9BEB-078B582173AB}']
    function  GetActive: Boolean;
    function  GetAddr: string;
    function  GetPort: Word;
    procedure SetActive(const Value: Boolean);
    procedure SetAddr(const Value: string);
    procedure SetPort(const Value: Word);
    procedure Start(const ACallback: TProc<Boolean> = nil);
    procedure Stop(const ACallback: TProc = nil);

    property Active: Boolean read GetActive write SetActive;
    property Addr: string read GetAddr write SetAddr;
    property Port: Word read GetPort write SetPort;
  end;

  TCrossSslServer = class(TCrossSslSocket, ICrossSslServer)
  private
    FAddr: string;
    FPort: Word;
    FStarted: Integer;

    function  GetActive: Boolean;
    function  GetAddr: string;
    function  GetPort: Word;
    procedure SetActive(const Value: Boolean);
    procedure SetAddr(const Value: string);
    procedure SetPort(const Value: Word);
  public
    constructor Create(const AIoThreads: Integer); override;

    procedure Start(const ACallback: TProc<Boolean> = nil);
    procedure Stop(const ACallback: TProc = nil);

    property Active: Boolean read GetActive write SetActive;
    property Addr: string read GetAddr write SetAddr;
    property Port: Word read GetPort write SetPort;
  end;

implementation

{ TCrossSslServer }

constructor TCrossSslServer.Create(const AIoThreads: Integer);
begin
  inherited;
end;

function TCrossSslServer.GetActive: Boolean;
begin
  Result := (AtomicCmpExchange(FStarted, 0, 0) = 1);
end;

function TCrossSslServer.GetAddr: string;
begin
  Result := FAddr;
end;

function TCrossSslServer.GetPort: Word;
begin
  Result := FPort;
end;

procedure TCrossSslServer.SetActive(const Value: Boolean);
begin
  if Value then
    Start
  else
    Stop;
end;

procedure TCrossSslServer.SetAddr(const Value: string);
begin
  FAddr := Value;
end;

procedure TCrossSslServer.SetPort(const Value: Word);
begin
  FPort := Value;
end;

procedure TCrossSslServer.Start(const ACallback: TProc<Boolean>);
begin
  if (AtomicExchange(FStarted, 1) = 1) then
  begin
    if Assigned(ACallback) then
      ACallback(False);

    Exit;
  end;

  StartLoop;

  Listen(FAddr, FPort,
    procedure(const AListen: ICrossListen; const ASuccess: Boolean)
    begin
      if not ASuccess then
        AtomicExchange(FStarted, 0);

      if (FPort = 0) then
        FPort := AListen.LocalPort;

      if Assigned(ACallback) then
        ACallback(ASuccess);
    end);
end;

procedure TCrossSslServer.Stop(const ACallback: TProc = nil);
begin
  CloseAll;
  StopLoop;
  AtomicExchange(FStarted, 0);

  if Assigned(ACallback) then
    ACallback();
end;

end.
