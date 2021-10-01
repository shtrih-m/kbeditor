unit fmuStdKey;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // This
  KBLayout, Utils, SizeableForm, KeyboardManager;

type
  { TfmKey }

  TfmStdKey = class(TSizeableForm)
    lblKeySet: TLabel;
    lblKey: TLabel;
    lbKey: TListBox;
    lbScanCode: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel: TBevel;
    procedure OKClick(Sender: TObject);
    procedure lbKeyClick(Sender: TObject);
  private
    procedure UpdatePage;
    procedure UpdateKeys;
    procedure UpdateScanCodes;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateObject(AScanCode: TScanCode; CodeType: TCodeType);
  end;

var
  fmStdKey: TfmStdKey;
  
implementation

{$R *.DFM}

{ TfmKey }

constructor TfmStdKey.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UpdatePage;
end;

procedure TfmStdKey.UpdateKeys;
var
  i: Integer;
  CodeTable: TCodeTable;
begin
  with lbKey do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      for i := 0 to Manager.CodeTables.Count-1 do
      begin
        CodeTable := Manager.CodeTables[i];
        Items.Add(CodeTable.Text);
      end;
    finally
      Items.EndUpdate;
    end;
    if Items.Count > 0 then ItemIndex := 0;
  end;
end;

procedure TfmStdKey.UpdateScanCodes;
var
  i: Integer;
  ScanCode: TScanCode;
  ScanCodes: TScanCodes;
begin
  ScanCodes := Manager.CodeTables[lbKey.ItemIndex].ScanCodes;
  with lbScanCode do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      for i := 0 to ScanCodes.Count-1 do
      begin
        ScanCode := ScanCodes[i];
        if ScanCode.CodeType = ctMake then
          Items.Add(ScanCodes[i].Text);
      end;
    finally
      Items.EndUpdate;
    end;
    if Items.Count > 0 then ItemIndex := 0;
  end;
end;

procedure TfmStdKey.UpdatePage;
begin
  UpdateKeys;
  UpdateScanCodes;
end;

procedure TfmStdKey.UpdateObject(AScanCode: TScanCode; CodeType: TCodeType);
var
  ScanCode: TScanCode;
  CodeTable: TCodeTable;
begin
  CodeTable := Manager.CodeTables[lbKey.ItemIndex];
  if Codetype = ctMake then
    ScanCode := CodeTable.ScanCodes[lbScanCode.ItemIndex*2]
  else
    ScanCode := CodeTable.ScanCodes[lbScanCode.ItemIndex*2+1];

  AScanCode.Assign(ScanCode);
end;

// Event handlers

procedure TfmStdKey.lbKeyClick(Sender: TObject);
begin
  UpdateScanCodes;
end;

procedure TfmStdKey.OKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
