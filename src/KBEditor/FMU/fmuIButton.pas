unit fmuIButton;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus,
  // JVCL
  JvGIF, 
  // This
  KBLayout, Utils, fmuCodes, KeyboardManager, KeyboardDriver,
  fmuNotes, GridType, SizeableForm, fmuIButtonKey;

type
  { TfmIButton }

  TfmIButton = class(TSizeableForm)
    lblPrefix: TLabel;
    edtPrefix: TEdit;
    btnPrefix: TButton;
    btnSuffix: TButton;
    edtSuffix: TEdit;
    lblSuffix: TLabel;
    lblNotes: TLabel;
    edtNotes: TEdit;
    btnPlayNotes: TBitBtn;
    btnNotes: TButton;
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
    rbSendCode: TRadioButton;
    rbSearchCode: TRadioButton;
    Bevel3: TBevel;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    btnEdit: TBitBtn;
    btnDelAll: TBitBtn;
    lbCodes: TListBox;
    Image2: TImage;
    procedure btnPrefixClick(Sender: TObject);
    procedure btnSuffixClick(Sender: TObject);
    procedure btnPlayNotesClick(Sender: TObject);
    procedure btnNotesClick(Sender: TObject);
    procedure pmiAllCodes1Click(Sender: TObject);
    procedure pmiPressCodes1Click(Sender: TObject);
    procedure pmiReleaseCodes1Click(Sender: TObject);
    procedure pmiCut1Click(Sender: TObject);
    procedure pmiCopy1Click(Sender: TObject);
    procedure pmiPast1Click(Sender: TObject);
    procedure EditItem(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure DeleteItem(Sender: TObject);
    procedure btnDelAllClick(Sender: TObject);
    procedure lbCodesClick(Sender: TObject);
    procedure lbCodesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FIButton: TIButton;
    FItemIndex: Integer;

    procedure UpdatePage;
    procedure UpdateCodes;
    procedure UpdateButtons;
    function GetEdit: TEdit;
    function ValidItemIndex: Boolean;
    function GetSelectedItem: TIButtonKey;

    property IButton: TIButton read FIButton;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdateObject(AIButton: TIButton);
  end;

var
  fmIButton: TfmIButton;

function ShowIButtonDlg(AIButton: TIButton): Boolean;

implementation

{$R *.DFM}

function ShowIButtonDlg(AIButton: TIButton): Boolean;
begin
  fmIButton.IButton.Assign(AIButton);
  fmIButton.UpdatePage;
  Result := fmIButton.ShowModal = mrOK;
  if Result then
    fmIButton.UpdateObject(AIButton);
end;

{ TfmIButton }

constructor TfmIButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIButton := TIButton.Create(nil);
end;

destructor TfmIButton.Destroy;
begin
  FIButton.Free;
  inherited Destroy;
end;

procedure TfmIButton.UpdateObject(AIButton: TIButton);
begin
  AIButton.BeginUpdate;
  try
    AIButton.SendCode := rbSendCode.Checked;
    AIButton.Notes.AsText := edtNotes.Text;
    AIButton.Prefix.AsText := edtPrefix.Text;
    AIButton.Suffix.AsText := edtSuffix.Text;
    AIButton.DefKey.Assign(IButton.DefKey);
    AIButton.RegKeys.Assign(IButton.RegKeys);
  finally
    AIButton.EndUpdate;
  end;
end;

function TfmIButton.ValidItemIndex: Boolean;
begin
  Result := (lbCodes.ItemIndex >= 0)and(lbCodes.ItemIndex < lbCodes.Items.Count);
end;

function TfmIButton.GetSelectedItem: TIButtonKey;
begin
  Result := TIButtonKey(lbCodes.Items.Objects[lbCodes.ItemIndex]);
end;

procedure TfmIButton.UpdateButtons;
begin
  btnDelAll.Enabled := IButton.RegKeys.Count > 0;
  if ValidItemIndex then
    btnDelete.Enabled := GetSelectedItem.CanDelete;
end;

procedure TfmIButton.UpdateCodes;
var
  i: Integer;
  Key: TIButtonKey;
begin
  lbCodes.Items.BeginUpdate;
  try
    lbCodes.Items.Clear;
    // Unregistered key
    Key := IButton.DefKey;
    lbCodes.Items.AddObject(Key.DisplayText, Key);
    // Registered keys
    for i := 0 to IButton.RegKeys.Count-1 do
    begin
      Key := IButton.RegKeys[i];
      lbCodes.Items.AddObject(Key.DisplayText, Key);
    end;
    // Select first item
    lbCodes.ItemIndex := FItemIndex;
    UpdateButtons;
  finally
    lbCodes.Items.EndUpdate;
  end;
end;

procedure TfmIButton.UpdatePage;
begin
  rbSendCode.Checked := IButton.SendCode;
  rbSearchCode.Checked := not IButton.SendCode;
  edtNotes.Text := IButton.Notes.AsText;
  edtPrefix.Text := IButton.Prefix.AsText;
  edtSuffix.Text := IButton.Suffix.AsText;
  UpdateCodes;
end;

procedure TfmIButton.btnPrefixClick(Sender: TObject);
begin
  fmCodes.ShowDialog(edtPrefix);
end;

procedure TfmIButton.btnSuffixClick(Sender: TObject);
begin
  fmCodes.ShowDialog(edtSuffix);
end;

procedure TfmIButton.btnPlayNotesClick(Sender: TObject);
begin
  btnPlayNotes.Enabled := False;
  try
    Manager.PlayText(edtNotes.Text);
  finally
    btnPlayNotes.Enabled := True;
    btnPlayNotes.SetFocus;
  end;
end;

procedure TfmIButton.btnNotesClick(Sender: TObject);
begin
  ShowNotesDlg(edtNotes);
end;

function TfmIButton.GetEdit: TEdit;
begin
  Result := pmCodes.PopupComponent as TEdit;
  if Result = nil then
    Abort;
end;

procedure TfmIButton.pmiAllCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit);
end;

