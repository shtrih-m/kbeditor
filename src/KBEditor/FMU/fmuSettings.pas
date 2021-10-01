unit fmuSettings;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons,
  // This
  KeyboardManager, KeyboardDriver, Keyboard, SizeableForm, AppSettings;

type
  { TfmSettings }

  TfmSettings = class(TSizeableForm)
    btnOK: TButton;
    btnCancel: TButton;
    FontDialog: TFontDialog;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    btnFont: TButton;
    Label2: TLabel;
    pnlPreview: TPanel;
    edtFont: TEdit;
    lblModel: TLabel;
    cbKeyboard: TComboBox;
    chbSave: TCheckBox;
    chbUpdate: TCheckBox;
    lblPortType: TLabel;
    Bevel1: TBevel;
    cbDevices: TComboBox;
    btnRefresh: TBitBtn;
    tsLog: TTabSheet;
    chbLogEnabled: TCheckBox;
    lblFileName: TLabel;
    edtLogFileName: TEdit;
    btnFileName: TButton;
    btnDefaults: TButton;
    OpenDialog: TOpenDialog;
    procedure ListBoxDblClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
    procedure btnFileNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SetFont(AFont: TFont);
  public
    procedure UpdatePage;
    procedure UpdateObject;
  end;

var
  fmSettings: TfmSettings;

function ShowSettingsDlg: Boolean;

implementation

{$R *.DFM}

function ShowSettingsDlg: Boolean;
begin
  fmSettings.UpdatePage;
  Result := fmSettings.ShowModal = mrOK;
  if Result then fmSettings.UpdateObject;
end;

procedure SetListItem(ListBox: TComboBox; Value: Integer);
begin
  ListBox.ItemIndex := ListBox.Items.IndexOfObject(TObject(Value));
end;

function GetListItem(ListBox: TComboBox): Integer;
begin
  Result := Integer(ListBox.Items.Objects[ListBox.ItemIndex]);
end;

{ TfmSettings }

procedure TfmSettings.SetFont(AFont: TFont);
begin
  pnlPreview.Font := AFont;
  edtFont.Text := Format('%s, %d', [AFont.Name, AFont.Size]);
end;

procedure TfmSettings.UpdatePage;
var
  i: Integer;
  Keyboard: TKeyboard;
begin
  SetFont(Settings.Font);
  chbSave.Checked := Settings.SaveBeforeUpload;
  chbUpdate.Checked := Settings.CheckUpdateOnLoad;
  Manager.GetDeviceNames(cbDevices.Items);
  cbDevices.ItemIndex := cbDevices.Items.IndexOfObject(TObject(Manager.DeviceID));
  cbDevices.Enabled := cbDevices.Items.Count > 1;

  for i := 0 to Manager.Keyboards.Count-1  do
  begin
    Keyboard := Manager.Keyboards[i];
    cbKeyboard.Items.AddObject(Keyboard.Text, TObject(Keyboard.ID));
  end;
  SetListItem(cbKeyboard, Settings.KeyboardID);
  chbLogEnabled.Checked := Settings.LogEnabled;
  edtLogFileName.Text := Settings.LogFileName;
end;

procedure TfmSettings.UpdateObject;
begin
  Manager.DeviceID := Integer(cbDevices.Items.Objects[cbDevices.ItemIndex]);
  if cbKeyboard.ItemIndex <> -1 then
    Settings.KeyboardID := GetListItem(cbKeyboard);
  Settings.SaveBeforeUpload := chbSave.Checked;
  Settings.CheckUpdateOnLoad := chbUpdate.Checked;
  Settings.Font := pnlPreview.Font;
  Settings.LogEnabled := chbLogEnabled.Checked;
  Settings.LogFileName := edtLogFileName.Text;
  Settings.SaveSettings;
end;

procedure TfmSettings.ListBoxDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmSettings.btnFontClick(Sender: TObject);
begin
  FontDialog.Font := pnlPreview.Font;
  if FontDialog.Execute then
    SetFont(FontDialog.Font);
end;

procedure TfmSettings.btnRefreshClick(Sender: TObject);
begin
  Manager.UpdateDevices;
  Manager.GetDeviceNames(cbDevices.Items);
  cbDevices.ItemIndex := cbDevices.Items.IndexOfObject(TObject(Manager.DeviceID));
  cbDevices.Enabled := cbDevices.Items.Count > 1;
end;

procedure TfmSettings.btnDefaultsClick(Sender: TObject);
begin
  chbLogEnabled.Checked := Settings.DefLogEnabled;
  edtLogFileName.Text := Settings.DefLogFileName;
end;

procedure TfmSettings.btnFileNameClick(Sender: TObject);
begin
  OpenDialog.FileName := edtLogFileName.Text;
  if OpenDialog.Execute then
    edtLogFileName.Text := OpenDialog.FileName;
end;

procedure TfmSettings.FormCreate(Sender: TObject);
begin
  OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
end;

end.
