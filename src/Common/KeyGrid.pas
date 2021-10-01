unit KeyGrid;

interface

uses
  // VCL
  Windows, Classes, Graphics, SysUtils, Controls,
  // This
  Grids2, KBLayout, GridType, Utils, KeyboardManager, AppSettings;

const
  SelectedLayerText = clGreen; // Active layer

type
  { TKeyGrid }

  TKeyGrid = class(TStringGrid2)
  private
    FLayout: TKBLayout;
    function GetArrowText(KeyType: TKeyType): string;
    function IsCellSelected(ACol, ARow: Longint): Boolean;
    procedure DrawLayer(ACol, ARow: Longint; ARect: TRect);
    procedure DrawGroup(ACol, ARow: Longint; ARect: TRect);
    procedure DrawColText(ACol, ARow: Longint; ARect: TRect);
    procedure DrawKeyPicture(ACol, ARow: Integer; ARect: TRect);
    procedure DrawArrow(Key: TKey; ARect: TRect; CellSelected: Boolean);
    function GetArrowColor(KeyType: TKeyType; CellSelected: Boolean): TColor;
    function GetKeyTextColor(LayerIndex: Integer; CellSelected: Boolean): TColor;
  protected
    procedure DrawKey(ACol, ARow: Longint; ARect: TRect); virtual;
    property Layout: TKBLayout read FLayout;
  public
    constructor CreateGrid(AOwner: TComponent; ALayout: TKBLayout);
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  end;

implementation

{$R *.RES}

function PointInGridRect(Col, Row: Longint; const Rect: TGridRect): Boolean;
begin
  Result := (Col >= Rect.Left) and (Col <= Rect.Right) and (Row >= Rect.Top)
    and (Row <= Rect.Bottom);
end;

{ TKeyGrid }

constructor TKeyGrid.CreateGrid(AOwner: TComponent; ALayout: TKBLayout);
begin
  inherited Create(AOwner);
  FLayout := ALayout;
end;

function TKeyGrid.GetArrowText(KeyType: TKeyType): string;
const
  // Symbol codes in 'Symbol' font
  CHAR_UPARROW    = #173;
  CHAR_DOWNARROW  = #175;
begin
  case KeyType of
    ktGoUp      : Result := CHAR_UPARROW;
    ktGoDown    : Result := CHAR_DOWNARROW;
    ktGo1       : Result := CHAR_UPARROW + '1';
    ktGo2       : Result := CHAR_UPARROW + '2';
    ktGo3       : Result := CHAR_UPARROW + '3';
    ktGo4       : Result := CHAR_UPARROW + '4';
    ktTemp1     : Result := CHAR_UPARROW + CHAR_DOWNARROW + '1';
    ktTemp2     : Result := CHAR_UPARROW + CHAR_DOWNARROW + '2';
    ktTemp3     : Result := CHAR_UPARROW + CHAR_DOWNARROW + '3';
    ktTemp4     : Result := CHAR_UPARROW + CHAR_DOWNARROW + '4';
  else
    Result := '';
  end;
end;

function TKeyGrid.GetArrowColor(KeyType: TKeyType; CellSelected: Boolean): TColor;
begin
  if CellSelected then
  begin
    Result := clWhite;
  end else
  begin
    case KeyType of
      ktGoUp      : Result := clBlue;
      ktGoDown    : Result := clBlue;
      ktGo1       : Result := clGreen;
      ktGo2       : Result := clGreen;
      ktGo3       : Result := clGreen;
      ktGo4       : Result := clGreen;
      ktTemp1     : Result := clRed;
      ktTemp2     : Result := clRed;
      ktTemp3     : Result := clRed;
      ktTemp4     : Result := clRed;
    else
      Result := clWhite;
    end;
  end;
end;

procedure TKeyGrid.DrawArrow(Key: TKey; ARect: TRect; CellSelected: Boolean);
var
  S: string;
  SaveFont: TFont;
begin
  SaveFont := TFont.Create;
  try
    SaveFont.Assign(Canvas.Font);
    Canvas.Font.Name := 'Symbol';
    Canvas.Font.Color := GetArrowColor(Key.KeyType, CellSelected);
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];

    S := GetArrowText(Key.KeyType);
    Canvas.TextOut(ARect.Left + 2, ARect.Top + 2, S);
  finally
    Canvas.Font.Assign(SaveFont);
    SaveFont.Free;
  end;
end;

function TKeyGrid.GetKeyTextColor(LayerIndex: Integer; CellSelected: Boolean): TColor;
begin
  if CellSelected then
    Result := clWindow
  else
  begin
    if Settings.LayerIndex = LayerIndex then
      Result := SelectedLayerText
    else
      Result := clBlack;
  end;
end;

{ Drawing key }

