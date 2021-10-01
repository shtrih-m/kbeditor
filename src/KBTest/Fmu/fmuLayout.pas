unit fmuLayout;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard, uProgress, KeyboardManager, KBLayout,
  OperationThread, OperationInterface, WriteLayoutOperation;

type
  { TfmLayout }

  TfmLayout = class(TWizardPage)
    lblFileName: TLabel;
    edtFileName: TEdit;
    btnFileName: TButton;
    lblProgress: TLabel;
    ProgressBar: TProgressBar;
    OpenDialog: TOpenDialog;
    lblPercents: TLabel;
    Timer: TTimer;
    procedure btnFileNameClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FFilterIndex: Integer;
    FLayoutUpdated: Boolean;

    procedure UpdatePage;
    procedure WriteLayout;
    procedure OperationCompleted(Sender: TObject; Operation: IOperation);
  public
    procedure Stop; override;
    procedure Start; override;
    procedure Cancel; override;
  end;

implementation

{$R *.DFM}

{ TfmLayout }

procedure TfmLayout.Stop;
begin
  if FLayoutUpdated then
  begin
    Wizard.GoNext;
    Wizard.EnablePrev(True);
    Wizard.EnableNext(True);
  end else
  begin
    WriteLayout;
  end;
end;

procedure TfmLayout.Start;
begin
  Progress.Clear;
  FFilterIndex := 1;
  edtFileName.Text := Wizard.LayoutFileName;
  OpenDialog.InitialDir := Wizard.LayoutFileName;
  FLayoutUpdated := False;
  UpdatePage;
end;

procedure TfmLayout.btnFileNameClick(Sender: TObject);
begin
  OpenDialog.Filter := Manager.XmlFormat.Filter;
  OpenDialog.FileName := edtFileName.Text;
  if OpenDialog.Execute then
  begin
    edtFileName.Text := OpenDialog.FileName;
    FFilterIndex := OpenDialog.FilterIndex;
  end;
end;

procedure TfmLayout.OperationCompleted(Sender: TObject; Operation: IOperation);
begin
  EnableButtons(True);
  if WorkThread.Failed then
  begin
    MessageBox(Handle, PChar(WorkThread.ErrorMessage),
      PChar(Application.Title), MB_ICONERROR);
  end else
  begin
    FLayoutUpdated := True;
    Wizard.EnablePrev(True);
    Wizard.EnableNext(True);
    Wizard.GoNext;
  end;
end;

procedure TfmLayout.WriteLayout;
var
  Operation: IOperation;
begin
  Wizard.EnableNext(False);
  Wizard.EnablePrev(False);
  Wizard.LayoutFileName := edtFileName.Text;
  Manager.LoadFromFile(Wizard.Layout, FFilterIndex-1, edtFileName.Text);
  Operation := TWriteLayoutOperation.Create(Wizard.Layout);

  Progress.Clear;
  WorkThread.OnCompleted := OperationCompleted;
  WorkThread.Start(Operation);
  EnableButtons(False);
end;

procedure TfmLayout.TimerTimer(Sender: TObject);
begin
  UpdatePage;
end;

procedure TfmLayout.UpdatePage;
begin
  Progress.Lock;
  try
    ProgressBar.Max := Progress.BlockCount;
    ProgressBar.Position := Progress.BlockSent;
    lblPercents.Caption := Progress.ProgressText;
  finally
    Progress.Unlock;
  end;
end;

procedure TfmLayout.Cancel;
begin
  Progress.Stop;
end;

procedure TfmLayout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Progress.Stop;
end;

end.
