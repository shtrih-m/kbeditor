program KBTestTest;

uses
  TestFramework,
  TextTestRunner,
  GUITestRunner,
  duKeyboardProgramXml in 'Units\duKeyboardProgramXml.pas',
  KeyboardProgram in '..\..\src\KBTest\Units\KeyboardProgram.pas',
  KeyboardProgramXml in '..\..\src\KBTest\Units\KeyboardProgramXml.pas',
  msxml in '..\..\src\Common\MSXML.pas',
  Utils in '..\..\src\Common\Utils.pas',
  LogFile in '..\..\src\Common\LogFile.pas',
  DebugUtils in '..\..\src\Common\DebugUtils.pas',
  xmlParser in '..\..\src\Common\XmlParser.pas',
  GridType in '..\..\src\Common\GridType.pas',
  duDfmFileTest in 'Units\duDfmFileTest.pas',
  FileUtils in '..\..\src\Common\FileUtils.pas',
  KeyboardFrame in '..\..\src\Common\KeyboardFrame.pas',
  DeviceError in '..\..\src\Common\DeviceError.pas';

{$R *.RES}

begin
  GUITestRunner.RunTest(RegisteredTests);
end.
