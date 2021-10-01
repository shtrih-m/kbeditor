unit Utils;

interface

uses
  // VCL
  Windows, Messages, Classes, Controls, SysUtils, stdctrls, Graphics, comctrls,
  // This
  GridType;

resourcestring
  MsgLayer              = 'Layer ';
  MsgAttention          = 'Attention';
  MsgInvalidFileFormat  = 'Invalid file format';

const
  PS2DeviceName = 'PS/2 keyboard by Shtrih-M';

  // Path to file with update info
  // http://support.shtrih-m.ru/data/SoftUpdates/KBEditor.txt
  SoftUpdatePath = 'data/SoftUpdates/';

type
  TPageChangeType = (pctNeedNext);
  TViewMode = (vmLayout, vmPicture, vmSimple);


procedure InvalidFileFormat(const S: string);
function RectWidth(const R: TRect): Integer;
function RectHeight(const R: TRect): Integer;
function IsEqualRect(Src, Dst: TGridRect): Boolean;
function GridRect(Left, Top, Right, Bottom: Longint): TGridRect;

function Min(I1, I2: Integer): Integer;
function GetLayerName(Index: Integer): string;
function TestBit(Value, Bit: Integer): Boolean;
procedure SetBit(var Value: Byte; Bit: Integer);
procedure ReadXmlFileNames(const Path: string; Items: TStrings);

function StrToHex(const S: string): string;
function StrToBin(const S: string): string;
function HexToStr(const Data: string): string;


function SetToInteger(const SetValue; SizeOfSetType: Integer): Integer;
procedure IntegerToSet(const IntValue: Integer; SizeOfSetType: Integer; var SetValue);

procedure SafeSetChecked(CheckBox: TCheckBox; Value: Boolean);
procedure SafeSetCheckedRadio(CheckBox: TRadioButton; Value: Boolean);
procedure SafeSetEdit(Edit: TEdit; const Value: String);

function GetGraphicExt(Picture: TPicture): string;
function GetPictureRect(Graphic: TGraphic; const SrcRect: TRect): TRect;

function GetFileName(const FileName: string): string;

function GetListBoxItem(ListBox: TListBox): string;
function GetListBoxObject(ListBox: TListBox): Integer;
procedure SetListItem(ListBox: TListBox; Value: Integer);

implementation

procedure InvalidFileFormat(const S: string);
begin
  raise EParserError.Create(MsgInvalidFileFormat);
end;

//  If picture is bigger than cell - resize it proportionally

function GetPictureRect(Graphic: TGraphic; const SrcRect: TRect): TRect;
var
  K: Double;
  ARect: TRect;
  x, y: Integer;
begin
  ARect.Top := SrcRect.Top + 10;
  ARect.Left := SrcRect.Left + 10;
  ARect.Right := SrcRect.Right - 10;
  ARect.Bottom := SrcRect.Bottom - 10;

  K := Graphic.Width / Graphic.Height;
  if (Graphic.Width > RectWidth(ARect)) or
  (Graphic.Height > RectHeight(ARect)) then
  begin
    Result := ARect;
    if (Graphic.Width - RectWidth(ARect)) >
      (Graphic.Height - RectHeight(ARect)) then
    begin
      Result.Bottom := Round((Result.Right - Result.Left)/k) + Result.Top;
    end else
    begin
      Result.Right := Round((Result.Bottom - Result.Top)*k) + Result.Left;
    end;
  end else
  begin
    Result.Left := ARect.Left;
    Result.Top := ARect.Top;
    Result.Bottom := ARect.Top + Graphic.Height;
    Result.Right := ARect.Left + Graphic.Width;
  end;
  x := ARect.Left + ((ARect.Right - ARect.Left) -
        RectWidth(Result)) div 2;
  y := ARect.Top + ((ARect.Bottom - ARect.Top) -
        RectHeight(Result)) div 2;
  Result.Right := x + RectWidth(Result);
  Result.Left := x;
  Result.Bottom := y + RectHeight(Result);
  Result.Top := y;
end;

function GetFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('.\:', FileName);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, 1, I-1) else
    Result := '';
end;

function GetGraphicExt(Picture: TPicture): string;
begin
  Result := '';
  if Picture.Graphic is TBitmap then
    Result := 'bmp';
  if Picture.Graphic is TIcon then
    Result := 'ico';
  if Picture.Graphic is TMetafile then
    Result := 'wmf';
end;

procedure SafeSetEdit(Edit: TEdit; const Value: String);
var
  SaveOnChange: TNotifyEvent;
begin
  SaveOnChange := Edit.OnChange;
  Edit.OnChange := nil;
  try
    Edit.Text := Value;
  finally
    Edit.OnChange := SaveOnChange;
  end;
end;

