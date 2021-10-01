unit duCompareLayout;

interface

uses
  // VCL
  SysUtils,
  // This
  KBLayout, Utils, DebugUtils;

type
  { TCompareLayout }

  TCompareLayout = class
  public
    IButtonExists: Boolean;
    ScrollWheelExists: Boolean;

    procedure CheckEqual(S1, S2: TKey); overload;
    procedure CheckEqual(S1, S2: TKeys); overload;
    procedure CheckEqual(S1, S2: TKBLayout); overload;
    procedure CheckEqual(S1, S2: TKeyGroups); overload;
    procedure CheckEqual(S1, S2: TIButtonKey); overload;
    procedure CheckEqual(S1, S2: TIButtonKeys); overload;
    procedure CheckEqual(S1, S2: TScanCode); overload;
    procedure CheckEqual(S1, S2: TScanCodes); overload;
    procedure CheckEqual(S1, S2: TNotes); overload;
    procedure CheckEqual(S1, S2: TScrollWheel); overload;
    procedure CheckEqual(S1, S2: TIButton); overload;
    procedure CheckEqual(S1, S2: TNote); overload;
    procedure CheckEqual(S1, S2: TWheelItem); overload;
    procedure CheckEqual(S1, S2: TLayer); overload;
    procedure CheckEqual(S1, S2: TMSR); overload;
    procedure CheckEqual(S1, S2: TKeyGroup); overload;
    procedure CheckEqual(S1, S2: TLayers); overload;
    procedure CheckEqual(S1, S2: TKeyLock); overload;
    procedure CheckEqual(S1, S2: TKeyPosition); overload;
    procedure CheckEqual(S1, S2: TMSRTracks); overload;
    procedure CheckEqual(S1, S2: TMSRTrack); overload;
    procedure CheckEqualKey(S1, S2: TIButtonKey);
  end;

implementation

procedure Check(Value: Boolean; const S: string);
begin
  if not Value then
    raise Exception.Create(S);
end;

procedure CheckInt(S1, S2: Integer; const S: string);
begin
  if S1 <> S2 then
    raise Exception.CreateFmt('%d <> %d. ' + S, [S1, S2]);
end;

{ TCompareLayout }

procedure TCompareLayout.CheckEqual(S1, S2: TScrollWheel);
begin
  if not ScrollWheelExists then Exit;

  CheckEqual(S1.ScrollUp, S2.ScrollUp);
  CheckEqual(S1.ScrollDown, S2.ScrollDown);
  CheckEqual(S1.SingleClick, S2.SingleClick);
  CheckEqual(S1.DoubleClick, S2.DoubleClick);
end;

procedure TCompareLayout.CheckEqual(S1, S2: TNotes);
var
  i: Integer;
begin
  Check(S1.Count = S2.Count, 'TNotes: S1.Count <> S2.Count');
  for i := 0 to S1.Count-1 do
  begin
    CheckEqual(S1[i], S2[i]);
  end;
end;

procedure TCompareLayout.CheckEqual(S1, S2: TNote);
begin
  Check(S1.Note = S2.Note, 'TNote: S1.Note <> S2.Note');
  Check(S1.Interval = S2.Interval, 'TNote: S1.Interval <> S2.Interval');
  Check(S1.Volume = S2.Volume, 'TNote: S1.Volume <> S2.Volume');
end;

procedure TCompareLayout.CheckEqual(S1, S2: TIButton);
begin
  if not IButtonExists then Exit;

  CheckEqual(S1.Notes, S2.Notes);
  CheckEqual(S1.Prefix, S2.Prefix);
  CheckEqual(S1.Suffix, S2.Suffix);
  CheckEqual(S1.DefKey, S2.DefKey);
  CheckEqual(S1.RegKeys, S2.RegKeys);
  Check(S1.SendCode = S2.SendCode, 'TIButton: S1.SendCode <> S2.SendCode');
end;

