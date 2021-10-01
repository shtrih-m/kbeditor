unit HidKeyboard;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SysConst, Forms, ComObj,
  // This
  KeyboardDevice, HID, SetupAPI, DebugUtils, LogFile, Utils, Semaphore,
  AppMessages, KeyboardController, KeyboardTypes;

type
  { THidKeyboard }

  THidKeyboard = class(TInterfacedObject, IKeyboardDevice)
  private
    FID: Integer;
    FHandle: THandle;
    FCaps: THIDPCaps;
    FValidCaps: Boolean;
    FDeviceName: string;
    FSemaphore: TSemaphore;

    function GetHandle: THandle;
    function GetCaps: THIDPCaps;
    function ReadAnswer: string;
    function ReadCaps: THIDPCaps;
    procedure Check(Value: Boolean);
    function GetProductString: string;
    procedure SetFeature(Data: string);
    function GetFeature(Count: DWORD): string;
    procedure SetDeviceName(const Value: string);
    function PortSendData(const TxData: string): string;
    function WriteCommand(const TxData: string): string;
    function GetDeviceName: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open;
    procedure Close;
    function GetID: Integer;
    function Opened: Boolean;
    function GetName: string;
    function GetIndicators: Byte;
    function GetUniqueName: string;
    procedure SetIndicators(Value: Byte);
    function GetSerialNumberString: string;
    procedure Assign(Source: THidKeyboard);
    function GetManufacturerString: string;
    function SendData(const TxData: string; MaxCount: Integer): string;
    class procedure RaiseError(const Message: string);
    class function Succeeded(ResultCode: Integer): Boolean;
    function ReadAttributes(var R: THIDDAttributes): Boolean;

    property Caps: THIDPCaps read GetCaps;
    property Handle: THandle read GetHandle;
    property DeviceName: string read GetDeviceName write SetDeviceName;
  end;

implementation

resourcestring
  MsgEmptyData = 'Empty data';

const
  // Device not connected
  ERROR_DEVICE_NOT_CONNECTED = 1167;

{ THidKeyboard }

constructor THidKeyboard.Create;
begin
  inherited Create;
  FHandle := INVALID_HANDLE_VALUE;
  FSemaphore := TSemaphore.Create;
  Inc(LastDeviceID); FID := LastDeviceID;
end;

destructor THidKeyboard.Destroy;
begin
  Close;
  FSemaphore.Free;
  inherited Destroy;
end;

function THidKeyboard.GetHandle: THandle;
begin
  Open;
  Result := FHandle;
end;

class procedure THidKeyboard.RaiseError(const Message: string);
begin
  raise EKeyboardException.Create(Message);
end;

procedure THidKeyboard.Open;
var
  SemaphoreName: string;
begin
  if not Opened then
  begin
    //Logger.Debug(Format('THidKeyboard.Open("%s")', [Path]));

    LoadSetupApi;
    LoadHid;

    // we cannot put path as semaphore name, we must hash it
    SemaphoreName := StrToBin(DeviceName);
    FSemaphore.Open(SemaphoreName);
    case FSemaphore.WaitFor(0) of
      WAIT_OBJECT_0: ;
      WAIT_TIMEOUT: RaiseError(MsgDeviceInUse);
    else
      RaiseError(SysErrorMessage(GetLastError));
    end;

    FHandle := CreateFile(PChar(DeviceName), 0,
      FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);

    if not Opened then
    begin
      FSemaphore.Release;
      RaiseError(SysErrorMessage(GetLastError));
    end;
  end;
end;

procedure THidKeyboard.Close;
begin
  if Opened then
  begin
    //Logger.Debug('THidKeyboard.Close');

    FSemaphore.Release;
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    FValidCaps := False;
  end;
end;

function THidKeyboard.Opened: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

procedure THidKeyboard.Check(Value: Boolean);
var
  LastError: Integer;
  ErrorMessage: string;
begin
  if Value then Exit;

  LastError := GetLastError;
  ErrorMessage := SysErrorMessage(LastError);

  // Handle error to recover device reconnect
  if LastError = ERROR_DEVICE_NOT_CONNECTED then
  begin
    Close;
    Open;
  end;
  raise EKeyboardException.Create(ErrorMessage);
end;

procedure THidKeyboard.SetFeature(Data: string);
begin
  if Length(Data) = 0 then Exit;
  Check(Hidd_SetFeature(GetHandle, Data[1], Length(Data)));
end;

function THidKeyboard.GetFeature(Count: DWORD): string;
begin
  Result := '';
  if Count = 0 then Exit;

  SetLength(Result, Count);
  Result[1] := #0;
  Check(Hidd_GetFeature(GetHandle, Result[1], Count));
end;

function THidKeyboard.ReadAttributes(var R: THIDDAttributes): Boolean;
begin
  R.Size := SizeOf(THIDDAttributes);
  Result := HidD_GetAttributes(GetHandle, R);
end;

function THidKeyboard.GetManufacturerString: string;
var
  Buffer: array [0..253] of WideChar;
