unit fmuMain;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  // Rx
  jpeg,
  // This
  WizardPage, untVInfo, KeyboardManager, fmuStart, fmuDevice, fmuModel,
  fmuFirmware, fmuTestLayout, fmuKeysTest, fmuShorting, fmuLeds, fmuMSR,
  fmuLayout, fmuEnd, fmuKeyLock, fmuScrollWheel, fmuIButton, KBLayout,
  fmuSound, SizeableForm, TestWizard, uProgress, KeyboardDriver,
  OperationThread, KeyboardTypes;

type
  { TfmMain }

  TfmMain = class(TSizeableForm)
    btnClose: TButton;
    Bevel: TBevel;
    btnNext: TButton;
    pnlPage: TPanel;
    btnPrev: TButton;
    Panel1: TPanel;
    lblPage: TLabel;
    lblAction: TLabel;
    Bevel1: TBevel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FPageIndex: Integer;
    FPages: TWizardPages;

    procedure CreatePages;
    function CanGoPrev: Boolean;
    function GetPage: TWizardPage;
    function GetNextPageIndex: Integer;
    function GetPrevPageIndex: Integer;
    procedure ShowPage(APageIndex: Integer);
    procedure AddPage(PageClass: TWizardPageClass);
    function ValidPageIndex(Value: Integer): Boolean;

    property Page: TWizardPage read GetPage;
    property Pages: TWizardPages read FPages;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GoNext;
    procedure GoPrev;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

procedure SetButtonFocus(Button: TButton);
begin
  if Button.CanFocus then Button.SetFocus;
end;

{ TfmMain }

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TWizardPages.Create;
  CreatePages;
  ShowPage(0);
end;

destructor TfmMain.Destroy;
begin
  FPages.Free;
  inherited Destroy;
end;

function TfmMain.GetPage: TWizardPage;
begin
  Result := Pages[FPageIndex];
end;

function TfmMain.GetPrevPageIndex: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := FPageIndex-1 downto 0 do
  begin
    if Pages[i].IsValid then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TfmMain.GetNextPageIndex: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := FPageIndex+1 to Pages.Count-1 do
  begin
    if Pages[i].IsValid then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TfmMain.AddPage(PageClass: TWizardPageClass);
var
  Page: TWizardPage;
begin
  Page := PageClass.Create(Application);
  Page.SetOwner(FPages);
  Page.BorderStyle := bsNone;
  Page.Parent := pnlPage;
  Page.Width := pnlPage.ClientHeight;
  Page.Height := pnlPage.ClientHeight;
end;

procedure TfmMain.CreatePages;
begin
  FPageIndex := -1;
  AddPage(TfmStart);            // Начало
  AddPage(TfmDevice);           // Выбор типа устройства
  AddPage(TfmModel);            // Выбор модели
  AddPage(TfmFirmware);         // Обновление ПО
  AddPage(TfmSound);            // Check sound
  AddPage(TfmTestLayout);       // Тестовая раскладка
  AddPage(TfmKeysTest);         // Проверка клавиш
  AddPage(TfmShorting);         // Тест замыкания
  AddPage(TfmLeds);             // Тест индикаторов
  AddPage(TfmMSR);              // Тест считывателя карт
  AddPage(TfmKeyLock);          // Тест ключа
  AddPage(TfmScrollWheel);      // Тест ключа
  AddPage(TfmIButton);          // Тест считывателя iButton
  AddPage(TfmLayout);           // Рабочая раскладка
  AddPage(TfmEnd);              // Конец
end;

procedure TfmMain.btnNextClick(Sender: TObject);
begin
  Page.Stop;
end;

procedure TfmMain.GoPrev;
begin
  ShowPage(GetPrevPageIndex);
  btnNext.Enabled := True;
  btnPrev.Enabled := CanGoPrev;
  Page.Start;
end;

procedure TfmMain.GoNext;
begin
  ShowPage(GetNextPageIndex);
  btnNext.Enabled := True;
  btnPrev.Enabled := CanGoPrev;
  Page.Start;
end;

procedure TfmMain.btnPrevClick(Sender: TObject);
begin
  GoPrev;
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Msg: string;
begin
  CanClose := True;
  if Progress.Started then
  begin
    CanClose := False;
    Msg := 'Выполняется запись, выход невозможен.';
    MessageBox(Handle, PChar(Msg), PChar(Application.Title),
      MB_ICONEXCLAMATION);
  end else
  begin
    if (FPageIndex > 0)and(FPageIndex < Pages.Count-1)
    then
    begin
      Msg := 'Тест клавиатуры не завершен.'#13#10'Выйти из программы ?';
      Progress.Lock;
      try
        CanClose := MessageBox(Handle, PChar(Msg), PChar(Application.Title),
          MB_YESNO or MB_ICONEXCLAMATION) = ID_YES;
      finally
        Progress.Unlock;
      end;
      if CanClose then Page.Cancel;
    end;
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Caption := Caption + ' ' + GetFileVersionInfoStr;
end;

function TfmMain.ValidPageIndex(Value: Integer): Boolean;
begin
  Result := (Value >= 0)and(Value < Pages.Count);
end;

procedure TfmMain.ShowPage(APageIndex: Integer);
var
  Page: TWizardPage;
begin
  if APageIndex <> FPageIndex then
  begin
    if ValidPageIndex(APageIndex) then
    begin
      Page := Pages[APageIndex];
      Page.Visible := True;
      Page.Align := alClient;
      Page.Width := Page.Parent.ClientWidth;
      lblPage.Caption := Page.Caption;
      lblAction.Caption := Page.ActionText;
      Update;
    end;
    if ValidPageIndex(FPageIndex) then
    begin
      Pages[FPageIndex].Hide;
    end;
    FPageIndex := APageIndex;
  end;
end;

function TfmMain.CanGoPrev: Boolean;
begin
  Result := FPageIndex > 0;
end;

procedure TfmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    Manager.Driver.SetMode(amProg, dmData);
  except

  end;
end;

end.
