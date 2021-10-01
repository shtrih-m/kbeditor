unit duKeyboardLayout;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // DUnit
  TestFramework,
  // This
  KBLayout, KeyboardManager, Keyboard, LayoutFormat, FileUtils;

type
  { TKeyboardLayoutTest }

  TKeyboardLayoutTest = class(TTestCase)
  published
    procedure CheckTestLayout;
  end;

implementation

procedure CreateTestLayout(Layout: TKBLayout);
var
  Key: TKey;
  Keys: TKeys;
  Col: Integer;
  Row: Integer;
  KeyText: string;
  KeyDef: TKeyDef;
  i, j, k: Integer;
  Keyboard: TKeyboard;
  ScrollWheel: TScrollWheel;
begin
  Layout.BeginUpdate;
  try
    // Keyboard
    Col := 1;
    Row := 1;
    Keyboard := Layout.Keyboard;
    for i := 0 to Keyboard.KeyDefs.Count-1 do
    begin
      KeyDef := Keyboard.KeyDefs[i];
      KeyDef.Left := Col;
      KeyDef.Top := Row;
      KeyDef.LogicNumber := i + 1;
      Inc(Col);
      if Col > Keyboard.ColCount then
      begin
        Inc(Row);
        Col := 1;
      end;
    end;
    Layout.UpdateLayout;
    // Layout
    for i := 0 to Layout.Layers.Count-1 do
    begin
      Keys := Layout.Layers[i].Keys;
      for j := 1 to Keys.Count do
      begin
        Key := Keys[j-1];
        Key.KeyType := ktMacros;
        KeyText := '';

        for k := 1 to 25 do
        begin
          KeyText := KeyText + '+1 -1 ';
        end;
        Key.PressCodes.AsText := KeyText;
        Key.ReleaseCodes.AsText := KeyText;
      end;
      // ScrollWheel
      ScrollWheel := Layout.Layers[i].ScrollWheel;
      ScrollWheel.ScrollUp.Codes.SimpleText := '[Scrollup]';
      ScrollWheel.ScrollDown.Codes.SimpleText := '[Scrolldown]';
      ScrollWheel.SingleClick.Codes.SimpleText := '[Singleclick]';
      ScrollWheel.DoubleClick.Codes.SimpleText := '[Doubleclick]';
    end;
  finally
    Layout.EndUpdate;
  end;
end;

{ TKeyboardLayoutTest }

procedure TKeyboardLayoutTest.CheckTestLayout;
var
  Data: string;
  DataLen: Integer;
  Layout: TKBLayout;
  MinMemSize: Integer;
  MaxMemSize: Integer;
  BinFormat: TKBLayoutFormat;
  BigLayoutFileName: string;
begin
  FreeManager;
  Layout := TKBLayout.Create(nil);
  try
    BigLayoutFileName := GetModulePath + 'BigLayout.xml';
    DeleteFile(BigLayoutFileName);

    Layout.Keyboard := Manager.Keyboards.ItemByText('KB-64K');
    CreateTestLayout(Layout);
    BinFormat := Manager.GetBinFormat($20C);
    Data := BinFormat.SaveToText(Layout);

    MinMemSize := 32767;
    MaxMemSize := 50000;

    DataLen := Length(Data);
    Check(DataLen > MinMemSize, Format(
      'Layout size less than min memory size, %d < %d', [DataLen, MinMemSize]));

    Check(DataLen < MaxMemSize, Format(
      'Layout size more than max memory size, %d > %d', [DataLen, MaxMemSize]));

    Manager.SaveToFile(Layout, 0, BigLayoutFileName);
  finally
    Layout.Free;
  end;
end;

initialization
  RegisterTest('', TKeyboardLayoutTest.Suite);

end.
