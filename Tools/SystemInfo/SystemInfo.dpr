program SystemInfo;

uses
  Windows,
  SysUtils,
  FileUtils in '..\..\src\Common\FileUtils.pas';

{$R *.res}


//IsWow64Process is not available on all supported versions of Windows.
//Use GetModuleHandle to get a handle to the DLL that contains the function
//and GetProcAddress to get a pointer to the function if available.

function IsWindows64: Boolean;
type
  TIsWow64Process = function(Process: THandle; var Value: BOOL): BOOL; stdcall;
var
  B: BOOL;
  P: Pointer;
  Line: string;
  IsWow64Process: TIsWow64Process;
begin
  B := False;
  P := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');
  if P <> nil then
  begin
    IsWow64Process := TIsWow64Process(P);
    if not IsWow64Process(GetCurrentProcess, B) then
    begin
      Line := Format('IsWow64Process function failed. Error code: 0x%.8x', [
        GetLastError]);
      Writeln(Line);
    end;
  end;
  Result := B;
end;

procedure PrintSystemInfo;
var
  si: TSystemInfo;
begin
  GetSystemInfo(si);
  Writeln('PageSize                  : 0x' + IntToHex(si.dwPageSize, 8));
  Writeln('MinimumApplicationAddress : 0x' + IntToHex(Integer(si.lpMinimumApplicationAddress), 8));
  Writeln('MaximumApplicationAddress : 0x' + IntToHex(Integer(si.lpMaximumApplicationAddress), 8));
  Writeln('ActiveProcessorMask       : 0x' + IntToHex(si.dwActiveProcessorMask, 8));
  Writeln('NumberOfProcessors        : 0x' + IntToHex(si.dwNumberOfProcessors, 8));
  Writeln('ProcessorType             : 0x' + IntToHex(si.dwProcessorType, 8));
  Writeln('AllocationGranularity     : 0x' + IntToHex(si.dwAllocationGranularity, 8));
  Writeln('ProcessorLevel            : 0x' + IntToHex(si.wProcessorLevel, 8));
  Writeln('ProcessorRevision         : 0x' + IntToHex(si.wProcessorRevision, 8));
end;

procedure PrintOsVersion;
begin
  if IsWindows64 then
    Writeln('The process is running under WOW64.')
  else
    Writeln('The process is not running under WOW64.');
end;

procedure PrintModulePath;
begin
  Writeln('GetModulePath: ' + GetModulePath);
  Writeln('GetModuleFileName: ' + GetModuleFileName);
  Writeln('GetLongFileName(GetModuleFileName): ' + GetLongFileName(GetModuleFileName));
end;

begin
  PrintSystemInfo;
  PrintOsVersion;
  PrintModulePath;
  ReadLn;
end.
