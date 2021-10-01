unit KeyboardDevice;

interface

Uses
  // VCL
  Classes, SysUtils,
  // This
  KeyboardTypes;


type
  { TKeyboardDevices }

  TKeyboardDevices = class
  private
    FList: TInterfaceList;
    function GetCount: Integer;
    function GetItem(Index: Integer): IKeyboardDevice;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(AItem: IKeyboardDevice);
    procedure Remove(AItem: IKeyboardDevice);
    function ItemByID(const ID: Integer): IKeyboardDevice;
    function ItemByName(const Name: string): IKeyboardDevice;
    function ItemByUniqueName(const Name: string): IKeyboardDevice;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: IKeyboardDevice read GetItem; default;
  end;

  { EKeyboardException }

  EKeyboardException = class(Exception);

procedure RaiseNoConnectionError;

implementation

resourcestring
  MsgNoConnection = 'Keyboard not connected';

procedure RaiseNoConnectionError;
begin
  raise EKeyboardException.Create(MsgNoConnection);
end;

{ TKeyboardDevices }

constructor TKeyboardDevices.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

destructor TKeyboardDevices.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TKeyboardDevices.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TKeyboardDevices.GetItem(Index: Integer): IKeyboardDevice;
begin
  Result := FList[Index] as IKeyboardDevice;
end;

procedure TKeyboardDevices.Add(AItem: IKeyboardDevice);
begin
  FList.Add(AItem);
end;

procedure TKeyboardDevices.Remove(AItem: IKeyboardDevice);
begin
  FList.Remove(AItem);
end;

procedure TKeyboardDevices.Clear;
begin
  FList.Clear;
  LastDeviceID := 0;
end;

function TKeyboardDevices.ItemByID(const ID: Integer): IKeyboardDevice;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.ID = ID then Exit;
  end;
  Result := nil;
end;

function TKeyboardDevices.ItemByName(const Name: string): IKeyboardDevice;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if AnsiCompareText(Result.Name, Name) = 0 then Exit;
  end;
  Result := nil;
end;

function TKeyboardDevices.ItemByUniqueName(
  const Name: string): IKeyboardDevice;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if AnsiCompareText(Result.UniqueName, Name) = 0 then Exit;
  end;
  Result := nil;
end;

end.
