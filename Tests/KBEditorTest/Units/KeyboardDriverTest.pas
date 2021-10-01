unit KeyboardDriverTest;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // DUnit
  TestFramework, PascalMock,
  // This
  KeyboardDriver, KeyboardTypes, MockKeyboardDevice, KeyboardFrame;

type
  { TKeyboardDriverTest }

  TKeyboardDriverTest = class(TTestCase)
  private
    Driver: TKeyboardDriver;
    Device: TMockKeyboardDevice;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckGetIndicators;
    procedure CheckSetIndicators;
    procedure CheckReadMemory;
  end;

implementation

{ TKeyboardDriverTest }

procedure TKeyboardDriverTest.Setup;
begin
  Device := TMockKeyboardDevice.Create;
  Driver := TKeyboardDriver.Create;
  Driver.Device := Device;
end;

procedure TKeyboardDriverTest.TearDown;
begin
  Driver.Free;
  Device.Free;
end;

procedure TKeyboardDriverTest.CheckGetIndicators;
begin
  Device.Expects('GetIndicators').Returns(123);
  CheckEquals(123, Driver.GetIndicators, 'Driver.GetIndicators');
  Device.Verify('Device calls');
end;

procedure TKeyboardDriverTest.CheckSetIndicators;
begin
  Device.Expects('SetIndicators').WithParams([123]);
  Driver.SetIndicators(123);
  Device.Verify('Device calls');
end;

procedure TKeyboardDriverTest.CheckReadMemory;
var
  Data: string;
  TxData: string;
  RxData: string;
begin
  Data := '0123456789';
  TxData := TKeyboardFrame.Encode(#$9D#$00#$00#$0A);
  RxData := TKeyboardFrame.Encode(#$9D#$00 + Data);
  Device.Expects('SendData').WithParams([TxData, 3]).Returns(RxData);
  CheckEquals(Data, Driver.ReadMemory(0, 10), 'Driver.ReadMemory');
  Device.Verify('Device calls');
end;


initialization
  RegisterTest('', TKeyboardDriverTest.Suite);

end.
