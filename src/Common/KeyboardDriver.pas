unit KeyboardDriver;

interface

uses
  // VCl
  Windows, WinSvc, SyncObjs, Classes, SysUtils, Dialogs, Forms,
  // This
  Utils, DeviceError, KeyboardController, LogFile, uProgress,
  KeyboardDevice, HidKeyboard, KeyboardFrame, KeyboardTypes;

type
  { TKeyboardDriver }

  TKeyboardDriver = class(TInterfacedObject, IKeyboardDriver)
  private
    FResetDelay: Integer;
    FDevice: IKeyboardDevice;
    FMaxFrameErrors: Integer;
    FMaxDeviceErrors: Integer;
    FWriteModeCount: Integer;
    FWriteModeTimeout: Integer;

    procedure SendFrame(const TxData: string; var RxData: string);
    function DoSetMode(AppMode: TAppMode; DataMode: TDataMode;
      var Status: TDeviceStatus): Boolean;

    procedure SetDeviceMode(AppMode: TAppMode; DataMode: TDataMode);
    procedure LogDeviceInfo(const Data: TDeviceInfo);
  protected
    procedure SendData(const TxData: string; var RxData: string);
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
    procedure SetDataMode(DataMode: TDataMode);
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

{ TKeyboardDriver }

constructor TKeyboardDriver.Create;
begin
  inherited Create;
  SetDefaults;
end;

procedure TKeyboardDriver.SetDefaults;
begin
  FMaxFrameErrors := 3;
  FMaxDeviceErrors := 3;
  FWriteModeCount := 3;
  FWriteModeTimeout := 3000;
  FResetDelay := 500;
end;

procedure TKeyboardDriver.SendData(const TxData: string; var RxData: string);
begin
  RxData := Device.SendData(TxData, 3);
end;

function TKeyboardDriver.GetDevice: IKeyboardDevice;
begin
  if FDevice = nil then
    raise Exception.Create('Device is not assigned.');

  Result := FDevice;
end;

procedure TKeyboardDriver.SendFrame(const TxData: string; var RxData: string);
var
  FrameErrors: Integer;
  DeviceErrors: Integer;
begin
  if Length(TxData) > 255 then
    raise Exception.Create(MsgMaxFrameLength);

  FrameErrors := 0;
  DeviceErrors := 0;
  repeat
    try
      SendData(TKeyboardFrame.Encode(TxData), RxData);
      RxData := TKeyboardFrame.Decode(RxData);
      Break;
    except
      on E: EFrameException do
      begin
        Logger.Error('Frame error: ' + E.Message);
        Inc(FrameErrors);
        if FrameErrors >= MaxFrameErrors then raise;
      end;
      on E: EDeviceError do
      begin
        Logger.Error('Device error: ' + E.Message);
        Inc(DeviceErrors);
        if DeviceErrors >= MaxDeviceErrors then raise;
      end;
    end;
  until False;
end;

procedure StartOperation(const S: string);
begin
  Logger.Debug(S);
  Progress.Operation := S;
end;

function TKeyboardDriver.GetDeviceInfo: TDeviceInfo;
var
  Data: string;
  TrackMask: Byte;
begin
  Logger.Debug('TKeyboardDriver.GetDeviceInfo');

  StartOperation(MsgOperationDeviceType);
  SendFrame(COMMAND_READ_TYPE, Data);
  CheckLength(Data, 8);
  // Device version, 2 bytes
  Result.Version := (Ord(Data[1]) shl 8) + Ord(Data[2]);
  Result.MajorVersion := Hi(Result.Version);
  Result.MinorVersion := Lo(Result.Version);
  Result.VersionText := Format('%d.%d',
    [Result.MajorVersion, Result.MinorVersion]);

  // Memory size, 2 bytes
  Move(Data[3], Result.MemSize, 2);
  // Device type, 1 byte
  Result.Model := Ord(Data[5]);

  // Layer count, 1 byte
  Result.LayerCount := Ord(Data[6]);
  // MSR tracks, 1 byte
  TrackMask := Ord(Data[7]);
  Result.Track1 := TestBit(TrackMask, 0);
  Result.Track2 := TestBit(TrackMask, 1);
  Result.Track3 := TestBit(TrackMask, 2);
  // Key position count
  Result.PosCount := Ord(Data[8]);
  // Keys count
  Result.KeyCount := 0;
  if Length(Data) > 8 then
    Result.KeyCount := Ord(Data[9]);

  LogDeviceInfo(Result);
