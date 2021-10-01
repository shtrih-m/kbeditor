unit fmuLeds;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard, KeyboardDriver, KeyboardManager, KBLayout, Utils,
  KeyboardController, KeyboardTypes;

type
  { TfmLeds }

  TfmLeds = class(TWizardPage)
    Label1: TLabel;
  public
    procedure Stop; override;
    procedure Start; override;
    function IsValid: Boolean; override;
  end;

implementation

{$R *.DFM}

{ TfmLeds }

function TfmLeds.IsValid: Boolean;
begin
  Result := Wizard.Layout.Keyboard.HasLeds;
end;

///////////////////////////////////////////////////////////////////////////////
// 1. Set loader mode to turn all layer leds ON.
// 2. Set standard keyboard indicators (Num Lock, Caps Lock and Scroll Lock) ON

procedure TfmLeds.Start;
begin
  Manager.Driver.SetMode(amLoader, dmData);
  Manager.Driver.SetIndicators(0);
  Manager.Driver.SetIndicators(KEYBOARD_ALL);
end;

procedure TfmLeds.Stop;
begin
  Manager.Driver.SetIndicators(0);
  Manager.Driver.SetMode(amProg, dmData);
  Wizard.GoNext;
end;

end.


