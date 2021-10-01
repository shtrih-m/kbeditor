unit WriteFirmwareFileOperation;

interface

uses
  // VCL
  SysUtils,
  // This
  OperationInterface, KBLayout, KeyboardManager, uProgress;

type
  { TWriteFirmwareFileOperation }

  TWriteFirmwareFileOperation = class(TInterfacedObject, IOperation)
  private
    FFileName: string;
  public
    constructor Create(const AFileName: string);

    procedure Cancel;
    procedure Execute;
  end;

implementation

{ TWriteFirmwareFileOperation }

constructor TWriteFirmwareFileOperation.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
end;

procedure TWriteFirmwareFileOperation.Cancel;
begin
  Progress.Stop;
end;

procedure TWriteFirmwareFileOperation.Execute;
begin
  Manager.WriteFirmwareFile(FFileName);
end;

end.
