unit duScanCodeTest;

interface

uses
  //VCL
  SysUtils, Classes,
  // This
  TestFramework, KBLayout, LogMessage;

type
  { TScanCodeTest }

  TScanCodeTest = class(TTestCase)
  private
    Lines: TStrings;
    ScanCodes: TScanCodes;
    procedure AddLogMessage(Sender: TObject; const S: string; LayoutID, ItemID: Integer);
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckMaxCodeLength;
    procedure CheckMaxCodeLength2;
    procedure CheckSimpleText;
    procedure CheckData;
    procedure CheckKeyData;
  end;

implementation

{ TScanCodeTest }

procedure TScanCodeTest.Setup;
begin
  inherited Setup;
  Lines := TStringList.Create;
  ScanCodes := TScanCodes.Create(nil);
  LogMessages.OnLogMessage := AddLogMessage;
end;

procedure TScanCodeTest.TearDown;
begin
  Lines.Free;
  ScanCodes.Free;
  inherited TearDown;
end;

procedure TScanCodeTest.AddLogMessage(Sender: TObject; const S: string;
  LayoutID, ItemID: Integer);
begin
  Lines.Add(S);
end;

procedure TScanCodeTest.CheckMaxCodeLength;
var
  i: Integer;
  Text: string;
  Result: Boolean;
begin
  Text := '';
  for i := 1 to 255 do
    Text := Text + '+M ';

  ScanCodes.AsText := Text;
  Text := Text + '+M ';
  try
    ScanCodes.AsText := Text;
    Result := False;
  except
    Result := True;
  end;
  Check(Result);
end;

procedure TScanCodeTest.CheckMaxCodeLength2;
var
  i: Integer;
  Text: string;
  Result: Boolean;
  ScanCode: TScanCode;
begin
  Text := '';
  for i := 1 to 255 do
  begin
    ScanCode := ScanCodes.Add;
    ScanCode.Code := #1;
    ScanCode.CodeType := ctMake;
  end;

  try
    ScanCode := ScanCodes.Add;
    ScanCode.Code := #1;
    ScanCode.CodeType := ctMake;
    Result := False;
  except
    Result := True;
  end;
  Check(Result);
end;

procedure TScanCodeTest.CheckSimpleText;
var
  Text: string;
  SimpleText: string;
  ScanCodes: TScanCodes;
begin
  ScanCodes := TScanCodes.Create(nil);
  try
    // Правильная последовательность
    Text := '+LCtrl +LShift +A -A +B -B +C -C -LShift -LCtrl';
    SimpleText := 'LCtrl+LShift+ABC';
    ScanCodes.AsText := Text;
    CheckEquals(SimpleText, ScanCodes.SimpleText, 'SimpleText');
    // Правильная последовательность
    Text := '+LCtrl +F6 -F6 -LCtrl +F1 -F1';
    SimpleText := 'LCtrl+F6F1';
    ScanCodes.AsText := Text;
    CheckEquals(SimpleText, ScanCodes.SimpleText, 'SimpleText');
    //Отжатия идут не в том порядке
    Text := '+LCtrl +F6 -LCtrl -F6';
    ScanCodes.AsText := Text;
    CheckEquals(Text, ScanCodes.SimpleText, 'SimpleText');
    // Сначала идет отжатие
    Text := '+LCtrl -LCtrl -F6 +F6';
    ScanCodes.AsText := Text;
    CheckEquals(Text, ScanCodes.SimpleText, 'SimpleText');
    // Непарный код
    Text := '+LCtrl -LCtrl +F6 -F6 -F1';
    ScanCodes.AsText := Text;
    CheckEquals(Text, ScanCodes.SimpleText, 'SimpleText');
  finally
    ScanCodes.Free;
  end;
end;

procedure TScanCodeTest.CheckData;
var
  CheckResult: TCheckResult;
begin
  // Правильные данные
  CheckResult.ErrCount := 0;
  ScanCodes.AsText := '+LCtrl -LCtrl';
  Check(ScanCodes.CheckScanCodes(CheckResult));
  Check(Lines.Count = 0);
  // Нет кода отжатия
  Lines.Clear;
  CheckResult.ErrCount := 0;
  ScanCodes.AsText := '+LCtrl';
  Check(not ScanCodes.CheckScanCodes(CheckResult));
  Check(Lines.Count = 1);
  CheckEquals('Scancode +LCtrl: No release scancode defined', Trim(Lines[0]));
  // Отжатие перед нажатием
  Lines.Clear;
  CheckResult.ErrCount := 0;
  ScanCodes.AsText := '-LCtrl +LCtrl -LCtrl';
  Check(not ScanCodes.CheckScanCodes(CheckResult));
  CheckEquals(1, Lines.Count, 'Lines.Count');
  CheckEquals('Scancode -LCtrl: Release scancode is before press scancode',
    Trim(Lines[0]), 'Lines[0]');
end;

procedure TScanCodeTest.CheckKeyData;
var
  Key: TKey;
begin
  Key := TKey.Create(nil);
  try
    Key.PressCodes.AsText := '+A -A';
    Key.ReleaseCodes.AsText := '+B -B';
    CheckEquals(True, Key.CheckData, 'Key.CheckData');
    //
    Lines.Clear;
    Key.Col := 1;
    Key.Row := 1;
    Key.PressCodes.AsText := '+A +B';
    Key.ReleaseCodes.AsText := '-A';
    CheckEquals(False, Key.CheckData, 'Key.CheckData');
    CheckEquals(1, Lines.Count, 'Lines.Count');
    CheckEquals('Button (1, 1).  Scancode +B: No release scancode defined', Lines[0], 'Lines[0]');
    //
    Lines.Clear;
    Key.Col := 1;
    Key.Row := 1;
    Key.PressCodes.AsText := '+A';
    Key.ReleaseCodes.AsText := '';
    CheckEquals(False, Key.CheckData, 'Key.CheckData');
    CheckEquals(1, Lines.Count, 'Lines.Count');
    CheckEquals('Button (1, 1).  Scancode +A: No release scancode defined', Lines[0], 'Lines[0]');
  finally
    Key.Free;
  end;
end;

initialization
  RegisterTest('', TScanCodeTest.Suite);

end.
