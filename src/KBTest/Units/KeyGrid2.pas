unit KeyGrid2;

interface

uses
  // VCL
  Windows, Classes, Graphics, SysUtils, Controls,
  // This
  KeyGrid, KBLayout;

type
  { TKeyGrid2 }

  TKeyGrid2 = class(TKeyGrid)
  protected
    procedure DrawKey(ACol, ARow: Longint; ARect: TRect); override;
  end;

implementation

{ TKeyGrid }

procedure TKeyGrid2.DrawKey(ACol, ARow: Longint; ARect: TRect);

  function GetKeyColor(KeyPressed: Boolean): TColor;
  begin
    if KeyPressed then Result := $9CFFB5
    else Result := clWindow;
  end;


  function IsKeyPressed(ACol, ARow: Integer): Boolean;
  var
    Key: TKey;
    Layer: TLayer;
  begin
    Result := False;
    if Layout.Layers.Count = 0 then Exit;
    Layer := Layout.Layers[0];
    Key := Layer.FindKey(ACol, ARow);
    if Key <> nil then Result := Key.Pressed;
  end;

var
  S: string;
  Key: TKey;
  i, y: Integer;
  Layer: TLayer;
  DrawRect: TRect;
  TextSize: TSize;
  TextRect: TRect;
  KeyPressed: Boolean;
begin
  Key := Layout.Layers[0].FindKey(ACol, ARow);
  if Key <> nil then
  begin
    KeyPressed := IsKeyPressed(ACol, ARow);
    Canvas.Brush.Color := GetKeyColor(KeyPressed);
  end else
    Canvas.Brush.Color := clBtnFace;

  Canvas.FillRect(ARect);

  TextSize := Canvas.TextExtent('999');
  // Отрисовка кодов
  DrawRect := ARect;
  DrawRect.Top := DrawRect.Top + 1;
  DrawRect.Left := DrawRect.Left + 2;

  for i := 0 to Layout.Layers.Count-1 do
  begin
    S := '';
    Layer := Layout.Layers[i];
    Key := Layer.FindKey(ACol, ARow);
    if Key <> nil then
    begin
      if Key.KeyType = ktMacros then
      begin
        S := IntToStr(Key.Number);
        if (DrawRect.Top + TextSize.cy) < ARect.Bottom then
        begin
          Canvas.Font.Size := 12;
          Canvas.Font.Color := clBlack;
          CanVas.Font.Style := CanVas.Font.Style + [fsBold];
          SetBkMode(Canvas.Handle, TRANSPARENT);
          DrawText(Canvas.Handle, PChar(S), Length(S), TextRect, DT_CALCRECT);
          y := ARect.Top + ((ARect.Bottom - ARect.Top) -
            (TextRect.Bottom - TextRect.Top)) div 2;
          TextRect.Right := ARect.Right;
          TextRect.Bottom := y + (TextRect.Bottom - TextRect.Top);
          TextRect.Left := ARect.Left;
          TextRect.Top := y;
          DrawText(Canvas.Handle, PChar(S), Length(S), TextRect, DT_CENTER);
        end;
      end;
    end;
    DrawRect.Top := DrawRect.Top + TextSize.cy;
  end;
end;

end.