begin
  FillChar(Buffer, SizeOf(Buffer), #0);
  Check(HidD_GetManufacturerString(GetHandle, Buffer, SizeOf(Buffer)));
  Result := Buffer;
end;

function THidKeyboard.GetSerialNumberString: string;
var
  Buffer: array [0..253] of WideChar;
begin
  FillChar(Buffer, SizeOf(Buffer), #0);
  Check(HidD_GetSerialNumberString(GetHandle, Buffer, SizeOf(Buffer)));
  Result := Buffer;
end;

function THidKeyboard.GetProductString: string;
var
  Buffer: array [0..253] of WideChar;
begin
  FillChar(Buffer, SizeOf(Buffer), #0);
  Check(HidD_GetProductString(GetHandle, Buffer, SizeOf(Buffer)));
  Result := Buffer;
end;

function THidKeyboard.GetCaps: THIDPCaps;
begin
  if not FValidCaps then
  begin
    FCaps := ReadCaps;
    FValidCaps := True;
  end;
  Result := FCaps;
end;

function THidKeyboard.ReadCaps: THIDPCaps;
var
  P: PHIDPPreparsedData;
begin
  Check(HidD_GetPreparsedData(GetHandle, P));
  FillChar(Result, SizeOf(THIDPCaps), #0);
  Check(HidP_GetCaps(P, Result) = HIDP_STATUS_SUCCESS);
end;

class function THidKeyboard.Succeeded(ResultCode: Integer): Boolean;
begin
  Result := Windows.Succeeded(ResultCode);
end;

procedure THidKeyboard.Assign(Source: THidKeyboard);
begin
  FCaps := Source.FCaps;
  FValidCaps := Source.FValidCaps;
  FDeviceName := Source.FDeviceName;
end;

function THidKeyboard.GetName: string;
begin
  Result := GetProductString;
end;

function THidKeyboard.GetUniqueName: string;
begin
  Result := DeviceName;
end;

function THidKeyboard.PortSendData(const TxData: string): string;
begin
  WriteCommand(TxData);
  Result := ReadAnswer;
end;

function THidKeyboard.WriteCommand(const TxData: string): string;

  function SetLen(const S: string; Count: Integer): string;
  begin
    Result := Copy(S, 1, Count);
    Result := Result + StringOfChar(#0, Count - Length(Result));
  end;

var
  i: Integer;
  Data: string;
  Count: Integer;
  ReportLength: Integer;
begin
  Result := '';
  ReportLength := Caps.FeatureReportByteLength-1;
  Count := (Length(TxData) + ReportLength - 1) div ReportLength;
  // Write command
  for i := 0 to Count-1 do
  begin
    Data := Copy(TxData, i*ReportLength+1, ReportLength);
    Data := #0 + SetLen(Data, ReportLength+1);
    Logger.WriteData('USB -> ', Data);
    SetFeature(Data);
  end;
end;

function THidKeyboard.ReadAnswer: string;
var
  i: Integer;
  Data: string;
  Count: Integer;
  DataLength: Integer;
  ReportLength: Integer;
begin
  ReportLength := Caps.FeatureReportByteLength-1;
  Data := GetFeature(ReportLength+1);
  Logger.WriteData('USB <- ', Data);
  Data := Copy(Data, 2, Length(Data));
  if Length(Data) > 1 then
  begin
    Result := Data;
    DataLength := Ord(Data[2]);
    if (DataLength + 5) > ReportLength then
    begin
      Count := (DataLength + 5 + ReportLength - 1) div ReportLength;
      for i := 1 to Count-1 do
      begin
        Data := GetFeature(ReportLength+1);
        Data := Copy(Data, 2, Length(Data));
        Result := Result + Data;
      end;
    end;
    Result := Copy(Result, 1, DataLength + 3);
  end;
end;

function THidKeyboard.SendData(const TxData: string; MaxCount: Integer): string;
begin
  if Length(TxData) = 0 then
    RaiseError(MsgEmptyData);

  Result := PortSendData(TxData);
end;

procedure THidKeyboard.SetIndicators(Value: Byte);
var
  ReturnedLength: DWORD;
  InputBuffer: TKIParameters;
begin
  InputBuffer.UnitId := 0;
  InputBuffer.LedFlags := Value;
  Win32Check(DeviceIoControl(GetHandle, IOCTL_KEYBOARD_SET_INDICATORS,
    @InputBuffer, Sizeof(TKIParameters), nil, 0, ReturnedLength, nil));
end;

function THidKeyboard.GetIndicators: Byte;
var
  UnitID: WORD;
  ReturnedLength: DWORD;
  OutputBuffer: TKIParameters;
begin
  UnitID := 0;
  OutputBuffer.UnitId := 0;
  Win32Check(DeviceIoControl(GetHandle, IOCTL_KEYBOARD_QUERY_INDICATORS,
    @UnitID, Sizeof(UnitID),
    @OutputBuffer, Sizeof(TKIParameters), ReturnedLength, nil));

  Result := OutputBuffer.LedFlags;
end;

procedure THidKeyboard.SetDeviceName(const Value: string);
begin
  if Value <> DeviceName then
  begin
    Close;
    FDeviceName := Value;
  end;
end;

function THidKeyboard.GetID: Integer;
begin
  Result := FID;
end;

function THidKeyboard.GetDeviceName: string;
begin
  Result := FDeviceName;
end;

end.
