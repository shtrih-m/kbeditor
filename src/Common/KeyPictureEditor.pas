unit KeyPictureEditor;

interface

uses
  // VCL
  Classes, Graphics, SysUtils,
  // This
  KBLayout, DebugUtils;

type
  { TKeyPictureEditor }

  TKeyPictureEditor = class(TComponent)
  private
    FFont: TFont;
    FPicture:TPicture;
    FLayout: TKBLayout;

    function GetText: string;
    function GetCaption: string;
    function GetTextFont: TFont;
    function GetLayout: TKBLayout;
    function GetPicture: TPicture;
    function GetVerticalText: Boolean;
    function GetSelectedKeys: TKeyList;
    function GetBackgroundColor: TColor;

    procedure SetText(const Value: string);
    procedure SetTextFont(const Value: TFont);
    procedure SetPicture(const Value: TPicture);
    procedure SetVerticalText(const Value: Boolean);
    procedure SetBackgroundColor(const Value: TColor);

    property SelectedKeys: TKeyList read GetSelectedKeys;
    procedure SetLayout(const Value: TKBLayout);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Caption: string read GetCaption;
    property Text: string read GetText write SetText;
    property Layout: TKBLayout read GetLayout write SetLayout;
    property Picture: TPicture read GetPicture write SetPicture;
    property TextFont: TFont read GetTextFont write SetTextFont;
    property VerticalText: Boolean read GetVerticalText write SetVerticalText;
    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor;
  end;

implementation

{ TKeyPictureEditor }

constructor TKeyPictureEditor.Create(AOwner: TComponent);
begin
  inherited;
  FFont := TFont.Create;
  FPicture := TPicture.Create;
end;

destructor TKeyPictureEditor.Destroy;
begin
  FFont.Free;
  FPicture.Free;
  inherited Destroy;
end;

function TKeyPictureEditor.GetLayout: TKBLayout;
begin
  if FLayout = nil then
    raise Exception.Create('Layout = nil');
  Result := FLayout;
end;

function TKeyPictureEditor.GetSelectedKeys: TKeyList;
begin
  Result := Layout.SelectedKeys;
end;

function TKeyPictureEditor.GetPicture: TPicture;
begin
  Result := FPicture;
  if SelectedKeys.Count = 1 then
    Result := SelectedKeys[0].Picture.Picture;
end;

function TKeyPictureEditor.GetTextFont: TFont;
begin
  Result := FFont;
  if SelectedKeys.Count = 1 then
    Result := SelectedKeys[0].Picture.TextFont;
end;

function TKeyPictureEditor.GetBackgroundColor: TColor;
var
  V: TColor;
  i: Integer;
begin
  Result := clWhite;
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].Picture.BackgroundColor;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].Picture.BackgroundColor <> V then Exit;
    end;
    Result := V;
  end;
end;

function TKeyPictureEditor.GetText: string;
var
  V: string;
  i: Integer;
begin
  Result := '';
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].Picture.Text;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].Picture.Text <> V then Exit;
    end;
    Result := V;
  end;
end;

function TKeyPictureEditor.GetVerticalText: Boolean;
var
  V: Boolean;
  i: Integer;
begin
  Result := False;
  if SelectedKeys.Count > 0 then
  begin
    V := SelectedKeys[0].Picture.VerticalText;
    for i := 0 to SelectedKeys.Count-1 do
    begin
      if SelectedKeys[i].Picture.VerticalText <> V then Exit;
    end;
    Result := V;
  end;
end;

// set methods

procedure TKeyPictureEditor.SetPicture(const Value: TPicture);
var
  i: Integer;
begin
  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].Picture.Picture := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyPictureEditor.SetBackgroundColor(const Value: TColor);
var
  i: Integer;
begin
  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].Picture.BackgroundColor := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyPictureEditor.SetText(const Value: string);
var
  i: Integer;
begin
  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].Picture.Text := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyPictureEditor.SetTextFont(const Value: TFont);
var
  i: Integer;
begin
  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].Picture.TextFont := Value;
  finally
    Layout.EndUpdate;
  end;
end;

procedure TKeyPictureEditor.SetVerticalText(const Value: Boolean);
var
  i: Integer;
begin
  Layout.BeginUpdate;
  try
    for i := 0 to SelectedKeys.Count-1 do
      SelectedKeys[i].Picture.VerticalText := Value;
  finally
    Layout.EndUpdate;
  end;
end;

function TKeyPictureEditor.GetCaption: string;
begin
  Result := '';
  if FLayout = nil then Exit;
  Result := Layout.SelectionText;
end;

procedure TKeyPictureEditor.SetLayout(const Value: TKBLayout);
begin
  FLayout := Value;
end;

end.
