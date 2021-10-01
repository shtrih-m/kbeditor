unit fmuDoc;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ImgList, ToolWin, StdCtrls, ExtCtrls, Buttons,
  ClipBrd, Printers, ExtDlgs,
  // Toolbar 2000
  TB2Item, TB2Dock, TB2Toolbar,
  // This
  KBLayout, KeyboardDriver, Utils, Grids2, KeyboardManager, XMLLayout,
  KeyGrid, GridType, SizeableForm, Preview, LogMessage, fmuKey, fmuAbout,
  fmuKeyboard, fmuFind, fmuPicture, fmuMSR, fmuKeyLock,
  fmuReplace, fmuIButton, fmuScrollWheel, KBLayoutPrint,
  AppSettings, XmlParser, DebugUtils;

const
  Col0Width             = 25;   // Column 0 width
  Row0Height            = 25;   // Column 0 height
  DefaultColWidth       = 25;   // Default column width
  DefaultRowHeight      = 25;   // Default column height

  MinColWidth           = 55;
  MinRowHeight          = 55;

type
  { TfmDoc }

  TfmDoc = class(TSizeableForm)
    pmiDelete: TMenuItem;
    pmiCut: TMenuItem;
    pmiCopy: TMenuItem;
    pmiPaste: TMenuItem;
    ImageList: TImageList;
    pmiProps: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    pmiGroup: TMenuItem;
    pmiUngroup: TMenuItem;
    Arrows: TImageList;
    SaveDialog: TSaveDialog;
    N2: TMenuItem;
    pmiLayoutProp: TMenuItem;
    pmiFind: TMenuItem;
    pmKey: TPopupMenu;
    pmPicture: TPopupMenu;
    pmiLoadPicture: TMenuItem;
    pmiSavePicture: TMenuItem;
    pmiClearPicture: TMenuItem;
    N7: TMenuItem;
    pmiFont: TMenuItem;
    pmiBgColor: TMenuItem;
    N10: TMenuItem;
    pmiPictureProps: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    N4: TMenuItem;
    N5: TMenuItem;
    pmiPaste2: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N11: TMenuItem;
    pmiGroup2: TMenuItem;
    N14: TMenuItem;
    pmiReplace: TMenuItem;
    StatusBar: TStatusBar;
    procedure EditKey(Sender: TObject);
    procedure KeyClearClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure CutClick(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pmiGroupClick(Sender: TObject);
    procedure pmiUngroupClick(Sender: TObject);
    procedure pmKeyPopup(Sender: TObject);
    procedure pmiLayoutPropClick(Sender: TObject);
    procedure pmiFindClick(Sender: TObject);
    procedure pmiPicturePropsClick(Sender: TObject);
    procedure pmiLoadPictureClick(Sender: TObject);
    procedure pmiSavePictureClick(Sender: TObject);
    procedure pmiClearPictureClick(Sender: TObject);
    procedure pmiFontClick(Sender: TObject);
    procedure pmiBgColorClick(Sender: TObject);
    procedure pmPicturePopup(Sender: TObject);
    procedure tbKeyClick(Sender: TObject);
    procedure tbMSRClick(Sender: TObject);
    procedure tbKeyLockClick(Sender: TObject);
    procedure tbLayoutKeyboardClick(Sender: TObject);
    procedure pmiReplaceClick(Sender: TObject);
    procedure tbIButtonClick(Sender: TObject);
    procedure tbScrollWheelClick(Sender: TObject);
  private
    Grid: TKeyGrid;
    FLayout: TKBLayout;
    LockResize: Boolean;

    procedure CreateGrid;
    procedure UpdateGrid;
    procedure UpdateGridParams;
    procedure SetLayout(Src: TKBLayout);
    procedure GridClick(Sender: TObject);
    procedure LayoutChanged(Sender: TObject);
    procedure SetGridParams(ColCount, RowCount: Integer);
    procedure SetFormConstraints(ColCount, RowCount: Integer);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Print;
    procedure GroupKeys;
    procedure UpdatePage;
    procedure UngroupKeys;
    procedure ShowKeyProps;
    procedure CutSelection;
    procedure CopySelection;

    function SaveLayout: Boolean;
    function SaveLayoutAs: Boolean;

    property Layout: TKBLayout read FLayout write SetLayout;
  end;

implementation

{$R *.DFM}

resourcestring
  MsgLayout     = 'Layout ';
  MsgModified   = 'Modified';
  MsgSavePrompt = 'Layout [%s] was modified. Save?';
  MsgNoErrors   = 'No errors.';

{ TfmDoc }

constructor TfmDoc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLayout := Manager.CreateLayout;
  FLayout.OnChange := LayoutChanged;
  Grid := TKeyGrid.CreateGrid(Self, Layout);
  Caption := MsgLayout + IntToStr(Application.MainForm.MdiChildCount+1);

  CreateGrid;
  UpdatePage;
end;

destructor TfmDoc.Destroy;
begin
  FLayout.Free;
  inherited Destroy;
end;

procedure TfmDoc.CreateGrid;
begin
  Grid.ScrollBars := ssNone;
  Grid.Parent := Self;
  Grid.Align := alClient;

  Grid.DefaultColWidth := DefaultColWidth;
  Grid.DefaultRowHeight := DefaultRowHeight;
  Grid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
    goRangeSelect, goDrawFocusSelected];

  Grid.OnClick := GridClick;
  Grid.OnDblClick := EditKey;
  Grid.OnKeyDown := GridKeyDown;
  Grid.OnSelectCell := GridSelectCell;
  Grid.ColWidths[0] := Col0Width;
  Grid.RowHeights[0] := Row0Height;
