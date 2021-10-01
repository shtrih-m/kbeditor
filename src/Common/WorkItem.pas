unit WorkItem;

interface

uses
  // VCL
  Classes;

type
  { TWorkItem }

  TWorkItem = class
  private
    FOnComplete: TNotifyEvent;
  public
    procedure Completed;
    procedure Execute; virtual; abstract;
    property OnComplete: TNotifyEvent read FOnComplete write FOnComplete;
  end;

implementation

{ TWorkItem }

procedure TWorkItem.Completed;
begin
  if Assigned(FOnComplete) then
    FOnComplete(Self);
end;

end.
