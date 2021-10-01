unit fmuScrollWheel;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, Windows, Forms, Graphics, ExtCtrls, Messages,
  SysUtils,
  // This
  WizardPage, TestWizard, KBLayout, KeyboardDriver, KeyboardManager,
  KeyboardTypes;

type
  { TfmScrollWheel }

  TfmScrollWheel = class(TWizardPage)
    lblResult: TLabel;
    ShapeResult: TShape;
    lblScrollUp: TLabel;
    spScrollUp: TShape;
    Label2: TLabel;
    spScrollDown: TShape;
    lblSingleClick: TLabel;
    spSingleClick: TShape;
    lblDoubleClick: TLabel;
    spDoubleClick: TShape;
    Bevel1: TBevel;
  private
    FData: string;
    FScrollUpPassed: Boolean;
    FScrollDownPassed: Boolean;
    FSingleClickPassed: Boolean;
    FDoubleClickPassed: Boolean;

    procedure UpdatePage;
    function TestData(const Text: string): Boolean;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  public
    procedure Stop; override;
    procedure Start; override;
  end;

implementation

{$R *.DFM}

const
  ShapeColors: array [Boolean] of TColor = (clSilver, clLime);

{ TfmKeyLock }

procedure TfmScrollWheel.UpdatePage;
begin
  spScrollUp.Brush.Color := ShapeColors[FScrollUpPassed];
  spScrollDown.Brush.Color := ShapeColors[FScrollDownPassed];
  spSingleClick.Brush.Color := ShapeColors[FSingleClickPassed];
  spDoubleClick.Brush.Color := ShapeColors[FDoubleClickPassed];
end;

procedure TfmScrollWheel.Start;
begin
  FData := '';
  FScrollUpPassed := False;
  FScrollDownPassed := False;
  FSingleClickPassed := False;
  FDoubleClickPassed := False;
  Manager.Driver.SetMode(amProg, dmData);
  Application.OnMessage := AppMessage;
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
  UpdatePage;
end;

procedure TfmScrollWheel.Stop;
begin
  FData := '';
  Application.OnMessage := nil;
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
  Wizard.GoNext;
end;

procedure TfmScrollWheel.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  ScrollWheel: TScrollWheel;
begin
  if Msg.message = WM_CHAR then
  begin
    FData := FData + Chr(Msg.wParam);

    ScrollWheel := Wizard.Layout.GetLayer.ScrollWheel;
    FScrollUpPassed := TestData(ScrollWheel.ScrollUp.Codes.SimpleText);
    FScrollDownPassed := TestData(ScrollWheel.ScrollDown.Codes.SimpleText);
    FSingleClickPassed := TestData(ScrollWheel.SingleClick.Codes.SimpleText);
    FDoubleClickPassed := TestData(ScrollWheel.DoubleClick.Codes.SimpleText);
    UpdatePage;
    if (FScrollUpPassed and FScrollDownPassed and FSingleClickPassed and
      FDoubleClickPassed) then
    begin
      lblResult.Caption := 'Тест успешно пройден.';
      ShapeResult.Brush.Color := clLime;
    end;
    ShapeResult.Visible := True;
  end;
end;

function TfmScrollWheel.TestData(const Text: string): Boolean;
begin
  Result := Pos(UpperCase(Text), UpperCase(FData)) <> 0;
end;

end.
