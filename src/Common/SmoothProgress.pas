unit SmoothProgress;

interface

uses
  // VCL
  Windows;

// Class to make smooth progress

type
  { TSmoothProgress }

  TSmoothProgress = class
  private
    FStarted: Boolean;
    FPosition: Integer;
    FStartTime: Integer;
    FMaxSteps: Integer;
    FStepCount: Integer;
    FStepTime: Double;
    FMaxProgress: Integer;

    function GetPosition: Integer;
  public
    procedure Start(AMaxSteps: Integer);
    procedure Step;
    procedure Stop;

    property Started: Boolean read FStarted;
    property Position: Integer read GetPosition;
    property MaxProgress: Integer read FMaxProgress;
  end;

implementation

{ TSmoothProgress }

function TSmoothProgress.GetPosition: Integer;
var
  TickCount: Integer;
begin
  if Started then
  begin
    TickCount := Integer(GetTickCount) - FStartTime;
    FPosition := Round(TickCount/FStepTime);
  end;
  Result := FPosition;
end;

procedure TSmoothProgress.Start(AMaxSteps: Integer);
begin
  FPosition := 0;
  FStarted := True;
  FMaxProgress := 100;
  FMaxSteps := AMaxSteps;
  FStepTime := 100; // 100 ms
  FStartTime := GetTickCount;
end;

procedure TSmoothProgress.Step;
var
  TickCount: Integer;
begin
  if FStarted and (FPosition < FMaxProgress) then
  begin
    Inc(FStepCount);
    if FStepCount >= FMaxSteps then
    begin
      FStarted := False;
    end;
    TickCount := Integer(GetTickCount) - FStartTime;
    FStepTime := (TickCount*FMaxSteps)/(FStepCount*100);
  end;
end;

procedure TSmoothProgress.Stop;
begin
  FPosition := 0;
  FStarted := False;
end;

end.
