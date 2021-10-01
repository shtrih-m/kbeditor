unit duTestLayout;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  KBLayout;

procedure CreateLayout(Layout: TKBLayout);

implementation

procedure CreateCode(Code: TScanCode);
begin
  //Code.Text := 'LControl'; { !!! }
  //Code.Code := Random($FFFF); { !!! }
end;

procedure CreateCodes(Codes: TScanCodes);
var
  i: Integer;
begin
  Codes.Clear;
  for i := 1 to 3 do
    CreateCode(Codes.Add);
end;

procedure CreateNote(Note: TNote);
begin
  Note.Note := Random($FF);
  Note.Interval := Random($FF);
  Note.Volume := Random($FF);
end;

procedure CreateNotes(Notes: TNotes);
var
  i: Integer;
begin
  Notes.Clear;
  for i := 0 to 10 do
    CreateNote(Notes.Add);
end;

procedure CreateTrack(MSRTrack: TMSRTrack);
begin
  MSRTrack.Enabled := True;
  CreateCodes(MSRTrack.Prefix);
  CreateCodes(MSRTrack.Suffix);
end;

procedure CreateMSR(MSR: TMSR);
begin
  MSR.SendEnter := True;
  MSR.LockOnErr := True;
  CreateTrack(MSR.Tracks[0]);
  CreateTrack(MSR.Tracks[1]);
  CreateTrack(MSR.Tracks[2]);
  CreateNotes(MSR.Notes);
end;

procedure CreateKeyPosition(KeyPosition: TKeyPosition);
begin
  KeyPosition.LockEnabled := Random($FF) > $80;
  CreateCodes(KeyPosition.Codes);
  CreateNotes(KeyPosition.Notes);
end;

procedure CreateKeyLock(KeyLock: TKeyLock);
var
  i: Integer;
begin
  for i := 0 to KeyLock.Count-1 do
    CreateKeyPosition(KeyLock[i]);
end;

{ Создаем клавишу }

procedure CreateKey(Key: TKey);
begin
  Key.KeyType := TKeyType(Random(SizeOf(TKeyType)));
  Key.RepeatKey := Random($FF) > $80;
  CreateCodes(Key.PressCodes);        // Коды нажатия
  CreateCodes(Key.ReleaseCodes);      // Коды отжатия
  CreateNotes(Key.Notes);             // Ноты
end;

{ Создаем клавиши }

procedure CreateKeys(Layout: TKBLayout; Keys: TKeys);
var
  Key: TKey;
  KeyNumber: Integer;
  Col, Row:  Integer;
begin
  KeyNumber := 1;
  for Row := 0 to Layout.RowCount-1 do
  for Col := 0 to Layout.ColCount-1 do
  begin
    Key := Keys.Add(Col, Row, KeyNumber);
    Inc(KeyNumber);
    CreateKey(Key);
  end;
end;

procedure CreateLayers(Layout: TKBLayout);
var
  i: Integer;
  Layer: TLayer;
begin
  for i := 0 to Layout.Layers.Count-1 do
  begin
    Layer := Layout.Layers[i];
    CreateKeys(Layout, Layer.Keys);
    CreateMSR(Layer.MSR);
    CreateKeyLock(Layer.KeyLock);
  end;
end;

procedure CreateGroups(Groups: TKeyGroups);
var
  i: Integer;
  //Group: TKeyGroup;
begin
  Groups.Clear;
  for i := 1 to 10 do
  begin
    Groups.Add;
    //Group := Groups.Add;
    //Group.Rect := Rect(1,2,3,4); { !!! }
    //Group.Text := 'Test' + IntToStr(Random(123));
    //CreateNotes(Group.Notes);
  end;
end;

procedure CreateLayout(Layout: TKBLayout);
begin
  CreateLayers(Layout);
  CreateGroups(Layout.KeyGroups);
end;

end.
