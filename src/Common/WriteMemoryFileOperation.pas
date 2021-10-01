unit WriteMemoryFileOperation;

interface

uses
  // VCL
  SysUtils,
  // This
  OperationInterface, KBLayout, KeyboardManager, uProgress;

type
  { TWriteMemoryFileOperation }

  TWriteMemoryFileOperation = class(TInterfacedObject, IOperation)
  private
    FFileName: string;
  public
    constructor Create(const AFileName: string);

    procedure Cancel;
    procedure Execute;
  end;

implementation

{ TWriteMemoryFileOperation }

constructor TWriteMemoryFileOperation.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
end;

procedure TWriteMemoryFileOperation.Cancel;
begin
  Progress.Stop;
end;

procedure TWriteMemoryFileOperation.Execute;
begin
  Manager.WriteMemoryFile(FFileName);
end;

end.
