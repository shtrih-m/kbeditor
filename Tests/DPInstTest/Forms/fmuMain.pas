unit fmuMain;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  // This
  DriverUtils, StdCtrls, ExtCtrls;

type
  TfmMain = class(TForm)
    btnInstallDriver: TButton;
    btnUninstallDriver: TButton;
    btnClose: TButton;
    Bevel1: TBevel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnInstallDriverClick(Sender: TObject);
    procedure btnUninstallDriverClick(Sender: TObject);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.btnInstallDriverClick(Sender: TObject);
var
  Params: TDriverParams;
begin
  Params.IsSilent := False;
  Params.MainWindow := Handle;
  Params.ExeFileName := Application.ExeName;
  InstallDriver(Params);
end;

procedure TfmMain.btnUninstallDriverClick(Sender: TObject);
var
  Params: TDriverParams;
begin
  Params.IsSilent := False;
  Params.MainWindow := Handle;
  Params.ExeFileName := Application.ExeName;
  UninstallDriver(Params);
end;

end.
