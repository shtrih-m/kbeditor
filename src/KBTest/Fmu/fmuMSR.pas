unit fmuMSR;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard, KeyboardDriver, KeyboardManager, KBLayout, Utils,
  KeyboardTypes;

type
  { TfmMSR }

  TfmMSR = class(TWizardPage)
    Memo: TMemo;
    btnClear: TButton;
    Label1: TLabel;
    lblResult: TLabel;
    ShapeResult: TShape;
    procedure btnClearClick(Sender: TObject);
  private
    FData: string;
    FDataTickCount: DWORD;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  public
    procedure Stop; override;
    procedure Start; override;
    function IsValid: Boolean; override;
  end;

implementation

{$R *.DFM}

{ TfmMSR }

procedure TfmMSR.Stop;
begin
  FData := '';
  Application.OnMessage := nil;
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
  Wizard.GoNext;
end;

procedure TfmMSR.Start;
begin
  FData := '';
  Memo.Clear;
  Memo.SetFocus;
  Manager.Driver.SetMode(amProg, dmData);
  Application.OnMessage := AppMessage;
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
  LoadKeyboardLayout('00000409', KLF_ACTIVATE);
end;

procedure TfmMSR.btnClearClick(Sender: TObject);
begin
  Memo.Clear;
  FData := '';
end;

procedure TfmMSR.AppMessage(var Msg: TMsg; var Handled: Boolean);
const
  DataExirationTimeout = 3000;  // 3 секунды
begin
  if Msg.message = WM_CHAR then
  begin
    if (GetTickCount - FDataTickCount) > DataExirationTimeout then
    begin
      FData := '';
      FDataTickCount := GetTickCount;
    end;

    FData := FData + Chr(Msg.wParam);
    if Pos(MSR_SUFFIX, FData) <> 0 then
    begin
      Memo.Clear;
      Memo.Lines.Add('Данные: ' + FData);

      lblResult.Caption := 'Тест успешно пройден.';
      ShapeResult.Brush.Color := clLime;
      ShapeResult.Visible := True;
    end;
    Handled := True;
  end;
end;

function TfmMSR.IsValid: Boolean;
begin
  Result := Wizard.Layout.Keyboard.HasMSR;
end;

end.


