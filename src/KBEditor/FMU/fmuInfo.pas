unit fmuInfo;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ImgList, Buttons,
  // This
  SizeableForm, KeyboardReport, KeyboardManager;

type
  { TfmInfo }

  TfmInfo = class(TSizeableForm)
    btnClose: TButton;
    ListView: TListView;
    imExclamation: TImage;
    Bevel1: TBevel;
    lblStatus: TLabel;
    ImageList: TImageList;
    btnCopy: TBitBtn;
    procedure btnCopyClick(Sender: TObject);
  private
    FReport: TKeyboardReport;
    procedure UpdatePage;
    procedure AddListItem(const Caption, Text: string;
      ImageIndex: Integer);

    property Report: TKeyboardReport read FReport;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ReadLoaderReport;
    procedure ReadApplicationReport;
  end;

var
  fmInfo: TfmInfo;

implementation

{$R *.DFM}

{ TfmInfo }

constructor TfmInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReport := TKeyboardReport.Create(Manager);
end;

destructor TfmInfo.Destroy;
begin
  FReport.Free;
  inherited Destroy;
end;

procedure TfmInfo.ReadLoaderReport;
begin
  fmInfo.Report.ReadLoaderReport;
  fmInfo.UpdatePage;
  fmInfo.ShowModal;
end;

procedure TfmInfo.ReadApplicationReport;
begin
  fmInfo.Report.ReadApplicationReport;
  fmInfo.UpdatePage;
  fmInfo.ShowModal;
end;

procedure TfmInfo.AddListItem(const Caption, Text: string; ImageIndex: Integer);
var
  ListItem: TListItem;
begin
  ListItem := ListView.Items.Add;
  ListItem.Caption := Caption;
  ListItem.SubItems.Add(Text);
  ListItem.ImageIndex := ImageIndex;
end;

procedure TfmInfo.UpdatePage;
var
  i: Integer;
  ParamName: string;
  ParamValue: string;
  ShortingImageIndex: Integer;
begin
  ListView.Items.Clear;
  ListView.Items.BeginUpdate;
  try
    for i := 0 to Report.Lines.Count-1 do
    begin
      ParamName := Report.Lines.Names[i];
      ParamValue := Report.Lines.ValueFromIndex[i];
      AddListItem(ParamName, ParamValue, -1);
    end;
    ShortingImageIndex := -1;
    if Report.HasShortings then
      ShortingImageIndex := 0;
    AddListItem(Report.ShortingName, Report.ShortingValue, ShortingImageIndex);
    imExclamation.Visible := Report.IsLayoutCorrupted;
    lblStatus.Caption := Report.LayoutStatus;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TfmInfo.btnCopyClick(Sender: TObject);
begin
  Report.CopyToClipboard;
end;

end.
