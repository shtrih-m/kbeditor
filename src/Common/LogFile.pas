unit LogFile;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs, SysConst, Variants;

const
  TagInfo         = '[ INFO] ';
  TagTrace        = '[TRACE] ';
  TagDebug        = '[DEBUG] ';
  TagError        = '[ERROR] ';
  SSeparator  = '************************************************************';
  StrLen      = 20;

type
  TStringEvent = procedure (Sender: TObject; const Line: string) of object;

  { TLogFile }

  TLogFile = class
  private
    FHandle: THandle;
    FFileName: string;
    FFilePath: string;
    FEnabled: Boolean;
    FSeparator: string;
    FLock: TCriticalSection;
    FOnMessage: TStringEvent;

    procedure Lock;
    procedure Unlock;
    procedure OpenFile;
    procedure CloseFile;
    procedure SetDefaults;
    function GetOpened: Boolean;
    function GetFileName: string;
    procedure SetEnabled(Value: Boolean);
    procedure Write(const Data: string);
    procedure AddLine(const Data: string);
    procedure SetFileName(const Value: string);

    property Opened: Boolean read GetOpened;
    class function ParamsToStr(const Params: array of const): string;
  public
    constructor Create;
    destructor Destroy; override;

    class function GetTimeStamp: string;
    class function GetLogLine(const Data: string): string;

    procedure Info(const Data: string); overload;
    procedure Debug(const Data: string); overload;
    procedure Trace(const Data: string); overload;
    procedure Error(const Data: string); overload;
    procedure Error(const Data: string; E: Exception); overload;
    procedure Info(const Data: string; Params: array of const); overload;
    procedure Debug(const Data: string; Params: array of const); overload;
    procedure Trace(const Data: string; Params: array of const); overload;
    procedure Error(const Data: string; Params: array of const); overload;
    procedure Debug(const Data: string; Params: array of const; Result: Variant); overload;
    procedure WriteRxData(const Data: string);
    procedure WriteTxData(const Data: string);
    procedure WriteData(const Prefix, Data: string);

    property Enabled: Boolean read FEnabled write SetEnabled;
    property FilePath: string read FFilePath write FFilePath;
    property FileName: string read FFileName write SetFileName;
    property Separator: string read FSeparator write FSeparator;
    property OnMessage: TStringEvent read FOnMessage write FOnMessage;
  end;

function Logger: TLogFile;
procedure LogDebugData(const Prefix, Data: string);

implementation

type
  TVariantArray = array of Variant;

function ConstArrayToVarArray(const AValues : array of const): TVariantArray;
var
  i : Integer;
begin
  SetLength(Result, Length(AValues));
  for i := Low(AValues) to High(AValues) do
  begin
    with AValues[i] do
    begin
      case VType of
        vtInteger: Result[i] := VInteger;
        vtInt64: Result[i] := VInt64^;
        vtBoolean: Result[i] := VBoolean;
        vtChar: Result[i] := VChar;
        vtExtended: Result[i] := VExtended^;
        vtString: Result[i] := VString^;
        vtPointer: Result[i] := Integer(VPointer);
        vtPChar: Result[i] := StrPas(VPChar);
        vtObject: Result[i]:= Integer(VObject);
        vtAnsiString: Result[i] := String(VAnsiString);
        vtCurrency: Result[i] := VCurrency^;
        vtVariant: Result[i] := VVariant^;
        vtInterface: Result[i]:= Integer(VPointer);
        vtWideString: Result[i]:= WideString(VWideString);
      else
        Result[i] := NULL;
      end;
    end;
  end;
end;

function VarArrayToStr(const AVarArray: TVariantArray): string;
var
  I: Integer;
begin
  Result := '';
  for i := Low(AVarArray) to High(AVarArray) do
  begin
    if Length(Result) > 0 then
      Result := Result + ', ';
    if VarIsNull(AVarArray[I]) then
      Result := Result + 'NULL'
    else
      Result := Result + VarToStr(AVarArray[I]);
  end;
  Result := '(' + Result + ')';
end;

function StrToHex(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    if i <> 1 then Result := Result + ' ';
    Result := Result + IntToHex(Ord(S[i]), 2);
  end;
end;

var
  FLogger: TLogFile;

function Logger: TLogFile;
begin
  if FLogger = nil then
    FLogger := TLogFile.Create;
  Result := FLogger;
end;

function GetModuleFileName: string;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

function GetModuleFileNameStr: string;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

function GetLastErrorText: string;
begin
  Result := Format(SOSError, [GetLastError,  SysErrorMessage(GetLastError)]);
end;

procedure LogDebugData(const Prefix, Data: string);
var
  Line: string;
const
  DataLen = 20; // Max data string length
begin
  Line := Data;
  repeat
    Logger.Debug(Prefix + StrToHex(Copy(Line, 1, DataLen)));
    Line := Copy(Line, DataLen + 1, Length(Line));
  until Line = '';
end;

procedure ODS(const S: string);
begin
{$IFDEF DEBUG}
  OutputDebugString(PChar(S));
{$ENDIF}
end;

{ Преобразование строки в текст, чтобы увидеть все символы }

function StrToText(const Text: string): string;
var
  Code: Byte;
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Text) do
  begin
    Code := Ord(Text[i]);
    if Code < $20 then
      Result := Result + Format('''#$%.2x''', [Code])
    else
      Result := Result + Text[i];
  end;
end;

{ TLogFile }

constructor TLogFile.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FHandle := INVALID_HANDLE_VALUE;
  FSeparator := SSeparator;
  SetDefaults;
end;

