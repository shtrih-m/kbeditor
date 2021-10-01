unit fmuKeysTest;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard, Utils, KBLayout, fmuKeyView, Keyboard, KeyboardManager,
  KeyboardDriver, KeyboardTypes;

type
  { TfmKeysTest }

  TfmKeysTest = class(TWizardPage)
    Label1: TLabel;
    lblKeyCount_: TLabel;
    lblKeyCount: TLabel;
    lblResult: TLabel;
    ShapeResult: TShape;
    btnShowLayout: TButton;
    btnReset: TButton;
    procedure btnShowLayoutClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
  private
    FScanCodes: TScanCodes;

    procedure Reset;
    procedure UpdatePage;
    function GetPressKeyCount: Integer;
    procedure KeyPressed(AScanCodes: TScanCodes);
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  public
    constructor Create(AOwner: TComponent); override;

    procedure Stop; override;
    procedure Start; override;
  end;

implementation

{$R *.DFM}

{ TfmKeysTest }

constructor TfmKeysTest.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScanCodes := TScanCodes.Create(Self);
end;

procedure TfmKeysTest.UpdatePage;
begin
  fmKeyView.Grid.Refresh;
  lblKeyCount.Caption := IntToStr(GetPressKeyCount);
  if GetPressKeyCount = Wizard.Layout.Keyboard.KeyDefs.Count then
  begin
    lblResult.Caption := 'Шаг пройден!';
    ShapeResult.Brush.Color := clLime;
  end else
  begin
    lblResult.Caption := 'Шаг не пройден';
    ShapeResult.Brush.Color := clSilver;
  end;
end;

procedure TfmKeysTest.btnShowLayoutClick(Sender: TObject);
begin
  ShowKeyView;
  UpdatePage;
end;

procedure TfmKeysTest.btnResetClick(Sender: TObject);
begin
  Reset;
  UpdatePage;
end;

procedure TfmKeysTest.Reset;
begin
  Wizard.Layout.ResetKeys;
  UpdatePage;
end;

function TfmKeysTest.GetPressKeyCount: Integer;
var
  i: Integer;
  Keys: TKeys;
begin
  Result := 0;
  if Wizard.Layout.Layers.Count = 0 then Exit;

  Keys := Wizard.Layout.Layers[0].Keys;
  for i := 0 to Keys.Count-1 do
    if Keys[i].Pressed then Inc(Result);
end;

procedure TfmKeysTest.KeyPressed(AScanCodes: TScanCodes);
var
  i: Integer;
  Keys: TKeys;
  ScanCodes: TScanCodes;
begin
  if Wizard.Layout.Layers.Count = 0 then Exit;

  Keys := Wizard.Layout.Layers[0].Keys;
  for i := 0 to Keys.Count - 1 do
  begin
    ScanCodes := Keys[i].PressCodes;
    if StrComp(PChar(ScanCodes.AsText), PChar(AScanCodes.AsText)) = 0  then
    begin
      Keys[i].Pressed := True;
      Break;
    end;
  end;
end;

procedure TfmKeysTest.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  ScanCode, SC: TScanCode;
begin
  try
    ScanCode := Manager.CodeTable.FromMessage(Msg, [koMake, koBreak]);


    if ScanCode <> nil then
    begin
      SC := FScanCodes.Add;
      try
        SC.Assign(ScanCode);
      except
        FScanCodes.Clear;
        Handled := False;
        Exit;
      end;
      if StrComp(PChar(SC.DisplayText), PChar('-]')) = 0 then
      begin
        KeyPressed(FScanCodes);
        FScanCodes.Clear;
        UpdatePage;
      end;
    end;
  finally
    Handled := False;
  end;
end;

procedure TfmKeysTest.Start;
begin
  Reset;
  Manager.Driver.SetMode(amProg, dmData);
  Application.OnMessage := AppMessage;
end;

procedure TfmKeysTest.Stop;
begin
  Application.OnMessage := nil;
  Wizard.GoNext;
end;

end.
