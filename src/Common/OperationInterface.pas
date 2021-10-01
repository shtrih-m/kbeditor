unit OperationInterface;

interface

uses
  // This
  KBLayout;

type
  { IOperation }

  IOperation = interface
  ['{B60D8B24-B046-473E-A76A-41FFA3D9C6A9}']
    procedure Cancel;
    procedure Execute;
  end;

  { ILayoutOperation }

  ILayoutOperation = interface
  ['{9CD66DF7-560F-4320-B2D5-BE71C73F340A}']
    function GetLayout: TKBLayout;
  end;

implementation

end.