end;

procedure TKeyboardDriver.LogDeviceInfo(const Data: TDeviceInfo);
begin
  Logger.Debug('DeviceInfo.Version: ', [Data.Version]);
  Logger.Debug('DeviceInfo.VersionText: ', [Data.VersionText]);
  Logger.Debug('DeviceInfo.MajorVersion: ', [Data.MajorVersion]);
  Logger.Debug('DeviceInfo.MinorVersion: ', [Data.MinorVersion]);
  Logger.Debug('DeviceInfo.MemSize: ', [Data.MemSize]);
  Logger.Debug('DeviceInfo.Model: ', [Data.Model]);
  Logger.Debug('DeviceInfo.LayerCount: ', [Data.LayerCount]);
  Logger.Debug('DeviceInfo.PosCount: ', [Data.PosCount]);
  Logger.Debug('DeviceInfo.KeyCount: ', [Data.KeyCount]);
  Logger.Debug('DeviceInfo.Track1: ', [Data.Track1]);
  Logger.Debug('DeviceInfo.Track2: ', [Data.Track2]);
  Logger.Debug('DeviceInfo.Track3: ', [Data.Track3]);
end;

(******************************************************************************

Тест замыкания строк и столбцов матрицы клавиатуры

Команда:	A1H. Длина сообщения: 1 байт.
Ответ:		A1H. Длина сообщения: 5 байт.
        - Код ошибки (1 байт)
        - Биты, соответствующие замкнутым строкам с 8 по 1 строку  (1 байт)
        - Биты, соответствующие замкнутым строкам 16 по 9 строку (1 байт)
        - Биты, соответствующие замкнутым столбцам с 8 по 1 столбец (1 байт)

*******************************************************************************)

function TKeyboardDriver.GetShorting: TShortingRec;
var
  B: Byte;
  i: Integer;
  Data: string;
begin
  SetMode(amLoader, dmData);
  StartOperation(MsgOperationCheckShorting);
  SendFrame(COMMAND_CHECK_SHORTING, Data);
  CheckLength(Data, 3);
  // Data
  for i := 1 to 3 do
    Result.Data[i] := Ord(Data[i]);
  // Rows 1..8
  B := Ord(Data[1]);
  for i := 1 to 8 do
    Result.Rows[i] := TestBit(B, i-1);
  // Rows 9..16
  B := Ord(Data[2]);
  for i := 1 to 8 do
    Result.Rows[i + 8] := TestBit(B, i-1);
  // Cols 1..8
  B := Ord(Data[3]);
  for i := 1 to 8 do
    Result.Cols[i] := TestBit(B, i-1);

  // RowsShorted
  Result.RowsShorted := 0;
  for i := Low(Result.Rows) to High(Result.Rows) do
    if Result.Rows[i] then Inc(Result.RowsShorted);
  // ColsShorted
  Result.ColsShorted := 0;
  for i := Low(Result.Cols) to High(Result.Cols) do
    if Result.Cols[i] then Inc(Result.ColsShorted);

  Result.IsShorted := (Result.ColsShorted + Result.RowsShorted) > 0;
end;

function TKeyboardDriver.IsShorted(const Data: TShortingRec): Boolean;
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

function TKeyboardDriver.ReadMemory(Address, DataLength: Word): string;
var
  TxData: string;
begin
  TxData := COMMAND_READ_MEMORY + WordToStr(Address) + Chr(DataLength);
  StartOperation(Format(MsgOperationReadMemory, [Address, DataLength]));

  SendFrame(TxData, Result);

  Result := Copy(Result, 1, DataLength);
  if Length(Result) < DataLength then
    raise Exception.CreateFmt(MsgInvalidDataLength, [DataLength, Length(Result)]);
end;

function TKeyboardDriver.ReadWord(Address: Word): Word;
var
  S: string;
begin
  S := ReadMemory(Address, 2);
  Move(S[1], Result, 2);
end;

procedure TKeyboardDriver.WritePacket(Address: Word; const Data: string);
var
  TxData: string;
  RxData: string;
begin
  StartOperation(Format(MsgOperationWiteMemory, [Address, Length(Data)]));
  TxData := COMMAND_WRITE_MEMORY + WordToStr(Address) + Data;
  SendFrame(TxData, RxData);
