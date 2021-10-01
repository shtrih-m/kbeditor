unit duBinLayout28Test;

interface

uses
  // VCL
  Windows, SysUtils, Graphics, Classes,
  // This
  TestFramework, TestLayout, KBLayout, KeyboardManager, Keyboard,
  Utils, DebugUtils, FileUtils, BinLayout28, duCompareLayout;

type
  { TBinLayout28Test }

  TBinLayout28Test = class(TTestCase)
  private
    FTestLayout: TTestLayout;
    FBinLayout: TBinLayout28;
    FKeyboard: TKeyboard;
    FComparer: TCompareLayout;

    procedure CheckScanCodes3(S: TScanCodes);
    function CreateTestKeyboard: TKeyboard;

    property BinLayout: TBinLayout28 read FBinLayout;
    property Keyboard: TKeyboard read FKeyboard;
    property Comparer: TCompareLayout read FComparer;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckMSR;
    procedure CheckKey;
    procedure CheckNotes;
    procedure CheckLayer;
    procedure CheckKeyLock;
    procedure CheckScanCodes;
    procedure CheckKeys;
    procedure CheckScanCodes2;
    procedure CheckScanCodes4;

    procedure CheckLayout;
  end;

implementation

{ TBinLayout28Test }

procedure TBinLayout28Test.Setup;
begin
  FKeyboard := CreateTestKeyboard;
  FTestLayout := TTestLayout.Create;
  FBinLayout := TBinLayout28.Create(nil);
  FBinLayout.Keyboard := FKeyboard;
  FComparer := TCompareLayout.Create;
end;

procedure TBinLayout28Test.TearDown;
begin
  FComparer.Free;
  FBinLayout.Free;
  FTestLayout.Free;
end;

function TBinLayout28Test.CreateTestKeyboard: TKeyboard;
var
  i: Integer;
  KeyDef: TKeyDef;
begin
  Manager.Keyboards.Clear;
  Result := Manager.Keyboards.Add;
  Result.ID := 1;
  Result.Name := 'Testkeyboard';
  Result.ColCount := 8;
  Result.RowCount := 8;
  Result.KeyCount := 64;
  Result.PosCount := 8;
  Result.LayerCount := 1;
  Result.HasMSRTrack1 := True;
  Result.HasMSRTrack2 := True;
  Result.HasMSRTrack3 := True;
  Result.HasMSR := True;
  Result.HasKey := True;
  // KeyDef
  for i := 1 to Result.KeyCount do
  begin
    KeyDef := Result.KeyDefs.Add;
    KeyDef.Top := ((i-1) div 8) + 1;
    KeyDef.Left := i mod 8;
    KeyDef.LogicNumber := i;
  end;
end;

procedure TBinLayout28Test.CheckScanCodes;
var
  S1: TScanCodes;
  S2: TScanCodes;
