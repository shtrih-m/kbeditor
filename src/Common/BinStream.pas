unit BinStream;

interface

uses
  // VCL
  Classes;
  
type
  { TBinStream }

  TBinStream = class(TMemoryStream)
  private
    function GetAsString: string;
  public
    function ReadByte: Byte;
    function ReadWord: Word;
    function ReadString(Count: Integer): string;
    procedure WriteByte(const Value: Byte);
    procedure WriteWord(const Value: Word);
    procedure WriteString(const S: string);

    property AsString: string read GetAsString;
  end;

function CheckSummCalculate(Stream: TBinStream): WORD;

implementation

function CheckSummCalculate(Stream: TBinStream): WORD;
var
  i: Integer;
  CS: WORD;
begin
  Stream.Position := 0;
  Result := 0;
  for i := 0 to Stream.Size - 1 do
  begin
    CS := Stream.ReadByte;
    Result := Word(Result + CS);
  end;
end;

{ TBinStream }

procedure TBinStream.WriteByte(const Value: Byte);
var
  C: Char;
begin
  C := Chr(Value);
  WriteBuffer(C, 1);
end;

procedure TBinStream.WriteWord(const Value: Word);
var
  S: string;
begin
  S := Chr(Lo(Value)) + Chr(Hi(Value));
  WriteBuffer(S[1], 2);
end;

procedure TBinStream.WriteString(const S: string);
begin
  if Length(S) > 0 then
  begin
    WriteBuffer(S[1], Length(S));
  end;
end;

function TBinStream.ReadByte: Byte;
begin
  ReadBuffer(Result, 1);
end;

function TBinStream.ReadWord: Word;
begin
  ReadBuffer(Result, 2);
end;

function TBinStream.ReadString(Count: Integer): string;
begin
  Result := '';
  if Count = 0 then Exit;
  SetLength(Result, Count);
  ReadBuffer(Result[1], Count);
end;

function TBinStream.GetAsString: string;
begin
  Result := '';
  if Size > 0 then
  begin
    SetLength(Result, Size);
    Move(Memory^, Result[1], Size);
  end;
end;

end.
