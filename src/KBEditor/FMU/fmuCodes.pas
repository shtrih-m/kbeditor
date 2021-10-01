unit fmuCodes;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls,
  // This
  KBLayout, fmuStdKey, fmuCstKey, Utils, SizeableForm, KeyboardManager;

type
  { TfmCodes }

  TfmCodes = class(TSizeableForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnSelect: TButton;
    btnClear: TButton;
    btnSet: TButton;
    Bevel1: TBevel;
    Memo: TMemo;
    lblInfo: TLabel;
    LabelHint: TLabel;
    procedure btnClearClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoKeyPress(Sender: TObject; var Key: Char);
    procedure MemoEnter(Sender: TObject);
    procedure MemoExit(Sender: TObject);
  private
    Flag: Integer;
    FCodes: TScanCodes;
    FOptions: TKeyOptions;

    procedure UpdateMemo;
    procedure AddScanCode(Data: TScanCode);
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    function PrevEnterPessed: Boolean;

    property Codes: TScanCodes read FCodes;
    procedure UpdatePage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowDialog(Edit: TEdit;
      Options: TKeyOptions = [koMake, koBreak]): Boolean; overload;
    function ShowDialog(var CodesText: string;
      Options: TKeyOptions = [koMake, koBreak]): Boolean; overload;
  end;

var
  fmCodes: TfmCodes;

implementation

{$R *.DFM}

{ TfmCodes }

constructor TfmCodes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCodes := TScanCodes.Create(nil);
  Flag := 0;
end;

destructor TfmCodes.Destroy;
begin
  Application.OnMessage := nil;
  FCodes.Free;
  inherited Destroy;
end;

function TfmCodes.ShowDialog(Edit: TEdit; Options: TKeyOptions): Boolean;
begin
  FOptions := Options;
  Codes.AsText := Edit.Text;
  UpdatePage;
  Result := ShowModal = mrOK;
  if Result then
    Edit.Text := Codes.AsText;
end;

function TfmCodes.ShowDialog(var CodesText: string; Options: TKeyOptions): Boolean;
begin
  FOptions := Options;
  Codes.AsText := CodesText;
  UpdatePage;
  Result := ShowModal = mrOK;
  if Result then
    CodesText := Codes.AsText;
end;

procedure TfmCodes.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  ScanCode: TScanCode;
begin
  Handled := False;
  try
    ScanCode := Manager.CodeTable.FromMessage(Msg, FOptions);
    if ScanCode <> nil then
    begin
      if ScanCode.Text <> 'TAB' then
      begin
        if (ScanCode.Text = 'ENTER') and (ScanCode.CodeType = ctBreak) then
        begin
          if not PrevEnterPessed then
          begin
            Handled := False;
            Exit;
          end;
        end;
        if not((Flag = 1)and(ScanCode.CodeType = ctBreak)) then
        begin
          AddScanCode(ScanCode);
        end;
        Flag := 0;
      end;
    end;
  except
    on E: Exception do
    begin
      Application.OnMessage := nil;
      Flag := 1;
      MessageBox(Handle, PChar(E.Message), PChar(Application.Title), MB_ICONERROR);
      Application.OnMessage := AppMessage;
    end;
  end;
end;

procedure TfmCodes.AddScanCode(Data: TScanCode);
var
  ScanCode: TScanCode;
begin
  ScanCode := Codes.Add;
  ScanCode.Assign(Data);
  Memo.Lines.Add(ScanCode.DisplayText);
end;

procedure TfmCodes.UpdateMemo;
var
  i: Integer;
begin
  Memo.Clear;
  for i := 0 to Codes.Count-1 do
    Memo.Lines.Add(Codes[i].DisplayText);
end;

procedure TfmCodes.UpdatePage;
begin
  UpdateMemo;
  ActiveControl := Memo;
end;

// Events

procedure TfmCodes.btnClearClick(Sender: TObject);
begin
  Codes.Clear;
  Memo.Lines.Clear;
  Memo.SetFocus;
end;

procedure TfmCodes.btnSelectClick(Sender: TObject);
var
  ScanCode: TScanCode;
begin
  ScanCode := TScanCode.Create(nil);
  Application.OnMessage := nil;
  try
    if fmStdKey.ShowModal = mrOK then
    begin
      if koMake in FOptions then
      begin
        fmStdKey.UpdateObject(ScanCode, ctMake);
        AddScanCode(ScanCode);
      end;
      if koBreak in FOptions then
      begin
        fmStdKey.UpdateObject(ScanCode, ctBreak);
        AddScanCode(ScanCode);
      end;
    end;
  finally
    ScanCode.Free;
    Application.OnMessage := AppMessage;
  end;
end;

procedure TfmCodes.btnSetClick(Sender: TObject);
var
  sc: TScanCode;
begin
  Application.OnMessage := nil;
  try
    if fmCstKey.ShowModal = mrOK then
    begin
      sc := Codes.AddRawCode(fmCstKey.Value);
      Memo.Lines.Add(sc.DisplayText);
    end;
  finally
    Application.OnMessage := AppMessage;
  end;
end;

procedure TfmCodes.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := 0;
end;

procedure TfmCodes.MemoKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TfmCodes.MemoEnter(Sender: TObject);
begin
  Application.OnMessage := AppMessage;
end;

procedure TfmCodes.MemoExit(Sender: TObject);
begin
  Application.OnMessage := nil;
end;

function TfmCodes.PrevEnterPessed: Boolean;
var
  i: Integer;
  Code: TScanCode;
begin
  Result := False;
  for i := Codes.Count-1 downto 0 do
  begin
    Code := Codes[i];
    if Code.Text = 'ENTER' then
    begin
      if Code.CodeType = ctBreak then Exit;
      if Code.CodeType = ctMake then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

end.
