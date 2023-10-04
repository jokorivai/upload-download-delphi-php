program updown;

uses
  Vcl.Forms,
  u_main in 'u_main.pas' {Form1},
  superobject in 'superobject\superobject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