procedure TfmIButton.pmiPressCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit, [koMake]);
end;

procedure TfmIButton.pmiReleaseCodes1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit, [koBreak]);
end;

procedure TfmIButton.pmiCut1Click(Sender: TObject);
begin
  GetEdit.CutToClipboard;
end;

procedure TfmIButton.pmiCopy1Click(Sender: TObject);
begin
  GetEdit.CopyToClipboard;
end;

procedure TfmIButton.pmiPast1Click(Sender: TObject);
begin
  GetEdit.PasteFromClipboard;
end;

procedure TfmIButton.btnAddClick(Sender: TObject);
var
  IButtonKey: TIButtonKey;
begin
  IButtonKey := IButton.RegKeys.Add;
  if ShowIButtonKeyDlg(IButtonKey) then
  begin
    FItemIndex := IButton.RegKeys.Count;
    UpdateCodes
  end else
  begin
    IButtonKey.Free;
  end;
end;

procedure TfmIButton.EditItem(Sender: TObject);
begin
  if ValidItemIndex then
  begin
    ShowIButtonKeyDlg(GetSelectedItem);
    UpdateCodes;
  end;
end;

procedure TfmIButton.DeleteItem(Sender: TObject);
begin
  if ValidItemIndex then
  begin
    GetSelectedItem.Delete;
    if FItemIndex > IButton.RegKeys.Count then
      FItemIndex := IButton.RegKeys.Count;
    UpdateCodes;
  end;
end;

procedure TfmIButton.btnDelAllClick(Sender: TObject);
begin
  IButton.RegKeys.Clear;
  FItemIndex := 0;
  UpdateCodes;
end;

procedure TfmIButton.lbCodesClick(Sender: TObject);
begin
  FItemIndex := lbCodes.ItemIndex;
  UpdateButtons;
end;

procedure TfmIButton.lbCodesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then EditItem(Self);
  if Key = VK_DELETE then DeleteItem(Self);
end;

end.

