unit ChangeNotifier;

interface

uses
  // VCL
  Windows, Classes, Messages, Forms;

const
  WM_CHANGE_NOTIFICATION = WM_USER + 1000;

type
  TChangeNotifier = class;

  { TChangeNotifiers }

  TChangeNotifiers = class(TComponent)
  public
    function Add: TChangeNotifier;
    procedure Notify(Sender: TObject);
  end;

  { TChangeNotifier }

  TChangeNotifier = class(TComponent)
  private
    FHandle: HWND;
    FOnChange: TNotifyEvent;
    procedure DoNotify;
    procedure WndProc(var Message: TMessage);
    procedure WMChangeNotification(var Msg: TMessage); message WM_CHANGE_NOTIFICATION;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Notify(Sender: TObject);
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TChangeNotifiers }

function TChangeNotifiers.Add: TChangeNotifier;
begin
  Result := TChangeNotifier.Create(Self);
end;

procedure TChangeNotifiers.Notify(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ComponentCount-1 do
    (Components[i] as TChangeNotifier).Notify(Sender);
end;

{ TChangeNotifier }

constructor TChangeNotifier.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := AllocateHwnd(WndProc);
end;

destructor TChangeNotifier.Destroy;
begin
  DeallocateHWnd(FHandle);
  inherited Destroy;
end;

procedure TChangeNotifier.WndProc(var Message: TMessage);
begin
  try
    Dispatch(Message);
  except
    Application.HandleException(Self);
  end;
end;

procedure TChangeNotifier.Notify(Sender: TObject);
begin
  if GetCurrentThreadID <> MainThreadID then
    PostMessage(FHandle, WM_CHANGE_NOTIFICATION, 0, 0)
  else
    DoNotify;
end;

procedure TChangeNotifier.WMChangeNotification(var Msg: TMessage);
begin
  DoNotify;
end;

procedure TChangeNotifier.DoNotify;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;


end.
