unit KeyEditor;

interface

uses
  // VCL
  Classes, Graphics, SysUtils,
  // This
  KBLayout;

type
  { TKeyEditor }

  TKeyEditor = class(TComponent)
  private
    FLayout: TKBLayout;

    function GetText: string;
    function GetCaption: string;
    function GetNotesText: string;
    function GetKeyType: TKeyType;
    function GetRepeatKey: Boolean;
    function GetPressCodesText: string;
    function GetSelectedKeys: TKeyList;
    function GetReleaseCodesText: string;
    procedure SetText(const Value: string);
    procedure SetNotesText(const Value: string);
    procedure SetKeyType(const Value: TKeyType);
    procedure SetRepeatKey(const Value: Boolean);
    procedure SetPressCodesText(const Value: string);
    procedure SetReleaseCodesText(const Value: string);

    property SelectedKeys: TKeyList read GetSelectedKeys;
    procedure SetLayout(const Value: TKBLayout);
  public
    property Caption: string read GetCaption;
    property Text: string read GetText write SetText;
    property Layout: TKBLayout read FLayout write SetLayout;
    property NotesText: string read GetNotesText write SetNotesText;
    property KeyType: TKeyType read GetKeyType write SetKeyType;
    property RepeatKey: Boolean read GetRepeatKey write SetRepeatKey;
    property PressCodesText: string read GetPressCodesText write SetPressCodesText;
    property ReleaseCodesText: string read GetReleaseCodesText write SetReleaseCodesText;
  end;

implementation

{ TKeyEditor }

function TKeyEditor.GetSelectedKeys: TKeyList;
begin
  Result := Layout.SelectedKeys;
end;

function TKeyEditor.GetKeyType: TKeyType;
var
  i: Integer;
  V: TKeyType;
begin
  Result := ktMacros;
  if FLayout = nil then Exit;
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].KeyType;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].KeyType <> V then Exit;
    end;
    Result := V;
  end;
end;

// NotesText

function TKeyEditor.GetNotesText: string;
var
  V: string;
  i: Integer;
begin
  Result := '';
  if FLayout = nil then Exit;
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].Notes.AsText;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].Notes.AsText <> V then Exit;
    end;
    Result := V;
  end;
end;

function TKeyEditor.GetPressCodesText: string;
var
  V: string;
  i: Integer;
begin
  Result := '';
  if FLayout = nil then Exit;
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].PressCodes.AsText;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].PressCodes.AsText <> V then Exit;
    end;
    Result := V;
  end;
end;

function TKeyEditor.GetReleaseCodesText: string;
var
  V: string;
  i: Integer;
begin
  Result := '';
  if FLayout = nil then Exit;
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].ReleaseCodes.AsText;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].ReleaseCodes.AsText <> V then Exit;
    end;
    Result := V;
  end;
end;

function TKeyEditor.GetRepeatKey: Boolean;
var
  V: Boolean;
  i: Integer;
begin
  Result := False;
  if FLayout = nil then Exit;
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].RepeatKey;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].RepeatKey <> V then Exit;
    end;
    Result := V;
  end;
end;

function TKeyEditor.GetText: string;
var
  V: string;
  i: Integer;
begin
  Result := '';
  if FLayout = nil then Exit;
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].Text;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].Text <> V then Exit;
    end;
    Result := V;
  end;
end;

function TKeyEditor.GetCaption: string;
begin
  Result := '';
  if FLayout = nil then Exit;
  Result := Layout.SelectionText;
end;

// set methods

procedure TKeyEditor.SetNotesText(const Value: string);
var
  i: Integer;
begin
  if FLayout = nil then Exit;

  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].Notes.AsText := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyEditor.SetKeyType(const Value: TKeyType);
var
  i: Integer;
begin
  if FLayout = nil then Exit;

  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].KeyType := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyEditor.SetPressCodesText(const Value: string);
var
  i: Integer;
begin
  if FLayout = nil then Exit;

  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].PressCodes.AsText := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyEditor.SetReleaseCodesText(const Value: string);
var
  i: Integer;
begin
  if FLayout = nil then Exit;

  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].ReleaseCodes.AsText := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyEditor.SetRepeatKey(const Value: Boolean);
var
  i: Integer;
begin
  if FLayout = nil then Exit;

  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].RepeatKey := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyEditor.SetText(const Value: string);
var
  i: Integer;
begin
  if FLayout = nil then Exit;

  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].Text := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyEditor.SetLayout(const Value: TKBLayout);
begin
  FLayout := Value;
end;

end.
