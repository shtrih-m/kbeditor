unit KeyboardFrame;

interface

uses
  // VCL
  SysUtils,
  // This
  DeviceError;

type
  { TKeyboardFrame }

  TKeyboardFrame = class
  public
    class function GetCRC(const Data: string): Byte;
    class function Encode(const Data: string): string;
    class function Decode(const Data: string): string;
  end;

  { EFrameException }

  EFrameException = class(Exception);

implementation

const
  STX =  #2;

resourcestring
  MsgCRCError = 'CRC error';
  MsgMinFrameLength = 'Insufficient frame length';
  MsgFrameFormatSTX = 'Invalid frame format, first byte is not STX';

class function TKeyboardFrame.GetCRC(const Data: string): Byte;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Data) do
    Result := Result xor Ord(Data[i]);
end;

class function TKeyboardFrame.Encode(const Data: string): string;
var
  DataLen: Integer;
begin
  DataLen := Length(Data);
  Result := Chr(DataLen) + Data;
  Result := STX + Result + Chr(GetCRC(Result));
end;

class function TKeyboardFrame.Decode(const Data: string): string;
var
  CRC: Byte;
  S: string;
  DataLength: Integer;
  ResultCode: Integer;
  ResultCodeDescription: string;
begin
  // Check minimum frame length
  if Length(Data) < 5 then
    raise EFrameException.Create(MsgMinFrameLength);
  // Check for STX
  if Data[1] <> STX then
    raise EFrameException.Create(MsgFrameFormatSTX);

  // Check frame CRC
  CRC := Ord(Data[Length(Data)]);
  S := Copy(Data, 2, Length(Data)-2);
  if GetCRC(S) <> CRC then
    raise EFrameException.Create(MsgCRCError);

  // Check result code
  ResultCode := Ord(Data[4]);
  ResultCodeDescription := GetErrorText(ResultCode);
  if ResultCode <> 0 then
    RaiseError(ResultCode, Format('%.8x, %s', [ResultCode, ResultCodeDescription]));

  DataLength := Ord(Data[2])-2;
  Result := Copy(Data, 5, DataLength);
end;

end.
