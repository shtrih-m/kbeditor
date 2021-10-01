unit PS2KeyboardTest;

interface

uses
  //VCL
  SysUtils, Classes,
  // This
  TestFramework, PS2Keyboard, KeyboardDevice, AppMessages;

type
  { TPS2KeyboardTest }

  TPS2KeyboardTest = class(TTestCase)
  published
    procedure CheckOpen;
    procedure CheckClose;
  end;

implementation

{ TPS2KeyboardTest }

// Check that device is opened exlusively
procedure TPS2KeyboardTest.CheckOpen;
var
  Keyboard1: TPS2Keyboard;
  Keyboard2: TPS2Keyboard;
begin
  Keyboard1 := TPS2Keyboard.Create;
  Keyboard2 := TPS2Keyboard.Create;
  try
    Keyboard1.Open;

    try
      Keyboard2.Open;
      Check(false, 'Device is opened successfully twice');
    except
      on E: EKeyboardException do
      begin
        CheckEquals(E.Message, MsgDeviceInUse, 'E.Message');
      end;
    end;
  finally
    Keyboard1.Free;
    Keyboard2.Free;
  end;
end;

// Check that PS/2 device released after close
procedure TPS2KeyboardTest.CheckClose;
var
  Keyboard1: TPS2Keyboard;
  Keyboard2: TPS2Keyboard;
begin
  Keyboard1 := TPS2Keyboard.Create;
  Keyboard2 := TPS2Keyboard.Create;
  try
    Keyboard1.Open;
    Keyboard1.Close;

    Keyboard2.Open;
  finally
    Keyboard1.Free;
    Keyboard2.Free;
  end;
end;

initialization
  RegisterTest('', TPS2KeyboardTest.Suite);

end.
