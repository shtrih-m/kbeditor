unit fmuIButtonKey;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus,
  // This
  KBLayout, Utils, fmuCodes, KeyboardManager, KeyboardDriver, fmuNotes,
  GridType, SizeableForm;

type
  { TfmIButtonKey }

  TfmIButtonKey = class(TSizeableForm)
    Bevel1: TBevel;
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
    lblCodes: TLabel;
    lblNotes: TLabel;
    btnCodes: TButton;
    edtCodes: TEdit;
    edtNotes: TEdit;
    btnPlayNotes: TBitBtn;
    btnNotes: TButton;
    lblCode: TLabel;
    edtCode: TEdit;
    cbCodeType: TComboBox;
    lblAction: TLabel;
    procedure btnCodesClick(Sender: TObject);
    procedure btnPlayNotesClick(Sender: TObject);
    procedure btnNotesClick(Sender: TObject);
    procedure pmiCut1Click(Sender: TObject);
    procedure pmiCopy1Click(Sender: TObject);
    procedure pmiPast1Click(Sender: TObject);
    procedure pmiAllCodes1Click(Sender: TObject);
    procedure pmiPressCodes1Click(Sender: TObject);
    procedure pmiReleaseCodes1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure UpdatePage(AIButtonKey: TIButtonKey);
    procedure UpdateObject(AIButtonKey: TIButtonKey);
  end;

var
  fmIButtonKey: TfmIButtonKey;

function ShowIButtonKeyDlg(AIButtonKey: TIButtonKey): Boolean;

implementation

resourcestring
  MsgIButtonCode        = 'Send code';
  MsgIButtonGo1         = 'Switch to layer 1';
  MsgIButtonGo2         = 'Switch to layer 2';
  MsgIButtonGo3         = 'Switch to layer 3';
  MsgIButtonGo4         = 'Switch to layer 4';
  MsgUnknownKeytype     = 'Unknown code type';

{$R *.DFM}

function ShowIButtonKeyDlg(AIButtonKey: TIButtonKey): Boolean;
begin
  fmIButtonKey.UpdatePage(AIButtonKey);
  Result := fmIButtonKey.ShowModal = mrOK;
  if Result then
    fmIButtonKey.UpdateObject(AIButtonKey);
end;

{ TfmIButtonKey }

procedure TfmIButtonKey.UpdatePage(AIButtonKey: TIButtonKey);
begin
  edtCode.Enabled := AIButtonKey.Registered;
  lblCode.Enabled := AIButtonKey.Registered;
  edtCode.Text := AIButtonKey.NumberAsHex;
  edtNotes.Text := AIButtonKey.Notes.AsText;
  edtCodes.Text := AIButtonKey.Codes.AsText;
  cbCodeType.ItemIndex := Ord(AIButtonKey.CodeType);
end;

procedure TfmIButtonKey.UpdateObject(AIButtonKey: TIButtonKey);
begin
  AIButtonKey.NumberAsHex := edtCode.Text;
  AIButtonKey.Notes.AsText := edtNotes.Text;
  AIButtonKey.Codes.AsText := edtCodes.Text;
  AIButtonKey.CodeType := TIButtonKeyType(cbCodeType.ItemIndex);
end;

procedure TfmIButtonKey.btnCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes);
end;

procedure TfmIButtonKey.btnPlayNotesClick(Sender: TObject);
begin
  btnPlayNotes.Enabled := False;
  try
    Manager.PlayText(edtNotes.Text);
  finally
    btnPlayNotes.Enabled := True;
    btnPlayNotes.SetFocus;
  end;
end;

procedure TfmIButtonKey.btnNotesClick(Sender: TObject);
begin
  ShowNotesDlg(edtNotes);
end;

procedure TfmIButtonKey.pmiCut1Click(Sender: TObject);
begin
  edtCodes.CutToClipboard;
end;

procedure TfmIButtonKey.pmiCopy1Click(Sender: TObject);
begin
  edtCodes.CopyToClipboard;
end;

procedure TfmIButtonKey.pmiPast1Click(Sender: TObject);
begin
  edtCodes.PasteFromClipboard;
end;

procedure TfmIButtonKey.pmiAllCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes);
end;

procedure TfmIButtonKey.pmiPressCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes, [koMake]);
end;

procedure TfmIButtonKey.pmiReleaseCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes, [koBreak]);
end;

function IButtonKeyTypeToStr(Value: TIButtonKeyType): string;
begin
  case Value of
    ctNone : Result := MsgIButtonCode;
    ctGo1  : Result := MsgIButtonGo1;
    ctGo2  : Result := MsgIButtonGo2;
    ctGo3  : Result := MsgIButtonGo3;
    ctGo4  : Result := MsgIButtonGo4;
  else
    raise Exception.Create(MsgUnknownKeyType);
  end;
end;

procedure TfmIButtonKey.FormCreate(Sender: TObject);
var
  i: TIButtonKeyType;
begin
  cbCodeType.Clear;
  for i := Low(TIButtonKeyType) to High(TIButtonKeyType) do
    cbCodeType.Items.AddObject(IButtonKeyTypeToStr(i), TObject(i));
end;

end.

