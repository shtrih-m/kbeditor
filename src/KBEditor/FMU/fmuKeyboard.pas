unit fmuKeyboard;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // This
  SizeableForm, KBLayout, KeyboardDriver, KeyboardManager, Keyboard, Utils;

type
  { TfmKeyboard }

  TfmKeyboard = class(TSizeableForm)
    btnOK: TButton;
    btnCancel: TButton;
    ListBox: TListBox;
    lblModel: TLabel;
    procedure ListBoxDblClick(Sender: TObject);
  private
    FLayout: TKBLayout;
  public
    procedure UpdateObject;
    procedure UpdatePage(ALayout: TKBLayout);
  end;

var
  fmKeyboard: TfmKeyboard;

procedure ShowKeyboardDlg(Layout: TKBLayout);

implementation

{$R *.DFM}

procedure ShowKeyboardDlg(Layout: TKBLayout);
begin
  fmKeyboard.UpdatePage(Layout);
  if fmKeyboard.ShowModal = mrOK then
    fmKeyboard.UpdateObject;
end;

{ TfmKeyboard }

procedure TfmKeyboard.UpdateObject;
var
  KeyboardID: Integer;
begin
  KeyboardID := GetListBoxObject(ListBox);
  FLayout.Keyboard := Manager.Keyboards.ItemByID(KeyboardID);
end;

procedure TfmKeyboard.UpdatePage(ALayout: TKBLayout);
var
  i: Integer;
  Keyboard: TKeyboard;
begin
  FLayout := ALayout;
  ListBox.Items.Clear;
  for i := 0 to Manager.Keyboards.Count-1  do
  begin
    Keyboard := Manager.Keyboards[i];
    ListBox.Items.AddObject(Keyboard.Text, TObject(Keyboard.ID));
  end;
  SetListItem(ListBox, ALayout.KeyboardID);
end;

procedure TfmKeyboard.ListBoxDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
