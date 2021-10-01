unit KeyboardReport;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ClipBrd,
  // This
  KeyboardDriver, KeyboardManager, Keyboardtypes, Utils, Keyboard, LogFile;

type
  { TKeyboardReport }

  TKeyboardReport = class
  private
    FLines: TStrings;
    FLayoutStatus: string;
    FShortingName: string;
    FShortingValue: string;
    FHasShortings: Boolean;
    FIsLayoutCorrupted: Boolean;
    FManager: TKeyboardManager;

    procedure Clear;
    procedure AddParameter(const Name, Value: string);
    procedure UpdateInfo(const LoaderInfo, ProgInfo: TDeviceInfo;
      const DeviceStatus: TDeviceStatus);
    procedure UpdateLoaderInfo(DeviceInfo: TDeviceInfo);

    property Manager: TKeyboardManager read FManager;
  public
    constructor Create(AManager: TKeyboardManager);
    destructor Destroy; override;

    procedure CopyToClipboard;
    procedure ReadLoaderReport;
    procedure ReadApplicationReport;

    property Lines: TStrings read FLines;
    property ShortingName: string read FShortingName;
    property ShortingValue: string read FShortingValue;
    property LayoutStatus: string read FLayoutStatus;
    property HasShortings: Boolean read FHasShortings;
    property IsLayoutCorrupted: Boolean read FIsLayoutCorrupted;
  end;

implementation

resourcestring
  MsgShortingNo         = 'no';
  MsgShortingYes        = 'yes';

  MsgLoader             = 'Loader';
  MsgKeyboardMode       = 'Keyboard mode';
  MsgProgramVersion     = 'Program version';
  MsgLoaderVersion      = 'Loader version';
  MsgMemorySize         = 'Memory size, bytes';
  MsgDeviceType         = 'Device type';
  MsgLayerCount         = 'Layers number';
  MsgMSRTracks          = 'MSR tracks';
  MsgKeyCount           = 'Keys number';
  MsgKeyPosCount        = 'Keylock positions number';
  MsgShorting           = 'Shortings on the plate';
  MsgLayoutOK           = 'Layout is correct';
  MsgLayoutError        = 'Layout is corrupted or layout version mismatch';
  MsgReadInfo           = 'info query';
  MsgDeviceInfo         = 'Device info';

function TracksToStr(Tracks: array of Boolean): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to High(Tracks) do
  begin
    if Tracks[i] then
    begin
      if Result <> '' then Result := Result + ',';
      Result := Result + IntToStr(i+1);
    end;
  end;
end;

{ TKeyboardReport }

constructor TKeyboardReport.Create(AManager: TKeyboardManager);
begin
  inherited Create;
  FLines := TStringList.Create;
  FManager := AManager;
end;

destructor TKeyboardReport.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TKeyboardReport.AddParameter(const Name, Value: string);
begin
  FLines.Values[Name] := Value;
end;

procedure TKeyboardReport.Clear;
begin
  FLines.Clear;
end;

procedure TKeyboardReport.ReadLoaderReport;
var
  LoaderInfo: TDeviceInfo;
begin
  Manager.LockDriver(MsgReadInfo);
  try
    LoaderInfo := Manager.Driver.GetLoaderInfo;
    UpdateLoaderInfo(LoaderInfo);
  finally
    Manager.UnlockDriver;
  end;
end;

procedure TKeyboardReport.ReadApplicationReport;
var
  LoaderInfo: TDeviceInfo;
  ProgramInfo: TDeviceInfo;
  IsProgramActive: Boolean;
  DeviceStatus: TDeviceStatus;
begin
  Manager.LockDriver(MsgReadInfo);
  try
    DeviceStatus := Manager.Driver.GetDeviceStatus;
    IsProgramActive := DeviceStatus.AppMode = amProg;
    if IsProgramActive then
    begin
      try
        ProgramInfo := Manager.Driver.GetProgramInfo;
      except
        on E: Exception do
        begin
          Logger.Error('HandleException: ' + E.Message);
          IsProgramActive := False;
        end;
      end;
    end;
    LoaderInfo := Manager.Driver.GetLoaderInfo;
    if IsProgramActive then
    begin
      UpdateInfo(LoaderInfo, ProgramInfo, DeviceStatus);
    end else
    begin
      UpdateLoaderInfo(LoaderInfo);
    end;
    if IsProgramActive then
      Manager.Driver.SetMode(amProg, dmData);
  finally
    Manager.UnlockDriver;
  end;
