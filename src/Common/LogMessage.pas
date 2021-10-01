unit LogMessage;

interface

uses
  // VCL
  Classes;

type
  TLogMessageEvent = procedure(Sender: TObject; const S: string;
    LayoutID, ItemID: Integer) of object;

  { TLogMessage }

  TLogMessage = class(TComponent)
  private
    FOnLogMessage: TLogMessageEvent;
  public
    procedure Add(const S: string; LayoutID, ItemID: Integer);
    property OnLogMessage: TLogMessageEvent read FOnLogMessage write FOnLogMessage;
  end;

procedure FreeLogMessages;
function LogMessages: TLogMessage;

implementation

var
  FLogMessages: TLogMessage;

procedure FreeLogMessages;
begin
  FLogMessages.Free;
  FLogMessages := nil;
end;

function LogMessages: TLogMessage;
begin
  if FLogMessages = nil then
    FLogMessages := TLogMessage.Create(nil);
  Result := FLogMessages;
end;

{ TLogMessage }

procedure TLogMessage.Add(const S: string; LayoutID, ItemID: Integer);
begin
  if Assigned(FOnLogMessage) then
    FOnLogMessage(Self, S, LayoutID, ItemID);
end;

end.
