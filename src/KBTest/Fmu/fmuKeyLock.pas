unit fmuKeyLock;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, Windows, Forms, Graphics, ExtCtrls, Messages,
  SysUtils,
  // This
  WizardPage, TestWizard, KBLayout, KeyboardDriver, KeyboardManager,
  KeyboardTypes;

type
  { TfmKeyLock }

  TfmKeyLock = class(TWizardPage)
    Memo: TMemo;
    Label1: TLabel;
    lblResult: TLabel;
    ShapeResult: TShape;
    procedure btnClearClick(Sender: TObject);
  public
    procedure Stop; override;
    procedure Start; override;
  private
    FKeyData: string;
    function DecodeData: Boolean;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  end;

implementation

{$R *.DFM}

{ TfmKeyLock }

procedure TfmKeyLock.Start;
begin
  Memo.Clear;
  Memo.SetFocus;
  FKeyData := '';
  Manager.Driver.SetMode(amProg, dmData);
  Application.OnMessage := AppMessage;
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
end;

procedure TfmKeyLock.Stop;
begin
  FKeyData := '';
  Application.OnMessage := nil;
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
  Wizard.GoNext;
end;

procedure TfmKeyLock.btnClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

procedure TfmKeyLock.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = WM_CHAR then
  begin
    FKeyData := FKeyData + Chr(Msg.wParam);
    if DecodeData then
    begin
      lblResult.Caption := 'Тест успешно пройден.';
      ShapeResult.Brush.Color := clLime;
    end;
    ShapeResult.Visible := True;
  end;
end;

function TfmKeyLock.DecodeData: Boolean;
var
  i: Integer;
  j: Integer;
  KeyLock: TKeyLock;
  Codes: TScanCodes;
begin
  Result := False;
  if Wizard.Layout.Layers.Count = 0 then
    raise Exception.Create('В раскладке нет слоев!');
  i := 0;
  KeyLock := Wizard.Layout.Layers[i].KeyLock;
  for j := 0 to KeyLock.Count-1 do
  begin
    Codes := KeyLock[j].Codes;
    Result := Pos(Codes.DisplayText, FKeyData) <> 0;
    if not Result then Break;
  end;
end;

end.
