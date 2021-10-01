unit fmuDevices;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // This
  KeyboardManager, Keyboard, SizeableForm, Utils, AppSettings;

type
  { TfmDevices }

  TfmDevices = class(TSizeableForm)
    Memo: TMemo;
    btnOK: TButton;
    Bevel1: TBevel;
    ListBox: TListBox;
    procedure ListBoxClick(Sender: TObject);
  private
    procedure UpdateKeyboards;
    procedure ShowParams(OffSet: string; Params: TKeyboardParams);
  public
    procedure UpdatePage;
  end;

var
  fmDevices: TfmDevices;
  
implementation

{$R *.DFM}

{ TfmDevices }

procedure TfmDevices.UpdateKeyboards;
var
  i: Integer;
  Keyboard: TKeyboard;
begin
  ListBox.Clear;
  for i := 0 to Manager.Keyboards.Count-1  do
  begin
    Keyboard := Manager.Keyboards[i];
    ListBox.Items.AddObject(Keyboard.Text, TObject(Keyboard.ID));
  end;
end;

procedure TfmDevices.UpdatePage;
begin
  Memo.Clear;
  UpdateKeyboards;
  SetListItem(ListBox, Settings.KeyboardID);
  ShowParams('', Manager.Keyboards.ItemByID(Settings.KeyboardID).Params);
end;

procedure TfmDevices.ShowParams(OffSet: string; Params: TKeyboardParams);
var
  i: Integer;
  Param: TKeyboardParam;
begin
  for i := 0 to Params.Count-1 do
  begin
    Param := Params[i];
    if Param.IsGroup then
    begin
      Memo.Lines.Add(Format('%s[%s]', [OffSet, Param.Text]));
    end else
    begin
      Memo.Lines.Add(Format('%s  %s: %s', [OffSet, Param.Text, Param.Value]));
    end;
    ShowParams(Offset + '  ', Param.Items);
  end;
end;

procedure TfmDevices.ListBoxClick(Sender: TObject);
var
  Keyboard: TKeyboard;
begin
  Memo.Clear;
  Keyboard := Manager.Keyboards.ItemByID(GetListBoxObject(ListBox));
  ShowParams('', Keyboard.Params);
end;

end.
