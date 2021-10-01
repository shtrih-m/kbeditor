unit XmlCodeTables;

interface

uses
  // VCL
  SysUtils,
  // This
  KBLayout, Utils, XmlParser, LogFile;

type
  { TXmlCodeTables }

  TXmlCodeTables = class
  private
    Xml: TXmlParser;
    procedure LoadCodeTable(Root: TXmlItem; CodeTable: TCodeTable);
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(const FileName: string; CodeTables: TCodeTables);
  end;

implementation

{ TXmlCodeTables }

constructor TXmlCodeTables.Create;
begin
  inherited Create;
  Xml := TXmlParser.Create;
end;

destructor TXmlCodeTables.Destroy;
begin
  Xml.Free;
  inherited Destroy;
end;

procedure TXmlCodeTables.LoadCodeTable(Root: TXmlItem; CodeTable: TCodeTable);
var
  i: Integer;
  xmlItem: TxmlItem;
  ScanCode, MakeCode, BreakCode, ScanText: string;
begin
  CodeTable.Text := Root.Params.Values['Name'];
  for i := 0 to Root.Count-1 do
  begin
    xmlItem := Root[i];
    ScanText := xmlItem.Params.Values['Name'];
    ScanCode := HexToStr(xmlItem.Params.Values['Scancode']);
    MakeCode := HexToStr(xmlItem.Params.Values['Makecode']);
    BreakCode := HexToStr(xmlItem.Params.Values['Breakcode']);
    CodeTable.Add(ScanText, ScanCode, MakeCode, BreakCode);
  end;
end;

procedure TXmlCodeTables.LoadFromFile(const FileName: string;
  CodeTables: TCodeTables);
var
  i: Integer;
begin
  Logger.Debug('TXmlCodeTables.LoadFromFile');

  CodeTables.Clear;
  xml.LoadFromFile(FileName);
  for i := 0 to xml.Root.Count-1 do
    LoadCodeTable(xml.Root[i], CodeTables.Add);

  Logger.Debug('TXmlCodeTables.LoadFromFile: OK');
end;


end.
