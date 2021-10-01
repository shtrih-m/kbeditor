unit DriverUtils;

interface

uses
  // VCL
  Windows, SysUtils, ShellAPI, Forms,
  // This
  LogFile;

type
  { TDriverParams }

  TDriverParams = record
    MainWindow: HWND;
    IsSilent: Boolean;
    ExeFileName: string;
  end;

procedure InstallDriver(const Params: TDriverParams);
procedure UninstallDriver(const Params: TDriverParams);

implementation

resourcestring
  MsgAttention                  = 'Attention';
  MsgErrorCode                  = 'Error code';
  MsgFileNotFound               = 'File not found';
  MsgDriverInstallFailed        = 'Driver installation failed';
  MsgDriverUninstallFailed      = 'Driver uninstall failed';
  MsgDriverInstalled            = 'Driver installed successfully';
  MsgDriverUninstalled          = 'Driver uninstalled successfully';
  MsgRestartRequired            = 'Computer need to be restarted';
  MsgAdminRightsRequired        = 'You must have administrative privileges to install driver';
  MsgNoDriverPackagesInstalled  = 'Driver package was not installed';
  MsgSetTestCodeSigningFailed   = 'Failed to enable test code signing';
  MsgCertificateInstallFailed   = 'Failed to install certificate';

const
  // User cancel driver installation
  ERROR_NO_SUCH_DEVINST         = $E000020B;
  ERROR_NO_CATALOG_FOR_OEM_INF  = $E000022F;

///////////////////////////////////////////////////////////////////////////////
//
// The return code is a DWORD (0xWWXXYYZZ),
// where the meaning of the four single-byte fields
// 0xWW, 0xXX, 0xYY, and 0xZZ are defined in the following table.
// Field	Meaning
// 0xWW
//        If a driver package could not be installed, the 0x80 bit is set.
//        If a computer restart is necessary, the 0x40 bit is set.
//        Otherwise, no bits are set.
// 0xXX
//        The number of driver packages that could not be installed.
// 0xYY
//        The number of driver packages that were copied to the DIFx driver
//        store but were not installed on a device.
// 0xZZ
//        The number of driver packages that were installed on a device.
//
// The following table lists some example return codes and their meanings.
// Example return code	Meaning
// 0x00000001 - One driver package was present and was successfully installed.
// 0x00000002 - Two driver packages were present and were successfully installed.
// 0x40000002 - Two driver packages were present and were successfully
//              installed on devices. A computer restart is required to
//              complete the installation.
// 0x00000100 - One driver package was present and was copied to the DIFx
//              driver store, but it was not installed on a device.
// 0x80010000 - One driver package was present, but it could not be installed.
// 0xC0010001 - One driver package could not be installed and one driver
//              package was installed. A computer restart is required to
//              complete the installation.
//
///////////////////////////////////////////////////////////////////////////////

procedure RaiseInstallError(const FunctionName: string);
var
  S: string;
  LastError: DWORD;
begin
  LastError := GetLastError;
  if LastError <> ERROR_SUCCESS then
  begin
    if (LastError <> ERROR_CANCELLED) and
       (LastError <> ERROR_NO_SUCH_DEVINST) and
       (LastError <> ERROR_NO_CATALOG_FOR_OEM_INF) then
    begin
      S := S + '%s:'#13#10'0x%.8x, %s';
      S := Format(S, [MsgDriverInstallFailed, LastError, SysErrorMessage(LastError)]);
      case LastError of
        ERROR_ACCESS_DENIED:
          S := S + #13#10 + MsgAdminRightsRequired;
        ERROR_FILE_NOT_FOUND:
          S := S + #13#10 + MsgFileNotFound;
      end;
      Logger.Error(S);
      raise Exception.Create(S)
    end;
  end;
  Abort;
end;

procedure RaiseUninstallError(const FunctionName: string);
var
  S: string;
  LastError: DWORD;
begin
  LastError := GetLastError;
  if LastError <> ERROR_SUCCESS then
  begin
    if (LastError <> ERROR_CANCELLED) and
       (LastError <> ERROR_NO_SUCH_DEVINST) and
       (LastError <> ERROR_NO_CATALOG_FOR_OEM_INF) then
    begin
      S := S + '%s:'#13#10'0x%.8x, %s';
      S := Format(S, [MsgDriverUninstallFailed, LastError, SysErrorMessage(LastError)]);
      case LastError of
        ERROR_ACCESS_DENIED:
          S := S + #13#10 + MsgAdminRightsRequired;
        ERROR_FILE_NOT_FOUND:
          S := S + #13#10 + MsgFileNotFound;
      end;
      raise Exception.Create(S)
    end;
  end;
  Abort;
end;

//IsWow64Process is not available on all supported versions of Windows.
//Use GetModuleHandle to get a handle to the DLL that contains the function
//and GetProcAddress to get a pointer to the function if available.

