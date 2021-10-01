unit BinLayout28;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Forms,
  // This
  LayoutFormat, BinStream, KBLayout, Utils, Keyboard, GridType,
  DebugUtils, LogFile;

type
  { TBinLayout28 }

  TBinLayout28 = class(TBinLayoutFormat)
  private
    FStream: TBinStream;
    FKeyboard: TKeyboard;

    function GetDefaultKeySFB: Byte;
    function SFBToKeyType(SFB: Integer): TKeyType;
    function GetHeaderSize(Layout: TKBLayout): Integer;

    procedure SetStreamPosition(Value: Integer);
    procedure UpdateMasterKeys(Layout: TKBLayout);
  public
    constructor Create(AOwner: TKBLayoutFormats); override;
    destructor Destroy; override;

    procedure SaveMSR(MSR: TMSR);
    procedure LoadMSR(MSR: TMSR);
    procedure LoadKey(Key: TKey);
    procedure LoadKeys(Keys: TKeys);
    procedure LoadNotes(Notes: TNotes);
    procedure SaveNotes(Notes: TNotes);
    procedure SaveLayer(Layer: TLayer);
    procedure LoadLayer(Layer: TLayer);
    procedure SaveKey(Key: TKey);
    procedure SaveKeys(Keys: TKeys);
    procedure SaveLayout(Layout: TKBLayout);
    procedure LoadLayout(Layout: TKBLayout);
    procedure SaveGroups(Groups: TKeyGroups);
    procedure LoadGroups(Groups: TKeyGroups);
    procedure SaveCodes(Codes: TScanCodes);
    procedure SaveKeyLock(KeyLock: TKeyLock);
    procedure LoadKeyLock(KeyLock: TKeyLock);
    procedure LoadCodes(Codes: TScanCodes; IsRawData: Boolean);
    procedure LoadLayerHeader(Layer: TLayer);
    procedure SaveUserData(Layout: TKBLayout);
    procedure LoadUserData(Layout: TKBLayout);
    procedure SaveLayerHeader(Layout: TKBLayout; Layer: TLayer);

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
  MsgBinLayout28 = 'KB-Editor layout (program 2.8) (*.bin)|*.bin';

{ TBinLayout28 }

constructor TBinLayout28.Create(AOwner: TKBLayoutFormats);
begin
  inherited Create(AOwner);
  FStream := TBinStream.Create;
end;

destructor TBinLayout28.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

function TBinLayout28.GetMinVersion: Word;
begin
  Result := $200;
end;

function TBinLayout28.GetMaxVersion: Word;
begin
  Result := $20A;
end;

function TBinLayout28.GetFilter: string;
begin
  Result := MsgBinLayout28;
end;

procedure TBinLayout28.SaveCodes(Codes: TScanCodes);
var
  Data: string;
begin
  Logger.Debug('TBinLayout28.SaveCodes', [Codes.AsText]);

  Data := Codes.GetBinaryData;
  Stream.WriteByte(Length(Data));
  Stream.WriteString(Data);
end;

{ Raw data }

function TBinLayout28.GetDefaultKeySFB: Byte;
begin
  Logger.Debug('TBinLayout28.GetDefaultKeySFB');

  Result := 0;
  SetBit(Result, 6);
end;

procedure TBinLayout28.SaveKey(Key: TKey);

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
    { Change layer key }
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
  Logger.Debug('TBinLayout28.SaveKey', [Key.Number, Key.Col, Key.Row]);
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
      Stream.WriteByte(0);
      Stream.WriteByte(0);
    end;
    // Notes
    SaveNotes(Key.Notes);
  end;
end;

procedure TBinLayout28.LoadKey(Key: TKey);
var
  SFB: Byte;
  IsRawData: Boolean;
begin
  Logger.Debug('TBinLayout28.LoadKey', [Key.Address]);
  if Key.Address <> $FFFF then
  begin
    SetStreamPosition(Key.Address);
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

