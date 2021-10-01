unit MockKeyboardDevice;

interface

uses
  // VCL
  PascalMock,
  // This
  KeyboardTypes, Utils;

type
  { TMockKeyboardDevice }

  TMockKeyboardDevice = class(TMock, IKeyboardDevice)
    procedure Open;
    procedure Close;
    function GetID: Integer;
    function GetName: string;
    function GetIndicators: Byte;
    function GetUniqueName: string;
    function GetDeviceName: string;
    procedure SetIndicators(Value: Byte);
    procedure SetDeviceName(const Value: string);
    function SendData(const TxData: string; MaxCount: Integer): string;
  end;

implementation

{ TMockKeyboardDevice }

procedure TMockKeyboardDevice.Open;
begin
  AddCall('Open');
end;

procedure TMockKeyboardDevice.Close;
begin
  AddCall('Close');
end;

function TMockKeyboardDevice.GetDeviceName: string;
begin
  Result := AddCall('GetDeviceName').ReturnValue;
end;

function TMockKeyboardDevice.GetID: Integer;
begin
  Result := AddCall('GetID').ReturnValue;
end;

function TMockKeyboardDevice.GetIndicators: Byte;
begin
  Result := AddCall('GetIndicators').ReturnValue;
end;

function TMockKeyboardDevice.GetName: string;
begin
  Result := AddCall('GetName').ReturnValue;
end;

function TMockKeyboardDevice.GetUniqueName: string;
begin
  Result := AddCall('GetUniqueName').ReturnValue;
end;

procedure TMockKeyboardDevice.SetDeviceName(const Value: string);
begin
  AddCall('SetDeviceName').WithParams([Value]);
end;

procedure TMockKeyboardDevice.SetIndicators(Value: Byte);
begin
  AddCall('SetIndicators').WithParams([Value]);
end;

function TMockKeyboardDevice.SendData(const TxData: string;
  MaxCount: Integer): string;
begin
  Result := AddCall('SendData').WithParams([TxData, MaxCount]).ReturnValue;
end;

end.