function IsWindows64: Boolean;
type
  TIsWow64Process = function(Process: THandle; var Value: BOOL): BOOL; stdcall;
var
  B: BOOL;
  P: Pointer;
  IsWow64Process: TIsWow64Process;
begin
  Logger.Debug('IsWindows64');
  B := False;
  P := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');
  if P <> nil then
  begin
    IsWow64Process := TIsWow64Process(P);
    IsWow64Process(GetCurrentProcess, B);
  end;
  Result := B;
  Logger.Debug('IsWindows64', [], Result);
end;

function GetRestartNeeded(Code: DWORD): Boolean;
begin
  Result := (Code and $40000000) <> 0;
end;

procedure CheckDriverInstallResult(Code: DWORD; MainWindow: THandle);
var
  Text: string;
  InstallFailed: Boolean;
  PackagesCopied: Integer;
  PackagesInstalled: Integer;
  PackagesNotInstalled: Integer;
begin
  InstallFailed := (Code and $80000000) <> 0;
  PackagesNotInstalled := (Code shr 16) and $FF;
  PackagesCopied := (Code shr 8) and $FF;
  PackagesInstalled := Code and $FF;

  if InstallFailed then
  begin
    if PackagesInstalled = 0 then
    begin
      Text := MsgNoDriverPackagesInstalled;
    end else
    begin
      Text := Format('%s, 0x%.8x', [MsgDriverInstallFailed, Code,
        PackagesCopied, PackagesInstalled, PackagesNotInstalled]);
    end;
    MessageBox(MainWindow, PChar(Text), PChar(MsgAttention),
      MB_OK or MB_ICONINFORMATION);

    Logger.Error(Text);
    Abort;
  end;
end;

function ExecuteCommand(const path, fileName, parameters: string;
  RunAsUser: Boolean = False): DWORD;
var
  WaitResult: DWORD;
  ExecInfo: ShellExecuteInfo;
begin
  Result := 0;
  FillChar(ExecInfo, Sizeof(ExecInfo), 0);
  ExecInfo.cbSize := Sizeof(ExecInfo);
  ExecInfo.Wnd := Application.Handle;
  ExecInfo.lpVerb := 'open';
  if RunAsUser then
    ExecInfo.lpVerb := 'runas';
  ExecInfo.lpFile := PChar(fileName);
  ExecInfo.lpParameters := PChar(Parameters);
  ExecInfo.lpDirectory := PChar(path);
  ExecInfo.nShow := SW_NORMAL;
  ExecInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
  if not ShellExecuteEx(@ExecInfo) then
    RaiseLastOSError;

  if ExecInfo.hProcess = 0 then
    RaiseLastOSError;

  try
    WaitResult := WaitForSingleObject(ExecInfo.hProcess, INFINITE);
    if WaitResult <> WAIT_OBJECT_0 then
      RaiseLastOSError;

    if not GetExitCodeProcess(ExecInfo.hProcess, Result) then
      RaiseLastOSError;
  finally
    CloseHandle(ExecInfo.hProcess);
  end;
end;

function GetDriverPath(const ExeFileName: string): string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ExeFileName));
  if IsWindows64 then
  begin
    Result := Result + 'Driver\Driver64';
  end else
  begin
    Result := Result + 'Driver\Driver32';
  end;
end;

function IsWindows7OrHigher: Boolean;
begin
  Result := (Win32MajorVersion >= 6)and(Win32MinorVersion >= 1);
end;

function GetSystemPath: string;
var
  Buffer: array [0..MAX_PATH] of char;
begin
  SetString(Result, Buffer, GetSystemDirectory(Buffer, MAX_PATH));
  Result := ExcludeTrailingPathDelimiter(Result);
end;

// Enable test code signing on Windows 7
procedure EnableTestCodeSigning;
var
  S: string;
  ExitCode: DWORD;
begin
  try
    if IsWindows64 then
    begin
      ExitCode := ExecuteCommand(GetSystemPath,
        'bcdedit.exe',  '/set TESTSIGNING ON', True);
      if ExitCode <> 0 then
      begin
        S := Format('%s. %s: 0x%.8x', [
          MsgSetTestCodeSigningFailed, MsgErrorCode, ExitCode]);
        Logger.Error(S);
      end;
    end;
  except
    on E: Exception do
    begin
      S := Format('%s. %s', [MsgSetTestCodeSigningFailed, E.Message]);
      Logger.Error(S);
    end;
  end;
end;

procedure InstallCertificate(const Path: string);
var
  S: string;
  ExitCode: DWORD;
begin
  try
    if IsWindows64 then
    begin
      ExitCode := ExecuteCommand(Path, 'certmgr.exe',
        '/add "Shtrih.cer" /s /r localMachine root');
      if ExitCode <> 0 then
      begin
        S := Format('%s. %s: 0x%.8x', [
          MsgCertificateInstallFailed, MsgErrorCode, ExitCode]);
        Logger.Error(S);
      end;
    end;
  except
    on E: Exception do
    begin
      S := Format('%s. %s', [MsgCertificateInstallFailed, E.Message]);
      Logger.Error(S);
    end;
  end;