procedure TBinLayout28.SaveMSR(MSR: TMSR);

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
  Logger.Debug('TBinLayout28.SaveMSR');
  if Keyboard.HasMSR then
  begin
    MSR.Address := Stream.Position;
    // SFB
    SFB := GetSFB(MSR);
    Stream.WriteByte(SFB);
    SaveTrack(MSR.Tracks[0], Keyboard.HasMSRTrack1);
    SaveTrack(MSR.Tracks[1], Keyboard.HasMSRTrack2);
    SaveTrack(MSR.Tracks[2], Keyboard.HasMSRTrack3);
    Stream.WriteString(NotesToStr(MSR.Notes));
  end else
  begin
    MSR.Address := $FFFF;
  end;
end;

procedure TBinLayout28.SaveKeys(Keys: TKeys);
var
  i: Integer;
  Key: TKey;
begin
  Logger.Debug('TBinLayout28.SaveKeys');

  // Real keys
  for i := 0 to Keys.Count-1 do
  begin
    Key := Keys[i];
    if Key.MasterKey = nil then
      SaveKey(Key);
  end;
  // Key group keys
  for i := 0 to Keys.Count-1 do
  begin
    Key := Keys[i];
    if Key.MasterKey <> nil then
      Key.Address := Key.MasterKey.Address;
  end;
end;

procedure TBinLayout28.SaveLayer(Layer: TLayer);
var
  i: Integer;
begin
  Logger.Debug('TBinLayout28.SaveLayer');

  // update LayerIndex
  for i := 0 to Layer.Keys.Count-1 do
    Layer.Keys[i].LayerIndex := Layer.Index;
  SaveKeys(Layer.Keys);
  SaveMSR(Layer.MSR);
  SaveKeyLock(Layer.KeyLock);
end;

procedure TBinLayout28.LoadCodes(Codes: TScanCodes; IsRawData: Boolean);
var
  i: Integer;
  Count: Integer;
  ScanCode: TScanCode;
begin
  Logger.Debug('TBinLayout28.LoadCodes');

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
    // Adding break codes
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

procedure TBinLayout28.SaveNotes(Notes: TNotes);
begin
  Logger.Debug('TBinLayout28.SaveNotes');
  Stream.WriteString(NotesToStr(Notes));
end;

procedure TBinLayout28.LoadNotes(Notes: TNotes);
var
  i: Integer;
  Count: Byte;
  Note: TNote;
begin
  Logger.Debug('TBinLayout28.LoadNotes');
  Notes.Clear;
  Count := Stream.ReadByte;
  for i := 0 to Count-1 do
  begin
    Note := Notes.Add;
    Note.Note := Stream.ReadByte;
    Note.Interval := Stream.ReadByte;
    Note.Volume := Stream.ReadByte;
  end;
end;

procedure TBinLayout28.LoadMSR(MSR: TMSR);

  procedure LoadTrack(Track: TMSRTrack; IsRawData: Boolean);
  begin
    LoadCodes(Track.Prefix, IsRawData);
    LoadCodes(Track.Suffix, IsRawData);
  end;

var
  SFB: Byte;
  IsRawData: Boolean;
begin
  Logger.Debug('TBinLayout28.LoadMSR');
  if MSR.Address <> $FFFF then
  begin
    SetStreamPosition(MSR.Address);

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
    if Keyboard.HasMSRTrack1 then LoadTrack(MSR.Tracks[0], IsRawData);
    if Keyboard.HasMSRTrack2 then LoadTrack(MSR.Tracks[1], IsRawData);
    if Keyboard.HasMSRTrack3 then LoadTrack(MSR.Tracks[2], IsRawData);
    LoadNotes(MSR.Notes);
  end;
end;

function TBinLayout28.SFBToKeyType(SFB: Integer): TKeyType;
var
  TempKey: Boolean;
  ChangeLayer: Boolean;
  LayerNumber: Integer;
begin
  Logger.Debug('TBinLayout28.SFBToKeyType');

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

procedure TBinLayout28.LoadKeys(Keys: TKeys);
var
  i: Integer;
