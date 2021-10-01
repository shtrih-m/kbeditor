unit xmlKeyboard;

interface

uses
  // VCL
  Classes, SysUtils,
  // This
  Keyboard, XmlParser, Utils, LogFile;

type
  { TXmlKeyboard }

  TXmlKeyboard = class
  private
    procedure LoadKeyDef(Root: TXmlItem; KeyDef: TKeyDef);
    procedure LoadKeyboard(Root: TXmlItem; Keyboard: TKeyboard);
    procedure LoadParamsGroup(Root: TXmlItem; Param: TKeyboardParam);
    procedure LoadKeyboardParam(Root: TXmlItem; Param: TKeyboardParam);
    procedure LoadKeyboardParams(Root: TXmlItem; Params: TKeyboardParams);
    procedure LoadKeyboardFromFile(const FileName: string; Keyboard: TKeyboard);
  public
    procedure LoadKeyboards(const Path: string; Keyboards: TKeyboards);
  end;

implementation

resourcestring
  MsgKeyDefNotFound             = 'Key defs not found';
  MsgInvalidRootName            = 'Invalid root name';
  MsgKeyboardPathNotExists      = 'Keyboard defs load failed.'#13#10+
                                  'Directory does not exist "%s"';
  MsgNoKeyboardDefFound         = 'Keyboards defs not found in directory %s';

const
  KEY_TAG               = 'Key';
  PARAM_TAG             = 'Param';
  GROUP_TAG             = 'Group';
  PRAM_MODEL            = 'Model';
  PRAM_NAME             = 'Name';
  PRAM_GroupName        = 'GroupName';

  PARAM_ID              = 'ID';
  PARAM_HEIGHT          = 'Height';
  PARAM_WIDTH           = 'Width';
  PRAM_LAYERS           = 'Layers';

{ TXmlKeyboard }

procedure TXmlKeyboard.LoadKeyboardFromFile(const FileName: string; Keyboard: TKeyboard);
var
  XML: TXMLParser;
begin
  XML := TXMLParser.Create;
  try
    XML.LoadFromFile(FileName);
    LoadKeyboard(Xml.Root, Keyboard);
  finally
    XML.Free;
  end;
end;

procedure TXmlKeyboard.LoadKeyboards(const Path: string; Keyboards: TKeyboards);
var
  i: Integer;
  FileNames: TStrings;
begin
  if not DirectoryExists(Path) then
    raise Exception.CreateFmt(MsgKeyboardPathNotExists, [Path]);

  Keyboards.Clear;
  FileNames := TStringList.Create;
  try
    ReadXmlFileNames(Path, FileNames);
    for i := 0 to FileNames.Count-1 do
    begin
      try
        LoadKeyboardFromFile(FileNames[i], Keyboards.Add);
      except
        on E: Exception do
        begin
          Logger.Error('LoadKeyboardFromFile: ' + E.Message);
        end;
      end;
    end;
  finally
    FileNames.Free;
  end;
  if Keyboards.Count = 0 then
    raise Exception.CreateFmt(MsgNoKeyboardDefFound, [Path]);
end;

procedure TXmlKeyboard.LoadKeyboard(Root: TXmlItem; Keyboard: TKeyboard);
var
  S: string;
  i: Integer;
  XmlItem: TXMLItem;
begin
  if not Root.NameIsEqual('keyboard') then
    raise Exception.Create(MsgInvalidRootName);
  if Root.Count < 1 then
    raise Exception.Create(MsgKeyDefNotFound);

  Keyboard.ID := StrToInt(Root.Params.Values['ID']);
  Keyboard.ModelID := StrToInt(Root.Params.Values['ModelID']);
  Keyboard.Text := Root.Params.Values[PRAM_NAME];
  Keyboard.GroupName := Root.Params.Values[PRAM_GroupName];
  Keyboard.RowCount := StrToInt(Root.Params.Values[PARAM_HEIGHT]);
  Keyboard.ColCount := StrToInt(Root.Params.Values[PARAM_WIDTH]);
  Keyboard.LayerCount := StrToInt(Root.Params.Values[PRAM_LAYERS]);
  // HasLeds
  S := Root.Params.Values['HasLeds'];
  if S <> '' then Keyboard.HasLeds := Boolean(StrToInt(S));
  // KeyPos
  S := Root.Params.Values['KeyPos'];
  if S <> '' then Keyboard.PosCount := StrToInt(S);
  // HasReader
  S := Root.Params.Values['HasReader'];
  if S <> '' then Keyboard.HasMSR := Boolean(StrToInt(S));
  // Track1
  S := Root.Params.Values['Track1'];
  if S <> '' then Keyboard.HasMSRTrack1 := Boolean(StrToInt(S));
  // Track2
  S := Root.Params.Values['Track2'];
  if S <> '' then Keyboard.HasMSRTrack2 := Boolean(StrToInt(S));
  // Track3
  S := Root.Params.Values['Track3'];
  if S <> '' then Keyboard.HasMSRTrack3 := Boolean(StrToInt(S));
  // InterfaceType
  S := Root.Params.Values['InterfaceType'];
  if S <> '' then Keyboard.InterfaceType := S;

  for i := 0 to Root.Count-1 do
  begin
    XmlItem := Root[i];
    if XmlItem.NameIsEqual(KEY_TAG) then
      LoadKeyDef(XmlItem, Keyboard.KeyDefs.Add);

    if XmlItem.NameIsEqual('Params') then
      LoadKeyboardParams(XmlItem, Keyboard.Params);
  end;
end;

procedure TXmlKeyboard.LoadKeyboardParams(Root: TXmlItem; Params: TKeyboardParams);
var
  i: Integer;
  XmlItem: TXmlItem;
begin
  for i := 0 to Root.Count-1 do
  begin
    XmlItem := Root[i];
    if XmlItem.NameIsEqual('Group')or XmlItem.NameIsEqual('Param') then
      LoadParamsGroup(XmlItem, Params.Add);
  end;
end;

procedure TXmlKeyboard.LoadParamsGroup(Root: TXmlItem; Param: TKeyboardParam);
var
  i: Integer;
  XmlItem: TXmlItem;
begin
  Param.Text := Root.Params.Values['Name'];
  for i := 0 to Root.Count-1 do
  begin
    XmlItem := Root[i];
    if XmlItem.NameIsEqual('Param') then
      LoadKeyboardParam(XmlItem, Param.Items.Add);
  end;
end;

procedure TXmlKeyboard.LoadKeyboardParam(Root: TXmlItem; Param: TKeyboardParam);
var
  i: Integer;
begin
  Param.Items.Clear;
  Param.Text := Root.Params.Values['Name'];
  Param.Value := Root.Params.Values['Value'];

  for i := 0 to Root.Count-1 do
    LoadKeyboardParam(Root[i], Param.Items.Add);

end;

procedure TXmlKeyboard.LoadKeyDef(Root: TXmlItem; KeyDef: TKeyDef);
begin
  KeyDef.Top := StrToInt(Root.Params.Values['Top']);
  KeyDef.Left := StrToInt(Root.Params.Values['Left']);
  KeyDef.LogicNumber := StrToInt(Root.Params.Values['LogicalNumber']);
end;

end.