end;

procedure TKeyboardDriver.WritePage(Address: Word; const S: string);
var
  Data: string;
begin
  Data := S;
  SetLength(Data, DevicePageSize);
  WritePacket(Address, Copy(Data, 1, PacketSize));
  WritePacket(Address + PacketSize, Copy(Data, PacketSize+1, PacketSize));
end;

procedure TKeyboardDriver.PlayNotes(const Data: string);
var
  TxData: string;
  RxData: string;
begin
  if Length(Data) > 254 then
    raise Exception.Create(MsgMaxNotesCount);

  TxData := COMMAND_SOUND_TRACK + Data;
  StartOperation(MsgOperationTestSound);
  SendFrame(TxData, RxData);
end;

function TKeyboardDriver.GetDeviceStatus: TDeviceStatus;
var
  Data: string;
const
  BoolToInt: array [Boolean] of Integer = (0, 1);
begin
  StartOperation(MsgOperationReadMode);
  SendFrame(COMMAND_CONTROL, Data);

  CheckLength(Data, 1);
  Result.Status := Ord(Data[1]);
  Result.CRCOK := TestBit(Result.Status, 0);
  Result.AppMode := TAppMode(BoolToInt[TestBit(Result.Status, 1)]);
  Result.DataMode := TDataMode(BoolToInt[TestBit(Result.Status, 4)]);
  Result.IsValidLayout := TestBit(Result.Status, 5);

  StartOperation(Format('%s: %s, %s', [MsgOperationReadMode,
    AppMode2Str(Result.AppMode), DataMode2Str(Result.DataMode)]));
end;

