{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit Net.CrossHttpServer;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Math,
  System.IOUtils,
  System.Generics.Collections,
  System.RegularExpressions,
  System.NetEncoding,
  System.RegularExpressionsCore,
  System.RegularExpressionsConsts,
  System.ZLib,
  System.Hash,
  Net.SocketAPI,
  Net.CrossSocket.Base,
  Net.CrossSocket,
  Net.CrossServer,
  Net.CrossHttpParams,
  Net.CrossHttpUtils,
  Utils.Logger;

const
  CROSS_HTTP_SERVER_NAME = 'CrossHttpServer/2.0';
  MIN_COMPRESS_SIZE = 512;

type
  ECrossHttpException = class(Exception)
  private
    FStatusCode: Integer;
  public
    constructor Create(const AMessage: string; AStatusCode: Integer = 400); reintroduce; virtual;
    constructor CreateFmt(const AMessage: string; const AArgs: array of const; AStatusCode: Integer = 400); reintroduce; virtual;

    property StatusCode: Integer read FStatusCode write FStatusCode;
  end;

  ICrossHttpServer = interface;
  ICrossHttpRequest = interface;
  ICrossHttpResponse = interface;

  ICrossHttpConnection = interface(ICrossConnection)
  ['{72E9AC44-958C-4C6F-8769-02EA5EC3E9A8}']
    function GetRequest: ICrossHttpRequest;
    function GetResponse: ICrossHttpResponse;
    function GetServer: ICrossHttpServer;

    property Request: ICrossHttpRequest read GetRequest;
    property Response: ICrossHttpResponse read GetResponse;
    property Server: ICrossHttpServer read GetServer;
  end;

  TBodyType = (btNone, btUrlEncoded, btMultiPart, btBinary);

  ICrossHttpRequest = interface
  ['{B26B7E7B-6B24-4D86-AB58-EBC20722CFDD}']
    function GetAccept: string;
    function GetAcceptEncoding: string;
    function GetAcceptLanguage: string;
    function GetAuthorization: string;
    function GetBody: TObject;
    function GetBodyType: TBodyType;
    function GetConnection: ICrossHttpConnection;
    function GetContentEncoding: string;
    function GetContentLength: Int64;
    function GetContentType: string;
    function GetCookies: TRequestCookies;
    function GetHeader: THttpHeader;
    function GetHostName: string;
    function GetHostPort: Word;
    function GetIfModifiedSince: TDateTime;
    function GetIfNoneMatch: string;
    function GetIfRange: string;
    function GetIsChunked: Boolean;
    function GetIsMultiPartFormData: Boolean;
    function GetIsUrlEncodedFormData: Boolean;
    function GetKeepAlive: Boolean;
    function GetMethod: string;
    function GetParams: THttpUrlParams;
    function GetPath: string;
    function GetPostDataSize: Int64;
    function GetQuery: THttpUrlParams;
    function GetRange: string;
    function GetRawPathAndParams: string;
    function GetRawRequestText: string;
    function GetReferer: string;
    function GetRequestBoundary: string;
    function GetRequestCmdLine: string;
    function GetRequestConnection: string;
    function GetSession: ISession;
    function GetTransferEncoding: string;
    function GetUserAgent: string;
    function GetVersion: string;
    function GetXForwardedFor: string;

    property Accept: string read GetAccept;
    property AcceptEncoding: string read GetAcceptEncoding;
    property AcceptLanguage: string read GetAcceptLanguage;
    property Authorization: string read GetAuthorization;
    property Body: TObject read GetBody;
    property BodyType: TBodyType read GetBodyType;
    property Connection: ICrossHttpConnection read GetConnection;
    property ContentEncoding: string read GetContentEncoding;
    property ContentLength: Int64 read GetContentLength;
    property ContentType: string read GetContentType;
    property Cookies: TRequestCookies read GetCookies;
    property Header: THttpHeader read GetHeader;
    property HostName: string read GetHostName;
    property HostPort: Word read GetHostPort;
    property IfModifiedSince: TDateTime read GetIfModifiedSince;
    property IfNoneMatch: string read GetIfNoneMatch;
    property IfRange: string read GetIfRange;
    property IsChunked: Boolean read GetIsChunked;
    property IsMultiPartFormData: Boolean read GetIsMultiPartFormData;
    property IsUrlEncodedFormData: Boolean read GetIsUrlEncodedFormData;
    property KeepAlive: Boolean read GetKeepAlive;
    property Method: string read GetMethod;
    property Params: THttpUrlParams read GetParams;
    property Path: string read GetPath;
    property PostDataSize: Int64 read GetPostDataSize;
    property Query: THttpUrlParams read GetQuery;
    property Range: string read GetRange;
    property RawPathAndParams: string read GetRawPathAndParams;
    property RawRequestText: string read GetRawRequestText;
    property Referer: string read GetReferer;
    property RequestBoundary: string read GetRequestBoundary;
    property RequestCmdLine: string read GetRequestCmdLine;
    property RequestConnection: string read GetRequestConnection;
    property Session: ISession read GetSession;
    property TransferEncoding: string read GetTransferEncoding;
    property UserAgent: string read GetUserAgent;
    property Version: string read GetVersion;
    property XForwardedFor: string read GetXForwardedFor;
  end;

  TCompressType = (ctGZip, ctDeflate);

  TCrossHttpChunkDataFunc = reference to function(const AData: PPointer; const ACount: PNativeInt): Boolean;

  ICrossHttpResponse = interface
  ['{5E15C20F-E221-4B10-90FC-222173A6F3E8}']
    procedure Attachment(const AFileName: string);
    procedure Download(const AFileName: string; const ACallback: TCrossConnectionCallback = nil);
    function  GetConnection: ICrossHttpConnection;
    function  GetContentType: string;
    function  GetCookies: TResponseCookies;
    function  GetHeader: THttpHeader;
    function  GetLocation: string;
    function  GetRequest: ICrossHttpRequest;
    function  GetSent: Boolean;
    function  GetStatusCode: Integer;
    procedure Json(const AJson: string; const ACallback: TCrossConnectionCallback = nil);
    procedure Redirect(const AUrl: string; const ACallback: TCrossConnectionCallback = nil);
    procedure Send(const ABody; const ACount: NativeInt; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: TBytes; const AOffset, ACount: NativeInt; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: TBytes; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: TStream; const AOffset, ACount: Int64; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: TStream; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: string; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendFile(const AFileName: string; const ACallback: TCrossConnectionCallback = nil);
    procedure SendNoCompress(const AChunkSource: TCrossHttpChunkDataFunc; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody; const ACount: NativeInt; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: TBytes; const AOffset, ACount: NativeInt; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: TBytes; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: TStream; const AOffset, ACount: Int64; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: TStream; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: string; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendStatus(const AStatusCode: Integer; const ADescription: string; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendStatus(const AStatusCode: Integer; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const AChunkSource: TCrossHttpChunkDataFunc; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody; const ACount: NativeInt; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: TBytes; const AOffset, ACount: NativeInt; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: TBytes; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: TStream; const AOffset, ACount: Int64; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: TStream; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: string; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SetContentType(const Value: string);
    procedure SetLocation(const Value: string);
    procedure SetStatusCode(Value: Integer);

    property Connection: ICrossHttpConnection read GetConnection;
    property ContentType: string read GetContentType write SetContentType;
    property Cookies: TResponseCookies read GetCookies;
    property Header: THttpHeader read GetHeader;
    property Location: string read GetLocation write SetLocation;
    property Request: ICrossHttpRequest read GetRequest;
    property Sent: Boolean read GetSent;
    property StatusCode: Integer read GetStatusCode write SetStatusCode;
  end;

  ICrossHttpRouter = interface
  ['{2B095450-6A5D-450F-8DCD-6911526C733F}']
    procedure Execute(const ARequest: ICrossHttpRequest; const AResponse: ICrossHttpResponse; var AHandled: Boolean);
    function  GetMethod: string;
    function  GetPath: string;
    function  IsMatch(const ARequest: ICrossHttpRequest): Boolean;

    property Method: string read GetMethod;
    property Path: string read GetPath;
  end;

  TCrossHttpRouters = TList<ICrossHttpRouter>;

  TCrossHttpRouterProc = reference to procedure(const ARequest: ICrossHttpRequest; const AResponse: ICrossHttpResponse; var AHandled: Boolean);

  TCrossHttpConnEvent = procedure(const Sender: TObject; const AConnection: ICrossHttpConnection) of object;
  TCrossHttpDataEvent = procedure(const Sender: TObject; const AClient: ICrossHttpConnection; const ABuf: Pointer; const ALen: Integer) of object;
  TCrossHttpRequestEvent = procedure(const Sender: TObject; const ARequest: ICrossHttpRequest; const AResponse: ICrossHttpResponse; var AHandled: Boolean) of object;
  TCrossHttpRequestExceptionEvent = procedure(const Sender: TObject; const ARequest: ICrossHttpRequest; const AResponse: ICrossHttpResponse; const AException: Exception) of object;

  ICrossHttpServer = interface(ICrossServer)
  ['{224D16AA-317C-435E-9C2E-92868E578DB3}']
    function  GetAutoDeleteFiles: Boolean;
    function  GetCompressible: Boolean;
    function  GetMaxHeaderSize: Int64;
    function  GetMaxPostDataSize: Int64;
    function  GetMinCompressSize: Int64;
    function  GetOnPostData: TCrossHttpDataEvent;
    function  GetOnPostDataBegin: TCrossHttpConnEvent;
    function  GetOnPostDataEnd: TCrossHttpConnEvent;
    function  GetOnRequest: TCrossHttpRequestEvent;
    function  GetOnRequestException: TCrossHttpRequestExceptionEvent;
    function  GetSessionIDCookieName: string;
    function  GetSessions: ISessions;
    function  GetStoragePath: string;
    procedure SetAutoDeleteFiles(const Value: Boolean);
    procedure SetCompressible(const Value: Boolean);
    procedure SetStoragePath(const Value: string);
    procedure SetMaxHeaderSize(const Value: Int64);
    procedure SetMaxPostDataSize(const Value: Int64);
    procedure SetMinCompressSize(const Value: Int64);
    procedure SetOnPostData(const Value: TCrossHttpDataEvent);
    procedure SetOnPostDataBegin(const Value: TCrossHttpConnEvent);
    procedure SetOnPostDataEnd(const Value: TCrossHttpConnEvent);
    procedure SetOnRequest(const Value: TCrossHttpRequestEvent);
    procedure SetOnRequestException(const Value: TCrossHttpRequestExceptionEvent);
    procedure SetSessionIDCookieName(const Value: string);
    procedure SetSessions(const Value: ISessions);

    function  All(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
    function  ClearRouter: ICrossHttpServer;
    function  CreateRouter(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpRouter;
    function  Delete(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  Dir(const APath, ALocalDir: string): ICrossHttpServer;
    function  Get(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  Index(const APath, ALocalDir: string; const ADefIndexFiles: TArray<string>): ICrossHttpServer;
    function  LockMiddlewares: TCrossHttpRouters;
    function  LockRouters: TCrossHttpRouters;
    function  Post(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  Put(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  RemoveRouter(const AMethod, APath: string): ICrossHttpServer;
    function  Route(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  &Static(const APath, ALocalStaticDir: string): ICrossHttpServer;
    procedure UnlockMiddlewares;
    procedure UnlockRouters;
    function  Use(const AMethod, APath: string; const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  Use(const APath: string; const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  Use(const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer; overload;

    property AutoDeleteFiles: Boolean read GetAutoDeleteFiles write SetAutoDeleteFiles;
    property Compressible: Boolean read GetCompressible write SetCompressible;
    property MaxHeaderSize: Int64 read GetMaxHeaderSize write SetMaxHeaderSize;
    property MaxPostDataSize: Int64 read GetMaxPostDataSize write SetMaxPostDataSize;
    property MinCompressSize: Int64 read GetMinCompressSize write SetMinCompressSize;
    property StoragePath: string read GetStoragePath write SetStoragePath;
    property SessionIDCookieName: string read GetSessionIDCookieName write SetSessionIDCookieName;
    property Sessions: ISessions read GetSessions write SetSessions;

    property OnPostData: TCrossHttpDataEvent read GetOnPostData write SetOnPostData;
    property OnPostDataBegin: TCrossHttpConnEvent read GetOnPostDataBegin write SetOnPostDataBegin;
    property OnPostDataEnd: TCrossHttpConnEvent read GetOnPostDataEnd write SetOnPostDataEnd;
    property OnRequest: TCrossHttpRequestEvent read GetOnRequest write SetOnRequest;
    property OnRequestException: TCrossHttpRequestExceptionEvent read GetOnRequestException write SetOnRequestException;
  end;

  TCrossHttpConnection = class(TCrossServerConnection, ICrossHttpConnection)
  private
    FRequest: ICrossHttpRequest;
    FResponse: ICrossHttpResponse;

    function GetRequest: ICrossHttpRequest;
    function GetResponse: ICrossHttpResponse;
    function GetServer: ICrossHttpServer;
  public
    constructor Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType); override;

    property Request: ICrossHttpRequest read GetRequest;
    property Response: ICrossHttpResponse read GetResponse;
    property Server: ICrossHttpServer read GetServer;
  end;

  TCrossHttpRequest = class(TInterfacedObject, ICrossHttpRequest)
  private
    function GetAccept: string;
    function GetAcceptEncoding: string;
    function GetAcceptLanguage: string;
    function GetAuthorization: string;
    function GetBody: TObject;
    function GetBodyType: TBodyType;
    function GetConnection: ICrossHttpConnection;
    function GetContentEncoding: string;
    function GetContentLength: Int64;
    function GetContentType: string;
    function GetCookies: TRequestCookies;
    function GetHeader: THttpHeader;
    function GetHostName: string;
    function GetHostPort: Word;
    function GetIfModifiedSince: TDateTime;
    function GetIfNoneMatch: string;
    function GetIfRange: string;
    function GetIsChunked: Boolean;
    function GetIsMultiPartFormData: Boolean;
    function GetIsUrlEncodedFormData: Boolean;
    function GetKeepAlive: Boolean;
    function GetMethod: string;
    function GetPath: string;
    function GetPostDataSize: Int64;
    function GetRawRequestText: string;
    function GetRawPathAndParams: string;
    function GetRequestBoundary: string;
    function GetRequestCmdLine: string;
    function GetRequestConnection: string;
    function GetSession: ISession;
    function GetVersion: string;
    function GetParams: THttpUrlParams;
    function GetQuery: THttpUrlParams;
    function GetRange: string;
    function GetReferer: string;
    function GetTransferEncoding: string;
    function GetUserAgent: string;
    function GetXForwardedFor: string;
  private
    type
      TCrossHttpParseState = (
        psHeader,
        psPostData,
        psChunkSize,
        psChunkData,
        psChunkEnd,
        psDone
      );
  private
    FAccept: string;
    FAcceptLanguage: string;
    FAcceptEncoding: string;
    FAuthorization: string;
    FBody: TObject;
    FBodyType: TBodyType;
    FChunkSizeStream: TBytesStream;
    FChunkSize: Integer;
    FChunkLeftSize: Integer;
    [unsafe]FConnection: ICrossHttpConnection;
    FContentEncoding: string;
    FContentLength: Int64;
    FContentType: string;
    FCookies: TRequestCookies;
    FHeader: THttpHeader;
    FHostName: string;
    FHostPort: Word;
    FIfModifiedSince: TDateTime;
    FIfNoneMatch: string;
    FIfRange: string;
    FMethod: string;
    FParseState: TCrossHttpParseState;
    FRawRequest: TBytesStream;
    FRawRequestText: string;
    FPath: string;
    FRawParamsText: string;
    FRawPath: string;
    FRawPathAndParams: string;
    FHttpVerNum: Integer;
    FKeepAlive: Boolean;
    FParams: THttpUrlParams;
    FPostDataSize: Int64;
    FQuery: THttpUrlParams;
    FRange: string;
    FReferer: string;
    FRequestBoundary: string;
    FRequestCmdLine: string;
    FRequestConnection: string;
    FRequestCookies: string;
    FRequestHost: string;
    FSession: ISession;
    FTransferEncoding: string;
    FUserAgent: string;
    FXForwardedFor: string;
    FVersion: string;

    CR: Integer;
    LF: Integer;
  protected
    function  ParseRequestData: Boolean; virtual;
  public
    constructor Create(const AConnection: ICrossHttpConnection);
    destructor Destroy; override;

    procedure Reset;

    property Accept: string read GetAccept;
    property AcceptEncoding: string read GetAcceptEncoding;
    property AcceptLanguage: string read GetAcceptLanguage;
    property Authorization: string read GetAuthorization;
    property Body: TObject read GetBody;
    property BodyType: TBodyType read GetBodyType;
    property Connection: ICrossHttpConnection read GetConnection;
    property ContentEncoding: string read GetContentEncoding;
    property ContentLength: Int64 read GetContentLength;
    property ContentType: string read GetContentType;
    property Cookies: TRequestCookies read GetCookies;
    property Header: THttpHeader read GetHeader;
    property HostName: string read GetHostName;
    property HostPort: Word read GetHostPort;
    property IfModifiedSince: TDateTime read GetIfModifiedSince;
    property IfNoneMatch: string read GetIfNoneMatch;
    property IfRange: string read GetIfRange;
    property IsChunked: Boolean read GetIsChunked;
    property IsMultiPartFormData: Boolean read GetIsMultiPartFormData;
    property IsUrlEncodedFormData: Boolean read GetIsUrlEncodedFormData;
    property KeepAlive: Boolean read GetKeepAlive;
    property Method: string read GetMethod;
    property Params: THttpUrlParams read GetParams;
    property Path: string read GetPath;
    property PostDataSize: Int64 read GetPostDataSize;
    property RawRequestText: string read GetRawRequestText;
    property RawPathAndParams: string read GetRawPathAndParams;
    property Query: THttpUrlParams read GetQuery;
    property Range: string read GetRange;
    property Referer: string read GetReferer;
    property RequestBoundary: string read GetRequestBoundary;
    property RequestCmdLine: string read GetRequestCmdLine;
    property RequestConnection: string read GetRequestConnection;
    property Session: ISession read GetSession;
    property TransferEncoding: string read GetTransferEncoding;
    property UserAgent: string read GetUserAgent;
    property Version: string read GetVersion;
    property XForwardedFor: string read GetXForwardedFor;
  end;

  TCrossHttpResponse = class(TInterfacedObject, ICrossHttpResponse)
  public
    const
      SND_BUF_SIZE = TCrossConnection.SND_BUF_SIZE;
  private
    [unsafe]FConnection: ICrossHttpConnection;
    FCookies: TResponseCookies;
    FHeader: THttpHeader;
    FRequest: ICrossHttpRequest;
    FSendStatus: Integer;
    FStatusCode: Integer;

    procedure _AdjustOffsetCount(const ABodySize: NativeInt; var AOffset, ACount: NativeInt); overload;
    procedure _AdjustOffsetCount(const ABodySize: Int64; var AOffset, ACount: Int64); overload;
    function  _CheckCompress(const ABodySize: Int64; var ACompressType: TCompressType): Boolean;
    function  _CreateHeader(const ABodySize: Int64; AChunked: Boolean): TBytes;
    procedure _Send(const ASource: TCrossHttpChunkDataFunc; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure _Send(const AHeaderSource, ABodySource: TCrossHttpChunkDataFunc; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Attachment(const AFileName: string);
    procedure Download(const AFileName: string; const ACallback: TCrossConnectionCallback = nil);
    function  GetConnection: ICrossHttpConnection;
    function  GetContentType: string;
    function  GetCookies: TResponseCookies;
    function  GetHeader: THttpHeader;
    function  GetLocation: string;
    function  GetRequest: ICrossHttpRequest;
    function  GetSent: Boolean;
    function  GetStatusCode: Integer;
    procedure Json(const AJson: string; const ACallback: TCrossConnectionCallback = nil);
    procedure Redirect(const AUrl: string; const ACallback: TCrossConnectionCallback = nil);
    procedure Reset;
    procedure Send(const ABody; const ACount: NativeInt; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: TBytes; const AOffset, ACount: NativeInt; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: TBytes; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: TStream; const AOffset, ACount: Int64; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: TStream; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure Send(const ABody: string; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendFile(const AFileName: string; const ACallback: TCrossConnectionCallback = nil);
    procedure SendNoCompress(const AChunkSource: TCrossHttpChunkDataFunc; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody; const ACount: NativeInt; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: TBytes; const AOffset, ACount: NativeInt; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: TBytes; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: TStream; const AOffset, ACount: Int64; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: TStream; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendNoCompress(const ABody: string; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendStatus(const AStatusCode: Integer; const ADescription: string; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendStatus(const AStatusCode: Integer; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const AChunkSource: TCrossHttpChunkDataFunc; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody; const ACount: NativeInt; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: TBytes; const AOffset, ACount: NativeInt; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: TBytes; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: TStream; const AOffset, ACount: Int64; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: TStream; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SendZCompress(const ABody: string; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback = nil); overload;
    procedure SetContentType(const Value: string);
    procedure SetLocation(const Value: string);
    procedure SetStatusCode(Value: Integer);
  public
    constructor Create(const AConnection: ICrossHttpConnection);
    destructor Destroy; override;
  end;

  TCrossHttpRouter = class(TInterfacedObject, ICrossHttpRouter)
  private
    FMethod: string;
    FMethodPattern: string;
    FMethodRegEx: TPerlRegEx;
    FPath: string;
    FPathParamKeys: TArray<string>;
    FPathPattern: string;
    FPathRegEx: TPerlRegEx;
    FRegExLock: TObject;
    FRouterProc: TCrossHttpRouterProc;

    function  GetMethod: string;
    function  GetPath: string;
    function  MakeMethodPattern(const AMethod: string): string;
    function  MakePathPattern(const APath: string; var AKeys: TArray<string>): string;
    procedure RemakePattern;
  public
    constructor Create(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc);
    destructor Destroy; override;

    procedure Execute(const ARequest: ICrossHttpRequest; const AResponse: ICrossHttpResponse; var AHandled: Boolean);
    function  IsMatch(const ARequest: ICrossHttpRequest): Boolean;
  end;

  TCrossHttpServer = class(TCrossServer, ICrossHttpServer)
  private
    const
    {$REGION 'HTTP_METHODS'}
      HTTP_METHOD_COUNT = 16;
      HTTP_METHODS: array [0..HTTP_METHOD_COUNT-1] of string = (
        'GET', 'POST', 'PUT', 'DELETE',
        'HEAD', 'OPTIONS', 'TRACE', 'CONNECT',
        'PATCH', 'COPY', 'LINK', 'UNLINK',
        'PURGE', 'LOCK', 'UNLOCK', 'PROPFIND');
      SESSIONID_COOKIE_NAME = 'cross_sessionid';
      {$ENDREGION}
  private
    FAutoDeleteFiles: Boolean;
    FCompressible: Boolean;
    FMaxHeaderSize: Int64;
    FMaxPostDataSize: Int64;
    FMethodTags: array [0..HTTP_METHOD_COUNT-1] of TBytes;
    FMiddlewares: TCrossHttpRouters;
    FMiddlewaresLock: TMultiReadExclusiveWriteSynchronizer;
    FMinCompressSize: Integer;
    FRouters: TCrossHttpRouters;
    FRoutersLock: TMultiReadExclusiveWriteSynchronizer;
    FSessionIDCookieName: string;
    FSessions: ISessions;
    FStoragePath: string;

    FOnPostData: TCrossHttpDataEvent;
    FOnPostDataBegin: TCrossHttpConnEvent;
    FOnPostDataEnd: TCrossHttpConnEvent;
    FOnRequest: TCrossHttpRequestEvent;
    FOnRequestException: TCrossHttpRequestExceptionEvent;

    function  IsValidHttpRequest(const ABuf: Pointer; const ALen: Integer): Boolean;
    procedure ParseRecvData(const AConnection: ICrossConnection; const ABuf: Pointer; ALen: Integer);
    function  RegisterMiddleware(const AMethod, APath: string; const AMiddlewareProc: TCrossHttpRouterProc): TCrossHttpServer;
    function  RegisterRouter(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc): TCrossHttpServer;
  private
    function  GetAutoDeleteFiles: Boolean;
    function  GetCompressible: Boolean;
    function  GetMaxHeaderSize: Int64;
    function  GetMaxPostDataSize: Int64;
    function  GetMinCompressSize: Int64;
    function  GetOnPostData: TCrossHttpDataEvent;
    function  GetOnPostDataBegin: TCrossHttpConnEvent;
    function  GetOnPostDataEnd: TCrossHttpConnEvent;
    function  GetOnRequest: TCrossHttpRequestEvent;
    function  GetOnRequestException: TCrossHttpRequestExceptionEvent;
    function  GetStoragePath: string;
    function  GetSessionIDCookieName: string;
    function  GetSessions: ISessions;
    procedure SetAutoDeleteFiles(const Value: Boolean);
    procedure SetCompressible(const Value: Boolean);
    procedure SetMaxHeaderSize(const Value: Int64);
    procedure SetMaxPostDataSize(const Value: Int64);
    procedure SetMinCompressSize(const Value: Int64);
    procedure SetOnPostData(const Value: TCrossHttpDataEvent);
    procedure SetOnPostDataBegin(const Value: TCrossHttpConnEvent);
    procedure SetOnPostDataEnd(const Value: TCrossHttpConnEvent);
    procedure SetOnRequest(const Value: TCrossHttpRequestEvent);
    procedure SetOnRequestException(const Value: TCrossHttpRequestExceptionEvent);
    procedure SetStoragePath(const Value: string);
    procedure SetSessionIDCookieName(const Value: string);
    procedure SetSessions(const Value: ISessions);
  protected
    function  CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection; override;
    function  CreateRouter(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpRouter; virtual;
    procedure LogicReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer); override;
  protected
    procedure DoOnRequest(const AConnection: ICrossHttpConnection); virtual;
    procedure TriggerPostData(const AConnection: ICrossHttpConnection; const ABuf: Pointer; const ALen: Integer); virtual;
    procedure TriggerPostDataBegin(const AConnection: ICrossHttpConnection); virtual;
    procedure TriggerPostDataEnd(const AConnection: ICrossHttpConnection); virtual;
  public
    constructor Create(const AIoThreads: Integer; const ASsl: Boolean); override;
    destructor Destroy; override;

    function  All(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
    function  ClearRouter: ICrossHttpServer;
    function  Delete(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
    function  Dir(const APath, ALocalDir: string): ICrossHttpServer;
    function  Get(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
    function  Index(const APath, ALocalDir: string; const ADefIndexFiles: TArray<string>): ICrossHttpServer;
    function  LockMiddlewares: TCrossHttpRouters;
    function  LockRouters: TCrossHttpRouters;
    function  Post(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
    function  Put(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
    function  RemoveRouter(const AMethod, APath: string): ICrossHttpServer;
    function  Route(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
    function  &Static(const APath, ALocalStaticDir: string): ICrossHttpServer;
    procedure UnlockMiddlewares;
    procedure UnlockRouters;
    function  Use(const AMethod, APath: string; const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  Use(const APath: string; const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer; overload;
    function  Use(const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer; overload;

    property AutoDeleteFiles: Boolean read GetAutoDeleteFiles write SetAutoDeleteFiles;
    property Compressible: Boolean read GetCompressible write SetCompressible;
    property MaxHeaderSize: Int64 read GetMaxHeaderSize write SetMaxHeaderSize;
    property MaxPostDataSize: Int64 read GetMaxPostDataSize write SetMaxPostDataSize;
    property MinCompressSize: Int64 read GetMinCompressSize write SetMinCompressSize;
    property StoragePath: string read GetStoragePath write SetStoragePath;
    property SessionIDCookieName: string read GetSessionIDCookieName write SetSessionIDCookieName;
    property Sessions: ISessions read GetSessions write SetSessions;

    property OnPostData: TCrossHttpDataEvent read GetOnPostData write SetOnPostData;
    property OnPostDataBegin: TCrossHttpConnEvent read GetOnPostDataBegin write SetOnPostDataBegin;
    property OnPostDataEnd: TCrossHttpConnEvent read GetOnPostDataEnd write SetOnPostDataEnd;
    property OnRequest: TCrossHttpRequestEvent read GetOnRequest write SetOnRequest;
    property OnRequestException: TCrossHttpRequestExceptionEvent read GetOnRequestException write SetOnRequestException;
  end;

implementation

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  Utils.RegEx,
  Utils.Utils,
  Net.CrossHttpRouter;


{ ECrossHttpException }

constructor ECrossHttpException.Create(const AMessage: string; AStatusCode: Integer);
begin
  inherited Create(AMessage);
  FStatusCode := AStatusCode;
end;

constructor ECrossHttpException.CreateFmt(const AMessage: string; const AArgs: array of const; AStatusCode: Integer);
begin
  inherited CreateFmt(AMessage, AArgs);
  FStatusCode := AStatusCode;
end;

{ TCrossHttpConnection }

constructor TCrossHttpConnection.Create(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType);
begin
  inherited;

  FRequest := TCrossHttpRequest.Create(Self);
  FResponse := TCrossHttpResponse.Create(Self);
end;

function TCrossHttpConnection.GetRequest: ICrossHttpRequest;
begin
  Result := FRequest;
end;

function TCrossHttpConnection.GetResponse: ICrossHttpResponse;
begin
  Result := FResponse;
end;

function TCrossHttpConnection.GetServer: ICrossHttpServer;
begin
  Result := Owner as ICrossHttpServer;
end;

{ TCrossHttpRouter }

constructor TCrossHttpRouter.Create(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc);
begin
  FMethod := AMethod;
  FPath := APath;
  FRouterProc := ARouterProc;

  FMethodRegEx := TPerlRegEx.Create;
  FMethodRegEx.Options := [preCaseLess];

  FPathRegEx := TPerlRegEx.Create;
  FPathRegEx.Options := [preCaseLess];

  FRegExLock := TObject.Create;

  RemakePattern;
end;

destructor TCrossHttpRouter.Destroy;
begin
  TMonitor.Enter(FRegExLock);
  try
    FreeAndNil(FMethodRegEx);
    FreeAndNil(FPathRegEx);
  finally
    TMonitor.Exit(FRegExLock);
  end;
  FreeAndNil(FRegExLock);

  inherited;
end;

function TCrossHttpRouter.MakeMethodPattern(const AMethod: string): string;
begin
  var LPattern := AMethod;

  LPattern := TRegEx.Replace(LPattern, '(?<!\.)\*', '.*');

  if not LPattern.StartsWith('^') then
    LPattern := '^' + LPattern;
  if not LPattern.EndsWith('$') then
    LPattern := LPattern + '$';

  Result := LPattern;
end;

function TCrossHttpRouter.MakePathPattern(const APath: string; var AKeys: TArray<string>): string;
begin
  var LKeys: TArray<string> := [];
  var LPattern := APath;

  if APath.EndsWith('/') then
    LPattern := LPattern + '?'
  else
    LPattern := LPattern + '/?';

  LPattern := TRegEx.Replace(LPattern, '\/\(', '/(?:');
  LPattern := TRegEx.Replace(LPattern, '([\/\.])', '\\$1');
  LPattern := TRegEx.Replace(LPattern, '(\\\/)?(\\\.)?:(\w+)(\(.*?\))?(\*)?(\?)?',
    function(const Match: TMatch): string
    var
      LSlash, LFormat, LKey, LCapture, LStar, LOptional: string;
    begin
      if not Match.Success then
        Exit('');

      if (Match.Groups.Count > 1) then
        LSlash := Match.Groups[1].Value
      else
        LSlash := '';
      if (Match.Groups.Count > 2) then
        LFormat := Match.Groups[2].Value
      else
        LFormat := '';

      if (Match.Groups.Count > 3) then
        LKey := Match.Groups[3].Value
      else
        LKey := '';

      if (Match.Groups.Count > 4) then
        LCapture := Match.Groups[4].Value
      else
        LCapture := '';

      if (Match.Groups.Count > 5) then
        LStar := Match.Groups[5].Value
      else
        LStar := '';

      if (Match.Groups.Count > 6) then
        LOptional := Match.Groups[6].Value
      else
        LOptional := '';

      if (LCapture = '') then
        LCapture := '([^\\/' + LFormat + ']+?)';

      Result := '';
      if (LOptional = '') then
        Result := Result + LSlash;

      Result := Result + '(?:' + LFormat;
      if (LOptional <> '') then
        Result := Result + LSlash;

      Result := Result + LCapture;
      if (LStar <> '') then
        Result := Result + '((?:[\\/' + LFormat + '].+?)?)';

      Result := Result + ')' + LOptional;

      LKeys := LKeys + [LKey];
    end);

  LPattern := TRegEx.Replace(LPattern, '(?<!\.)\*', '.*');

  if not LPattern.StartsWith('^') then
    LPattern := '^' + LPattern;

  if not LPattern.EndsWith('$') then
    LPattern := LPattern + '$';

  AKeys := LKeys;
  Result := LPattern;
end;

procedure TCrossHttpRouter.RemakePattern;
begin
  if (FPath.Chars[0] <> '/') then
    FPath := '/' + FPath;

  FMethodPattern := MakeMethodPattern(FMethod);
  FPathPattern := MakePathPattern(FPath, FPathParamKeys);

  TMonitor.Enter(FRegExLock);
  try
    FMethodRegEx.RegEx := FMethodPattern;
    FPathRegEx.RegEx := FPathPattern;
  finally
    TMonitor.Exit(FRegExLock);
  end;
end;

function TCrossHttpRouter.IsMatch(const ARequest: ICrossHttpRequest): Boolean;

  function _IsMatchMethod: Boolean;
  begin
    if (FMethod = '*') or SameText(ARequest.Method, FMethod) then
      Exit(True);

    FMethodRegEx.Subject := ARequest.Method;
    Result := FMethodRegEx.Match;
  end;

  function _IsMatchPath: Boolean;
  begin
    if (FPath = '*') or ((Length(FPathParamKeys) = 0) and SameText(ARequest.Path, FPath)) then
      Exit(True);

    FPathRegEx.Subject := ARequest.Path;
    Result := FPathRegEx.Match;
    if not Result then
      Exit;

    for var I := 1 to FPathRegEx.GroupCount do
      ARequest.Params[FPathParamKeys[I - 1]] := FPathRegEx.Groups[I];
  end;
begin
  ARequest.Params.Clear;

  TMonitor.Enter(FRegExLock);
  try
    Result := _IsMatchMethod and _IsMatchPath;
  finally
    TMonitor.Exit(FRegExLock);
  end;
end;

procedure TCrossHttpRouter.Execute(const ARequest: ICrossHttpRequest; const AResponse: ICrossHttpResponse; var AHandled: Boolean);
begin
  if Assigned(FRouterProc) then
  begin
    FRouterProc(ARequest, AResponse, AHandled);
  end;
end;

function TCrossHttpRouter.GetMethod: string;
begin
  Result := FMethod;
end;

function TCrossHttpRouter.GetPath: string;
begin
  Result := FPath;
end;

{ TCrossHttpServer }

constructor TCrossHttpServer.Create(const AIoThreads: Integer; const ASsl: Boolean);
begin
  inherited Create(AIoThreads, ASsl);

  FRouters := TCrossHttpRouters.Create;
  FRoutersLock := TMultiReadExclusiveWriteSynchronizer.Create;

  FMiddlewares := TCrossHttpRouters.Create;
  FMiddlewaresLock := TMultiReadExclusiveWriteSynchronizer.Create;

  for var I := Low(FMethodTags) to High(FMethodTags) do
    FMethodTags[I] := TEncoding.ANSI.GetBytes(HTTP_METHODS[I]);

  Port := 80;
  Addr := '';

  FCompressible := True;
  FMinCompressSize := MIN_COMPRESS_SIZE;
  FStoragePath := TPath.Combine(TUtils.AppPath, 'temp') + TPath.DirectorySeparatorChar;
  FSessionIDCookieName := SESSIONID_COOKIE_NAME;
end;

destructor TCrossHttpServer.Destroy;
begin
  Stop;

  FRoutersLock.BeginWrite;
  FreeAndNil(FRouters);
  FRoutersLock.EndWrite;
  FreeAndNil(FRoutersLock);

  FMiddlewaresLock.BeginWrite;
  FreeAndNil(FMiddlewares);
  FMiddlewaresLock.EndWrite;
  FreeAndNil(FMiddlewaresLock);

  inherited Destroy;
end;

function TCrossHttpServer.All(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := Route('*', APath, ARouterProc);
end;

function TCrossHttpServer.CreateConnection(const AOwner: ICrossSocket; const AClientSocket: THandle; const AConnectType: TConnectType): ICrossConnection;
begin
  Result := TCrossHttpConnection.Create(AOwner, AClientSocket, AConnectType);
end;

function TCrossHttpServer.CreateRouter(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpRouter;
begin
  Result := TCrossHttpRouter.Create(AMethod, APath, ARouterProc);
end;

function TCrossHttpServer.Dir(const APath, ALocalDir: string): ICrossHttpServer;
begin
  var LReqPath := APath;
  if not LReqPath.EndsWith('/') then
    LReqPath := LReqPath + '/';
  LReqPath := LReqPath + '?:dir(*)';
  Result := Get(LReqPath, TNetCrossRouter.Dir(APath, ALocalDir, 'dir'));
end;

function TCrossHttpServer.Delete(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := Route('DELETE', APath, ARouterProc);
end;

procedure TCrossHttpServer.DoOnRequest(const AConnection: ICrossHttpConnection);
var
  LRequest: ICrossHttpRequest;
  LResponse: ICrossHttpResponse;
  LSessionID: string;
  LHandled: Boolean;
  LRouter: ICrossHttpRouter;
  LMiddleware: ICrossHttpRouter;
  LMiddlewares: TArray<ICrossHttpRouter>;
  LRouters: TArray<ICrossHttpRouter>;
begin
  LRequest := AConnection.Request;
  LResponse := AConnection.Response;
  LHandled := False;

  try
    if (FSessions <> nil) and (FSessionIDCookieName <> '') then
    begin
      LSessionID := LRequest.Cookies[FSessionIDCookieName];
      (LRequest as TCrossHttpRequest).FSession := FSessions.Sessions[LSessionID];
      if (LRequest.Session <> nil) and (LRequest.Session.SessionID <> LSessionID) then
      begin
        LSessionID := LRequest.Session.SessionID;
        LResponse.Cookies.AddOrSet(FSessionIDCookieName, LSessionID, 0);
      end;
    end;

    FMiddlewaresLock.BeginRead;
    try
      LMiddlewares := FMiddlewares.ToArray;
    finally
      FMiddlewaresLock.EndRead;
    end;

    for LMiddleware in LMiddlewares do
    begin
      if LMiddleware.IsMatch(LRequest) then
      begin
        LHandled := False;
        LMiddleware.Execute(LRequest, LResponse, LHandled);

        if LHandled or LResponse.Sent then
          Exit;
      end;
    end;

    if Assigned(FOnRequest) then
    begin
      LHandled := False;
      FOnRequest(Self, LRequest, LResponse, LHandled);

      if LHandled or LResponse.Sent then
        Exit;
    end;

    FRoutersLock.BeginRead;
    try
      LRouters := FRouters.ToArray;
    finally
      FRoutersLock.EndRead;
    end;

    for LRouter in LRouters do
    begin
      if LRouter.IsMatch(LRequest) then
      begin
        LHandled := True;
        LRouter.Execute(LRequest, LResponse, LHandled);

        if LHandled or LResponse.Sent then
          Exit;
      end;
    end;

    if not (LHandled or LResponse.Sent) then
      LResponse.SendStatus(404);
  except
    on e: Exception do
    begin
      if Assigned(FOnRequestException) then
        FOnRequestException(Self, LRequest, LResponse, e)
      else
      if (e is ECrossHttpException) then
        LResponse.SendStatus(ECrossHttpException(e).StatusCode, ECrossHttpException(e).Message)
      else
        LResponse.SendStatus(500, e.Message);
    end;
  end;
end;

function TCrossHttpServer.Get(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := Route('GET', APath, ARouterProc);
end;

function TCrossHttpServer.GetAutoDeleteFiles: Boolean;
begin
  Result := FAutoDeleteFiles;
end;

function TCrossHttpServer.GetCompressible: Boolean;
begin
  Result := FCompressible;
end;

function TCrossHttpServer.GetMaxHeaderSize: Int64;
begin
  Result := FMaxHeaderSize;
end;

function TCrossHttpServer.GetMaxPostDataSize: Int64;
begin
  Result := FMaxPostDataSize;
end;

function TCrossHttpServer.GetMinCompressSize: Int64;
begin
  Result := FMinCompressSize;
end;

function TCrossHttpServer.GetOnPostData: TCrossHttpDataEvent;
begin
  Result := FOnPostData;
end;

function TCrossHttpServer.GetOnPostDataBegin: TCrossHttpConnEvent;
begin
  Result := FOnPostDataBegin;
end;

function TCrossHttpServer.GetOnPostDataEnd: TCrossHttpConnEvent;
begin
  Result := FOnPostDataEnd;
end;

function TCrossHttpServer.GetOnRequest: TCrossHttpRequestEvent;
begin
  Result := FOnRequest;
end;

function TCrossHttpServer.GetOnRequestException: TCrossHttpRequestExceptionEvent;
begin
  Result := FOnRequestException;
end;

function TCrossHttpServer.GetSessionIDCookieName: string;
begin
  Result := FSessionIDCookieName;
end;

function TCrossHttpServer.GetSessions: ISessions;
begin
  Result := FSessions;
end;

function TCrossHttpServer.GetStoragePath: string;
begin
  Result := FStoragePath;
end;

procedure TCrossHttpServer.SetAutoDeleteFiles(const Value: Boolean);
begin
  FAutoDeleteFiles := Value;
end;

procedure TCrossHttpServer.SetCompressible(const Value: Boolean);
begin
  FCompressible := Value;
end;

procedure TCrossHttpServer.SetMaxHeaderSize(const Value: Int64);
begin
  FMaxHeaderSize := Value;
end;

procedure TCrossHttpServer.SetMaxPostDataSize(const Value: Int64);
begin
  FMaxPostDataSize := Value;
end;

procedure TCrossHttpServer.SetMinCompressSize(const Value: Int64);
begin
  FMinCompressSize := Value;
end;

procedure TCrossHttpServer.SetOnPostData(const Value: TCrossHttpDataEvent);
begin
  FOnPostData := Value;
end;

procedure TCrossHttpServer.SetOnPostDataBegin(const Value: TCrossHttpConnEvent);
begin
  FOnPostDataBegin := Value;
end;

procedure TCrossHttpServer.SetOnPostDataEnd(const Value: TCrossHttpConnEvent);
begin
  FOnPostDataEnd := Value;
end;

procedure TCrossHttpServer.SetOnRequest(const Value: TCrossHttpRequestEvent);
begin
  FOnRequest := Value;
end;

procedure TCrossHttpServer.SetOnRequestException(const Value: TCrossHttpRequestExceptionEvent);
begin
  FOnRequestException := Value;
end;

procedure TCrossHttpServer.SetSessionIDCookieName(const Value: string);
begin
  FSessionIDCookieName := Value;
end;

procedure TCrossHttpServer.SetSessions(const Value: ISessions);
begin
  FSessions := Value;
end;

procedure TCrossHttpServer.SetStoragePath(const Value: string);
begin
  FStoragePath := Value;
end;

function TCrossHttpServer.Static(const APath, ALocalStaticDir: string): ICrossHttpServer;
var
  LReqPath: string;
begin
  LReqPath := APath;
  if not LReqPath.EndsWith('/') then
    LReqPath := LReqPath + '/';

  LReqPath := LReqPath + ':file(*)';
  Result := Get(LReqPath, TNetCrossRouter.Static(ALocalStaticDir, 'file'));
end;

function TCrossHttpServer.Index(const APath, ALocalDir: string; const ADefIndexFiles: TArray<string>): ICrossHttpServer;
var
  LReqPath: string;
begin
  LReqPath := APath;
  if not LReqPath.EndsWith('/') then
    LReqPath := LReqPath + '/';

  LReqPath := LReqPath + ':file(*)';
  Result := Get(LReqPath, TNetCrossRouter.Index(ALocalDir, 'file', ADefIndexFiles));
end;

function TCrossHttpServer.IsValidHttpRequest(const ABuf: Pointer; const ALen: Integer): Boolean;
var
  LBytes: TBytes;
begin
  for var I := Low(FMethodTags) to High(FMethodTags) do
  begin
    LBytes := FMethodTags[I];
    if (ALen >= Length(LBytes)) and
      CompareMem(ABuf, Pointer(LBytes), Length(LBytes)) then
        Exit(True);
  end;
  Result := False;
end;

procedure TCrossHttpServer.ParseRecvData(const AConnection: ICrossConnection; const ABuf: Pointer; ALen: Integer);
var
  LHttpConnection: ICrossHttpConnection;
  LRequest: TCrossHttpRequest;
  LResponse: TCrossHttpResponse;
  pch: PByte;
  LChunkSize: Integer;
  LLineStr: string;

  procedure _Error(AStatusCode: Integer; const AErrMsg: string);
  begin
    LHttpConnection.Response.SendStatus(AStatusCode, AErrMsg);
  end;

begin
  LHttpConnection := AConnection as ICrossHttpConnection;
  LRequest := LHttpConnection.Request as TCrossHttpRequest;
  LResponse := LHttpConnection.Response as TCrossHttpResponse;

  try
    pch := ABuf;
    while (ALen > 0) do
    begin
      while (ALen > 0) and (LRequest.FParseState <> psDone) do
      begin
        case LRequest.FParseState of
          psHeader:
            begin
              case pch^ of
                13{\r}: Inc(LRequest.CR);
                10{\n}: Inc(LRequest.LF);
              else
                LRequest.CR := 0;
                LRequest.LF := 0;
              end;

              if (FMaxHeaderSize > 0) and (LRequest.FRawRequest.Size + 1 > FMaxHeaderSize) then
              begin
                _Error(400, 'Request header too large.');
                Exit;
              end;

              LRequest.FRawRequest.Write(pch^, 1);
              Dec(ALen);
              Inc(pch);

              if (LRequest.FRawRequest.Size = 8) and not IsValidHttpRequest(LRequest.FRawRequest.Memory, LRequest.FRawRequest.Size) then
              begin
                _Error(400, 'Request method invalid.');
                Exit;
              end;

              if (LRequest.CR = 2) and (LRequest.LF = 2) then
              begin
                LRequest.CR := 0;
                LRequest.LF := 0;

                if not LRequest.ParseRequestData then
                begin
                  _Error(400, 'Request data invalid.');
                  Exit;
                end;

                if (FMaxPostDataSize > 0) and (LRequest.FContentLength > FMaxPostDataSize) then
                begin
                  _Error(400, 'Post data too large.');
                  Exit;
                end;

                if (LRequest.FContentLength > 0) or LRequest.IsChunked then
                begin
                  LRequest.FPostDataSize := 0;

                  if LRequest.IsChunked then
                  begin
                    LRequest.FParseState := psChunkSize;
                    LRequest.FChunkSizeStream := TBytesStream.Create(nil);
                  end
                  else
                    LRequest.FParseState := psPostData;

                  TriggerPostDataBegin(LHttpConnection);
                end else
                begin
                  LRequest.FBodyType := btNone;
                  LRequest.FParseState := psDone;
                  Break;
                end;
              end;
            end;
          psPostData:
            begin
              LChunkSize := Min((LRequest.ContentLength - LRequest.FPostDataSize), ALen);
              if (FMaxPostDataSize > 0) and (LRequest.FPostDataSize + LChunkSize > FMaxPostDataSize) then
              begin
                _Error(400, 'Post data too large.');
                Exit;
              end;
              TriggerPostData(LHttpConnection, pch, LChunkSize);

              Inc(LRequest.FPostDataSize, LChunkSize);
              Inc(pch, LChunkSize);
              Dec(ALen, LChunkSize);

              if (LRequest.FPostDataSize >= LRequest.ContentLength) then
              begin
                LRequest.FParseState := psDone;
                TriggerPostDataEnd(LHttpConnection);
                Break;
              end;
            end;
          psChunkSize:
            begin
              case pch^ of
                13{\r}: Inc(LRequest.CR);
                10{\n}: Inc(LRequest.LF);
              else
                LRequest.CR := 0;
                LRequest.LF := 0;
                LRequest.FChunkSizeStream.Write(pch^, 1);
              end;
              Dec(ALen);
              Inc(pch);

              if (LRequest.CR = 1) and (LRequest.LF = 1) then
              begin
                SetString(LLineStr, MarshaledAString(LRequest.FChunkSizeStream.Memory), LRequest.FChunkSizeStream.Size);
                LRequest.FParseState := psChunkData;
                LRequest.FChunkSize := StrToIntDef('$' + Trim(LLineStr), -1);
                LRequest.FChunkLeftSize := LRequest.FChunkSize;
              end;
            end;
          psChunkData:
            begin
              if (LRequest.FChunkLeftSize > 0) then
              begin
                LChunkSize := Min(LRequest.FChunkLeftSize, ALen);
                if (FMaxPostDataSize > 0) and (LRequest.FPostDataSize + LChunkSize > FMaxPostDataSize) then
                begin
                  _Error(400, 'Post data too large.');
                  Exit;
                end;
                TriggerPostData(LHttpConnection, pch, LChunkSize);

                Inc(LRequest.FPostDataSize, LChunkSize);
                Dec(LRequest.FChunkLeftSize, LChunkSize);
                Inc(pch, LChunkSize);
                Dec(ALen, LChunkSize);
              end;

              if (LRequest.FChunkLeftSize <= 0) then
              begin
                LRequest.FParseState := psChunkEnd;
                LRequest.CR := 0;
                LRequest.LF := 0;
              end;
            end;
          psChunkEnd:
            begin
              case pch^ of
                13{\r}: Inc(LRequest.CR);
                10{\n}: Inc(LRequest.LF);
              else
                LRequest.CR := 0;
                LRequest.LF := 0;
              end;
              Dec(ALen);
              Inc(pch);

              if (LRequest.CR = 1) and (LRequest.LF = 1) then
              begin
                if (LRequest.FChunkSize > 0) then
                begin
                  LRequest.FParseState := psChunkSize;
                  LRequest.FChunkSizeStream.Clear;
                  LRequest.CR := 0;
                  LRequest.LF := 0;
                end else
                begin
                  LRequest.FParseState := psDone;
                  FreeAndNil(LRequest.FChunkSizeStream);
                  TriggerPostDataEnd(LHttpConnection);
                  Break;
                end;
              end;
            end;
        end;
      end;

      if (LRequest.FParseState = psDone) then
      begin
        LResponse.Reset;
        DoOnRequest(LHttpConnection);
        LRequest.Reset;
      end;
    end;
  except
    on e: Exception do
      _Error(500, e.Message);
  end;
end;

function TCrossHttpServer.Post(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := Route('POST', APath, ARouterProc);
end;

function TCrossHttpServer.Put(const APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := Route('PUT', APath, ARouterProc);
end;

function TCrossHttpServer.RegisterMiddleware(const AMethod, APath: string; const AMiddlewareProc: TCrossHttpRouterProc): TCrossHttpServer;
begin
  var LMiddleware := CreateRouter(AMethod, APath, AMiddlewareProc);
  FMiddlewaresLock.BeginWrite;
  try
    FMiddlewares.Add(LMiddleware);
  finally
    FMiddlewaresLock.EndWrite;
  end;
  Result := Self;
end;

function TCrossHttpServer.RegisterRouter(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc): TCrossHttpServer;
begin
  var LRouter := CreateRouter(AMethod, APath, ARouterProc);
  FRoutersLock.BeginWrite;
  try
    FRouters.Add(LRouter);
  finally
    FRoutersLock.EndWrite;
  end;
  Result := Self;
end;

function TCrossHttpServer.Route(const AMethod, APath: string; const ARouterProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := RegisterRouter(AMethod, APath, ARouterProc);
end;

function TCrossHttpServer.RemoveRouter(const AMethod, APath: string): ICrossHttpServer;
begin
  FRoutersLock.BeginWrite;
  try
    for var I := FRouters.Count - 1 downto 0 do
      if SameText(FRouters[I].Method, AMethod) and SameText(FRouters[I].Path, APath) then
        FRouters.Delete(I);
  finally
    FRoutersLock.EndWrite;
  end;
  Result := Self;
end;

function TCrossHttpServer.ClearRouter: ICrossHttpServer;
begin
  FRoutersLock.BeginWrite;
  try
    FRouters.Clear;
  finally
    FRoutersLock.EndWrite;
  end;
  Result := Self;
end;

procedure TCrossHttpServer.TriggerPostDataBegin(const AConnection: ICrossHttpConnection);
var
  LRequest: TCrossHttpRequest;
  LMultiPart: THttpMultiPartFormData;
  LStream: TStream;
begin
  LRequest := AConnection.Request as TCrossHttpRequest;
  case LRequest.BodyType of
    btMultiPart:
      begin
        if (FStoragePath <> '') and not TDirectory.Exists(FStoragePath) then
          TDirectory.CreateDirectory(FStoragePath);

        LMultiPart := THttpMultiPartFormData.Create;
        LMultiPart.StoragePath := FStoragePath;
        LMultiPart.AutoDeleteFiles := FAutoDeleteFiles;
        LMultiPart.InitWithBoundary(LRequest.RequestBoundary);
        FreeAndNil(LRequest.FBody);
        LRequest.FBody := LMultiPart;
      end;
    btUrlEncoded:
      begin
        LStream := TBytesStream.Create;
        FreeAndNil(LRequest.FBody);
        LRequest.FBody := LStream;
      end;
    btBinary:
      begin
        LStream := TBytesStream.Create(nil);
        FreeAndNil(LRequest.FBody);
        LRequest.FBody := LStream;
      end;
  end;

  if Assigned(FOnPostDataBegin) then
    FOnPostDataBegin(Self, AConnection);
end;

procedure TCrossHttpServer.TriggerPostData(const AConnection: ICrossHttpConnection; const ABuf: Pointer; const ALen: Integer);
begin
  var LRequest := AConnection.Request as TCrossHttpRequest;

  case LRequest.GetBodyType of
    btMultiPart:
      (LRequest.Body as THttpMultiPartFormData).Decode(ABuf, ALen);
    btUrlEncoded:
      (LRequest.Body as TStream).Write(ABuf^, ALen);
    btBinary:
      (LRequest.Body as TStream).Write(ABuf^, ALen);
  end;

  if Assigned(FOnPostData) then
    FOnPostData(Self, AConnection, ABuf, ALen);
end;

procedure TCrossHttpServer.TriggerPostDataEnd(const AConnection: ICrossHttpConnection);
var
  LUrlEncodedStr: string;
  LUrlEncodedBody: THttpUrlParams;
begin
  var LRequest := AConnection.Request as TCrossHttpRequest;

  case LRequest.GetBodyType of
    btUrlEncoded:
      begin
        SetString(LUrlEncodedStr, MarshaledAString((LRequest.Body as TBytesStream).Memory), (LRequest.Body as TBytesStream).Size);
        LUrlEncodedBody := THttpUrlParams.Create;
        LUrlEncodedBody.Decode(LUrlEncodedStr);
        FreeAndNil(LRequest.FBody);
        LRequest.FBody := LUrlEncodedBody;
      end;
    btBinary:
      begin
        (LRequest.Body as TStream).Position := 0;
      end;
  end;

  if Assigned(FOnPostDataEnd) then
    FOnPostDataEnd(Self, AConnection);
end;

function TCrossHttpServer.LockMiddlewares: TCrossHttpRouters;
begin
  Result := FMiddlewares;
  FMiddlewaresLock.BeginWrite;
end;

function TCrossHttpServer.LockRouters: TCrossHttpRouters;
begin
  Result := FRouters;
  FRoutersLock.BeginWrite;
end;

procedure TCrossHttpServer.LogicReceived(const AConnection: ICrossConnection; const ABuf: Pointer; const ALen: Integer);
begin
  ParseRecvData(AConnection as ICrossHttpConnection, ABuf, ALen);
end;

function TCrossHttpServer.Use(const AMethod, APath: string; const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := RegisterMiddleware(AMethod, APath, AMiddlewareProc);
end;

function TCrossHttpServer.Use(const APath: string; const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := Use('*', APath, AMiddlewareProc);
end;

procedure TCrossHttpServer.UnlockMiddlewares;
begin
  FMiddlewaresLock.EndWrite;
end;

procedure TCrossHttpServer.UnlockRouters;
begin
  FRoutersLock.EndWrite;
end;

function TCrossHttpServer.Use(const AMiddlewareProc: TCrossHttpRouterProc): ICrossHttpServer;
begin
  Result := Use('*', '*', AMiddlewareProc);
end;

{ TCrossHttpRequest }

constructor TCrossHttpRequest.Create(const AConnection: ICrossHttpConnection);
begin
  FConnection := AConnection;

  FRawRequest := TBytesStream.Create(nil);
  FHeader := THttpHeader.Create;
  FCookies := TRequestCookies.Create;
  FParams := THttpUrlParams.Create;
  FQuery := THttpUrlParams.Create;

  Reset;
end;

destructor TCrossHttpRequest.Destroy;
begin
  FreeAndNil(FRawRequest);
  FreeAndNil(FHeader);
  FreeAndNil(FCookies);
  FreeAndNil(FParams);
  FreeAndNil(FQuery);
  FreeAndNil(FBody);

  inherited;
end;

function TCrossHttpRequest.GetAccept: string;
begin
  Result := FAccept;
end;

function TCrossHttpRequest.GetAcceptEncoding: string;
begin
  Result := FAcceptEncoding;
end;

function TCrossHttpRequest.GetAcceptLanguage: string;
begin
  Result := FAcceptLanguage;
end;

function TCrossHttpRequest.GetAuthorization: string;
begin
  Result := FAuthorization;
end;

function TCrossHttpRequest.GetBody: TObject;
begin
  Result := FBody;
end;

function TCrossHttpRequest.GetBodyType: TBodyType;
begin
  Result := FBodyType;
end;

function TCrossHttpRequest.GetConnection: ICrossHttpConnection;
begin
  Result := FConnection;
end;

function TCrossHttpRequest.GetContentEncoding: string;
begin
  Result := FContentEncoding;
end;

function TCrossHttpRequest.GetContentLength: Int64;
begin
  Result := FContentLength;
end;

function TCrossHttpRequest.GetContentType: string;
begin
  Result := FContentType;
end;

function TCrossHttpRequest.GetCookies: TRequestCookies;
begin
  Result := FCookies;
end;

function TCrossHttpRequest.GetHeader: THttpHeader;
begin
  Result := FHeader;
end;

function TCrossHttpRequest.GetHostName: string;
begin
  Result := FHostName;
end;

function TCrossHttpRequest.GetHostPort: Word;
begin
  Result := FHostPort;
end;

function TCrossHttpRequest.GetIfModifiedSince: TDateTime;
begin
  Result := FIfModifiedSince;
end;

function TCrossHttpRequest.GetIfNoneMatch: string;
begin
  Result := FIfNoneMatch;
end;

function TCrossHttpRequest.GetIfRange: string;
begin
  Result := FIfRange;
end;

function TCrossHttpRequest.GetIsChunked: Boolean;
begin
  Result := SameText(FTransferEncoding, 'chunked');
end;

function TCrossHttpRequest.GetIsMultiPartFormData: Boolean;
begin
  Result := SameText(FContentType, 'multipart/form-data');
end;

function TCrossHttpRequest.GetIsUrlEncodedFormData: Boolean;
begin
  Result := SameText(FContentType, 'application/x-www-form-urlencoded');
end;

function TCrossHttpRequest.GetKeepAlive: Boolean;
begin
  Result := FKeepAlive;
end;

function TCrossHttpRequest.GetMethod: string;
begin
  Result := FMethod;
end;

function TCrossHttpRequest.GetParams: THttpUrlParams;
begin
  Result := FParams;
end;

function TCrossHttpRequest.GetPath: string;
begin
  Result := FPath;
end;

function TCrossHttpRequest.GetPostDataSize: Int64;
begin
  Result := FPostDataSize;
end;

function TCrossHttpRequest.GetQuery: THttpUrlParams;
begin
  Result := FQuery;
end;

function TCrossHttpRequest.GetRange: string;
begin
  Result := FRange;
end;

function TCrossHttpRequest.GetRawPathAndParams: string;
begin
  Result := FRawPathAndParams;
end;

function TCrossHttpRequest.GetRawRequestText: string;
begin
  Result := FRawRequestText;
end;

function TCrossHttpRequest.GetReferer: string;
begin
  Result := FReferer;
end;

function TCrossHttpRequest.GetRequestBoundary: string;
begin
  Result := FRequestBoundary;
end;

function TCrossHttpRequest.GetRequestCmdLine: string;
begin
  Result := FRequestCmdLine;
end;

function TCrossHttpRequest.GetRequestConnection: string;
begin
  Result := FRequestConnection;
end;

function TCrossHttpRequest.GetSession: ISession;
begin
  Result := FSession;
end;

function TCrossHttpRequest.GetTransferEncoding: string;
begin
  Result := FTransferEncoding;
end;

function TCrossHttpRequest.GetUserAgent: string;
begin
  Result := FUserAgent;
end;

function TCrossHttpRequest.GetVersion: string;
begin
  Result := FVersion;
end;

function TCrossHttpRequest.GetXForwardedFor: string;
begin
  Result := FXForwardedFor;
end;

function TCrossHttpRequest.ParseRequestData: Boolean;
var
  LRequestHeader: string;
  I, J: Integer;
begin
  SetString(FRawRequestText, MarshaledAString(FRawRequest.Memory), FRawRequest.Size);
  I := FRawRequestText.IndexOf(#13#10);
  FRequestCmdLine := FRawRequestText.Substring(0, I);
  LRequestHeader := FRawRequestText.Substring(I + 2);
  FHeader.Decode(LRequestHeader);

  I := FRequestCmdLine.IndexOf(' ');
  FMethod := FRequestCmdLine.Substring(0, I).ToUpper;

  J := FRequestCmdLine.IndexOf(' ', I + 1);
  FRawPathAndParams := FRequestCmdLine.Substring(I + 1, J - I - 1);

  FVersion := FRequestCmdLine.Substring(J + 1).ToUpper;

  J := FRawPathAndParams.IndexOf('?');
  if (J < 0) then
  begin
    FRawPath := FRawPathAndParams;
    FRawParamsText := '';
  end
  else
  begin
    FRawPath := FRawPathAndParams.Substring(0, J);
    FRawParamsText := FRawPathAndParams.Substring(J + 1);
  end;
  FPath := TNetEncoding.URL.Decode(FRawPath);

  FQuery.Decode(FRawParamsText);

  if (FVersion = '') then
    FVersion := 'HTTP/1.0';

  if (FVersion = 'HTTP/1.0') then
    FHttpVerNum := 10
  else
    FHttpVerNum := 11;

  FKeepAlive := (FHttpVerNum = 11);

  FCookies.Decode(FHeader['Cookie'], True);

  FContentType := FHeader['Content-Type'];
  FRequestBoundary := '';
  J := FContentType.IndexOf(';');
  if (J >= 0) then
  begin
    FRequestBoundary := FContentType.Substring(J + 1);
    if FRequestBoundary.StartsWith(' boundary=', True) then
      FRequestBoundary := FRequestBoundary.Substring(10);

    FContentType := FContentType.Substring(0, J);
  end;

  FContentLength := StrToInt64Def(FHeader['Content-Length'], -1);

  FRequestHost := FHeader['Host'];
  J := FRequestHost.IndexOf(']');
  if (J < 0) then
    J := 0;

  J := FRequestHost.IndexOf(':', J);
  if (J >= 0) then
  begin
    FHostName := FRequestHost.Substring(0, J);
    FHostPort := FRequestHost.Substring(J + 1).ToInteger;
  end
  else
  begin
    FHostName := FRequestHost;
    FHostPort := TCrossHttpServer(FConnection.Owner).Port;
  end;

  FRequestConnection := FHeader['Connection'];
  if FHttpVerNum = 10 then
    FKeepAlive := SameText(FRequestConnection, 'keep-alive')
  else
  if SameText(FRequestConnection, 'close') then
    FKeepAlive := False;

  FTransferEncoding := FHeader['Transfer-Encoding'];
  FContentEncoding := FHeader['Content-Encoding'];
  FAccept := FHeader['Accept'];
  FReferer := FHeader['Referer'];
  FAcceptLanguage := FHeader['Accept-Language'];
  FAcceptEncoding := FHeader['Accept-Encoding'];
  FUserAgent := FHeader['User-Agent'];
  FAuthorization := FHeader['Authorization'];
  FRequestCookies := FHeader['Cookie'];
  FIfModifiedSince := TCrossHttpUtils.RFC1123_StrToDate(FHeader['If-Modified-Since']);
  FIfNoneMatch := FHeader['If-None-Match'];
  FRange := FHeader['Range'];
  FIfRange := FHeader['If-Range'];
  FXForwardedFor:= FHeader['X-Forwarded-For'];

  if IsMultiPartFormData then
    FBodyType := btMultiPart
  else
  if IsUrlEncodedFormData then
    FBodyType := btUrlEncoded
  else
    FBodyType := btBinary;

  Result := True;
end;

procedure TCrossHttpRequest.Reset;
begin
  FRawRequest.Clear;

  FParseState := psHeader;
  CR := 0;
  LF := 0;
  FPostDataSize := 0;
  FreeAndNil(FBody);
end;

{ TCrossHttpResponse }

constructor TCrossHttpResponse.Create(const AConnection: ICrossHttpConnection);
begin
  FConnection := AConnection;
  FRequest := AConnection.Request;
  FHeader := THttpHeader.Create;
  FCookies := TResponseCookies.Create;
  FStatusCode := 200;
end;

destructor TCrossHttpResponse.Destroy;
begin
  FreeAndNil(FHeader);
  FreeAndNil(FCookies);

  inherited;
end;

procedure TCrossHttpResponse.Download(const AFileName: string; const ACallback: TCrossConnectionCallback);
begin
  Attachment(AFileName);
  SendFile(AFileName, ACallback);
end;

function TCrossHttpResponse.GetConnection: ICrossHttpConnection;
begin
  Result := FConnection;
end;

function TCrossHttpResponse.GetContentType: string;
begin
  Result := FHeader['Content-Type'];
end;

function TCrossHttpResponse.GetCookies: TResponseCookies;
begin
  Result := FCookies;
end;

function TCrossHttpResponse.GetHeader: THttpHeader;
begin
  Result := FHeader;
end;

function TCrossHttpResponse.GetLocation: string;
begin
  Result := FHeader['Location'];
end;

function TCrossHttpResponse.GetRequest: ICrossHttpRequest;
begin
  Result := FRequest;
end;

function TCrossHttpResponse.GetSent: Boolean;
begin
  Result := (AtomicCmpExchange(FSendStatus, 0, 0) > 0);
end;

function TCrossHttpResponse.GetStatusCode: Integer;
begin
  Result := FStatusCode;
end;

procedure TCrossHttpResponse.Json(const AJson: string; const ACallback: TCrossConnectionCallback);
begin
  SetContentType(TMediaType.APPLICATION_JSON_UTF8);
  Send(AJson, ACallback);
end;

procedure TCrossHttpResponse.Redirect(const AUrl: string; const ACallback: TCrossConnectionCallback);
begin
  SetLocation(AUrl);
  SendStatus(302, '', ACallback);
end;

procedure TCrossHttpResponse.Reset;
begin
  FStatusCode :=  200;
  FHeader.Clear;
  FCookies.Clear;
  FSendStatus := 0;
end;

procedure TCrossHttpResponse.Attachment(const AFileName: string);
begin
  if (GetContentType = '') then
    SetContentType(TCrossHttpUtils.GetFileMIMEType(AFileName));

  FHeader['Content-Disposition'] := 'attachment; filename="' + TNetEncoding.URL.Encode(TPath.GetFileName(AFileName)) + '"';
end;

procedure TCrossHttpResponse.Send(const ABody; const ACount: NativeInt; const ACallback: TCrossConnectionCallback);
var
  LCompressType: TCompressType;
begin
  if _CheckCompress(ACount, LCompressType) then
    SendZCompress(ABody, ACount, LCompressType, ACallback)
  else
    SendNoCompress(ABody, ACount, ACallback);
end;

procedure TCrossHttpResponse.Send(const ABody: TBytes; const AOffset, ACount: NativeInt; const ACallback: TCrossConnectionCallback);
begin
  var LBody := ABody;
  var LOffset := AOffset;
  var LCount := ACount;

  _AdjustOffsetCount(Length(ABody), LOffset, LCount);

  Send(LBody[LOffset], LCount,
    // CALLBACK
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LBody := nil;

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.Send(const ABody: TBytes; const ACallback: TCrossConnectionCallback);
begin
  Send(ABody, 0, Length(ABody), ACallback);
end;

procedure TCrossHttpResponse.Send(const ABody: TStream; const AOffset, ACount: Int64; const ACallback: TCrossConnectionCallback);
var
  LCompressType: TCompressType;
begin
  if _CheckCompress(ABody.Size, LCompressType) then
    SendZCompress(ABody, AOffset, ACount, LCompressType, ACallback)
  else
    SendNoCompress(ABody, AOffset, ACount, ACallback);
end;

procedure TCrossHttpResponse.Send(const ABody: TStream; const ACallback: TCrossConnectionCallback);
begin
  Send(ABody, 0, 0, ACallback);
end;

procedure TCrossHttpResponse.Send(const ABody: string; const ACallback: TCrossConnectionCallback);
begin
  var LBody := TEncoding.UTF8.GetBytes(ABody);
  if (GetContentType = '') then
    SetContentType(TMediaType.TEXT_HTML_UTF8);

  Send(LBody, ACallback);
end;

procedure TCrossHttpResponse.SendNoCompress(const AChunkSource: TCrossHttpChunkDataFunc; const ACallback: TCrossConnectionCallback);
type
  TChunkState = (csHead, csBody, csDone);
const
  CHUNK_END: array [0..6] of Byte = (13, 10, 48, 13, 10, 13, 10); // \r\n0\r\n\r\n
var
  LHeaderBytes, LChunkHeader: TBytes;
  LIsFirstChunk: Boolean;
  LChunkState: TChunkState;
  LChunkData: Pointer;
  LChunkSize: NativeInt;
begin
  LIsFirstChunk := True;
  LChunkState := csHead;

  _Send(
    // HEADER
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      LHeaderBytes := _CreateHeader(0, True);

      AData^ := @LHeaderBytes[0];
      ACount^ := Length(LHeaderBytes);

      Result := (ACount^ > 0);
    end,
    // BODY
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      case LChunkState of
        csHead:
          begin
            LChunkData := nil;
            LChunkSize := 0;
            if not Assigned(AChunkSource)
              or not AChunkSource(@LChunkData, @LChunkSize)
              or (LChunkData = nil)
              or (LChunkSize <= 0) then
            begin
              LChunkState := csDone;

              AData^ := @CHUNK_END[0];
              ACount^ := Length(CHUNK_END);

              Result := (ACount^ > 0);

              Exit;
            end;

            LChunkHeader := TEncoding.ANSI.GetBytes(IntToHex(LChunkSize, 0)) + [13, 10];
            if LIsFirstChunk then
              LIsFirstChunk := False
            else
              LChunkHeader := [13, 10] + LChunkHeader;

            LChunkState := csBody;

            AData^ := @LChunkHeader[0];
            ACount^ := Length(LChunkHeader);

            Result := (ACount^ > 0);
          end;
        csBody:
          begin
            LChunkState := csHead;

            AData^ := LChunkData;
            ACount^ := LChunkSize;

            Result := (ACount^ > 0);
          end;
        csDone:
          begin
            Result := False;
          end;
      else
        Result := False;
      end;
    end,
    // CALLBACK
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LHeaderBytes := nil;
      LChunkHeader := nil;

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.SendFile(const AFileName: string; const ACallback: TCrossConnectionCallback);
var
  LStream: TFileStream;
  LLastModified: TDateTime;
  LRequest: TCrossHttpRequest;
  LLastModifiedStr, LETag: string;
  LRangeStr: string;
  LRangeStrArr: TArray<string>;
  LRangeBegin, LRangeEnd, LOffset, LCount: Int64;
begin
  if not TFile.Exists(AFileName) then
  begin
    FHeader.Remove('Content-Disposition');
    SendStatus(404, ACallback);
    Exit;
  end;

  if (GetContentType = '') then
    SetContentType(TCrossHttpUtils.GetFileMIMEType(AFileName));

  try
    LRequest := GetRequest as TCrossHttpRequest;
    LLastModified := TFile.GetLastWriteTime(AFileName);

    if (LRequest.IfModifiedSince > 0) and (LRequest.IfModifiedSince >= (LLastModified - (1 / SecsPerDay))) then
    begin
      SendStatus(304, '', ACallback);
      Exit;
    end;

    LLastModifiedStr := TCrossHttpUtils.RFC1123_DateToStr(LLastModified);

    LETag := '"' + TUtils.BytesToHex(THashMD5.GetHashBytes(AFileName + LLastModifiedStr)) + '"';
    if (LRequest.IfNoneMatch = LETag) then
    begin
      SendStatus(304, '', ACallback);
      Exit;
    end;

    LStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  except
    on e: Exception do
    begin
      FHeader.Remove('Content-Disposition');
      SendStatus(404, Format('%s, %s', [e.ClassName, e.Message]), ACallback);
      Exit;
    end;
  end;

  FHeader['Last-Modified'] := LLastModifiedStr;
  FHeader['ETag'] := LETag;
  FHeader['Accept-Ranges'] := 'bytes';

  LRangeStr := LRequest.Range;
  if (LRangeStr <> '') and ((LRequest.IfRange = '') or (LRequest.IfRange = LETag)) then
  begin
    LRangeStr := LRangeStr.Substring(LRangeStr.IndexOf('=') + 1);
    LRangeStrArr := LRangeStr.Split(['-']);
    if (Length(LRangeStrArr) >= 2) then
    begin
      LRangeBegin := StrToInt64Def(LRangeStrArr[0], 0);
      LRangeEnd := StrToInt64Def(LRangeStrArr[1], 0);
    end
    else
    if (Length(LRangeStrArr) >= 1) then
    begin
      LRangeBegin := StrToInt64Def(LRangeStrArr[0], 0);
      LRangeEnd := LStream.Size - 1;
    end
    else
    begin
      LRangeBegin := 0;
      LRangeEnd := LStream.Size - 1;
    end;

    if (LRangeBegin < 0) then
      LRangeBegin := 0;

    if (LRangeEnd <= 0) or (LRangeEnd >= LStream.Size) then
      LRangeEnd := LStream.Size - 1;

    LOffset := LRangeBegin;
    LCount := LRangeEnd - LRangeBegin + 1;

    FHeader['Content-Range'] := Format('bytes %d-%d/%d', [LRangeBegin, LRangeEnd, LStream.Size]);

    FStatusCode := 206;
  end
  else
  begin
    LOffset := 0;
    LCount := LStream.Size;
  end;

  Send(LStream, LOffset, LCount,
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      FreeAndNil(LStream);

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.SetContentType(const Value: string);
begin
  FHeader['Content-Type'] := Value;
end;

procedure TCrossHttpResponse.SetLocation(const Value: string);
begin
  FHeader['Location'] := Value;
end;

procedure TCrossHttpResponse.SetStatusCode(Value: Integer);
begin
  FStatusCode := Value;
end;

procedure TCrossHttpResponse._AdjustOffsetCount(const ABodySize: NativeInt; var AOffset, ACount: NativeInt);
begin
  if (AOffset >= 0) then
  begin
    AOffset := AOffset;
    if (AOffset >= ABodySize) then
      AOffset := ABodySize - 1;
  end
  else
  begin
    AOffset := ABodySize + AOffset;
    if (AOffset < 0) then
      AOffset := 0;
  end;

  if (ACount <= 0) then
    ACount := ABodySize;

  if (ABodySize - AOffset < ACount) then
    ACount := ABodySize - AOffset;
end;

procedure TCrossHttpResponse._AdjustOffsetCount(const ABodySize: Int64; var AOffset, ACount: Int64);
begin
  if (AOffset >= 0) then
  begin
    AOffset := AOffset;
    if (AOffset >= ABodySize) then
      AOffset := ABodySize - 1;
  end
  else
  begin
    AOffset := ABodySize + AOffset;
    if (AOffset < 0) then
      AOffset := 0;
  end;

  if (ACount <= 0) then
    ACount := ABodySize;

  if (ABodySize - AOffset < ACount) then
    ACount := ABodySize - AOffset;
end;

function TCrossHttpResponse._CheckCompress(const ABodySize: Int64; var ACompressType: TCompressType): Boolean;
var
  LContType, LRequestAcceptEncoding: string;
  LServer: ICrossHttpServer;
begin
  LContType := GetContentType;
  LServer := FConnection.Server;

  if LServer.Compressible
    and (ABodySize > 0)
    and ((LServer.MinCompressSize <= 0) or (ABodySize >= LServer.MinCompressSize))
    and ((Pos('text/', LContType) > 0)
      or (Pos('application/json', LContType) > 0)
      or (Pos('javascript', LContType) > 0)
      or (Pos('xml', LContType) > 0)
    ) then
  begin
    LRequestAcceptEncoding := GetRequest.AcceptEncoding;

    if (Pos('gzip', LRequestAcceptEncoding) > 0) then
    begin
      ACompressType := ctGZip;
      Exit(True);
    end else
    if (Pos('deflate', LRequestAcceptEncoding) > 0) then
    begin
      ACompressType := ctDeflate;
      Exit(True);
    end;
  end;

  Result := False;
end;

function TCrossHttpResponse._CreateHeader(const ABodySize: Int64; AChunked: Boolean): TBytes;
var
  LHeaderStr: string;
  LCookie: TResponseCookie;
begin
  if (GetContentType = '') then
    SetContentType(TMediaType.APPLICATION_OCTET_STREAM);

  if (FHeader['Connection'] = '') then
  begin
    if FRequest.KeepAlive then
      FHeader['Connection'] := 'keep-alive'
    else
      FHeader['Connection'] := 'close';
  end;

  if AChunked then
    FHeader['Transfer-Encoding'] := 'chunked'
  else
    FHeader['Content-Length'] := ABodySize.ToString;

  if (FHeader['Server'] = '') then
    FHeader['Server'] := CROSS_HTTP_SERVER_NAME;

  LHeaderStr := FRequest.Version + ' ' + FStatusCode.ToString + ' ' + TCrossHttpUtils.GetHttpStatusText(FStatusCode) + #13#10;

  for LCookie in FCookies do
    LHeaderStr := LHeaderStr + 'Set-Cookie: ' + LCookie.Encode + #13#10;

  LHeaderStr := LHeaderStr + FHeader.Encode;

  Result := TEncoding.ANSI.GetBytes(LHeaderStr);
end;

procedure TCrossHttpResponse._Send(const ASource: TCrossHttpChunkDataFunc; const ACallback: TCrossConnectionCallback);
var
  LSender: TCrossConnectionCallback;
  LKeepAlive: Boolean;
  LStatusCode: Integer;
begin
  AtomicIncrement(FSendStatus);

  LKeepAlive := FRequest.KeepAlive;
  LStatusCode := FStatusCode;

  LSender :=
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    var
      LData: Pointer;
      LCount: NativeInt;
    begin
      if not ASuccess then
      begin
        if Assigned(ACallback) then
          ACallback(AConnection, False);

        AConnection.Close;

        LSender := nil;

        Exit;
      end;

      LData := nil;
      LCount := 0;
      if not Assigned(ASource)
        or not ASource(@LData, @LCount)
        or (LData = nil)
        or (LCount <= 0) then
      begin
        if Assigned(ACallback) then
          ACallback(AConnection, True);

        if not LKeepAlive
          or (LStatusCode >= 400) then
          AConnection.Disconnect;

        LSender := nil;

        Exit;
      end;

      AConnection.SendBuf(LData^, LCount, LSender);
    end;

  LSender(FConnection, True);
end;

procedure TCrossHttpResponse._Send(const AHeaderSource, ABodySource: TCrossHttpChunkDataFunc; const ACallback: TCrossConnectionCallback);
begin
  var LHeaderDone := False;

  _Send(
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      if not LHeaderDone then
      begin
        LHeaderDone := True;
        Result := Assigned(AHeaderSource) and AHeaderSource(AData, ACount);
      end
      else
      begin
        Result := Assigned(ABodySource) and ABodySource(AData, ACount);
      end;
    end,
    ACallback);
end;

procedure TCrossHttpResponse.SendNoCompress(const ABody; const ACount: NativeInt; const ACallback: TCrossConnectionCallback);
var
  P: PByte;
  LSize: NativeInt;
  LHeaderBytes: TBytes;
begin
  P := @ABody;
  LSize := ACount;

  _Send(
    // HEADER
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      LHeaderBytes := _CreateHeader(LSize, False);

      AData^ := @LHeaderBytes[0];
      ACount^ := Length(LHeaderBytes);

      Result := (ACount^ > 0);
    end,
    // BODY
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      AData^ := P;
      ACount^ := Min(LSize, SND_BUF_SIZE);
      Result := (ACount^ > 0);

      if (LSize > SND_BUF_SIZE) then
      begin
        Inc(P, SND_BUF_SIZE);
        Dec(LSize, SND_BUF_SIZE);
      end
      else
      begin
        LSize := 0;
        P := nil;
      end;
    end,
    // CALLBACK
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LHeaderBytes := nil;

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.SendNoCompress(const ABody: TBytes; const AOffset, ACount: NativeInt; const ACallback: TCrossConnectionCallback);
begin
  var LBody := ABody;
  var LOffset := AOffset;
  var LCount := ACount;

  _AdjustOffsetCount(Length(ABody), LOffset, LCount);

  SendNoCompress(LBody[LOffset], LCount,
    // CALLBACK
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LBody := nil;

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.SendNoCompress(const ABody: TBytes; const ACallback: TCrossConnectionCallback);
begin
  SendNoCompress(ABody, 0, Length(ABody), ACallback);
end;

procedure TCrossHttpResponse.SendNoCompress(const ABody: TStream; const AOffset, ACount: Int64; const ACallback: TCrossConnectionCallback);
var
  LHeaderBytes, LBuffer: TBytes;
begin
  var LOffset := AOffset;
  var LCount := ACount;

  _AdjustOffsetCount(ABody.Size, LOffset, LCount);

  if (ABody is TCustomMemoryStream) then
  begin
    SendNoCompress(Pointer(IntPtr(TCustomMemoryStream(ABody).Memory) + LOffset)^, LCount, ACallback);
    Exit;
  end;

  var LBody := ABody;
  LBody.Position := LOffset;

  SetLength(LBuffer, SND_BUF_SIZE);

  _Send(
    // HEADER
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      LHeaderBytes := _CreateHeader(LCount, False);

      AData^ := @LHeaderBytes[0];
      ACount^ := Length(LHeaderBytes);

      Result := (ACount^ > 0);
    end,
    // BODY
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      if (LCount <= 0) then
        Exit(False);

      AData^ := @LBuffer[0];
      ACount^ := LBody.Read(LBuffer[0], Min(LCount, SND_BUF_SIZE));

      Result := (ACount^ > 0);

      if Result then
        Dec(LCount, ACount^);
    end,
    // CALLBACK
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LHeaderBytes := nil;
      LBuffer := nil;

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.SendNoCompress(const ABody: TStream; const ACallback: TCrossConnectionCallback);
begin
  SendNoCompress(ABody, 0, 0, ACallback);
end;

procedure TCrossHttpResponse.SendNoCompress(const ABody: string; const ACallback: TCrossConnectionCallback);
begin
  var LBody := TEncoding.UTF8.GetBytes(ABody);
  if (GetContentType = '') then
    SetContentType(TMediaType.TEXT_HTML_UTF8);

  SendNoCompress(LBody, ACallback);
end;

procedure TCrossHttpResponse.SendStatus(const AStatusCode: Integer; const ADescription: string; const ACallback: TCrossConnectionCallback);
begin
  FStatusCode := AStatusCode;
  Send(ADescription, ACallback);
end;

procedure TCrossHttpResponse.SendStatus(const AStatusCode: Integer; const ACallback: TCrossConnectionCallback);
begin
  SendStatus(AStatusCode, TCrossHttpUtils.GetHttpStatusText(AStatusCode), ACallback);
end;

procedure TCrossHttpResponse.SendZCompress(const AChunkSource: TCrossHttpChunkDataFunc; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback);
const
  WINDOW_BITS: array [TCompressType] of Integer = (15 + 16{gzip}, 15{deflate});
  CONTENT_ENCODING: array [TCompressType] of string = ('gzip', 'deflate');
var
  LZStream: TZStreamRec;
  LZFlush: Integer;
  LZResult: Integer;
  LOutSize: Integer;
  LBuffer: TBytes;
begin
  FHeader['Content-Encoding'] := CONTENT_ENCODING[ACompressType];
  FHeader['Vary'] := 'Accept-Encoding';

  SetLength(LBuffer, SND_BUF_SIZE);

  FillChar(LZStream, SizeOf(TZStreamRec), 0);
  LZResult := Z_OK;
  LZFlush := Z_NO_FLUSH;

  if (deflateInit2(LZStream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, WINDOW_BITS[ACompressType], 8, Z_DEFAULT_STRATEGY) <> Z_OK) then
  begin
    if Assigned(ACallback) then
      ACallback(FConnection, False);

    Exit;
  end;

  SendNoCompress(
    // CHUNK
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    var
      LChunkData: Pointer;
      LChunkSize: NativeInt;
    begin
      repeat
        if (LZResult = Z_STREAM_END) then
        begin
          AData^ := nil;
          ACount^ := 0;
          Exit(False);
        end;

        if (LZStream.avail_in = 0) then
        begin
          LChunkData := nil;
          LChunkSize := 0;
          if not Assigned(AChunkSource) or not AChunkSource(@LChunkData, @LChunkSize) or (LChunkData = nil) or (LChunkSize <= 0) then
            LZFlush := Z_FINISH
          else
            LZFlush := Z_NO_FLUSH;

          LZStream.avail_in := LChunkSize;
          LZStream.next_in := LChunkData;
        end;

        LZStream.avail_out := SND_BUF_SIZE;
        LZStream.next_out := @LBuffer[0];

        LZResult := deflate(LZStream, LZFlush);

        if (LZResult < 0) then
        begin
          AData^ := nil;
          ACount^ := 0;
          Exit(False);
        end;

        LOutSize := SND_BUF_SIZE - LZStream.avail_out;
      until (LOutSize > 0);

      AData^ := @LBuffer[0];
      ACount^ := LOutSize;

      Result := (ACount^ > 0);
    end,
    // CALLBACK
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LBuffer := nil;
      deflateEnd(LZStream);

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.SendZCompress(const ABody; const ACount: NativeInt; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback);
var
  P: PByte;
  LSize: NativeInt;
begin
  P := @ABody;
  LSize := ACount;

  SendZCompress(
    // CHUNK
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      AData^ := P;
      ACount^ := Min(LSize, SND_BUF_SIZE);
      Result := (ACount^ > 0);

      if (LSize > SND_BUF_SIZE) then
      begin
        Inc(P, SND_BUF_SIZE);
        Dec(LSize, SND_BUF_SIZE);
      end else
      begin
        LSize := 0;
        P := nil;
      end;
    end,
    ACompressType,
    ACallback);
end;

procedure TCrossHttpResponse.SendZCompress(const ABody: TBytes;
  const AOffset, ACount: NativeInt; const ACompressType: TCompressType;
  const ACallback: TCrossConnectionCallback);
var
  LBody: TBytes;
  LOffset, LCount: NativeInt;
begin
  LBody := ABody;

  LOffset := AOffset;
  LCount := ACount;
  _AdjustOffsetCount(Length(ABody), LOffset, LCount);

  SendZCompress(LBody[LOffset], LCount, ACompressType,
    // CALLBACK
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LBody := nil;

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.SendZCompress(const ABody: TBytes; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback);
begin
  SendZCompress(ABody, 0, Length(ABody), ACompressType, ACallback);
end;

procedure TCrossHttpResponse.SendZCompress(const ABody: TStream;
  const AOffset, ACount: Int64; const ACompressType: TCompressType;
  const ACallback: TCrossConnectionCallback);
var
  LOffset, LCount: Int64;
  LBody: TStream;
  LBuffer: TBytes;
begin
  LOffset := AOffset;
  LCount := ACount;
  _AdjustOffsetCount(ABody.Size, LOffset, LCount);

  if (ABody is TCustomMemoryStream) then
  begin
    SendZCompress(Pointer(IntPtr(TCustomMemoryStream(ABody).Memory) + LOffset)^, LCount, ACompressType, ACallback);
    Exit;
  end;

  LBody := ABody;
  LBody.Position := LOffset;

  SetLength(LBuffer, SND_BUF_SIZE);

  SendZCompress(
    // CHUNK
    function(const AData: PPointer; const ACount: PNativeInt): Boolean
    begin
      if (LCount <= 0) then
        Exit(False);

      ACount^ := LBody.Read(LBuffer, Min(LCount, SND_BUF_SIZE));
      AData^ := @LBuffer[0];

      Result := (ACount^ > 0);

      if Result then
        Dec(LCount, ACount^);
    end,
    ACompressType,
    // CALLBACK
    procedure(const AConnection: ICrossConnection; const ASuccess: Boolean)
    begin
      LBuffer := nil;

      if Assigned(ACallback) then
        ACallback(AConnection, ASuccess);
    end);
end;

procedure TCrossHttpResponse.SendZCompress(const ABody: TStream; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback);
begin
  SendZCompress(ABody, 0, 0, ACompressType, ACallback);
end;

procedure TCrossHttpResponse.SendZCompress(const ABody: string; const ACompressType: TCompressType; const ACallback: TCrossConnectionCallback);
var
  LBody: TBytes;
begin
  LBody := TEncoding.UTF8.GetBytes(ABody);
  if (GetContentType = '') then
    SetContentType(TMediaType.TEXT_HTML_UTF8);

  SendZCompress(LBody, ACompressType, ACallback);
end;

end.
