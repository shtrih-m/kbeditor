unit dmuData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  JvComponentBase, JvAppStorage, JvAppRegistryStorage;

type
  TdmData = class(TDataModule)
    AppStorage: TJvAppRegistryStorage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmData: TdmData;

implementation

{$R *.DFM}

end.
