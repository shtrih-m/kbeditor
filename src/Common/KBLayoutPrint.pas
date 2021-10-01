unit KBLayoutPrint;

interface

uses
  // VCL
  Windows, Graphics,
  // This
  KBLayout, Preview, Utils;

type
  { TKBLayoutPrint }

  TKBLayoutPrint = class
  private
    procedure PrintKey(Canvas: TCanvas; DrawRect: TRect; Key: Tkey);
  public
    procedure Execute(Layout: TKBLayout);
    procedure PrintLayout(Layout: TKBLayout; Canvas: TCanvas;
      KeyWidth, KeyHeight, KeySpaceX, KeySpaceY: Integer; BoundsRect: TRect);
  end;

const
  LineWidth             = 1;
  KeyWidthInInch        = 0.5;
  KeyHeightInInch       = 0.5;
  KeySpaceXInInch       = 0.3;
  KeySpaceYInInch       = 0.3;
  BaseShiftX            = LineWidth + 1;
  BaseShiftY            = LineWidth+1;

procedure PrintLayout(Layout: TKBLayout);

implementation

procedure PrintLayout(Layout: TKBLayout);
var
  Print: TKBLayoutPrint;
begin
  Print := TKBLayoutPrint.Create;
  try
    Print.Execute(Layout);
  finally
    Print.Free;
  end;
end;

{ TKBLayoutPrint }

procedure TKBLayoutPrint.Execute(Layout: TKBLayout);
var
  KeyWidthInUnits: Integer;
  KeyHeightInUnits: Integer;
  PrintPreview: TPrintPreview;
  KeySpaceX, KeySpaceY: Integer;
begin
  PrintPreview := TPrintPreview.Create(nil);
  try
    PrintPreview.Units := mmLoMetric;
    PrintPreview.DirectPrint := True;
    PrintPreview.BeginDoc;
    KeyWidthInUnits := Round(KeyWidthInInch*254);
    KeyHeightInUnits := Round(KeyHeightInInch*254);
    KeySpaceX := Round(KeySpaceXInInch*254);
    KeySpaceY := Round(KeySpaceYInInch*254);
    PrintLayout(Layout, PrintPreview.Canvas, KeyWidthInUnits, KeyHeightInUnits,
      KeySpaceX, KeySpaceY, PrintPreview.PrinterPageBounds);
    PrintPreview.EndDoc;
  finally
    PrintPreview.Free;
  end;
end;

procedure TKBLayoutPrint.PrintKey(Canvas: TCanvas; DrawRect: TRect; Key: Tkey);
var
  x, y: Integer;
  TextRect: TRect;
  TextToDraw: string;
begin
  TextRect := DrawRect;
  if Key = nil then Exit;

  SetBkMode(Canvas.Handle, TRANSPARENT);
  if Key.Picture.BackgroundColor <> 0 then
  begin
    Canvas.Brush.Color := Key.Picture.BackgroundColor;
    Canvas.FillRect(DrawRect);
  end;

  if Key.Picture.Picture.Graphic <> nil then
  begin
    StretchDrawGraphicAsDIB(Canvas.Handle,
      GetPictureRect(Key.Picture.Picture.Graphic, DrawRect),
      Key.Picture.Picture.Graphic);
  end;

  if Key.Picture.Text <> '' then
  begin
    Canvas.Font := Key.Picture.TextFont;
    TextToDraw := Key.Picture.Text[1];
    if  not Key.Picture.VerticalText then
    begin
    // Draw text horizontally
      DrawText(Canvas.Handle, PChar(Key.Picture.Text), Length(Key.Picture.Text),
        TextRect, DT_CALCRECT or DT_WORDBREAK);
      y := DrawRect.Top + ((DrawRect.Bottom - DrawRect.Top) -
        (TextRect.Bottom - TextRect.Top)) div 2;
      TextRect.Right := DrawRect.Right;
      TextRect.Bottom := y + (TextRect.Bottom - TextRect.Top);
      TextRect.Left := DrawRect.Left;
      TextRect.Top := y;
      DrawText(Canvas.Handle, PChar(Key.Picture.Text), Length(Key.Picture.Text),
        TextRect, DT_WORDBREAK or DT_CENTER);
    end else
    begin
    // Draw text vertically
      DrawText(Canvas.Handle, PChar(TextToDraw), Length(TextToDraw),
        TextRect, DT_CALCRECT);
      TextRect.Bottom := TextRect.Top + (TextRect.Bottom - TextRect.Top) * Length(Key.Picture.Text);
      y := DrawRect.Top + ((DrawRect.Bottom - DrawRect.Top) -
        (TextRect.Bottom - TextRect.Top)) div 2;
      if y < DrawRect.Top then y := DrawRect.Top;
      TextRect.Bottom := y + (TextRect.Bottom - TextRect.Top);
      if TextRect.Bottom > DrawRect.Bottom then TextRect.Bottom := DrawRect.Bottom;
      TextRect.Top := y;
      x := (DrawRect.Right - DrawRect.Left - (TextRect.Right - TextRect.Left)) div 2;
      TextRect.Right := DrawRect.Left + x + (TextRect.Right - TextRect.Left);
      TextRect.Left := DrawRect.Left + x;
      TextToDraw := '';
      for x := 1 to Length(Key.Picture.Text) do
        TextToDraw := TextToDraw + Key.Picture.Text[x] + ' ';
      DrawText(Canvas.Handle, PChar(TextToDraw), Length(TextToDraw),
        TextRect, DT_WORDBREAK or DT_CENTER);
    end;
  end;
