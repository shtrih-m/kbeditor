unit OperationThread;

interface

uses
  // VCL
  Windows, SysUtils, Classes, SyncObjs,
  // This
  NotifyThread, OperationInterface, LogFile, DebugUtils;

type
  TOperationEvent = procedure (Sender: TObject; Operation: IOperation) of object;

  TThreadStatus = (stNone, stStarted, stFailed, stAborted, stSucceeded);

  { TOperationThread }

  TOperationThread = class
  private
    FStartEvent: TEvent;
    FErrorMessage: string;
    FThread: TNotifyThread;
    FOperation: IOperation;
    FStatus: TThreadStatus;
    FOnCompleted: TOperationEvent;

    procedure Completed;
    function GetSucceeded: Boolean;
    procedure ThreadProc(Sender: TObject);
    function GetAborted: Boolean;
    function GetFailed: Boolean;
    function GetStarted: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start(AOperation: IOperation);

    property Failed: Boolean read GetFailed;
    property Aborted: Boolean read GetAborted;
    property Started: Boolean read GetStarted;
    property Succeeded: Boolean read GetSucceeded;
    property ErrorMessage: string read FErrorMessage;
    property OnCompleted: TOperationEvent read FOnCompleted write FOnCompleted;
  end;

procedure FreeWorkThread;
function WorkThread: TOperationThread;

implementation

var
  FOperationThread: TOperationThread;

function WorkThread: TOperationThread;
begin
  if FOperationThread = nil then
    FOperationThread := TOperationThread.Create;
  Result := FOperationThread;
end;

procedure FreeWorkThread;
begin
  FOperationThread.Free;
  FOperationThread := nil;
end;

{ TOperationThread }

constructor TOperationThread.Create;
begin
  inherited Create;
  FStartEvent := TSimpleEvent.Create;
end;

destructor TOperationThread.Destroy;
begin
  FThread.Free;
  FStartEvent.Free;
  inherited Destroy;
end;

procedure TOperationThread.ThreadProc(Sender: TObject);
begin
  FStatus := stStarted;
  FErrorMessage := '';
  FStartEvent.SetEvent;
  try
    FOperation.Execute;
    FStatus := stSucceeded;
  except
    on E: Exception do
    begin
      if E is EAbort then
      begin
        FStatus := stAborted;
      end else
      begin
        FStatus := stFailed;
      end;
      FErrorMessage := E.Message;
      Logger.Error(E.Message);
    end;
  end;
  FThread.Synchronize(Completed);

  FOperation := nil;
end;

procedure TOperationThread.Completed;
begin
  if Assigned(FOnCompleted) then
    FOnCompleted(Self, FOperation);
end;

procedure TOperationThread.Start(AOperation: IOperation);
begin
  FStatus := stStarted;
  FOperation := AOperation;
  FStartEvent.ResetEvent;

  FThread.Free;
  FThread := TNotifyThread.Create(True);
  FThread.OnExecute := ThreadProc;
  FThread.Resume;
  if FStartEvent.WaitFor(INFINITE) <> wrSignaled then
    RaiseLastOSError;
end;

function TOperationThread.GetSucceeded: Boolean;
begin
  Result := FStatus = stSucceeded;
end;

function TOperationThread.GetAborted: Boolean;
begin
  Result := FStatus = stAborted;
end;

function TOperationThread.GetFailed: Boolean;
begin
  Result := FStatus = stFailed;
end;

function TOperationThread.GetStarted: Boolean;
begin
  Result := FStatus = stStarted;
end;

end.
