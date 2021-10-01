unit TextDfmTest;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  TestFramework, FileUtils, FormFileTest;

type
  { TDfmFileTest }

  TDfmFileTest = class(TFormFileTest)
  published
    procedure CheckDfmFiles;
  end;

implementation

{ TDfmFileTest }

procedure TDfmFileTest.CheckDfmFiles;
begin
  CheckDfmFilePath(GetModulePath + '..\..\..\Src\KBEditor\FMU');
end;

initialization
  RegisterTest('', TDfmFileTest.Suite);

end.
