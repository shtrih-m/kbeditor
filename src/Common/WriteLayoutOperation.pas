unit WriteLayoutOperation;

interface

uses
  // VCL
  SysUtils,
  // This
  OperationInterface, KBLayout, KeyboardManager, uProgress;

type
  { TWriteLayoutOperation }

  TWriteLayoutOperation = class(TInterfacedObject, IOperation)
  private
    FLayout: TKBLayout;
  public
    constructor Create(ALayout: TKBLayout);

    procedure Cancel;
    procedure Execute;
  end;

implementation

{ TWriteLayoutOperation }

constructor TWriteLayoutOperation.Create(ALayout: TKBLayout);
begin
  inherited Create;
  FLayout := ALayout;
end;

procedure TWriteLayoutOperation.Cancel;
begin
  Progress.Stop;
end;

procedure TWriteLayoutOperation.Execute;
begin
  Manager.WriteLayout(FLayout);
end;

end.
