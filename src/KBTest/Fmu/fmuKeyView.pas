unit fmuKeyView;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ImgList, ToolWin, StdCtrls, ExtCtrls, Buttons,
  ClipBrd,
  // This
  KBLayout, TestWizard, KeyGrid2, Grids2, KeyboardManager, KeyboardDriver, Utils,
  WizardPage, SizeableForm;

const
  Col0Width             = 25;
  Row0Height            = 25;
  DefaulColWidth        = 55;
  DefaultRowHeight      = 55;

type
  { TfmKeyView }

  TfmKeyView = class(TSizeableForm)
    btnReset: TButton;
    btnClose: TButton;
    Bevel: TBevel;
    ImageList: TImageList;
    procedure FormResize(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function GetLayout: TKBLayout;
  private
    procedure CreateGrid;
    procedure UpdateParams;
    procedure UpdateGridParams;
    procedure SetGridParams(ColCount, RowCount: Integer);

    property Layout: TKBLayout read GetLayout;
  public
    Grid: TKeyGrid2;
    constructor Create(AOwner: TComponent); override;
  end;

var
  fmKeyView: TfmKeyView;

procedure ShowKeyView;

implementation

{$R *.DFM}

procedure ShowKeyView;
begin
  fmKeyView.UpdateParams;
  fmKeyView.ShowModal;
end;

{ TfmKeyView }

constructor TfmKeyView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateGrid;
end;

procedure TfmKeyView.UpdateParams;
begin
  SetGridParams(Layout.ColCount + 1, Layout.RowCount + 1);
end;

procedure TfmKeyView.CreateGrid;
begin
  Grid := TKeyGrid2.CreateGrid(Self, Layout);
  Grid.ScrollBars := ssNone;
  Grid.Parent := Self;
  Grid.Left := Bevel.Left;
  Grid.Top := Bevel.Top;
  Grid.Width := Bevel.Width;
  Grid.Height := Bevel.Height;
  Grid.Anchors := Bevel.Anchors;
  Grid.ColCount := 9;
  Grid.RowCount := 9;

  Grid.DefaultColWidth := DefaulColWidth;
  Grid.DefaultRowHeight := DefaultRowHeight;
  Grid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];

  Grid.ColWidths[0] := Col0Width;
  Grid.RowHeights[0] := Row0Height;
  ActiveControl := Grid;
end;

procedure TfmKeyView.UpdateGridParams;
var
  i: Integer;
  RowCount: Integer;
  ColCount: Integer;
  ColWidth: Integer;
  RowHeight: Integer;
  LineWidth: Integer;
  ColWidths: Integer;
  RowHeights: Integer;
begin
  ColCount := Grid.ColCount;
  RowCount := Grid.RowCount;
  LineWidth := Grid.GridLineWidth;
  ColWidths := Bevel.Width - LineWidth*(ColCount+3) - Col0Width;
  RowHeights := Bevel.Height - LineWidth*(RowCount+3) - Row0Height;

  ColWidth := ColWidths div (ColCount-1);
  RowHeight := RowHeights div (RowCount-1);

  for i := 1 to RowCount-2 do
    Grid.RowHeights[i] := RowHeight;
  for i := 1 to ColCount-2 do
    Grid.ColWidths[i] := ColWidth;

  Grid.ColWidths[ColCount-1] := ColWidths - (ColCount-2) * ColWidth;
  Grid.RowHeights[RowCount-1] := RowHeights - (RowCount-2) * RowHeight;
end;

procedure TfmKeyView.SetGridParams(ColCount, RowCount: Integer);

  function GetGridWidth: Integer;
  var
    i: Integer;
  begin
    Result := Grid.GridLineWidth*2;
    for i := 0 to Grid.ColCount-1 do
      Result := Result + Grid.ColWidths[i] + Grid.GridLineWidth*2;
  end;

  function GetGridHeight: Integer;
  var
    i: Integer;
  begin
    // Высота Caption
    Result := Grid.GridLineWidth*2 + Height - ClientHeight - 7;
    for i := 0 to Grid.RowCount-1 do
      Result := Result + Grid.RowHeights[i] + Grid.GridLineWidth*2;
  end;

var
  i: Integer;
begin
  Grid.ColCount := ColCount;
  Grid.RowCount := RowCount;
  Width := GetGridWidth;
  Height := GetGridHeight;
  { Номера столбцов }
  for i := 1 to Grid.ColCount-1 do
    Grid.Cells[i, 0] := IntToStr(i);
  { Номера строк }
  for i := 1 to Grid.RowCount-1 do
    Grid.Cells[0, i] := IntToStr(i);
end;

procedure TfmKeyView.FormResize(Sender: TObject);
begin
  UpdateGridParams;
end;

procedure TfmKeyView.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmKeyView.btnResetClick(Sender: TObject);
begin
  Layout.ResetKeys;
  Grid.Refresh;
end;

procedure TfmKeyView.FormShow(Sender: TObject);
begin
  Grid.SetFocus;
end;

function TfmKeyView.GetLayout: TKBLayout;
begin
  Result := Wizard.Layout;
end;

end.
