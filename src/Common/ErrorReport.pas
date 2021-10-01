unit ErrorReport;

interface

uses
  // VCL
  Windows, Messages, SysUtils, MAPI, Controls, Forms, Classes,
  // This
  fmuError, untVInfo, LogFile;

function ReportError(E: Exception): Boolean;

implementation

resourcestring
  MsgErrorSendingMessage = 'Error sending message';

type
  { TErrorReport }

  TErrorReport = class
  private
    procedure SendMail(const TargetName, TargetAddr, SenderName, SenderAddr,
      MsgSubject, MsgContent, Attachment: string; PreviewMsg: Boolean);
    function GetOSVersion: string;
    function CreateReport(E: Exception): string;
  public
    function HandleException(E: Exception): Boolean;
  end;

  { ESendMailException }

  ESendMailException = class(Exception);

function GetMAPIError(ErrorCode: Integer): string;
begin
  case ErrorCode of
    MAPI_E_USER_ABORT               : Result := 'User cancelled request';
    MAPI_E_FAILURE                  : Result := 'General MAPI failure';
    MAPI_E_LOGON_FAILURE            : Result := 'Logon failure';
    MAPI_E_DISK_FULL                : Result := 'Disk full';
    MAPI_E_INSUFFICIENT_MEMORY      : Result := 'Insufficient memory';
    MAPI_E_ACCESS_DENIED            : Result := 'Access denied';
    MAPI_E_TOO_MANY_SESSIONS        : Result := 'Too many sessions';
    MAPI_E_TOO_MANY_FILES           : Result := 'Too many files open';
    MAPI_E_TOO_MANY_RECIPIENTS      : Result := 'Too many recipients';
    MAPI_E_ATTACHMENT_NOT_FOUND     : Result := 'Attachment not found';
    MAPI_E_ATTACHMENT_OPEN_FAILURE  : Result := 'Failed to open attachment';
    MAPI_E_ATTACHMENT_WRITE_FAILURE : Result := 'Failed to write attachment';
    MAPI_E_UNKNOWN_RECIPIENT        : Result := 'Unknown recipient';
    MAPI_E_BAD_RECIPTYPE            : Result := 'Invalid recipient type';
    MAPI_E_NO_MESSAGES              : Result := 'No messages';
    MAPI_E_INVALID_MESSAGE          : Result := 'Invalid message';
    MAPI_E_TEXT_TOO_LARGE           : Result := 'Text too large.';
    MAPI_E_INVALID_SESSION          : Result := 'Invalid session';
    MAPI_E_TYPE_NOT_SUPPORTED       : Result := 'Type not supported';
    MAPI_E_AMBIGUOUS_RECIPIENT      : Result := 'Ambiguous recipient';
    MAPI_E_MESSAGE_IN_USE           : Result := 'Message in use';
    MAPI_E_NETWORK_FAILURE          : Result := 'Network failure';
    MAPI_E_INVALID_EDITFIELDS       : Result := 'Invalid edit fields';
    MAPI_E_INVALID_RECIPS           : Result := 'Invalid recipients';
    MAPI_E_NOT_SUPPORTED            : Result := 'Not supported';
  else
    Result := 'Unknown error code: ' + IntToStr(ErrorCode);
  end;
end;

function IsVCLException(E: Exception): Boolean;
begin
  Result :=
    (E is EHeapException) or
    (E is EInOutError) or
    (E is EExternal) or
    (E is EInvalidCast) or
    (E is EConvertError) or
    (E is EVariantError) or
    (E is EPropReadOnly) or
    (E is EPropWriteOnly) or
    (E is EAssertionFailed) or
    (E is EAbstractError) or
    (E is EIntfCastError) or
    (E is EPackageError) or
    (E is ESafecallException) or
    (E is EResNotFound) or
    (E is EInvalidOperation) or
    (E is EThread);
end;

function ReportError(E: Exception): Boolean;
var
  ErrorReport: TErrorReport;
begin
  ErrorReport := TErrorReport.Create;
  try
    Result := IsVCLException(E);
    if Result then  
      Result := ErrorReport.HandleException(E);
  finally
    ErrorReport.Free;
  end;
end;

{ TErrorReport }

function TErrorReport.HandleException(E: Exception): Boolean;
const
  MailAddress = 'bugs@shtrih-m.ru';
begin
  Result := True;
  fmError.UpdatePage(E);
  if fmError.ShowModal = mrOK then
  begin
    try
      SendMail(MailAddress, MailAddress, Application.Title, '',
        Application.Title, CreateReport(E), '', True);
    except
      on E: Exception do
      begin
        Logger.Error('HandleException: ' + E.Message);
        MessageBox(Application.Handle, PChar(E.Message),
          PChar(Application.Title), MB_ICONERROR);
      end;
    end;
  end;
end;

function TErrorReport.GetOSVersion: string;
begin
  Result := Format('%d.%d.%d.%d.%s', [
    Win32Platform, Win32MajorVersion, Win32MinorVersion,
    Win32BuildNumber, Win32CSDVersion]);
end;

function TErrorReport.CreateReport(E: Exception): string;
var
  Report: Tstrings;
begin
  Report := TstringList.Create;
  try
    Report.Add('Application : ' + Application.Title);
    Report.Add('Error class : ' + E.ClassName);
    Report.Add('Error text  : ' + E.Message);
    Report.Add('Application version: ' + GetFileVersionInfoStr);
    Report.Add('OS version: ' + GetOSVersion);
    Report.Add(Format('Date: %s Time: %s', [DateToStr(Date), TimeToStr(Time)]));
    Result := Report.Text;
  finally
    Report.Free;
  end;
end;

procedure TErrorReport.SendMail(const TargetName, TargetAddr,
  SenderName, SenderAddr, MsgSubject, MsgContent,
  Attachment: string; PreviewMsg: Boolean);
var
  Msg: TMapiMessage;          // Pointer to the message itself
  Sender: TMapiRecipDesc;     // Who's sending it?
  Target: TMapiRecipDesc;     // Who's going to get it?
  Flags: Longint;             // Flags for MAPI.
  ResultCode: Integer;
begin
  Flags := 0;
  FillChar(Msg, SizeOf(Msg), 0);
  FillChar(Sender, SizeOf(Sender), 0);
  FillChar(Target, SizeOf(Target), 0);
  Target.lpszName := PChar(TargetName);
  Target.ulRecipClass := MAPI_TO;
  Target.lpszAddress := PChar(TargetAddr);
  Sender.lpszName := PChar(SenderName);
  Sender.ulRecipClass := MAPI_ORIG;
  Sender.lpszAddress := PChar('SMTP:' + SenderAddr);
  Msg.nRecipCount := 1;
  Msg.lpRecips := @Target;
  Msg.lpOriginator := @Sender;
  Msg.lpszSubject := PChar(MsgSubject);
  Msg.lpszNoteText := PChar(MsgContent);
  if PreviewMsg then Flags := MAPI_DIALOG;
  ResultCode := MAPISendMail(0, Application.Handle, Msg, Flags, 0);
  if (ResultCode <> 0)and(ResultCode <> MAPI_E_USER_ABORT) then
    raise ESendMailException.CreateFmt('%s.'#10#13'%s.',
     [MsgErrorSendingMessage, GetMAPIError(ResultCode)]);
end;

end.
