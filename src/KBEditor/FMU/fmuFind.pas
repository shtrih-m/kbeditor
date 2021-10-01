unit fmuFind;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  SizeableForm, KBLayout, AppMessages;

type
  { TfmFind }

  TfmFind = class(TSizeableForm)
    Label1: TLabel;
    btnFind: TButton;
    btnCancel: TButton;
    cbFind: TComboBox;
    procedure cbFindKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFindClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Search;
  end;

var
  fmFind: TfmFind;

procedure ShowFindDlg(Layout: TKBLayout);

implementation

uses
  fmuMessageWindow;

{$R *.DFM}

procedure ShowFindDlg(Layout: TKBLayout);
var
  S: string;
begin
  if fmFind.ShowModal = mrOK then
  begin
    fmMessageWindow.Clear;
    if Layout.Find(fmFind.cbFind.Text) = 0 then
    begin
      S := Format('%s "%s"', [MsgCannotFind, fmFind.cbFind.Text]);
      MessageBox(fmFind.Handle, PChar(S), PChar(MsgSearch), MB_ICONINFORMATION);
    end else
    begin
      fmMessageWindow.ShowWindow(fmFind);
    end;
  end;
end;


{ TfmFind }

procedure TfmFind.Search;
begin
  if cbFind.Items.IndexOf(cbFind.Text) < 0 then
    cbFind.Items.Insert(0, cbFind.Text);
end;

procedure TfmFind.cbFindKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Search;
    ModalResult := mrOK;
  end;
end;

procedure TfmFind.btnFindClick(Sender: TObject);
begin
  Search;
end;

procedure TfmFind.FormShow(Sender: TObject);
begin
  cbFind.SetFocus;
end;

end.
