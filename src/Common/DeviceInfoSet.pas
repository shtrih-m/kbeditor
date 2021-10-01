unit DeviceInfoSet;

interface

uses
  // VCL
  Windows, SysUtils,
  // THis
  Hid, SetupAPI, KeyboardDevice, HidKeyboard, LogFile;

type
  { TDeviceInfoSet }

  TDeviceInfoSet = class
  private
    FHandle: HDEVINFO;
    function Opened: Boolean;
    function EnumDeviceInterfaces(DeviceInfoData: PSPDevInfoData;
      const InterfaceClassGuid: TGUID; MemberIndex: DWORD;
      var DeviceInterfaceData: TSPDeviceInterfaceData): Boolean;

    function GetDevicePath(DeviceInterfaceData: PSPDeviceInterfaceData;
      var DevicePath: string): Boolean;

    function GetDeviceInterfaceDetail(
      DeviceInterfaceData: PSPDeviceInterfaceData;
      DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataA;
      DeviceInterfaceDetailDataSize: DWORD; var RequiredSize: DWORD;
      Device: PSPDevInfoData): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(ClassGuid: PGUID; const Enumerator: PAnsiChar;
      hwndParent: HWND; Flags: DWORD);
    procedure Close;

    procedure EnumDevices(Devices: TKeyboardDevices);
  end;

procedure EnumHIDKeyboards(Devices: TKeyboardDevices);

implementation

const
  ShtrihVendorID                = $4B4; //

procedure EnumHIDKeyboards(Devices: TKeyboardDevices);
var
  DeviceInfoSet: TDeviceInfoSet;
begin
  DeviceInfoSet := TDeviceInfoSet.Create;
  try
    DeviceInfoSet.EnumDevices(Devices);
  finally
    DeviceInfoSet.Free;
  end;
end;

{ TDeviceInfoSet }

constructor TDeviceInfoSet.Create;
begin
  inherited Create;
  FHandle := Pointer(INVALID_HANDLE_VALUE);
  LoadSetupApi;
  LoadHid;
end;

destructor TDeviceInfoSet.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TDeviceInfoSet.Open(ClassGuid: PGUID;
  const Enumerator: PAnsiChar; hwndParent: HWND; Flags: DWORD);
begin
  Close;

  FHandle := SetupDiGetClassDevs(ClassGuid, Enumerator, hwndParent, Flags);
  if not Opened then
    RaiseLastOSError;
end;

function TDeviceInfoSet.Opened: Boolean;
begin
  Result := FHandle <> Pointer(INVALID_HANDLE_VALUE);
end;

procedure TDeviceInfoSet.Close;
begin
  if Opened then
  begin
    SetupDiDestroyDeviceInfoList(FHandle);
    FHandle := Pointer(INVALID_HANDLE_VALUE);
  end;
end;

function TDeviceInfoSet.EnumDeviceInterfaces(DeviceInfoData: PSPDevInfoData;
  const InterfaceClassGuid: TGUID; MemberIndex: DWORD;
  var DeviceInterfaceData: TSPDeviceInterfaceData): Boolean;
begin
  DeviceInterfaceData.cbSize := SizeOf(TSPDeviceInterfaceData);
  Result := SetupDiEnumDeviceInterfaces(FHandle, DeviceInfoData,
    InterfaceClassGuid, MemberIndex, DeviceInterfaceData);
end;

function TDeviceInfoSet.GetDeviceInterfaceDetail(
  DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataA;
  DeviceInterfaceDetailDataSize: DWORD; var RequiredSize: DWORD;
  Device: PSPDevInfoData): Boolean;
begin
  Result := SetupDiGetDeviceInterfaceDetail(FHandle, DeviceInterfaceData,
    DeviceInterfaceDetailData, DeviceInterfaceDetailDataSize, RequiredSize,
    Device);
end;

function TDeviceInfoSet.GetDevicePath(
  DeviceInterfaceData: PSPDeviceInterfaceData;
  var DevicePath: string): Boolean;
var
  RequiredSize: DWORD;
  Device: TSPDevInfoData;
  DetailData: PSPDeviceInterfaceDetailData;
begin
  DevicePath := '';
  // get size
  RequiredSize := 0;
  Device.cbSize := SizeOf(Device);
  GetDeviceInterfaceDetail(DeviceInterfaceData, nil, 0, RequiredSize, @Device);
  if GetLastError <> ERROR_INSUFFICIENT_BUFFER then
    RaiseLastOSError;
  //
  DetailData := AllocMem(RequiredSize);
  try
    DetailData.cbSize := SizeOf(TSPDeviceInterfaceDetailData);
    Result := GetDeviceInterfaceDetail(DeviceInterfaceData, DetailData,
      RequiredSize, RequiredSize, @Device);

    if Result then
      DevicePath := PChar(@DetailData.DevicePath);
  finally
    FreeMem(DetailData);
  end;
end;

procedure TDeviceInfoSet.EnumDevices(Devices: TKeyboardDevices);
var
  Index: Integer;
  Success: Boolean;
  DeviceGUID: TGUID;
  DevicePath: string;
  Device: THidKeyboard;
  HidKeyboard: THidKeyboard;
  Attributes: THIDDAttributes;
  IntfData: TSPDeviceInterfaceData;
const
  GUID_DEVINTERFACE_KEYBOARD: TGUID = '{884b96c3-56ef-11d1-bc8c-00a0c91405dd}';
  GUID_DEVINTERFACE_USB_DEVICE: TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';
begin
  Device := THidKeyboard.Create;
  try
    //HidD_GetHidGuid(DeviceGUID);
    DeviceGUID := GUID_DEVINTERFACE_KEYBOARD;
    Open(@DeviceGUID, nil, 0, DIGCF_PRESENT or DIGCF_DEVICEINTERFACE);
    Index := 0;
    repeat
      IntfData.cbSize := SizeOf(TSPDeviceInterfaceData);
      Success := EnumDeviceInterfaces(nil, DeviceGUID, Index, IntfData);
      if Success then
      begin
        if GetDevicePath(@IntfData, DevicePath) then
        begin
          try
            Device.DeviceName := DevicePath;
            Device.Open;

            if Device.ReadAttributes(Attributes) then
            begin
              if (Attributes.VendorID = ShtrihVendorID) then
              begin
                HidKeyboard := THidKeyboard.Create;
                HidKeyboard.Assign(Device);
                Devices.Add(HidKeyboard);
              end;
            end;
          except
            on E: EKeyboardException do
            begin
              Logger.Error(E.Message);
            end;
          end;
        end;
      end;
      Inc(Index);
    until not Success;
  finally
    Device.Free;
  end;
end;

end.
