unit HelpFile;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ShellAPI;

type
  { TProcess }

  TProcess = class(TComponent)
  private
    FHandle: THandle;
    FFileName: string;

    procedure Close;
    function IsActive: Boolean;
    procedure ShowProcessWindow;
    procedure Start(ParentWindow: HWND; const Verb, FileName: string);
  public
    destructor Destroy; override;
    procedure Execute(ParentWindow: HWND; const Verb, FileName: string);
  end;

implementation

{ TProcess }

destructor TProcess.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TProcess.Close;
begin
  CloseHandle(FHandle);
  FHandle := 0;
end;

function TProcess.IsActive: Boolean;
var
  ExitCode: DWORD;
begin
  Result := (FHandle <> 0);
  if Result then
  begin
    Result := GetExitCodeProcess(FHandle, ExitCode);
    if Result then
      Result := ExitCode = STILL_ACTIVE;
  end;
end;

procedure TProcess.ShowProcessWindow;
var
  Wnd: HWND;
  WndName: string;
begin
  WndName := ChangeFileExt(ExtractFileName(FFileName), '');
  Wnd := FindWindow(nil, PChar(WndName));
  if Wnd <> 0 then
  begin
    ShowWindow(Wnd, SW_RESTORE);
    SetForegroundWindow(Wnd);
  end;
end;

procedure TProcess.Start(ParentWindow: HWND; const Verb, FileName: string);
var
  ExecInfo: TShellExecuteInfo;
begin
  Close;
  FillChar(ExecInfo, SizeOf(ExecInfo), 0);
  ExecInfo.cbSize := SizeOf(ExecInfo);
  ExecInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
  ExecInfo.Wnd := ParentWindow;
  ExecInfo.lpVerb := PChar(Verb);
  ExecInfo.lpFile := PChar(FileName);
  ExecInfo.nShow := SW_SHOWNORMAL;
  Win32Check(ShellExecuteEx(@ExecInfo));
  FHandle := ExecInfo.hProcess;
  FFileName := FileName;
end;

procedure TProcess.Execute(ParentWindow: HWND; const Verb, FileName: string);
begin
  if IsActive then ShowProcessWindow
  else Start(ParentWindow, Verb, FileName);
end;

end.
