unit XMLLayoutEng;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Consts, Graphics,
  // This
  KBLayout, XmlParser, GridType, Keyboard, Utils, LayoutFormat,
  LogFile, FileUtils, AppTypes;

type
  { TXmlLayoutEng }

  TXmlLayoutEng = class(TKBLayoutFormat)
  private
    FXml: TXmlParser;
    FLayout: TKBLayout;

    procedure LoadCodes0(Codes: TScanCodes; Parent: TXmlItem);
    procedure LoadCodes1(Codes: TScanCodes; Parent: TXmlItem);
    procedure SavePicture(Picture: TKeyPicture; Root: TXmlItem);
    procedure LoadPicture(Picture: TKeyPicture; Parent: TXmlItem);
    procedure SaveFont(Parent: TXmlItem; Font: TFont);
    procedure LoadFont(Parent: TXmlItem; Font: TFont);
    procedure SaveIButtonKey(Obj: TIButtonKey; Root: TXmlItem;
      const s: string);
    procedure SaveString(const Value: string; Root: TXmlItem;
      const s: string);
    procedure SaveWheelItem(Obj: TWheelItem; Root: TXmlItem;
      const s: string);
    procedure LoadIButtonKeys(Obj: TIButtonKeys; Root: TXmlItem);
    procedure LoadIButtonKey(Obj: TIButtonKey; Root: TXmlItem);
    procedure LoadWheelItem(Obj: TWheelItem; Root: TXmlItem);
    procedure SaveVersion(Root: TXmlItem);
  protected
    function GetFilter: string; override;
  public
    function GetMinVersion: Word; override;
    function GetMaxVersion: Word; override;
    procedure SaveMSR(MSR: TMSR; Parent: TXmlItem);
    procedure LoadMSR(MSR: TMSR; Root: TXmlItem);
    procedure SaveKey(Key: TKey; Parent: TXmlItem);
    procedure SaveKeys(Keys: TKeys; Parent: TXmlItem);
    procedure SaveLayer(Layer: TLayer; Parent: TXmlItem);
    procedure SaveNote(Note: TNote; Parent: TXmlItem);
    procedure LoadIButton(Obj: TIButton; Root: TXmlItem);
    procedure SaveLayers(Layers: TLayers; Parent: TXmlItem);
    procedure SaveGroups(Groups: TKeyGroups; Parent: TXmlItem);
    procedure SaveTrack(MSRTrack: TMSRTrack; Parent: TXmlItem);
    procedure LoadTrack(MSRTrack: TMSRTrack; Parent: TXmlItem);
    procedure LoadKeyLock(KeyLock: TKeyLock; Root: TXmlItem);
    procedure LoadScrollWheel(Obj: TScrollWheel; Root: TXmlItem);
    procedure SaveKeyPosition(KeyPosition: TKeyPosition; Parent: TXmlItem);
    procedure LoadKeyPosition(KeyPosition: TKeyPosition; Parent: TXmlItem);
    procedure SaveNotes(Notes: TNotes; Root: TXmlItem; const ParentName: string);
    procedure SaveCodes(Codes: TScanCodes; Root: TXmlItem; const ParentName: string);
    procedure SaveIButtonKeys(Obj: TIButtonKeys; Root: TXmlItem; const s: string);

    procedure SaveKeyLock(KeyLock: TKeyLock; Root: TXmlItem; const ParentName: string);
    procedure SaveIButton(Obj: TIButton; Root: TXmlItem; const s: string);
    procedure SaveScrollWheel(Obj: TScrollWheel; Root: TXmlItem; const s: string);

    procedure LoadKey(Keys: TKeys; Parent: TXmlItem);
    procedure LoadKeys(Keys: TKeys; Root: TXmlItem);
    procedure LoadLayers(Layers: TLayers; Root: TXmlItem);
    procedure LoadNote(Note: TNote; Parent: TXmlItem);
    procedure LoadNotes(Notes: TNotes; Parent: TXmlItem);
    procedure LoadCodes(Codes: TScanCodes; Parent: TXmlItem);
    procedure LoadGroups(Groups: TKeyGroups; Parent: TXmlItem);

    procedure LoadLayout(Layout: TKBLayout);
    procedure SaveLayout(Layout: TKBLayout);

    property Xml: TXmlParser read FXml;
    property Layout: TKBLayout read FLayout;
  public
    constructor Create(AOwner: TKBLayoutFormats); override;
    destructor Destroy; override;

    procedure SaveToStream(Layout: TKBLayout; Stream: TStream); override;
    procedure LoadFromStream(Layout: TKBLayout; Stream: TStream); override;
    procedure SaveToFile(Layout: TKBLayout; const FileName: string); override;
    procedure LoadFromFile(Layout: TKBLayout; const FileName: string); override;
  end;

  { TXmlLayoutEng13 }

  // Save layout in KBEditor 1.3 format

  TXmlLayoutEng13 = class(TKBLayoutFormat)
  private
    FXml: TXmlParser;
    FLayout: TKBLayout;

    procedure LoadCodes0(Codes: TScanCodes; Parent: TXmlItem);
    procedure LoadCodes1(Codes: TScanCodes; Parent: TXmlItem);
  protected
    function GetFilter: string; override;
  public
    function GetMinVersion: Word; override;
    function GetMaxVersion: Word; override;
    procedure SaveMSR(MSR: TMSR; Parent: TXmlItem);
    procedure LoadMSR(MSR: TMSR; Parent: TXmlItem);
    procedure SaveKey(Key: TKey; Parent: TXmlItem);
    procedure SaveKeys(Keys: TKeys; Parent: TXmlItem);
    procedure SaveLayer(Layer: TLayer; Parent: TXmlItem);
    procedure SaveNote(Note: TNote; Parent: TXmlItem);
    procedure SaveLayers(Layers: TLayers; Parent: TXmlItem);
    procedure SaveGroups(Groups: TKeyGroups; Parent: TXmlItem);
    procedure SaveTrack(MSRTrack: TMSRTrack; Parent: TXmlItem);
    procedure LoadTrack(MSRTrack: TMSRTrack; Parent: TXmlItem);
    procedure LoadKeyLock(KeyLock: TKeyLock; Parent: TXmlItem);
    procedure SaveKeyPosition(KeyPosition: TKeyPosition; Parent: TXmlItem);
    procedure LoadKeyPosition(KeyPosition: TKeyPosition; Parent: TXmlItem);
    procedure SaveNotes(Notes: TNotes; Root: TXmlItem; const ParentName: string);
    procedure SaveCodes(Codes: TScanCodes; Root: TXmlItem; const ParentName: string);
    procedure SaveKeyLock(KeyLock: TKeyLock; Root: TXmlItem; const ParentName: string);

    procedure LoadKey(Keys: TKeys; Parent: TXmlItem);
    procedure LoadKeys(Keys: TKeys; Parent: TXmlItem);
    procedure LoadLayer(Layer: TLayer; Parent: TXmlItem);
    procedure LoadLayers(Layers: TLayers; Parent: TXmlItem);
    procedure LoadNote(Note: TNote; Parent: TXmlItem);
    procedure LoadNotes(Notes: TNotes; Parent: TXmlItem);
    procedure LoadCodes(Codes: TScanCodes; Parent: TXmlItem);
    procedure LoadGroups(Groups: TKeyGroups; Parent: TXmlItem);

    procedure LoadLayout(Layout: TKBLayout);
    procedure SaveLayout(Layout: TKBLayout);

    property Xml: TXmlParser read FXml;
  public
    constructor Create(AOwner: TKBLayoutFormats); override;
    destructor Destroy; override;

    procedure SaveToStream(Layout: TKBLayout; Stream: TStream); override;
    procedure LoadFromStream(Layout: TKBLayout; Stream: TStream); override;
    procedure SaveToFile(Layout: TKBLayout; const FileName: string); override;
    procedure LoadFromFile(Layout: TKBLayout; const FileName: string); override;
  end;

implementation

const
  BoolToStr: array [Boolean] of string = ('0', '1');

{ TXmlLayoutEng }

