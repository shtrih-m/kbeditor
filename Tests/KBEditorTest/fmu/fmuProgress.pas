unit fmuProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TfmProgress = class(TForm)
    ProgressBar: TProgressBar;
    Button1: TButton;
    Button2: TButton;
    StepTimer: TTimer;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FProgress: TSmoothProgress;
  end;

var
  fmProgress: TfmProgress;

implementation

{$R *.DFM}

procedure TfmProgress.TimerTimer(Sender: TObject);
begin
  ProgressBar.Position := FProgress.Position;
end;

procedure TfmProgress.FormCreate(Sender: TObject);
begin
  FProgress := TSmoothProgress.Create();
end;

end.
