unit KeyboardManager;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Consts, Clipbrd,
  // This
  KBLayout, KeyboardDriver, MockKeyboardDriver, Utils, Keyboard, XmlLayout,
  AppSettings, LayoutFormat, EMFLayout, uProgress, xmlKeyboard,
  XmlCodeTables, GridType, xmlParser, BinLayout28, BinLayout13, BinLayout30,
  PS2Keyboard, KeyboardDevice, DeviceInfoSet, BinStream, FileUtils, LogFile,
  DebugUtils, AppMessages, KeyboardTypes;

resourcestring
  SaveBinFilter                 = 'KB-Editor layouts (*.bin)|*.bin';
  OpenBinFilter                 = 'KB-Editor layouts (*.bin)|*.bin|All files (*.*)|*.*';
  SavePrgFilter                 = 'Keyboard programs (*.prg)|*.prg';
  OpenPrgFilter                 = 'Keyboard programs (*.prg)|*.prg|All files (*.*)|*.*';
  OpenPrgTxtFilter              = 'Keyboard programs (*.prg)|*.prg;*.txt|All files (*.*)|*.*';
  MsgFileNotFound               = 'File %s not found';
  MsgOperationMemoryRead        = 'Reading memory';
  MsgReadingLayout              = 'Reading layout';
  MsgReadingLayoutToFile        = 'reading layout to file';
  MsgReadingReadFirmwareFile       = 'reading program to file';
  MsgMaxLayoutSize              = 'Layout size cannot exceed 65 kB!';
  MsgLayoutInvalidCodes         = 'Layout has invalid scancode sequence.'#13#10 +
    'Write layout?';
  MsgUpdatePrompt               =
    'Keyboard firmware need to be updated.'#13#10 +
    'Update it now?'#13#10#13#10;

  MsgNoBinaryFormats            = 'Binary format list is empty';
  MsgWritingLayout              = 'Writing layout';
  MsgClearMemory                = 'Clearing memory';
  MsgWritingProgramFromFile     = 'writing program from file';
  MsgWritingProgramFile         = 'Write program file';
  MsgWritingLayoutFile          = 'Write layout file';
  MsgWritingLayoutFromFile      = 'writing layout from file';
  MsgExecuting                  = 'Executing ';
  MsgInvalidFormatIndex         = 'Invalid format index';
  MsgKeyNotFound                = 'Button not found';
  MsgInvalidLayoutData          = 'Invalid layout format';
  MsgLayoutSizeIsTooLarge       =
    'Layout size is more than keyboard memory.' + CRLF +
    'Layout size, bytes: %d.' + CRLF +
    'Keyboard memory size, bytes: %d';
  MsgNoLayout = 'Keyboard has no layout';
  MsgInvalidModel = 'Layout for another model';

