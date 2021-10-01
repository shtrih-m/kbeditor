unit fmuError;

interface

uses
  // VCL
  Forms, Graphics, ExtCtrls, StdCtrls, Controls, Classes, SysUtils,
  // This
  SizeableForm;

type
  { TfmError }

  TfmError = class(TSizeableForm)
    btnSend: TButton;
    Bevel1: TBevel;
    lblError: TLabel;
    Image1: TImage;
  public
    procedure UpdatePage(E: Exception);
  end;

var
  fmError: TfmError;

implementation

{$R *.DFM}

procedure TfmError.UpdatePage(E: Exception);
begin
  lblError.Caption := E.Message;
end;

end.
