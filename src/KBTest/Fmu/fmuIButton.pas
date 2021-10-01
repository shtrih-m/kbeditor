unit fmuIButton;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, Windows, Forms, Graphics, ExtCtrls, Messages,
  SysUtils,
  // This
  WizardPage, TestWizard;

type
  { TfmIButton }

  TfmIButton = class(TWizardPage)
    Label1: TLabel;
    lblResult: TLabel;
    ShapeResult: TShape;
    Memo: TMemo;
  public
    procedure Stop; override;
    procedure Start; override;
  private
    FData: string;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  end;

implementation

{$R *.DFM}

{ TfmIButton }

procedure TfmIButton.Stop;
begin
  FData := '';
  Application.OnMessage := nil;
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
  Wizard.GoNext;
end;

procedure TfmIButton.Start;
begin
  Memo.Clear;
  Memo.SetFocus;
  FData := '';
  Application.OnMessage := AppMessage;
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
end;

procedure TfmIButton.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = WM_CHAR then
  begin
    FData := FData + Chr(Msg.wParam);
    if Pos(IBUTTON_SUFFIX, FData) <> 0 then
    begin
      Memo.Clear;
      Memo.Lines.Add('Данные: ' + FData);

      FData := '';
      lblResult.Caption := 'Тест успешно пройден.';
      ShapeResult.Brush.Color := clLime;
      ShapeResult.Visible := True;
    end;
  end;
end;

end.