procedure SafeSetCheckedRadio(CheckBox: TRadioButton; Value: Boolean);
var
  SaveOnClick: TNotifyEvent;
begin
  SaveOnClick := CheckBox.OnClick;
  CheckBox.OnClick := nil;
  try
    CheckBox.Checked := Value;
  finally
    CheckBox.OnClick := SaveOnClick;
  end;
end;

procedure SafeSetChecked(CheckBox: TCheckBox; Value: Boolean);
var
  SaveOnClick: TNotifyEvent;
begin
  SaveOnClick := CheckBox.OnClick;
  CheckBox.OnClick := nil;
  try
    CheckBox.Checked := Value;
  finally
    CheckBox.OnClick := SaveOnClick;
  end;
end;

function HexToChar(const Data: string): Char;
begin
  Result := Chr(StrToInt('$' + Data));
end;

function HexToStr(const Data: string): string;
var
  C: Char;
  i: Integer;
  PrevChar: Char;
  HasPrev: Boolean;
begin
  Result := '';
  PrevChar := #0;
  HasPrev := False;
  for i := 1 to Length(Data) do
  begin
    C := Data[i];
    if C in ['0'..'9', 'A'..'F', 'a'..'f'] then
    begin
      if HasPrev then
      begin
        Result := Result + HexToChar(PrevChar + C);
        HasPrev := False;
      end else
      begin
        PrevChar := C;
        HasPrev := True;
      end;
    end else
    begin
      if HasPrev then
        Result := Result + HexToChar(PrevChar);
      HasPrev := False;
    end;
  end;
  if HasPrev then
    Result := Result + HexToChar(PrevChar);
end;

function StrToHex(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + IntToHex(Ord(S[i]), 2) + ' ';
end;

function StrToBin(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + IntToHex(Ord(S[i]), 2);
end;

function GetTimeStamp: string;
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  Result := Format('[%.2d.%.2d.%.4d %.2d:%.2d:%.2d.%.3d] ',
    [Day, Month, Year, Hour, Min, Sec, MSec]);
end;

function Min(I1, I2: Integer): Integer;
begin
  if I1 < I2 then Result := I1 else Result := I2;
end;

function GetLayerName(Index: Integer): string;
begin
  Result := MsgLayer + IntToStr(Index+1);
end;

function TestBit(Value, Bit: Integer): Boolean;
begin
  Result := (Value and (1 shl Bit)) <> 0;
end;

procedure SetBit(var Value: Byte; Bit: Integer);
begin
  Value := Value or (1 shl Bit);
end;

procedure ReadXmlFileNames(const Path: string; Items: TStrings);
var
  FileInfo: TSearchRec;
const
  FileMask = '*.xml';
  FileAttr = faReadOnly + faHidden + faSysFile + faArchive;
begin
  ChDir(Path);
  Items.Clear;
  if FindFirst(FileMask, FileAttr, FileInfo) = 0 then
  begin
    repeat
      Items.Add(IncludeTrailingBackslash(Path) + FileInfo.Name);
    until FindNext(FileInfo) <> 0;
    FindClose(FileInfo);
  end;
end;

function SetToInteger(const SetValue; SizeOfSetType: Integer): Integer;
begin
  case SizeOfSetType of
  1: Result := Byte(SetValue);
  2: Result := Word(SetValue);
  4: Result := Integer(SetValue);
  else
    raise Exception.Create('Invalid size of set');
  end;
end;

procedure IntegerToSet(const IntValue: Integer; SizeOfSetType: Integer; var SetValue);
begin
  case SizeOfSetType of
  1: Byte(SetValue) := IntValue;
  2: Word(SetValue) := IntValue;
  4: Integer(SetValue) := IntValue;
  else
    raise Exception.Create('Invalid size of set');
  end;
end;

function RectWidth(const R: TRect): Integer;
begin
  Result := R.Right - R.Left;
end;

function RectHeight(const R: TRect): Integer;
begin
  Result := R.Bottom - R.Top;
end;

function GetListBoxItem(ListBox: TListBox): string;
begin
  Result := ListBox.Items[ListBox.ItemIndex];
end;

function GetListBoxObject(ListBox: TListBox): Integer;
begin
  Result := Integer(ListBox.Items.Objects[ListBox.ItemIndex]);
end;

procedure SetListItem(ListBox: TListBox; Value: Integer);
begin
  ListBox.ItemIndex := ListBox.Items.IndexOfObject(TObject(Value));
end;

function IsEqualRect(Src, Dst: TGridRect): Boolean;
begin
  Result :=
    (Src.Top = Dst.Top) and
    (Src.Left = Dst.Left) and
    (Src.Right = Dst.Right) and
    (Src.Bottom = Dst.Bottom);
end;

function GridRect(Left, Top, Right, Bottom: Longint): TGridRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

end.
