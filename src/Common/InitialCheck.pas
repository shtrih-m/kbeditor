unit InitialCheck;

interface

uses
  // VCL
  Windows, SysUtils, Forms,
  // This
  KeyboardDriver, DriverUtils, LogFile;

function CheckServiceMode: Boolean;

implementation

resourcestring
  MsgError      = 'Error';

function CheckServiceMode: Boolean;
var
  Code: Integer;
  MainWindow: HWND;
  Params: TDriverParams;
begin
  Result := False;
  try
    // Install driver
    if FindCmdLineSwitch('install',['-','\','/'], True) then
    begin
      // Installer main window handle passed throw parameter 2
      Result := True;
      Val(ParamStr(2), MainWindow, Code);
      Params.MainWindow := MainWindow;
      Params.IsSilent := True;
      Params.ExeFileName := Application.ExeName;
      InstallDriver(Params);
      Exit;
    end;
    // Uninstallation
    if FindCmdLineSwitch('uninstall',['-','\','/'], True) then
    begin
      // Installer main window handle passed throw parameter 2
      Result := True;
      Val(ParamStr(2), MainWindow, Code);
      Params.MainWindow := MainWindow;
      Params.IsSilent := True;
      Params.ExeFileName := Application.ExeName;
      UninstallDriver(Params);
      Exit;
    end;
  except
    on E: Exception do
    begin
      Logger.Error('CheckServiceMode: ' + E.Message);
    end;
  end;
end;

end.
