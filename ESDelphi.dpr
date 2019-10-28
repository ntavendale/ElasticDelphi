program ESDelphi;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmMain},
  EndPointClient in 'EndPointClient.pas',
  LogMessage in 'LogMessage.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.






