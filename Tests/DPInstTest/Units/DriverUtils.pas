unit DriverUtils;

interface

uses
  // VCL
  Windows, SysUtils,
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
  MsgFileNotFound               = 'File not found';
  MsgDriverInstallFailed        = 'Driver installation failed';
  MsgDriverUninstallFailed      = 'Driver uninstall failed';
  MsgDriverInstalled            = 'Driver installed successfully';
  MsgDriverUninstalled          = 'Driver uninstalled successfully';
  MsgRestartRequired            = 'Computer need to be restarted';
  MsgAdminRightsRequired        = 'You must have administrative privileges to install driver';

const
  // User cancel driver installation
  ERROR_NO_SUCH_DEVINST         = $E000020B;
  ERROR_NO_CATALOG_FOR_OEM_INF  = $E000022F;

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
  B := False;
  P := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');
  if P <> nil then
  begin
    IsWow64Process := TIsWow64Process(P);
    IsWow64Process(GetCurrentProcess, B);
  end;
  Result := B;
end;

procedure InstallDriver(const Params: TDriverParams);
var
  S: string;
  Path: string;
  Command: string;
  ExitCode: DWORD;
  WaitResult: DWORD;
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  Path := IncludeTrailingPathDelimiter(ExtractFilePath(Params.ExeFileName));
  if IsWindows64 then
  begin
    Path := Path + 'Driver\Driver64';
  end else
  begin
    Path := Path + 'Driver\Driver32';
  end;
  Command := Path + '\DPInst.exe /F /LM /D';

  if not CreateProcess(nil, PAnsiChar(command), nil, nil, False, 0, nil,
    PAnsiChar(Path), StartupInfo, ProcessInformation) then
      RaiseInstallError('CreateProcess');

  if ProcessInformation.hProcess = 0 then
    RaiseInstallError('CreateProcess');

  try
    WaitResult := WaitForSingleObject(ProcessInformation.hProcess, INFINITE);
    if WaitResult <> WAIT_OBJECT_0 then
      RaiseInstallError('WaitForSingleObject');

    if not GetExitCodeProcess(ProcessInformation.hProcess, ExitCode) then
      RaiseInstallError('GetExitCodeProcess');

    GetExitCodeThread( ProcessInformation.hThread, ExitCode);

    if not Params.IsSilent then
    begin
      S := MsgDriverInstalled + #13#10 + MsgRestartRequired;
      MessageBox(Params.MainWindow, PChar(S), PChar(MsgAttention),
        MB_OK or MB_ICONINFORMATION);
    end;
  finally
    CloseHandle(ProcessInformation.hProcess);
    CloseHandle(ProcessInformation.hThread);
  end;
end;

procedure UninstallDriver(const Params: TDriverParams);
var
  S: string;
  Path: string;
  Command: string;
  ExitCode: DWORD;
  WaitResult: DWORD;
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  Path := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  if IsWindows64 then
  begin
    Path := Path + 'Driver\Driver64';
  end else
  begin
    Path := Path + 'Driver\Driver32';
  end;
  Command := Path + '\DPInst.exe /Q /U Inst.inf';

  if not CreateProcess(nil, PAnsiChar(command), nil, nil, False, 0, nil,
    PAnsiChar(Path), StartupInfo, ProcessInformation) then
    RaiseUninstallError('CreateProcess');

  if ProcessInformation.hProcess = 0 then
    RaiseUninstallError('CreateProcess');
  try
    WaitResult := WaitForSingleObject(ProcessInformation.hProcess, INFINITE);
    if WaitResult <> WAIT_OBJECT_0 then
      RaiseUninstallError('WaitForSingleObject');

    if not GetExitCodeProcess(ProcessInformation.hProcess, ExitCode) then
      RaiseLastOSError;

    GetExitCodeThread( ProcessInformation.hThread, ExitCode);
    if not Params.IsSilent then
    begin
      S := MsgDriverUninstalled + #10#13 + MsgRestartRequired;
      MessageBox(Params.MainWindow, PChar(S), PChar(MsgAttention), MB_OK or MB_ICONINFORMATION);
    end;
  finally
    CloseHandle(ProcessInformation.hProcess);
    CloseHandle(ProcessInformation.hThread);
  end;
end;

end.