type
  { TKeyboardManager }

  TKeyboardManager = class(TComponent)
  private
    FOperation: string;
    FIsDriverLocked: Boolean;
    FInitialDir: string;
    FLayouts: TKBLayouts;
    FErrorMessage: string;
    FKeyboards: TKeyboards;             // Keyboard models
    FCodeTable: TCodeTable;             // Full scan code table
    FCodeTables: TCodeTables;           // Categorized scan code tables
    FErrorLayoutID: Integer;
    FDriver: IKeyboardDriver;
    FInitialFileName: string;
    FXmlFormat: TKBLayoutFormat;        // Default Xml format
    FBinFormat: TKBLayoutFormat;        // Default bin format
    FBinFormats: TKBLayoutFormats;
    FXmlFormats: TKBLayoutFormats;
    FSaveFormats: TKBLayoutFormats;
    FLoadFormats: TKBLayoutFormats;
    FDisableNotifications: Boolean;
    FDevice: IKeyboardDevice;           // Active device
    FDevices: TKeyboardDevices;
    FPS2Keyboard: TPS2Keyboard;
    FLoaderInfo: TDeviceInfo;
    FProgramInfo: TDeviceInfo;

    function ReadMemory: string;
    function GetDeviceID: Integer;
    function GetKeyboard: TKeyboard;
    function ReadFullMemory: string;
    function GetKeyboardPath: string;
    function GetStdCodesPath: string;
    function GetLayoutVersion(const Data: string): Integer;

    procedure LoadCodeTables;
    procedure PasteKeys(Src, Dst: TKBLayout);
    procedure UpdateLayout(Layout: TKBLayout);
    procedure SetDeviceID(const Value: Integer);
    procedure DoPasteSelection(Src, Dst: TKBLayout);
    procedure WriteMemory(const S, Operation: string);
    procedure SetInitialParams(const FileName: string);
    procedure SetDevice(const ADevice: IKeyboardDevice);
    procedure DoWriteMemoryFile(const FileName, Operation: string);
    procedure LoadKeyboards(const Path: string; RaiseOnError: Boolean);
    procedure CheckFormatIndex(Index: Integer; Formats: TKBLayoutFormats);
    procedure CopyLayerMultyKeys(Src, Dst: TKBLayout; ALayerIndex: Integer);

    property Devices: TKeyboardDevices read FDevices;
    property SaveFormats: TKBLayoutFormats read FSaveFormats;
    property LoadFormats: TKBLayoutFormats read FLoadFormats;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetDeviceName: string;
    function GetBinFilter: string;
    function GetOpenFilter: string;
    function GetSaveFilter: string;
    function CreateLayout: TKBLayout;
    function GetBinFormat(Version: Word): TKBLayoutFormat;
    function LayoutToText(Layout: TKBLayout): string;

    procedure LoadData;
    procedure SetDefaults;
    procedure ClearMemory;
    procedure UnlockDriver;
    procedure UpdateDevices;
    procedure CheckDriverBusy;
    procedure UpdateDocuments;
    procedure LoadKeyboardDefs;
    procedure CheckLayoutExists;
    procedure DisableNotifications;
    procedure PlayNotes(Notes: TNotes);
    procedure PlayText(const S: string);
    procedure ReadLayout(Layout: TKBLayout);
    procedure WriteLayout(Layout: TKBLayout);
    procedure GetDeviceNames(Names: TStrings);
    procedure PasteSelection(Layout: TKBLayout);
    procedure SetDeviceName(const Value: string);
    procedure CreateTestLayout(Layout: TKBLayout);
    procedure LockDriver(const Operation: string);
    procedure ReadMemoryFile(const FileName: string);
    procedure WriteMemoryFile(const FileName: string);
    procedure ReadFirmwareFile(const FileName: string);
    procedure WriteFirmwareFile(const FileName: string);
    procedure TextToLayout(Layout: TKBLayout; const Text: string);
    procedure SaveToFile(Layout: TKBLayout; FormatIndex: Integer; const FileName: string);
    procedure LoadFromFile(Layout: TKBLayout; FormatIndex: Integer; const FileName: string);

    property CodeTable: TCodeTable read FCodeTable;
    property CodeTables: TCodeTables read FCodeTables;
    property Layouts: TKBLayouts read FLayouts;
    property InitialDir: string read FInitialDir;
    property Driver: IKeyboardDriver read FDriver;
    property Keyboards: TKeyboards read FKeyboards;
    property ErrorMessage: string read FErrorMessage;
    property ErrorLayoutID: Integer read FErrorLayoutID;
    property BinFormat: TKBLayoutFormat read FBinFormat;
    property XmlFormat: TKBLayoutFormat read FXmlFormat;
    property InitialFileName: string read FInitialFileName;
    property BinFormats: TKBLayoutFormats read FBinFormats;
    property XmlFormats: TKBLayoutFormats read FXmlFormats;
    property DeviceID: Integer read GetDeviceID write SetDeviceID;
    property Device: IKeyboardDevice read FDevice write SetDevice;
    property PS2Keyboard: TPS2Keyboard read FPS2Keyboard;
  end;

procedure FreeManager;
function Manager: TKeyboardManager;

implementation

