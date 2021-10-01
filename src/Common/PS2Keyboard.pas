unit PS2Keyboard;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Forms,
  // This
  KeyboardDevice, Utils, DriverUtils, LogFile, Semaphore, AppMessages,
  KeyboardController, KeyboardTypes;

type
  { TPS2Keyboard }

  TPS2Keyboard = class(TInterfacedObject, IKeyboardDevice)
  private
    FID: Integer;
    FHandle: THandle;
    FDeviceName: string;
    FSemaphore: TSemaphore;
    function GetDeviceName: string;
    procedure SetDeviceName(const Value: string);

  public
    constructor Create;
    destructor Destroy; override;

    procedure Open;
    procedure Close;
    procedure CreateHandle;
    function GetID: Integer;
    function GetName: string;
    function Opened: Boolean;
    function GetHandle: THandle;
    function GetIndicators: Byte;
    function GetUniqueName: string;
    function GetDriverVersion: string;
    procedure SetIndicators(Value: Byte);
    function SendData(const TxData: string; MaxCount: Integer): string;

    property DeviceName: string read GetDeviceName write SetDeviceName;
  end;

const
  CRLF = #13#10;

resourcestring
  MsgDriverNotLoaded            = 'Driver is not loaded';
  MsgWriteDataError             = 'Data write error. Error code: %d';
  MsgDriverNotInstalled         = 'Keyboard driver is not installed.' + CRLF +
    'Connect PS/2 keyboard to PC, install driver and reboot.';

implementation

const
  DriverServiceName   = 'smkbddrv driver';
  DriverDisplayName   = 'smkbddrv driver';

  METHOD_WRITE_DATA   = 2048;
  METHOD_SEND_DATA    = 2049;
  METHOD_GET_VERSION  = 2050;

  METHOD_BUFFERED       = 0;
  FILE_ANY_ACCESS       = 0;
  FILE_DEVICE_KEYBOARD  = $0b;

function CTL_CODE(DevType, DevFunc, DevMethod, DevAccess: DWORD): DWORD;
begin
  Result := (DevType shl 16) or (DevAccess shl 14)
    or (DevFunc shl 2) or DevMethod;
end;

function GetIOCTL(DevFunc: DWORD): DWORD;
begin
  Result := CTL_CODE(FILE_DEVICE_KEYBOARD, DevFunc, METHOD_BUFFERED, FILE_ANY_ACCESS);
end;

{ TPS2Keyboard }

constructor TPS2Keyboard.Create;
begin
  inherited Create;
  FHandle := INVALID_HANDLE_VALUE;
  FSemaphore := TSemaphore.Create;
  Inc(LastDeviceID); FID := LastDeviceID;
end;

destructor TPS2Keyboard.Destroy;
begin
  Close;
  FSemaphore.Free;
  inherited Destroy;
end;

function TPS2Keyboard.GetID: Integer;
begin
  Result := FID;
end;

function TPS2Keyboard.GetName: string;
begin
  Result := PS2DeviceName;
end;

function TPS2Keyboard.GetUniqueName: string;
begin
  Result := PS2DeviceName;
end;

function TPS2Keyboard.Opened: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

function TPS2Keyboard.GetHandle: THandle;
begin
  Open;
  Result := FHandle;
end;

procedure TPS2Keyboard.CreateHandle;
begin
  FSemaphore.Open('TPS2Keyboard');
  if FSemaphore.WaitFor(0) <> WAIT_OBJECT_0 then
    raise EKeyboardException.Create(MsgDeviceInUse);

  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    FHandle := CreateFile('\\.\SmKbdDrv', GENERIC_READ or GENERIC_WRITE,
      0, PSECURITY_DESCRIPTOR(nil), OPEN_EXISTING, 0, 0);

    if not Opened then
    begin
      FSemaphore.Release;
      raise EKeyboardException.Create(MsgDriverNotInstalled);
    end;
  end else
  begin
    FHandle := CreateFile('\\.\smkbddrv.vxd', 0, 0, nil, 0,
      FILE_FLAG_DELETE_ON_CLOSE, 0);
    if not Opened then
    begin
      FSemaphore.Release;
      RaiseLastOSError;
    end;
  end;
end;

procedure TPS2Keyboard.Open;
begin
  if not Opened then
  begin
    CreateHandle;
  end;
end;

procedure TPS2Keyboard.Close;
begin
  if Opened then
  begin
    FSemaphore.Release;
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
  end;
end;

function TPS2Keyboard.SendData(const TxData: string; MaxCount: Integer): string;
var
  V: BOOL;
  R: DWORD;
  S: string;
  i: Integer;
  IOCTL: DWORD;
const
  MaxRxData = 259;
begin
  SetLength(Result, MaxRxData);
  if Length(TxData) > 0 then
  begin
    IOCTL := GetIOCTL(METHOD_SEND_DATA);
    for i := 1 to MaxCount do
    begin
      Logger.WriteData('PS/2 -> ', TxData);
      V := DeviceIoControl(GetHandle, IOCTL,
        @TxData[1], Length(TxData),
        @Result[1], Length(Result), R, nil);

      if V then
      begin
        if R < MaxRxData then SetLength(Result, R);
        Logger.WriteData('PS/2 <- ', Result);

        Break;
      end else
      begin
        Logger.Error(Format('PS/2 %d, %s', [GetLastError, SysErrorMessage(GetLastError)]));

        if i = MaxCount then
        begin
          if (Win32Platform = VER_PLATFORM_WIN32_NT)and
            (GetLastError = ERROR_SEM_TIMEOUT) then
          begin
            RaiseNoConnectionError;
          end else
          begin
            S := Format(MsgWriteDataError, [GetLastError]);
            raise Exception.Create(S);
          end;
        end;
      end;
    end;
  end;
end;

function TPS2Keyboard.GetDriverVersion: string;
var
  R: DWORD;
  IOCTL: DWORD;
  V: array [0..3] of Byte;
begin
  IOCTL := GetIOCTL(METHOD_GET_VERSION);
  if Opened then
  begin
    Win32Check(DeviceIoControl(GetHandle, IOCTL, nil, 0, @V, Sizeof(V), R, nil));
    if R = 4 then
    begin
      Result := Format('%d.%d.%d.%d', [V[3], V[2], V[1], V[0]]);
    end;
  end else
  begin
    Result := MsgDriverNotLoaded;
  end;
end;

procedure TPS2Keyboard.SetIndicators(Value: Byte);
var
  Controller: TKeyboardController;
begin
  Controller := TKeyboardController.Create;
  try
    Controller.SetIndicatorsAll(Value);
  finally
    Controller.Free;
  end;
end;

function TPS2Keyboard.GetIndicators: Byte;
var
  Controller: TKeyboardController;
begin
  Controller := TKeyboardController.Create;
  try
    Result := Controller.GetIndicators;
  finally
    Controller.Free;
  end;
end;


function TPS2Keyboard.GetDeviceName: string;
begin
  Result := FDeviceName;
end;

procedure TPS2Keyboard.SetDeviceName(const Value: string);
begin
  FDeviceName := Value;
end;

end.
