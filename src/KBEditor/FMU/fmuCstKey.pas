unit fmuCstKey;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // This
  KBLayout, Utils, SizeableForm;

type
  TNumMode = (nmDec, nmHex);

  { TfmCstKey }

  TfmCstKey = class(TSizeableForm)
    edtCode: TEdit;
    lblCode: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel: TBevel;
    procedure btnOKClick(Sender: TObject);
  public
    Value: string;
  end;

var
  fmCstKey: TfmCstKey;
  
implementation

{$R *.DFM}

{ TfmCstKey }

procedure TfmCstKey.btnOKClick(Sender: TObject);
begin
  Value := HexToStr(edtCode.Text);
  ModalResult := mrOK;
end;

end.
