unit fmuEnd;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard;

type
  TfmEnd = class(TWizardPage)
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
  public
    procedure Stop; override;
  end;

implementation

{$R *.DFM}

{ TfmEnd }

procedure TfmEnd.Stop;
begin
  Wizard.GoNext;
  Wizard.EnablePrev(False);
  Wizard.EnableNext(True);
end;

end.
