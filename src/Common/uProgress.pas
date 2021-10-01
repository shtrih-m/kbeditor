unit uProgress;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs;

type
  { TProgress }

  TProgress = class
  private
    FText: string;
    FStarted: Boolean;
    FTickCount: DWORD;
    FOperation: string;
    FTimeLeft: Integer;
    FBlockSent: Integer;
    FStopFlag: Boolean;
    FBlockCount: Integer;
    FDataRateText: string;
    FDataSizeText: string;
    FDataSentText: string;
    FOnChange: TNotifyEvent;
    FLock: TCriticalSection;

    function GetProgressText: string;
    function GetPersents: Integer;
    function GetTimeLeftText: string;
    function GetBlockSentText: string;
    function GetBlockCountText: string;
    procedure DoChanged;
    function GetElapsedTickCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Stop;
    procedure Clear;
    procedure Lock;
    procedure Unlock;
    procedure CheckStopFlag;
    procedure Step(Value, PacketSize: Integer);
    procedure Start(Value, PacketSize: Integer; const AText: string);

    property Text: string read FText;
    property Started: Boolean read FStarted;
    property TimeLeft: Integer read FTimeLeft;
    property BlockSent: Integer read FBlockSent;
    property BlockCount: Integer read FBlockCount;
    property DataSizeText: string read FDataSizeText;
    property DataSentText: string read FDataSentText;
    property DataRateText: string read FDataRateText;
    property ProgressText: string read GetProgressText;
    property TimeLeftText: string read GetTimeLeftText;
    property BlockSentText: string read GetBlockSentText;
    property BlockCountText: string read GetBlockCountText;
    property Operation: string read FOperation write FOperation;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property ElapsedTickCount: Integer read GetElapsedTickCount;
  end;

procedure FreeProgress;
function Progress: TProgress;

implementation

resourcestring
  MsgAbortOperation     = 'Abort operation?';
  MsgDataSentText       = '%d byte';
  MsgDataRateText       = '%d byte/s';
  MsgDataSizeText       = '%d byte';

var
  FProgress: TProgress = nil;

procedure FreeProgress;
begin
  FProgress.Free;
  FProgress := nil;
end;

function Progress: TProgress;
begin
  if FProgress = nil then
    FProgress := TProgress.Create;
  Result := FProgress;
end;

{ TProgress }

constructor TProgress.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
end;

destructor TProgress.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

procedure TProgress.Stop;
begin
  FStarted := False;
  FStopFlag := True;
end;

procedure TProgress.DoChanged;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TProgress.CheckStopFlag;
begin
  if FStopFlag then Abort;
end;

procedure TProgress.Step(Value, PacketSize: Integer);
begin
  Lock;
  try
    CheckStopFlag;
    FBlockSent := Value;
    FTimeLeft := Round((GetTickCount - FTickCount)/1000);
    FDataSentText := Format(MsgDataSentText, [Value*PacketSize]);
    if TimeLeft > 0 then
      FDataRateText := Format(MsgDataRateText, [Value*PacketSize div TimeLeft]);
    DoChanged;
  finally
    Unlock;
  end;
end;

procedure TProgress.Start(Value, PacketSize: Integer; const AText: string);
begin
  FText := AText;
  FDataRateText := '';
  FBlockCount := Value;
  FDataSizeText := Format(MsgDataSizeText, [Value*PacketSize]);
  FDataSentText := '';
  FStopFlag := False;
  FTickCount := GetTickCount;
  FStarted := True;
end;

function TProgress.GetPersents: Integer;
begin
  Result := 0;
  if BlockCount <> 0 then
    Result := Trunc(100*BlockSent/BlockCount);
end;

function TProgress.GetProgressText: string;
begin
  Result := Format('%d %%', [GetPersents]);
end;

function TProgress.GetTimeLeftText: string;
begin
  Result := IntToStr(TimeLeft);
end;

function TProgress.GetBlockSentText: string;
begin
  Result := IntToStr(BlockSent);
end;

function TProgress.GetBlockCountText: string;
begin
  Result := IntToStr(BlockCount);
end;

procedure TProgress.Clear;
begin
  FText := '';
  FStarted := False;
  FTickCount := 0;
  FOperation := '';
  FTimeLeft := 0;
  FBlockSent := 0;
  FBlockCount := 0;
  FDataRateText := '';
  FDataSizeText := '';
  FDataSentText := '';
end;

procedure TProgress.Lock;
begin
  FLock.Enter;
end;

procedure TProgress.Unlock;
begin
  FLock.Leave;
end;

function TProgress.GetElapsedTickCount: Integer;
begin
  Result := 0;
  if Started then
    Result := GetTickCount - FTickCount;
end;

end.
