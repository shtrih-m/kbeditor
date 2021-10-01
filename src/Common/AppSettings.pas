unit AppSettings;

interface

uses
  // VCL
  Windows, Classes, SysUtils, IniFiles, Graphics, Forms,
  // This
  Utils, FileUtils, LogFile, untVInfo;

type
  { TMRUList }

  TMRUList = class
  private
    FItems: TStrings;
    FMaxItems: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddItem(const FileName: string; const Data: Pointer);

    property Items: TStrings read FItems;
    property MaxItems: Integer read FMaxItems write FMaxItems default 4;
  end;

  { TAppSettings }

  TAppSettings = class(TComponent)
  private
    FFont: TFont;
    FMRUList: TMRUList;
    FDeviceName: string;
    FDefLogEnabled: Boolean;
    FDefLogFileName: string;

    function GetIniFileName: string;
    procedure SetFont(const Value: TFont);
    procedure SetDeviceName(const Value: string);

    property MRUList: TMRUList read FMRUList;
    function GetLogEnabled: Boolean;
    function GetLogFileName: string;
    procedure SetLogEnabled(const Value: Boolean);
    procedure SetLogFileName(const Value: string);
    procedure DoLoadSettings;
  public
    KeyboardID: Integer;
    LayerIndex: Integer;        // Active layer index
    ViewMode: TViewMode;        // View mode
    DockPanelHeight: Integer;
    MessageFormDocked: Boolean;
    SaveBeforeUpload: Boolean;
    CheckUpdateOnLoad: Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetDefaults;
    procedure SaveSettings;
    procedure LoadSettings;

    property Font: TFont read FFont write SetFont;
    property DefLogEnabled: Boolean read FDefLogEnabled;
    property DefLogFileName: string read FDefLogFileName;
    property DeviceName: string read FDeviceName write SetDeviceName;
    property LogEnabled: Boolean read GetLogEnabled write SetLogEnabled;
    property LogFileName: string read GetLogFileName write SetLogFileName;
  end;

procedure FreeSettings;
function Settings: TAppSettings;

implementation

const
  MRUSection            = 'MRU';
  SettingSection        = 'SETTINGS';

var
  FSettings: TAppSettings = nil;

function Settings: TAppSettings;
begin
  if FSettings = nil then
    FSettings := TAppSettings.Create(nil);
  Result := FSettings;
end;

procedure FreeSettings;
begin
  FSettings.Free;
  FSettings := nil;
end;

{ TAppSettings }

constructor TAppSettings.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont := TFont.Create;
  FMRUList := TMRUList.Create;
  FDefLogEnabled := False;
  FDefLogFileName := ChangeFileExt(FileUtils.GetModuleFileName, '.log');
  LoadSettings;
end;

destructor TAppSettings.Destroy;
begin
  FFont.Free;
  FMRUList.Free;
  inherited Destroy;
end;

function TAppSettings.GetIniFileName: string;
begin
  Result := ChangeFileExt(FileUtils.GetModuleFileName, '.ini');
end;

procedure TAppSettings.LoadSettings;
begin
  Logger.Debug('TAppSettings.LoadSettings');
  try
    SetDefaults;
    DoLoadSettings;
  except
    on E: Exception do
      Logger.Error('TAppSettings.LoadSettings: ' + E.Message);
  end;
end;

procedure TAppSettings.DoLoadSettings;
var
  i: Integer;
  Count: Integer;
  FileName: string;
  IniFile: TIniFile;
  KeyNames: TStrings;
  FilterIndex: Integer;
  Style: TFontStyles;
begin
  KeyNames := TStringList.Create;
  IniFile := TIniFile.Create(GetIniFileName);
  try
    DockPanelHeight := IniFile.ReadInteger(SettingSection, 'DockPanelHeight', 0);
    MessageFormDocked := IniFile.ReadBool(SettingSection, 'MessageFormDocked', False);
    DeviceName := IniFile.ReadString(SettingSection, 'DeviceName', PS2DeviceName);
    KeyboardID := IniFile.ReadInteger(SettingSection, 'KeyboardID', 1);
    SaveBeforeUpload := IniFile.ReadBool(SettingSection, 'SaveBeforeUpload', False);
    CheckUpdateOnLoad := IniFile.ReadBool(SettingSection, 'CheckUpdateOnLoad', True);
    ViewMode := TViewMode(IniFile.ReadInteger(SettingSection, 'ViewMode', Integer(vmLayout)));
    Font.PixelsPerInch := IniFile.ReadInteger(SettingSection, 'FontPixelsPerInch', 96);
    Font.Charset := TFontCharset(IniFile.ReadInteger(SettingSection, 'FontCharset', RUSSIAN_CHARSET));
    Font.Color := IniFile.ReadInteger(SettingSection, 'FontColor', 0);
    Font.Height := IniFile.ReadInteger(SettingSection, 'FontHeight', -11);
    Font.Size := IniFile.ReadInteger(SettingSection, 'FontSize', 8);
    i := IniFile.ReadInteger(SettingSection, 'FontStyle', 0);
    IntegerToSet(i, SizeOF(TFontStyle), Style);
    Font.Style := Style;
    Font.Name := IniFile.ReadString(SettingSection, 'FontName', 'MS Sans Serif');
    // MRU
    if IniFile.SectionExists(MRUSection) then
    begin
      IniFile.ReadSection(MRUSection, KeyNames);
      Count := KeyNames.Count div 2;
      for i := 0 to Count-1 do
      begin
        FileName := IniFile.ReadString(MRUSection, KeyNames[i*2], '');
        FilterIndex := IniFile.ReadInteger(MRUSection, KeyNames[i*2+1], 0);
        MRUList.AddItem(FileName, Pointer(FilterIndex));
      end;
    end;
    LogFileName := IniFile.ReadString(SettingSection, 'LogFileName', FDefLogFileName);
    LogEnabled := IniFile.ReadBool(SettingSection, 'LogEnabled', FDefLogEnabled);
  finally
    IniFile.Free;
    KeyNames.Free;
  end;
