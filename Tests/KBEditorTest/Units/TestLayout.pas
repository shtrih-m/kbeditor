unit TestLayout;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  KBLayout, Utils, KeyboardManager;

type
  { TTestLayout }

  TTestLayout = class
  public
    class procedure CreateKey(Key: TKey);
    class procedure CreateMSR(MSR: TMSR);
    class procedure CreateKeys(Keys: TKeys);
    class procedure CreateNote(Note: TNote);
    class procedure CreateLayer(Layer: TLayer);
    class procedure CreateNotes(Notes: TNotes);
    class procedure CreateCodes(Codes: TScanCodes);
    class procedure CreateLayout(Layout: TKBLayout);
    class procedure CreateLayers(Layout: TKBLayout);
    class procedure CreateGroups(Groups: TKeyGroups);
    class procedure CreateKeyLock(KeyLock: TKeyLock);
    class procedure CreateTrack(MSRTrack: TMSRTrack);
    class procedure CreateIButton(IButton: TIButton);
    class procedure CreateWheelItem(WheelItem: TWheelItem);
    class procedure CreateIButtonKey(IButtonKey: TIButtonKey);
    class procedure CreateScrollWheel(ScrollWheel: TScrollWheel);
    class procedure CreateKeyPosition(KeyPosition: TKeyPosition);
    class procedure CreateIButtonKeys(IButtonKeys: TIButtonKeys);
  end;

procedure CreateTestLayout(Layout: TKBLayout);

implementation

function RandomBoolean: Boolean;
begin
  Result := Random($FF) > $80;
end;

procedure CreateTestLayout(Layout: TKBLayout);
begin
  TTestLayout.CreateLayout(Layout);
end;

{ TTestLayout }

class procedure TTestLayout.CreateCodes(Codes: TScanCodes);
begin
  Codes.Clear;
  Codes.Add.Assign(Manager.CodeTable.ScanCodes[Random(100)]);
end;

class procedure TTestLayout.CreateNote(Note: TNote);
begin
  Note.Note := Random($FF);
  Note.Interval := Random($FF);
  Note.Volume := Random($FF);
end;

class procedure TTestLayout.CreateNotes(Notes: TNotes);
var
  i: Integer;
begin
  Notes.Clear;
  for i := 0 to 10 do
    CreateNote(Notes.Add);
end;

class procedure TTestLayout.CreateTrack(MSRTrack: TMSRTrack);
begin
  MSRTrack.Enabled := True;
  CreateCodes(MSRTrack.Prefix);
  CreateCodes(MSRTrack.Suffix);
end;

class procedure TTestLayout.CreateMSR(MSR: TMSR);
begin
  MSR.SendEnter := True;
  MSR.LockOnErr := True;

  CreateTrack(MSR.Tracks[0]);
  CreateTrack(MSR.Tracks[1]);
  CreateTrack(MSR.Tracks[2]);
  CreateNotes(MSR.Notes);
end;

class procedure TTestLayout.CreateKeyPosition(KeyPosition: TKeyPosition);
begin
  KeyPosition.LockEnabled := RandomBoolean;
  KeyPosition.PosType := TPosType(Random(sizeof(TPosType)));
  KeyPosition.NcrEmulation := RandomBoolean;
  KeyPosition.NixdorfEmulation := RandomBoolean;


  CreateCodes(KeyPosition.Codes);
  CreateNotes(KeyPosition.Notes);
end;

class procedure TTestLayout.CreateKeyLock(KeyLock: TKeyLock);
var
  i: Integer;
begin
  KeyLock.Clear;
  for i := 1 to 8 do
    CreateKeyPosition(KeyLock.Add);
end;

{ Создаем клавишу }

class procedure TTestLayout.CreateKey(Key: TKey);
begin
  Key.KeyType := TKeyType(Random(SizeOf(TKeyType)-1) + 1);
  Key.RepeatKey := RandomBoolean;
  CreateCodes(Key.PressCodes);        // Коды нажатия
  CreateCodes(Key.ReleaseCodes);      // Коды отжатия
  CreateNotes(Key.Notes);             // Ноты
end;

{ Создаем клавиши }

class procedure TTestLayout.CreateKeys(Keys: TKeys);
var
  Key: TKey;
  KeyNumber: Integer;
  Col, Row:  Integer;
begin
  Keys.Clear;
  KeyNumber := 1;
  for Row := 0 to 7 do
  for Col := 0 to 7 do
  begin
    Key := Keys.Add(Col, Row, KeyNumber);
    Inc(KeyNumber);
    CreateKey(Key);
  end;
end;

class procedure TTestLayout.CreateGroups(Groups: TKeyGroups);
var
  Group: TKeyGroup;
begin
  Groups.Clear;
  Group := Groups.Add;
  Group.Rect := GridRect(1,2,1,2);
end;

class procedure TTestLayout.CreateLayer(Layer: TLayer);
begin
  CreateKeys(Layer.Keys);
  CreateMSR(Layer.MSR);
  CreateKeyLock(Layer.KeyLock);
  CreateIButton(Layer.IButton);
  CreateScrollWheel(Layer.ScrollWheel);
end;

class procedure TTestLayout.CreateLayers(Layout: TKBLayout);
var
  i: Integer;
begin
  for i := 0 to Layout.Layers.Count-1 do
    CreateLayer(Layout.Layers[i]);
end;

class procedure TTestLayout.CreateLayout(Layout: TKBLayout);
begin
  Layout.KeyCount := 64;
  Layout.DeviceVersion := $020A;
  CreateLayers(Layout);
  CreateGroups(Layout.KeyGroups);
end;

class procedure TTestLayout.CreateIButtonKey(IButtonKey: TIButtonKey);
begin
  CreateNotes(IButtonKey.Notes);
  CreateCodes(IButtonKey.Codes);
  IButtonKey.Registered := RandomBoolean;
  IButtonKey.Number := Format('%.8d', [Random(99999999)]);
  IButtonKey.CodeType := TIButtonKeyType(Random(Integer(High(TIButtonKeyType))));
end;

class procedure TTestLayout.CreateIButtonKeys(IButtonKeys: TIButtonKeys);
var
  i: Integer;
begin
  IButtonKeys.Clear;
  for i := 0 to 5 do
    CreateIButtonKey(IButtonKeys.Add);
end;

class procedure TTestLayout.CreateIButton(IButton: TIButton);
begin
  IButton.SendCode := False;
  if IButton.SendCode then
  begin
    CreateNotes(IButton.Notes);
    CreateCodes(IButton.Prefix);
    CreateCodes(IButton.Suffix);
  end else
  begin
    CreateIButtonKeys(IButton.RegKeys);
    CreateIButtonKey(IButton.DefKey);
    IButton.DefKey.Number := '';
  end;
end;

class procedure TTestLayout.CreateWheelItem(WheelItem: TWheelItem);
begin
  CreateCodes(WheelItem.Codes);
  CreateNotes(WheelItem.Notes);
end;

class procedure TTestLayout.CreateScrollWheel(ScrollWheel: TScrollWheel);
begin
  CreateWheelItem(ScrollWheel.ScrollUp);
  CreateWheelItem(ScrollWheel.ScrollDown);
  CreateWheelItem(ScrollWheel.SingleClick);
  CreateWheelItem(ScrollWheel.DoubleClick);
end;

end.
