unit NotifyThread;

interface

uses
  // VCL
  Classes;

type
  { TNotifyThread }

  TNotifyThread = class(TThread)
  private
    FOnExecute: TNotifyEvent;
  protected
    procedure Execute; override;
  published
    property Terminated;
    procedure Synchronize(Method: TThreadMethod);
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
  end;

implementation

{ TNotifyThread }

procedure TNotifyThread.Execute;
begin
  if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

procedure TNotifyThread.Synchronize(Method: TThreadMethod);
begin
  inherited Synchronize(Method);
end;

end.
