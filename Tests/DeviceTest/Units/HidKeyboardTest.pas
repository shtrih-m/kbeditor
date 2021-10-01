unit HidKeyboardTest;

interface

uses
  //VCL
  SysUtils, Classes,
  // This
  TestFramework, HidKeyboard, KeyboardDevice, AppMessages, KeyboardManager,
  DeviceInfoSet, KeyboardController, KeyboardDriver, KeyboardTypes;

type
  { THidKeyboardTest }

  THidKeyboardTest = class(TTestCase)
  private
    Driver: TKeyboardDriver;
    Keyboard: IKeyboardDevice;

    function GetDeviceName: string;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  public
    procedure CheckIndicators; { !!! }
  published
    procedure CheckOpen;
    procedure CheckClose;
    procedure CheckGetDeviceVersion;
    procedure CheckGetDeviceStatus;
    procedure CheckGetProgramStatus;
    procedure CheckShorting;
    procedure CheckGetDeviceInfo;
  end;

implementation

{ THidKeyboardTest }

procedure THidKeyboardTest.Setup;
begin
  Keyboard := THidKeyboard.Create;
  Keyboard.DeviceName := GetDeviceName;

  Driver := TKeyboardDriver.Create;
  Driver.Device := Keyboard;
end;

procedure THidKeyboardTest.TearDown;
begin
  Driver.Free;
  Keyboard := nil;
end;

function THidKeyboardTest.GetDeviceName: string;
var
  Devices: TKeyboardDevices;
begin
  Devices := TKeyboardDevices.Create;
  try
    EnumHIDKeyboards(Devices);
    if Devices.Count = 0 then
      raise Exception.Create('No HID keyboards connected!');

    Result := Devices[0].DeviceName;
  finally
    Devices.Free;
  end;
end;


// Check that PS/2 device is opened exlusively
procedure THidKeyboardTest.CheckOpen;
var
  DevicePath: string;
  Keyboard1: THidKeyboard;
  Keyboard2: THidKeyboard;
begin
  DevicePath := GetDeviceName;
  Keyboard1 := THidKeyboard.Create;
  Keyboard2 := THidKeyboard.Create;
  try
    Keyboard1.DeviceName := DevicePath;
    Keyboard2.DeviceName := DevicePath;

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
procedure THidKeyboardTest.CheckClose;
var
  DevicePath: string;
  Keyboard1: THidKeyboard;
  Keyboard2: THidKeyboard;
begin
  DevicePath := GetDeviceName;
  Keyboard1 := THidKeyboard.Create;
  Keyboard2 := THidKeyboard.Create;
  try
    Keyboard1.DeviceName := DevicePath;
    Keyboard2.DeviceName := DevicePath;

    Keyboard1.Open;
    Keyboard1.Close;

    Keyboard2.Open;
  finally
    Keyboard1.Free;
    Keyboard2.Free;
  end;
end;

procedure THidKeyboardTest.CheckIndicators;
begin
  Keyboard.Open;

  Keyboard.SetIndicators(0);
  CheckEquals(0, Keyboard.GetIndicators, 'Keyboard.GetIndicators <> 0');

  Keyboard.SetIndicators(KEYBOARD_SCROLL_LOCK_ON);
  CheckEquals(KEYBOARD_SCROLL_LOCK_ON, Keyboard.GetIndicators,
    'Keyboard.GetIndicators <> KEYBOARD_SCROLL_LOCK_ON');

  Keyboard.SetIndicators(KEYBOARD_NUM_LOCK_ON);
  CheckEquals(KEYBOARD_NUM_LOCK_ON, Keyboard.GetIndicators,
    'Keyboard.GetIndicators <> KEYBOARD_NUM_LOCK_ON');

(*
  KEYBOARD_SCROLL_LOCK_ON       = 1;
  KEYBOARD_NUM_LOCK_ON          = 2;
  KEYBOARD_CAPS_LOCK_ON         = 4;
*)
end;

procedure THidKeyboardTest.CheckGetDeviceVersion;
var
  DeviceVersion: Word;
begin
  DeviceVersion := $20F;
  CheckEquals(DeviceVersion, Driver.GetDeviceVersion,
    'Driver.GetDeviceVersion <> 0x20Fh');
end;

procedure THidKeyboardTest.CheckGetDeviceStatus;
begin
  Driver.GetDeviceStatus;
end;

procedure THidKeyboardTest.CheckGetProgramStatus;
begin
  Driver.GetProgramStatus;
end;

procedure THidKeyboardTest.CheckShorting;
begin
  CheckEquals(False, Driver.CheckShorting, 'Driver.CheckShorting');
end;

procedure THidKeyboardTest.CheckGetDeviceInfo;
var
  DeviceInfo: TDeviceInfo;
begin
  DeviceInfo := Driver.GetDeviceInfo;
  CheckEquals($208, DeviceInfo.Version, 'DeviceInfo.Version');

(*
    VersionText: string;        // Device program version
    MajorVersion: Byte;         // Major version
    MinorVersion: Byte;         // Minor version
    MemSize: Word;              // Device memory size
    Model: Byte;                // Model
    LayerCount: Byte;           // Layer count
    PosCount: Byte;             // Key position count
    KeyCount: Integer;          // Key count
    Track1: Boolean;            // MSR supports track1
    Track2: Boolean;            // MSR supports track2
    Track3: Boolean;            // MSR supports track3
*)
end;


(*
    function GetDeviceInfo: TDeviceInfo;
    function GetLoaderInfo: TDeviceInfo;
    function GetProgramInfo: TDeviceInfo;
    function ReadDeviceModel: Integer;
    function CapShortingReport(DeviceInfo: TDeviceInfo): Boolean;
    function GetShorting: TShortingRec;
    procedure WaitForKeyboard(Timeout: DWORD);
    procedure SetDataMode(DataMode: TDataMode);
    function ReadWord(Address: Word): Word;
    procedure PlayNotes(const Data: string);
    procedure SetMode(AppMode: TAppMode; DataMode: TDataMode);
    procedure WritePage(Address: Word; const S: string);
    function ReadMem(Address, DataLength: Word): string;
    function IsShorted(const Data: TShortingRec): Boolean;
    function GetIndicators: Byte;
    procedure SetIndicators(Value: Byte);


*)

initialization
  RegisterTest('', THidKeyboardTest.Suite);

end.
