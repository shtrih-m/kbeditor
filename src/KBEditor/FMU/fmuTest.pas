unit fmuTest;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ImgList, ComCtrls, ToolWin, Clipbrd, Menus,
  // This
  KBLayout, Utils, SizeableForm, KeyboardManager;

type
  { TfmTest }

  TfmTest = class(TSizeableForm)
    ImageList: TImageList;
    PageControl: TPageControl;
    tsCodes: TTabSheet;
    tsText: TTabSheet;
    MemoText: TMemo;
    pmMemoText: TPopupMenu;
    miTextCopy: TMenuItem;
    miTextClear: TMenuItem;
    miTextSelectAll: TMenuItem;
    miTextCut: TMenuItem;
    miTextPaste: TMenuItem;
    MemoCodes: TMemo;
    pmMemoCodes: TPopupMenu;
    miCodesCut: TMenuItem;
    miCodesCopy: TMenuItem;
    miCodesPaste: TMenuItem;
    miCodesClear: TMenuItem;
    miCodesSelectAll: TMenuItem;
    procedure miTextSelectAllClick(Sender: TObject);
    procedure miTextClearClick(Sender: TObject);
    procedure miTextPasteClick(Sender: TObject);
    procedure miTextCopyClick(Sender: TObject);
    procedure miTextCutClick(Sender: TObject);
    procedure pmMemoTextPopup(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure miCodesCutClick(Sender: TObject);
    procedure miCodesCopyClick(Sender: TObject);
    procedure miCodesPasteClick(Sender: TObject);
    procedure miCodesSelectAllClick(Sender: TObject);
    procedure pmMemoCodesPopup(Sender: TObject);
    procedure miCodesClearClick(Sender: TObject);
    procedure tsTextShow(Sender: TObject);
  private
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  end;

var
  fmTest: TfmTest;

implementation

{$R *.DFM}

{ TfmTest }

procedure TfmTest.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  ScanCode: TScanCode;
  ScanCodeText: string;
begin
  Handled := False;
  if PageControl.ActivePageIndex = 0 then
  begin
    ScanCode := Manager.CodeTable.FromMessage(Msg, [koMake, koBreak, koRepeat]);
    if ScanCode <> nil then
    begin
      ScanCodeText := Format('%s (%s)', [ScanCode.DisplayText,
          StrToHex(ScanCode.ScanCode)]);
      MemoCodes.Lines.Add(ScanCodeText);
      Handled := True;
    end;
  end;
end;

procedure TfmTest.miTextSelectAllClick(Sender: TObject);
begin
  MemoText.SelectAll;
end;

procedure TfmTest.miTextClearClick(Sender: TObject);
begin
  MemoText.Clear;
end;

procedure TfmTest.miTextPasteClick(Sender: TObject);
begin
  MemoText.PasteFromClipboard;
end;

procedure TfmTest.miTextCopyClick(Sender: TObject);
begin
  MemoText.CopyToClipboard;
end;

procedure TfmTest.miTextCutClick(Sender: TObject);
begin
  MemoText.CutToClipboard;
end;

procedure TfmTest.pmMemoTextPopup(Sender: TObject);
var
  HasSelection: Boolean;
begin
  HasSelection := MemoText.SelText <> '';
  miTextCut.Enabled := HasSelection;
  miTextCopy.Enabled := HasSelection;
  miTextPaste.Enabled := Clipboard.HasFormat(CF_TEXT);
end;

procedure TfmTest.pmMemoCodesPopup(Sender: TObject);
var
  HasSelection: Boolean;
begin
  HasSelection := MemoCodes.SelText <> '';
  miCodesCut.Enabled := HasSelection;
  miCodesCopy.Enabled := HasSelection;
  miCodesPaste.Enabled := Clipboard.HasFormat(CF_TEXT);
end;

procedure TfmTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfmTest.FormActivate(Sender: TObject);
begin
  Application.OnMessage := AppMessage;
end;

procedure TfmTest.FormDeactivate(Sender: TObject);
begin
  Application.OnMessage := nil;
end;

procedure TfmTest.miCodesCutClick(Sender: TObject);
begin
  MemoCodes.CutToClipboard;
end;

procedure TfmTest.miCodesCopyClick(Sender: TObject);
begin
  MemoCodes.CopyToClipboard;
end;

procedure TfmTest.miCodesPasteClick(Sender: TObject);
begin
  MemoCodes.PasteFromClipboard;
end;

procedure TfmTest.miCodesSelectAllClick(Sender: TObject);
begin
  MemoCodes.SelectAll;
end;

procedure TfmTest.miCodesClearClick(Sender: TObject);
begin
  MemoCodes.Clear;
end;

procedure TfmTest.tsTextShow(Sender: TObject);
begin
  MemoText.SetFocus;
end;

end.
