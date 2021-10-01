unit untVInfo;

interface

uses
  Windows, SysUtils;

type
  { TVersionInfo }

  TVersionInfo = record
    MajorVersion: WORD;
    MinorVersion: WORD;
    ProductRelease: WORD;
    ProductBuild: WORD;
  end;

function GetFileVersionInfoStr: string;
function GetFileVersionInfo: TVersionInfo;

//0 - v1=v2, 1 - v1<v2, 2 - v1>v2
function CompareVersions(v1, v2: TVersionInfo): Integer;

implementation

function GetFileVersionInfo: TVersionInfo;
var
  hVerInfo: THandle;
  hGlobal: THandle;
  AddrRes: pointer;
  Buf: array[0..7]of byte;
begin
  Result.MajorVersion := 0;
  Result.MinorVersion := 0;
  Result.ProductRelease := 0;
  Result.ProductBuild := 0;

  hVerInfo:= FindResource(hInstance, '#1', RT_VERSION);
  if hVerInfo <> 0 then
  begin
    hGlobal := LoadResource(hInstance, hVerInfo);
    if hGlobal <> 0 then
    begin
      AddrRes:= LockResource(hGlobal);
      try
        CopyMemory(@Buf, Pointer(Integer(AddrRes)+48), 8);
        Result.MinorVersion := Buf[0] + Buf[1]*$100;
        Result.MajorVersion := Buf[2] + Buf[3]*$100;
        Result.ProductBuild := Buf[4] + Buf[5]*$100;
        Result.ProductRelease := Buf[6] + Buf[7]*$100;
      finally
        FreeResource(hGlobal);
      end;
    end;
  end;
end;

function GetFileVersionInfoStr: string;
var
  vi: TVersionInfo;
begin
  vi := GetFileVersionInfo;
  Result := Format('%d.%d.%d.%d', [vi.MajorVersion, vi.MinorVersion,
    vi.ProductRelease, vi.ProductBuild]);
end;

//0 - v1=v2, 1 - v1<v2, 2 - v1>v2
function CompareVersions(v1, v2: TVersionInfo): Integer;
begin
  if v1.MajorVersion < v2.MajorVersion then
  begin
    Result := 1;
    Exit;
  end;
  if v1.MinorVersion < v2.MinorVersion then
  begin
    Result := 1;
    Exit;
  end;
  if v1.ProductRelease < v2.ProductRelease then
  begin
    Result := 1;
    Exit;
  end;
  if v1.ProductBuild < v2.ProductBuild then
  begin
    Result := 1;
    Exit;
  end;
  if (v1.MajorVersion = v2.MajorVersion) and (v1.MinorVersion = v2.MinorVersion)
    and (v1.ProductRelease = v2.ProductRelease)
    and (v1.ProductBuild = v2.ProductBuild) then Result := 0
  else Result := 2;
end;

end.