const
  S_LAYOUT              = 'Layout';
  S_LAYOUT_PARAMS       = 'Parameters';
  S_LAYOUT_MODEL        = 'Parameters';
  S_LAYOUT_KEYBOARDID   = 'KeyboardID';
  S_LAYOUT_LAYERS       = 'Layers';
  S_LAYOUT_SLEFT        = 'SLeft';
  S_LAYOUT_SRIGHT       = 'SRight';
  S_LAYOUT_STOP         = 'STop';
  S_LAYOUT_SBOTTOM      = 'SBottom';

  S_LAYER_MSR           = 'MSR';
  S_LAYER               = 'Layer';
  S_LAYER_KEYLOCK       = 'KeyLock';
  S_LAYER_IBUTTON       = 'IButton';
  S_LAYER_SCROLLWHEEL   = 'ScrollWheel';
  S_LAYER_KEYS          = 'Keys';
  S_LAYER_PARAMS        = 'Parameters';
  S_LAYER_KEYTYPE       = 'KeyType';

  S_KEY                 = 'Key';
  S_KEY_NUMBER          = 'Number';
  S_KEY_ROW             = 'Row';
  S_KEY_COL             = 'Column';
  S_KEY_PARAMS          = 'Parameters';
  S_KEY_TEXT            = 'Text';
  S_KEY_NOTES           = 'Notes';
  S_KEY_REPEATKEY       = 'RepeatEnabled';
  S_KEY_PRESSCODES      = 'PressCodes';
  S_KEY_RELEASECODES    = 'ReleaseCodes';
  S_KEY_PICTURE         = 'Picture';
  S_KEY_PICTURE_DATA    = 'Data';

  S_PICTURE_BKCOLOR     = 'BackgroundColor';
  S_PICTURE_TEXT        = 'Text';
  S_PICTURE_FILE        = 'PictureFile';
  S_TEXT_ORIENTATION    = 'TextOrientation';

  S_SCANCODE            = 'ScanCode';
  S_SCANCODES           = 'ScanCodes';
  S_SCANCODE_TYPE       = 'Type';
  S_SCANCODE_CODE       = 'Code';
  S_SCANCODE_NUMBER     = 'Number';
  S_SCANCODE_EXTCODE    = 'ExtCode';
  S_SCANCODE_TEXT       = 'Text';

  S_NOTE                = 'Note';
  S_NOTE_NUMBER         = 'Number';
  S_NOTE_NOTE           = 'Note';
  S_NOTE_TIME           = 'Duration';
  S_NOTE_VOLUME         = 'Volume';

  S_KEYGROUP            = 'Group';
  S_KEYGROUPS           = 'Groups';
  S_KEYGROUP_TOP        = 'Top';
  S_KEYGROUP_LEFT       = 'Left';
  S_KEYGROUP_RIGHT      = 'Right';
  S_KEYGROUP_BOTTOM     = 'Bottom';

  S_MSR_SENDENTER       = 'SendEnter';
  S_MSR_LOCKONERR       = 'StopOnError';
  S_MSR_LIGHTINDICATION = 'LightIndication';
  S_MSR_TRACK1          = 'Track1';
  S_MSR_TRACK2          = 'Track2';
  S_MSR_TRACK3          = 'Track3';
  S_MSR_NOTES           = 'Notes';

  S_TRACK_ENABLED       = 'Enabled';
  S_TRACK_PREFIX        = 'Prefix';
  S_TRACK_SUFFIX        = 'Suffix';

  S_KEYLOCK_POSITION    = 'Position';
  S_KEYLOCK_POSNUM      = 'Number';

  S_KEYPOS_CODES        = 'ScanCodes';
  S_KEYPOS_NOTES        = 'Notes';
  S_KEYPOS_LOCK         = 'LockEnabled';
  S_KEYPOS_TYPE         = 'PositionType';
  S_KEYPOS_NcrEmulation = 'NCREmulation';

  FONT_PIXELS           = 'FontFixels';
  FONT_CHARSET          = 'FontCharset';
  FONT_COLOR            = 'FontColor';
  FONT_HEIGHT           = 'FontHeight';
  FONT_NAME             = 'FontName';
  FONT_SIZE             = 'FontSize';
  FONT_STYLE            = 'FontStyle';

function KeyTypeToInt(Value: TKeyType): Integer;
begin
  case Value of
    ktNone      : Result := 0;
    ktMacros    : Result := 1;
    ktGoUp      : Result := 2;
    ktGoDown    : Result := 3;
    ktGo1       : Result := 4;
    ktGo2       : Result := 5;
    ktGo3       : Result := 6;
    ktGo4       : Result := 7;
    ktTemp1     : Result := 8;
    ktTemp2     : Result := 9;
    ktTemp3     : Result := 10;
    ktTemp4     : Result := 11;
  else
    Result := 1;
  end;
end;

function IntToKeyType(Value: Integer): TKeyType;
begin
  case Value of
    0: Result := ktNone;
    1: Result := ktMacros;
    2: Result := ktGoUp;
    3: Result := ktGoDown;
    4: Result := ktGo1;
    5: Result := ktGo2;
    6: Result := ktGo3;
    7: Result := ktGo4;
    8: Result := ktTemp1;
    9: Result := ktTemp2;
    10: Result := ktTemp3;
    11: Result := ktTemp4;
  else
    Result := ktMacros;
  end;
end;

function PosTypeToInt(Value: TPosType): Integer;
begin
  case Value of
    ptMacros    : Result := 0;
    ptGo1       : Result := 1;
    ptGo2       : Result := 2;
    ptGo3       : Result := 3;
    ptGo4       : Result := 4;
  else
    Result := 0;
  end;
end;

function IntToPosType(Value: Integer): TPosType;
begin
  case Value of
    0: Result := ptMacros;
    1: Result := ptGo1;
    2: Result := ptGo2;
    3: Result := ptGo3;
    4: Result := ptGo4;
  else
    Result := ptMacros;
  end;
end;

{ TXmlLayoutEng }

constructor TXmlLayoutEng.Create(AOwner: TKBLayoutFormats);
begin
  inherited Create(AOwner);
  FXml := TXmlParser.Create;
end;

destructor TXmlLayoutEng.Destroy;
begin
  FXml.Free;
  inherited Destroy;
end;

procedure TXmlLayoutEng.SaveFont(Parent: TXmlItem; Font: TFont);
var
  Style: TFontStyles;
begin
  Parent.Params.Values[FONT_PIXELS] := IntToStr(Font.PixelsPerInch);
  Parent.Params.Values[FONT_CHARSET] := IntToStr(Integer(Font.Charset));
  Parent.Params.Values[FONT_COLOR] := IntToHex(Integer(Font.Color), 8);
  Parent.Params.Values[FONT_HEIGHT] := IntToStr(Font.Height);
  Parent.Params.Values[FONT_NAME] := Font.Name;
  Parent.Params.Values[FONT_SIZE] := IntToStr(Font.Size);
  Style := Font.Style;
  Parent.Params.Values[FONT_STYLE] := IntToStr(SetToInteger(Style, SizeOf(TFontStyle)));
end;

procedure TXmlLayoutEng.LoadFont(Parent: TXmlItem; Font: TFont);
var
  S: string;
  Style: TFontStyles;
begin
  S := Parent.Params.Values[FONT_PIXELS];
  if S <> '' then
    Font.PixelsPerInch := StrToInt(S);

  S := Parent.Params.Values[FONT_CHARSET];
  if S <> '' then
    Font.Charset := TFontCharset(StrToInt(S));

  S := Parent.Params.Values[FONT_COLOR];
  if S <> '' then
    Font.Color := StrToInt('$' + S);

  S := Parent.Params.Values[FONT_HEIGHT];
  if S <> '' then
    Font.Height := StrToInt(S);

  S := Parent.Params.Values[FONT_SIZE];
  if S <> '' then
    Font.Size := StrToInt(S);

  S := Parent.Params.Values[FONT_STYLE];
  if S <> '' then
  begin
    IntegerToSet(StrToInt(S), SizeOF(TFontStyle), Style);
    Font.Style := Style;
  end;

  Font.Name := Parent.Params.Values[FONT_NAME];
end;

procedure TXmlLayoutEng.SavePicture(Picture: TKeyPicture; Root: TXmlItem);
var
  Item: TXmlItem;
begin
  Item := Root.New(S_KEY_PICTURE);
  Item.Params.Values[S_PICTURE_BKCOLOR] := IntToHex(Integer(Picture.BackgroundColor), 8);
  if Picture.Text <> '' then
    Item.Params.Values[S_PICTURE_TEXT] := Picture.Text;

  Item.Params.Values[S_TEXT_ORIENTATION] := IntToStr(Integer(Picture.VerticalText));
  SaveFont(Item, Picture.TextFont);
  // Picture data
  if Picture.HasData then
  begin
    Item := Item.New(S_KEY_PICTURE_DATA);
    Item.Text := Picture.Data;
  end;
end;

procedure TXmlLayoutEng.LoadPicture(Picture: TKeyPicture; Parent: TXmlItem);
var
  S: string;
  Item: TXmlItem;
