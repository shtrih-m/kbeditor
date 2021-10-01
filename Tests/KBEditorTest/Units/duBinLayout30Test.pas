unit duBinLayout30Test;

interface

uses
  // VCL
  Windows, SysUtils, Graphics, Classes,
  // This
  TestFramework, TestLayout, KBLayout, KeyboardManager, Keyboard,
  Utils, DebugUtils, FileUtils, BinLayout30, duCompareLayout;

type
  { TBinLayout30Test }

  TBinLayout30Test = class(TTestCase)
  private
    FTestLayout: TTestLayout;
    FBinLayout: TBinLayout30;
    FKeyboard: TKeyboard;
    FComparer: TCompareLayout;

    procedure CheckScanCodes3(S: TScanCodes);
    function CreateTestKeyboard: TKeyboard;

    property BinLayout: TBinLayout30 read FBinLayout;
    property Keyboard: TKeyboard read FKeyboard;
    property Comparer: TCompareLayout read FComparer;
  protected
    procedure Setup; override;
    procedure TearDown; override;

    procedure CheckLayout2; { !!! }
    procedure CompareFiles(const FileName1, FileName2: string);
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
    procedure CheckIButton;
    procedure CheckScrollWheel;
    procedure CheckIButtonKey;
    procedure CheckIButtonKeys;
    procedure CheckIButton2;

    procedure CheckLayout;
  end;

implementation

{ TBinLayout30Test }

procedure TBinLayout30Test.Setup;
begin
  FKeyboard := CreateTestKeyboard;
  FTestLayout := TTestLayout.Create;
  FBinLayout := TBinLayout30.Create(nil);
  FBinLayout.Keyboard := FKeyboard;
  FComparer := TCompareLayout.Create;
  FComparer.IButtonExists := True;
  FComparer.ScrollWheelExists := True;
end;

procedure TBinLayout30Test.TearDown;
begin
  FComparer.Free;
  FBinLayout.Free;
  FTestLayout.Free;
end;

function TBinLayout30Test.CreateTestKeyboard: TKeyboard;
var
  i: Integer;
  KeyDef: TKeyDef;
begin
  //Manager.Keyboards.Clear;
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

procedure TBinLayout30Test.CheckScanCodes;
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

procedure TBinLayout30Test.CheckNotes;
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

procedure TBinLayout30Test.CheckKey;
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

procedure TBinLayout30Test.CheckKeys;
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

procedure TBinLayout30Test.CheckKeyLock;
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

procedure TBinLayout30Test.CheckMSR;
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

procedure TBinLayout30Test.CheckLayer;
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
    S2.IButton.Address := S1.IButton.Address;
    S2.ScrollWheel.Address := S1.ScrollWheel.Address;

    BinLayout.LoadLayer(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout30Test.CheckScanCodes2;
var
  i: Integer;
begin
  for i := 1 to 100 do CheckScanCodes;
end;

procedure TBinLayout30Test.CheckScanCodes3(S: TScanCodes);
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

procedure TBinLayout30Test.CheckScanCodes4;
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

procedure TBinLayout30Test.CheckLayout;
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
    CreateTestLayout(Layout2);

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

procedure TBinLayout30Test.CheckIButton;
var
  S1: TIButton;
  S2: TIButton;
begin
  S1 := TIButton.Create(nil);
  S2 := TIButton.Create(nil);
  try
    S1.SendCode := True;
    FTestLayout.CreateIButton(S1);
    S2.SendCode := S1.SendCode;


    BinLayout.SaveIButton(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadIButton(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout30Test.CheckIButton2;
var
  S1: TIButton;
  S2: TIButton;
begin
  S1 := TIButton.Create(nil);
  S2 := TIButton.Create(nil);
  try
    S1.SendCode := False;
    FTestLayout.CreateIButton(S1);
    S2.SendCode := S1.SendCode;

    BinLayout.SaveIButton(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadIButton(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout30Test.CheckIButtonKey;
var
  S1: TIButtonKey;
  S2: TIButtonKey;
begin
  S1 := TIButtonKey.Create(nil);
  S2 := TIButtonKey.Create(nil);
  try
    FTestLayout.CreateIButtonKey(S1);

    BinLayout.SaveIButtonKey(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadIButtonKey(S2);

    comparer.CheckEqualKey(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout30Test.CheckIButtonKeys;
var
  S1: TIButton;
  S2: TIButton;
begin
  S1 := TIButton.Create(nil);
  S2 := TIButton.Create(nil);
  try
    FTestLayout.CreateIButtonKeys(S1.RegKeys);

    BinLayout.SaveIButtonKeys(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadIButtonKeys(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout30Test.CheckScrollWheel;
var
  S1: TScrollWheel;
  S2: TScrollWheel;
begin
  S1 := TScrollWheel.Create(nil);
  S2 := TScrollWheel.Create(nil);
  try
    FTestLayout.CreateScrollWheel(S1);

    BinLayout.SaveScrollWheel(S1);
    BinLayout.Stream.Position := 0;
    BinLayout.LoadScrollWheel(S2);

    comparer.CheckEqual(S1, S2);
  finally
    S1.Free;
    S2.Free;
  end;
end;

procedure TBinLayout30Test.CompareFiles(const FileName1, FileName2: string);
var
  Data1: string;
  Data2: string;
begin
  Data1 := ReadFileData(FileName1);
  Data2 := ReadFileData(FileName2);
  Check(Data1 = Data2, Format('%s <> %s', [
    ExtractFileName(FileName1), ExtractFileName(FileName2)]));
end;

procedure TBinLayout30Test.CheckLayout2;
(*
var
  Data: string;
  FileName1: string;
  FileName2: string;
  Layout1: TKBLayout;
  Layout2: TKBLayout;
  Keyboard: TKeyboard;
*)  
begin
(*
  Layout1 := TKBLayout.Create(nil);
  Layout2 := TKBLayout.Create(nil);
  try
    FileName1 := GetModulePath + 'Data\Layouts\KB-64RiB.xml';
    FileName2 := GetModulePath + 'Data\Layouts\KB-64RiB_2.xml';

    Keyboard := Manager.Keyboards.ItemByID(6);
    //Layout.Keyboard := Keyboard;
    Manager.LoadFromFile(Layout, 0, FileName1);
    Data := BinLayout.SaveToText(Layout);
    BinLayout.LoadFromText(Layout, Data);
    Manager.SaveToFile(Layout, 0, FileName2);

    CompareFiles(FileName1, FileName2);
  finally
    Layout1.Free;
    Layout2.Free;
  end;
*)  
end;

//initialization
//RegisterTest('', TBinLayout30Test.Suite);

end.