begin
  Logger.Debug('TBinLayout28.LoadKeys');
  for i := 0 to Keys.Count-1 do
    LoadKey(Keys[i]);
end;

procedure TBinLayout28.LoadLayer(Layer: TLayer);
begin
  Logger.Debug('TBinLayout28.LoadLayer');
  LoadKeys(Layer.Keys);
  LoadMSR(Layer.MSR);
  LoadKeyLock(Layer.KeyLock);
end;

procedure TBinLayout28.SaveUserData(Layout: TKBLayout);
var
  DataSize: DWORD;
  CheckSumm: Word;
begin
  Logger.Debug('TBinLayout28.SaveUserData');

  DataSize := Stream.Size;
  SetStreamPosition(0);
  Stream.WriteWord(DataSize);
  SetStreamPosition(Stream.Size);
  // Keyboard software version
  Stream.WriteWord(Layout.DeviceVersion);
  // Layout CRC
  CheckSumm := CheckSummCalculate(Stream);
  Stream.WriteWord(CheckSumm);
  // Layout size
  Stream.WriteWord(0);
  // Layout version
  Stream.WriteWord(Layout.FileVersion);
  // Key groups
  SaveGroups(Layout.KeyGroups);
  // Layout parameters
  Stream.WriteByte(Layout.KeyboardID);
  // Layout size
  SetStreamPosition(DataSize + 4);
  Stream.WriteWord(Stream.Size);

end;

procedure TBinLayout28.LoadUserData(Layout: TKBLayout);
var
  KeyboardID: Integer;
  Keyboard: TKeyboard;
  Selection: TGridRect;
begin
  Logger.Debug('TBinLayout28.LoadUserData');

  SetStreamPosition(0);
  SetStreamPosition(Stream.ReadWord);

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

procedure TBinLayout28.LoadFromStream(Layout: TKBLayout; AStream: TStream);
begin
  Logger.Debug('TBinLayout28.LoadFromStream');

  FKeyboard := Layout.Keyboard;
  AStream.Position := 0;
  Stream.LoadFromStream(AStream);
  Stream.Position := 0;
  LoadLayout(Layout);
end;

procedure TBinLayout28.SaveToStream(Layout: TKBLayout; AStream: TStream);
begin
  Logger.Debug('TBinLayout28.SaveToStream');

  FStream.Clear;
  FKeyboard := Layout.Keyboard;
  SaveLayout(Layout);
  Stream.SaveToStream(AStream);
end;

function TBinLayout28.GetHeaderSize(Layout: TKBLayout): Integer;
begin
  Logger.Debug('TBinLayout28.GetHeaderSize');
  Result := 2*(1 + Layout.Layers.Count + Layout.Layers.Count*(Layout.KeyCount + 4));
  Logger.Debug('TBinLayout28.GetHeaderSize', [Result]);
  Logger.Debug('Layout.Layers.Count', [Layout.Layers.Count]);
  Logger.Debug('Layout.KeyCount', [Layout.KeyCount]);
end;

procedure TBinLayout28.SaveLayerHeader(Layout: TKBLayout; Layer: TLayer);
var
  Key: TKey;
  i: Integer;
begin
  Logger.Debug('TBinLayout28.SaveLayerHeader');

  // Writing keys on numbers
  for i := 0 to Layer.Keys.Count-1 do
  begin
    Key := Layer.Keys.ItemByNumber(i+1);
    if Key <> nil then
      Stream.WriteWord(Key.Address)
    else
      Stream.WriteWord($FFFF);
  end;
  Stream.WriteWord(Layer.MSR.Address);
  Stream.WriteWord(Layer.KeyLock.Address);
end;

procedure TBinLayout28.LoadLayerHeader(Layer: TLayer);
var
  Key: TKey;
  i: Integer;
  Address: Word;
begin
  Logger.Debug('TBinLayout28.LoadLayerHeader');

  for i := 0 to Layer.Keys.Count-1 do
  begin
    Address := Stream.ReadWord;
    Key := Layer.Keys.ItemByNumber(i+1);
    if Key <> nil then Key.Address := Address;
  end;
  Layer.MSR.Address := Stream.ReadWord;
  Layer.KeyLock.Address := Stream.ReadWord;
