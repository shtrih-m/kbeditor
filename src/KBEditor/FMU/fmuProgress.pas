unit fmuProgress;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  // This
  SizeableForm, KeyboardManager, uProgress, OperationThread, DebugUtils;

type
  { TfmProgress }

  TfmProgress = class(TSizeableForm)
    lblTimeLeft: TLabel;
    ProgressBar: TProgressBar;
    btnCancel: TButton;
    lblProgress: TLabel;
    edtDataRate: TEdit;
    lblDataRate: TLabel;
    edtTimeLeft: TEdit;
    edtProgress: TEdit;
    lblDataSent: TLabel;
    edtDataSent: TEdit;
    lblDataSize: TLabel;
    edtDataSize: TEdit;
    lblBlockSent: TLabel;
    edtBlockSent: TEdit;
    lblBlockCount: TLabel;
    edtBlockCount: TEdit;
    edtOperation: TEdit;
    Timer: TTimer;
    procedure btnCancelClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    procedure ClearPage;
    procedure UpdatePage;
  end;

var
  fmProgress: TfmProgress;

implementation

{$R *.DFM}

{ TfmProgress }

procedure TfmProgress.ClearPage;
begin
  edtOperation.Clear;
  edtProgress.Clear;
  edtTimeLeft.Clear;
  edtDataSize.Clear;
  edtDataRate.Clear;
  edtDataSent.Clear;
  edtBlockSent.Clear;
  edtBlockCount.Clear;
  ProgressBar.Position := 0;
end;

procedure TfmProgress.UpdatePage;
begin
  edtOperation.Text := Progress.Operation;
  edtProgress.Text := Progress.ProgressText;
  ProgressBar.Max := Progress.BlockCount;
  ProgressBar.Position := Progress.BlockSent;
  edtTimeLeft.Text := Progress.TimeLeftText;
  edtDataSize.Text := Progress.DataSizeText;
  edtDataRate.Text := Progress.DataRateText;
  edtDataSent.Text := Progress.DataSentText;
  edtBlockSent.Text := Progress.BlockSentText;
  edtBlockCount.Text := Progress.BlockCountText;
end;

procedure TfmProgress.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmProgress.TimerTimer(Sender: TObject);
begin
  try
    UpdatePage;
  except
    on E: Exception do
    begin
      Timer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TfmProgress.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
resourcestring
  SCancelConfirmation = 'Operation is in progress. Cancel operation?';
begin
  if WorkThread.Started then
  begin
    Progress.Lock;
    try
      CanClose := MessageBox(Handle, PChar(SCancelConfirmation),
        PChar(Application.Title), MB_YESNO or MB_ICONEXCLAMATION) = ID_YES;
    finally
      Progress.Unlock;
    end;
  end;
end;

procedure TfmProgress.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Progress.Stop;
end;

end.
