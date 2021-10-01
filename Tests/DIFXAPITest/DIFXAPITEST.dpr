program DIFXAPITEST;

uses
  Forms,
  Windows,
  SysUtils,
  Unit1 in 'Units\Unit1.pas',
  difxapi in 'Units\difxapi.pas';

{$R *.res}

const
  AppName = 'DIFx API test';


procedure DoInstallDriver;
var
  Text: string;
begin
  try
    InstallDriver;
    MessageBox(0, 'Driver installed successfully', AppName, MB_ICONINFORMATION);
  except
    on E: Exception do
    begin
      Text := 'Driver installation failed: ' + E.Message;
      MessageBox(0, PChar(Text), AppName, MB_ICONERROR);
    end;
  end;
end;

procedure DoUninstallDriver;
var
  Text: string;
begin
  try
    UninstallDriver;
    MessageBox(0, 'Driver uninstalled successfully', AppName, MB_ICONINFORMATION);
  except
    on E: Exception do
    begin
      Text := 'Driver uninstallation failed: ' + E.Message;
      MessageBox(0, PChar(Text), AppName, MB_ICONERROR);
    end;
  end;
end;

begin
  Application.Initialize;
  DoInstallDriver;
  //DoUninstallDriver;

end.