var
  FManager: TKeyboardManager = nil;

procedure FreeManager;
begin
  FManager.Free;
  FManager := nil;
end;
                       
function Manager: TKeyboardManager;
begin
  if FManager = nil then
  begin
    FManager := TKeyboardManager.Create(nil);
    FManager.LoadData;
  end;
  Result := FManager;
end;

procedure CheckFileName(const FileName: string);
begin
  if not FileExists(FileName) then
    raise Exception.CreateFmt(MsgFileNotFound, [FileName]);
end;

{ TKeyboardManager }

constructor TKeyboardManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Logger.Debug('TKeyboardManager.Create.0');
  FDevices := TKeyboardDevices.Create;
  FLayouts := TKBLayouts.Create(Self);
  FKeyboards := TKeyboards.Create(Self);
  FDriver := TKeyboardDriver.Create;

  FBinFormats := TKBLayoutFormats.Create;
  FXmlFormats := TKBLayoutFormats.Create;
  FSaveFormats := TKBLayoutFormats.Create;
  FLoadFormats := TKBLayoutFormats.Create;
  // loading
  FXmlFormat := TXmlLayout.Create(FLoadFormats);
  TBinLayout28.Create(FLoadFormats);
  FBinFormat := TBinLayout30.Create(FLoadFormats);
  // saving
  TXmlLayout.Create(FSaveFormats);
  TBinLayout28.Create(FSaveFormats);
  TBinLayout30.Create(FSaveFormats);
  // xml formats
  TXmlLayout.Create(FXmlFormats);
  TXmlLayout13.Create(FXmlFormats);
  // binary formats
  TBinLayout30.Create(FBinFormats);
  TBinLayout28.Create(FBinFormats);
  TBinLayout13.Create(FBinFormats);
  // sorting
  FCodeTables := TCodeTables.Create;
  FCodeTable := TCodeTable.Create;
  FInitialFileName := '';
  FInitialDir := GetModulePath;

  FPS2Keyboard := TPS2Keyboard.Create;
  Devices.Add(FPS2Keyboard);
  FDevice := FPS2Keyboard;
  Logger.Debug('TKeyboardManager.Create.1');
end;

destructor TKeyboardManager.Destroy;
begin
  Logger.Debug('TKeyboardManager.Destroy.0');
  FDisableNotifications := True;

  FDevices.Free;
  FKeyboards.Free;
  CodeTables.Free;
  CodeTable.Free;
  FBinFormats.Free;
  FXmlFormats.Free;
  FSaveFormats.Free;
  FLoadFormats.Free;
  inherited Destroy;
  Logger.Debug('TKeyboardManager.Destroy.1');
end;

function TKeyboardManager.CreateLayout: TKBLayout;
begin
  Logger.Debug('TKeyboardManager.CreateLayout');
  Result := TKBLayout.Create(Layouts);
  Result.Keyboard := GetKeyboard;
end;

procedure TKeyboardManager.DisableNotifications;
begin
  Logger.Debug('TKeyboardManager.DisableNotifications');
  FDisableNotifications := True;
end;

procedure TKeyboardManager.SetDefaults;
begin
  Logger.Debug('TKeyboardManager.SetDefaults');
  FCodeTables.SetDefaults;
  FCodeTable.LoadFromCodeTables(FCodeTables);
end;

function TKeyboardManager.GetStdCodesPath: string;
begin
  Logger.Debug('TKeyboardManager.GetStdCodesPath');
  Result := GetModulePath + 'Data\Keydefs\Keydefs.xml';
end;

procedure TKeyboardManager.LoadCodeTables;
var
  XmlCodeTables: TXmlCodeTables;
begin
  Logger.Debug('TKeyboardManager.LoadCodeTables');
  XmlCodeTables := TXmlCodeTables.Create;
  try
    XmlCodeTables.LoadFromFile(GetStdCodesPath, FCodeTables);
  except
    on E: Exception do
    begin
      Logger.Error('LoadCodeTables: ' + E.Message);
      FCodeTables.SetDefaults;
    end;
  end;
  XmlCodeTables.Free;
