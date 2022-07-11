unit Net.CrossSslSocket.Base;

interface

uses
  Net.CrossSocket.Base;

type
  ICrossSslSocket = interface(ICrossSocket)
  ['{A4765486-A0F1-4EFD-BC39-FA16AED21A6A}']
    procedure SetCertificate(const ACertBuf: Pointer; const ACertBufSize: Integer); overload;
    procedure SetCertificate(const ACertStr: string); overload;
    procedure SetCertificateFile(const ACertFile: string);
    procedure SetPrivateKey(const APKeyBuf: Pointer; const APKeyBufSize: Integer); overload;
    procedure SetPrivateKey(const APKeyStr: string); overload;
    procedure SetPrivateKeyFile(const APKeyFile: string);
  end;

implementation

end.