procedure TKeyGrid.DrawKey(ACol, ARow: Longint; ARect: TRect);

  function GetCellColor(CellSelected: Boolean): TColor;
  begin
    if CellSelected then Result := clHighlight
    else Result := clWindow;
  end;

  function GetKeyColor(CellSelected: Boolean): TColor;
  begin
    if CellSelected then
      Result := clHighlight
    else
      Result := clWindow;
  end;

var
  S: string;
  Key: TKey;
  i: Integer;
  Layer: TLayer;
  DrawRect: TRect;
  TextSize: TSize;
  FillCount: Integer;
  ReleaseText: string;
  CellSelected: Boolean;
begin
  FillCount := 0;
  CellSelected := IsCellSelected(ACol, ARow);
  Canvas.Brush.Color := GetCellColor(CellSelected);
  Canvas.FillRect(ARect);

  TextSize := Canvas.TextExtent('999');
  // Drawing keys
  DrawRect := ARect;
  DrawRect.Top := DrawRect.Top + 1;
  DrawRect.Left := DrawRect.Left + 2;

  for i := 0 to Layout.Layers.Count-1 do
  begin
    S := '';
    Layer := Layout.Layers[i];
    Key := Layer.Keys.FindItem(ACol, ARow);
    if Key <> nil then
    begin
      if FillCount = 0 then
      begin
        Inc(FillCount);
        Canvas.Brush.Color := GetKeyColor(CellSelected);
        Canvas.FillRect(ARect);
      end;

      if Key.KeyType = ktMacros then
      begin
        if Settings.ViewMode = vmLayout then
        begin
          S := Key.PressCodes.AsText;
          ReleaseText := Key.ReleaseCodes.AsText;
        end else
        begin
          S := Key.PressCodes.SimpleText;
          ReleaseText := Key.ReleaseCodes.SimpleText;
        end;

        if ReleaseText <> '' then S := S + '^' + ReleaseText;

        if (DrawRect.Top + TextSize.cy) < ARect.Bottom then
        begin
          Canvas.Font.Color := GetKeyTextColor(i, CellSelected);
          DrawText(Canvas.Handle, PChar(S), Length(S), DrawRect, dt_left);
        end;
      end else
      begin
        DrawArrow(Key, DrawRect, CellSelected);
      end;
    end else
    begin
      if FillCount = 0 then
      begin
        Inc(FillCount);
        Canvas.Brush.Color := clBtnFace;
        Canvas.FillRect(ARect);
      end;
    end;
    DrawRect.Top := DrawRect.Top + TextSize.cy;
  end;
end;

{ Drawing key groups }

procedure TKeyGrid.DrawGroup(ACol, ARow: Longint; ARect: TRect);
var
  Group: TKeyGroup;
  LeftLine: Boolean;
  RightLine: Boolean;
  TopLine: Boolean;
  BottomLine: Boolean;
begin
  Group := Layout.GetGroup(ACol, ARow);
  if Group <> nil then
  begin
    TopLine := ARow = Group.Rect.Top;
    LeftLine := ACol = Group.Rect.Left;
    RightLine := ACol = Group.Rect.Right;
    BottomLine := ARow = Group.Rect.Bottom;
    // Selecting color
    if IsCellSelected(ACol, ARow) then
    begin
      Canvas.Pen.Width := 2;
      Canvas.Pen.Color := clSilver;
    end else
    begin
      Canvas.Pen.Width := 1;
      Canvas.Pen.Color := clBlack;
    end;
    if TopLine then
    begin
      Canvas.MoveTo(ARect.Left, ARect.Top);
      Canvas.LineTo(ARect.Right, ARect.Top);
    end;
    if BottomLine then
    begin
      Canvas.MoveTo(ARect.Left, ARect.Bottom-1);
      Canvas.LineTo(ARect.Right, ARect.Bottom-1);
    end;
    if LeftLine then
    begin
      Canvas.MoveTo(ARect.Left, ARect.Top);
      Canvas.LineTo(ARect.Left, ARect.Bottom);
    end;
    if RightLine then
    begin
      Canvas.MoveTo(ARect.Right-1, ARect.Top);
      Canvas.LineTo(ARect.Right-1, ARect.Bottom);
    end;
  end;
end;

procedure TKeyGrid.DrawKeyPicture(ACol, ARow: Longint; ARect: TRect);
var
  Key: TKey;
  x, y: Integer;
  TextRect: TRect;
  PictureRect: TRect;
  TextToDraw: string;
  Graphic: TGraphic;
