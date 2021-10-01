unit fmuKeyLock;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, Menus,
  // This
  KBLayout, KeyboardManager, fmuNotes, fmuCodes, Utils, SizeableForm;

type
  { TfmKeyLock }

  TfmKeyLock = class(TSizeableForm)
    btnOK: TButton;
    btnCancel: TButton;
    lbPosition: TListBox;
    Label1: TLabel;
    edtCodes: TEdit;
    btnCodes: TButton;
    edtNotes: TEdit;
    btnPlay: TBitBtn;
    btnNotes: TButton;
    lblCodes: TLabel;
    lblNotes: TLabel;
    Bevel1: TBevel;
    chbLockEnabled: TCheckBox;
    lblKeyFunc: TLabel;
    cbPosType: TComboBox;
    pmPress: TPopupMenu;
    pmiCut: TMenuItem;
    pmiCopy: TMenuItem;
    pmiPaste: TMenuItem;
    N3: TMenuItem;
    PressCodes: TMenuItem;
    ReleaseCodes: TMenuItem;
    AllCodes: TMenuItem;
    chbNcrEmulation: TCheckBox;
    chbNixdorfEmulation: TCheckBox;
    procedure btnNotesClick(Sender: TObject);
    procedure btnCodesClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure lbPositionClick(Sender: TObject);
    procedure AllCodesClick(Sender: TObject);
    procedure pmiCopyClick(Sender: TObject);
    procedure pmiCutClick(Sender: TObject);
    procedure pmiPasteClick(Sender: TObject);
    procedure PressCodesClick(Sender: TObject);
    procedure ReleaseCodesClick(Sender: TObject);
    procedure cbPosTypeChange(Sender: TObject);
  private
    FKeylock: TKeylock;
    FPositionIndex: Integer;    

    procedure ApplyPosition;
    procedure UpdateControls;
    procedure ShowPosition(Index: Integer);

    property Keylock: TKeylock read FKeylock;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdatePage(AKeylock: TKeylock);
    procedure UpdateObject(AKeylock: TKeylock);
  end;

var
  fmKeyLock: TfmKeyLock;

function ShowKeyLockDlg(AKeylock: TKeylock): Boolean;

implementation

{$R *.DFM}

function ShowKeyLockDlg(AKeylock: TKeylock): Boolean;
begin
  fmKeyLock.UpdatePage(AKeylock);
  Result := fmKeyLock.ShowModal = mrOK;
  if Result then
    fmKeyLock.UpdateObject(AKeylock);
end;

{ TfmReader }

constructor TfmKeyLock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FKeylock := TKeylock.Create(nil);
end;

destructor TfmKeyLock.Destroy;
begin
  FKeylock.Free;
  inherited Destroy;
end;

procedure TfmKeyLock.ShowPosition(Index: Integer);
var
  KeyPosition: TKeyPosition;
begin
  if KeyLock.Count > 0 then
  begin
    FPositionIndex := Index;
    KeyPosition := KeyLock[Index];
    edtCodes.Text := KeyPosition.Codes.AsText;
    edtNotes.Text := KeyPosition.Notes.AsText;
    cbPosType.ItemIndex := Ord(KeyPosition.PosType);
    chbLockEnabled.Checked := KeyPosition.LockEnabled;
    chbNcrEmulation.Checked := KeyPosition.NcrEmulation;
    chbNixdorfEmulation.Checked := KeyPosition.NixdorfEmulation;
    UpdateControls;
  end;
end;

procedure TfmKeyLock.ApplyPosition;
var
  KeyPosition: TKeyPosition;
begin
  if KeyLock.Count > 0 then
  begin
    KeyPosition := KeyLock[FPositionIndex];
    KeyPosition.Codes.AsText := edtCodes.Text;
    KeyPosition.Notes.AsText := edtNotes.Text;
    KeyPosition.LockEnabled := chbLockEnabled.Checked;
    KeyPosition.NcrEmulation := chbNcrEmulation.Checked;
    KeyPosition.NixdorfEmulation := chbNixdorfEmulation.Checked;
    KeyPosition.PosType := TPosType(cbPosType.ItemIndex);
  end;
end;

procedure TfmKeyLock.UpdatePage(AKeylock: TKeylock);
var
  i: Integer;
resourcestring
  MsgPosition = 'Position';
begin
  Keylock.Assign(AKeylock);
  // Positions
  lbPosition.Clear;
  for i := 0 to KeyLock.Count-1 do
    lbPosition.Items.Add(Format('%s %d', [MsgPosition, i+1]));
  // Current position
  if KeyLock.Count > 0 then
  begin
    if FPositionIndex >= KeyLock.Count then
      FPositionIndex := 0;

    lbPosition.ItemIndex := FPositionIndex;
    ShowPosition(FPositionIndex);
  end;
  UpdateControls;
end;

procedure TfmKeyLock.UpdateObject(AKeylock: TKeylock);
begin
  ApplyPosition;
  AKeylock.Assign(Keylock);
end;

procedure TfmKeyLock.btnCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes);
end;

procedure TfmKeyLock.btnNotesClick(Sender: TObject);
begin
  ShowNotesDlg(edtNotes);
end;

procedure TfmKeyLock.btnPlayClick(Sender: TObject);
begin
  btnPlay.Enabled := False;
  try
    Manager.PlayText(edtNotes.Text);
  finally
    btnPlay.Enabled := True;
    btnPlay.SetFocus;
  end;
end;

procedure TfmKeyLock.lbPositionClick(Sender: TObject);
begin
  ApplyPosition;
  ShowPosition(lbPosition.ItemIndex);
end;

procedure TfmKeyLock.PressCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes, [koMake]);
end;

procedure TfmKeyLock.ReleaseCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes, [koBreak]);
end;

procedure TfmKeyLock.AllCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(edtCodes);
end;

procedure TfmKeyLock.pmiCutClick(Sender: TObject);
begin
  edtCodes.CutToClipboard;
end;

procedure TfmKeyLock.pmiCopyClick(Sender: TObject);
begin
  edtCodes.CopyToClipboard;
end;

procedure TfmKeyLock.pmiPasteClick(Sender: TObject);
begin
  edtCodes.PasteFromClipboard;
end;

procedure TfmKeyLock.cbPosTypeChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfmKeyLock.UpdateControls;
var
  CodesEnabled: Boolean;
begin
  CodesEnabled := cbPosType.ItemIndex = 0;
  lblCodes.Enabled := CodesEnabled;
  edtCodes.Enabled := CodesEnabled;
  btnCodes.Enabled := CodesEnabled;
end;

end.
