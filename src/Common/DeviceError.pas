unit DeviceError;

interface

uses
  // VCL
  Windows, SysUtils;

const
  E_NOERROR             =  0;
  E_INCORRECT_PARAM     =  4;
  E_UNSUPPORTED_COMMAND =  8;
  E_INVALID_MODE        =  $73;

  E_UNKNOWN             = -199;

resourcestring
  S_NOERROR             = 'No error';
  S_INCORRECT_PARAM     = 'Invalid command parameter value';
  S_UNSUPPORTED_COMMAND = 'Command is not supported by device';
  S_INVALID_MODE        = 'Invalid keyboard state';
  S_UNKNOWN             = 'Unknown device error';

type
  { EDeviceError }

  EDeviceError = class(Exception)
  private
    FErrorCode: Int64;
  public
    property ErrorCode: Int64 read fErrorCode;
    constructor Create2(Code: Int64; Msg: string);
  end;

function GetErrorText(Code: Integer): string;
function HandleException(E: Exception): Integer;
procedure RaiseError(Code: Int64; const Msg: string);

implementation

{ EDeviceError }

constructor EDeviceError.Create2(Code: Int64; Msg: string);
begin
  inherited Create(Msg);
  FErrorCode := Code;
end;

procedure RaiseError(Code: Int64; const Msg: string);
begin
  raise EDeviceError.Create2(Code, Msg);
end;

function HandleException(E: Exception): Integer;
begin
  if E is EDeviceError then
    Result := (E as EDeviceError).ErrorCode
  else
    Result := Integer(E_UNKNOWN);
end;

function GetErrorText(Code: Integer): string;
begin
  case Code of
    E_NOERROR             : Result := S_NOERROR;
    E_INCORRECT_PARAM     : Result := S_INCORRECT_PARAM;
    E_UNSUPPORTED_COMMAND : Result := S_UNSUPPORTED_COMMAND;
    E_INVALID_MODE        : Result := S_INVALID_MODE;
  else
    Result := S_UNKNOWN;
  end;
end;

end.