destructor TLogFile.Destroy;
begin
  CloseFile;
  FLock.Free;
  inherited Destroy;
end;

class function TLogFile.GetTimeStamp: string;
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  Result := Format('%.2d.%.2d.%.4d %.2d:%.2d:%.2d.%.3d ',[
    Day, Month, Year, Hour, Min, Sec, MSec]);
end;

procedure TLogFile.Lock;
begin
  FLock.Enter;
end;

procedure TLogFile.Unlock;
begin
  FLock.Leave;
end;

function TLogFile.GetFileName: string;
begin
  Result := IncludeTrailingPathDelimiter(FilePath) +
    ChangeFileExt(ExtractFileName(GetModuleFileNameStr), '') + '_' +
    FormatDateTime('dd.mm.yyyy', Date) + '.log';
end;

procedure TLogFile.SetDefaults;
begin
  Enabled := False;         // Disabled by default
  FileName := ChangeFileExt(GetModuleFileName, '.log');
  FilePath := IncludeTrailingPathDelimiter(ExtractFilePath(GetModuleFileName)) + 'Logs';
end;

procedure TLogFile.OpenFile;
var
  FileName: string;
begin
  Lock;
  try
    if not Opened then
    begin
      if not DirectoryExists(FilePath) then
      begin
        ODS(Format('Log directory is not exists, "%s"', [FilePath]));
        if not CreateDir(FilePath) then
        begin
          ODS('Failed to create log directory');
          ODS(GetLastErrorText);
        end;
      end;

      FileName := GetFileName;
      FHandle := CreateFile(PChar(GetFileName), GENERIC_READ or GENERIC_WRITE,
        FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);

      if Opened then
      begin
        FileSeek(FHandle, 0, 2); // 0 from end
        FFileName := FileName;
      end else
      begin
        ODS(Format('Failed to create log file "%s"', [FileName]));
        ODS(GetLastErrorText);
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TLogFile.CloseFile;
begin
  Lock;
  try
    if Opened then
      CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
  finally
    Unlock;
  end;
end;

function TLogFile.GetOpened: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

procedure TLogFile.SetEnabled(Value: Boolean);
begin
  if Value <> Enabled then
  begin
    FEnabled := Value;
    CloseFile;
  end;
end;

procedure TLogFile.SetFileName(const Value: string);
begin
  if Value <> FileName then
  begin
    CloseFile;
    FFileName := Value;
  end;
end;

procedure TLogFile.Write(const Data: string);
var
  S: string;
  Count: DWORD;
begin
  Lock;
  try
    ODS(Data);
    if not Enabled then Exit;
    S := Data;

    if GetFileName <> FFileName then
    begin
      CloseFile;
    end;
    OpenFile;
    if Opened then
    begin
      WriteFile(FHandle, S[1], Length(S), Count, nil);
      FlushFileBuffers(FHandle);
    end;
  finally
    Unlock;
  end;
end;

class function TLogFile.GetLogLine(const Data: string): string;
begin
  Result := Format('[%s] [%.8d] %s', [GetTimeStamp, GetCurrentThreadID,
    StrToText(Data) + #13#10]);
end;

procedure TLogFile.AddLine(const Data: string);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Self, Data);

  Write(GetLogLine(Data));
end;

procedure TLogFile.Trace(const Data: string);
begin
  AddLine(TagTrace + Data);
end;

procedure TLogFile.Info(const Data: string);
begin
  AddLine(TagInfo + Data);
end;

procedure TLogFile.Error(const Data: string);
begin
  AddLine(TagError + Data);
end;

procedure TLogFile.Error(const Data: string; E: Exception);
begin
  AddLine(TagError + Data + ' ' + E.Message);
end;

procedure TLogFile.Debug(const Data: string);
begin
  AddLine(TagDebug + Data);
end;

class function TLogFile.ParamsToStr(const Params: array of const): string;
begin
  Result := VarArrayToStr(ConstArrayToVarArray(Params));
end;

procedure TLogFile.Debug(const Data: string; Params: array of const);
begin
  Debug(Data + ParamsToStr(Params));
end;

procedure TLogFile.Debug(const Data: string; Params: array of const;
  Result: Variant);
begin
  Debug(Data + ParamsToStr(Params) + '=' + VarToStr(Result));
end;

procedure TLogFile.Error(const Data: string; Params: array of const);
begin
  Error(Data + ParamsToStr(Params));
end;

procedure TLogFile.Info(const Data: string; Params: array of const);
begin
  Info(Data + ParamsToStr(Params));
end;

procedure TLogFile.Trace(const Data: string; Params: array of const);
begin
  Trace(Data + ParamsToStr(Params));
end;

procedure TLogFile.WriteRxData(const Data: string);
begin
  WriteData('<- ', Data);
end;

procedure TLogFile.WriteTxData(const Data: string);
begin
  WriteData('-> ', Data);
end;

procedure TLogFile.WriteData(const Prefix, Data: string);
var
  I: Integer;
  Text: string;
  Count: Integer;
  DataLen: Integer;
begin
  DataLen := Length(Data);
  Count := DataLen div StrLen;
  if (DataLen mod StrLen) <> 0 then
    Inc(Count);
  if Count = 0 then
    Inc(Count);
  for i := 0 to Count - 1 do
  begin
    Text := Prefix + StrToHex(Copy(Data, 1 + i * StrLen, StrLen));
    Debug(Text);
  end;
end;

initialization

finalization
  ODS('LogFile.finalization.0');
  FLogger.Free;
  FLogger := nil;
  ODS('LogFile.finalization.1');

end.
