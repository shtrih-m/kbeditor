unit MockKeyboardDriver;

interface

uses
  // VCl
  Windows, WinSvc, SyncObjs, Classes, SysUtils, Dialogs, Forms,
  // This
  Utils, DeviceError, KeyboardController, LogFile, uProgress,
  KeyboardDevice, HidKeyboard, KeyboardFrame, KeyboardTypes;

type
  { TMockKeyboardDriver }

  TMockKeyboardDriver = class(TInterfacedObject, IKeyboardDriver)
  private
    FDataMode: TDataMode;
    FResetDelay: Integer;
    FStatus: TDeviceStatus;
    FShorting: TShortingRec;
    FDeviceInfo: TDeviceInfo;
    FDevice: IKeyboardDevice;
    FMaxFrameErrors: Integer;
    FWriteModeCount: Integer;
    FMaxDeviceErrors: Integer;
    FWriteModeTimeout: Integer;
    FLoaderInfo: TDeviceInfo;
    FProgramInfo: TDeviceInfo;
  public
    constructor Create;

    function GetIndicators: Byte;
    function GetPageSize: Integer;
    function GetPacketSize: Integer;
    function GetDeviceVersion: Word;
    function CheckShorting: Boolean;
    function GetResetDelay: Integer;
    function GetDevice: IKeyboardDevice;
    function GetWriteModeCount: Integer;
    function GetMaxFrameErrors: Integer;
    function GetMaxDeviceErrors: Integer;
    function GetWriteModeTimeout: Integer;
    function GetDeviceStatus: TDeviceStatus;
    function GetProgramStatus: TDeviceStatus;
    function ReadDeviceModel: Integer;
    function GetShorting: TShortingRec;
    function GetDeviceInfo: TDeviceInfo;
    function GetLoaderInfo: TDeviceInfo;
    function GetProgramInfo: TDeviceInfo;
    function ReadWord(Address: Word): Word;
    function IsShorted(const Data: TShortingRec): Boolean;
    function ReadMemory(Address, DataLength: Word): string;
    function CapShortingReport(DeviceInfo: TDeviceInfo): Boolean;

    procedure SetDefaults;
    procedure SetIndicators(Value: Byte);
    procedure PlayNotes(const Data: string);
    procedure WaitForKeyboard(Timeout: DWORD);
    procedure SetDataMode(Value: TDataMode);
    procedure SetResetDelay(const Value: Integer);
    procedure SetDevice(const Value: IKeyboardDevice);
    procedure SetWriteModeCount(const Value: Integer);
    procedure SetMaxFrameErrors(const Value: Integer);
    procedure SetMaxDeviceErrors(const Value: Integer);
    procedure SetWriteModeTimeout(const Value: Integer);
    procedure WritePage(Address: Word; const S: string);
    procedure SetMode(AppMode: TAppMode; DataMode: TDataMode);
    procedure WritePacket(Address: Word; const Data: string);

    property PageSize: Integer read GetPageSize;
    property PacketSize: Integer read GetPacketSize;
    property Device: IKeyboardDevice read GetDevice write SetDevice;
    property ResetDelay: Integer read GetResetDelay write SetResetDelay;
    property MaxFrameErrors: Integer read GetMaxFrameErrors write SetMaxFrameErrors;
    property MaxDeviceErrors: Integer read GetMaxDeviceErrors write SetMaxDeviceErrors;
    property WriteModeCount: Integer read GetWriteModeCount write SetWriteModeCount;
    property WriteModeTimeout: Integer read GetWriteModeTimeout write SetWriteModeTimeout;
  end;

function WordToStr(Value: Word): string;

implementation

resourcestring
  MsgInvalidFrameLength         = 'Invalid frame length';
  MsgAppModeProgram             = 'program';
  MsgAppModeLoader              = 'loader';
  MsgAppModeUnknown             = 'unknown application mode';
  MsgDataModeData               = 'data';
  MsgDataModeProgram            = 'program';
  MsgDataModeUnknown            = 'unknown data mode';
  MsgMaxFrameLength             = 'Frame length cannot exceed 255';
  MsgOperationDeviceType        = 'Reading device type';
  MsgOperationCheckShorting     = 'Checking shorting rows and columns';
  MsgOperationReadMemory        = 'Memory read, address: %d, size: %d';
  MsgInvalidDataLength          = 'Invalid data size received.'#13#10 + 'Requested size: %d, received size: %d';
  MsgOperationWiteMemory        = 'Memory write, address: %d, size: %d';
  MsgMaxNotesCount              = 'Notes count cannot exceed 84';
  MsgOperationTestSound         = 'Test sound';
  MsgOperationReadMode          = 'Reading mode';
  MsgInvalidProgram             = 'Keyboard program is invalid or corrupted';
  MsgWriteModeTimeout             = 'Timeout setting keyboard mode';
  MsgOperationSetMode           = 'Settings keyboard mode';


