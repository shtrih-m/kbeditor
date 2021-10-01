unit KeyboardProgramXml;

interface

uses
  // VCK
  SysUtils,
  // This
  KeyboardProgram, XmlParser, LogFile;

type
  { TKeyboardProgramXml }

  TKeyboardProgramXml = class
  public
    procedure Load(Items: TKeyboardPrograms; const FileName: string);
    procedure Save(Items: TKeyboardPrograms; const FileName: string);
    procedure DoLoad(Items: TKeyboardPrograms; const FileName: string);
    procedure DoSave(Items: TKeyboardPrograms; const FileName: string);
  end;

implementation

const
  S_MODELID = 'Model';
  S_PROGRAM = 'Program';
  S_PROGRAMS = 'Programs';
  S_FILENAME = 'FileName';

{ TKeyboardProgramXml }

procedure TKeyboardProgramXml.Load(Items: TKeyboardPrograms;
  const FileName: string);
begin
  try
    DoLoad(Items, FileName);
  except
    on E: Exception do
    begin
      Logger.Error('Loading keyboard programs: ' + E.Message);
    end;
  end;
end;

procedure TKeyboardProgramXml.Save(Items: TKeyboardPrograms;
  const FileName: string);
begin
  try
    DoSave(Items, FileName);
  except
    on E: Exception do
    begin
      Logger.Error('Saving keyboard programs: ' + E.Message);
    end;
  end;
end;

procedure TKeyboardProgramXml.DoLoad(Items: TKeyboardPrograms;
  const FileName: string);
var
  i: Integer;
  Item: TXmlItem;
  xml: TXmlParser;
  Data: TKeyboardProgramRec;
begin
  xml := TXmlParser.Create;
  try
    xml.LoadFromFile(FileName);

    Items.Clear;
    for i := 0 to xml.Root.Count-1 do
    begin
      Item := xml.Root[i];
      if Item.NameIsEqual(S_PROGRAM) then
      begin
        Data.ModelID := Item.GetInt(S_MODELID);
        Data.FileName := Item.GetText(S_FILENAME);
        Items.Add(Data);
      end;
    end;
  finally
    xml.Free;
  end;
end;

procedure TKeyboardProgramXml.DoSave(Items: TKeyboardPrograms;
  const FileName: string);
var
  i: Integer;
  xml: TXmlParser;
  XmlItem: TXmlItem;
begin
  xml := TXmlParser.Create;
  try
    Xml.Clear;
    Xml.SetRootName(S_PROGRAMS);
    for i := 0 to Items.Count-1 do
    begin
      XmlItem := Xml.Root.Add(S_PROGRAM);
      XmlItem.AddInt(S_MODELID, Items[i].ModelID);
      XmlItem.AddText(S_FILENAME, Items[i].FileName);
    end;
    Xml.SaveToFile(FileName);
  finally
    Xml.Free;
  end;
end;

end.
