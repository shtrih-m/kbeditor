unit uWorkThread;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Forms,
  // This
  WorkItem;

type
  { TNotifyThread }

  TNotifyThread = class(TThread)
  private
    FOnExecute: TNotifyEvent;
  protected
    procedure Execute; override;
  public
    constructor CreateThread(AOnExecute: TNotifyEvent);
  published
    property Terminated;
  end;

  { TWorkThread }

  TWorkThread = class
  private
    FItems: TThreadList;
    FThread: TNotifyThread;
    FOnException: TExceptionEvent;

    procedure FreeItems;
    procedure ThreadProc(Sender: TObject);
    function GetWorkItem: TWorkItem;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Stop;
    procedure Start;
    function Started: Boolean;
    procedure AddItem(AItem: TWorkItem);
    procedure Execute(AItem: TWorkItem);
    property OnException: TExceptionEvent read FOnException write FOnException;
  end;

function WorkThread: TWorkThread;

implementation

var
  FWorkThread: TWorkThread = nil;

function WorkThread: TWorkThread;
begin
  if FWorkThread = nil then
    FWorkThread := TWorkThread.Create;
  Result := FWorkThread;
end;

{ TNotifyThread }

constructor TNotifyThread.CreateThread(AOnExecute: TNotifyEvent);
begin
  FOnExecute := AOnExecute;
  inherited Create(False);
end;

procedure TNotifyThread.Execute;
begin
  if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

{ TWorkThread }

constructor TWorkThread.Create;
begin
  inherited Create;
  FItems := TThreadList.Create;
end;

destructor TWorkThread.Destroy;
begin
  Stop;
  FreeItems;
  FItems.Free;
  inherited Destroy;
end;

procedure TWorkThread.FreeItems;
var
  Item: TObject;
begin
  repeat
    Item := GetWorkItem;
    Item.Free;
  until Item = nil;
end;


procedure TWorkThread.Execute(AItem: TWorkItem);
begin
  AddItem(AItem);
  Start;
end;

procedure TWorkThread.AddItem(AItem: TWorkItem);
var
  List: TList;
begin
  List := FItems.LockList;
  try
    if List.Count > 0 then
      raise Exception.Create('Задание уже выполняется');

    FItems.Add(AItem);
  finally
    FItems.UnlockList;
  end;
end;

procedure TWorkThread.Start;
begin
  if not Started then
    FThread := TNotifyThread.CreateThread(ThreadProc);
end;

function TWorkThread.GetWorkItem: TWorkItem;
var
  List: TList;
begin
  Result := nil;
  List := FItems.LockList;
  try
    if List.Count > 0 then
    begin
      Result := List[0];
      List.Delete(0);
    end;
  finally
    FItems.UnlockList;
  end;
end;

procedure TWorkThread.ThreadProc(Sender: TObject);
var
  Item: TworkItem;
begin
  repeat
    if FThread.Terminated then Exit;
    Item := GetWorkItem;
    if Item = nil then Sleep(100)
    else
    begin
      try
        Item.Execute;
        Item.Completed;
      except
        on E: Exception do
        begin
          if not(E is EAbort) then
          begin
            if Assigned(FOnException) then
              FOnException(Self, E)
            else
              MessageBox(Application.Handle, PChar(E.Message),
              PChar(Application.Title), MB_ICONERROR);
          end;
        end;
      end;
      Item.Free;
    end;
  until False;
end;

procedure TWorkThread.Stop;
begin
  FThread.Free;
  FThread := nil;
end;

function TWorkThread.Started: Boolean;
begin
  Result := FThread <> nil;
end;

initialization

finalization
  FWorkThread.Free;
  FWorkThread := nil;

end.
