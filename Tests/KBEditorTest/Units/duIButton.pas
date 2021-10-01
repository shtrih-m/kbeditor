unit duIButton;

interface

uses
  // VCL
  Windows, SysUtils, Graphics, Classes,
  // This
  TestFramework, KBLayout, FileUtils;

type
  { TIButonTest }

  TIButonTest = class(TTestCase)
  published
    procedure TestAssign;
  end;

implementation

{ TIButonTest }

procedure TIButonTest.TestAssign;
var
  IButton1: TIButton;
  IButton2: TIButton;
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  IButton1 := TIButton.Create(nil);
  IButton2 := TIButton.Create(nil);
  try
    IButton1.Prefix.Add.Text := 'Test899999999999997';

    IButton1.SendCode := False;
    Check(IButton1.Prefix.Count = 1);
    Stream.WriteComponentRes('IButton1', IButton1);
    Stream.SaveToFile(ChangeFileExt(FileUtils.GetModuleFileName, '.txt'));
    //
    IButton2.Assign(IButton1);
    Check(IButton2.SendCode = False);
    Check(IButton2.Prefix.Count = 1);
  finally
    Stream.Free;
    IButton1.Free;
    IButton2.Free;
  end;
end;

initialization
  RegisterTest('', TIButonTest.Suite);

end.