begin
  S1 := TScanCodes.Create(nil);
  S2 := TScanCodes.Create(nil);
  try
    FTestLayout.CreateCodes(S1);

    BinLayout.Stream.Size := 0;
    BinLayout.SaveCodes(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadCodes(S2, True);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout28Test.CheckNotes;
var
  S1: TNotes;
  S2: TNotes;
begin
  S1 := TNotes.Create(nil);
  S2 := TNotes.Create(nil);
  try
    FTestLayout.CreateNotes(S1);

    BinLayout.SaveNotes(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadNotes(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout28Test.CheckKey;
var
  S1: TKey;
  S2: TKey;
begin
  S1 := TKey.Create(nil);
  S2 := TKey.Create(nil);
  try
    FTestLayout.CreateKey(S1);

    BinLayout.SaveKey(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadKey(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout28Test.CheckKeys;
var
  S1: TKeys;
  S2: TKeys;
  i: Integer;
begin
  S1 := TKeys.Create(nil);
  S2 := TKeys.Create(nil);
  try
    FTestLayout.CreateKeys(S1);
    FTestLayout.CreateKeys(S2);

    BinLayout.SaveKeys(S1);

    BinLayout.Stream.Position := 0;
    for i := 0 to S1.Count-1 do
      S2[i].Address := S1[i].Address;
    BinLayout.LoadKeys(S2);

    BinLayout.Stream.Size := 0;
    BinLayout.Stream.Position := 0;
    BinLayout.SaveKeys(S2);
    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout28Test.CheckKeyLock;
var
  S1: TKeyLock;
  S2: TKeyLock;
begin
  S1 := TKeyLock.Create(nil);
  S2 := TKeyLock.Create(nil);
  try
    FTestLayout.CreateKeyLock(S1);
    FTestLayout.CreateKeyLock(S2);

    BinLayout.SaveKeyLock(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadKeyLock(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout28Test.CheckMSR;
var
  S1: TMSR;
  S2: TMSR;
begin
  S1 := TMSR.Create(nil);
  S2 := TMSR.Create(nil);
  try
    FTestLayout.CreateMSR(S1);
    FTestLayout.CreateMSR(S2);

    BinLayout.SaveMSR(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadMSR(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout28Test.CheckLayer;
var
  S1: TLayer;
  S2: TLayer;
  i: Integer;
begin
  S1 := TLayer.Create(nil);
  S2 := TLayer.Create(nil);
  try
    FTestLayout.CreateLayer(S1);
    FTestLayout.CreateLayer(S2);

    BinLayout.SaveLayer(S1);
    BinLayout.Stream.Position := 0;

    for i := 0 to S1.Keys.Count-1 do
      S2.Keys[i].Address := S1.Keys[i].Address;

    S2.MSR.Address := S1.MSR.Address;
    S2.Keylock.Address := S1.Keylock.Address;

    BinLayout.LoadLayer(S2);
    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout28Test.CheckScanCodes2;
var
  i: Integer;
begin
  for i := 1 to 10 do
    CheckScanCodes;
end;

procedure TBinLayout28Test.CheckScanCodes3(S: TScanCodes);
var
  S1: TScanCodes;
  S2: TScanCodes;
begin
  S1 := TScanCodes.Create(nil);
  S2 := TScanCodes.Create(nil);
  try
    S1.Assign(S);

    BinLayout.Stream.Size := 0;
    BinLayout.SaveCodes(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadCodes(S2, True);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout28Test.CheckScanCodes4;
var
  i: Integer;
  ScanCode: TScanCode;
  ScanCodes: TScanCodes;
begin
  ScanCodes := TScanCodes.Create(nil);
  try
    ScanCodes.Clear;
    for i := 0 to Manager.CodeTable.ScanCodes.Count-1 do
    begin
      ScanCodes.Clear;
      ScanCode := Manager.CodeTable.ScanCodes[i];
      ScanCodes.Add.Assign(ScanCode);
      CheckScanCodes3(ScanCodes);
    end;
  finally
    ScanCodes.Free;
  end;
end;

procedure TBinLayout28Test.CheckLayout;
var
  S1: string;
  S2: string;
  Layout1: TKBLayout;
  Layout2: TKBLayout;
begin
  Layout1 := TKBLayout.Create(nil);
  Layout2 := TKBLayout.Create(nil);
  try
    CreateTestLayout(Layout1);
    Layout1.Keyboard := Keyboard;
    Layout2.Keyboard := Keyboard;

    // Сохраняем в строке
    S1 := BinLayout.SaveToText(Layout1);
    WriteFileData(GetModulePath + 'Layout1.bin', S1);
    // Загружаем из строки
    BinLayout.LoadFromText(Layout2, S1);

    BinLayout.Stream.Size := 0;
    S2 := BinLayout.SaveToText(Layout2);
    WriteFileData(GetModulePath + 'Layout2.bin', S2);
    // Проверяем
    comparer.CheckEqual(Layout1, Layout2);
  finally
    Layout1.Free;
    Layout2.Free;
  end;
end;

initialization
  RegisterTest('', TBinLayout28Test.Suite);

end.