{****************************************************************************}
{
{       Settings device mode with timeout check
{
{****************************************************************************}

procedure TKeyboardDriver.SetMode(AppMode: TAppMode; DataMode: TDataMode);
var
  i: Integer;
  TickCount: Integer;
  DeviceStatus: TDeviceStatus;
begin
  // Check mode
  DeviceStatus := GetDeviceStatus;
  if (DeviceStatus.AppMode = AppMode)and(DeviceStatus.DataMode = DataMode) then
    Exit;

  // Set mode
  for i := 1 to WriteModeCount do
  begin
    try
      SetDeviceMode(AppMode, DataMode);
      if DeviceStatus.AppMode <> AppMode then
      begin
        Sleep(FResetDelay);
      end;

      TickCount := GetTickCount;
      repeat
        DeviceStatus := GetDeviceStatus;
        if (AppMode = amProg)and(not DeviceStatus.CRCOK) then
          raise Exception.Create(MsgInvalidProgram);

        if (DeviceStatus.AppMode = AppMode)and(DeviceStatus.DataMode = DataMode) then
          Exit;

        if (Integer(GetTickCount) - TickCount) > WriteModeTimeout then Break;
        Sleep(100);
      until False;
    except
      on E: EKeyboardException do
      begin
        Logger.Error('SetMode error: ' + E.Message);
      end;
    end;
  end;
  raise Exception.Create(MsgWriteModeTimeout);
end;

function TKeyboardDriver.DoSetMode(AppMode: TAppMode;
  DataMode: TDataMode; var Status: TDeviceStatus): Boolean;
var
  i: Integer;
  TickCount: Integer;
begin
  // Check mode
  Status := GetDeviceStatus;
  Result := (Status.AppMode = AppMode)and(Status.DataMode = DataMode);
  if Result then Exit;

  // Set mode
  for i := 1 to WriteModeCount do
  begin
    try
      SetDeviceMode(AppMode, DataMode);
      if Status.AppMode <> AppMode then
      begin
        Sleep(FResetDelay);
      end;

      TickCount := GetTickCount;
      repeat
        Status := GetDeviceStatus;
        if not Status.CRCOK then Exit;

        if (Status.AppMode = AppMode)and(Status.DataMode = DataMode) then Exit;
        if (Integer(GetTickCount) - TickCount) > WriteModeTimeout then Break;
        Sleep(100);
      until False;
    except
      on E: EKeyboardException do
      begin
        Logger.Error('SetMode error: ' + E.Message);
      end;
    end;
  end;
  raise Exception.Create(MsgWriteModeTimeout);
end;

function TKeyboardDriver.GetProgramStatus: TDeviceStatus;
begin
  DoSetMode(amProg, dmData, Result);
end;

function TKeyboardDriver.GetLoaderInfo: TDeviceInfo;
begin
  SetMode(amLoader, dmData);
  Result := GetDeviceInfo;
end;

function TKeyboardDriver.GetProgramInfo: TDeviceInfo;
begin
  SetMode(amProg, dmData);
  Result := GetDeviceInfo;
end;

procedure TKeyboardDriver.SetDeviceMode(AppMode: TAppMode; DataMode: TDataMode);
var
  B: Byte;
  RxData: string;
begin
  B := 0;
  if AppMode = amLoader then SetBit(B, 1);
  if DataMode = dmProg then SetBit(B, 4);
  StartOperation(Format('%s: %s, %s', [MsgOperationSetMode,
    AppMode2Str(AppMode), DataMode2Str(DataMode)]));
  SendFrame(COMMAND_CONTROL + Chr(B), RxData);
end;

function TKeyboardDriver.CapShortingReport(DeviceInfo: TDeviceInfo): Boolean;
begin
  Result := (DeviceInfo.MajorVersion >=2) and(DeviceInfo.MinorVersion > 5);
end;

function TKeyboardDriver.CheckShorting: Boolean;
begin
  Result := IsShorted(GetShorting);
end;

{ Device status checking with timeout }

procedure TKeyboardDriver.WaitForKeyboard(Timeout: DWORD);
var
  TickCount: DWORD;
begin
  TickCount := GetTickCount;
  while True do
  begin
    try
      GetDeviceStatus;
      Break;
    except
      on E: Exception do
      begin
        Logger.Error('WaitForKeyboard: ' + E.Message);
        if ((GetTickCount - TickCount) > Timeout) then Raise
        else Sleep(500);
      end;
    end;
  end;
end;

procedure TKeyboardDriver.SetDataMode(DataMode: TDataMode);
var
  DeviceStatus: TDeviceStatus;
begin
  DeviceStatus := GetDeviceStatus;
  if DeviceStatus.DataMode <> DataMode then
    SetDeviceMode(DeviceStatus.AppMode, DataMode);
end;

function TKeyboardDriver.ReadDeviceModel: Integer;
begin
  Result := GetProgramInfo.Model;
end;

function TKeyboardDriver.GetDeviceVersion: Word;
var
  DeviceInfo: TDeviceInfo;
begin
  DeviceInfo := GetProgramInfo;
  Result := (DeviceInfo.MajorVersion shl 8) + DeviceInfo.MinorVersion;
end;

procedure TKeyboardDriver.SetIndicators(Value: Byte);
begin
  Device.SetIndicators(Value);
end;

function TKeyboardDriver.GetIndicators: Byte;
begin
  Result := Device.GetIndicators;
end;

function TKeyboardDriver.GetPacketSize: Integer;
begin
  Result := DevicePacketSize;
end;

function TKeyboardDriver.GetPageSize: Integer;
begin
  Result := DevicePageSize;
end;

function TKeyboardDriver.GetResetDelay: Integer;
begin
  Result := FResetDelay;
end;

procedure TKeyboardDriver.SetResetDelay(const Value: Integer);
begin
  FResetDelay := Value;
end;

procedure TKeyboardDriver.SetDevice(const Value: IKeyboardDevice);
begin
  FDevice := Value;
end;

function TKeyboardDriver.GetWriteModeCount: Integer;
begin
  Result := FWriteModeCount;
end;

function TKeyboardDriver.GetWriteModeTimeout: Integer;
begin
  Result := FWriteModeTimeout;
end;

procedure TKeyboardDriver.SetWriteModeCount(const Value: Integer);
begin
  FWriteModeCount := Value;
end;

procedure TKeyboardDriver.SetWriteModeTimeout(const Value: Integer);
begin
  FWriteModeTimeout := Value;
end;

function TKeyboardDriver.GetMaxDeviceErrors: Integer;
begin
  Result := FMaxDeviceErrors;
end;

function TKeyboardDriver.GetMaxFrameErrors: Integer;
begin
  Result := FMaxFrameErrors;
end;

procedure TKeyboardDriver.SetMaxDeviceErrors(const Value: Integer);
begin
  FMaxDeviceErrors := Value;
end;

procedure TKeyboardDriver.SetMaxFrameErrors(const Value: Integer);
begin
  FMaxFrameErrors := Value;
end;

end.


