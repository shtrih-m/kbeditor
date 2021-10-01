unit xmlParser;

interface

uses
  // VCL
  Classes, SysUtils, ActiveX, ComObj,
  // This
  MSXML, Utils;

type
  TXmlItem = class;

  { TXmlParser }

  TXmlParser = class
  private
    FRoot: TXmlItem;
    FxmlDoc: IXMLDOMDocument;

    procedure UpdateItems;
    procedure CreateProcessingInstruction;
    procedure ConvertFile(const FileName: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure SetRootName(const Name: string);
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromString(const Data: string);

    property Root: TXmlItem read FRoot;
    property xmlDoc: IXMLDOMDocument read FxmlDoc;
  end;

  { TXmlItemParams }

  TXmlItemParams = class
  private
    FxmlNode: IXMLDOMNode;
    function GetValue(const Name: string): string;
    procedure SetValue(const Name, Value: string);
    function GetCount: Integer;
  public
    constructor Create(AxmlNode: IXMLDOMNode);

    property Count: Integer read GetCount;
    property Values[const Name: string]: string read GetValue write SetValue;
  end;

  { TXmlItem }

  TXmlItem = class
  private
    FList: TList;
    FOwner: TXmlItem;
    FxmlNode: IXMLDOMNode;
    FParams: TXmlItemParams;

    procedure Clear;
    function GetName: string;
    function Get_Text: string;
    procedure CreateChildItems;
    function GetCount: Integer;
    function GetParams: TXmlItemParams;
    procedure SetOwner(AOwner: TXmlItem);
    procedure InsertItem(AItem: TXmlItem);
    procedure RemoveItem(AItem: TXmlItem);
    procedure SetText(const Value: string);
    function Get_Item(const Index: Integer): TXmlItem;
  public
    constructor Create(AOwner: TXmlItem; AxmlNode: IXMLDOMNode);
    destructor Destroy; override;

    function Add(const Name: string): TXmlItem;
    function New(const Name: string): TXmlItem;
    procedure AddText(const Name, Text: string);
    function GetText(const Name: string): string;
    function GetInt(const Name: string): Integer;
    function GetBool(const Name: string): Boolean;
    function GetItem(const Name: string): TXmlItem;
    function FindItem(const Name: string): TXmlItem;
    function NameIsEqual(const AName: string): Boolean;
    procedure AddInt(const Name: string; Value: Integer);
    procedure AddBool(const Name: string; Value: Boolean);

    property Count: Integer read GetCount;
    property Node: IXMLDOMNode read FxmlNode;
    property Params: TXmlItemParams read GetParams;
    property Text: string read Get_Text write SetText;
    property Items[const Index: Integer]: TXmlItem read Get_Item; default;
  end;

procedure TextToFile(const Text, FileName: string);
procedure TextToXmlFile(const Text, FileName: string);

implementation

resourcestring
  MsgElementNotFound    = 'Element %s not found';
  MsgFileReadError      = 'File read error %s.'#13#10'%s';
  MsgXmlReadError       = 'Xml document read error';



procedure TextToXmlFile(const Text, FileName: string);
var
  xml: TXmlParser;
begin
  xml := TXmlParser.Create;
  try
    xml.xmlDoc.LoadXml(Text);
    xml.SaveToFile(FileName);
  finally
    xml.Free;
  end;
end;

// Make XML document readable

function GetXml(const Data: string): string;
begin
  Result := StringReplace(Data, '><', '>'#13#10'<', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TextToFile(const Text, FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    if Length(Text) > 0 then
      Stream.Write(Text[1], Length(Text));
  finally
    Stream.Free;
  end;
end;

{ TXmlParser }

constructor TXmlParser.Create;
begin
  inherited Create;
  FxmlDoc := CoDOMDocument.Create;
  FxmlDoc.async := False;
  CreateProcessingInstruction;
  FxmlDoc.documentElement := FxmlDoc.createElement('root');
  FRoot := TXmlItem.Create(nil, xmlDoc.documentElement);
end;

destructor TXmlParser.Destroy;
begin
  FRoot.Free;
  FxmlDoc := nil;
  inherited Destroy;
end;

procedure TXmlParser.CreateProcessingInstruction;
var
  ProcessingInstruction: IXMLDOMProcessingInstruction;
begin
  ProcessingInstruction := xmlDoc.createProcessingInstruction('xml',
    'version=''1.0'' encoding=''windows-1251''');
  xmlDoc.appendChild(ProcessingInstruction);
end;

procedure TXmlParser.SetRootName(const Name: string);
begin
  FRoot.Free;
  FxmlDoc.documentElement := FxmlDoc.createElement(Name);
  FRoot := TXmlItem.Create(nil, xmlDoc.documentElement);
end;

procedure TXmlParser.UpdateItems;
begin
  FRoot.Free;
  FRoot := TXmlItem.Create(nil, xmlDoc.documentElement);
  FRoot.CreateChildItems;
end;

procedure TXmlParser.SaveToStream(Stream: TStream);
var
  OleStream: IStream;
begin
  OleStream := TStreamAdapter.Create(stream);
  xmlDoc.Save(OleStream);
end;

procedure TXmlParser.ConvertFile(const FileName: string);
var
  Data: string;
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenReadWrite);
  try
    if Stream.Size = 0 then Exit;
    SetLength(Data, Stream.Size);
    Stream.Read(Data[1], Stream.Size);
    Data := StringReplace(Data, '><', '>'#13#10'<', [rfReplaceAll, rfIgnoreCase]);
    if Length(Data) > 0 then
    begin
      Stream.Position := 0;
      Stream.Write(Data[1], Length(Data));
    end;
  finally
    Stream.Free;
  end;
end;

procedure TXmlParser.SaveToFile(const FileName: string);
begin
  xmlDoc.save(FileName);
  ConvertFile(FileName);
  xmlDoc.load(FileName);
  xmlDoc.save(FileName);
end;

procedure TXmlParser.LoadFromFile(const FileName: string);
begin
  if not xmlDoc.Load(FileName) then
    raise Exception.CreateFmt(MsgFileReadError,
      [FileName, xmlDoc.parseError.reason]);

  UpdateItems;
end;

procedure TXmlParser.Clear;
begin
  Root.Clear;
end;

procedure TXmlParser.LoadFromStream(Stream: TStream);
var
  OleStream: IStream;
begin
  OleStream := TStreamAdapter.Create(stream);
  if not xmlDoc.load(OleStream) then
    raise Exception.Create(MsgXmlReadError + #13#10 +
      xmlDoc.parseError.reason);
  UpdateItems;
end;

procedure TXmlParser.LoadFromString(const Data: string);
var
  Stream: TMemoryStream;
begin
  if Length(Data) > 0 then
  begin
    Stream := TMemoryStream.Create;
    try
      Stream.Write(Data[1], Length(Data));
      Stream.Position := 0;
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

{ TXmlItem }

procedure TXmlItem.Clear;
begin
  while Count > 0 do
    Items[0].Free;
end;

constructor TXmlItem.Create(AOwner: TXmlItem; AxmlNode: IXMLDOMNode);
begin
  inherited Create;
  FxmlNode := AxmlNode;
  FList := TList.Create;
  SetOwner(AOwner);

  if AxmlNode = nil then
    raise Exception.Create('AxmlNode = nil');
end;

destructor TXmlItem.Destroy;
begin
  SetOwner(nil);
  Clear;
  FList.Free;
  FxmlNode := nil;
  FParams.Free;
  inherited Destroy;
end;

procedure TXmlItem.SetOwner(AOwner: TXmlItem);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TXmlItem.InsertItem(AItem: TXmlItem);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TXmlItem.RemoveItem(AItem: TXmlItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TXmlItem.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TXmlItem.Get_Item(const Index: Integer): TXmlItem;
begin
  Result := TXmlItem(FList[Index]);
end;

procedure TXmlItem.CreateChildItems;
var
  i: Integer;
  Item: TXmlItem;
  childNodes: IXMLDOMNodeList;
begin
  Clear;
  childNodes := FxmlNode.childNodes;
  for i := 0 to childNodes.length-1 do
  begin
    Item := TXmlItem.Create(Self, childNodes.item[i]);
    Item.CreateChildItems;
  end;
end;

function TXmlItem.GetParams: TXmlItemParams;
begin
  if FParams = nil then
    FParams := TXmlItemParams.Create(FxmlNode);
  Result := FParams;
end;

function TXmlItem.New(const Name: string): TXmlItem;
var
  node: IXMLDOMElement;
begin
  node := FxmlNode.ownerDocument.createElement(Name);
  Result := TXmlItem.Create(Self, FxmlNode.appendChild(node));
end;

function TXmlItem.Add(const Name: string): TXmlItem;
var
  node: IXMLDOMElement;
begin
  node := FxmlNode.ownerDocument.createElement(Name);
  Result := TXmlItem.Create(Self, FxmlNode.appendChild(node));
end;

function TXmlItem.Get_Text: string;
begin
  Result := FxmlNode.text;
end;

procedure TXmlItem.SetText(const Value: string);
begin
  FxmlNode.text := Value;
end;

function TXmlItem.NameIsEqual(const AName: string): Boolean;
begin
  Result := AnsiCompareText(GetName, AName) = 0;
end;

function TXmlItem.FindItem(const Name: string): TXmlItem;
var
  i: Integer;
begin
  if NameIsEqual(Name) then
  begin
    Result := Self;
    Exit;
  end;

  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.NameIsEqual(Name) then Exit;
  end;
  Result := nil;
end;

function TXmlItem.GetName: string;
begin
  Result := FxmlNode.nodeName;
end;

procedure TXmlItem.AddText(const Name, Text: string);
begin
  Add(Name).Text := Text;
end;

procedure TXmlItem.AddInt(const Name: string; Value: Integer);
begin
  AddText(Name, IntToStr(Value));
end;

procedure TXmlItem.AddBool(const Name: string; Value: Boolean);
const
  BoolToStr: array [Boolean] of string = ('0', '1');
begin
  AddText(Name, BoolToStr[Value]);
end;

function TXmlItem.GetItem(const Name: string): TXmlItem;
begin
  Result := FindItem(Name);
  if Result = nil then
    raise Exception.CreateFmt(MsgElementNotFound, [Name]);
end;

function TXmlItem.GetText(const Name: string): string;
begin
  Result := GetItem(Name).Text;
end;

function TXmlItem.GetInt(const Name: string): Integer;
begin
  Result := StrToInt(GetText(Name));
end;

function TXmlItem.GetBool(const Name: string): Boolean;
begin
  Result := GetText(Name) = '1';
end;

{ TXmlItemParams }

constructor TXmlItemParams.Create(AxmlNode: IXMLDOMNode);
begin
  inherited Create;
  FxmlNode := AxmlNode;
  if AxmlNode = nil then
    raise Exception.Create('AxmlNode = nil');
end;

function TXmlItemParams.GetCount: Integer;
begin
  Result := FxmlNode.attributes.length;
end;

function TXmlItemParams.GetValue(const Name: string): string;
var
  node: IXMLDOMNode;
begin
  Result := '';
  node := FxmlNode.attributes.getNamedItem(Name);
  if node <> nil then Result := node.text;
end;

procedure TXmlItemParams.SetValue(const Name, Value: string);
var
  node: IXMLDOMNode;
  newAtt: IXMLDOMAttribute;
begin
  node := FxmlNode.attributes.getNamedItem(Name);
  if node <> nil then
  begin
    node.text := Value
  end else
  begin
    newAtt := FxmlNode.ownerDocument.createAttribute(Name);
    FxmlNode.attributes.setNamedItem(newAtt);
    newAtt.text := Value;
  end;
end;

initialization
  CoInitialize(nil);

end.
