unit duStringUtils;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // DUnit
  TestFramework,
  // This
  StringUtils;

type
  { TStringUtilsTest }

  TStringUtilsTest = class(TTestCase)
  published
    procedure CheckSplit;
  end;

implementation

{ TStringUtilsTest }

procedure TStringUtilsTest.CheckSplit;
var
  Lines: TStrings;
begin
  Lines := TStringList.Create;
  try
    Split('  123 12345 12   ', ' ', Lines);
    CheckEquals(3, Lines.Count, 'Lines.Count');
    CheckEquals('123', Lines[0], 'Lines[0]');
    CheckEquals('12345', Lines[1], 'Lines[1]');
    CheckEquals('12', Lines[2], 'Lines[2]');
  finally
    Lines.Free;
  end;
end;

initialization
  RegisterTest('', TStringUtilsTest.Suite);

end.
