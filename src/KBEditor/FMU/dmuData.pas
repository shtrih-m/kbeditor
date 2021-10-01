unit dmuData;

interface

uses
  SysUtils, Classes, JvComponentBase, JvAppStorage, JvAppRegistryStorage;

type
  TdmData = class(TDataModule)
    JvAppRegistryStorage: TJvAppRegistryStorage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmData: TdmData;

implementation

{$R *.dfm}

end.