const
  // Keyboard commands
  COMMAND_WRITE_MEMORY          = #$9C;  // Write memory
  COMMAND_READ_MEMORY           = #$9D;  // Read memory
  COMMAND_READ_TYPE             = #$9E;  // Read device type
  COMMAND_SOUND_TRACK           = #$A0;  // Test sound
  COMMAND_CONTROL               = #$9F;  // Control device
  COMMAND_CHECK_SHORTING        = #$A1;  // Internal interconnection test
  COMMAND_SET_LEDS              = #$A2;  // Set keyboard leds

{*****************************************************************************}


{*****************************************************************************}

procedure CheckLength(const Data: string; MinLength: Integer);
begin
  if Length(Data) < MinLength then
    raise Exception.Create(MsgInvalidFrameLength);
end;

function TrimLeftZero(const Data: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Data) do
  begin
    if Data[i] <> #0 then
    begin
      Result := Copy(Data, i, Length(Data));
      Break;
    end;
  end;
end;

function AppMode2Str(AppMode: TAppMode): string;
begin
  case AppMode of
    amProg    : Result := MsgAppModeProgram;
    amLoader  : Result := MsgAppModeLoader;
  else
    Result := Format('%d, %s', [Ord(AppMode), MsgAppModeUnknown]);
  end;
end;

function DataMode2Str(DataMode: TDataMode): string;
begin
  case DataMode of
    dmData: Result := MsgDataModeData;
    dmProg: Result := MsgDataModeProgram;
  else
    Result := Format('%d, %s', [Ord(DataMode), MsgDataModeUnknown]);
  end;
end;

{ TMockKeyboardDriver }

constructor TMockKeyboardDriver.Create;
begin
  inherited Create;
  SetDefaults;
end;

procedure TMockKeyboardDriver.SetDefaults;
begin
  FMaxFrameErrors := 3;
  FMaxDeviceErrors := 3;
  FWriteModeCount := 3;
  FWriteModeTimeout := 3000;
  FResetDelay := 500;

  FDeviceInfo.Version := $102;
  FDeviceInfo.VersionText := '827364872346';
  FDeviceInfo.MajorVersion := 2;
  FDeviceInfo.MinorVersion := 6;
  FDeviceInfo.MemSize := $5678;
  FDeviceInfo.Model := 3;
  FDeviceInfo.LayerCount := 4;
  FDeviceInfo.PosCount := 3;
  FDeviceInfo.KeyCount := 3;
  FDeviceInfo.Track1 := True;
  FDeviceInfo.Track2 := True;
  FDeviceInfo.Track3 := True;

  FLoaderInfo.Version := $102;
  FLoaderInfo.VersionText := '827364872346';
  FLoaderInfo.MajorVersion := 2;
  FLoaderInfo.MinorVersion := 6;
  FLoaderInfo.MemSize := $5678;
  FLoaderInfo.Model := 3;
  FLoaderInfo.LayerCount := 4;
  FLoaderInfo.PosCount := 3;
  FLoaderInfo.KeyCount := 3;
  FLoaderInfo.Track1 := True;
  FLoaderInfo.Track2 := True;
  FLoaderInfo.Track3 := True;

  FProgramInfo.Version := $102;
  FProgramInfo.VersionText := '827364872346';
  FProgramInfo.MajorVersion := 2;
  FProgramInfo.MinorVersion := 6;
  FProgramInfo.MemSize := $5678;
  FProgramInfo.Model := 3;
  FProgramInfo.LayerCount := 4;
  FProgramInfo.PosCount := 3;
  FProgramInfo.KeyCount := 3;
  FProgramInfo.Track1 := True;
  FProgramInfo.Track2 := True;
  FProgramInfo.Track3 := True;
end;

function TMockKeyboardDriver.GetDevice: IKeyboardDevice;
begin
  Result := FDevice;
end;

procedure StartOperation(const S: string);
begin
  Logger.Debug(S);
  Progress.Operation := S;
end;

function TMockKeyboardDriver.GetDeviceInfo: TDeviceInfo;
begin
  Result := FDeviceInfo;
end;

function TMockKeyboardDriver.GetShorting: TShortingRec;
begin
  Result := FShorting;
end;

function TMockKeyboardDriver.IsShorted(const Data: TShortingRec): Boolean;
var
  i: Integer;
begin
  // Rows
  for i := Low(Data.Rows) to High(Data.Rows) do
  begin
    Result := Data.Rows[i];
    if Result then Exit;
  end;
  // Cols
  for i := Low(Data.Cols) to High(Data.Cols) do
  begin
    Result := Data.Cols[i];
    if Result then Exit;
  end;