end;

procedure TKBLayoutPrint.PrintLayout(Layout: TKBLayout;
  Canvas: TCanvas; KeyWidth, KeyHeight,
  KeySpaceX, KeySpaceY: Integer; BoundsRect: Trect);
var
  i, j, k, X, Y: Integer;
  DrawRect: TRect;
  Key: Tkey;
  MaxColsCount: Integer;
  ShiftX, ShiftY: Integer;
  MaxBottom: Integer;
begin
  MaxColsCount := Min(Layout.ColCount, (BoundsRect.Right - BoundsRect.Left) div KeyWidth);
  ShiftX := BoundsRect.Left + BaseShiftX;
  ShiftY := BoundsRect.Top + BaseShiftY;
  Canvas.Pen.Width := LineWidth;
  // Draw key
  for j := 1 to MaxColsCount do
  for i := 1 to Layout.RowCount do
  begin
    X := ShiftX + KeyWidth*(j-1);
    Y := ShiftY + KeyHeight*(i-1);
    DrawRect.Left := X;
    DrawRect.Top := Y;
    DrawRect.Right := X + KeyWidth;
    DrawRect.Bottom := Y + KeyHeight;
    Key := Layout.Layers[0].FindKey(j, i);
    if Key <> nil then
    begin
      if Layout.GetGroup(Key.Col, Key.Row) = nil then
        PrintKey(Canvas, DrawRect, Key);
    end else
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.FillRect(DrawRect);
    end;
  end;
  // Upper line
  Canvas.MoveTo(ShiftX, ShiftY);
  Canvas.LineTo(ShiftX + KeyWidth*MaxColsCount, ShiftY);
  // Right line
  Canvas.MoveTo(ShiftX, ShiftY);
  Canvas.LineTo(ShiftX, ShiftY + KeyHeight*Layout.RowCount);
  // Vertical line
  for i := 1 to MaxColsCount do
  begin
    Canvas.MoveTo(ShiftX + KeyWidth*i, ShiftY);
    Canvas.LineTo(ShiftX + KeyWidth*i, ShiftY + KeyHeight*Layout.RowCount);
  end;
  // Horizontal lines
  for i := 1 to Layout.RowCount do
  begin
    Canvas.MoveTo(ShiftX, ShiftY + KeyHeight*i);
    Canvas.LineTo(ShiftX + KeyWidth*MaxColsCount, ShiftY + KeyHeight*i);
  end;
  // Draw other keys
  ShiftY := DrawRect.Bottom + KeySpaceY div 2;
  for j := 1 to Layout.ColCount - MaxColsCount do
  for i := 1 to Layout.RowCount do
  begin
    X := ShiftX + j*KeyWidth;
    Y := ShiftY + i*KeyHeight;
    DrawRect.Left := X;
    DrawRect.Top := Y;
    DrawRect.Right := X + KeyWidth;
    DrawRect.Bottom := Y + KeyHeight;
    Key := Layout.Layers[0].FindKey(j + MaxColsCount, i);
    if Key <> nil then
    begin
      if Layout.GetGroup(Key.Col, Key.Row) = nil then
        PrintKey(Canvas, DrawRect, Key);
    end else
    begin
      Canvas.Brush.Color := clBtnFace;
      Canvas.FillRect(DrawRect);
    end;
  end;
  if MaxColsCount < Layout.ColCount then
  begin
    // Upper line
    Canvas.MoveTo(ShiftX, ShiftY);
    Canvas.LineTo(ShiftX + KeyWidth*(Layout.ColCount - MaxColsCount), ShiftY);
    // Right line
    Canvas.MoveTo(ShiftX, ShiftY);
    Canvas.LineTo(ShiftX, ShiftY + KeyHeight*Layout.RowCount);
    // Vertical lines
    for i := 1 to Layout.ColCount - MaxColsCount do
    begin
      Canvas.MoveTo(ShiftX + KeyWidth*i, ShiftY);
      Canvas.LineTo(ShiftX + KeyWidth*i, ShiftY + KeyHeight*Layout.RowCount);
    end;
    // Horizontal lines
    for i := 1 to Layout.RowCount do
    begin
      Canvas.MoveTo(ShiftX, ShiftY + KeyHeight*i);
      Canvas.LineTo(ShiftX + KeyWidth*(Layout.ColCount - MaxColsCount), ShiftY + KeyHeight*i);
    end;
  end;
  // Key groups
  X := ShiftX;
  Y := DrawRect.Bottom + KeySpaceY;
  MaxBottom := 0;
  for k := 0 to Layout.KeyGroups.Count-1 do
  begin
    DrawRect.Left := X;
    DrawRect.Top := Y;
    DrawRect.Right := X + KeyWidth*(Layout.KeyGroups[k].Rect.Right - Layout.KeyGroups[k].Rect.Left + 1)
      + KeySpaceX*(Layout.KeyGroups[k].Rect.Right - Layout.KeyGroups[k].Rect.Left);
    DrawRect.Bottom := Y +  KeyHeight*(Layout.KeyGroups[k].Rect.Bottom - Layout.KeyGroups[k].Rect.Top + 1)
      + KeySpaceY*(Layout.KeyGroups[k].Rect.Bottom - Layout.KeyGroups[k].Rect.Top);
    // Check page limits
    if DrawRect.Right > BoundsRect.Right then
    begin
      X := ShiftX;
      DrawRect.Left := X;
      DrawRect.Right := X + KeyWidth*(Layout.KeyGroups[k].Rect.Right - Layout.KeyGroups[k].Rect.Left + 1)
        + KeySpaceX*(Layout.KeyGroups[k].Rect.Right - Layout.KeyGroups[k].Rect.Left);
      Y := MaxBottom + KeySpaceY;
      DrawRect.Top := Y;
      DrawRect.Bottom := Y +  KeyHeight*(Layout.KeyGroups[k].Rect.Bottom - Layout.KeyGroups[k].Rect.Top + 1)
        + KeySpaceY*(Layout.KeyGroups[k].Rect.Bottom - Layout.KeyGroups[k].Rect.Top);
    end;
    if DrawRect.Bottom > MaxBottom then MaxBottom := DrawRect.Bottom;
    //--------------------------------------------------------------------------
    Key := Layout.Layers[0].GetKey(Layout.KeyGroups[k].Rect.Left, Layout.KeyGroups[k].Rect.Top);
    PrintKey(Canvas, DrawRect, Key);
    Canvas.MoveTo(DrawRect.Left, DrawRect.Top);
    Canvas.LineTo(DrawRect.Right, DrawRect.Top);
    Canvas.LineTo(DrawRect.Right, DrawRect.Bottom);
    Canvas.LineTo(DrawRect.Left, DrawRect.Bottom);
    Canvas.LineTo(DrawRect.Left, DrawRect.Top);
    X := DrawRect.Right + KeySpaceX;
  end;
end;


end.
