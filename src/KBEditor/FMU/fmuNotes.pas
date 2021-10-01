unit fmuNotes;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,
  // This
  KBLayout, KeyboardManager, KeyboardDriver, SizeableForm;

type
  { TfmNotes }

  TfmNotes = class(TSizeableForm)
    btnOpen: TBitBtn;
    btnSave: TBitBtn;
    btnPlay: TBitBtn;
    btnClear: TBitBtn;
    btnOK: TButton;
    btnCancel: TButton;
    Memo: TMemo;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure btnClearClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
  end;

function ShowNotesDlg(var edt: TEdit): Boolean;

var
  fmNotes: TfmNotes;

implementation

{$R *.DFM}

function ShowNotesDlg(var edt: TEdit): Boolean;
begin
  fmNotes.Memo.Text := edt.Text;
  Result := fmNotes.ShowModal = mrOK;
  if Result then
    edt.Text := fmNotes.Memo.Text;
end;

procedure CheckNotes(const NotesText: string);
var
  Notes: TNotes;
begin
  Notes := TNotes.Create(nil);
  try
    Notes.AsText := NotesText;
  finally
    Notes.Free;
  end;
end;

{ TfmNEditor }

procedure TfmNotes.btnClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

procedure TfmNotes.btnOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    Memo.Lines.LoadFromFile(OpenDialog.FileName);
end;

procedure TfmNotes.btnSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    Memo.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TfmNotes.FormCreate(Sender: TObject);
var
  Dir: string;
begin
  Dir := ExtractFilePath(ParamStr(0));
  OpenDialog.InitialDir := Dir;
  SaveDialog.InitialDir := Dir;
end;

procedure TfmNotes.btnOKClick(Sender: TObject);
begin
  CheckNotes(Memo.Text);
  ModalResult := mrOK;
end;

procedure TfmNotes.btnPlayClick(Sender: TObject);
begin
  btnPlay.Enabled := False;
  try
    Manager.PlayText(Memo.Text);
  finally
    btnPlay.Enabled := True;
    btnPlay.SetFocus;
  end;
end;

end.
