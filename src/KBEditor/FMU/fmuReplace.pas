unit fmuReplace;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  KBLayout, LogMessage, SizeableForm, AppMessages;

type
  { TfmReplace }

  TfmReplace = class(TSizeableForm)
    Label1: TLabel;
    Label2: TLabel;
    cmbFindText: TComboBox;
    cmbReplaceText: TComboBox;
    btnCancel: TButton;
    btnReplace: TButton;
    procedure btnReplaceClick(Sender: TObject);
    procedure DoReplace(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    procedure SaveList;
    procedure Execute(Layout: TKBLayout);
  end;

var
  fmReplace: TfmReplace;

procedure ShowReplaceDlg(Layout: TKBLayout);

implementation

uses fmuMessageWindow;

{$R *.DFM}

procedure ShowReplaceDlg(Layout: TKBLayout);
begin
  fmReplace.Execute(Layout);
end;

{ TfmReplace }

procedure TfmReplace.SaveList;
begin
  if cmbFindText.Items.IndexOf(cmbFindText.Text) < 0 then
    cmbFindText.Items.Insert(0, cmbFindText.Text);
  if cmbReplaceText.Items.IndexOf(cmbReplaceText.Text) < 0 then
    cmbReplaceText.Items.Insert(0, cmbReplaceText.Text);
end;

procedure TfmReplace.DoReplace(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    SaveList;
    ModalResult := mrOK;
  end;
end;

procedure TfmReplace.btnReplaceClick(Sender: TObject);
begin
  SaveList;
end;

procedure TfmReplace.FormShow(Sender: TObject);
begin
  cmbFindText.SetFocus;
end;

procedure TfmReplace.Execute(Layout: TKBLayout);
var
  S: string;
  ReplaceCount: Integer;
begin
  if ShowModal = mrOK then
  begin
    fmMessageWindow.Clear;
    ReplaceCount := Layout.Replace(cmbFindText.Text, cmbReplaceText.Text);
    if ReplaceCount > 0 then
    begin
      S := Format(MsgReplacement,
        [cmbFindText.Text, cmbReplaceText.Text, ReplaceCount]);
      LogMessages.Add(S, Layout.ID, 0);
      fmMessageWindow.ShowWindow(Self);
    end else
    begin
      S := Format('%s "%s"', [MsgCannotFind, cmbFindText.Text]);
      MessageBox(Handle, PChar(S), PChar(MsgReplace), MB_ICONINFORMATION);
    end;
  end;
end;

end.