procedure TCompareLayout.CheckEqual(S1, S2: TIButtonKeys);
var
  i: Integer;
begin
  Check(S1.Count = S2.Count, 'TIButtonKeys: S1.Count <> S2.Count');
  for i := 0 to S1.Count-1 do
  begin
    CheckEqual(S1[i], S2[i]);
  end;
end;

procedure TCompareLayout.CheckEqual(S1, S2: TIButtonKey);
begin
  Check(S1.Number = S2.Number, 'TIButtonKey: S1.Number <> S2.Number');
  Check(S1.CodeType = S2.CodeType, 'TIButtonKey: S1.CodeType <> S2.CodeType');

  CheckEqual(S1.Notes, S2.Notes);
  CheckEqual(S1.Codes, S2.Codes);
end;

procedure TCompareLayout.CheckEqualKey(S1, S2: TIButtonKey);
begin
  Check(S1.CodeType = S2.CodeType, 'TIButtonKey: S1.CodeType <> S2.CodeType');
  CheckEqual(S1.Notes, S2.Notes);
  CheckEqual(S1.Codes, S2.Codes);
end;

procedure TCompareLayout.CheckEqual(S1, S2: TScanCodes);
var
  i: Integer;
begin
  CheckInt(S1.Count, S2.Count, 'TScanCodes: S1.Count <> S2.Count');

  for i := 0 to S1.Count-1 do
  begin
    CheckEqual(S1[i], S2[i]);
  end;
end;

procedure TCompareLayout.CheckEqual(S1, S2: TScanCode);
begin
  Check(S1.Text = S2.Text, 'TScanCode: S1.Text <> S2.Text');
  Check(S1.Code = S2.Code, 'TScanCode: S1.Code <> S2.Code');
  Check(S1.ScanCode = S2.ScanCode, 'TScanCode: S1.ScanCode <> S2.ScanCode');
  Check(S1.CodeType = S2.CodeType, 'TScanCode: S1.CodeType <> S2.CodeType');
end;

procedure TCompareLayout.CheckEqual(S1, S2: TWheelItem);
begin
  CheckEqual(S1.Notes, S2.Notes);
  CheckEqual(S1.Codes, S2.Codes);
end;

procedure TCompareLayout.CheckEqual(S1, S2: TKeyPosition);
begin
  Check(S1.PosType = S2.PosType, 'TKeyPosition: S1.PosType <> S2.PosType');
  Check(S1.LockEnabled = S2.LockEnabled, 'TKeyPosition: S1.LockEnabled <> S2.LockEnabled');
  Check(S1.NcrEmulation = S2.NcrEmulation, 'TKeyPosition: S1.NcrEmulation <> S2.NcrEmulation');
  Check(S1.NixdorfEmulation = S2.NixdorfEmulation, 'TKeyPosition: S1.NixdorfEmulation <> S2.NixdorfEmulation');

  CheckEqual(S1.Notes, S2.Notes);
  CheckEqual(S1.Codes, S2.Codes);
end;

procedure TCompareLayout.CheckEqual(S1, S2: TKeyLock);
var
  i: Integer;
begin
  Check(S1.Count = S2.Count, 'TKeyLock.CheckEqual: S1.Count <> S2.Count');
  // Items
  for i := 0 to S1.Count - 1 do
  begin
    CheckEqual(S1[i], S2[i]);
  end;
end;

procedure TCompareLayout.CheckEqual(S1, S2: TMSRTrack);
begin
  Check(S1.Enabled = S2.Enabled, 'TMSRTrack.CheckEqual: S1.Enabled <> S2.Enabled');

  CheckEqual(S1.Suffix, S2.Suffix);
  CheckEqual(S1.Prefix, S2.Prefix);
end;

procedure TCompareLayout.CheckEqual(S1, S2: TMSRTracks);
var
  i: Integer;
