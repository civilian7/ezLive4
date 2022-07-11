program Demo;

uses
  Vcl.Forms,
  UDemo in 'UDemo.pas' {FormDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormDemo, FormDemo);
  Application.Run;
end.
