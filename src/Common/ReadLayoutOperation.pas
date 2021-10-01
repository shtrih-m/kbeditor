unit ReadLayoutOperation;

interface

uses
  // VCL
  SysUtils,
  // This
  OperationInterface, KBLayout, KeyboardManager, uProgress;

type
  { TReadLayoutOperation }

  TReadLayoutOperation = class(TInterfacedObject, IOperation, ILayoutOperation)
  private
    FLayout: TKBLayout;
  public
    constructor Create(ALayout: TKBLayout);

    // IOperation
    procedure Cancel;
    procedure Execute;
    // ILayoutOperation
    function GetLayout: TKBLayout;
  end;

implementation

{ TReadLayoutOperation }

constructor TReadLayoutOperation.Create(ALayout: TKBLayout);
begin
  inherited Create;
  FLayout := ALayout;
end;

procedure TReadLayoutOperation.Cancel;
begin
  Progress.Stop;
end;

procedure TReadLayoutOperation.Execute;
begin
  Manager.ReadLayout(FLayout);
end;

function TReadLayoutOperation.GetLayout: TKBLayout;
begin
  Result := FLayout;
end;

end.
