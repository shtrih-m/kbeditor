unit ScanCodeBuffer;

interface

uses
  // VCL
  Windows, Forms, Messages,
  // This
  KBLayout, KeyboardManager;

type
  { TScanCodeBuffer }

  TScanCodeBuffer = class
  private
    FMaxCodes: Integer;
    FScanCodes: TScanCodes;
    FOnMessage: TMessageEvent;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  public
    constructor Create(AMaxCodes: Integer);
    destructor Destroy; override;

    property ScanCodes: TScanCodes read FScanCodes;
  end;

implementation

{ TScanCodeBuffer }

constructor TScanCodeBuffer.Create(AMaxCodes: Integer);
begin
  inherited Create;
  FMaxCodes := AMaxCodes;
  FScanCodes := TScanCodes.Create(nil);
  FOnMessage := Application.OnMessage;
  Application.OnMessage := AppMessage;
end;

destructor TScanCodeBuffer.Destroy;
begin
  Application.OnMessage := FOnMessage;
  FScanCodes.Free;
  inherited Destroy;
end;

procedure TScanCodeBuffer.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  ScanCode: TScanCode;
  Item: TScanCode;
begin
  Handled := False;
  ScanCode := Manager.CodeTable.FromMessage(Msg, [koMake, koBreak, koRepeat]);
  if (ScanCode <> nil)and(ScanCodes.Count < FMaxCodes) then
  begin
    Item := ScanCodes.Add;
    Item.Assign(ScanCode);
  end;
  if Assigned(FOnMessage) then FOnMessage(Msg, Handled);
end;

end.
