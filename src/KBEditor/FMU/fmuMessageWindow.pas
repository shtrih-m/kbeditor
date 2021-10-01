unit fmuMessageWindow;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, ImgList, Menus,
  // Toolbar 2000
  TB2Item,
  // This
  DockableForm, KeyboardManager, Utils, LogMessage, LogFile, LayoutMessage,
  fmuDoc;

type
  { TMessageWindow }

  TfmMessageWindow = class(TDockableForm)
    lbMessages: TListBox;
    ImageList: TImageList;
    PopUpMenu: TTBPopupMenu;
    miClear: TTBItem;
    miSave: TTBItem;
    SaveDialog: TSaveDialog;
    miViewError: TTBItem;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miClearClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure miViewErrorClick(Sender: TObject);
    procedure lbMessagesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    FMessageIndex: Integer;
    FMessages: TLayoutMessages;

    procedure SelectMessage(Sender: TObject);
    procedure LogMessage(Sender: TObject; const S: string; LayoutID, ItemID: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear;
    procedure LoggerMessage(Sender: TObject; const Message: string);
  end;

var
  fmMessageWindow: TfmMessageWindow;

implementation

{$R *.DFM}

{ TfmMessageWindow }

constructor TfmMessageWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMessages := TLayoutMessages.Create;
  lbMessages.OnDblClick :=  SelectMessage;
  LogMessages.OnLogMessage := LogMessage;
  Logger.OnMessage := LoggerMessage;
end;

destructor TfmMessageWindow.Destroy;
begin
  Logger.OnMessage := nil;
  LogMessages.OnLogMessage := nil;
  FMessages.Free;
  inherited Destroy;
end;

procedure TfmMessageWindow.Clear;
begin
  FMessages.Lock;
  try
    FMessages.Clear;
    FMessageIndex := 0;
  finally
    FMessages.Unlock;
  end;
  lbMessages.Clear;
end;

procedure TfmMessageWindow.LoggerMessage(Sender: TObject;
  const Message: string);
begin
  FMessages.Lock;
  try
    FMessages.Add(0, 0, Message);
  finally
    FMessages.Unlock;
  end;
end;

procedure TfmMessageWindow.LogMessage(Sender: TObject; const S: string;
  LayoutID, ItemID: Integer);
begin
  FMessages.Lock;
  try
    FMessages.Add(LayoutID, ItemID, S);
  finally
    FMessages.Unlock;
  end;
end;

procedure TfmMessageWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DoFormClose(Sender, Action);
end;

procedure TfmMessageWindow.miClearClick(Sender: TObject);
begin
  Clear;
end;

procedure TfmMessageWindow.miSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    lbMessages.Items.SaveToFile(SaveDialog.FileName);
end;

procedure TfmMessageWindow.miViewErrorClick(Sender: TObject);
begin
  SelectMessage(Self);
end;

procedure TfmMessageWindow.SelectMessage(Sender: TObject);
var
  i: Integer;
  Doc: TfmDoc;
  Item: TLayoutMessage;
begin
  if FMessages.ValidIndex(lbMessages.ItemIndex) then
  begin
    Item := FMessages[lbMessages.ItemIndex];
    for i := 0 to Application.MainForm.MDIChildCount - 1 do
    begin
      if Application.MainForm.MDIChildren[i] is TfmDoc then
      begin
        Doc := Application.MainForm.MDIChildren[i] as TfmDoc;
        if Doc.Layout.ID = Item.LayoutID then
        begin
          Doc.Layout.SelectItem(Item.ItemID);
          Doc.Show;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfmMessageWindow.lbMessagesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then SelectMessage(Sender);
end;

procedure TfmMessageWindow.Timer1Timer(Sender: TObject);
const
  MaxCount = 1000;
begin
  FMessages.Lock;
  lbMessages.Items.BeginUpdate;
  try
    if FMessages.ValidIndex(FMessageIndex) then
    begin
      while FMessages.ValidIndex(FMessageIndex) do
      begin
        lbMessages.Items.Add(FMessages[FMessageIndex].Text);
        Inc(FMessageIndex);
      end;
      while lbMessages.Items.Count > MaxCount do
      begin
        lbMessages.Items.Delete(0);
      end;
      while FMessages.Count > MaxCount do
      begin
        FMessages.Delete(0);
      end;
      FMessageIndex := FMessages.Count;
      lbMessages.ItemIndex := lbMessages.Items.Count-1;
    end;
  finally
    FMessages.Unlock;
    lbMessages.Items.EndUpdate;
  end;
end;

end.