begin
  S := Parent.Params.Values[S_PICTURE_BKCOLOR];
  if S <> '' then
    Picture.BackgroundColor := StrToInt('$' + S);
  Picture.Text := Parent.Params.Values[S_PICTURE_TEXT];


  { !!! }
  S := Parent.Params.Values[S_TEXT_ORIENTATION];
  if S <> '' then
    Picture.VerticalText := Boolean(StrToInt(S));
  LoadFont(Parent, Picture.TextFont);
  // Picture data
  Item := Parent.FindItem(S_KEY_PICTURE_DATA);
  if Assigned(Item) then Picture.Data := Item.Text;
end;

procedure TXmlLayoutEng.SaveCodes(Codes: TScanCodes; Root: TXmlItem;
  const ParentName: string);
var
  Item: TXmlItem;
begin
  if Codes.Count = 0 then Exit;
  Item := Root.New(ParentName);
  Item.Params.Values[S_SCANCODES] := Codes.AsText;
end;

procedure TXmlLayoutEng.SaveGroups(Groups: TKeyGroups; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
  Group: TKeyGroup;
begin
  for i := 0 to Groups.Count-1 do
  begin
    Group := Groups[i];
    Item := Parent.New(S_KEYGROUP);
    Item.Params.Values[S_KEYGROUP_TOP] := IntToStr(Group.Rect.Top-1);
    Item.Params.Values[S_KEYGROUP_LEFT] := IntToStr(Group.Rect.Left-1);
    Item.Params.Values[S_KEYGROUP_RIGHT] := IntToStr(Group.Rect.Right-1);
    Item.Params.Values[S_KEYGROUP_BOTTOM] := IntToStr(Group.Rect.Bottom-1);
  end;
end;

procedure TXmlLayoutEng.SaveIButtonKeys(Obj: TIButtonKeys; Root: TXmlItem;
  const s: string);
var
  i: Integer;
  Item: TXmlItem;
begin
  Item := Root.New(S);
  for i := 0 to Obj.Count-1 do
    SaveIButtonKey(Obj[i], Item, 'IButtonKey');
end;

procedure TXmlLayoutEng.SaveIButtonKey(Obj: TIButtonKey; Root: TXmlItem;
  const s: string);
var
  Item: TXmlItem;
begin
  Item := Root.New(S);
  SaveNotes(Obj.Notes, Item, 'Notes');
  SaveCodes(Obj.Codes, Item, 'Codes');
  SaveString(Obj.NumberAsHex, Item, 'Number');
end;

procedure TXmlLayoutEng.SaveString(const Value: string; Root: TXmlItem;
  const s: string);
var
  Item: TXmlItem;
begin
  Item := Root.New(S);
  Item.Text := Value;
end;

procedure TXmlLayoutEng.LoadCodes(Codes: TScanCodes; Parent: TXmlItem);
begin
  if Parent = nil then Exit;

  if FLayout.FileVersion = 0 then
    LoadCodes0(Codes, Parent)
  else
    LoadCodes1(Codes, Parent);
end;

procedure TXmlLayoutEng.LoadCodes0(Codes: TScanCodes; Parent: TXmlItem);
var
  S: string;
  i: Integer;
  Code: Word;
  HiCode: Byte;
  LoCode: Byte;
  Item: TXmlItem;
  Count: Integer;
  ScanCode: TScanCode;
begin
  Codes.Clear;
  // ScanCode
  Item := Parent.FindItem(S_SCANCODE);
  if Assigned(Item) then
  begin
    LoCode := 0;
    HiCode := 0;
    // LoCode
    S := Item.Params.Values[S_SCANCODE_CODE];
    if S <> '' then LoCode := StrToInt(S);
    // HiCode
    S := Item.Params.Values[S_SCANCODE_EXTCODE];
    if S <> '' then HiCode := StrToInt(S);

    Code := (HiCode shl 8) + LoCode;
    Codes.AddCode(Code);
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
      ScanCode.Code := ScanCode.BreakCode;
    end;
  end;
end;

procedure TXmlLayoutEng.LoadCodes1(Codes: TScanCodes; Parent: TXmlItem);
begin
  Codes.AsText := Parent.Params.Values[S_SCANCODES];
end;

procedure TXmlLayoutEng.LoadGroups(Groups: TKeyGroups; Parent: TXmlItem);
var
  S: string;
  i: Integer;
  Rect: TGridRect;
  Item: TXmlItem;
  Group: TKeyGroup;
begin
  Groups.Clear;
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_KEYGROUP) then
    begin
      Group := Groups.Add;
      // Top
      S := Item.Params.Values[S_KEYGROUP_TOP];
      if S <> '' then Rect.Top := StrToInt(S)+1;
      // Left
      S := Item.Params.Values[S_KEYGROUP_LEFT];
      if S <> '' then Rect.Left := StrToInt(S)+1;
      // Right
      S := Item.Params.Values[S_KEYGROUP_RIGHT];
      if S <> '' then Rect.Right := StrToInt(S)+1;
      // Bottom
      S := Item.Params.Values[S_KEYGROUP_BOTTOM];
      if S <> '' then Rect.Bottom := StrToInt(S)+1;
      Group.Rect := Rect;
    end;
  end;
end;

procedure TXmlLayoutEng.SaveNote(Note: TNote; Parent: TXmlItem);
begin
  Parent.Params.Values[S_NOTE_NOTE] := IntToStr(Note.Note);
  Parent.Params.Values[S_NOTE_TIME] := IntToStr(Note.Interval);
  Parent.Params.Values[S_NOTE_VOLUME] := IntToStr(Note.Volume);
end;

procedure TXmlLayoutEng.LoadNote(Note: TNote; Parent: TXmlItem);
var
  S: string;
begin
  { Note }
  S := Parent.Params.Values[S_NOTE_NOTE];
  if S <> '' then Note.Note := StrToInt(S);
  { Duration }
  S := Parent.Params.Values[S_NOTE_TIME];
  if S <> '' then Note.Interval := StrToInt(S);
  { Volume }
  S := Parent.Params.Values[S_NOTE_VOLUME];
  if S <> '' then Note.Volume := StrToInt(S);
end;

procedure TXmlLayoutEng.SaveNotes(Notes: TNotes; Root: TXmlItem;
  const ParentName: string);
var
  i: Integer;
  Item: TXmlItem;
  Parent: TXmlItem;
begin
  if Notes.Count = 0 then Exit;
  Parent := Root.New(ParentName);
  for i := 0 to Notes.Count-1 do
  begin
    Item := Parent.New(S_NOTE);
    Item.Params.Values[S_NOTE_NUMBER] := IntToStr(i+1);
    SaveNote(Notes[i], Item);
  end;
end;

procedure TXmlLayoutEng.LoadNotes(Notes: TNotes; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  if Parent = nil then Exit;

  Notes.Clear;
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_NOTE) then
      LoadNote(Notes.Add, Item);
  end;
end;

procedure TXmlLayoutEng.SaveLayer(Layer: TLayer; Parent: TXmlItem);
var
  Item: TXmlItem;
begin
  { Keys }
  if Layer.Keys.Count > 0 then
  begin
    Item := Parent.New(S_LAYER_KEYS);
    SaveKeys(Layer.Keys, Item);
  end;
  { MSR }
  if Layout.HasMSR then
  begin
    Item := Parent.New(S_LAYER_MSR);
    SaveMSR(Layer.MSR, Item);
  end;
  SaveKeyLock(Layer.KeyLock, Parent, S_LAYER_KEYLOCK);
  SaveScrollWheel(Layer.ScrollWheel, Parent, S_LAYER_SCROLLWHEEL);
  SaveIButton(Layer.IButton, Parent, S_LAYER_IBUTTON);
end;

