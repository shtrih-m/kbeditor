unit untBinFmt;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Consts,
  // This
  untLayout, untUtil, AddrItem, ScanCode, untBinStm, untTypes;

type
  { TBinFile }

  TBinFile = class
  public
    procedure UpdateKeyTypes(Layout: TLayout);
    procedure LoadKey(Key: TKey; Stream: TBinStream);
    procedure LoadNotes(Notes: TNotes; Stream: TBinStream);
    procedure SaveNotes(Notes: TNotes; Stream: TBinStream);
    procedure LoadLayers(Layout: TLayout; Stream: TBinStream);
    procedure LoadLayout(Layout: TLayout; Stream: TBinStream);
    procedure SaveLayout(Layout: TLayout; Stream: TBinStream);
    procedure LoadCodes(Codes: TScanCodes; Stream: TBinStream);
    procedure SaveCodes(Codes: TScanCodes; Stream: TBinStream);
    procedure LoadKeyLock(KeyLock: TKeyLock; Stream: TBinStream);
    procedure SaveGroups(Groups: TKeyGroups; Stream: TBinStream);
    procedure LoadGroups(Groups: TKeyGroups; Stream: TBinStream);
    procedure SaveKeyLock(KeyLock: TKeyLock; Stream: TBinStream);
    procedure SaveKey(Key: TKey; Index: Integer; Stream: TBinStream);
    procedure SaveMSR(Layout: TLayout; MSR: TMSR; Stream: TBinStream);
    procedure LoadMSR(Layout: TLayout; MSR: TMSR; Stream: TBinStream);
    function GetKeyType(Layout: TLayout; Col, Row: Integer): TKeyType;
    function GetLayerKeyType(KeyType: TKeyType; Index: Integer): TKeyType;
    procedure LoadLayer(Layout: TLayout; Layer: TLayer; Stream: TBinStream);
    function AddressByIndex(Layout: TLayout; LIndex, KIndex: Integer): Word;
    procedure SaveLayer(Layout: TLayout; Index: Integer; Stream: TBinStream);
    function GetKeyAddress(Layout: TLayout; LayerIndex, KeyIndex: Integer): Word;
    procedure SaveKeys(Layout: TLayout; LayerIndex: Integer; Stream: TBinStream);
  public
    function SaveToString(Layout: TLayout): string;
    procedure SaveToStream(Layout: TLayout; Stream: TStream);
    procedure LoadFromStream(Layout: TLayout; Stream: TStream);
    procedure LoadFromString(Layout: TLayout; const Data: string);

    procedure SaveToFile(Layout: TLayout; const FileName: string);
    procedure LoadFromFile(Layout: TLayout; const FileName: string);
  end;

function NotesToStr(Notes: TNotes): string;

implementation

function NotesToStr(Notes: TNotes): string;
var
  i: Integer;
  Note: TNote;
begin
  // ���������� ���
  Result := Chr(Notes.Count);
  for i := 0 to Notes.Count-1 do
  begin
    Note := Notes[i];
    Result := Result + Chr(Note.Note);       // ����
    Result := Result + Chr(Note.Time);       // ������������ ����
    Result := Result + Chr(Note.Volume);     // ��������� ����
  end;
end;

{ TBinFile }

function TBinFile.GetKeyAddress(Layout: TLayout; LayerIndex, KeyIndex: Integer): Word;
begin
  Result := 2 + Layout.LayerCount*2 + 2*LayerIndex * (Layout.KeyCount+2) +
    KeyIndex*2;
end;

