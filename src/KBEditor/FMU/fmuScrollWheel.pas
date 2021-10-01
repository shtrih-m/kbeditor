unit fmuScrollWheel;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus,
  // This
  SizeableForm, KeyboardManager, fmuCodes, fmuNotes, KBLayout;

type
  { TfmScrollWheel }

  TfmScrollWheel = class(TSizeableForm)
    pmCodes: TPopupMenu;
    pmiCut1: TMenuItem;
    pmiCopy1: TMenuItem;
    pmiPast1: TMenuItem;
    MenuItem4: TMenuItem;
    pmiPressCodes1: TMenuItem;
    pmiReleaseCodes1: TMenuItem;
    pmiAllCodes1: TMenuItem;
    btnOK: TButton;
    btnCancel: TButton;
    psScroll: TPageControl;
    tsScroll: TTabSheet;
    tsClick: TTabSheet;
    gbScrollUp: TGroupBox;
    lblNotes1: TLabel;
    edtNotes1: TEdit;
    lblCodes1: TLabel;
    edtCodes1: TEdit;
    btnCodes1: TButton;
    btnNotes1: TButton;
    btnPlayNotes1: TBitBtn;
    gbScrollDown: TGroupBox;
    lblCodes2: TLabel;
    edtCodes2: TEdit;
    edtNotes2: TEdit;
    lblNotes2: TLabel;
    btnPlayNotes2: TBitBtn;
    btnNotes2: TButton;
    btnCodes2: TButton;
    gbSingleClick: TGroupBox;
    lblNotes3: TLabel;
    lblCodes3: TLabel;
    edtCodes3: TEdit;
    edtNotes3: TEdit;
    btnPlayNotes3: TBitBtn;
    btnNotes3: TButton;
    btnCodes3: TButton;
    gbDoubleClick: TGroupBox;
    lblCodes4: TLabel;
    edtCodes4: TEdit;
    edtNotes4: TEdit;
    lblNotes4: TLabel;
    btnPlayNotes4: TBitBtn;
    btnNotes4: TButton;
    btnCodes4: TButton;
    procedure btnCodes1Click(Sender: TObject);
    procedure btnPlayNotes1Click(Sender: TObject);
    procedure btnNotes1Click(Sender: TObject);
    procedure pmiCut1Click(Sender: TObject);
    procedure pmiCopy1Click(Sender: TObject);
    procedure pmiPast1Click(Sender: TObject);
    procedure pmiAllCodes1Click(Sender: TObject);
    procedure pmiPressCodes1Click(Sender: TObject);
    procedure pmiReleaseCodes1Click(Sender: TObject);
    procedure btnCodes2Click(Sender: TObject);
    procedure btnCodes3Click(Sender: TObject);
    procedure btnCodes4Click(Sender: TObject);
    procedure btnPlayNotes2Click(Sender: TObject);
    procedure btnPlayNotes3Click(Sender: TObject);
    procedure btnPlayNotes4Click(Sender: TObject);
    procedure btnNotes2Click(Sender: TObject);
    procedure btnNotes3Click(Sender: TObject);
    procedure btnNotes4Click(Sender: TObject);
  public
    procedure UpdatePage(AScrollWheel: TScrollWheel);
    procedure UpdateObject(AScrollWheel: TScrollWheel);
  end;

var
  fmScrollWheel: TfmScrollWheel;

function ShowScrollWheelDlg(AScrollWheel: TScrollWheel): Boolean;

implementation

{$R *.DFM}

function ShowScrollWheelDlg(AScrollWheel: TScrollWheel): Boolean;
begin
  fmScrollWheel.UpdatePage(AScrollWheel);
  Result := fmScrollWheel.ShowModal = mrOK;
  if Result then
    fmScrollWheel.UpdateObject(AScrollWheel);
end;

{ TfmScrollWheel }

procedure TfmScrollWheel.UpdatePage(AScrollWheel: TScrollWheel);
begin
  // Scroll up
  edtCodes1.Text := AScrollWheel.ScrollUp.Codes.AsText;
  edtNotes1.Text := AScrollWheel.ScrollUp.Notes.AsText;
  // Scroll down
  edtCodes2.Text := AScrollWheel.ScrollDown.Codes.AsText;
  edtNotes2.Text := AScrollWheel.ScrollDown.Notes.AsText;
  // Single click
  edtCodes3.Text := AScrollWheel.SingleClick.Codes.AsText;
  edtNotes3.Text := AScrollWheel.SingleClick.Notes.AsText;
  // Double click
  edtCodes4.Text := AScrollWheel.DoubleClick.Codes.AsText;
  edtNotes4.Text := AScrollWheel.DoubleClick.Notes.AsText;
