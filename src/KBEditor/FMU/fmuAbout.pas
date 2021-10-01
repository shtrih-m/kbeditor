unit fmuAbout;

interface

uses
  // VCL
  Windows, Forms, ExtCtrls, StdCtrls, Controls, Classes, ShellAPI, Graphics,
  // This
  SizeableForm, Utils, fmuUpdates;


type
  { TfmAbout }

  TfmAbout = class(TSizeableForm)
    lblAddress: TLabel;
    btnOK: TButton;
    lblURL: TLabel;
    lblWebSite: TLabel;
    lblSupport: TLabel;
    lblSupportMail: TLabel;
    NameLabel: TLabel;
    lbVersion: TListBox;
    bvlInfo: TBevel;
    lblFirmName: TLabel;
    Image: TImage;
    Shape1: TShape;
    Bevel2: TBevel;
    btnCheckForUpdates: TButton;
    procedure lblURLClick(Sender: TObject);
    procedure lblSupportMailClick(Sender: TObject);
    procedure btnCheckForUpdatesClick(Sender: TObject);
  public
    procedure UpdatePage(const ACaption: string; Info: array of string);
  end;

var
  fmAbout: TfmAbout;

implementation

{$R *.DFM}

{ TfmAbout }

procedure TfmAbout.UpdatePage(const ACaption: string; Info: array of string);
var
  i: Integer;
begin
  NameLabel.Caption := ACaption;
  lbVersion.Items.Clear;
  for i:= Low(Info) to High(Info) do
    lbVersion.Items.Add(Info[i]);
end;

procedure TfmAbout.lblURLClick(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow(),'open','http://www.shtrih-m.ru',
    nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.lblSupportMailClick(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow(),'open','mailto:support@shtrih-m.ru',
    nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.btnCheckForUpdatesClick(Sender: TObject);
begin
  fmUpdates.CheckForUpdates(SoftUpdatePath, False);
end;

end.