end;

procedure TAppSettings.SaveSettings;
var
  i: Integer;
  IniFile: TIniFile;
  Style: TFontStyles;
begin
  IniFile := TIniFile.Create(GetIniFileName);
  try
    IniFile.WriteInteger(SettingSection, 'DockPanelHeight', DockPanelHeight);
    IniFile.WriteBool(SettingSection, 'MessageFormDocked', MessageFormDocked);
    IniFile.WriteString(SettingSection, 'DeviceName', DeviceName);
    IniFile.WriteInteger(SettingSection, 'KeyboardID', KeyboardID);
    IniFile.WriteBool(SettingSection, 'SaveBeforeUpload', SaveBeforeUpload);
    IniFile.WriteBool(SettingSection, 'CheckUpdateOnLoad', CheckUpdateOnLoad);
    IniFile.WriteInteger(SettingSection, 'ViewMode', Integer(ViewMode));
    IniFile.WriteInteger(SettingSection, 'FontPixelsPerInch', Font.PixelsPerInch);
    IniFile.WriteInteger(SettingSection, 'FontCharset', Integer(Font.Charset));
    IniFile.WriteInteger(SettingSection, 'FontColor', Font.Color);
    IniFile.WriteInteger(SettingSection, 'FontHeight', Font.Height);
    IniFile.WriteString(SettingSection, 'FontName', Font.Name);
    IniFile.WriteInteger(SettingSection, 'FontSize', Font.Size);
    Style := Font.Style;
    IniFile.WriteInteger(SettingSection, 'FontStyle', SetToInteger(Style, SizeOf(TFontStyle)));
    // MRU
    for i := 0 to MRUList.Items.Count-1 do
    begin
      IniFile.WriteString(MRUSection, 'File' + IntToStr(i), MRUList.Items[i]);
      IniFile.WriteInteger(MRUSection, 'Filter' + IntToStr(i), Integer(MRUList.Items.Objects[i]));
    end;
    IniFile.WriteBool(SettingSection, 'LogEnabled', LogEnabled);
    IniFile.WriteString(SettingSection, 'LogFileName', LogFileName);
  except
    on E: Exception do
      Logger.Error('TAppSettings.SaveSettings: ' + E.Message);
  end;
  IniFile.Free;
end;

procedure TAppSettings.SetDefaults;
begin
  LogEnabled := False;
  LogFileName := ChangeFileExt(ParamStr(0), '.log');
end;

procedure TAppSettings.SetDeviceName(const Value: string);
begin
  FDeviceName := Value;
end;

procedure TAppSettings.SetFont(const Value: TFont);
var
  i: Integer;
begin
  FFont.Assign(Value);
  for i := 0 to Screen.FormCount-1 do
    Screen.Forms[i].Font := Value;
end;

procedure TAppSettings.SetLogEnabled(const Value: Boolean);
begin
  Logger.Enabled := Value;
end;

procedure TAppSettings.SetLogFileName(const Value: string);
begin
  Logger.FileName := Value;
end;

function TAppSettings.GetLogEnabled: Boolean;
begin
  Result := Logger.Enabled;
end;

function TAppSettings.GetLogFileName: string;
begin
  Result := Logger.FileName;
end;

{ TMRUList }

constructor TMRUList.Create;
begin
  inherited Create;
  FItems := TStringList.Create;
  FMaxItems := 4;
end;

destructor TMRUList.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TMRUList.AddItem(const FileName: string; const Data: Pointer);
var
  Index: Integer;
begin
  Index := Items.IndexOf(FileName);
  if Index <> -1 then
  begin
    Items[Index] := FileName;
  end;
end;

end.