{*****************************************************************************}
{
{
{
{*****************************************************************************}

function TBinFile.AddressByIndex(Layout: TLayout;
  LIndex, KIndex: Integer): Word;
begin
  Result := 2 + Layout.LayerCount*2 + 2*LIndex * (Layout.KeyCount+2) +
    KIndex*2;
end;

procedure TBinFile.SaveCodes(Codes: TScanCodes; Stream: TBinStream);
var
  i: Integer;
  Code: TScanCode;
begin
  // ���������� ����-�����
  Stream.WriteByte(Codes.Count);
  // ����-����
  for i := 0 to Codes.Count-1 do
  begin
    Code := Codes[i];
    Stream.WriteWord(Code.Code);
  end;
end;

{****************************************************************************}
{
{    ������ ����� �������
{
{    Key        - �������, ������� ����� ��������
{    Stream     - ������ �����
{
{****************************************************************************}

procedure TBinFile.SaveKey(Key: TKey; Index: Integer; Stream: TBinStream);

  function GetLayerNumber(Key: TKey; Index: Integer): Byte;
  begin
    Result := 0;
    case Key.KeyType of

      ktGoUp:
      begin
        Result := Index;
        if Result < 3 then Inc(Result);
      end;
      ktGoDown:
      begin
        Result := Index;
        if Result > 0 then Dec(Result);
      end;
      ktGo0: Result := 0;
      ktGo1: Result := 1;
      ktGo2: Result := 2;
      ktGo3: Result := 3;
      ktTemp0: Result := 0;
      ktTemp1: Result := 1;
      ktTemp2: Result := 2;
      ktTemp3: Result := 3;
    end;
  end;

  function GetSFB(Key: TKey; Index: Integer): Byte;
  begin
    { ����� ���� }
    Result := GetLayerNumber(Key, Index) shl 1;
    { ������� �� ���� }
    if Key.KeyType <> ktMacros then Result := Result or 1;
    { ��������� ������� �� ���� }
    if Key.KeyType in [ktTemp0, ktTemp1, ktTemp2, ktTemp3] then
      Result := Result or $8;
    { ������ }
    if Key.RepeatKey then Result := Result or $10;
  end;

var
  SFB: Byte;
begin
  // SFB
  SFB := GetSFB(Key, Index);
  Stream.WriteByte(SFB);

  if Key.KeyType = ktMacros then
  begin
    // ���� �������
    SaveCodes(Key.PressCodes, Stream);
    // ���� �������
    SaveCodes(Key.ReleaseCodes, Stream);
  end else
  begin
    Stream.WriteByte(0);
    Stream.WriteByte(0);
  end;
  // ������
  SaveNotes(Key.Notes, Stream);
end;

{****************************************************************************}
{
{       ������ ���������� ����������� ��������� ���� - MSR
{
{       MSR     - ����������� MSR
{       Stream  - ������ ������
{
{****************************************************************************}

procedure TBinFile.SaveMSR(Layout: TLayout; MSR: TMSR; Stream: TBinStream);

  function GetSFB(MSR: TMSR): Byte;
  begin
    Result := 0;
    if MSR.Track1.Enabled then Result := Result or 1;   // ��� 0
    if MSR.Track2.Enabled then Result := Result or 2;   // ��� 1
    if MSR.Track3.Enabled then Result := Result or 4;   // ��� 2
    if MSR.LockOnErr then Result := Result or $10;      // ��� 4
    if MSR.SendEnter then Result := Result or $20;      // ��� 5
  end;

  procedure SaveTrack(Track: TMSRTrack; Stream: TBinStream);
  begin
    // ������� ���� 1
    SaveCodes(Track.Prefix, Stream);
    // ������� ���� 1
    SaveCodes(Track.Suffix, Stream);
  end;

var
  SFB: Byte;
begin
  // SFB
  SFB := GetSFB(MSR);
  Stream.WriteByte(SFB);
  if Layout.Track1 then SaveTrack(MSR.Track1, Stream);
  if Layout.Track2 then SaveTrack(MSR.Track2, Stream);
  if Layout.Track3 then SaveTrack(MSR.Track3, Stream);
  // ������
  Stream.AddStr(NotesToStr(MSR.Notes));
end;

{ ������ ������ ���� }

procedure TBinFile.SaveKeys(Layout: TLayout; LayerIndex: Integer;
  Stream: TBinStream);

  procedure WriteKey(Key: TKey; Index: Integer; Stream: TBinStream);
  begin
    if not Key.Changed then
    begin
      Stream.WriteWord($FFFF);
    end else
    begin
      Stream.WriteWord(Stream.Size);
      Stream.Position := Stream.Size;
      SaveKey(Key, Index, Stream);
    end;
  end;

var
  Key: TKey;
  i: Integer;
  Layer: TLayer;
  GroupKey: TKey;
  Group: TKeyGroup;
  Col, Row: Integer;
  AddrItem: TAddrItem;
  AddrItems: TAddrItems;
begin
  AddrItems := TAddrItems.Create;
  try
    Layer := Layout.Layers[LayerIndex];

    for i := 0 to Layer.Keys.Count-1 do
    begin
      Key := Layer.Keys[i];
      Col := Key.Col;
      Row := Key.Row;

      Stream.Position := GetKeyAddress(Layout, LayerIndex, i);
      Group := Layout.GetGroup(Col, Row);
      // ���� ������� � ������, �� ������� ������-�������
      // ���� ������� �� � ������, �� ������� ���� �������
      if Group <> nil then
      begin
        GroupKey := Layer.GetKey(Group.Rect.Left, Group.Rect.Top);
        if GroupKey <> nil then
        begin
          // ����� ������ ������� ������
          AddrItem := AddrItems.Find(GroupKey.Col, GroupKey.Row);
          if AddrItem <> nil then
          begin
            Stream.WriteWord(AddrItem.Address);
          end else
          begin
            // ��������� � ������
            AddrItem := AddrItems.Add;
            AddrItem.Col := GroupKey.Col;
            AddrItem.Row := GroupKey.Row;
            AddrItem.Address := Stream.Size;
            // ����� ����� � �������
            WriteKey(Key, LayerIndex, Stream);
          end;
        end else
        begin
          WriteKey(Key, LayerIndex, Stream);
        end;
      end else
      begin
        WriteKey(Key, LayerIndex, Stream);
      end;
    end;
  finally
    AddrItems.Free;
  end;
end;

{****************************************************************************}
{
{    ������ ������ ���� � ������
{
{    Layer      - ����, ������� ����� ��������
{    AddrTbl    - ������ �����
{    DataTbl    - ������ ������
{
{****************************************************************************}

procedure TBinFile.SaveLayer(Layout: TLayout; Index: Integer;
  Stream: TBinStream);
var
  Layer: TLayer;
begin
  Layer := Layout.Layers[Index];
  // �������
  SaveKeys(Layout, Index, Stream);
  // MSR
  Stream.Position := AddressByIndex(Layout, Index, Layout.KeyCount);
  Stream.WriteWord(Stream.Size);
  Stream.Position := Stream.Size;
  SaveMSR(Layout, Layer.MSR, Stream);
  // KeyLock
  Stream.Position := AddressByIndex(Layout, Index, Layout.KeyCount+1);
  Stream.WriteWord(Stream.Size);
  Stream.Position := Stream.Size;
  SaveKeyLock(Layer.KeyLock, Stream);
end;

{****************************************************************************}
{
{    ������ ������ ��������� � ������
{
{****************************************************************************}

function TBinFile.SaveToString(Layout: TLayout): string;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    SaveToStream(Layout, Stream);
    Result := Stream.AsString;
  finally
    Stream.Free;
  end;
end;

{****************************************************************************}
{
{    ������ ����-�����
{
{****************************************************************************}

procedure TBinFile.LoadCodes(Codes: TScanCodes; Stream: TBinStream);
var
  i: Integer;
  Count: Integer;
  ScanCode: TScanCode;
  ScanCodeRec: TScanCodeRec;
begin
  Codes.Clear;
  Count := Stream.ReadByte;
  for i := 0 to Count-1 do
  begin
    ScanCode := Codes.Add;
    ScanCode.Code := Stream.ReadWord;

    ScanCodeRec.Code := ScanCode.Code;
    if FindScanCode(ScanCodeRec) then
      ScanCode.Text := ScanCodeRec.Text;
  end;
end;

{ ������ ��� }

procedure TBinFile.SaveNotes(Notes: TNotes; Stream: TBinStream);
begin
  Stream.AddStr(NotesToStr(Notes));
end;

{****************************************************************************}
{
{    ������ ���
{
{****************************************************************************}

procedure TBinFile.LoadNotes(Notes: TNotes; Stream: TBinStream);
var
  i: Integer;
  Count: Byte;
  Note: TNote;
begin
  Notes.Clear;
  Count := Stream.ReadByte;
  for i := 0 to Count-1 do
  begin
    Note := Notes.Add;
    // ����
    Note.Note := Stream.ReadByte;
    // ������������ ����
    Note.Time := Stream.ReadByte;
    // ��������� ����
    Note.Volume := Stream.ReadByte;
  end;
end;

{****************************************************************************}
{
{       ������ ���������� ����������� ��������� ���� - MSR
{
{****************************************************************************}

procedure TBinFile.LoadMSR(Layout: TLayout; MSR: TMSR; Stream: TBinStream);

  procedure LoadTrack(Track: TMSRTrack; Stream: TBinStream);
  begin
    // �������
    LoadCodes(Track.Prefix, Stream);
    // �������
    LoadCodes(Track.Suffix, Stream);
  end;

var
  SFB: Byte;
begin
  MSR.Clear;
  // SFB
  SFB := Stream.ReadByte;

  MSR.Track1.Enabled := (SFB and 1) = 1;
  MSR.Track2.Enabled := (SFB and 2) = 2;
  MSR.Track3.Enabled := (SFB and 4) = 4;
  MSR.LockOnErr := (SFB and $10) = $10;
  MSR.SendEnter := (SFB and $20) = $20;
  // �����
  if Layout.Track1 then LoadTrack(MSR.Track1, Stream);
  if Layout.Track2 then LoadTrack(MSR.Track2, Stream);
  if Layout.Track3 then LoadTrack(MSR.Track3, Stream);
  // ������
  LoadNotes(MSR.Notes, Stream);
end;

{****************************************************************************}
{
{       ��������� ���� ������� �� FSB
{
{****************************************************************************}

function SFBToKeyType(SFB: Integer): TKeyType;
var
  TempKey: Boolean;           // ������� ���������� ��������
  ChangeLayer: Boolean;       // ������� ��������� ����
  LayerNumber: Integer;       // ����� ����
begin
  TempKey := (SFB and 8)=8;
  ChangeLayer := (SFB and 1)=1;
  LayerNumber := (SFB shr 1)and 3;

  if ChangeLayer then
  begin
    if TempKey then
    begin
      case LayerNumber of
        0: Result := ktTemp0;
        1: Result := ktTemp1;
        2: Result := ktTemp2;
        3: Result := ktTemp3;
      else
        Result := ktTemp0;
      end;
    end else
    begin
      case LayerNumber of
        0: Result := ktGo0;
        1: Result := ktGo1;
        2: Result := ktGo2;
        3: Result := ktGo3;
      else
        Result := ktGo0;
      end;
    end;
  end else
  begin
    Result := ktMacros;
  end;
end;

{****************************************************************************}
{
{       ������ ���������� ����
{
{****************************************************************************}

procedure TBinFile.LoadKey(Key: TKey; Stream: TBinStream);
var
  SFB: Byte;
begin
  // FSB
  SFB := Stream.ReadByte;
  Key.RepeatKey := (SFB and $10) = $10;
  Key.KeyType := SFBToKeyType(SFB);
  // ���� �������
  LoadCodes(Key.PressCodes, Stream);
  // ���� �������
  LoadCodes(Key.ReleaseCodes, Stream);
  // ����
  LoadNotes(Key.Notes, Stream);
end;

procedure TBinFile.LoadLayer(Layout: TLayout; Layer: TLayer;
  Stream: TBinStream);

  function SetDataAddress(Stream: TBinStream; var Address: Word): Boolean;
  var
    DataAddress: Word;
  begin
    Stream.Position := Address;
    DataAddress := Stream.ReadWord;
    Result := DataAddress <> $FFFF;
    if Result then
      Stream.Position := DataAddress;
    Inc(Address, 2);
  end;

var
  i: Integer;
  Keys: TKeys;
  Address: Word;
begin
  // ������ ������
  Address := Stream.Position;
  Keys := Layer.Keys;
  for i := 0 to Layout.KeyCount-1 do
  begin
    if SetDataAddress(Stream, Address) then
    begin
      LoadKey(Keys[i], Stream);
    end;
  end;
  // ������ ���������� ����������� ����
  if SetDataAddress(Stream, Address) then
    LoadMSR(Layout, Layer.MSR, Stream);
  // ������ ���������� ����� ����������
  if SetDataAddress(Stream, Address) then
    LoadKeyLock(Layer.KeyLock, Stream);
end;

{****************************************************************************}
{
{       ��������� ���� �������
{
{****************************************************************************}

function TBinFile.GetLayerKeyType(KeyType: TKeyType; Index: Integer): TKeyType;
begin
  Result := ktNone;
  case KeyType of
    ktGo0:
      begin
        if Index = 0 then Result := ktGoDown;
        if Index = 1 then Result := ktGoDown;
      end;
    ktGo1:
      begin
        if Index = 0 then Result := ktGoUp;
        if Index = 2 then Result := ktGoDown;
      end;
    ktGo2:
      begin
        if Index = 1 then Result := ktGoUp;
        if Index = 3 then Result := ktGoDown;
      end;
    ktGo3:
      begin
        if Index = 2 then Result := ktGoUp;
        if Index = 3 then Result := ktGoUp;
      end;
  end;
end;

{****************************************************************************}
{
{       ��������� ���� �������
{
{****************************************************************************}

function TBinFile.GetKeyType(Layout: TLayout; Col, Row: Integer): TKeyType;
var
  Key: TKey;
  i: Integer;
  Layer: TLayer;
  KeyType: TKeyType;
begin
  Result := ktNone;
  for i := 0 to Layout.Layers.Count-1 do
  begin
    Layer := Layout.Layers[i];
    Key := Layer.GetKey(Col, Row);
    if Key = nil then
    begin
      Result := ktNone;
      Break;
    end;

    KeyType := GetLayerKeyType(Key.KeyType, i);
    if KeyType = ktNone then
    begin
      Result := ktNone;
      Break;
    end;
    // �������� �� ����������
    if Result = ktNone then
    begin
      Result := KeyType;
    end else
    begin
      if KeyType <> Result then
      begin
        Result := ktNone;
        Break;
      end;
    end;
  end;
end;

{****************************************************************************}
{
{       ���������� ����� ������.
{       ��� ����� ��� ��������� ����� ktGoUp, ktGoDown
{
{****************************************************************************}

procedure TBinFile.UpdateKeyTypes(Layout: TLayout);
var
  i: Integer;
  Key: TKey;
  Layer: TLayer;
  KeyType: TKeyType;
  Row, Col: Integer;
begin
  if Layout.Layers.Count = 0 then Exit;
  for Col := 0 to Layout.ColCount-1 do
  for Row := 0 to Layout.RowCount-1 do
  begin
    KeyType := GetKeyType(Layout, Col, Row);
    if KeyType <> ktNone then
    begin
      for i := 0 to Layout.Layers.Count-1 do
      begin
        Layer := Layout.Layers[i];
        Key := Layer.GetKey(Col, Row);
        if Key <> nil then
          Key.KeyType := KeyType;
      end;
    end;
  end;
end;

{ ������ ����� }

procedure TBinFile.LoadLayers(Layout: TLayout; Stream: TBinStream);
var
  i: Integer;
  Address: Word;
begin
  for i := 0 to Layout.Layers.Count-1 do
  begin
    Stream.Position := i*2 + 2;
    Address := Stream.ReadWord;
    Stream.Position := Address;
    LoadLayer(Layout, Layout.Layers[i], Stream);
  end;
  // ���������� ����� ������
  UpdateKeyTypes(Layout);
end;

procedure TBinFile.LoadLayout(Layout: TLayout; Stream: TBinStream);
var
  DataAddr: Word;
begin
  // ������ ������ ������������
  Stream.Position := 0;
  DataAddr := Stream.ReadWord;
  Stream.Position := DataAddr;
  Layout.Version := Stream.ReadWord;
  if Layout.Version = $0100 then
  begin
    Stream.Position := Stream.Position + 2;
    LoadGroups(Layout.Groups, Stream);
    Layout.Model := TModel(Stream.ReadByte);
  end;
  // ������ ������ �����
  LoadLayers(Layout, Stream);
end;

{****************************************************************************}
{
{    ������ ������ ��������� �� ������
{
{****************************************************************************}

procedure TBinFile.LoadFromStream(Layout: TLayout; Stream: TStream);
var
  BinStream: TBinStream;
begin
  BinStream := TBinStream.Create;
  try
    Stream.Position := 0;
    BinStream.LoadFromStream(Stream);
    BinStream.Position := 0;
    LoadLayout(Layout, BinStream);
  finally
    BinStream.Free;
  end;
end;

{****************************************************************************}
{
{    ������ ������ ��������� �� ������
{
{****************************************************************************}

procedure TBinFile.LoadFromString(Layout: TLayout; const Data: string);
var
  Stream: TStream;
begin
  if Length(Data) = 0 then Exit;
  Stream := TMemoryStream.Create;
  try
    Stream.WriteBuffer(Data[1], Length(Data));
    LoadFromStream(Layout, Stream);
  finally
    Stream.Free;
  end;
end;

{****************************************************************************}
{
{    ������ ������ ��������� � �����
{
{****************************************************************************}

procedure TBinFile.SaveToStream(Layout: TLayout; Stream: TStream);
var
  BinStream: TBinStream;
begin
  BinStream := TBinStream.Create;
  try
    SaveLayout(Layout, BinStream);
    BinStream.SaveToStream(Stream);
  finally
    BinStream.Free;
  end;
end;

{****************************************************************************}
{
{    ������ ������ ��������� � �����
{
{****************************************************************************}

procedure TBinFile.SaveLayout(Layout: TLayout; Stream: TBinStream);
var
  i: Integer;
  DataSize: DWORD;
  LayerSize: Word;              // ������ ������� �����
  LayerStart: Word;
  LayersStart: Word;            // ����� ������ �����
begin
  DataSize := 2*(1 + Layout.LayerCount + Layout.LayerCount*(Layout.KeyCount+2));
  Stream.Size := DataSize;
  // ������ �����
  LayersStart := Layout.LayerCount*2 + 2;     // ����� ������ �����
  LayerSize := (Layout.KeyCount + 2)*2;       // ������ ������� ��������
  for i := 0 to Layout.LayerCount-1 do
  begin
    // ����� ����
    LayerStart := LayersStart + i*LayerSize;
    Stream.Position := 2*(i+1);
    Stream.WriteWord(LayerStart);
    // ������ ����
    SaveLayer(Layout, i, Stream);
  end;
  // ���������������� ������

  // ����� ������ ������������
  DataSize := Stream.Size;              // ����� ������
  Stream.Position := 0;
  Stream.WriteWord(DataSize);
  Stream.Position := Stream.Size;       // ���������� � �����
  // ������ ��
  Stream.WriteWord($0100);
  // ������ ��������
  Stream.WriteWord(0);
  // ������
  SaveGroups(Layout.Groups, Stream);
  // ��������� ���������
  Stream.WriteByte(Ord(Layout.Model));
  // ������ ��������
  Stream.Position := DataSize + 2;
  Stream.WriteWord(Stream.Size);
end;

{****************************************************************************}
{
{    ������ ��������� � �������� ����
{
{****************************************************************************}

procedure TBinFile.SaveToFile(Layout: TLayout; const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Layout, Stream);
  finally
    Stream.Free;
  end;
end;

{****************************************************************************}
{
{    ������ ��������� �� ��������� �����
{
{****************************************************************************}

procedure TBinFile.LoadFromFile(Layout: TLayout; const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Layout, Stream);
  finally
    Stream.Free;
  end;
end;

{ ������ ���������� ����� ���������� }

procedure TBinFile.LoadKeyLock(KeyLock: TKeyLock; Stream: TBinStream);

  procedure ReadPosition(Position: TKeyPosition; Stream: TBinStream);
  begin
    LoadCodes(Position.Codes, Stream);
    LoadNotes(Position.Notes, Stream);
  end;

var
  SFB: Byte;
  i: Integer;
  Position: TKeyPosition;
begin
  SFB := Stream.ReadByte;
  for i := 0 to KeyLock.Count-1 do
  begin
    Position := KeyLock[i];
    if i < 8 then Position.LockEnabled := TestBit(SFB, i);
    ReadPosition(Position, Stream);
  end;
end;

procedure TBinFile.SaveKeyLock(KeyLock: TKeyLock; Stream: TBinStream);

  function GetSFB(KeyLock: TKeyLock): Byte;
  var
    i: Integer;
    Position: TKeyPosition;
  begin
    Result := 0;
    for i := 0 to KeyLock.Count-1 do
    begin
      Position := KeyLock[i];
      if Position.LockEnabled and (i < 8) then
        Result := Result + (1 shl i);
    end;
  end;

  procedure WritePosition(Position: TKeyPosition; Stream: TBinStream);
  begin
    SaveCodes(Position.Codes, Stream);
    SaveNotes(Position.Notes, Stream);
  end;

var
  i: Integer;
begin
  Stream.WriteByte(GetSFB(KeyLock));
  for i := 0 to KeyLock.Count-1 do
    WritePosition(KeyLock[i], Stream);
end;

{ ���������� ����� }

procedure TBinFile.SaveGroups(Groups: TKeyGroups; Stream: TBinStream);
var
  i: Integer;
  Rect: TRect;
  Group: TKeyGroup;
begin
  Stream.WriteByte(Groups.Count);
  for i := 0 to Groups.Count-1 do
  begin
    Group := Groups[i];
    Rect := Group.Rect;
    Stream.WriteByte(Rect.Left);
    Stream.WriteByte(Rect.Top);
    Stream.WriteByte(Rect.Right);
    Stream.WriteByte(Rect.Bottom);
  end;
end;

{ ���������� ����� }

procedure TBinFile.LoadGroups(Groups: TKeyGroups; Stream: TBinStream);
var
  i: Integer;
  Count: Byte;
  Rect: TRect;
  Group: TKeyGroup;
begin
  Groups.Clear;
  Count := Stream.ReadByte;
  for i := 0 to Count-1 do
  begin
    Group := Groups.Add;
    Rect.Left := Stream.ReadByte;
    Rect.Top := Stream.ReadByte;
    Rect.Right := Stream.ReadByte;
    Rect.Bottom := Stream.ReadByte;
    Group.Rect := Rect;
  end;
end;

end.