end;

procedure TKeyboardManager.LoadData;
begin
  Logger.Debug('TKeyboardManager.LoadData');

  LoadCodeTables;
  FCodeTable.LoadFromCodeTables(FCodeTables);
  LoadKeyboards(GetKeyboardPath, False);
end;

procedure TKeyboardManager.LoadKeyboardDefs;
begin
  Logger.Debug('TKeyboardManager.LoadKeyboardDefs');
  LoadKeyboards(GetKeyboardPath, True);
end;

function TKeyboardManager.GetKeyboardPath: string;
begin
  Logger.Debug('TKeyboardManager.GetKeyboardPath');
  Result := GetModulePath + 'Data\Keyboards';
end;

procedure TKeyboardManager.LoadKeyboards(const Path: string; RaiseOnError: Boolean);
var
  Reader: TxmlKeyboard;
begin
  Logger.Debug('TKeyboardManager.LoadKeyboards');
  Reader := TXmlKeyboard.Create;
  try
    try
      Reader.LoadKeyboards(Path, Keyboards);
    except
      on E: Exception do
      begin
        Logger.Error('SaveSettings: ' + E.Message);
        if RaiseOnError then raise;
      end;
    end;
  finally
    Reader.Free;
  end;
end;

// Reading device memory
function TKeyboardManager.ReadFullMemory: string;
var
  i: Integer;
  Count: Integer;               // Packet count
begin
  Logger.Debug('TKeyboardManager.ReadFullMemory');
  Result := '';
  Count := Driver.GetDeviceInfo.MemSize div Driver.PacketSize;
  Progress.Start(Count, Driver.PacketSize, MsgOperationMemoryRead);
  try
    for i := 0 to Count-1 do
    begin
      Result := Result + Driver.ReadMemory(i*Driver.PacketSize, Driver.PacketSize);
      Progress.Step(i+1, Driver.PacketSize);
    end;
  finally
    Progress.Stop;
  end;
end;

function TKeyboardManager.ReadMemory: string;
var
  i: Integer;
  MemSize: Word;
  Address: Word;
  Count: Integer;       // Packet count
begin
  Logger.Debug('TKeyboardManager.ReadMemory');
  Result := '';
  Address := Driver.ReadWord(0);
  MemSize := Driver.ReadWord(Address + 4);
  Count := Round(MemSize/Driver.PacketSize + 0.5);
  Progress.Start(Count, Driver.PacketSize, MsgReadingLayout);
  try
    for i := 0 to Count-1 do
    begin
      Address := i * Driver.PacketSize;
      Result := Result + Driver.ReadMemory(Address, Driver.PacketSize);
      Progress.Step(i+1, Driver.PacketSize);
    end;
    SetLength(Result, MemSize);
  finally
    Progress.Stop;
  end;
end;

// Reading layout to file
procedure TKeyboardManager.ReadMemoryFile(const FileName: string);
var
  Data: string;
begin
  Logger.Debug('TKeyboardManager.ReadMemoryFile');
  LockDriver(MsgReadingLayoutToFile);
  try
    SetInitialParams(FileName);
    Driver.SetDataMode(dmData);
    Data := ReadFullMemory;
    WriteFileData(FileName, Data);
  finally
    Driver.SetDataMode(dmData);
    UnlockDriver;
  end;
end;

// Reading program to file
procedure TKeyboardManager.ReadFirmwareFile(const FileName: string);
var
  Data: string;
begin
  Logger.Debug('TKeyboardManager.ReadFirmwareFile');
  LockDriver(MsgReadingReadFirmwareFile);
  try
    SetInitialParams(FileName);
    Driver.SetDataMode(dmProg);
    Data := ReadFullMemory;
    WriteFileData(FileName, Data);
  finally
    Driver.SetDataMode(dmData);
    UnlockDriver;
  end;
end;

