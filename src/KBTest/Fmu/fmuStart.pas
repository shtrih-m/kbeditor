unit fmuStart;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  // Rx
  jpeg,
  // This
  WizardPage, TestWizard;

type
  { TfmIntro }

  TfmStart = class(TWizardPage)
    Label2: TLabel;
    Label1: TLabel;
    Image1: TImage;
  public
    procedure Stop; override;
  end;

implementation

{$R *.DFM}

{ TfmStart }

procedure TfmStart.Stop;
begin
  Wizard.GoNext;
end;

end.