end;

procedure TfmDoc.UpdatePage;
const
  LayoutModified: array [Boolean] of string = ('', MsgModified);
begin
  UpdateGrid;
  if Settings.ViewMode = vmPicture then Grid.PopupMenu := pmPicture
  else Grid.PopupMenu := pmKey;
  // Panels
  StatusBar.Panels[0].Text := FLayout.Keyboard.Text;
  StatusBar.Panels[1].Text := LayoutModified[FLayout.IsModified];
end;

procedure TfmDoc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TfmDoc.SaveLayoutAs: Boolean;
begin
  SaveDialog.Filter := Manager.GetSaveFilter;
  SaveDialog.FileName := Manager.InitialFileName;
  SaveDialog.InitialDir := Manager.InitialDir;
  Result := SaveDialog.Execute;
  if Result then
  begin
    Manager.SaveToFile(Layout, SaveDialog.FilterIndex-1, SaveDialog.FileName);
    Caption := ExtractFileName(SaveDialog.FileName);
  end;
end;

function TfmDoc.SaveLayout: Boolean;
begin
  if Layout.FileName = '' then
  begin
    Result := SaveLayoutAs;
  end else
  begin
    Result := True;
    Manager.SaveToFile(Layout, SaveDialog.FilterIndex-1, Layout.FileName);
  end;
end;

procedure TfmDoc.ShowKeyProps;
begin
  if Settings.ViewMode = vmPicture then
  begin
    fmPicture.UpdatePage;
    fmPicture.Show
  end else
  begin
    fmKeyDlg.UpdatePage;
    fmKeyDlg.Show;
  end;
  Grid.Invalidate;
end;

procedure TfmDoc.UpdateGrid;
begin
  Grid.Selection := Layout.Selection;
  SetGridParams(Layout.ColCount + 1, Layout.RowCount + 1);

  Grid.Refresh;
end;

procedure TfmDoc.UpdateGridParams;
var
  i: Integer;
  RowCount: Integer;
  ColCount: Integer;
  ColWidth: Integer;
  RowHeight: Integer;
  ColWidths: Integer;
  RowHeights: Integer;