// Before layout writing clear first page to disable all layout.
// So if one interrupts loading layout will be disabled
procedure TKeyboardManager.WriteMemory(const S, Operation: string);
var
  i: Integer;
  Data: string;         // Data to transfer
  Address: Word;
  Packet: string;       // Packet data
  PageCount: Integer;   // Page count
  FirstPage: string;
begin
  Logger.Debug('TKeyboardManager.WriteMemory');
  if Length(S) > 65*1024 then
    raise Exception.Create(MsgMaxLayoutSize);

  Data := S;
  PageCount := Round(Length(Data)/Driver.PageSize + 0.5);
  Progress.Start(PageCount, Driver.PageSize, Operation);
  FirstPage := Copy(Data, 1, Driver.PageSize);
  Data := StringOfChar(#0, Driver.PageSize) + Copy(Data, Driver.PageSize + 1, Length(Data));
  try
    for i := 0 to PageCount-1 do
    begin
      Address := Driver.PageSize * i + 1;
      Packet := Copy(Data, Address, Driver.PageSize);
      Driver.WritePage(Address, Packet);
      Progress.Step(i+1, Driver.PageSize);
    end;
    Driver.WritePage(0, FirstPage);
  finally
    Progress.Stop;
  end;
end;

// Checking keyboard model
// Finding format to save layout

function TKeyboardManager.GetBinFormat(Version: Word): TKBLayoutFormat;
var
  i: Integer;
begin
  Logger.Debug('TKeyboardManager.GetBinFormat', [Version]);
  if BinFormats.Count = 0 then
    raise Exception.Create(MsgNoBinaryFormats);

  Result := BinFormats[0];
  for i := 0 to BinFormats.Count-1 do
  begin
    Result := BinFormats[i];
    if Result.ValidFormat(Version) then Break;
  end;
end;

procedure TKeyboardManager.WriteLayout(Layout: TKBLayout);
var
  Data: string;
  DataLength: Integer;
  BinFormat: TKBLayoutFormat;
begin
  Logger.Debug('TKeyboardManager.WriteLayout');
  try
    UpdateLayout(Layout);
    // Saving data
    BinFormat := GetBinFormat(Layout.DeviceVersion);
    Data := BinFormat.SaveToText(Layout);
    // Check data lenghth
    DataLength := Length(Data);
    if DataLength > FProgramInfo.MemSize then
      raise Exception.CreateFmt(MsgLayoutSizeIsTooLarge, [
      DataLength, FProgramInfo.MemSize]);

    WriteMemory(Data, MsgWritingLayout);
  finally
    Driver.SetMode(amProg, dmData);
  end;
end;

function TKeyboardManager.GetLayoutVersion(const Data: string): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TKeyboardManager.GetLayoutVersion', [Data]);
  Stream := TBinStream.Create;
  try
    Stream.Write(Data[1], Length(Data));
    Stream.Position := 0;
    Stream.Position := Stream.ReadWord;
    Result := Stream.ReadWord; // Keyboard firmware version
  finally
    Stream.Free;
  end;
  Logger.Debug('TKeyboardManager.GetLayoutVersion', [Data], Result);
end;

procedure TKeyboardManager.CheckLayoutExists;
var
  Data: string;
begin
  Data := Driver.ReadMemory(0, Driver.PacketSize);
  if Data = StringOfChar(#0, Driver.PacketSize) then
    raise Exception.Create(MsgNoLayout);
end;

procedure TKeyboardManager.UpdateLayout(Layout: TKBLayout);
begin
  Logger.Debug('TKeyboardManager.UpdateLayout.0');

  Layout.KeyCount := Layout.Keyboard.KeyDefs.Count;

  FProgramInfo := Driver.GetProgramInfo;
  Layout.DeviceVersion := FProgramInfo.Version;

  FLoaderInfo := Driver.GetLoaderInfo;
  if FLoaderInfo.KeyCount <> 0 then
    Layout.KeyCount := FLoaderInfo.KeyCount;

  Logger.Debug('TKeyboardManager.UpdateLayout.1');
end;

procedure TKeyboardManager.ReadLayout(Layout: TKBLayout);
var
  Data: string;
  BinFormat: TKBLayoutFormat;
begin
  try
    Driver.SetMode(amProg, dmData);

    UpdateLayout(Layout);

    CheckLayoutExists;
    Data := ReadMemory;
    //Layout.KeyCount := Driver.GetLoaderInfo.KeyCount; { !!! }

    BinFormat := GetBinFormat(GetLayoutVersion(Data));
    BinFormat.LoadFromText(Layout, Data);
    Driver.SetMode(amProg, dmData);
  except
    on E: EReadError do
    begin
      raise Exception.Create(MsgInvalidLayoutData);
    end;
  end;
end;

{*****************************************************************************}
{
{  Clear device memory.
{  To clear device memory is enough to clear lyer table
{
{*****************************************************************************}

procedure TKeyboardManager.ClearMemory;
var
  i: Integer;
  Data: string;
  MaxAddress: Word;
begin
  FLoaderInfo := Driver.GetLoaderInfo;
  MaxAddress := FLoaderInfo.MemSize;
  for i := 0 to FLoaderInfo.LayerCount-1 do
    Data := Data + WordToStr(MaxAddress);
  WriteMemory(Data, MsgClearMemory);
end;

procedure TKeyboardManager.DoWriteMemoryFile(const FileName, Operation: string);
var
  Data: string;
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    if Stream.Size > 0 then
    begin
      SetLength(Data, Stream.Size);
      Stream.ReadBuffer(Data[1], Stream.Size);
      WriteMemory(Data, Operation);
    end;
  finally
    Stream.Free;
  end;
end;

procedure TKeyboardManager.WriteFirmwareFile(const FileName: string);
begin
  LockDriver(MsgWritingProgramFromFile);
  try
    CheckFileName(FileName);
    SetInitialParams(FileName);
    Driver.SetMode(amLoader, dmProg);
    DoWriteMemoryFile(FileName, MsgWritingProgramFile);
    Driver.SetMode(amProg, dmData);
  finally
    UnlockDriver;
  end;
end;

procedure TKeyboardManager.WriteMemoryFile(const FileName: string);
begin
  LockDriver(MsgWritingLayoutFromFile);
  try
    SetInitialParams(FileName);
    Driver.SetMode(amLoader, dmData);
    DoWriteMemoryFile(FileName, MsgWritingLayout);
    Driver.SetMode(amProg, dmData);
  finally
    UnlockDriver;
  end;
end;

procedure TKeyboardManager.CheckDriverBusy;
begin
  if FIsDriverLocked then
    raise Exception.Create(MsgExecuting + FOperation);
end;

procedure TKeyboardManager.LockDriver(const Operation: string);
begin
  CheckDriverBusy;
  FOperation := Operation;
  FIsDriverLocked := True;
end;

procedure TKeyboardManager.UnlockDriver;
begin
  FIsDriverLocked := False;
end;

procedure TKeyboardManager.PlayNotes(Notes: TNotes);

  function NotesToStr(Notes: TNotes): string;
  var
    i: Integer;
    Note: TNote;
  begin
    Result := '';
    for i := 0 to Notes.Count-1 do
    begin
      Note := Notes[i];
      Result := Result + Chr(Note.Note);     // Note
      Result := Result + Chr(Note.Interval); // Note duration
      Result := Result + Chr(Note.Volume);   // Note volume
    end;
  end;

var
  Data: string;
begin
  Data := NotesToStr(Notes);
  Driver.PlayNotes(Data);
end;

procedure TKeyboardManager.PlayText(const S: string);
var
  Notes: TNotes;
begin
  Notes := TNotes.Create(nil);
  try
    Notes.AsText := S;
    PlayNotes(Notes);
  finally
    Notes.Free;
  end;
end;

procedure TKeyboardManager.SaveToFile(Layout: TKBLayout; FormatIndex: Integer;
  const FileName: string);
begin
  SetInitialParams(FileName);
  CheckFormatIndex(FormatIndex, SaveFormats);
  SaveFormats[FormatIndex].SaveToFile(Layout, FileName);
end;

procedure TKeyboardManager.LoadFromFile(Layout: TKBLayout; FormatIndex: Integer;
  const FileName: string);
begin
  Layout.BeginUpdate;
  try
    SetInitialParams(FileName);
    CheckFormatIndex(FormatIndex, LoadFormats);
    LoadFormats[FormatIndex].LoadFromFile(Layout, FileName);
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyboardManager.CheckFormatIndex(Index: Integer; Formats: TKBLayoutFormats);
begin
  if (Index < 0)or(Index > Formats.Count) then
    raise Exception.Create(MsgInvalidFormatIndex);
end;

function TKeyboardManager.LayoutToText(Layout: TKBLayout): string;
begin
  Result := XmlFormat.SaveToText(Layout);
end;

procedure TKeyboardManager.TextToLayout(Layout: TKBLayout; const Text: string);
begin
  XmlFormat.LoadFromText(Layout, Text);
end;

function TKeyboardManager.GetBinFilter: string;
begin
  Result := BinFormats.Filter;
end;

function TKeyboardManager.GetOpenFilter: string;
begin
  Result := LoadFormats.Filter;
end;

function TKeyboardManager.GetSaveFilter: string;
begin
  Result := SaveFormats.Filter;
end;

procedure TKeyboardManager.SetInitialParams(const FileName: string);
begin
  FInitialDir := ExtractFilePath(FileName);
  FInitialFileName := FileName;
end;

function TKeyboardManager.GetDeviceName: string;
begin
  Result := Device.Name;
end;

function TKeyboardManager.GetKeyboard: TKeyboard;
begin
  Result := Keyboards.FindItemByID(Settings.KeyboardID);
  if Result = nil then
  begin
    if Keyboards.Count = 0 then
      raise Exception.Create(MsgNoKeyboardDefs);

    Result := Keyboards[0];
  end;
end;

procedure TKeyboardManager.CopyLayerMultyKeys(Src, Dst: TKBLayout; ALayerIndex: Integer);
var
  SrcKey: TKey;
  DstKey: TKey;
  SrcLayer: TLayer;
  DstLayer: TLayer;
  Col, Row: Integer;
begin
  for Col := Dst.Selection.Left to Dst.Selection.Right do
  for Row := Dst.Selection.Top to Dst.Selection.Bottom do
  begin
    SrcLayer := Src.Layers[ALayerIndex];
    DstLayer := Dst.Layers[ALayerIndex];
    SrcKey := SrcLayer.FindKey(
      Src.Selection.Left + Col - Dst.Selection.Left,
      Src.Selection.Top + Row - Dst.Selection.Top);
    DstKey := DstLayer.FindKey(Col, Row);

    if (SrcKey = nil)or(DstKey = nil) then
      raise Exception.Create(MsgKeyNotFound);

    DstKey.AssignKey(SrcKey)
  end;
end;

function GetMinSelection(R1, R2: TGridRect): TGridRect;
begin
  Result := R1;
  Result.Right := Min(R1.Right, R1.Left + R2.Right - R2.Left);
  Result.Bottom := Min(R1.Bottom, R1.Top + R2.Bottom - R2.Top);
end;

procedure TKeyboardManager.PasteKeys(Src, Dst: TKBLayout);
var
  i: Integer;
begin
  Dst.Selection := GetMinSelection(Dst.Selection, Src.Selection);
  for i := 0 to Src.Layers.Count-1 do
    CopyLayerMultyKeys(Src, Dst, i);
end;

procedure TKeyboardManager.DoPasteSelection(Src, Dst: TKBLayout);
begin
  Dst.BeginUpdate;
  try
    PasteKeys(Src, Dst);
    Dst.Modified;
  finally
    Dst.EndUpdate;
  end;
end;

procedure TKeyboardManager.PasteSelection(Layout: TKBLayout);
var
  Src: TKBLayout;
begin
  Src := CreateLayout;
  try
    TextToLayout(Src, Clipboard.AsText);
    DoPasteSelection(Src, Layout);
  finally
    Src.Free;
  end;
end;

// Creating test layout
// Text must be in format [123], where 123 - physical key number

procedure TKeyboardManager.CreateTestLayout(Layout: TKBLayout);
var
  Key: TKey;
  Keys: TKeys;
  Col: Integer;
  Row: Integer;
  KeyDef: TKeyDef;
  i, j, k: Integer;
  Keyboard: TKeyboard;
  str, KeyText: string;
  ScrollWheel: TScrollWheel;
begin
  Layout.BeginUpdate;
  try
    // Keyboard
    Col := 1;
    Row := 1;
    Keyboard := Layout.Keyboard;
    for i := 0 to Keyboard.KeyDefs.Count-1 do
    begin
      KeyDef := Keyboard.KeyDefs[i];
      KeyDef.Left := Col;
      KeyDef.Top := Row;
      KeyDef.LogicNumber := i + 1;
      Inc(Col);
      if Col > Keyboard.ColCount then
      begin
        Inc(Row);
        Col := 1;
      end;
    end;
    Layout.UpdateLayout;
    // Layout
    for i := 0 to Layout.Layers.Count-1 do
    begin
      Keys := Layout.Layers[i].Keys;
      for j := 1 to Keys.Count do
      begin
        Key := Keys[j-1];
        Key.KeyType := ktMacros;
        str := IntToStr(j);
        KeyText := '';
        for k := 1 to Length(str) do
        begin
          KeyText := KeyText + '+' + str[k] + ' ';
          KeyText := KeyText + '-' + str[k] + ' ';
        end;
        Key.PressCodes.AsText := '+[ -[ ' + KeyText + '+] -]';
      end;
      // ScrollWheel
      ScrollWheel := Layout.Layers[i].ScrollWheel;
      ScrollWheel.ScrollUp.Codes.SimpleText := '[Scrollup]';
      ScrollWheel.ScrollDown.Codes.SimpleText := '[Scrolldown]';
      ScrollWheel.SingleClick.Codes.SimpleText := '[Singleclick]';
      ScrollWheel.DoubleClick.Codes.SimpleText := '[Doubleclick]';
    end;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyboardManager.GetDeviceNames(Names: TStrings);
var
  s: string;
  i: Integer;
begin
  Names.Clear;
  for i := 0 to Devices.Count-1 do
  begin
    s := Format('%d. %s', [i+1, Devices[i].Name]);
    Names.AddObject(s, TObject(Devices[i].ID));
  end;
end;

// On device update we need to restore active device by unique name

procedure TKeyboardManager.UpdateDevices;
var
  UniqueName: string;
begin
  // save active device unique name
  UniqueName := Device.UniqueName;

  Devices.Clear;
  // By default PS/2 keyboard active
  FPS2Keyboard := TPS2Keyboard.Create;
  Devices.Add(FPS2Keyboard);
  FDevice := FPS2Keyboard;
  EnumHIDKeyboards(Devices);
  // restore active device
  SetDevice(Devices.ItemByUniqueName(UniqueName));
end;

procedure TKeyboardManager.SetDeviceName(const Value: string);
begin
  SetDevice(Devices.ItemByName(Value));
end;

procedure TKeyboardManager.SetDevice(const ADevice: IKeyboardDevice);
begin
  if ADevice <> nil then
  begin
    FDevice := ADevice;
    Driver.Device := ADevice;
    Settings.DeviceName := ADevice.Name;
  end;
end;

function TKeyboardManager.GetDeviceID: Integer;
begin
  Result := Device.ID;
end;

procedure TKeyboardManager.SetDeviceID(const Value: Integer);
begin
  SetDevice(Devices.ItemByID(Value));
end;

procedure TKeyboardManager.UpdateDocuments;
var
  i: Integer;
begin
  for i := 0 to Layouts.Count-1 do
    Layouts[i].Changed;
end;


end.
