
unit fmuPreview;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Printers, ImgList, StdCtrls,
  // Toolbar 2000
  TB2Item, TB2Dock, TB2Toolbar, TB2MDI,
  // This
  KBLayout, Preview, KBLayoutPrint, SizeableForm;

type
  { TfmPreview }

  TfmPreview = class(TSizeableForm)
    PrintPreview: TPrintPreview;
    PrintDialog: TPrintDialog;
    ImageList: TImageList;
    TBDock1: TTBDock;
    tbPreview: TTBToolbar;
    miPrintPreview: TTBItem;
    TBSeparatorItem16: TTBSeparatorItem;
    miClosePreview: TTBItem;
    TBSeparatorItem18: TTBSeparatorItem;
    TBControlItem1: TTBControlItem;
    TBSeparatorItem15: TTBSeparatorItem;
    cmbZoom: TComboBox;
    Label1: TLabel;
    TBControlItem2: TTBControlItem;
    Label2: TLabel;
    cmbPaper: TComboBox;
    TBControlItem3: TTBControlItem;
    TBControlItem4: TTBControlItem;
    Label3: TLabel;
    TBSeparatorItem1: TTBSeparatorItem;
    TBControlItem5: TTBControlItem;
    Label4: TLabel;
    rbnBook: TRadioButton;
    TBControlItem6: TTBControlItem;
    rbnAlbum: TRadioButton;
    TBControlItem7: TTBControlItem;
    procedure PrintPreviewAnnotation(Sender: TObject; PageNo: Integer;
      Canvas: TCanvas);

    procedure miClosePreviewClick(Sender: TObject);
    procedure EnterZoom(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PreviewZoomChange(Sender: TObject);
    procedure miPrintPreviewClick(Sender: TObject);
    procedure cmbZoomClick(Sender: TObject);
    procedure cmbPaperChange(Sender: TObject);
    procedure ChangeOrientation(Sender: TObject);
  private
    FLayout: TKBLayout;
    FWindowState: TWindowState;
    FLayoutPrint: TKBLayoutPrint;

    procedure DrawLayout;
    procedure SetZoomText;
  public
    constructor CreateForm(AOwner: TComponent; ALayout: TKBLayout);
    destructor Destroy; override;
    procedure PrintDoc;
  end;

implementation

{$R *.DFM}

resourcestring
  MsgInvalidScale       = 'Invalid scale value';

{ TfmPreview }

constructor TfmPreview.CreateForm(AOwner: TComponent; ALayout: TKBLayout);
begin
  if (Application.MainForm <> nil)
    and (Application.MainForm.ActiveMDIChild <> nil) then
    FWindowState := Application.MainForm.ActiveMDIChild.WindowState;

  inherited Create(AOwner);
  FLayoutPrint := TKBLayoutPrint.Create;
  FLayout := ALayout;
  cmbZoom.ItemIndex := 2;
  PrintPreview.FetchFormNames(cmbPaper.Items);
  cmbPaper.ItemIndex := cmbPaper.Items.IndexOf(PrintPreview.FormName);
  rbnBook.Checked := PrintPreview.Orientation = poPortrait;
  rbnAlbum.Checked := PrintPreview.Orientation = poLandscape;
  DrawLayout;
end;

destructor TfmPreview.Destroy;
begin
  FLayoutPrint.Free;
  inherited Destroy;
  if (Application.MainForm <> nil)
    and (Application.MainForm.ActiveMDIChild <> nil) then
    Application.MainForm.ActiveMDIChild.WindowState := FWindowState;
end;

procedure TfmPreview.DrawLayout;
begin
  PrintPreview.Units := mmLoMetric;
  PrintPreview.BeginDoc;
  try
    FLayoutPrint.PrintLayout(FLayout, PrintPreview.Canvas,
      Round(KeyWidthInInch*254), Round(KeyHeightInInch*254),
      Round(KeySpaceXInInch*254), Round(KeySpaceYInInch*254),
      PrintPreview.PrinterPageBounds);
  finally
    PrintPreview.EndDoc;
  end;
end;

procedure TfmPreview.PrintPreviewAnnotation(Sender: TObject; PageNo: Integer; Canvas: TCanvas);
begin
  with PrintPreview.PrinterPageBounds do
  begin
    Canvas.Pen.Width := 0;
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clLtGray;
    Canvas.MoveTo(Left, 0);
    Canvas.LineTo(Left, PrintPreview.PaperHeight);
    Canvas.MoveTo(Right, 0);
    Canvas.LineTo(Right, PrintPreview.PaperHeight);
    Canvas.MoveTo(0, Top);
    Canvas.LineTo(PrintPreview.PaperWidth, Top);
    Canvas.MoveTo(0, Bottom);
    Canvas.LineTo(PrintPreview.PaperWidth, Bottom);
  end;
end;

procedure TfmPreview.PrintDoc;
begin
  PrintPreview.SetPrinterOptions;
  if PrintDialog.Execute then
    PrintPreview.Print;
end;

procedure TfmPreview.EnterZoom(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then SetZoomText;
end;

procedure TfmPreview.SetZoomText;
var
  S: string;
  Zoom: Integer;
  Code: Integer;
begin
  S := cmbZoom.Text;
  if S[Length(S)] = '%' then S := Copy(S, 1, Length(S)-1);
  Val(S, Zoom, Code);
  if Code <> 0 then
  begin
    MessageBox(Handle, PChar(MsgInvalidScale),
      PChar(Application.Title), MB_ICONEXCLAMATION);
    Exit;
  end;

  if (Zoom > PrintPreview.ZoomMax) then Zoom := PrintPreview.ZoomMax;
  if (Zoom < PrintPreview.ZoomMin) then Zoom := PrintPreview.ZoomMin;
  PrintPreview.Zoom := Zoom;
  cmbZoom.Text := IntToStr(Zoom) + '%';
end;

procedure TfmPreview.miPrintPreviewClick(Sender: TObject);
begin
  PrintDoc;
end;

procedure TfmPreview.PreviewZoomChange(Sender: TObject);
begin
  cmbZoom.Text := IntToStr(PrintPreview.Zoom) + '%';
end;

procedure TfmPreview.cmbZoomClick(Sender: TObject);
begin
  SetZoomText;
end;

procedure TfmPreview.miClosePreviewClick(Sender: TObject);
begin
  Close;
end;

procedure TfmPreview.cmbPaperChange(Sender: TObject);
begin
  PrintPreview.FormName := cmbPaper.Items[cmbPaper.ItemIndex];
  PrintPreview.Clear;
  DrawLayout;
end;

procedure TfmPreview.ChangeOrientation(Sender: TObject);
begin
  PrintPreview.Orientation := TPrinterOrientation((Sender as TRadioButton).Tag);
  PrintPreview.Clear;
  DrawLayout;
end;

end.