end;

function WordToStr(Value: Word): string;
begin
  SetLength(Result, 2);
  Move(Value, Result[1], 2);
end;

function TMockKeyboardDriver.ReadMemory(Address, DataLength: Word): string;
begin
  Result := '';
end;

function TMockKeyboardDriver.ReadWord(Address: Word): Word;
var
  S: string;
begin
  S := ReadMemory(Address, 2);
  Move(S[1], Result, 2);
end;

procedure TMockKeyboardDriver.WritePacket(Address: Word; const Data: string);
begin
  { !!! }
end;

procedure TMockKeyboardDriver.WritePage(Address: Word; const S: string);
var
  Data: string;
begin
  Data := S;
  SetLength(Data, DevicePageSize);
  WritePacket(Address, Copy(Data, 1, PacketSize));
  WritePacket(Address + PacketSize, Copy(Data, PacketSize+1, PacketSize));
end;

procedure TMockKeyboardDriver.PlayNotes(const Data: string);
begin
  { !!! }
end;

function TMockKeyboardDriver.GetDeviceStatus: TDeviceStatus;
begin
  Result := FStatus;
end;

procedure TMockKeyboardDriver.SetMode(AppMode: TAppMode; DataMode: TDataMode);
begin
  { !!! }
end;

function TMockKeyboardDriver.GetProgramStatus: TDeviceStatus;
begin
end;

function TMockKeyboardDriver.GetLoaderInfo: TDeviceInfo;
begin
  Result := FLoaderInfo;
end;

function TMockKeyboardDriver.GetProgramInfo: TDeviceInfo;
begin
  Result := FProgramInfo;
end;

function TMockKeyboardDriver.CapShortingReport(DeviceInfo: TDeviceInfo): Boolean;
begin
  Result := (DeviceInfo.MajorVersion >=2) and(DeviceInfo.MinorVersion > 5);
end;

function TMockKeyboardDriver.CheckShorting: Boolean;
begin
  Result := IsShorted(GetShorting);
end;

procedure TMockKeyboardDriver.WaitForKeyboard(Timeout: DWORD);
begin
end;

procedure TMockKeyboardDriver.SetDataMode(Value: TDataMode);
begin
  FDataMode := Value;
end;

function TMockKeyboardDriver.ReadDeviceModel: Integer;
begin
  Result := GetProgramInfo.Model;
end;

function TMockKeyboardDriver.GetDeviceVersion: Word;
var
  DeviceInfo: TDeviceInfo;
begin
  DeviceInfo := GetProgramInfo;
  Result := (DeviceInfo.MajorVersion shl 8) + DeviceInfo.MinorVersion;
end;

procedure TMockKeyboardDriver.SetIndicators(Value: Byte);
begin
  Device.SetIndicators(Value);
end;

function TMockKeyboardDriver.GetIndicators: Byte;
begin
  Result := Device.GetIndicators;
end;

function TMockKeyboardDriver.GetPacketSize: Integer;
begin
  Result := DevicePacketSize;
end;

function TMockKeyboardDriver.GetPageSize: Integer;
begin
  Result := DevicePageSize;
end;

function TMockKeyboardDriver.GetResetDelay: Integer;
begin
  Result := FResetDelay;
end;

procedure TMockKeyboardDriver.SetResetDelay(const Value: Integer);
begin
  FResetDelay := Value;
end;

procedure TMockKeyboardDriver.SetDevice(const Value: IKeyboardDevice);
begin
  FDevice := Value;
end;

function TMockKeyboardDriver.GetWriteModeCount: Integer;
begin
  Result := FWriteModeCount;
end;

function TMockKeyboardDriver.GetWriteModeTimeout: Integer;
begin
  Result := FWriteModeTimeout;
end;

procedure TMockKeyboardDriver.SetWriteModeCount(const Value: Integer);
begin
  FWriteModeCount := Value;
end;

procedure TMockKeyboardDriver.SetWriteModeTimeout(const Value: Integer);
begin
  FWriteModeTimeout := Value;
end;

function TMockKeyboardDriver.GetMaxDeviceErrors: Integer;
begin
  Result := FMaxDeviceErrors;
end;

function TMockKeyboardDriver.GetMaxFrameErrors: Integer;
begin
  Result := FMaxFrameErrors;
end;

procedure TMockKeyboardDriver.SetMaxDeviceErrors(const Value: Integer);
begin
  FMaxDeviceErrors := Value;
end;

procedure TMockKeyboardDriver.SetMaxFrameErrors(const Value: Integer);
begin
  FMaxFrameErrors := Value;
end;

end.