end;

procedure InstallDriver(const Params: TDriverParams);
var
  S: string;
  Path: string;
  ExitCode: DWORD;
begin
  Logger.Debug('InstallDriver.Begin', [Params.IsSilent, Params.ExeFileName]);

  Path := GetDriverPath(Params.ExeFileName);
  //EnableTestCodeSigning;    8
  //InstallCertificate(Path); !!!

  ExitCode := ExecuteCommand(Path, Path + '\dpinst.exe', ' /F /LM /D');
  CheckDriverInstallResult(ExitCode, Params.MainWindow);
  if not Params.IsSilent then
  begin
    S := MsgDriverInstalled + #13#10 + MsgRestartRequired;
    MessageBox(Params.MainWindow, PChar(S), PChar(MsgAttention),
      MB_OK or MB_ICONINFORMATION);
  end;
  Logger.Debug('InstallDriver.End', [Params.IsSilent, Params.ExeFileName]);
end;

procedure UninstallDriver(const Params: TDriverParams);
var
  S: string;
  Path: string;
begin
  Logger.Debug('UninstallDriver.Begin', [Params.IsSilent, Params.ExeFileName]);
  Path := GetDriverPath(Params.ExeFileName);
  ExecuteCommand(Path, 'DPInst.exe', '/Q /U Inst.inf');
  if not Params.IsSilent then
  begin
    S := MsgDriverUninstalled + #10#13 + MsgRestartRequired;
    MessageBox(Params.MainWindow, PChar(S), PChar(MsgAttention),
      MB_OK or MB_ICONINFORMATION);
  end;
  Logger.Debug('UninstallDriver.End', [Params.IsSilent, Params.ExeFileName]);
end;

(*
function ExecuteCommand(const Path, FileName, Parameters: string): DWORD;
begin
  Result := 0;
  if ShellExecute(GetActiveWindow, nil, PChar(FileName), PChar(Parameters),
    PChar(path), 0) < 32 then
    RaiseLastOSError;
end;

function ExecuteCommand(const path, fileName, parameters: string): DWORD;
var
  ExecInfo: ShellExecuteInfo;
begin
  Result := 0;
  FillChar(ExecInfo, Sizeof(ExecInfo), 0);
  ExecInfo.cbSize := Sizeof(ExecInfo);
  ExecInfo.fMask := 0;
  ExecInfo.Wnd := GetActiveWindow;
  ExecInfo.lpVerb := 'run';
  ExecInfo.lpFile := PChar(fileName);
  ExecInfo.lpParameters := PChar(Parameters);
  ExecInfo.lpDirectory := PChar(path);
  ExecInfo.nShow := SW_SHOWNORMAL;
  ExecInfo.hInstApp := 0;
  if not ShellExecuteEx(@ExecInfo) then
    RaiseLastOSError;
end;

function ExecuteCommand2(const path, fileName, parameters: string): DWORD;
var
  ExecInfo: ShellExecuteInfo;
begin
  Result := 0;
  FillChar(ExecInfo, Sizeof(ExecInfo), 0);
  ExecInfo.cbSize := Sizeof(ExecInfo);
  ExecInfo.fMask := 0;
  ExecInfo.Wnd := GetActiveWindow;
  ExecInfo.lpVerb := 'runas';
  ExecInfo.lpFile := PChar(fileName);
  ExecInfo.lpParameters := PChar(Parameters);
  ExecInfo.lpDirectory := PChar(path);
  ExecInfo.nShow := SW_SHOWNORMAL;
  ExecInfo.hInstApp := 0;
  if not ShellExecuteEx(@ExecInfo) then
    RaiseLastOSError;
end;

(*
function ExecuteCommand(const path, fileName, parameters: string): DWORD;
var
  WaitResult: DWORD;
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
begin
  Logger.Debug('ExecuteCommand', [command, path]);

  Result := 0;
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  if not CreateProcess(nil, PAnsiChar(command), nil, nil, False, 0, nil,
    PAnsiChar(Path), StartupInfo, ProcessInformation) then
      RaiseLastOSError;

  if ProcessInformation.hProcess = 0 then
    RaiseLastOSError;

  try
    WaitResult := WaitForSingleObject(ProcessInformation.hProcess, INFINITE);
    if WaitResult <> WAIT_OBJECT_0 then
      RaiseLastOSError;

    if not GetExitCodeProcess(ProcessInformation.hProcess, Result) then
      RaiseLastOSError;
  finally
    CloseHandle(ProcessInformation.hProcess);
    CloseHandle(ProcessInformation.hThread);
  end;
  Logger.Debug('ExecuteCommand', [command, path], Result);
end;

  except
    on E: Exception do
      Logger.Error('Execute failed, ' + E.Message);
  end;

*)

end.
