unit fmuDevice;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons,
  // This
  WizardPage, TestWizard, Keyboard, KeyboardManager, KeyboardDriver,
  KeyboardTypes;

type
  { TfmDevice }

  TfmDevice = class(TWizardPage)
    Label1: TLabel;
    lbDevice: TListBox;
    btnUpdate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    procedure UpdatePage;
  public
    procedure Stop; override;
  end;

implementation

{$R *.DFM}

procedure TfmDevice.UpdatePage;
begin
  Manager.UpdateDevices;
  Manager.GetDeviceNames(lbDevice.Items);
  lbDevice.ItemIndex := lbDevice.Items.IndexOfObject(TObject(Manager.DeviceID));
  lbDevice.Enabled := lbDevice.Items.Count > 1;
  ActionText := 'Выберите тип клавиатуры и нажмите кнопку "Далее"';
end;

procedure TfmDevice.FormCreate(Sender: TObject);
begin
  UpdatePage;
end;

procedure TfmDevice.btnUpdateClick(Sender: TObject);
begin
  UpdatePage;
end;

procedure TfmDevice.Stop;
var
  DeviceInfo: TDeviceInfo;
begin
  Manager.DeviceID := Integer(lbDevice.Items.Objects[lbDevice.ItemIndex]);
  DeviceInfo := Manager.Driver.GetDeviceInfo;
  Wizard.Initialize(DeviceInfo);
  Wizard.GoNext;
end;

end.


