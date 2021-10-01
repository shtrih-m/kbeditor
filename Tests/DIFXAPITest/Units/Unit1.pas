unit Unit1;

interface

uses
  // VCL
  Windows, SysUtils, SysConst,
  // This
  difxapi;

procedure InstallDriver;
procedure UninstallDriver;

implementation

const
  // Invalid Driver Store entry
  E_INVALID_DRIVER_ENTRY = $E0000302;

procedure Check(LastError: Integer);
begin
  if LastError <> 0 then
    raise EOSError.CreateResFmt(@SOSError, [LastError,
      SysErrorMessage(LastError)]);
end;

procedure InstallDriver;
var
  InfPath: string;
  InstInfo: INSTALLERINFO;
  NeedReboot: Boolean;
begin
  InfPath := IncludeTrailingPathDelimiter(GetCurrentDir) + 'Inst.inf';
  InstInfo.pApplicationId := '{CF7BEC44-E1BE-4D8E-85B0-6AEB13CA73F8}';
  InstInfo.pDisplayName := 'Test application 1';
  InstInfo.pProductName := 'Test product 1';
  InstInfo.pMfgName := 'SHTRIH-M company, 2012';

  Check(DriverPackageInstall(PChar(InfPath),
    DRIVER_PACKAGE_FORCE +
    DRIVER_PACKAGE_LEGACY_MODE +
    DRIVER_PACKAGE_ONLY_IF_DEVICE_PRESENT,
    @InstInfo, NeedReboot));
end;

procedure UninstallDriver;
var
  InfPath: string;
  InstInfo: INSTALLERINFO;
  NeedReboot: Boolean;
  ResultCode: DWORD;
begin
  InfPath := IncludeTrailingPathDelimiter(GetCurrentDir) + 'Inst.inf';
  InstInfo.pApplicationId := '{CF7BEC44-E1BE-4D8E-85B0-6AEB13CA73F8}';
  InstInfo.pDisplayName := 'Test application 1';
  InstInfo.pProductName := 'Test product 1';
  InstInfo.pMfgName := 'SHTRIH-M company, 2012';

  ResultCode := DriverPackageUninstall(PChar(InfPath), 0, @InstInfo, NeedReboot);
  if ResultCode = E_INVALID_DRIVER_ENTRY then Exit;
  Check(ResultCode);
end;

end.
