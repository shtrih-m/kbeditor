unit fmuPicture;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtDlgs, ExtCtrls, ColorGrd, Buttons, jpeg,
  // This
  KBLayout, GridType, SizeableForm, Utils, KeyEditor, KeyPictureEditor,
  DebugUtils;

type
  { TfmPicture }

  TfmPicture = class(TSizeableForm)
    OpenPictureDialog: TOpenPictureDialog;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    SaveDialog: TSaveDialog;
    gbPicture: TGroupBox;
    KeyText: TPanel;
    imPreview: TImage;
    gbText: TGroupBox;
    Label2: TLabel;
    edtText: TEdit;
    btnFont: TBitBtn;
    GroupBox1: TGroupBox;
    rbnHorizontal: TRadioButton;
    rbnVertical: TRadioButton;
    btnOpen: TButton;
    btnSave: TButton;
    btnClear: TButton;
    btnColor: TButton;
    procedure btnOpenClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure edtTextChange(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure rbnHorizontalClick(Sender: TObject);

    procedure rbnVerticalClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FLink: TKBLayoutLink;
    FEditor: TKeyPictureEditor;

    procedure ClearPage;
    function GetLayout: TKBLayout;
    procedure LayoutChanged(Sender: TObject);
    procedure SetLayout(const Value: TKBLayout);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdatePage;

    property Editor: TKeyPictureEditor read FEditor;
    property Layout: TKBLayout read GetLayout write SetLayout;
  end;

var
  fmPicture: TfmPicture;

implementation

{$R *.DFM}

constructor TfmPicture.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditor := TKeyPictureEditor.Create(Self);
  FLink := TKBLayoutLink.Create;
  FLink.OnChange := LayoutChanged;
end;

destructor TfmPicture.Destroy;
begin
  FLink.Free;
  FEditor.Free;
  inherited Destroy;
end;

function TfmPicture.GetLayout: TKBLayout;
begin
  Result := FLink.Layout;
end;

procedure TfmPicture.SetLayout(const Value: TKBLayout);
begin
  FLink.Layout := Value;
end;

procedure TfmPicture.LayoutChanged(Sender: TObject);
begin
  Editor.Layout := Layout;
  if Visible then
  begin
    if Layout = nil then
    begin
      ClearPage;
    end else
    begin
      UpdatePage;
    end;
  end;
end;

procedure TfmPicture.btnOpenClick(Sender: TObject);
begin
  OpenPictureDialog.Filter := GraphicFilter(TGraphic);
  if OpenPictureDialog.Execute then
  begin
    imPreview.Picture.LoadFromFile(OpenPictureDialog.FileName);
    Editor.Picture := imPreview.Picture;
  end;
end;

procedure TfmPicture.btnSaveClick(Sender: TObject);
begin
  SaveDialog.Filter := '*.' + GetGraphicExt(imPreview.Picture);
  if SaveDialog.Execute then
    imPreview.Picture.SaveToFile(SaveDialog.FileName);
end;

procedure TfmPicture.btnClearClick(Sender: TObject);
begin
  imPreview.Picture.Assign(nil);
  Editor.Picture := nil;
end;

procedure TfmPicture.ClearPage;
begin
  imPreview.Picture.Assign(nil);
  edtText.Text := '';
  KeyText.Caption := '';
  KeyText.Color := clWhite;
  KeyText.Font := btnOpen.Font;
end;

procedure TfmPicture.UpdatePage;
begin
  if Layout = nil then Exit;

  SafeSetEdit(edtText, Editor.Text);
  KeyText.Font := Editor.TextFont;
  KeyText.Caption := Editor.Text;
  KeyText.Color := Editor.BackgroundColor;
  if Editor.VerticalText then
  begin
    SafeSetCheckedRadio(rbnVertical, True);
    SafeSetCheckedRadio(rbnHorizontal, False);
  end else
  begin
    SafeSetCheckedRadio(rbnVertical, False);
    SafeSetCheckedRadio(rbnHorizontal, True);
  end;
  imPreview.Picture.Assign(Editor.Picture);
  Caption := Editor.Caption;
end;

procedure TfmPicture.btnFontClick(Sender: TObject);
begin
  FontDialog.Font := Editor.TextFont;
  if FontDialog.Execute then
  begin
    KeyText.Font := FontDialog.Font;
    Editor.TextFont := FontDialog.Font;
  end;
end;

procedure TfmPicture.edtTextChange(Sender: TObject);
begin
  KeyText.Caption := edtText.Text;
  Editor.Text := edtText.Text;
end;

procedure TfmPicture.btnColorClick(Sender: TObject);
begin
  ColorDialog.Color := Editor.BackgroundColor;
  if ColorDialog.Execute then
  begin
    KeyText.Color := ColorDialog.Color;
    Editor.BackgroundColor := ColorDialog.Color;
  end;
end;

procedure TfmPicture.rbnHorizontalClick(Sender: TObject);
begin
  Editor.VerticalText := False;
end;

procedure TfmPicture.rbnVerticalClick(Sender: TObject);
begin
  Editor.VerticalText := True;
end;

procedure TfmPicture.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Hide;
end;

end.