begin
  // Count
  Check(S1.Count = S2.Count, 'TMSRTracks.CheckEqual: S1.Count <> S2.Count');
  // Items
  for i := 0 to S1.Count - 1 do
  begin
    CheckEqual(S1[i], S2[i]);
  end;
end;

procedure TCompareLayout.CheckEqual(S1, S2: TMSR);
begin
  Check(S1.SendEnter = S2.SendEnter, 'TMSR.CheckEqual: S1.SendEnter <> S2.SendEnter');
  Check(S1.LockOnErr = S2.LockOnErr, 'TMSR.CheckEqual: S1.LockOnErr <> S2.LockOnErr');

  CheckEqual(S1.Tracks, S2.Tracks);
  CheckEqual(S1.Notes, S2.Notes);
end;

procedure TCompareLayout.CheckEqual(S1, S2: TLayer);
begin
  CheckEqual(S1.Keys, S2.Keys);
  CheckEqual(S1.MSR, S2.MSR);
  CheckEqual(S1.KeyLock, S2.KeyLock);
  CheckEqual(S1.IButton, S2.IButton);
  CheckEqual(S1.ScrollWheel, S2.ScrollWheel);
end;

procedure TCompareLayout.CheckEqual(S1, S2: TLayers);
var
  i: Integer;
begin
  Check(S1.Count = S2.Count, 'TLayers.CheckEqual: S1.Count <> S2.Count');
  for i := 0 to S1.Count - 1 do
  begin
    CheckEqual(S1[i], S2[i]);
  end;
end;

procedure TCompareLayout.CheckEqual(S1, S2: TKeyGroup);
begin
  Check(IsEqualRect(S1.Rect, S2.Rect),
    'TKeyGroup.CheckEqual: IsEqualRect(S1.Rect, S2.Rect)');
end;

procedure TCompareLayout.CheckEqual(S1, S2: TKeyGroups);
var
  i: Integer;
begin
  Check(S1.Count = S2.Count, 'TKeyGroups.CheckEqual: S1.Count <> S2.Count');
  for i := 0 to S1.Count - 1 do
  begin
    CheckEqual(S1[i], S2[i]);
  end;
end;

procedure TCompareLayout.CheckEqual(S1, S2: TKey);
begin
  Check(S1.Text = S2.Text, 'TKey.CheckEqual: S1.Text <> S2.Text');
  Check(S1.KeyType = S2.KeyType, 'TKey.CheckEqual: S1.KeyType <> S2.KeyType');
  Check(S1.RepeatKey = S2.RepeatKey, 'TKey.CheckEqual: S1.RepeatKey <> S2.RepeatKey');

  CheckEqual(S1.Notes, S2.Notes);
  CheckEqual(S1.PressCodes, S2.PressCodes);
  CheckEqual(S1.ReleaseCodes, S2.ReleaseCodes);
end;

procedure TCompareLayout.CheckEqual(S1, S2: TKeys);
var
  i: Integer;
begin
  Check(S1.Count = S2.Count, 'TKeys.CheckEqual: S1.Count <> S2.Count');
  for i := 0 to S1.Count - 1 do
  begin
    CheckEqual(S1[i], S2[i]);
  end;
end;

procedure TCompareLayout.CheckEqual(S1, S2: TKBLayout);
begin
  Check(S1.ColCount = S2.ColCount, 'S1.ColCount <> S2.ColCount');
  Check(S1.RowCount = S2.RowCount, 'S1.RowCount <> S2.RowCount');
  Check(S1.FileName = S2.FileName, 'S1.FileName <> S2.FileName');
  Check(S1.IsModified = S2.IsModified, 'S1.IsModified <> S2.IsModified');
  //Check(S1.KeyCount = S2.KeyCount, 'S1.KeyCount <> S2.KeyCount');

  CheckEqual(S1.Layers, S2.Layers);
  CheckEqual(S1.KeyGroups, S2.KeyGroups);
end;

end.
