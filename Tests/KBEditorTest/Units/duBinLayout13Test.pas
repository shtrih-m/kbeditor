unit duBinLayout13Test;

interface

uses
  // VCL
  Windows, SysUtils, Graphics, classes,
  // This
  TestFramework, KBLayout, KeyboardManager, LayoutFormat, FileUtils, BinLayout13;

type
  { TBinLayout13Test }

  TBinLayout13Test = class(TTestCase)
  published
    procedure Bin13Test;
  end;

implementation

{ TBinLayout13Test }

procedure TBinLayout13Test.Bin13Test;
var
  Layout: TKBLayout;
  BinLayout13: TBinLayout13;
  LayoutFormats: TKBLayoutFormats;
  FileName, FileNameToSave: string;
begin
  FileName := GetModulePath + 'testdata\1.3_test.bin';
  FileNameToSave := GetModulePath + 'testdata\1.3_test_2.bin';
  LayoutFormats := TKBLayoutFormats.Create;
  BinLayout13 := TBinLayout13.Create(LayoutFormats);
  Layout := TKBLayout.Create(nil);
  BinLayout13.LoadFromFile(Layout, FileName);

  try
    BinLayout13.SaveToFile(Layout, FileNameToSave);
    Check(ReadFileData(FileName) = ReadFileData(FileNameToSave));
  finally
    Layout.Free;
    LayoutFormats.Free;
    DeleteFile(FileNameToSave);
  end;
end;

//initialization
//  RegisterTest('', TBinLayout13Test.Suite);

end.