begin
  if LockResize then Exit;
  // Column width
  ColCount := Grid.ColCount;
  if ColCount > 1 then
  begin
    ColWidths := Grid.ClientWidth - Grid.GridLineWidth*ColCount - Col0Width;
    ColWidth := ColWidths div (ColCount-1);
    for i := 1 to ColCount-2 do
      Grid.ColWidths[i] := ColWidth;

    Grid.ColWidths[ColCount-1] := ColWidths - (ColCount-2) * ColWidth;
  end;
  // Columns height
  RowCount := Grid.RowCount;
  if RowCount > 1 then
  begin
    RowHeights := Grid.ClientHeight - Grid.GridLineWidth*RowCount - Row0Height;
    RowHeight := RowHeights div (RowCount-1);
    for i := 1 to RowCount-2 do
      Grid.RowHeights[i] := RowHeight;

    Grid.RowHeights[RowCount-1] := RowHeights - (RowCount-2) * RowHeight;
  end;
end;

procedure TfmDoc.SetFormConstraints(ColCount, RowCount: Integer);
var
  FormWidth: Integer;
  FormHeight: Integer;
begin
  FormWidth := MinColWidth*ColCount + Grid.GridLineWidth*(ColCount+3) + Col0Width;
  FormHeight := MinRowHeight*RowCount + Grid.GridLineWidth*(RowCount+3) + Row0Height + 5;

  Constraints.MinWidth := FormWidth;
  Constraints.MinHeight := FormHeight;
  Constraints.MaxWidth := FormWidth;
  Constraints.MaxHeight := FormHeight;
end;

procedure TfmDoc.SetGridParams(ColCount, RowCount: Integer);
var
  i: Integer;
begin
  LockResize := True;
  try
    //
    SetFormConstraints(ColCount, RowCount);

    Grid.ColCount := ColCount;
    Grid.RowCount := RowCount;
    // Column numbers
    for i := 1 to Grid.ColCount-1 do
     Grid.Cells[i, 0] := IntToStr(i);
    // Row numbers
    for i := 1 to Grid.RowCount-1 do
     Grid.Cells[0, i] := IntToStr(i);
  finally
    LockResize := False;
  end;
  UpdateGridParams;
end;

procedure TfmDoc.SetLayout(Src: TKBLayout);
begin
  Layout.Assign(Src);
end;

procedure TfmDoc.LayoutChanged(Sender: TObject);
begin
  UpdatePage;
end;

procedure TfmDoc.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then EditKey(Sender);
  if Key = VK_DELETE then Layout.DeleteSelection;
end;

procedure TfmDoc.EditKey(Sender: TObject);
begin
  ShowKeyProps;
end;

// Event handlers

procedure TfmDoc.KeyClearClick(Sender: TObject);
begin
  Layout.DeleteSelection;
end;

procedure TfmDoc.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmDoc.miSelectAllClick(Sender: TObject);
begin
  Layout.SelectAll;
end;

procedure TfmDoc.CopyClick(Sender: TObject);
begin
  CopySelection;
end;

procedure TfmDoc.CutClick(Sender: TObject);
begin
  CutSelection;
end;

procedure TfmDoc.PasteClick(Sender: TObject);
begin
  Manager.PasteSelection(Layout);
end;

procedure TfmDoc.GroupKeys;
begin
  Layout.GroupKeys;
end;

procedure TfmDoc.UngroupKeys;
begin
  Layout.UngroupKeys;
end;

procedure TfmDoc.FormResize(Sender: TObject);
begin
  UpdateGridParams;
end;

procedure TfmDoc.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  S: string;
  Result: Integer;
begin
  if Layout.IsModified then
  begin
    S := Format(MsgSavePrompt, [Caption]);
    Result := MessageBox(Handle, PChar(S), PChar(MsgAttention),
      MB_ICONQUESTION or MB_YESNOCANCEL or MB_TOPMOST);
    if Result = ID_YES then SaveLayout;
    CanClose := (Result = ID_YES)or(Result = ID_NO);
  end;
end;

procedure TfmDoc.GridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  CanSelect := Layout.CanSelect(ACol, ARow);
end;