begin
  TextRect := ARect;
  Key := Layout.Layers[0].Keys.FindItem(ACol, ARow);
  if Key = nil then
  begin
    Canvas.Brush.Color := clbtnFace;
    Canvas.FillRect(ARect);
    Exit;
  end;

  Canvas.Brush.Color := Key.Picture.BackgroundColor;
  if IsCellSelected(ACol, ARow) then
    Canvas.Brush.Color := clHighlight;
  Canvas.FillRect(ARect);

  Graphic := Key.Picture.Picture.Graphic;
  if Graphic <> nil then
  begin
    PictureRect := GetPictureRect(Graphic, ARect);
    Canvas.StretchDraw(PictureRect, Graphic);
  end;

  if Key.Picture.Text <> '' then
  begin
    Canvas.Font := Key.Picture.TextFont;
    SetBkMode(Canvas.Handle, TRANSPARENT);
    TextToDraw := Key.Picture.Text[1];
    if not Key.Picture.VerticalText then
    // Drawing text hotizontally
    begin
      DrawText(Canvas.Handle, PChar(Key.Picture.Text), Length(Key.Picture.Text),
        TextRect, DT_CALCRECT or DT_WORDBREAK);
      y := ARect.Top + ((ARect.Bottom - ARect.Top) -
        (TextRect.Bottom - TextRect.Top)) div 2;
      if (ARect.Bottom - ARect.Top) < (TextRect.Bottom - TextRect.Top) then
      begin
        TextRect := ARect;
      end else
      begin
        TextRect.Right := ARect.Right;
        TextRect.Bottom := y + (TextRect.Bottom - TextRect.Top);
        TextRect.Left := ARect.Left;
        TextRect.Top := y;
      end;
      DrawText(Canvas.Handle, PChar(Key.Picture.Text), Length(Key.Picture.Text),
        TextRect, DT_WORDBREAK or DT_CENTER);
    end else
    begin
    // Draw text vertically
      DrawText(Canvas.Handle, PChar(TextToDraw), Length(TextToDraw),
        TextRect, DT_CALCRECT);
      TextRect.Bottom := TextRect.Top + (TextRect.Bottom - TextRect.Top) * Length(Key.Picture.Text);
      y := ARect.Top + ((ARect.Bottom - ARect.Top) -
        (TextRect.Bottom - TextRect.Top)) div 2;
      if y < ARect.Top then y := ARect.Top;
      TextRect.Bottom := y + (TextRect.Bottom - TextRect.Top);
      if TextRect.Bottom > ARect.Bottom then TextRect.Bottom := ARect.Bottom;
      TextRect.Top := y;
      x := (ARect.Right - ARect.Left - (TextRect.Right - TextRect.Left)) div 2;
      TextRect.Right := ARect.Left + x + (TextRect.Right - TextRect.Left);
      TextRect.Left := ARect.Left + x;
      TextToDraw := '';
      for x := 1 to Length(Key.Picture.Text) do
        TextToDraw := TextToDraw + Key.Picture.Text[x] + ' ';
      DrawText(Canvas.Handle, PChar(TextToDraw), Length(TextToDraw),
        TextRect, DT_WORDBREAK or DT_CENTER);
    end;
  end;
end;

function TKeyGrid.IsCellSelected(ACol, ARow: Longint): Boolean;
begin
  Result := Focused and (Row = ARow) and (Col = ACol) or
    PointInGridRect(ACol, ARow, Selection);
end;

{ Draw layer sign }

procedure TKeyGrid.DrawLayer(ACol, ARow: Longint; ARect: TRect);
var
  S: string;
begin
  Canvas.Brush.Color := SelectedLayerText;
  Canvas.FillRect(ARect);
  Canvas.Font.Color := clBlack;
  S := IntToStr(Settings.LayerIndex+1);
  DrawText(Canvas.Handle, PChar(S), Length(S), ARect,
    DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  // White lines
  Canvas.Pen.Color := clBtnFace;
  Canvas.MoveTo(ARect.Left, ARect.Bottom-1);
  Canvas.LineTo(ARect.Right-1, ARect.Bottom-1);
  Canvas.LineTo(ARect.Right-1, ARect.Top);
end;

procedure TKeyGrid.DrawColText(ACol, ARow: Longint; ARect: TRect);
var
  S: string;
begin
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(ARect);
  // Drawing column and rows number
  S := Cells[ACol, ARow];
  DrawText(Canvas.Handle, PChar(S), Length(S), ARect,
    DT_CENTER or DT_VCENTER or DT_SINGLELINE);
end;

{ Drawing cell }

procedure TKeyGrid.DrawCell(
  ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);
begin
  if (ACol = 0)or(ARow = 0) then
  begin
    if (ACol = 0)and(ARow = 0) then
    begin
      // Layer sign
      DrawLayer(ACol, ARow, ARect);
    end else
    begin
      // Row and column number
      DrawColText(ACol, ARow, ARect);
    end;
  end else
  begin
    if Settings.ViewMode <> vmPicture then
    begin
      // Draw key
      DrawKey(ACol, ARow, ARect);
    end else
    begin
      DrawKeyPicture(ACol, ARow, ARect);
    end;
    // Draw key group
    DrawGroup(ACol, ARow, ARect);
  end;
end;

end.
