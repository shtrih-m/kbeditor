unit TestWizard;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Forms,
  // This
  KBLayout, KeyboardDriver, XmlParser, AppSettings, KeyboardManager, FileUtils,
  KeyboardProgram, KeyboardProgramXml, KeyboardTypes;

type
  { TTestWizard }

  TTestWizard = class(TComponent)
  private
    FLayout: TKBLayout;
    FNextEnabled: Boolean;
    FPrevEnabled: Boolean;
    FDeviceInfo: TDeviceInfo;

    procedure SetDefaults;
    function GetPath: string;
    function GetFileName: string;
    function GetKeyboardID: Integer;
    function GetProgramsPath: string;
    function GetProgramsFileName: string;
    procedure SetKeyboardID(const Value: Integer);
  public
    LayoutFileName: string;
    ProgramFileName: string;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GoNext;
    procedure GoPrev;
    procedure SaveParams;
    procedure LoadParams;
    procedure EnableNext(Value: Boolean);
    procedure EnablePrev(Value: Boolean);
    procedure Initialize(const ADeviceInfo: TDeviceInfo);

    property Layout: TKBLayout read FLayout;
    property DeviceInfo: TDeviceInfo read FDeviceInfo;
    property KeyboardID: Integer read GetKeyboardID write SetKeyboardID;
  end;

const
  MSR_SUFFIX = '+++';
  IBUTTON_SUFFIX = '---';

function Wizard: TTestWizard;

implementation

uses
  fmuMain;

var
  FWizard: TTestWizard;

function Wizard: TTestWizard;
begin
  if FWizard = nil then
    FWizard := TTestWizard.Create(nil);
  Result := FWizard;
end;

{ TTestWizard }

constructor TTestWizard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLayout := TKBLayout.Create(Self);
  FNextEnabled := True;
  FPrevEnabled := True;
  LoadParams;
end;

destructor TTestWizard.Destroy;
begin
  SaveParams;
  inherited Destroy;
end;

procedure TTestWizard.SetDefaults;
var
  Path: string;
const
  KeyboardName = 'KB-64RiB_v2.15.prg';
begin
  Path := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
  LayoutFileName := Format('%sData\Layouts\%s.xml', [Path, KeyboardName]);
  ProgramFileName := Format('%sData\Programs\%s', [Path, KeyboardName]);
end;

function TTestWizard.GetFileName: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.xml');
end;

procedure TTestWizard.LoadParams;
var
  i: Integer;
  xml: TXmlParser;
  xmlItem: TXmlItem;
begin
  SetDefaults;
  if not FileExists(GetFileName) then Exit;

  xml := TXmlParser.Create;
  try
    xml.LoadFromFile(GetFileName);
    for i := 0 to xml.Root.Count-1 do
    begin
      XmlItem := xml.Root[i];
      if XmlItem.NameIsEqual('LayoutFileName') then
        LayoutFileName := XmlItem.Text;
      if XmlItem.NameIsEqual('ProgramFileName') then
        ProgramFileName := XmlItem.Text;
    end;
  except
    { !!! }
  end;
  xml.Free;
end;

procedure TTestWizard.SaveParams;
var
  xml: TXmlParser;
begin
  xml := TXmlParser.Create;
  try
    xml.SetRootName(ExtractFileName(Application.ExeName));
    xml.Root.AddText('LayoutFileName', LayoutFileName);
    xml.Root.AddText('ProgramFileName', ProgramFileName);
    xml.SaveToFile(GetFileName);
  except
    { !!! }
  end;
  xml.Free;
end;

function TTestWizard.GetKeyboardID: Integer;
begin
  Result := Settings.KeyboardID;
end;

procedure TTestWizard.SetKeyboardID(const Value: Integer);
var
  Path: string;
begin
  Layout.Keyboard := Manager.Keyboards.ItemByID(Value);
  Settings.KeyboardID := Value;
  Settings.SaveSettings;

  Path := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
  LayoutFileName := Path + 'Data\Layouts\' + Layout.Keyboard.Text + '.xml';
  if ProgramFileName = '' then
    ProgramFileName := Path + 'Data\Programs\';
end;

function TTestWizard.GetPath: string;
begin
  Result := IncludeTrailingBackslash(ExtractFilePath(FileUtils.GetModuleFileName));
end;

function TTestWizard.GetProgramsPath: string;
begin
  Result := GetPath + 'Data\Programs\';
end;

function TTestWizard.GetProgramsFileName: string;
begin
  Result := GetProgramsPath + 'Programs.xml';
end;

procedure TTestWizard.Initialize(const ADeviceInfo: TDeviceInfo);
var
  Item: TKeyboardProgram;
  xml: TKeyboardProgramXml;
  Items: TKeyboardPrograms;
begin
  FDeviceInfo := ADeviceInfo;
  // Update ProgramFileName property
  Items := TKeyboardPrograms.Create;
  xml := TKeyboardProgramXml.Create;
  try
    xml.Load(Items, GetProgramsFileName);
    Item := Items.ItemByModel(ADeviceInfo.Model);
    if Item <> nil then
      ProgramFileName := GetProgramsPath + Item.FileName;
  finally
    xml.Free;
    Items.Free;
  end;
end;

procedure TTestWizard.EnableNext(Value: Boolean);
begin
  fmMain.btnNext.Enabled := Value;
  if Value then fmMain.btnNext.SetFocus;
end;

procedure TTestWizard.EnablePrev(Value: Boolean);
begin
  fmMain.btnPrev.Enabled := Value;
  if Value then fmMain.btnPrev.SetFocus;
end;

procedure TTestWizard.GoNext;
begin
  fmMain.GoNext;
end;

procedure TTestWizard.GoPrev;
begin
  fmMain.GoPrev;
end;

initialization

finalization
  FWizard.Free;
  FWizard := nil;

end.
