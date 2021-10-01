unit HttpGet;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, WinInet;

type
  { THttpGet }

  THttpGet = class
  private
    procedure Check(Value: Boolean);
  public
    function GetString(const URL: string): string;
  end;

function GetHttpFile(const URL: string): string;

implementation

function GetHttpFile(const URL: string): string;
var
  HttpGet: THttpGet;
begin
  HttpGet := THttpGet.Create;
  try
    Result := HttpGet.GetString(URL);
  finally
    HttpGet.Free;
  end;
end;

procedure ParseURL(URL: String; var HostName, FileName: String);
var
  i: Integer;
begin
  if Pos('http://', LowerCase(URL)) <> 0 then
    System.Delete(URL, 1, 7);

  i := Pos('/', URL);
  HostName := Copy(URL, 1, i);
  FileName := Copy(URL, i, Length(URL) - i + 1);

  if (Length(HostName) > 0) and (HostName[Length(HostName)] = '/') then
    SetLength(HostName, Length(HostName) - 1);
end;


{ THttpGet }

function GetInetErrorText(ErrorCode: Integer): string;
begin
  case ErrorCode of
    ERROR_HTTP_HEADER_NOT_FOUND:
      Result := 'The requested header could not be located.';
    ERROR_HTTP_DOWNLEVEL_SERVER:
      Result := 'The server did not return any headers.';
    ERROR_HTTP_INVALID_SERVER_RESPONSE:
      Result := 'The server response could not be parsed.';
    ERROR_HTTP_INVALID_HEADER:
      Result := 'The supplied header is invalid.';
    ERROR_HTTP_INVALID_QUERY_REQUEST:
      Result := 'The request made to HttpQueryInfo is invalid.';
    ERROR_HTTP_HEADER_ALREADY_EXISTS:
      Result := 'The header could not be added because it already exists.';
    ERROR_HTTP_REDIRECT_FAILED:
      Result := 'The redirection failed because either the scheme changed (for example, HTTP to FTP) or all attempts made to redirect failed (default is five attempts).';
    ERROR_HTTP_NOT_REDIRECTED:
      Result := 'The HTTP request was not redirected.';
    ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION:
      Result := 'The HTTP cookie requires confirmation.';
    ERROR_HTTP_COOKIE_DECLINED:
      Result := 'The HTTP cookie was declined by the server.';
    ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION:
      Result := 'The redirection requires user confirmation.';
  else
    Result := '';
  end;
end;

procedure THttpGet.Check(Value: Boolean);
var
  LastError: DWORD;
begin
  if not Value then
  begin
    LastError := GetLastError;
    raise Exception.CreateFmt('Internet error %d. %s',
      [LastError, GetInetErrorText(LastError)])
  end;
end;

function THttpGet.GetString(const URL: string): string;
var
  Buf: Pointer;
  Data: string;
  DataSize: DWORD;
  HostName: string;
  FileName: string;
  BytesToRead: DWORD;
  dwBufLen, dwIndex: DWORD;
  AcceptType: array [0..1] of LPStr;
  hSession, hConnect, hRequest: hInternet;
begin
  hRequest := nil;
  hConnect := nil;
  hSession := nil;
  try
    ParseURL(URL, HostName, FileName);

    hSession := InternetOpen(nil,
      INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if hSession = nil then
      RaiseLastOSError;

    hConnect := InternetConnect(hSession, PChar(HostName),
      INTERNET_DEFAULT_HTTP_PORT, nil, nil,
      INTERNET_SERVICE_HTTP, 0, 0);
    if hConnect = nil then
      RaiseLastOSError;

    AcceptType[0] := PChar('Accept: */*');
    AcceptType[1] := nil;
    hRequest := HttpOpenRequest(hConnect, 'GET', PChar(FileName), 'HTTP/1.0',
                nil, @AcceptType, INTERNET_FLAG_RELOAD, 0);
    if hRequest = nil then RaiseLastOSError;

    Check(HttpSendRequest(hRequest, nil, 0, nil, 0));

    dwIndex  := 0;
    dwBufLen := 1024;
    GetMem(Buf, dwBufLen);
    try
      Check(HttpQueryInfo(hRequest, HTTP_QUERY_CONTENT_LENGTH,
        Buf, dwBufLen, dwIndex));
      DataSize := StrToInt(StrPas(Buf));
    finally
      FreeMem(Buf);
    end;
    if DataSize = 0 then Exit;

    Result := '';
    SetLength(Data, 1024);
    while True do
    begin
      BytesToRead := DataSize;
      InternetReadFile(hRequest, @Data[1], SizeOf(Data), BytesToRead);
      if BytesToRead = 0 then Exit;
      Result := Result + Copy(Data, 1, BytesToRead);
    end;
  finally
    InternetCloseHandle(hRequest);
    InternetCloseHandle(hConnect);
    InternetCloseHandle(hSession);
  end;
end;

end.
