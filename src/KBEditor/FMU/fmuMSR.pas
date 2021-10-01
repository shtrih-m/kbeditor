unit fmuMSR;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, Menus, 
  // This
  KBLayout, KeyboardManager, fmuNotes, fmuCodes, Utils, SizeableForm;

type
  { TfmMSR }

  TfmMSR = class(TSizeableForm)
    btnOK: TButton;
    btnCancel: TButton;
    pmCodes: TPopupMenu;
    pmiCut1: TMenuItem;
    pmiCopy1: TMenuItem;
    mpiPast1: TMenuItem;
    MenuItem4: TMenuItem;
    pmiAllCodes: TMenuItem;
    pmiPressCodes: TMenuItem;
    pmiReleaseCodes: TMenuItem;
    chbTrack1: TCheckBox;
    chbTrack2: TCheckBox;
    chbTrack3: TCheckBox;
    chbLockOnErr: TCheckBox;
    chbSendEnter: TCheckBox;
    chbLightIndication: TCheckBox;
    edtNotes: TEdit;
    btnPlay: TBitBtn;
    btnNotes: TButton;
    gbTrack1: TGroupBox;
    lblPrefix1: TLabel;
    edtPrefix1: TEdit;
    btnPrefix1: TButton;
    lblSuffix1: TLabel;
    edtSuffix1: TEdit;
    btnSuffix1: TButton;
    gbTrack2: TGroupBox;
    gbTrack3: TGroupBox;
    edtPrefix2: TEdit;
    btnPrefix2: TButton;
    Label7: TLabel;
    Label8: TLabel;
    edtSuffix3: TEdit;
    btnSuffix3: TButton;
    Label1: TLabel;
    Label4: TLabel;
    Bevel2: TBevel;
    lblNotes: TLabel;
    edtPrefix3: TEdit;
    btnPrefix3: TButton;
    edtSuffix2: TEdit;
    btnSuffix2: TButton;
    procedure btnPlayClick(Sender: TObject);
    procedure btnNotesClick(Sender: TObject);
    procedure btnPrefix1Click(Sender: TObject);
    procedure btnSuffix1Click(Sender: TObject);
    procedure btnPrefix2Click(Sender: TObject);
    procedure btnSuffix2Click(Sender: TObject);
    procedure btnPrefix3Click(Sender: TObject);
    procedure btnSuffix3Click(Sender: TObject);
    procedure pmiCut1Click(Sender: TObject);
    procedure pmiCopy1Click(Sender: TObject);
    procedure mpiPast1Click(Sender: TObject);
    procedure pmiAllCodesClick(Sender: TObject);
    procedure pmiPressCodesClick(Sender: TObject);
    procedure pmiReleaseCodesClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FMSR: TMSR;
    function GetEdit: TEdit;
  public
    procedure UpdatePage(AMSR: TMSR);
    procedure UpdateObject(AMSR: TMSR);
  end;

var
  fmMSR: TfmMSR;

function ShowMSRDlg(AMSR: TMSR): Boolean;

implementation

{$R *.DFM}

function ShowMSRDlg(AMSR: TMSR): Boolean;
begin
  fmMSR.UpdatePage(AMSR);
  Result := fmMSR.ShowModal = mrOK;
end;

{ TfmReader }

procedure TfmMSR.UpdatePage(AMSR: TMSR);
begin
  FMSR := AMSR;
  // Flags
  chbTrack1.Checked := AMSR.Tracks[0].Enabled;
  chbTrack2.Checked := AMSR.Tracks[1].Enabled;
  chbTrack3.Checked := AMSR.Tracks[2].Enabled;
  chbLockOnErr.Checked := AMSR.LockOnErr;
  chbSendEnter.Checked := AMSR.SendEnter;
  chbLightIndication.Checked := AMSR.LightIndication;
  // Prefix
  edtPrefix1.Text := AMSR.Tracks[0].Prefix.AsText;
  edtPrefix2.Text := AMSR.Tracks[1].Prefix.AsText;
  edtPrefix3.Text := AMSR.Tracks[2].Prefix.AsText;
  // Suffix
  edtSuffix1.Text := AMSR.Tracks[0].Suffix.AsText;
  edtSuffix2.Text := AMSR.Tracks[1].Suffix.AsText;
  edtSuffix3.Text := AMSR.Tracks[2].Suffix.AsText;
  // Notes
  edtNotes.Text := AMSR.Notes.AsText;
