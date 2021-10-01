program DPInstTest;

uses
  Forms,
  Windows,
  SysUtils,
  DriverUtils in 'Units\DriverUtils.pas',
  fmuMain in 'Forms\fmuMain.pas' {fmMain},
  LogFile in 'Units\LogFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.