procedure TfmDoc.pmiGroupClick(Sender: TObject);
begin
  GroupKeys;
end;

procedure TfmDoc.pmiUngroupClick(Sender: TObject);
begin
  UngroupKeys;
end;

procedure TfmDoc.pmKeyPopup(Sender: TObject);
begin
  pmiPaste.Enabled := Layout.CanPaste;
  pmiGroup.Enabled := Layout.CanGroup;
  pmiUngroup.Enabled := Layout.CanUngroup;
end;

procedure TfmDoc.CopySelection;
begin
  Clipboard.AsText := Manager.LayoutToText(Layout);
end;

procedure TfmDoc.CutSelection;
begin
  CopySelection;
  Layout.DeleteSelection;
end;

procedure TfmDoc.pmiLayoutPropClick(Sender: TObject);
begin
  ShowKeyboardDlg(Layout);
end;

procedure TfmDoc.pmiFindClick(Sender: TObject);
begin
  ShowFindDlg(Layout);
end;

procedure TfmDoc.pmiPicturePropsClick(Sender: TObject);
begin
  ShowKeyProps;
end;

procedure TfmDoc.pmiLoadPictureClick(Sender: TObject);
begin
  OpenPictureDialog.Filter := GraphicFilter(TGraphic);
  if OpenPictureDialog.Execute then
  begin
    fmPicture.UpdatePage;
    fmPicture.imPreview.Picture.LoadFromFile(OpenPictureDialog.FileName);
    fmPicture.Editor.Picture := fmPicture.imPreview.Picture;
  end;
end;

procedure TfmDoc.pmiSavePictureClick(Sender: TObject);
begin
  SaveDialog.Filter := '*.' + GetGraphicExt(Layout.Picture);
  if SaveDialog.Execute then
    Layout.Picture.SaveToFile(SaveDialog.FileName);
end;

procedure TfmDoc.pmiClearPictureClick(Sender: TObject);
begin
  fmPicture.UpdatePage;
  fmPicture.Editor.Picture := nil;
end;

procedure TfmDoc.pmiFontClick(Sender: TObject);
begin
  if FontDialog.Execute then
  begin
    fmPicture.UpdatePage;
    fmPicture.Editor.TextFont := FontDialog.Font;
  end;
end;

procedure TfmDoc.pmiBgColorClick(Sender: TObject);
begin
  if ColorDialog.Execute then
  begin
    fmPicture.UpdatePage;
    fmPicture.Editor.BackgroundColor := ColorDialog.Color;
  end;
end;

procedure TfmDoc.Print;
begin
  PrintLayout(Layout);
end;

procedure TfmDoc.pmPicturePopup(Sender: TObject);
begin
  pmiPaste2.Enabled := Layout.CanPaste;
  pmiGroup2.Enabled := Layout.CanGroup;
end;

procedure TfmDoc.tbKeyClick(Sender: TObject);
begin
  ShowKeyProps;
end;

procedure TfmDoc.tbMSRClick(Sender: TObject);
begin
  ShowMSRDlg(Layout.Layer.MSR);
end;

procedure TfmDoc.tbKeyLockClick(Sender: TObject);
begin
  ShowKeylockDlg(FLayout.Layer.Keylock);
end;

procedure TfmDoc.tbLayoutKeyboardClick(Sender: TObject);
begin
  ShowKeyboardDlg(Layout);
end;

procedure TfmDoc.pmiReplaceClick(Sender: TObject);
begin
  ShowReplaceDlg(Layout);
end;

procedure TfmDoc.tbIButtonClick(Sender: TObject);
begin
  ShowIButtonDlg(FLayout.Layer.IButton);
end;

procedure TfmDoc.tbScrollWheelClick(Sender: TObject);
begin
  ShowScrollWheelDlg(FLayout.Layer.ScrollWheel);
end;

procedure TfmDoc.GridClick(Sender: TObject);
begin
  Layout.Selection := Grid.Selection;
end;

end.
