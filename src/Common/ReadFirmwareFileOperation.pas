unit ReadFirmwareFileOperation;

interface

uses
  // VCL
  SysUtils,
  // This
  OperationInterface, KBLayout, KeyboardManager, uProgress;

type
  { TReadFirmwareFileOperation }

  TReadFirmwareFileOperation = class(TInterfacedObject, IOperation)
  private
    FFileName: string;
  public
    constructor Create(const AFileName: string);

    procedure Cancel;
    procedure Execute;
  end;

implementation

{ TReadFirmwareFileOperation }

constructor TReadFirmwareFileOperation.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
end;

procedure TReadFirmwareFileOperation.Cancel;
begin
  Progress.Stop;
end;

procedure TReadFirmwareFileOperation.Execute;
begin
  Manager.ReadFirmwareFile(FFileName);
end;

end.
