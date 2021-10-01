unit fmuSound;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard, KeyboardDriver, KeyboardManager, KBLayout, Utils;

type
  { TfmMSR }

  TfmSound = class(TWizardPage)
    Label1: TLabel;
    Timer: TTimer;
    lblInfo: TLabel;
    imgExclamation: TImage;
    procedure TimerTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
  public
    procedure Stop; override;
    procedure Start; override;
    procedure Cancel; override;
  end;

implementation

{$R *.DFM}

{ TfmMSR }

procedure TfmSound.Stop;
begin
  Timer.Enabled := False;
  Wizard.GoNext;
end;

procedure TfmSound.Start;
begin
  Timer.Enabled := True;
end;

procedure TfmSound.Cancel;
begin
end;

procedure TfmSound.TimerTimer(Sender: TObject);
const
  TestSound = 'G1;4;1;Dis1;4;1;G2;4;1;Ais2;4;1;D3;4;1;Dis3;4;1;Gis3;4;1;C4;4;1;Dis4;4;1;Gis4;4;1';
begin
  try
    lblInfo.Visible := False;
    imgExclamation.Visible := False;

    Manager.PlayText(TestSound);
  except
    on E: Exception do
    begin
      lblInfo.Visible := True;
      imgExclamation.Visible := True;
      lblInfo.Caption := '!!! Ошибка: ' + e.Message;
    end;
  end;
end;

procedure TfmSound.FormHide(Sender: TObject);
begin
  Timer.Enabled := False;
end;

end.


