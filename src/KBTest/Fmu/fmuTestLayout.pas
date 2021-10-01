unit fmuTestLayout;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard, Keyboard, KeyboardManager, KBLayout, uProgress,
  WriteLayoutOperation, OperationThread, OperationInterface;

type
  { TfmTestLayout }

  TfmTestLayout = class(TWizardPage)
    lblPercents: TLabel;
    lblInfo2: TLabel;
    lblProgress: TLabel;
    ProgressBar: TProgressBar;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FLayoutUpdated: Boolean;

    procedure UpdatePage;
    procedure WriteTestLayout;
    procedure CreateTestLayout(Layout: TKBLayout);
    procedure OperationCompleted(Sender: TObject; Operation: IOperation);
  public
    procedure Stop; override;
    procedure Start; override;
    procedure Cancel; override;
  end;

implementation

{$R *.DFM}

{ TfmTestLayout }

procedure TfmTestLayout.Start;
begin
  Progress.Clear;
  UpdatePage;
  FLayoutUpdated := False;
end;

procedure TfmTestLayout.Stop;
begin
  if FLayoutUpdated then
  begin
    Wizard.GoNext;
  end else
  begin
    WriteTestLayout;
  end;
end;

procedure TfmTestLayout.UpdatePage;
begin
  Progress.Lock;
  try
    ProgressBar.Max := Progress.BlockCount;
    ProgressBar.Position := Progress.BlockSent;
    lblPercents.Caption := Progress.ProgressText;
  finally
    Progress.Unlock;
  end;
end;

procedure TfmTestLayout.OperationCompleted(Sender: TObject; Operation: IOperation);
begin
  EnableButtons(True);
  if WorkThread.Failed then
  begin
    MessageBox(Handle, PChar(WorkThread.ErrorMessage), PCHar(Application.Title), MB_ICONERROR);
  end else
  begin
    FLayoutUpdated := True;
    Wizard.EnablePrev(True);
    Wizard.EnableNext(True);
    Wizard.GoNext;
  end;
end;

procedure TfmTestLayout.TimerTimer(Sender: TObject);
begin
  UpdatePage;
end;


{******************************************************************************

 Создание тестовой раскладки

 - Текст задается в виде [123], где 123 - физический номер клавиши
 - Включаются все треки считывателя
 - Задаются данные для ключа

{******************************************************************************}

procedure TfmTestLayout.CreateTestLayout(Layout: TKBLayout);
var
  Key: TKey;
  MSR: TMSR;
  Keys: TKeys;
  i, j, k: Integer;
  str, KeyText: string;
  KeyLock: TKeyLock;
  Position: TKeyposition;
  ScrollWheel: TScrollWheel;
  IButton: TIButton;
begin
  Layout.KeyGroups.Clear;

  if Layout.Layers.Count = 0 then
    raise Exception.Create('В раскладке нет слоев!');

  i := 0;
  // Клавиши
  Keys := Layout.Layers[i].Keys;
  for j := 0 to Keys.Count - 1 do
  begin
    Key := Keys[j];
    Key.KeyType := ktMacros;
    str := IntToStr(j);
    KeyText := '';
    for k := 1 to Length(str) do
    begin
      KeyText := KeyText + '+' + str[k] + ' ';
      KeyText := KeyText + '-' + str[k] + ' ';
    end;
    Key.PressCodes.AsText := '+[ -[ ' + KeyText + '+] -]';
  end;
  // Ключ
  KeyLock := Layout.Layers[i].KeyLock;
  for j := 0 to KeyLock.Count-1 do
  begin
    Position := KeyLock[j];
    Position.Codes.DisplayText := '=' + IntToStr(j+1);
  end;
  // Считыватель карт
  MSR := Layout.Layers[i].MSR;

  MSR.LockOnErr := False;
  MSR.SendEnter := False;
  MSR.LightIndication := True;
  MSR.Tracks[0].Enabled := True;
  MSR.Tracks[1].Enabled := True;
  MSR.Tracks[2].Enabled := True;

  MSR.Tracks[0].Prefix.DisplayText := '';
  MSR.Tracks[1].Prefix.DisplayText := '';
  MSR.Tracks[2].Prefix.DisplayText := '';

  MSR.Tracks[0].Suffix.DisplayText := MSR_SUFFIX;
  MSR.Tracks[1].Suffix.DisplayText := MSR_SUFFIX;
  MSR.Tracks[2].Suffix.DisplayText := MSR_SUFFIX;
  // ScrollWheel
  ScrollWheel := Layout.Layers[i].ScrollWheel;
  ScrollWheel.ScrollUp.Codes.SimpleText := '[ScrollUp]';
  ScrollWheel.ScrollDown.Codes.SimpleText := '[ScrollDown]';
  ScrollWheel.SingleClick.Codes.SimpleText := '[SingleClick]';
  ScrollWheel.DoubleClick.Codes.SimpleText := '[DoubleClick]';
  // IButton
  IButton := Layout.Layers[i].IButton;
  IButton.SendCode := True;
  IButton.Suffix.DisplayText := IBUTTON_SUFFIX;
end;

procedure TfmTestLayout.Cancel;
begin
  Progress.Stop;
end;

procedure TfmTestLayout.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Progress.Stop;
end;

procedure TfmTestLayout.WriteTestLayout;
var
  Operation: IOperation;
begin
  Wizard.EnableNext(False);
  Wizard.EnablePrev(False);

  CreateTestLayout(Wizard.Layout);
  Operation := TWriteLayoutOperation.Create(Wizard.Layout);

  Progress.Clear;
  WorkThread.OnCompleted := OperationCompleted;
  WorkThread.Start(Operation);
  EnableButtons(False);
end;

end.
