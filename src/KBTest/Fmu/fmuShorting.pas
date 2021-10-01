unit fmuShorting;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // This
  WizardPage, TestWizard, Utils, KeyboardDriver, DeviceError, KeyboardManager,
  KeyboardTypes;

type
  { TfmfmShorting }

  TfmShorting = class(TWizardPage)
    Memo: TMemo;
    lblResult: TLabel;
    ShapeResult: TShape;
  public
    procedure Stop; override;
    procedure Start; override;
    function IsValid: Boolean; override;
  end;

implementation

{$R *.DFM}

{ TfmShorting }

procedure TfmShorting.Stop;
begin
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';
  Wizard.GoNext;
end;

procedure TfmShorting.Start;
var
  i: Integer;
  S: string;
  Shorting: TShortingRec;
begin
  ShapeResult.Brush.Color := clSilver;
  lblResult.Caption := 'Тест не выполнялся';

  Memo.Lines.Clear;
  try
    Shorting := Manager.Driver.GetShorting;
    Memo.Lines.Add(Format('Данные: %.2x %.2x %.2x', [
      Shorting.Data[1],
      Shorting.Data[2],
      Shorting.Data[3]]));

    // Rows
    if Shorting.RowsShorted > 0 then
    begin
      S := '';
      for i := Low(Shorting.Rows) to High(Shorting.Rows) do
      begin
        if Shorting.Rows[i] then
        begin
          S := S + IntToStr(i) + ',';
        end;
      end;
      S := 'Замкнутые строки: ' + S;
      Memo.Lines.Add(Copy(S, 1, Length(S) - 1));
    end;
    // Cols
    if Shorting.ColsShorted > 0 then
    begin
      S := '';
      for i := Low(Shorting.Cols) to High(Shorting.Cols) do
      begin
        if Shorting.Cols[i] then
        begin
          S := S + IntToStr(i) + ',';
        end;
      end;
      S := 'Замкнутые столбцы: ' + S;
      Memo.Lines.Add(Copy(S, 1, Length(S) - 1));
    end;
    if Shorting.IsShorted then
    begin
      lblResult.Caption := 'Тест не пройден';
      ShapeResult.Brush.Color := clSilver;
    end else
    begin
      Memo.Lines.Add('Замкнутых строк или столбцов нет');
      lblResult.Caption := 'Тест успешно пройден.';
      ShapeResult.Brush.Color := clLime;
    end;
  finally
    Manager.Driver.SetMode(amProg, dmData);
  end;
end;

function TfmShorting.IsValid: Boolean;
begin
  Result := True;
  try
    Manager.Driver.GetShorting;
  except
    on E: Exception do
      if HandleException(E) = E_UNSUPPORTED_COMMAND then
        Result := False
      else raise;
  end;
end;

end.
