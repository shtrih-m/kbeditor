unit SmoothProgressTest;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Graphics,
  // This
  TestFramework, SmoothProgress;

type
  { TSmoothProgressTest }

  TSmoothProgressTest = class(TTestCase)
  private
  published
    procedure TestProgress;
  end;

implementation

{ TSmoothProgressTest }

procedure TSmoothProgressTest.TestProgress;
var
  Progress: TSmoothProgress;
begin
  Progress := TSmoothProgress.Create;
  try
    Progress.Start(10);
    // Step is 100 ms by default
    CheckEquals(100, Progress.MaxProgress, 'Progress.MaxProgress');
    Sleep(120);
    CheckEquals(1, Progress.Position, 'Progress.Position <> 1');
    Progress.Step;
    CheckEquals(10, Progress.Position, 'Progress.Position <> 10');
    CheckEquals(10, Progress.Position, 'Progress.Position <> 10');
    Sleep(120);
    CheckEquals(20, Progress.Position, 'Progress.Position <> 20');
    Sleep(60);
    CheckEquals(25, Progress.Position, 'Progress.Position <> 25');

    //Progress.Step
  finally
    Progress.Free;
  end;
end;

initialization
  RegisterTest('', TSmoothProgressTest.Suite);

end.