end;

procedure TBinLayout28.UpdateMasterKeys(Layout: TKBLayout);

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
  Logger.Debug('TBinLayout28.UpdateMasterKeys');
  for i := 0 to Layout.Layers.Count-1 do
  begin
    Keys := Layout.Layers[i].Keys;
    for j := 0 to Keys.Count-1 do
    begin
      Key := Keys[j];
      Key.MasterKey := nil;
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

procedure TBinLayout28.LoadLayout(Layout: TKBLayout);
var
  i: Integer;
begin
  Logger.Debug('TBinLayout28.LoadLayout');

  UpdateMasterKeys(Layout);
  try
    LoadUserData(Layout);
    for i := 0 to Layout.Layers.Count-1 do
    begin
      SetStreamPosition(i*2 + 2);
      SetStreamPosition(Stream.ReadWord);
      LoadLayerHeader(Layout.Layers[i]);
      LoadLayer(Layout.Layers[i]);
    end;
  except
    on E: EStreamError do
      InvalidFileFormat(E.Message);
  end;
end;

procedure TBinLayout28.SaveLayout(Layout: TKBLayout);
var
  i: Integer;
  LayerSize: Word;
  LayerStart: Word;
  LayersStart: Word;
begin
  Logger.Debug('TBinLayout28.SaveLayout');

  Stream.Size := 0;
  UpdateMasterKeys(Layout);
  LayersStart := Layout.Layers.Count*2 + 2;
  LayerSize := (Layout.KeyCount + 4)*2;
  // Layers data
  SetStreamPosition(GetHeaderSize(Layout));
  for i := 0 to Layout.Layers.Count-1 do
  begin
    SaveLayer(Layout.Layers[i]);
  end;
  // Header
  SetStreamPosition(2);
  for i := 0 to Layout.Layers.Count-1 do
  begin
    // Layer address
    LayerStart := LayersStart + i*LayerSize;
    SetStreamPosition(2*(i+1));
    Stream.WriteWord(LayerStart);
  end;
  // Data reference
  for i := 0 to Layout.Layers.Count-1 do
  begin
    // Layer address
    SetStreamPosition(LayersStart + i*LayerSize);
    SaveLayerHeader(Layout, Layout.Layers[i]);
  end;
  SaveUserData(Layout);
end;

procedure TBinLayout28.LoadKeyLock(KeyLock: TKeyLock);

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
  Logger.Debug('TBinLayout28.LoadKeyLock');
  if KeyLock.Address <> $FFFF then
  begin
    SetStreamPosition(KeyLock.Address);
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

procedure TBinLayout28.SaveKeyLock(KeyLock: TKeyLock);

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
    Result := Result + (GetLayerNumber(Position.PosType) shl 1);
    if Position.PosType <> ptMacros then SetBit(Result, 0);
    if Position.LockEnabled then SetBit(Result, 3);
    if Position.NcrEmulation then SetBit(Result, 4);
    if Position.NixdorfEmulation then SetBit(Result, 5);
  end;

var
  i: Integer;
  Position: TKeyPosition;
begin
  Logger.Debug('TBinLayout28.SaveKeyLock');
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

procedure TBinLayout28.SaveGroups(Groups: TKeyGroups);
var
  i: Integer;
  Rect: TGridRect;
  Group: TKeyGroup;
begin
  Logger.Debug('TBinLayout28.SaveGroups');
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

procedure TBinLayout28.LoadGroups(Groups: TKeyGroups);
var
  i: Integer;
  Count: Byte;
  Rect: TGridRect;
  Group: TKeyGroup;
begin
  Logger.Debug('TBinLayout28.LoadGroups');

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

procedure TBinLayout28.SetStreamPosition(Value: Integer);
begin
  if Value > Stream.Size then
    Logger.Debug(Format('SetStreamPosition: %d', [Value]));

  Stream.Position := Value;
end;

end.