end;

procedure TfmScrollWheel.UpdateObject(AScrollWheel: TScrollWheel);
begin
  // Scroll up
  AScrollWheel.ScrollUp.Notes.AsText := edtNotes1.Text;
  AScrollWheel.ScrollUp.Codes.AsText := edtCodes1.Text;
  // Scroll down
  AScrollWheel.ScrollDown.Notes.AsText := edtNotes2.Text;
  AScrollWheel.ScrollDown.Codes.AsText := edtCodes2.Text;
  // Single click
  AScrollWheel.SingleClick.Notes.AsText := edtNotes3.Text;
  AScrollWheel.SingleClick.Codes.AsText := edtCodes3.Text;
  // Double click
  AScrollWheel.DoubleClick.Notes.AsText := edtNotes4.Text;
  AScrollWheel.DoubleClick.Codes.AsText := edtCodes4.Text;
end;

procedure TfmScrollWheel.btnCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes1);
end;

procedure TfmScrollWheel.btnPlayNotes1Click(Sender: TObject);
begin
  btnPlayNotes1.Enabled := False;
  try
    Manager.PlayText(edtNotes1.Text);
  finally
    btnPlayNotes1.Enabled := True;
    btnPlayNotes1.SetFocus;
  end;
end;

procedure TfmScrollWheel.btnNotes1Click(Sender: TObject);
begin
  ShowNotesDlg(edtNotes1);
end;

procedure TfmScrollWheel.pmiCut1Click(Sender: TObject);
begin
  (pmCodes.PopupComponent as TEdit).CutToClipboard;
end;

procedure TfmScrollWheel.pmiCopy1Click(Sender: TObject);
begin
  (pmCodes.PopupComponent as TEdit).CopyToClipboard;
end;

procedure TfmScrollWheel.pmiPast1Click(Sender: TObject);
begin
  (pmCodes.PopupComponent as TEdit).PasteFromClipboard;
end;

procedure TfmScrollWheel.pmiAllCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(pmCodes.PopupComponent as TEdit);
end;

procedure TfmScrollWheel.pmiPressCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(pmCodes.PopupComponent as TEdit, [koMake]);
end;

procedure TfmScrollWheel.pmiReleaseCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(pmCodes.PopupComponent as TEdit, [koBreak]);
end;

procedure TfmScrollWheel.btnCodes2Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes2);
end;

procedure TfmScrollWheel.btnCodes3Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes3);
end;

procedure TfmScrollWheel.btnCodes4Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes4);
end;

procedure TfmScrollWheel.btnPlayNotes2Click(Sender: TObject);
begin
  btnPlayNotes2.Enabled := False;
  try
    Manager.PlayText(edtNotes2.Text);
  finally
    btnPlayNotes2.Enabled := True;
    btnPlayNotes2.SetFocus;
  end;
end;

procedure TfmScrollWheel.btnPlayNotes3Click(Sender: TObject);
begin
  btnPlayNotes3.Enabled := False;
  try
    Manager.PlayText(edtNotes3.Text);
  finally
    btnPlayNotes3.Enabled := True;
    btnPlayNotes3.SetFocus;
  end;
end;

procedure TfmScrollWheel.btnPlayNotes4Click(Sender: TObject);
begin
  btnPlayNotes4.Enabled := False;
  try
    Manager.PlayText(edtNotes4.Text);
  finally
    btnPlayNotes4.Enabled := True;
    btnPlayNotes4.SetFocus;
  end;
end;

procedure TfmScrollWheel.btnNotes2Click(Sender: TObject);
begin
  ShowNotesDlg(edtNotes2);
end;

procedure TfmScrollWheel.btnNotes3Click(Sender: TObject);
begin
  ShowNotesDlg(edtNotes3);
end;

procedure TfmScrollWheel.btnNotes4Click(Sender: TObject);
begin
  ShowNotesDlg(edtNotes4);
end;

end.

