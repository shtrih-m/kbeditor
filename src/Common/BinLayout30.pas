unit BinLayout30;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // This
  LayoutFormat, BinStream, KBLayout, Utils, Keyboard, GridType, LogFile;

type
  { TBinLayout30 }

  TBinLayout30 = class(TBinLayoutFormat)
  private
    FStream: TBinStream;
    FKeyboard: TKeyboard;

    function GetDefaultKeySFB: Byte;
    function SFBToKeyType(SFB: Integer): TKeyType;
    function GetHeaderSize(Layout: TKBLayout): Integer;
    function GetIButtonKeySFB(IButtonKey: TIButtonKey): Byte;
    function GetIButtonSFB(IButton: TIButton): Byte;
    function GetScrollSheelSFB(ScrollWheel: TScrollWheel): Byte;
    procedure SaveWheelItem(WheelItem: TWheelItem);
    procedure LoadWheelItem(WheelItem: TWheelItem; IsRawData: Boolean);
    procedure UpdateMasterKeys(Layout: TKBLayout);
  public
    constructor Create(AOwner: TKBLayoutFormats); override;
    destructor Destroy; override;

    procedure SaveMSR(MSR: TMSR);
    procedure LoadMSR(MSR: TMSR);
    procedure SaveKey(Key: TKey);
    procedure LoadKey(Key: TKey);
    procedure SaveKeys(Keys: TKeys);
    procedure LoadKeys(Keys: TKeys);
    procedure LoadNotes(Notes: TNotes);
    procedure SaveNotes(Notes: TNotes);
    procedure SaveLayer(Layer: TLayer);
    procedure LoadLayer(Layer: TLayer);
    procedure SaveLayout(Layout: TKBLayout);
    procedure LoadLayout(Layout: TKBLayout);
    procedure SaveGroups(Groups: TKeyGroups);
    procedure LoadGroups(Groups: TKeyGroups);
    procedure SaveCodes(Codes: TScanCodes);
    procedure SaveKeyLock(KeyLock: TKeyLock);
    procedure LoadKeyLock(KeyLock: TKeyLock);
    procedure LoadCodes(Codes: TScanCodes; IsRawData: Boolean);
    procedure SaveUserData(Layout: TKBLayout);
    procedure LoadUserData(Layout: TKBLayout);
    procedure SaveIButton(IButton: TIButton);
    procedure LoadIButton(IButton: TIButton);
    procedure SaveIButtonKeys(IButton: TIButton);
    procedure LoadIButtonKeys(IButton: TIButton);
    procedure SaveIButtonKey(IButtonKey: TIButtonKey);
    procedure LoadIButtonKey(IButtonKey: TIButtonKey);
    procedure SaveScrollWheel(ScrollWheel: TScrollWheel);
    procedure LoadScrollWheel(ScrollWheel: TScrollWheel);
    procedure SaveLayerHeader(Layer: TLayer; KeyCount: Integer);
    procedure LoadLayerHeader(Layer: TLayer; KeyCount: Integer);
    function GetFilter: string; override;
    function GetMinVersion: Word; override;
    function GetMaxVersion: Word; override;
    procedure SaveToStream(Layout: TKBLayout; AStream: TStream); override;
    procedure LoadFromStream(Layout: TKBLayout; AStream: TStream); override;

    property Stream: TBinStream read FStream;
    property Keyboard: TKeyboard read FKeyboard write FKeyboard;
  end;

implementation

resourcestring
  MsgBinLayout30 = 'KB-Editor layout (program 3.0) (*.bin)|*.bin';

{ TBinLayout30 }

constructor TBinLayout30.Create(AOwner: TKBLayoutFormats);
begin
  inherited Create(AOwner);
  FStream := TBinStream.Create;
end;

destructor TBinLayout30.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

procedure TBinLayout30.SaveCodes(Codes: TScanCodes);
var
  Data: string;
begin
  Logger.Debug('TBinLayout30.SaveCodes');
  Data := Codes.GetBinaryData;
  Stream.WriteByte(Length(Data));
  Stream.WriteString(Data);
end;

{ Raw data }

function TBinLayout30.GetDefaultKeySFB: Byte;
begin
  Result := 0;
  SetBit(Result, 6);
end;

