unit fmuModel;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons,
  // JVCL
  JvComponentBase, JvAppStorage,
  // This
  WizardPage, TestWizard, Keyboard, KeyboardManager, KeyboardDriver, Utils,
  dmuData, JvFormPlacement;

type
  { TfmModel }

  TfmModel = class(TWizardPage)
    lblModel: TLabel;
    ListBox: TListBox;
    chbShowAllModels: TCheckBox;
    JvFormStorage1: TJvFormStorage;
    procedure FormCreate(Sender: TObject);
    procedure chbShowAllModelsClick(Sender: TObject);
  private
    procedure UpdatePage;
  public
    procedure Stop; override;
    procedure Start; override;
  end;

implementation

{$R *.DFM}

procedure TfmModel.UpdatePage;
var
  i: Integer;
  Keyboard: TKeyboard;
  ShowAllModels: Boolean;
begin
  ShowAllModels := chbShowAllModels.Checked;
  ListBox.Items.Clear;
  for i := 0 to Manager.Keyboards.Count-1  do
  begin
    Keyboard := Manager.Keyboards[i];
    if ShowAllModels or (Keyboard.ModelID = Wizard.DeviceInfo.Model) then
    begin
      ListBox.Items.AddObject(Keyboard.Text, TObject(Keyboard.ID));
    end;
  end;
  ListBox.ItemIndex := ListBox.Items.IndexOfObject(TObject(Wizard.KeyboardID));
  if ListBox.ItemIndex = -1 then
    ListBox.ItemIndex := ListBox.Items.Count-1;

  ActionText := 'Выберите модель клавиатуры и нажмите кнопку "Далее"';
end;

procedure TfmModel.Start;
begin
  UpdatePage;
end;

procedure TfmModel.Stop;
begin
  Wizard.KeyboardID := GetListBoxObject(ListBox);
  Wizard.GoNext;
end;

procedure TfmModel.FormCreate(Sender: TObject);
begin
  UpdatePage;
end;

procedure TfmModel.chbShowAllModelsClick(Sender: TObject);
begin
  UpdatePage;
end;

end.


