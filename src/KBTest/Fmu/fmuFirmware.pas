unit fmuFirmware;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard, uProgress, KeyboardManager, KeyboardDriver,
  OperationThread, OperationInterface, WriteFirmwareFileOperation,
  KeyboardTypes;

type
  { TfmFirmwareUpdate }

  TfmFirmware = class(TWizardPage)
    lblProgress: TLabel;
    ProgressBar: TProgressBar;
    lblInfo: TLabel;
    lblFileName: TLabel;
    edtFileName: TEdit;
    btnFileName: TButton;
    OpenDialog: TOpenDialog;
    lblPercents: TLabel;
    btnUpdate: TButton;
    Timer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnFileNameClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    procedure UpdatePage;
    procedure UpdateFirmware;
    procedure CheckKeyboard;
    procedure OperationCompleted(Sender: TObject; Operation: IOperation);
  public
    procedure Start; override;
    procedure Stop; override;
    procedure Cancel; override;
  end;

implementation

{$R *.DFM}

{ TfmFirmwareUpdate }

procedure TfmFirmware.OperationCompleted(Sender: TObject; Operation: IOperation);
begin
  EnableButtons(True);
  if WorkThread.Failed then
  begin
    MessageBox(Handle, PChar(WorkThread.ErrorMessage), PCHar(Application.Title), MB_ICONERROR);
  end else
  begin
    btnUpdate.SetFocus;
    CheckKeyboard;
  end;
  Wizard.EnableNext(True);
  Wizard.EnablePrev(True);
end;

procedure TfmFirmware.UpdateFirmware;
var
  Operation: IOperation;
begin
  Operation := TWriteFirmwareFileOperation.Create(edtFileName.Text);

  Progress.Clear;
  WorkThread.OnCompleted := OperationCompleted;
  WorkThread.Start(Operation);
  EnableButtons(False);
  Wizard.EnableNext(False);
  Wizard.EnablePrev(False);
end;

procedure TfmFirmware.Start;
begin
  Progress.Clear;
  CheckKeyboard;
end;

procedure TfmFirmware.CheckKeyboard;
var
  UpdateNeeded: Boolean;
  FirmwareVersion: string;
  DeviceInfo: TDeviceInfo;
  DeviceStatus: TDeviceStatus;
begin
  lblInfo.Caption := '';
  OpenDialog.Filter := OpenPrgFilter;
  edtFileName.Text := Wizard.ProgramFileName;
  Update;

  DeviceStatus := Manager.Driver.GetDeviceStatus;
  if DeviceStatus.CRCOK then
  begin
    DeviceInfo := Manager.Driver.GetProgramInfo;

    UpdateNeeded :=
     ((DeviceInfo.MajorVersion = 2)and
     (DeviceInfo.MinorVersion < 8)) or
     (DeviceInfo.MajorVersion < 2);

    FirmwareVersion := Format('%d.%d',
      [DeviceInfo.MajorVersion, DeviceInfo.MinorVersion]);

    if UpdateNeeded then
    begin
      lblInfo.Caption := Format('Версия программы: %s. Обновление необходимо.',
        [FirmwareVersion]);
    end else
    begin
      lblInfo.Caption := Format('Версия программы: %s. Обновление не требуется.',
        [FirmwareVersion]);
    end;
  end else
  begin
    lblInfo.Caption := 'Программа повреждена. Обновление необходимо.';
  end;
end;

procedure TfmFirmware.Stop;
begin
  Wizard.ProgramFileName := edtFileName.Text;
  Wizard.GoNext;
end;

procedure TfmFirmware.FormCreate(Sender: TObject);
begin
  lblInfo.Caption := '';
end;

procedure TfmFirmware.btnFileNameClick(Sender: TObject);
begin
  OpenDialog.FileName := edtFileName.Text;
  if OpenDialog.Execute then
  begin
    edtFileName.Text := OpenDialog.FileName;
    Wizard.ProgramFileName := OpenDialog.FileName;
    Wizard.SaveParams;
  end;
end;

procedure TfmFirmware.btnUpdateClick(Sender: TObject);
begin
  UpdateFirmware;
end;

procedure TfmFirmware.TimerTimer(Sender: TObject);
begin
  UpdatePage;
end;

procedure TfmFirmware.UpdatePage;
begin
  Progress.Lock;
  try
    ProgressBar.Max := Progress.BlockCount;
    ProgressBar.Position := Progress.BlockSent;
    lblPercents.Caption := Progress.ProgressText;
  finally
    Progress.Unlock;
  end;
end;

procedure TfmFirmware.Cancel;
begin
  Progress.Stop;
end;

procedure TfmFirmware.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Progress.Stop;
end;

end.


