unit LayoutFormat;

interface

Uses
  // VCL
  Classes, SysUtils,
  // This
  KBLayout, Keyboard, KeyboardDriver, Utils, LogFile;

type
  TKBLayoutFormat = class;

  { TKBLayoutFormats }

  TKBLayoutFormats = class
  private
    FList: TList;
    procedure Clear;
    function GetCount: Integer;
    function GetFilter: string;
    function GetItem(Index: Integer): TKBLayoutFormat;
    procedure InsertItem(AItem: TKBLayoutFormat);
    procedure RemoveItem(AItem: TKBLayoutFormat);
  public
    constructor Create;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    property Filter: string read GetFilter;
    property Items[Index: Integer]: TKBLayoutFormat read GetItem; default;
  end;

  { TKBLayoutFormat }

  TKBLayoutFormat = class
  private
    FOwner: TKBLayoutFormats;
    function GetKeyboards: TKeyboards;
    procedure SetOwner(AOwner: TKBLayoutFormats);
  protected
    function GetFilter: string; virtual;
    property Keyboards: TKeyboards read GetKeyboards;
  public
    constructor Create(AOwner: TKBLayoutFormats); virtual;
    destructor Destroy; override;

    function GetMinVersion: Word; virtual; abstract;
    function GetMaxVersion: Word; virtual; abstract;
    function SaveToText(Layout: TKBLayout): string;
    function ValidFormat(Version: Word): Boolean;
    procedure LoadFromText(Layout: TKBLayout; const Text: string);
    procedure SaveToStream(Layout: TKBLayout; Stream: TStream); virtual;
    procedure LoadFromStream(Layout: TKBLayout; Stream: TStream); virtual;
    procedure SaveToFile(Layout: TKBLayout; const FileName: string); virtual;
    procedure LoadFromFile(Layout: TKBLayout; const FileName: string); virtual;

    property Filter: string read GetFilter;
    property MinVersion: Word read GetMinVersion;
    property MaxVersion: Word read GetMaxVersion;
  end;
  TKBLayoutFormatClass = class of TKBLayoutFormat;

  { TBinLayoutFormat }

  TBinLayoutFormat = class(TKBLayoutFormat)
  public
    procedure SaveToFile(Layout: TKBLayout; const FileName: string); override;
  end;

function IsKeyEmpty(Key: TKey): Boolean;
function NotesToStr(Notes: TNotes): string;

implementation

uses
  // This
  KeyboardManager;

resourcestring
  MsgLayoutDataMissing          = 'Layout data missing';

function IsKeyEmpty(Key: TKey): Boolean;
begin
  Result :=
    (not Key.RepeatKey) and
    (Key.Notes.Count = 0) and
    (Key.PressCodes.Count = 0) and
    (Key.ReleaseCodes.Count = 0) and
    (Key.KeyType = ktMacros);
end;

function NotesToStr(Notes: TNotes): string;
var
  i: Integer;
  Note: TNote;
begin
  // Notes count
  Result := Chr(Notes.Count);
  for i := 0 to Notes.Count-1 do
  begin
    Note := Notes[i];
    Result := Result + Chr(Note.Note);       // Note
    Result := Result + Chr(Note.Interval);   // Note duration
    Result := Result + Chr(Note.Volume);     // Note volume
  end;
end;

{ TKBLayoutFormats }

constructor TKBLayoutFormats.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TKBLayoutFormats.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TKBLayoutFormats.Clear;
begin
  while Count > 0 do
    Items[0].Free;
end;

function TKBLayoutFormats.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TKBLayoutFormats.GetFilter: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count-1 do
  begin
    Result := Result + Items[i].Filter;
    if i <> (Count-1) then Result := Result + '|';
  end;
end;

function TKBLayoutFormats.GetItem(Index: Integer): TKBLayoutFormat;
begin
  Result := FList[Index];
end;

procedure TKBLayoutFormats.InsertItem(AItem: TKBLayoutFormat);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TKBLayoutFormats.RemoveItem(AItem: TKBLayoutFormat);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function CompareInt(v1, v2: Integer): Integer;
begin
  if v1 > v2 then Result := 1 else
  if v1 < v2 then Result := -1 else
  Result := 0;
end;

{ TKBLayoutFormat }

constructor TKBLayoutFormat.Create(AOwner: TKBLayoutFormats);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TKBLayoutFormat.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

function TKBLayoutFormat.GetKeyboards: TKeyboards;
begin
  Result := Manager.Keyboards;
end;

procedure TKBLayoutFormat.SaveToFile(Layout: TKBLayout; const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Layout, Stream);
    Layout.Saved(FileName);
  finally
    Stream.Free;
  end;
end;

procedure TKBLayoutFormat.LoadFromFile(Layout: TKBLayout; const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    Stream.Position := 0;
    LoadFromStream(Layout, Stream);
    Layout.Saved(FileName);
  finally
    Stream.Free;
  end;
end;

procedure TKBLayoutFormat.LoadFromStream(Layout: TKBLayout; Stream: TStream);
begin

end;

procedure TKBLayoutFormat.SaveToStream(Layout: TKBLayout; Stream: TStream);
begin

end;

procedure TKBLayoutFormat.LoadFromText(Layout: TKBLayout; const Text: string);
var
  Stream: TMemoryStream;
begin
  if Text = '' then
    InvalidFileFormat(MsgLayoutDataMissing);

  Stream := TMemoryStream.Create;
  try
    Stream.WriteBuffer(Text[1], Length(Text));
    Stream.Position := 0;
    LoadFromStream(Layout, Stream);
  finally
    Stream.Free;
  end;
end;

function TKBLayoutFormat.SaveToText(Layout: TKBLayout): string;
var
  Stream: TMemoryStream;
begin
  Logger.Debug('TKBLayoutFormat.SaveToText.0');

  Result := '';
  Stream := TMemoryStream.Create;
  try
    SaveToStream(Layout, Stream);
    if Stream.Size > 0 then
    begin
      SetLength(Result, Stream.Size);
      Stream.Position := 0;
      Stream.ReadBuffer(Result[1], Stream.Size);
    end;
  finally
    Stream.Free;
  end;

  Logger.Debug('TKBLayoutFormat.SaveToText.1');
end;

procedure TKBLayoutFormat.SetOwner(AOwner: TKBLayoutFormats);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

function TKBLayoutFormat.GetFilter: string;
begin
  Result := '';
end;

function TKBLayoutFormat.ValidFormat(Version: Word): Boolean;
begin
  Result := (Version >= MinVersion)and(Version <= MaxVersion);
end;

{ TBinLayoutFormat }

procedure TBinLayoutFormat.SaveToFile(Layout: TKBLayout;
  const FileName: string);
begin
  Layout.DeviceVersion := MinVersion;
  inherited SaveToFile(Layout, FileName);
end;

end.