end;

procedure TfmMSR.UpdateObject(AMSR: TMSR);
begin
  AMSR.BeginUpdate;
  try
    // Flags
    AMSR.Tracks[0].Enabled := chbTrack1.Checked;
    AMSR.Tracks[1].Enabled := chbTrack2.Checked;
    AMSR.Tracks[2].Enabled := chbTrack3.Checked;
    AMSR.LockOnErr := chbLockOnErr.Checked;
    AMSR.SendEnter := chbSendEnter.Checked;
    AMSR.LightIndication := chbLightIndication.Checked;

    try
      AMSR.Tracks[0].Prefix.AsText := edtPrefix1.Text;
    except
      on E: Exception do
      begin
        edtPrefix1.SetFocus;
        raise;
      end;
    end;

    try
      AMSR.Tracks[0].Suffix.AsText := edtSuffix1.Text;
    except
      on E: Exception do
      begin
        edtSuffix1.SetFocus;
        raise;
      end;
    end;

    try
      AMSR.Tracks[1].Prefix.AsText := edtPrefix2.Text;
    except
      on E: Exception do
      begin
        edtPrefix2.SetFocus;
        raise;
      end;
    end;

    try
      AMSR.Tracks[1].Suffix.AsText := edtSuffix2.Text;
    except
      on E: Exception do
      begin
        edtSuffix2.SetFocus;
        raise;
      end;
    end;

    try
      AMSR.Tracks[2].Prefix.AsText := edtPrefix3.Text;
    except
      on E: Exception do
      begin
        edtPrefix3.SetFocus;
        raise;
      end;
    end;

    try
      AMSR.Tracks[2].Suffix.AsText := edtSuffix3.Text;
    except
      on E: Exception do
      begin
        edtSuffix3.SetFocus;
        raise;
      end;
    end;

    try
      AMSR.Notes.AsText := edtNotes.Text;
    except
      on E: Exception do
      begin
        edtNotes.SetFocus;
        raise;
      end;
    end;

  finally
    AMSR.EndUpdate;
  end;
end;

procedure TfmMSR.btnPlayClick(Sender: TObject);
begin
  btnPlay.Enabled := False;
  try
    Manager.PlayText(edtNotes.Text);
  finally
    btnPlay.Enabled := True;
    btnPlay.SetFocus;
  end;
end;

procedure TfmMSR.btnNotesClick(Sender: TObject);
begin
  ShowNotesDlg(edtNotes);
end;

procedure TfmMSR.btnPrefix1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtPrefix1);
end;

procedure TfmMSR.btnPrefix2Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtPrefix2);
end;

procedure TfmMSR.btnPrefix3Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtPrefix3);
end;

procedure TfmMSR.btnSuffix1Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtSuffix1);
end;

procedure TfmMSR.btnSuffix2Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtSuffix2);
end;

procedure TfmMSR.btnSuffix3Click(Sender: TObject);
begin
  fmCodes.ShowDialog(edtSuffix3);
end;

function TfmMSR.GetEdit: TEdit;
begin
  Result := pmCodes.PopupComponent as TEdit;
  if Result = nil then Abort;
end;

procedure TfmMSR.pmiCut1Click(Sender: TObject);
begin
  GetEdit.CutToClipboard;
end;

procedure TfmMSR.pmiCopy1Click(Sender: TObject);
begin
  GetEdit.CopyToClipboard;
end;

procedure TfmMSR.mpiPast1Click(Sender: TObject);
begin
  GetEdit.PasteFromClipboard;
end;

procedure TfmMSR.pmiAllCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit);
end;

procedure TfmMSR.pmiPressCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit, [koMake]);
end;

procedure TfmMSR.pmiReleaseCodesClick(Sender: TObject);
begin
  fmCodes.ShowDialog(GetEdit, [koBreak]);
end;

procedure TfmMSR.btnOKClick(Sender: TObject);
begin
  UpdateObject(FMSR);
  ModalResult := mrOK;
end;

end.