end;

procedure TKeyboardReport.UpdateLoaderInfo(DeviceInfo: TDeviceInfo);
var
  ShortingText: string;
begin
  FHasShortings := False;
  if Manager.Driver.CapShortingReport(DeviceInfo) then
  begin
    if Manager.Driver.CheckShorting then
    begin
      ShortingText := MsgShortingYes;
      FHasShortings := True;
    end else
    begin
      ShortingText := MsgShortingNo;
    end;
  end;

  Clear;
  AddParameter(MsgKeyboardMode, MsgLoader);
  AddParameter(MsgLoaderVersion, DeviceInfo.VersionText);
  AddParameter(MsgMemorySize, IntToStr(DeviceInfo.MemSize));
  AddParameter(MsgDeviceType, IntToStr(DeviceInfo.Model));
  AddParameter(MsgLayerCount, IntToStr(DeviceInfo.LayerCount));
  AddParameter(MsgMSRTracks,
    TracksToStr([DeviceInfo.Track1, DeviceInfo.Track2, DeviceInfo.Track3]));
  if DeviceInfo.KeyCount > 0 then
    AddParameter(MsgKeyCount,  IntToStr(DeviceInfo.KeyCount));
  AddParameter(MsgKeyPoscount, IntToStr(DeviceInfo.PosCount));

  FShortingName := MsgShorting;
  FShortingValue := ShortingText;
end;

procedure TKeyboardReport.UpdateInfo(const LoaderInfo, ProgInfo: TDeviceInfo;
  const DeviceStatus: TDeviceStatus);
var
  DeviceType: string;
  ShortingText: string;
  ProgramVersion: string;
begin
  // Program version
  ProgramVersion := ProgInfo.VersionText;
  // Device type
  DeviceType := IntToStr(ProgInfo.Model);
  // Shortings
  FHasShortings := False;
  if Manager.Driver.CapShortingReport(LoaderInfo) then
  begin
    if Manager.Driver.CheckShorting then
    begin
      FHasShortings := True;
      ShortingText := MsgShortingYes;
    end else
    begin
      ShortingText := MsgShortingNo;
    end;
  end;
  // Update
  Clear;
  AddParameter(MsgProgramVersion, ProgramVersion);
  AddParameter(MsgLoaderVersion, LoaderInfo.VersionText);
  AddParameter(MsgMemorySize, IntToStr(LoaderInfo.MemSize));
  AddParameter(MsgDeviceType, DeviceType);
  AddParameter(MsgLayerCount, IntToStr(ProgInfo.LayerCount));
  AddParameter(MsgMSRTracks,
    TracksToStr([ProgInfo.Track1, ProgInfo.Track2, ProgInfo.Track3]));

  if LoaderInfo.KeyCount > 0 then
    AddParameter(MsgKeyCount,  IntToStr(LoaderInfo.KeyCount));
  AddParameter(MsgKeyPosCount, IntToStr(ProgInfo.PosCount));

  FShortingName := MsgShorting;
  FShortingValue := ShortingText;
  if DeviceStatus.IsValidLayout then
  begin
    FIsLayoutCorrupted := False;
    FLayoutStatus :=  MsgLayoutOK;
  end else
  begin
    FIsLayoutCorrupted := True;
    FLayoutStatus := MsgLayoutError;
  end;
end;

procedure TKeyboardReport.CopyToClipboard;
var
  i: Integer;
  Strings: TStrings;
  ParamName: string;
  ParamValue: string;
const
  MsgSeparator = '--------------------------------------------------';
  MsgLineFormat = ' %-27s: %s';
begin
  Strings := TStringList.Create;
  try
    Strings.Add(MsgSeparator);
    Strings.Add(' ' + MsgDeviceInfo);
    Strings.Add(MsgSeparator);
    for i := 0 to Lines.Count-1 do
    begin
      ParamName := Lines.Names[i];
      ParamValue := Lines.ValueFromIndex[i];
      Strings.Add(Format(MsgLineFormat, [ParamName, ParamValue]));
    end;
    Strings.Add(Format(MsgLineFormat, [ShortingName, ShortingValue]));
    Strings.Add('');
    Strings.Add(' ' + FLayoutStatus);
    Strings.Add(MsgSeparator);

    Clipboard.SetTextBuf(PChar(Strings.Text));
  finally
    Strings.Free;
  end;
end;

end.
