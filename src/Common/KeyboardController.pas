unit KeyboardController;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Registry,
  // This
  LogFile;

type
  // Keyboard indicator parameters

  { TKIParameters }

  TKIParameters = packed record
    UnitId: WORD;       // Unit ID
    LedFlags: WORD;     // LED indicator state.
  end;

  { TKeyboard }

  TKeyboardController = class
  private
    FHandle: THandle;
    FDeviceName: string;
    FDeviceIndex: Integer;

    function Opened: Boolean;
    function GetHandle: THandle;
    function CreateHandle: THandle;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Close;
    function GetIndicators: Byte;
    procedure SetIndicators(Value: Byte);
    procedure SetIndicatorsAll(Value: Byte);
    procedure GetDeviceNames(DeviceNames: TStrings);
  end;

const
  // Keyboard indicators
  KEYBOARD_SCROLL_LOCK_ON       = 1;
  KEYBOARD_NUM_LOCK_ON          = 2;
  KEYBOARD_CAPS_LOCK_ON         = 4;

  KEYBOARD_ALL = KEYBOARD_SCROLL_LOCK_ON + KEYBOARD_NUM_LOCK_ON + KEYBOARD_CAPS_LOCK_ON;

var
  IOCTL_KEYBOARD_SET_INDICATORS: DWORD;
  IOCTL_KEYBOARD_QUERY_INDICATORS: DWORD;

implementation

const
  METHOD_BUFFERED       = 0;
  FILE_ANY_ACCESS       = 0;
  FILE_DEVICE_KEYBOARD  = $0b;
  DefaultDeviceName = '\Device\KeyboardClass0';


function CTL_CODE(DevType, DevFunc, DevMethod, DevAccess: DWORD): DWORD;
begin
  Result := (DevType shl 16) or (DevAccess shl 14)
    or (DevFunc shl 2) or DevMethod;
end;

{ TKeyboardController }

constructor TKeyboardController.Create;
begin
  inherited Create;
  FDeviceName := DefaultDeviceName;
  FHandle := INVALID_HANDLE_VALUE;
end;

destructor TKeyboardController.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TKeyboardController.CreateHandle: THandle;
begin
  Win32Check(DefineDosDevice(DDD_RAW_TARGET_PATH, 'Kbd', PChar(FDeviceName)));
  Result := CreateFile('\\.\Kbd', 0, 0, nil, OPEN_EXISTING, 0, 0);

  if Result = INVALID_HANDLE_VALUE then
    RaiseLastOSError;
end;

procedure TKeyboardController.Close;
begin
  Win32Check(DefineDosDevice(DDD_REMOVE_DEFINITION, 'Kbd', nil));
  if Opened then
  begin
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
  end;
end;

function TKeyboardController.Opened: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

function TKeyboardController.GetHandle: THandle;
begin
  if not Opened then
    FHandle := CreateHandle;
  Result := FHandle;
end;

// Read indicators state
function TKeyboardController.GetIndicators: Byte;
var
  ReturnedLength: DWORD;
  InputBuffer: TKIParameters;
  OutputBuffer: TKIParameters;
begin
  InputBuffer.UnitId := FDeviceIndex;
  OutputBuffer.UnitId := FDeviceIndex;
  // Save indicators state
  Win32Check(DeviceIoControl(GetHandle, IOCTL_KEYBOARD_QUERY_INDICATORS,
    @InputBuffer, Sizeof(TKIParameters),
    @OutputBuffer, Sizeof(TKIParameters), ReturnedLength, nil));

  Result := OutputBuffer.LedFlags;
end;

// Set indicators state

procedure TKeyboardController.SetIndicators(Value: Byte);
var
  ReturnedLength: DWORD;
  InputBuffer: TKIParameters;
begin
  InputBuffer.UnitId := FDeviceIndex;
  InputBuffer.LedFlags := Value;
  Win32Check(DeviceIoControl(GetHandle, IOCTL_KEYBOARD_SET_INDICATORS,
    @InputBuffer, Sizeof(TKIParameters), nil, 0, ReturnedLength, nil));
end;

// Set indicators state for all keyboards

procedure TKeyboardController.SetIndicatorsAll(Value: Byte);
var
  i: Integer;
  DeviceNames: TStrings;
begin
  Logger.Debug('TKeyboardController.SetIndicatorsAll');

  Close;
  DeviceNames := TStringList.Create;
  try
    GetDeviceNames(DeviceNames);
    for i := 0 to DeviceNames.Count-1 do
    begin
      FDeviceIndex := i;
      FDeviceName := DeviceNames[i];
      try
        SetIndicators(Value);
      except
        on E: Exception do
        begin
          Logger.Error(E.Message);
        end;
      end;
      Close;
    end;
  finally
    DeviceNames.Free;
    FDeviceName := DefaultDeviceName;
  end;
end;

// Read device list from registry

procedure TKeyboardController.GetDeviceNames(DeviceNames: TStrings);
var
  Reg: TRegistry;
begin
  DeviceNames.Clear;
  Reg := TRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\HARDWARE\DEVICEMAP\KeyboardClass', False) then
      Reg.GetValueNames(DeviceNames);
  finally
    Reg.Free;
  end;
end;

initialization
  IOCTL_KEYBOARD_SET_INDICATORS := CTL_CODE(FILE_DEVICE_KEYBOARD, $0002, METHOD_BUFFERED, FILE_ANY_ACCESS);
  IOCTL_KEYBOARD_QUERY_INDICATORS := CTL_CODE(FILE_DEVICE_KEYBOARD, $0010, METHOD_BUFFERED, FILE_ANY_ACCESS);

end.
