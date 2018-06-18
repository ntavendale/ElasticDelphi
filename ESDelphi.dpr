program ESDelphi;

uses
  EMemLeaks,
  EResLeaks,
  ESendAPIFogBugz,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  EDebugExports,
  EDebugJCL,
  EMapWin32,
  EAppVCL,
  ExceptionLog7,
  Vcl.Forms,
  Main in 'Main.pas' {fmMain},
  EndPointClient in 'EndPointClient.pas',
  SyslogMessage in 'SyslogMessage.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