procedure TXmlLayoutEng.SaveLayers(Layers: TLayers; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  for i := 0 to Layers.Count-1 do
  begin
    Item := Parent.New(S_LAYER);
    SaveLayer(Layers[i], Item);
  end;
end;

procedure TXmlLayoutEng.SaveKey(Key: TKey; Parent: TXmlItem);
begin
  Parent.Params.Values[S_KEY_COL] := IntToStr(Key.Col-1);
  Parent.Params.Values[S_KEY_ROW] := IntToStr(Key.Row-1);
  if Key.Text <> '' then
    Parent.Params.Values[S_KEY_TEXT] := Key.Text;

  Parent.Params.Values[S_KEY_REPEATKEY] := BoolToStr[Key.RepeatKey];
  Parent.Params.Values[S_LAYER_KEYTYPE] := IntToStr(KeyTypeToInt(Key.KeyType));
  { Press codes }
  SaveCodes(Key.PressCodes, Parent, S_KEY_PRESSCODES);
  { Release codes }
  SaveCodes(Key.ReleaseCodes, Parent, S_KEY_RELEASECODES);
  { Notes }
  SaveNotes(Key.Notes, Parent, S_KEY_NOTES);
  { Pictures }
  SavePicture(Key.Picture, Parent);
end;

procedure TXmlLayoutEng.LoadLayers(Layers: TLayers; Root: TXmlItem);
var
  i: Integer;
  Layer: TLayer;
  Item: TXmlItem;
  XmlItem: TXmlItem;
begin
  for i := 0 to Root.Count-1 do
  begin
    Item := Root[i];
    if Item.NameIsEqual(S_LAYER) then
    begin
      if i < Layers.Count then
      begin
        Layer := Layers[i];
        // Keys
        XmlItem := Item.FindItem(S_LAYER_KEYS);
        if Assigned(XmlItem) then LoadKeys(Layer.Keys, XmlItem);
        // MSR
        XmlItem := Item.FindItem(S_LAYER_MSR);
        if Assigned(XmlItem) then LoadMSR(Layer.MSR, XmlItem);
        // KeyLock
        XmlItem := Item.FindItem(S_LAYER_KEYLOCK);
        if Assigned(XmlItem) then
          LoadKeyLock(Layer.KeyLock, XmlItem);
        // IButton
        XmlItem := Item.FindItem(S_LAYER_IBUTTON);
        if Assigned(XmlItem) then LoadIButton(Layer.IButton, XmlItem);
        // ScrollWheel
        XmlItem := Item.FindItem(S_LAYER_SCROLLWHEEL);
        if Assigned(XmlItem) then LoadScrollWheel(Layer.ScrollWheel, XmlItem);
      end;
    end;
  end;
end;

procedure TXmlLayoutEng.LoadKey(Keys: TKeys; Parent: TXmlItem);
var
  S: string;
  Key: TKey;
  i: Integer;
  Col: Integer;
  Row: Integer;
  Item: TXmlItem;
begin
  // Column
  S := Parent.Params.Values[S_KEY_COL];
  Col := StrToInt(S) + 1;
  // Row
  S := Parent.Params.Values[S_KEY_ROW];
  Row := StrToInt(S) + 1;
  // Get key
  Key := Keys.FindItem(Col, Row);
  if Key = nil then
  begin
    Logger.Error('Key = nil');
    Exit;
  end;
  // Layer 
  S := Parent.Params.Values[S_LAYER_KEYTYPE];
  if S <> '' then Key.KeyType := IntToKeyType(StrToInt(S));
  // Note
  Key.Text := Parent.Params.Values[S_KEY_TEXT];
  // Repeat enabled
  S := Parent.Params.Values[S_KEY_REPEATKEY];
  Key.RepeatKey := S = '1';
  //
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    { Press codes }
    if Item.NameIsEqual(S_KEY_PRESSCODES) then
      LoadCodes(Key.PressCodes, Item);
    { Release codes }
    if Item.NameIsEqual(S_KEY_RELEASECODES) then
      LoadCodes(Key.ReleaseCodes, Item);
    { Notes }
    if Item.NameIsEqual(S_KEY_NOTES) then
      LoadNotes(Key.Notes, Item);
    { Pictures }
    if Item.NameIsEqual(S_KEY_PICTURE) then
      LoadPicture(Key.Picture, Item);
  end;
end;

{ Save keys }

procedure TXmlLayoutEng.SaveKeys(Keys: TKeys; Parent: TXmlItem);
var
  i: Integer;
  Key: TKey;
  Item: TXmlItem;
begin
  for i := 0 to Keys.Count-1 do
  begin
    Key := Keys[i];

    Item := Parent.New(S_KEY);
    SaveKey(Key, Item);
  end;
end;

{ Writing MSR track parameters }

procedure TXmlLayoutEng.SaveTrack(MSRTrack: TMSRTrack; Parent: TXmlItem);
begin
  { Parameters }
  Parent.Params.Values[S_TRACK_ENABLED] := BoolToStr[MSRTrack.Enabled];
  { Prefix }
  SaveCodes(MSRTrack.Prefix, Parent, S_TRACK_PREFIX);
  { Suffix }
  SaveCodes(MSRTrack.Suffix, Parent, S_TRACK_SUFFIX);
end;

{ Reading MSR parameters }

procedure TXmlLayoutEng.LoadTrack(MSRTrack: TMSRTrack; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  { Parameters }
  MSRTrack.Enabled := Parent.Params.Values[S_TRACK_ENABLED] = '1';

  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    { Prefix }
    if Item.NameIsEqual(S_TRACK_PREFIX) then
      LoadCodes(MSRTrack.Prefix, Item);
    { Suffix }
    if Item.NameIsEqual(S_TRACK_SUFFIX) then
      LoadCodes(MSRTrack.Suffix, Item);
  end;
end;

{ Writing MSR parameters }

procedure TXmlLayoutEng.SaveMSR(MSR: TMSR; Parent: TXmlItem);
var
  Item: TXmlItem;
begin
  { Parameters }
  Parent.Params.Values[S_MSR_SENDENTER] := BoolToStr[MSR.SendEnter];
  Parent.Params.Values[S_MSR_LOCKONERR] := BoolToStr[MSR.LockOnErr];
  Parent.Params.Values[S_MSR_LIGHTINDICATION] := BoolToStr[MSR.LightIndication];
  { Track 1}
  Item := Parent.New(S_MSR_TRACK1);
  SaveTrack(MSR.Tracks[0], Item);
  { Track 2}
  Item := Parent.New(S_MSR_TRACK2);
  SaveTrack(MSR.Tracks[1], Item);
  { Track 3}
  Item := Parent.New(S_MSR_TRACK3);
  SaveTrack(MSR.Tracks[2], Item);
  { Notes }
  SaveNotes(MSR.Notes, Parent, S_MSR_NOTES);
end;

{ Read MSR parameters }

procedure TXmlLayoutEng.LoadMSR(MSR: TMSR; Root: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  if Root = nil then Exit;
  { Parameters }
  MSR.SendEnter := Root.Params.Values[S_MSR_SENDENTER] = '1';
  MSR.LockOnErr := Root.Params.Values[S_MSR_LOCKONERR] = '1';
  MSR.LightIndication := Root.Params.Values[S_MSR_LIGHTINDICATION] = '1';

  for i := 0 to Root.Count-1 do
  begin
    Item := Root[i];
    { Track 1 }
    if Item.NameIsEqual(S_MSR_TRACK1) then
      LoadTrack(MSR.Tracks[0], Item);
    { Track 2 }
    if Item.NameIsEqual(S_MSR_TRACK2) then
      LoadTrack(MSR.Tracks[1], Item);
    { Track 3 }
    if Item.NameIsEqual(S_MSR_TRACK3) then
      LoadTrack(MSR.Tracks[2], Item);
    { Notes }
    if Item.NameIsEqual(S_MSR_NOTES) then
      LoadNotes(MSR.Notes, Item);
  end;
end;

procedure TXmlLayoutEng.LoadKeys(Keys: TKeys; Root: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  if Root = nil then Exit;
  for i := 0 to Root.Count-1 do
  begin
    Item := Root[i];
    if Item.NameIsEqual(S_KEY) then
    begin
      LoadKey(Keys, Item);
    end;
  end;
end;

procedure TXmlLayoutEng.LoadLayout(Layout: TKBLayout);
var
  S: string;
  i: Integer;
  Item: TXmlItem;
  Parent: TXmlItem;
  HasParams: Boolean;
  Selection: TGridRect;
  KeyboardID: Integer;
  Keyboard: TKeyboard;
begin
  Parent := Xml.Root;
  // Layout parameters
  FLayout.FileVersion := 0;
  S := Parent.Params.Values['Vesion'];
  if S <> '' then
  begin
   S := HexToStr(S);
   FLayout.FileVersion := Byte(S[1])*256 + Byte(S[2]);
   Layout.DeviceVersion := FLayout.FileVersion;
  end;

  HasParams := False;
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_LAYOUT_PARAMS) then
    begin
      HasParams := True;
      // Top
      S := Item.Params.Values[S_LAYOUT_STOP];
      if S <> '' then Selection.Top := StrToInt(S);
      // Left
      S := Item.Params.Values[S_LAYOUT_SLEFT];
      if S <> '' then Selection.Left := StrToInt(S);
      // Right
      S := Item.Params.Values[S_LAYOUT_SRIGHT];
      if S <> '' then Selection.Right := StrToInt(S);
      // Bottom
      S := Item.Params.Values[S_LAYOUT_SBOTTOM];
      if S <> '' then Selection.Bottom := StrToInt(S);

      //KeyboardID
      S := Item.Params.Values[S_LAYOUT_KEYBOARDID];
      if S = '' then KeyboardID := 4
      else KeyboardID := StrToInt(S);
      Keyboard := Keyboards.ItemByID(KeyboardID);
      Layout.Keyboard := Keyboard;
      Layout.Selection := Selection;
    end;
  end;
  if not HasParams then
    InvalidFileFormat(MsgLayoutParametersNotFound);
  // Layout data
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    // Layers
    if Item.NameIsEqual(S_LAYOUT_LAYERS) then
      LoadLayers(Layout.Layers, Item);
    // Key groups
    if Item.NameIsEqual(S_KEYGROUPS) then
      LoadGroups(Layout.KeyGroups, Item);
  end;
  Layout.UpdateKeys;
end;

procedure TXmlLayoutEng.SaveVersion(Root: TXmlItem);
begin
  Root.Params.Values[S_LAYOUT_KEYBOARDID] := IntToStr(Layout.Keyboard.ID);
end;

procedure TXmlLayoutEng.SaveLayout(Layout: TKBLayout);
var
  Item: TXmlItem;
begin
  Xml.Clear;
  Xml.SetRootName(S_LAYOUT);
  Xml.Root.Params.Values['Vesion'] := IntToHex(Layout.FileVersion, 4);
  { Parameters }
  Item := Xml.Root.New(S_LAYOUT_PARAMS);
  SaveVersion(Item);
  Item.Params.Values[S_LAYOUT_STOP] := IntToStr(Layout.Selection.Top);
  Item.Params.Values[S_LAYOUT_SLEFT] := IntToStr(Layout.Selection.Left);
  Item.Params.Values[S_LAYOUT_SRIGHT] := IntToStr(Layout.Selection.Right);
  Item.Params.Values[S_LAYOUT_SBOTTOM] := IntToStr(Layout.Selection.Bottom);
  { Keys }
  if Layout.Layers.Count > 0 then
  begin
    Item := Xml.Root.New(S_LAYOUT_LAYERS);
    SaveLayers(Layout.Layers, Item);
  end;
  { Key groups }
  if Layout.KeyGroups.Count > 0 then
  begin
    Item := Xml.Root.New(S_KEYGROUPS);
    SaveGroups(Layout.KeyGroups, Item);
  end;
end;

procedure TXmlLayoutEng.SaveToStream(Layout: TKBLayout; Stream: TStream);
begin
  FLayout := Layout;
  SaveLayout(Layout);
  Xml.SaveToStream(Stream);
end;

procedure TXmlLayoutEng.LoadFromStream(Layout: TKBLayout; Stream: TStream);
begin
  FLayout := Layout;
  Xml.LoadFromStream(Stream);
  LoadLayout(Layout);
end;

procedure TXmlLayoutEng.SaveToFile(Layout: TKBLayout; const FileName: string);
begin
  Logger.Debug('TXmlLayoutEng.SaveToFile', [FileName]);

  FLayout := Layout;
  SaveLayout(Layout);
  Xml.SaveToFile(FileName);
end;

//////////////////////////////////////////////////////////////////////////////
//
// String replacement
//
// <?xml version="1.0" encoding="ISO8859-1" ?>
// <?xml version="1.0" encoding="Windows-1251" ?>
//
//////////////////////////////////////////////////////////////////////////////

function ChangeFirstLine(const Data: string): string;
const
  S1 = '<?xml version="1.0" encoding="ISO8859-1" ?>';
  S2 = '<?xml version="1.0" encoding="Windows-1251" ?>';
begin
  Result := StringReplace(Data, S1, S2, [rfReplaceAll, rfIgnoreCase]);
end;

procedure TXmlLayoutEng.LoadFromFile(Layout: TKBLayout; const FileName: string);
var
  Data: string;
begin
  Logger.Debug('TXmlLayoutEng.LoadFromFile', [FileName]);

  FLayout := Layout;
  Data := ReadFileData(FileName);
  Data := ChangeFirstLine(Data);
  Xml.LoadFromString(Data);

  LoadLayout(Layout);
  Layout.Saved(FileName);
end;

{ Reading KeyLock parameters }

procedure TXmlLayoutEng.LoadKeyLock(KeyLock: TKeyLock; Root: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  if Root = nil then Exit;

  KeyLock.Clear;
  for i := 0 to Root.Count-1 do
  begin
    Item := Root[i];
    if Item.NameIsEqual(S_KEYLOCK_POSITION) then
    begin
      LoadKeyPosition(KeyLock.Add, Item);
    end;
  end;
end;

{ Reading keylock position parameters - KeyPosition }

procedure TXmlLayoutEng.LoadKeyPosition(KeyPosition: TKeyPosition;
  Parent: TXmlItem);
var
  S: string;
  i: Integer;
  Item: TXmlItem;
begin
  { Position type }
  S := Parent.Params.Values[S_KEYPOS_TYPE];
  if S <> '' then KeyPosition.PosType := IntToPosType(StrToInt(S));
  { Lock enabled }
  KeyPosition.LockEnabled := Parent.Params.Values[S_KEYPOS_LOCK] = '1';
  { NCR emulation }
  KeyPosition.NcrEmulation := Parent.Params.Values[S_KEYPOS_NcrEmulation] = '1';
  // NixdorfEmulation
  KeyPosition.NixdorfEmulation := Parent.Params.Values['NixdorfEmulation'] = '1';

  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    { Scan codes }
    if Item.NameIsEqual(S_KEYPOS_CODES) then
      LoadCodes(KeyPosition.Codes, Item);
    { Notes }
    if Item.NameIsEqual(S_KEYPOS_NOTES) then
      LoadNotes(KeyPosition.Notes, Item);
  end;
end;

{ Writing keylock parameters }

procedure TXmlLayoutEng.SaveKeyLock(KeyLock: TKeyLock; Root: TXmlItem;
  const ParentName: string);
var
  i: Integer;
  Item: TXmlItem;
  Parent: TXmlItem;
begin
  if KeyLock.IsEmpty then Exit;

  Parent := Root.New(ParentName);
  for i := 0 to KeyLock.Count-1 do
  begin
    Item := Parent.New(S_KEYLOCK_POSITION);
    Item.Params.Values[S_KEYLOCK_POSNUM] := IntToStr(i+1);

    SaveKeyPosition(KeyLock[i], Item);
  end;
end;

procedure TXmlLayoutEng.SaveIButton(Obj: TIButton; Root: TXmlItem; const s: string);
var
  Parent: TXmlItem;
begin
  if Obj.IsEmpty then Exit;

  Parent := Root.New(S);
  SaveNotes(Obj.Notes, Parent, 'Notes');
  SaveCodes(Obj.Prefix, Parent, 'Prefix');
  SaveCodes(Obj.Suffix, Parent, 'Suffix');
  SaveIButtonKey(Obj.DefKey, Parent, 'DefKey');
  SaveIButtonKeys(Obj.RegKeys, Parent, 'RegKeys');
  SaveString(BoolTostr[Obj.SendCode], Parent, 'SendCode');
end;


{ Writing keylock position parameters - KeyPosition }

procedure TXmlLayoutEng.SaveKeyPosition(KeyPosition: TKeyPosition;
  Parent: TXmlItem);
begin
  { Position type }
  Parent.Params.Values[S_KEYPOS_TYPE] := IntToStr(PosTypeToInt(KeyPosition.PosType));
  { Lock enbaled }
  Parent.Params.Values[S_KEYPOS_LOCK] := BoolToStr[KeyPosition.LockEnabled];
  { NCREmulation }
  Parent.Params.Values[S_KEYPOS_NcrEmulation] := BoolToStr[KeyPosition.NcrEmulation];
  // NixdorfEmulation
  Parent.Params.Values['NixdorfEmulation'] := BoolToStr[KeyPosition.NixdorfEmulation];
  { Scancodes }
  SaveCodes(KeyPosition.Codes, Parent, S_KEYPOS_CODES);
  { Notes }
  SaveNotes(KeyPosition.Notes, Parent, S_KEYPOS_NOTES);
end;

function TXmlLayoutEng.GetFilter: string;
begin
  Result := MsgXmlLayout;
end;

procedure TXmlLayoutEng.SaveScrollWheel(Obj: TScrollWheel; Root: TXmlItem;
  const s: string);
var
  Item: TXmlItem;
begin
  if Obj.IsEmpty then Exit;
  
  Item := Root.New(S);
  SaveWheelItem(Obj.ScrollUp, Item, 'ScrollUp');
  SaveWheelItem(Obj.ScrollDown, Item, 'ScrollDown');
  SaveWheelItem(Obj.SingleClick, Item, 'SingleClick');
  SaveWheelItem(Obj.DoubleClick, Item, 'DoubleClick');
end;

procedure TXmlLayoutEng.SaveWheelItem(Obj: TWheelItem; Root: TXmlItem;
  const s: string);
var
  Item: TXmlItem;
begin
  Item := Root.New(S);
  SaveNotes(Obj.Notes, Item, 'Notes');
  SaveCodes(Obj.Codes, Item, 'Codes');
end;

procedure TXmlLayoutEng.LoadIButton(Obj: TIButton; Root: TXmlItem);
var
  Item: TXmlItem;
begin
  if Root = nil then Exit;

  Obj.Clear;
  // Notes
  Item := Root.FindItem('Notes');
  if Assigned(Item) then LoadNotes(Obj.Notes, Item);
  // Prefix
  Item := Root.FindItem('Prefix');
  if Assigned(Item) then LoadCodes(Obj.Prefix, Item);
  // Suffix
  Item := Root.FindItem('Prefix');
  if Assigned(Item) then LoadCodes(Obj.Suffix, Item);
  // DefKey
  Item := Root.FindItem('DefKey');
  if Assigned(Item) then LoadIButtonKey(Obj.DefKey, Item);
  // RegKeys
  Item := Root.FindItem('RegKeys');
  if Assigned(Item) then LoadIButtonKeys(Obj.RegKeys, Item);
  // SendCode
  Item := Root.FindItem('SendCode');
  if Assigned(Item) then Obj.SendCode := Item.Text <> '0';
end;

procedure TXmlLayoutEng.LoadIButtonKeys(Obj: TIButtonKeys; Root: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  Obj.Clear;
  if Root = nil then Exit;
  for i := 0 to Root.Count-1 do
  begin
    Item := Root[i];
    if Item.NameIsEqual('IButtonKey') then
      LoadIButtonKey(Obj.Add, Item);
  end;
end;

procedure TXmlLayoutEng.LoadIButtonKey(Obj: TIButtonKey; Root: TXmlItem);
var
  Item: TXmlItem;
begin
  // Number
  Item := Root.FindItem('Notes');
  if Assigned(Item) then Obj.NumberAsHex := Item.Text;
  // Notes
  Item := Root.FindItem('Notes');
  if Assigned(Item) then LoadNotes(Obj.Notes, Item);
  // Codes
  Item := Root.FindItem('Codes');
  if Assigned(Item) then LoadCodes(Obj.Codes, Item);
end;

procedure TXmlLayoutEng.LoadScrollWheel(Obj: TScrollWheel; Root: TXmlItem);
begin
  if Root = nil then Exit;
  LoadWheelItem(Obj.ScrollUp, Root.FindItem('ScrollUp'));
  LoadWheelItem(Obj.ScrollDown, Root.FindItem('ScrollDown'));
  LoadWheelItem(Obj.SingleClick, Root.FindItem('SingleClick'));
  LoadWheelItem(Obj.DoubleClick, Root.FindItem('DoubleClick'));
end;

procedure TXmlLayoutEng.LoadWheelItem(Obj: TWheelItem; Root: TXmlItem);
begin
  if Root = nil then Exit;
  LoadNotes(Obj.Notes, Root.FindItem('Notes'));
  LoadCodes(Obj.Codes, Root.FindItem('Codes'));
end;


function TXmlLayoutEng.GetMinVersion: Word;
begin
  Result := $200;
end;

function TXmlLayoutEng.GetMaxVersion: Word;
begin
  Result := $2FF;
end;

constructor TXmlLayoutEng13.Create(AOwner: TKBLayoutFormats);
begin
  inherited Create(AOwner);
  FXml := TXmlParser.Create;
end;

destructor TXmlLayoutEng13.Destroy;
begin
  FXml.Free;
  inherited Destroy;
end;

procedure TXmlLayoutEng13.SaveCodes(Codes: TScanCodes; Root: TXmlItem;
  const ParentName: string);
var
  i, j: Integer;
  Item: TXmlItem;
  Parent: TXmlItem;
  ScanCode: TScanCode;
begin
  if Codes.Count = 0 then Exit;
  Parent := Root.New(ParentName);
  j := 0;
  for i := 0 to Codes.Count-1 do
  begin
    ScanCode := Codes[i];
    if ScanCode.CodeType = ctMake then
    begin
      Item := Parent.New(S_SCANCODE);
      Item.Params.Values[S_SCANCODE_NUMBER] := IntToStr(j+1);
      if Length(ScanCode.Code) > 1 then
      begin
        Item.Params.Values[S_SCANCODE_CODE] := IntToStr(Byte(ScanCode.Code[2]));
        Item.Params.Values[S_SCANCODE_EXTCODE] := IntToStr(Byte(ScanCode.Code[1]));
      end else
      begin
        Item.Params.Values[S_SCANCODE_CODE] := IntToStr(Byte(ScanCode.Code[1]));
        Item.Params.Values[S_SCANCODE_EXTCODE] := IntToStr(0);
      end;
      Item.Params.Values[S_SCANCODE_TEXT] := ScanCode.Text;
      j := j + 1;
    end;
  end;
end;

procedure TXmlLayoutEng13.SaveGroups(Groups: TKeyGroups; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
  Group: TKeyGroup;
begin
  for i := 0 to Groups.Count-1 do
  begin
    Group := Groups[i];
    Item := Parent.New(S_KEYGROUP);
    Item.Params.Values[S_KEYGROUP_TOP] := IntToStr(Group.Rect.Top);
    Item.Params.Values[S_KEYGROUP_LEFT] := IntToStr(Group.Rect.Left);
    Item.Params.Values[S_KEYGROUP_RIGHT] := IntToStr(Group.Rect.Right);
    Item.Params.Values[S_KEYGROUP_BOTTOM] := IntToStr(Group.Rect.Bottom);
  end;
end;

procedure TXmlLayoutEng13.LoadCodes(Codes: TScanCodes; Parent: TXmlItem);
begin
  if FLayout.FileVersion = 0 then
    LoadCodes0(Codes, Parent)
  else
    LoadCodes1(Codes, Parent);
end;

procedure TXmlLayoutEng13.LoadCodes0(Codes: TScanCodes; Parent: TXmlItem);
var
  S: string;
  i: Integer;
  Code: Word;
  HiCode: Byte;
  LoCode: Byte;
  Item: TXmlItem;
  Count: Integer;
  ScanCode: TScanCode;
begin
  Codes.Clear;
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_SCANCODE) then
    begin
      S := Item.Params.Values[S_SCANCODE_CODE];
      if S <> '' then LoCode := StrToInt(S)
      else LoCode := 0;
      { Extended }
      S := Item.Params.Values[S_SCANCODE_EXTCODE];
      if S <> '' then HiCode := StrToInt(S)
      else HiCode := 0;

      Code := (HiCode shl 8) + LoCode;
      Codes.AddCode(Code);
    end;
  end;
  // Add break codes
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

procedure TXmlLayoutEng13.LoadCodes1(Codes: TScanCodes; Parent: TXmlItem);
begin
  Codes.AsText := Parent.Params.Values[S_SCANCODES];
end;

procedure TXmlLayoutEng13.LoadGroups(Groups: TKeyGroups; Parent: TXmlItem);
var
  S: string;
  i: Integer;
  Rect: TGridRect;
  Item: TXmlItem;
  Group: TKeyGroup;
begin
  Groups.Clear;
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_KEYGROUP) then
    begin
      Group := Groups.Add;
      // Top
      S := Item.Params.Values[S_KEYGROUP_TOP];
      if S <> '' then Rect.Top := StrToInt(S);
      // Left
      S := Item.Params.Values[S_KEYGROUP_LEFT];
      if S <> '' then Rect.Left := StrToInt(S);
      // Right
      S := Item.Params.Values[S_KEYGROUP_RIGHT];
      if S <> '' then Rect.Right := StrToInt(S);
      // Bottom
      S := Item.Params.Values[S_KEYGROUP_BOTTOM];
      if S <> '' then Rect.Bottom := StrToInt(S);
      Group.Rect := Rect;
    end;
  end;
end;

procedure TXmlLayoutEng13.SaveNote(Note: TNote; Parent: TXmlItem);
begin
  Parent.Params.Values[S_NOTE_NOTE] := IntToStr(Note.Note);
  Parent.Params.Values[S_NOTE_TIME] := IntToStr(Note.Interval);
  Parent.Params.Values[S_NOTE_VOLUME] := IntToStr(Note.Volume);
end;

procedure TXmlLayoutEng13.LoadNote(Note: TNote; Parent: TXmlItem);
var
  S: string;
begin
  { Note }
  S := Parent.Params.Values[S_NOTE_NOTE];
  if S <> '' then Note.Note := StrToInt(S);
  { Note duration }
  S := Parent.Params.Values[S_NOTE_TIME];
  if S <> '' then Note.Interval := StrToInt(S);
  { Note volume }
  S := Parent.Params.Values[S_NOTE_VOLUME];
  if S <> '' then Note.Volume := StrToInt(S);
end;

procedure TXmlLayoutEng13.SaveNotes(Notes: TNotes; Root: TXmlItem;
  const ParentName: string);
var
  i: Integer;
  Item: TXmlItem;
  Parent: TXmlItem;
begin
  if Notes.Count = 0 then Exit;
  Parent := Root.New(ParentName);
  for i := 0 to Notes.Count-1 do
  begin
    Item := Parent.New(S_NOTE);
    Item.Params.Values[S_NOTE_NUMBER] := IntToStr(i+1);
    SaveNote(Notes[i], Item);
  end;
end;

procedure TXmlLayoutEng13.LoadNotes(Notes: TNotes; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  Notes.Clear;
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_NOTE) then
      LoadNote(Notes.Add, Item);
  end;
end;

procedure TXmlLayoutEng13.SaveLayer(Layer: TLayer; Parent: TXmlItem);
var
  Item: TXmlItem;
begin
  { Keys }
  if Layer.Keys.Count > 0 then
  begin
    Item := Parent.New(S_LAYER_KEYS);
    SaveKeys(Layer.Keys, Item);
  end;
  { MSR }
  Item := Parent.New(S_LAYER_MSR);
  SaveMSR(Layer.MSR, Item);
  { KeyLock }
  SaveKeyLock(Layer.KeyLock, Parent, S_LAYER_KEYLOCK);
end;

procedure TXmlLayoutEng13.SaveLayers(Layers: TLayers; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  for i := 0 to Layers.Count-1 do
  begin
    Item := Parent.New(S_LAYER);
    SaveLayer(Layers[i], Item);
  end;
end;

procedure TXmlLayoutEng13.LoadLayer(Layer: TLayer; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    { Keys }
    if Item.NameIsEqual(S_LAYER_KEYS) then
      LoadKeys(Layer.Keys, Item);
    { MSR }
    if Item.NameIsEqual(S_LAYER_MSR) then
      LoadMSR(Layer.MSR, Item);
    { KeyLock }
    if Item.NameIsEqual(S_LAYER_KEYLOCK) then
      LoadKeyLock(Layer.KeyLock, Item);
  end;
end;

procedure TXmlLayoutEng13.SaveKey(Key: TKey; Parent: TXmlItem);
begin
  Parent.Params.Values[S_KEY_COL] := IntToStr(Key.Col);
  Parent.Params.Values[S_KEY_ROW] := IntToStr(Key.Row);
  Parent.Params.Values[S_KEY_TEXT] := Key.Text;
  Parent.Params.Values[S_KEY_REPEATKEY] := BoolToStr[Key.RepeatKey];
  Parent.Params.Values[S_LAYER_KEYTYPE] := IntToStr(KeyTypeToInt(Key.KeyType));
  { Press codes }
  SaveCodes(Key.PressCodes, Parent, S_KEY_PRESSCODES);
  { Release codes }
  SaveCodes(Key.ReleaseCodes, Parent, S_KEY_RELEASECODES);
  { Notes }
  SaveNotes(Key.Notes, Parent, S_KEY_NOTES);
end;

procedure TXmlLayoutEng13.LoadLayers(Layers: TLayers; Parent: TXmlItem);
var
  i: Integer;
  Layer: TLayer;
  Item: TXmlItem;
begin
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_LAYER) then
    begin
      if i < Layers.Count then
      begin
        Layer := Layers[i];
        LoadLayer(Layer, Item);
      end;
    end;
  end;
end;

procedure TXmlLayoutEng13.LoadKey(Keys: TKeys; Parent: TXmlItem);
var
  S: string;
  Key: TKey;
  i: Integer;
  Col: Integer;
  Row: Integer;
  Item: TXmlItem;
begin
  // Column
  S := Parent.Params.Values[S_KEY_COL];
  if S <> '' then Col := StrToInt(S) else Exit;
  // Row
  S := Parent.Params.Values[S_KEY_ROW];
  if S <> '' then Row := StrToInt(S) else Exit;
  // Find key
  Key := Keys.FindItem(Col, Row);
  if Key = nil then Exit;
  // Chnage layer key 
  S := Parent.Params.Values[S_LAYER_KEYTYPE];
  if S <> '' then Key.KeyType := IntToKeyType(StrToInt(S));
  // Text
  Key.Text := Parent.Params.Values[S_KEY_TEXT];
  // Repeat enbaled
  S := Parent.Params.Values[S_KEY_REPEATKEY];
  Key.RepeatKey := S = '1';
  // Number
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    { Press codes }
    if Item.NameIsEqual(S_KEY_PRESSCODES) then
      LoadCodes(Key.PressCodes, Item);
    { Release codes }
    if Item.NameIsEqual(S_KEY_RELEASECODES) then
      LoadCodes(Key.ReleaseCodes, Item);
    { Notes }
    if Item.NameIsEqual(S_KEY_NOTES) then
      LoadNotes(Key.Notes, Item);
  end;
end;

{ Saving keys }

procedure TXmlLayoutEng13.SaveKeys(Keys: TKeys; Parent: TXmlItem);
var
  i: Integer;
  Key: TKey;
  Item: TXmlItem;
begin
  for i := 0 to Keys.Count-1 do
  begin
    Key := Keys[i];
    Item := Parent.New(S_KEY);
    Item.Params.Values[S_KEY_NUMBER] := IntToStr(i+1);
    SaveKey(Key, Item);
  end;
end;

{ Writing MST track parameters - MSRTrack }

procedure TXmlLayoutEng13.SaveTrack(MSRTrack: TMSRTrack; Parent: TXmlItem);
begin
  { Parameters }
  Parent.Params.Values[S_TRACK_ENABLED] := BoolToStr[MSRTrack.Enabled];
  { Prefix }
  SaveCodes(MSRTrack.Prefix, Parent, S_TRACK_PREFIX);
  { Suffix }
  SaveCodes(MSRTrack.Suffix, Parent, S_TRACK_SUFFIX);
end;

{ Reading MSR track parameters - MSRTrack }

procedure TXmlLayoutEng13.LoadTrack(MSRTrack: TMSRTrack; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  { Parameters }
  MSRTrack.Enabled := Parent.Params.Values[S_TRACK_ENABLED] = '1';

  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    { Prefix }
    if Item.NameIsEqual(S_TRACK_PREFIX) then
      LoadCodes(MSRTrack.Prefix, Item);
    { Suffix }
    if Item.NameIsEqual(S_TRACK_SUFFIX) then
      LoadCodes(MSRTrack.Suffix, Item);
  end;
end;

{ Writing MSR parameters }

procedure TXmlLayoutEng13.SaveMSR(MSR: TMSR; Parent: TXmlItem);
var
  Item: TXmlItem;
begin
  { Parameters }
  Parent.Params.Values[S_MSR_SENDENTER] := BoolToStr[MSR.SendEnter];
  Parent.Params.Values[S_MSR_LOCKONERR] := BoolToStr[MSR.LockOnErr];
  { Track 1}
  Item := Parent.New(S_MSR_TRACK1);
  SaveTrack(MSR.Tracks[0], Item);
  { Track 2}
  Item := Parent.New(S_MSR_TRACK2);
  SaveTrack(MSR.Tracks[1], Item);
  { Track 3}
  Item := Parent.New(S_MSR_TRACK3);
  SaveTrack(MSR.Tracks[2], Item);
  { Notes }
  SaveNotes(MSR.Notes, Parent, S_MSR_NOTES);
end;

{ Reading MSR parameters }

procedure TXmlLayoutEng13.LoadMSR(MSR: TMSR; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  { Parameters }
  MSR.SendEnter := Parent.Params.Values[S_MSR_SENDENTER] = '1';
  MSR.LockOnErr := Parent.Params.Values[S_MSR_LOCKONERR] = '1';

  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    { Track 1 }
    if Item.NameIsEqual(S_MSR_TRACK1) then
      LoadTrack(MSR.Tracks[0], Item);
    { Track 2 }
    if Item.NameIsEqual(S_MSR_TRACK2) then
      LoadTrack(MSR.Tracks[1], Item);
    { Track 3 }
    if Item.NameIsEqual(S_MSR_TRACK3) then
      LoadTrack(MSR.Tracks[2], Item);
    { Notes }
    if Item.NameIsEqual(S_MSR_NOTES) then
      LoadNotes(MSR.Notes, Item);
  end;
end;

procedure TXmlLayoutEng13.LoadKeys(Keys: TKeys; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_KEY) then
    begin
      LoadKey(Keys, Item);
    end;
  end;
end;

procedure TXmlLayoutEng13.LoadLayout(Layout: TKBLayout);
var
  S: string;
  i: Integer;
  Item: TXmlItem;
  Parent: TXmlItem;
  HasParams: Boolean;
  LayoutVersion: Word;
  KeyboardID: Integer;
  Selection: TGridRect;
  Keyboard: TKeyboard;
begin
  LayoutVersion := 0;
  Parent := Xml.Root;
  // Layout parameters
  FLayout.FileVersion := 0;
  S := Parent.Params.Values['Vesion'];
  if S <> '' then
  begin
    S := HexToStr(S);
    FLayout.FileVersion := Byte(S[1]) + Byte(S[2]);
    LayoutVersion := FLayout.FileVersion;
  end;

  HasParams := False;
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_LAYOUT_PARAMS) then
    begin
      HasParams := True;
      // Top
      S := Item.Params.Values[S_LAYOUT_STOP];
      if S <> '' then Selection.Top := StrToInt(S);
      // Left
      S := Item.Params.Values[S_LAYOUT_SLEFT];
      if S <> '' then Selection.Left := StrToInt(S);
      // Right
      S := Item.Params.Values[S_LAYOUT_SRIGHT];
      if S <> '' then Selection.Right := StrToInt(S);
      // Bottom
      S := Item.Params.Values[S_LAYOUT_SBOTTOM];
      if S <> '' then Selection.Bottom := StrToInt(S);
      Layout.Selection := Selection;
      if FLayout.FileVersion = 0 then
      begin
        // Version 1.3
        S := Item.Params.Values[S_LAYOUT_MODEL];
        if S = '' then KeyboardID := 4
        else KeyboardID := StrToInt(S)+1;
        Keyboard := Keyboards.ItemByID(KeyboardID);
        Layout.Keyboard := Keyboard;
      end else
      begin
        case LayoutVersion of
          $0208:
          begin
            // Model
            S := Item.Params.Values[S_LAYOUT_MODEL];
            if S = '' then KeyboardID := 4
            else KeyboardID := StrToInt(S)+1;
            Keyboard := Keyboards.ItemByID(KeyboardID);
            Layout.Keyboard := Keyboard;
          end;
          $0209:
          begin
            //KeyboardID
            S := Item.Params.Values[S_LAYOUT_KEYBOARDID];
            if S = '' then KeyboardID := 4
            else KeyboardID := StrToInt(S);
            Keyboard := Keyboards.ItemByID(KeyboardID);
            Layout.Keyboard := Keyboard;
          end;
        end;
      end;
    end;
  end;

  if not HasParams then
    InvalidFileFormat(MsgLayoutParametersNotFound);

  // Layout data
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    // Layers
    if Item.NameIsEqual(S_LAYOUT_LAYERS) then
      LoadLayers(Layout.Layers, Item);
    // Groups
    if Item.NameIsEqual(S_KEYGROUPS) then
      LoadGroups(Layout.KeyGroups, Item);
  end;
  Layout.UpdateKeys;
end;

procedure TXmlLayoutEng13.SaveLayout(Layout: TKBLayout);
var
  Item: TXmlItem;
begin
  Xml.Clear;
  Xml.SetRootName(S_LAYOUT);
  { Parameters }
  Item := Xml.Root.New(S_LAYOUT_PARAMS);
  Item.Params.Values[S_LAYOUT_MODEL] := IntToStr(Layout.KeyboardID-1);
  Item.Params.Values[S_LAYOUT_STOP] := IntToStr(Layout.Selection.Top);
  Item.Params.Values[S_LAYOUT_SLEFT] := IntToStr(Layout.Selection.Left);
  Item.Params.Values[S_LAYOUT_SRIGHT] := IntToStr(Layout.Selection.Right);
  Item.Params.Values[S_LAYOUT_SBOTTOM] := IntToStr(Layout.Selection.Bottom);

  { Keys }
  if Layout.Layers.Count > 0 then
  begin
    Item := Xml.Root.New(S_LAYOUT_LAYERS);
    SaveLayers(Layout.Layers, Item);
  end;
  { Groups }
  if Layout.KeyGroups.Count > 0 then
  begin
    Item := Xml.Root.New(S_KEYGROUPS);
    SaveGroups(Layout.KeyGroups, Item);
  end;
end;

procedure TXmlLayoutEng13.SaveToStream(Layout: TKBLayout; Stream: TStream);
begin
  FLayout := Layout;
  SaveLayout(Layout);
  Xml.SaveToStream(Stream);
end;

procedure TXmlLayoutEng13.LoadFromStream(Layout: TKBLayout; Stream: TStream);
begin
  FLayout := Layout;
  Xml.LoadFromStream(Stream);
  LoadLayout(Layout);
end;

procedure TXmlLayoutEng13.SaveToFile(Layout: TKBLayout; const FileName: string);
begin
  FLayout := Layout;
  SaveLayout(Layout);
  Xml.SaveToFile(FileName);
end;

procedure TXmlLayoutEng13.LoadFromFile(Layout: TKBLayout; const FileName: string);
begin
  FLayout := Layout;
  Xml.LoadFromFile(FileName);
  LoadLayout(Layout);
  Layout.Saved(FileName);
end;

{ Reading keylock parameters }

procedure TXmlLayoutEng13.LoadKeyLock(KeyLock: TKeyLock; Parent: TXmlItem);
var
  i: Integer;
  Item: TXmlItem;
begin
  KeyLock.Clear;
  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    if Item.NameIsEqual(S_KEYLOCK_POSITION) then
    begin
      LoadKeyPosition(KeyLock.Add, Item);
    end;
  end;
end;

{ Read keylock position parameters }

procedure TXmlLayoutEng13.LoadKeyPosition(KeyPosition: TKeyPosition;
  Parent: TXmlItem);
var
  S: string;
  i: Integer;
  Item: TXmlItem;
begin
  { Position type }
  S := Parent.Params.Values[S_KEYPOS_TYPE];
  if S <> '' then KeyPosition.PosType := IntToPosType(StrToInt(S));
  { Lock enabled }
  KeyPosition.LockEnabled := Parent.Params.Values[S_KEYPOS_LOCK] = '1';
  { NCRemulation }
  KeyPosition.NcrEmulation := Parent.Params.Values[S_KEYPOS_NcrEmulation] = '1';
  // NixdorfEmulation
  KeyPosition.NixdorfEmulation := Parent.Params.Values['NixdorfEmulation'] = '1';

  for i := 0 to Parent.Count-1 do
  begin
    Item := Parent[i];
    { Scancodes }
    if Item.NameIsEqual(S_KEYPOS_CODES) then
      LoadCodes(KeyPosition.Codes, Item);
    { Notes }
    if Item.NameIsEqual(S_KEYPOS_NOTES) then
      LoadNotes(KeyPosition.Notes, Item);
  end;
end;

{ Write keylock parameters }

procedure TXmlLayoutEng13.SaveKeyLock(KeyLock: TKeyLock; Root: TXmlItem;
  const ParentName: string);
var
  i: Integer;
  Item: TXmlItem;
  Parent: TXmlItem;
begin
  if KeyLock.Count = 0 then Exit;
  Parent := Root.New(ParentName);
  for i := 0 to KeyLock.Count-1 do
  begin
    Item := Parent.New(S_KEYLOCK_POSITION);
    Item.Params.Values[S_KEYLOCK_POSNUM] := IntToStr(i+1);

    SaveKeyPosition(KeyLock[i], Item);
  end;
end;

{ Write keylock position parameters }

procedure TXmlLayoutEng13.SaveKeyPosition(KeyPosition: TKeyPosition;
  Parent: TXmlItem);
begin
  { Position type }
  Parent.Params.Values[S_KEYPOS_TYPE] := IntToStr(PosTypeToInt(KeyPosition.PosType));
  { Lock enabled }
  Parent.Params.Values[S_KEYPOS_LOCK] := BoolToStr[KeyPosition.LockEnabled];
  { NCR emulation }
  Parent.Params.Values[S_KEYPOS_NcrEmulation] := BoolToStr[KeyPosition.NcrEmulation];
  // Nixdorf emulation
  Parent.Params.Values['NixdorfEmulation'] := BoolToStr[KeyPosition.NixdorfEmulation];
  { Scancodes }
  SaveCodes(KeyPosition.Codes, Parent, S_KEYPOS_CODES);
  { Notes }
  SaveNotes(KeyPosition.Notes, Parent, S_KEYPOS_NOTES);
end;

function TXmlLayoutEng13.GetFilter: string;
begin
  Result := MsgXmlLayout13;
end;

function TXmlLayoutEng13.GetMinVersion: Word;
begin
  Result := $100;
end;

function TXmlLayoutEng13.GetMaxVersion: Word;
begin
  Result := $1FF;
end;

end.
