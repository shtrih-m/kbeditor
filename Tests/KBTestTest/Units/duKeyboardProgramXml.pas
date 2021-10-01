unit duKeyboardProgramXml;

interface

uses
  // VCL
  Windows, SysUtils, Graphics, classes,
  // This
  TestFramework, KeyboardProgram, KeyboardProgramXml;

type
  { TKeyboardProgramXmlTest }

  TKeyboardProgramXmlTest = class(TTestCase)
  published
    procedure TestLoad;
  end;

implementation

function GetModuleFileName: string;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

(*

<Programs>
	<Program>
		<Model>16</Model>
		<Filename>KB-64xx_v3.7.prg</Filename>
	</Program>
	<Program>
		<Model>32</Model>
		<Filename>KB-64RiB_v2.15.prg</Filename>
	</Program>
	<Program>
		<Model>17</Model>
		<Filename>KB-128xx_v3.6.prg</Filename>
	</Program>
</Programs>

*)


{ TKeyboardProgramXmlTest }

procedure TKeyboardProgramXmlTest.TestLoad;
var
  Path: string;
  FileName: string;
  FileName2: string;
  Items: TKeyboardPrograms;
  Xml: TKeyboardProgramXml;
begin
  Xml := TKeyboardProgramXml.Create;
  Items := TKeyboardPrograms.Create;
  try
    Path := IncludeTrailingBackSlash(ExtractFilePath(GetModuleFileName));
    FileName := Path + '\Data\Programs.xml';
    FileName2 := Path + '\Data\Programs2.xml';

    DeleteFile(FileName2);
    Xml.DoLoad(Items, FileName);
    CheckEquals(3, Items.Count, 'Items.Count');
    CheckEquals(16, Items[0].ModelID, 'Items[0].ModelID');
    CheckEquals('KB-64xx_v3.7.prg', Items[0].FileName, 'Items[0].FileName');
    CheckEquals(32, Items[1].ModelID, 'Items[1].ModelID');
    CheckEquals('KB-64RiB_v2.15.prg', Items[1].FileName, 'Items[1].FileName');
    CheckEquals(17, Items[2].ModelID, 'Items[2].ModelID');
    CheckEquals('KB-128xx_v3.6.prg', Items[2].FileName, 'Items[2].FileName');


    Xml.DoSave(Items, FileName2);
    Items.Clear;
    CheckEquals(0, Items.Count, 'Items.Count');
    Xml.DoLoad(Items, FileName2);

    CheckEquals(3, Items.Count, 'Items.Count');
    CheckEquals(16, Items[0].ModelID, 'Items[0].ModelID');
    CheckEquals('KB-64xx_v3.7.prg', Items[0].FileName, 'Items[0].FileName');
    CheckEquals(32, Items[1].ModelID, 'Items[1].ModelID');
    CheckEquals('KB-64RiB_v2.15.prg', Items[1].FileName, 'Items[1].FileName');
    CheckEquals(17, Items[2].ModelID, 'Items[2].ModelID');
    CheckEquals('KB-128xx_v3.6.prg', Items[2].FileName, 'Items[2].FileName');
    DeleteFile(FileName2);
  finally
    Xml.Free;
    Items.Free;
  end;
end;

initialization
  RegisterTest('', TKeyboardProgramXmlTest.Suite);

end.