{****************************************************************************}
{
{    Saving key
{
{    Key        - key to write
{    Stream     - Layer data
{
{****************************************************************************}

procedure TBinLayout30.SaveKey(Key: TKey);

  function GetLayerNumber(Key: TKey): Integer;
  begin
    Result := 0;
    case Key.KeyType of

      ktGoUp:
      begin
        Result := Key.LayerIndex + 1;
        if Result > 3 then Result := 0;
      end;
      ktGoDown:
      begin
        Result := Key.LayerIndex - 1;
        if Result < 0 then Result := 3;
      end;
      ktGo1: Result := 0;
      ktGo2: Result := 1;
      ktGo3: Result := 2;
      ktGo4: Result := 3;
      ktTemp1: Result := 0;
      ktTemp2: Result := 1;
      ktTemp3: Result := 2;
      ktTemp4: Result := 3;
    end;
  end;

  function GetSFB(Key: TKey): Byte;
  begin
    Result := GetDefaultKeySFB;
    { Layer number }
    Result := Result + (GetLayerNumber(Key) shl 1);
    { Layer change }
    if Key.KeyType <> ktMacros then
      Result := Result or 1;
    { Temporal layer change }
    if Key.KeyType in [ktTemp1, ktTemp2, ktTemp3, ktTemp4] then
      Result := Result or $8;
    { Repeat }
    if Key.RepeatKey then SetBit(Result, 4);
  end;

var
  SFB: Byte;
begin
  Logger.Debug('TBinLayout30.SaveKey');

  if Key.KeyType = ktNone then
  begin
    Key.Address := $FFFF;
  end else
  begin
    Key.Address := Stream.Position;
    // SFB
    SFB := GetSFB(Key);
    Stream.WriteByte(SFB);

    if Key.KeyType = ktMacros then
    begin
      // Press codes
      SaveCodes(Key.PressCodes);
      // Release codes
      SaveCodes(Key.ReleaseCodes);
    end else
    begin
      Stream.WriteWord(0);
    end;
    // Sound
    SaveNotes(Key.Notes);
  end;
end;

procedure TBinLayout30.LoadKey(Key: TKey);
var
  SFB: Byte;
  IsRawData: Boolean;
begin
  Logger.Debug('TBinLayout30.LoadKey');

  if Key.Address <> $FFFF then
  begin
    Stream.Position := Key.Address;
    // FSB
    SFB := Stream.ReadByte;
    Key.RepeatKey := TestBit(SFB, 4);
    Key.KeyType := SFBToKeyType(SFB);
    IsRawData := TestBit(SFB, 6);
    // Press codes
    LoadCodes(Key.PressCodes, IsRawData);
    // Release codes
    LoadCodes(Key.ReleaseCodes, IsRawData);
    // Notes
    LoadNotes(Key.Notes);
  end else
  begin
    Key.KeyType := ktNone;
  end;
end;


{****************************************************************************}
{
{       Saving MSR parameters
{
{       MSR     - Magnetic Stripe Reader
{       Stream  - Keys data
{
{****************************************************************************}

procedure TBinLayout30.SaveMSR(MSR: TMSR);

  function GetSFB(MSR: TMSR): Byte;
  begin
    Result := GetDefaultKeySFB;
    if MSR.Tracks[0].Enabled then SetBit(Result, 0);
    if MSR.Tracks[1].Enabled then SetBit(Result, 1);
    if MSR.Tracks[2].Enabled then SetBit(Result, 2);
    if MSR.LockOnErr then SetBit(Result, 4);
    if MSR.SendEnter then SetBit(Result, 5);
    if MSR.LightIndication then SetBit(Result, 7);
  end;

  procedure SaveTrack(Track: TMSRTrack; TrackExists: Boolean);
  begin
    if TrackExists then
    begin
      SaveCodes(Track.Prefix);
      SaveCodes(Track.Suffix);
    end;
  end;

var
  SFB: Byte;
begin
  Logger.Debug('TBinLayout30.SaveMSR');

  if Keyboard.HasMSR then
  begin
    MSR.Address := Stream.Position;
    // SFB
    SFB := GetSFB(MSR);
    Stream.WriteByte(SFB);
    SaveTrack(MSR.Tracks[0], Keyboard.HasMSRTrack1);
    SaveTrack(MSR.Tracks[1], Keyboard.HasMSRTrack2);
    SaveTrack(MSR.Tracks[2], Keyboard.HasMSRTrack3);
    // Notes
    Stream.WriteString(NotesToStr(MSR.Notes));
  end else
  begin
    MSR.Address := $FFFF;
  end;
end;

procedure TBinLayout30.SaveKeys(Keys: TKeys);
var
  i: Integer;
  Key: TKey;
begin
  Logger.Debug('TBinLayout30.SaveKeys');

  // Keys
  for i := 0 to Keys.Count-1 do
  begin
    SaveKey(Keys[i]);
  end;
  // Group keys
  for i := 0 to Keys.Count-1 do
  begin
    Key := Keys[i];
    if Key.MasterKey <> nil then
      Key.Address := Key.MasterKey.Address;
  end;
end;

function TBinLayout30.GetIButtonSFB(IButton: TIButton): Byte;
begin
  Result := 0;
  if IButton.SendCode then SetBit(Result, 5);
  SetBit(Result, 6); // always
end;

function IButtonKeyTypeToInt(Value: TIButtonKeyType): Byte;
begin
  case Value of
    ctGo1       : Result := 1;
    ctGo2       : Result := 3;
    ctGo3       : Result := 5;
    ctGo4       : Result := 7;
  else
    Result := 0;
  end;
end;

function IntToIButtonKeyType(Value: Byte): TIButtonKeyType;
begin
  case Value of
    1: Result := ctGo1;
    3: Result := ctGo2;
    5: Result := ctGo3;
    7: Result := ctGo4;
  else
    Result := ctNone;
  end;
end;

function TBinLayout30.GetIButtonKeySFB(IButtonKey: TIButtonKey): Byte;
begin
  Result := IButtonKeyTypeToInt(IButtonKey.CodeType);
  SetBit(Result, 6);
end;

// Key data

procedure TBinLayout30.SaveIButtonKey(IButtonKey: TIButtonKey);
var
  SFB: Integer;
begin
  Logger.Debug('TBinLayout30.SaveIButtonKey');
  SFB := GetIButtonKeySFB(IButtonKey);
  Stream.WriteByte(SFB);
  SaveCodes(IButtonKey.Codes);
  SaveNotes(IButtonKey.Notes);
end;

procedure TBinLayout30.LoadIButtonKey(IButtonKey: TIButtonKey);
var
  SFB: Integer;
begin
  Logger.Debug('TBinLayout30.LoadIButtonKey');
  SFB := Stream.ReadByte;
  IButtonKey.CodeType := IntToIButtonKeyType(SFB and $07);
  LoadCodes(IButtonKey.Codes, TestBit(SFB, 6));
  LoadNotes(IButtonKey.Notes);
end;

// IButton

procedure TBinLayout30.SaveIButtonKeys(IButton: TIButton);
var
  i: Integer;
  IButtonKey: TIButtonKey;
begin
  Logger.Debug('TBinLayout30.SaveIButtonKeys');
  Stream.WriteByte(IButton.RegKeys.Count);
  // Registered keys
  for i := 0 to IButton.RegKeys.Count-1 do
  begin
    IButtonKey := IButton.RegKeys[i];
    IButtonKey.Address := Stream.Position;
    Stream.WriteWord(0);
    // Key number length
    Stream.WriteByte(Length(IButtonKey.Number));
    Stream.WriteString(IButtonKey.Number);
  end;
  // Unregistered key
  IButton.DefKey.Address := Stream.Position;
  Stream.WriteWord(0);
  // IButton keys data
  for i := 0 to IButton.RegKeys.Count-1 do
  begin
    IButtonKey := IButton.RegKeys[i];
    Stream.Position := IButtonKey.Address;
    Stream.WriteWord(Stream.Size);
    Stream.Position := Stream.Size;
    SaveIButtonKey(IButtonKey);
  end;
  // Unregistered key
  IButtonKey := IButton.DefKey;
  Stream.Position := IButtonKey.Address;
  Stream.WriteWord(Stream.Size);
  Stream.Position := Stream.Size;
  SaveIButtonKey(IButtonKey);
end;

procedure TBinLayout30.LoadIButtonKeys(IButton: TIButton);
var
  i: Integer;
  Count: Integer;
  DataPos: Integer;
  IButtonKey: TIButtonKey;
begin
  Logger.Debug('TBinLayout30.LoadIButtonKeys');
  IButton.RegKeys.Clear;
  Count := Stream.ReadByte;
  DataPos := Stream.Position;
  for i := 0 to Count-1 do
  begin
    IButtonKey := IButton.RegKeys.Add;
    Stream.Position := DataPos;
    // IButton key data
    Stream.Position := Stream.ReadWord;
    LoadIButtonKey(IButtonKey);
    // IButton key data length
    Stream.Position := DataPos + 2;
    IButtonKey.Number := Stream.ReadString(Stream.ReadByte);
    DataPos := Stream.Position;
  end;
  Stream.Position := Stream.ReadWord;
  LoadIButtonKey(IButton.DefKey);
end;

procedure TBinLayout30.LoadIButton(IButton: TIButton);
var
  SFB: Integer;
  IsRawData: Boolean;
begin
  Logger.Debug('TBinLayout30.LoadIButton');
  if IButton.Address <> $FFFF then
  begin
    Stream.Position := IButton.Address;
    // SFB
    SFB := Stream.ReadByte;
    IButton.SendCode := TestBit(SFB, 5);
    IsRawData := TestBit(SFB, 6);
    // Scancodes
    if IButton.SendCode then
    begin
      LoadCodes(IButton.Prefix, IsRawData);
      LoadCodes(IButton.Suffix, IsRawData);
      LoadNotes(IButton.Notes);
    end else
    begin
      LoadIButtonKeys(IButton);
    end;
  end;
end;

procedure TBinLayout30.SaveIButton(IButton: TIButton);
begin
  Logger.Debug('TBinLayout30.SaveIButton');
  IButton.Address := Stream.Position;
  Stream.WriteByte(GetIButtonSFB(IButton));
  if IButton.SendCode then
  begin
    SaveCodes(IButton.Prefix);
    SaveCodes(IButton.Suffix);
    SaveNotes(IButton.Notes);
  end else
  begin
    SaveIButtonKeys(IButton);
  end;
end;

(******************************************************************************

  Scroll wheel parameters

  SFB - flags byte

  Bit values:
  0	- reserved
  1,2	- reserved
  3	- reserved
  4 	- reserved
  5	- reserved
  6	- send make and brake codes
  7 	- reserved

******************************************************************************)

function TBinLayout30.GetScrollSheelSFB(ScrollWheel: TScrollWheel): Byte;
begin
  Result := 0;
  SetBit(Result, 6);
end;

procedure TBinLayout30.SaveWheelItem(WheelItem: TWheelItem);
begin
  Logger.Debug('TBinLayout30.SaveWheelItem');
  SaveCodes(WheelItem.Codes);
  SaveNotes(WheelItem.Notes);
end;

procedure TBinLayout30.LoadWheelItem(WheelItem: TWheelItem; IsRawData: Boolean);
begin
  Logger.Debug('TBinLayout30.LoadWheelItem');
  LoadCodes(WheelItem.Codes, IsRawData);
  LoadNotes(WheelItem.Notes);
end;

procedure TBinLayout30.SaveScrollWheel(ScrollWheel: TScrollWheel);
begin
  Logger.Debug('TBinLayout30.SaveScrollWheel');
  ScrollWheel.Address := Stream.Position;
  Stream.WriteByte(GetScrollSheelSFB(ScrollWheel));
  SaveWheelItem(ScrollWheel.ScrollUp);
  SaveWheelItem(ScrollWheel.ScrollDown);
  SaveWheelItem(ScrollWheel.SingleClick);
  SaveWheelItem(ScrollWheel.DoubleClick);
end;

procedure TBinLayout30.LoadScrollWheel(ScrollWheel: TScrollWheel);
var
  SFB: Byte;
  IsRawData: Boolean;
begin
  Logger.Debug('TBinLayout30.LoadScrollWheel');
  if ScrollWheel.Address <> $FFFF then
  begin
    Stream.Position := ScrollWheel.Address;

    SFB := Stream.ReadByte;
    IsRawData := TestBit(SFB, 6);

    LoadWheelItem(ScrollWheel.ScrollUp, IsRawData);
    LoadWheelItem(ScrollWheel.ScrollDown, IsRawData);
    LoadWheelItem(ScrollWheel.SingleClick, IsRawData);
    LoadWheelItem(ScrollWheel.DoubleClick, IsRawData);
  end;
end;


{****************************************************************************}
{
{    Write layer
{
{    Layer      - layer to write
{    AddrTbl    - layer data
{    DataTbl    - keys data
{
{****************************************************************************}

procedure TBinLayout30.SaveLayer(Layer: TLayer);
var
  i: Integer;
begin
  Logger.Debug('TBinLayout30.SaveLayer');

  // update LayerIndex
  for i := 0 to Layer.Keys.Count-1 do
    Layer.Keys[i].LayerIndex := Layer.Index;
  // keys
  SaveKeys(Layer.Keys);
  // offset to end of keys

  // MSR
  SaveMSR(Layer.MSR);
  // KeyLock
  SaveKeyLock(Layer.KeyLock);
  // IButton
  SaveIButton(Layer.IButton);
  // ScrollWheel
  SaveScrollWheel(Layer.ScrollWheel);
end;

{ Read scancodes }

procedure TBinLayout30.LoadCodes(Codes: TScanCodes; IsRawData: Boolean);
var
  i: Integer;
  Count: Integer;
  ScanCode: TScanCode;
begin
  Logger.Debug('TBinLayout30.LoadCodes');
  Codes.Clear;
  Count := Stream.ReadByte;
  if IsRawData then
  begin
    Codes.SetBinaryData(Stream.ReadString(Count));
  end else
  begin
    for i := 0 to Count-1 do
    begin
      Codes.AddCode(Stream.ReadWord);
    end;
    // Adding Break codes
    Count := Codes.Count;
    for i := 0 to Count-1 do
    begin
      if Codes[i].CodeType = ctMake then
      begin
        ScanCode := Codes.Add;
        ScanCode.Assign(Codes[i]);
        ScanCode.CodeType := ctBreak;
      end;
    end;
  end;
end;

{ Save notes }

procedure TBinLayout30.SaveNotes(Notes: TNotes);
begin
  Logger.Debug('TBinLayout30.SaveNotes');
  Stream.WriteString(NotesToStr(Notes));
end;

{ Reading notes }

procedure TBinLayout30.LoadNotes(Notes: TNotes);
var
  i: Integer;
  Count: Byte;
  Note: TNote;
begin
  Logger.Debug('TBinLayout30.LoadNotes');
  Notes.Clear;
  Count := Stream.ReadByte;
  for i := 0 to Count-1 do
  begin
    Note := Notes.Add;
    // Note
    Note.Note := Stream.ReadByte;
    // Note duration
    Note.Interval := Stream.ReadByte;
    // Note volume
    Note.Volume := Stream.ReadByte;
  end;
end;

{ Load MSR parameters }

procedure TBinLayout30.LoadMSR(MSR: TMSR);

  procedure LoadTrack(Track: TMSRTrack; IsRawData: Boolean);
  begin
    LoadCodes(Track.Prefix, IsRawData);
    LoadCodes(Track.Suffix, IsRawData);
  end;

var
  SFB: Byte;
  IsRawData: Boolean;
begin
  Logger.Debug('TBinLayout30.LoadMSR');

  if MSR.Address <> $FFFF then
  begin
    Stream.Position := MSR.Address;

    MSR.Clear;
    // SFB
    SFB := Stream.ReadByte;

    MSR.Tracks[0].Enabled := TestBit(SFB, 0);
    MSR.Tracks[1].Enabled := TestBit(SFB, 1);
    MSR.Tracks[2].Enabled := TestBit(SFB, 2);
    MSR.LockOnErr := TestBit(SFB, 4);
    MSR.SendEnter := TestBit(SFB, 5);
    IsRawData := TestBit(SFB, 6);
    MSR.LightIndication := TestBit(SFB, 7);
    // Tracks
    if Keyboard.HasMSRTrack1 then LoadTrack(MSR.Tracks[0], IsRawData);
    if Keyboard.HasMSRTrack2 then LoadTrack(MSR.Tracks[1], IsRawData);
    if Keyboard.HasMSRTrack3 then LoadTrack(MSR.Tracks[2], IsRawData);
    // Notes
    LoadNotes(MSR.Notes);
  end;
end;

{ Get key type from FSB byte }

function TBinLayout30.SFBToKeyType(SFB: Integer): TKeyType;
var
  TempKey: Boolean;           // temp layer change key
  ChangeLayer: Boolean;       // layer change key
  LayerNumber: Integer;       // layer number
begin
  Logger.Debug('TBinLayout30.SFBToKeyType');

  TempKey := TestBit(SFB, 3);
  ChangeLayer := TestBit(SFB, 0);
  LayerNumber := (SFB shr 1)and 3;

  if ChangeLayer then
  begin
    if TempKey then
    begin
      case LayerNumber of
        0: Result := ktTemp1;
        1: Result := ktTemp2;
        2: Result := ktTemp3;
        3: Result := ktTemp4;
      else
        Result := ktTemp1;
      end;
    end else
    begin
      case LayerNumber of
        0: Result := ktGo1;
        1: Result := ktGo2;
        2: Result := ktGo3;
        3: Result := ktGo4;
      else
        Result := ktGo1;
      end;
    end;
  end else
  begin
    Result := ktMacros;
  end;
end;

procedure TBinLayout30.LoadKeys(Keys: TKeys);
var
  i: Integer;
begin
  Logger.Debug('TBinLayout30.LoadKeys');
  for i := 0 to Keys.Count-1 do
    LoadKey(Keys[i]);
end;

procedure TBinLayout30.LoadLayer(Layer: TLayer);
begin
  Logger.Debug('TBinLayout30.LoadLayer');
  LoadKeys(Layer.Keys);
  LoadMSR(Layer.MSR);
  LoadKeyLock(Layer.KeyLock);
  LoadIButton(Layer.IButton);
  LoadScrollWheel(Layer.ScrollWheel);
end;

procedure TBinLayout30.SaveUserData(Layout: TKBLayout);
var
  DataSize: DWORD;
  CheckSumm: Word;
begin
  Logger.Debug('TBinLayout30.SaveUserData');
  DataSize := Stream.Size;
  Stream.Position := 0;
  Stream.WriteWord(DataSize);
  Stream.Position := Stream.Size;
  // Software version
  Stream.WriteWord(Layout.DeviceVersion);
  // Layout CRC
  CheckSumm := CheckSummCalculate(Stream);
  Stream.WriteWord(CheckSumm);
  // Layout size
  Stream.WriteWord(0);
  // Layout version
  Stream.WriteWord(Layout.FileVersion);
  // Groups
  SaveGroups(Layout.KeyGroups);
  // KeyboardID
  Stream.WriteByte(Layout.KeyboardID);
  // Layout size
  Stream.Position := DataSize + 4;
  Stream.WriteWord(Stream.Size);
end;

procedure TBinLayout30.LoadUserData(Layout: TKBLayout);
var
  KeyboardID: Integer;
  Keyboard: TKeyboard;
  Selection: TGridRect;
begin
  Logger.Debug('TBinLayout30.LoadUserData');
  Stream.Position := 0;
  Stream.Position := Stream.ReadWord;

  Layout.DeviceVersion := Stream.ReadWord;
  Stream.ReadWord;
  Stream.ReadWord;
  Layout.FileVersion := Stream.ReadWord;

  LoadGroups(Layout.KeyGroups);
  KeyboardID := Stream.ReadByte;
  Keyboard := Keyboards.ItemByID(KeyboardID);
  Layout.Keyboard := Keyboard;

  Selection.Top := 0;
  Selection.Left := 0;
  Selection.Right := 0;
  Selection.Bottom := 0;
  Layout.Selection := Selection;
end;

procedure TBinLayout30.LoadFromStream(Layout: TKBLayout; AStream: TStream);
begin
  Logger.Debug('TBinLayout30.LoadFromStream');
  FKeyboard := Layout.Keyboard;
  AStream.Position := 0;
  Stream.LoadFromStream(AStream);
  Stream.Position := 0;
  LoadLayout(Layout);
end;

procedure TBinLayout30.SaveToStream(Layout: TKBLayout; AStream: TStream);
begin
  Logger.Debug('TBinLayout30.SaveToStream');

  FKeyboard := Layout.Keyboard;
  SaveLayout(Layout);
  Stream.SaveToStream(AStream);
end;

function TBinLayout30.GetHeaderSize(Layout: TKBLayout): Integer;
begin
  Result := 2*(1 + Layout.Layers.Count + Layout.Layers.Count*(Layout.KeyCount + 4));
end;

procedure TBinLayout30.SaveLayerHeader(Layer: TLayer; KeyCount: Integer);
var
  Key: TKey;
  i: Integer;
begin
  Logger.Debug('TBinLayout30.SaveLayerHeader');
  // write keys by numbers
  for i := 1 to KeyCount do
  begin
    Key := Layer.Keys.ItemByNumber(i);
    if Key <> nil then
      Stream.WriteWord(Key.Address)
    else
      Stream.WriteWord($FFFF);
  end;
  Stream.WriteWord(Layer.MSR.Address);
  Stream.WriteWord(Layer.KeyLock.Address);
  Stream.WriteWord(Layer.IButton.Address);
  Stream.WriteWord(Layer.ScrollWheel.Address);
end;

procedure TBinLayout30.LoadLayerHeader(Layer: TLayer; KeyCount: Integer);
var
  Key: TKey;
  i: Integer;
  Address: Word;
begin
  Logger.Debug('TBinLayout30.LoadLayerHeader');
  for i := 1 to KeyCount do
  begin
    Address := Stream.ReadWord;
    Key := Layer.Keys.ItemByNumber(i);
    if Key <> nil then Key.Address := Address;
  end;
  Layer.MSR.Address := Stream.ReadWord;
  Layer.KeyLock.Address := Stream.ReadWord;
  Layer.IButton.Address := Stream.ReadWord;
  Layer.ScrollWheel.Address := Stream.ReadWord;
end;

procedure TBinLayout30.UpdateMasterKeys(Layout: TKBLayout);

  function ValidKey(Key : TKey): Boolean;
  begin
    Result := Key <> nil;
    if Result then
      Result := Key.KeyType <> ktNone;
  end;

var
  Key: TKey;
  Keys: TKeys;
  i, j: Integer;
  KeyGroup: TKeyGroup;
begin
  Logger.Debug('TBinLayout30.UpdateMasterKeys');
  for i := 0 to Layout.Layers.Count-1 do
  begin
    Keys := Layout.Layers[i].Keys;
    for j := 0 to Keys.Count-1 do
    begin
      Key := Keys[j];
      KeyGroup := Layout.KeyGroups.GetGroup(Key.Col, Key.Row);
      if KeyGroup <> nil then
      begin
        Key.MasterKey := Keys.FindItem(KeyGroup.Left, KeyGroup.Top);
        if Key = Key.MasterKey then Key.MasterKey := nil;
        if not ValidKey(Key.MasterKey) then Key.MasterKey := nil;
      end else
      begin
        Key.MasterKey := nil;
      end;
    end;
  end;
end;

procedure TBinLayout30.LoadLayout(Layout: TKBLayout);
var
  i: Integer;
begin
  Logger.Debug('TBinLayout30.LoadLayout');
  UpdateMasterKeys(Layout);
  try
    LoadUserData(Layout);
    for i := 0 to Layout.Layers.Count-1 do
    begin
      Stream.Position := i*2 + 2;
      Stream.Position := Stream.ReadWord;
      LoadLayerHeader(Layout.Layers[i], Layout.KeyCount);
      LoadLayer(Layout.Layers[i]);
    end;
  except
    on E: EStreamError do
    begin
      Logger.Error('LoadLayout: ' + E.Message);
      InvalidFileFormat(E.Message);
    end;
  end;
end;

procedure TBinLayout30.SaveLayout(Layout: TKBLayout);
var
  i: Integer;
  LayerSize: Word;
  LayerStart: Word;
  LayersStart: Word;
begin
  Logger.Debug('TBinLayout30.SaveLayout');
  Stream.Size := 0;
  UpdateMasterKeys(Layout);
  LayersStart := Layout.Layers.Count*2 + 2;
  LayerSize := (Layout.KeyCount + 4)*2;
  // Layers data
  Stream.Position := GetHeaderSize(Layout);
  for i := 0 to Layout.Layers.Count-1 do
  begin
    SaveLayer(Layout.Layers[i]);
  end;
  // Header
  Stream.Position := 2;
  for i := 0 to Layout.Layers.Count-1 do
  begin
    // Layer address
    LayerStart := LayersStart + i*LayerSize;
    Stream.Position := 2*(i+1);
    Stream.WriteWord(LayerStart);
  end;
  for i := 0 to Layout.Layers.Count-1 do
  begin
    // Layer address
    Stream.Position := LayersStart + i*LayerSize;
    SaveLayerHeader(Layout.Layers[i], Layout.KeyCount);
  end;
  SaveUserData(Layout);
end;

procedure TBinLayout30.LoadKeyLock(KeyLock: TKeyLock);

  function IntToPosType(Value: Integer): TPosType;
  begin
    if TestBit(Value, 0) then
    begin
      case (Value and $6) of
        0: Result := ptGo1;
        2: Result := ptGo2;
        4: Result := ptGo3;
        6: Result := ptGo4;
      else
        Result := ptGo1;
      end;
    end else
    begin
      Result := ptMacros;
    end;
  end;

  procedure DecodeSFB(SFB: Byte; Position: TKeyPosition);
  begin
    Position.PosType := IntToPosType(SFB);
    Position.LockEnabled := TestBit(SFB, 3);
    Position.NcrEmulation := TestBit(SFB, 4);
    Position.NixdorfEmulation := TestBit(SFB, 5);
  end;

var
  SFB: Byte;
  i: Integer;
  IsRawData: Boolean;
  Position: TKeyPosition;
begin
  Logger.Debug('TBinLayout30.LoadKeyLock');
  if KeyLock.Address <> $FFFF then
  begin
    Stream.Position := KeyLock.Address;

    for i := 0 to KeyLock.Count-1 do
    begin
      Position := KeyLock[i];
      SFB := Stream.ReadByte;
      IsRawData := TestBit(SFB, 6);
      DecodeSFB(SFB, Position);
      LoadCodes(Position.Codes, IsRawData);
      LoadNotes(Position.Notes);
    end;
  end;
end;

procedure TBinLayout30.SaveKeyLock(KeyLock: TKeyLock);

  function GetLayerNumber(PosType: TPosType): Byte;
  begin
    case PosType of
      ptGo1: Result := 0;
      ptGo2: Result := 1;
      ptGo3: Result := 2;
      ptGo4: Result := 3;
    else
      Result := 0;
    end;
  end;

  function GetSFB(Position: TKeyPosition): Byte;
  begin
    Result := GetDefaultKeySFB;
    { Layers number }
    Result := Result + (GetLayerNumber(Position.PosType) shl 1);
    { Change layer }
    if Position.PosType <> ptMacros then SetBit(Result, 0);
    { Lock enabled }
    if Position.LockEnabled then SetBit(Result, 3);
    { NCR emulation }
    if Position.NcrEmulation then SetBit(Result, 4);
    // Nixdorf emulation
    if Position.NixdorfEmulation then SetBit(Result, 5);
  end;

var
  i: Integer;
  Position: TKeyPosition;
begin
  Logger.Debug('TBinLayout30.SaveKeyLock');
  KeyLock.Address := Stream.Position;
  for i := 0 to KeyLock.Count-1 do
  begin
    Position := KeyLock[i];
    Stream.WriteByte(GetSFB(Position));
    if Position.PosType = ptMacros then
    begin
      SaveCodes(Position.Codes);
    end else
    begin
      // No codes
      Stream.WriteByte(0);
    end;
    SaveNotes(Position.Notes);
  end;
end;

procedure TBinLayout30.SaveGroups(Groups: TKeyGroups);
var
  i: Integer;
  Rect: TGridRect;
  Group: TKeyGroup;
begin
  Logger.Debug('TBinLayout30.SaveGroups');
  Stream.WriteByte(Groups.Count);
  for i := 0 to Groups.Count-1 do
  begin
    Group := Groups[i];
    Rect := Group.Rect;
    Stream.WriteByte(Rect.Left);
    Stream.WriteByte(Rect.Top);
    Stream.WriteByte(Rect.Right);
    Stream.WriteByte(Rect.Bottom);
  end;
end;

procedure TBinLayout30.LoadGroups(Groups: TKeyGroups);
var
  i: Integer;
  Count: Byte;
  Rect: TGridRect;
  Group: TKeyGroup;
begin
  Logger.Debug('TBinLayout30.LoadGroups');
  Groups.Clear;
  Count := Stream.ReadByte;
  for i := 0 to Count-1 do
  begin
    Group := Groups.Add;
    Rect.Left := Stream.ReadByte;
    Rect.Top := Stream.ReadByte;
    Rect.Right := Stream.ReadByte;
    Rect.Bottom := Stream.ReadByte;
    Group.Rect := Rect;
  end;
end;

function TBinLayout30.GetMinVersion: Word;
begin
  Result := $20B;
end;

function TBinLayout30.GetMaxVersion: Word;
begin
  Result := $FFFF;
end;

function TBinLayout30.GetFilter: string;
begin
  Result := MsgBinLayout30;
end;

end.
