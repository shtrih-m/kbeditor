unit ReadMemoryFileOperation;

interface

uses
  // VCL
  SysUtils,
  // This
  OperationInterface, KBLayout, KeyboardManager, uProgress;

type
  { TReadMemoryFileOperation }

  TReadMemoryFileOperation = class(TInterfacedObject, IOperation)
  private
    FFileName: string;
  public
    constructor Create(const AFileName: string);

    procedure Cancel;
    procedure Execute;
  end;

implementation

{ TReadMemoryFileOperation }

constructor TReadMemoryFileOperation.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
end;

procedure TReadMemoryFileOperation.Cancel;
begin
  Progress.Stop;
end;

procedure TReadMemoryFileOperation.Execute;
begin
  Manager.ReadMemoryFile(FFileName);
end;

end.
