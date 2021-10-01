unit fmuKey;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus,
  // This
  KBLayout, Utils, fmuCodes, KeyboardManager, KeyboardDriver,
  fmuNotes, GridType, SizeableForm, KeyEditor, DebugUtils;

type
  { TfmKeyDlg }

  TfmKeyDlg = class(TSizeableForm)
    lblKeyFunc: TLabel;
    cbKeyType: TComboBox;
    lblPress: TLabel;
    edtPress: TEdit;
    btnPress: TButton;
    btnRelease: TButton;
    edtRelease: TEdit;
    lblRelease: TLabel;
    chbRepeatKey: TCheckBox;
    lblSound: TLabel;
    edtNotes: TEdit;
    btnPlay: TBitBtn;
    btnSound: TButton;
    edtText: TEdit;
    lblText: TLabel;
    Bevel1: TBevel;
    pmCodes: TPopupMenu;
    pmiCut1: TMenuItem;
    pmiCopy1: TMenuItem;
    mpiPast1: TMenuItem;
    MenuItem4: TMenuItem;
    pmiAllCodes1: TMenuItem;
    Bevel2: TBevel;
    pmiPressCodes: TMenuItem;
    pmiReleaseCodes: TMenuItem;
    procedure cbKeyTypeChange(Sender: TObject);
    procedure btnPressClick(Sender: TObject);
    procedure btnReleaseClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnSoundClick(Sender: TObject);
    procedure chbRepeatKeyClick(Sender: TObject);
    procedure edtTextChange(Sender: TObject);
    procedure edtNotesChange(Sender: TObject);
    procedure pmiAllCodesClick1(Sender: TObject);
    procedure pmiCutClick1(Sender: TObject);
    procedure pmiCopyClick1(Sender: TObject);
    procedure pmiPasteClick1(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPressExit(Sender: TObject);
    procedure edtReleaseExit(Sender: TObject);
    procedure pmiPressCodesClick(Sender: TObject);
    procedure pmiReleaseCodesClick(Sender: TObject);
    procedure edtPressKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtReleaseKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FEditor: TKeyEditor;
    FLink: TKBLayoutLink;

    procedure ClearPage;
    function GetEdit: TEdit;
    function GetLayout: TKBLayout;
    procedure LayoutChanged(Sender: TObject);
    procedure SetLayout(const Value: TKBLayout);
    procedure UpdateControls(IsMacros: Boolean);
    procedure SetPressCodes(const Codes: string);
    procedure SetReleaseCodes(const Codes: string);

    property Editor: TKeyEditor read FEditor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdatePage;
    property Layout: TKBLayout read GetLayout write SetLayout;
  end;

var
  fmKeyDlg: TfmKeyDlg;

implementation

{$R *.DFM}

function KeyTypeToInt(Value: TKeyType): Integer;
begin
  case Value of
    ktMacros    : Result := 0;
    ktGoUp      : Result := 1;
    ktGoDown    : Result := 2;
    ktGo1       : Result := 3;
    ktGo2       : Result := 4;
    ktGo3       : Result := 5;
    ktGo4       : Result := 6;
    ktTemp1     : Result := 7;
    ktTemp2     : Result := 8;
    ktTemp3     : Result := 9;
    ktTemp4     : Result := 10;
  else
    Result := -1;
  end;
end;

function IntToKeyType(Value: Integer): TKeyType;
begin
  case Value of
    0: Result := ktMacros;
    1: Result := ktGoUp;
    2: Result := ktGoDown;
    3: Result := ktGo1;
    4: Result := ktGo2;
    5: Result := ktGo3;
    6: Result := ktGo4;
    7: Result := ktTemp1;
    8: Result := ktTemp2;
    9: Result := ktTemp3;
    10: Result := ktTemp4;
  else
    Result := ktMacros;
  end;
end;

{ TfmKeyDlg }

constructor TfmKeyDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  cbKeyType.ItemIndex := 0;
  FEditor := TKeyEditor.Create(Self);
  FLink := TKBLayoutLink.Create;
  FLink.OnChange := LayoutChanged;
end;

destructor TfmKeyDlg.Destroy;
begin
  FLink.Free;
  inherited Destroy;
end;

procedure TfmKeyDlg.LayoutChanged(Sender: TObject);
begin
  if Visible then
  begin
    if Layout <> nil then
    begin
      UpdatePage;
    end else
    begin
      ClearPage;
    end;
  end;
end;

procedure TfmKeyDlg.SetLayout(const Value: TKBLayout);
begin
  Editor.Layout := Value;
  FLink.Layout := Value;
end;

function TfmKeyDlg.GetLayout: TKBLayout;
begin
  Result := FLink.Layout;
end;

procedure TfmKeyDlg.UpdateControls(IsMacros: Boolean);
begin
  lblPress.Enabled := IsMacros;
  edtPress.Enabled := IsMacros;
  btnPress.Enabled := IsMacros;
  btnRelease.Enabled := IsMacros;
  lblRelease.Enabled := IsMacros;
  edtRelease.Enabled := IsMacros;
  chbRepeatKey.Enabled := IsMacros;
end;

procedure TfmKeyDlg.ClearPage;
begin
  SafeSetEdit(edtText, '');
  SafeSetEdit(edtNotes, '');
  SafeSetEdit(edtPress, '');
  SafeSetEdit(edtRelease, '');
  SafeSetChecked(chbRepeatKey, False);
end;

{ Page update }

procedure TfmKeyDlg.UpdatePage;
begin
  if Layout = nil then Exit;
  cbKeyType.ItemIndex := KeyTypeToInt(Editor.KeyType);
  SafeSetEdit(edtText, Editor.Text);
  SafeSetEdit(edtNotes, Editor.NotesText);
  SafeSetChecked(chbRepeatKey, Editor.RepeatKey);
  SafeSetEdit(edtPress, Editor.PressCodesText);
  SafeSetEdit(edtRelease, Editor.ReleaseCodesText);
  Caption := Editor.Caption;
  UpdateControls(Editor.KeyType in [ktMacros]);
end;

procedure TfmKeyDlg.cbKeyTypeChange(Sender: TObject);
begin
  if Layout = nil then Exit;
  Editor.KeyType := IntToKeyType(cbKeyType.ItemIndex);
  UpdateControls(cbKeyType.ItemIndex = 0);
end;

procedure TfmKeyDlg.btnPressClick(Sender: TObject);
var
  CodesText: string;
begin
  CodesText := edtPress.Text;
  if fmCodes.ShowDialog(CodesText, [koMake]) then
    SetPressCodes(CodesText);
end;

procedure TfmKeyDlg.btnReleaseClick(Sender: TObject);
var
  CodesText: string;
begin
  CodesText := edtRelease.Text;
  if fmCodes.ShowDialog(CodesText, [koBreak]) then
    SetReleaseCodes(CodesText);
end;

procedure TfmKeyDlg.btnPlayClick(Sender: TObject);
begin
  btnPlay.Enabled := False;
  try
    Manager.PlayText(edtNotes.Text);
  finally
    btnPlay.Enabled := True;
    btnPlay.SetFocus;
  end;
end;

procedure TfmKeyDlg.chbRepeatKeyClick(Sender: TObject);
begin
  Editor.RepeatKey := chbRepeatKey.Checked;
end;

procedure TfmKeyDlg.btnSoundClick(Sender: TObject);
begin
  ShowNotesDlg(edtNotes);
end;

procedure TfmKeyDlg.edtTextChange(Sender: TObject);
begin
  Editor.Text := edtText.Text;
end;

procedure TfmKeyDlg.edtNotesChange(Sender: TObject);
begin
  Editor.NotesText := edtNotes.Text;
end;

function TfmKeyDlg.GetEdit: TEdit;
begin
  Result := pmCodes.PopupComponent as TEdit;
  if Result = nil then
    Abort;
end;

procedure TfmKeyDlg.pmiAllCodesClick1(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit);
end;

procedure TfmKeyDlg.pmiCutClick1(Sender: TObject);
begin
  GetEdit.CutToClipboard;
end;

procedure TfmKeyDlg.pmiCopyClick1(Sender: TObject);
begin
  GetEdit.CopyToClipboard;
end;

procedure TfmKeyDlg.pmiPasteClick1(Sender: TObject);
begin
  GetEdit.PasteFromClipboard;
end;

procedure TfmKeyDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Hide;
end;

procedure TfmKeyDlg.SetPressCodes(const Codes: string);
begin
  try
    Editor.PressCodesText := Codes;
  except
    on E: Exception do
    begin
      edtPress.SetFocus;
      raise;
    end;
  end;
end;

procedure TfmKeyDlg.SetReleaseCodes(const Codes: string);
begin
  try
    Editor.ReleaseCodesText := Codes;
  except
    on E: Exception do
    begin
      edtRelease.SetFocus;
      raise;
    end;
  end;
end;

procedure TfmKeyDlg.edtPressExit(Sender: TObject);
begin
  SetPressCodes(edtPress.Text);
end;

procedure TfmKeyDlg.edtReleaseExit(Sender: TObject);
begin
  SetReleaseCodes(edtRelease.Text);
end;

procedure TfmKeyDlg.pmiPressCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit, [koMake]);
end;

procedure TfmKeyDlg.pmiReleaseCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit, [koBreak]);
end;

procedure TfmKeyDlg.edtPressKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SetPressCodes(edtPress.Text);
end;

procedure TfmKeyDlg.edtReleaseKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SetReleaseCodes(edtRelease.Text);
end;

procedure TfmKeyDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetPressCodes(edtPress.Text);
  SetReleaseCodes(edtRelease.Text);
end;

end.

