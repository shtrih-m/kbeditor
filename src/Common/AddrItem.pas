unit AddrItem;

interface

uses
  // VCL
  Classes;

type
  TAddrItem = class;

  { TAddrItems }

  TAddrItems = class
  private
    FList: TList;
    function GetCount: Integer;
    procedure InsertItem(AItem: TAddrItem);
    procedure RemoveItem(AItem: TAddrItem);
    function GetItem(Index: Integer): TAddrItem;
  public
    destructor Destroy; override;

    procedure Clear;
    function Add: TAddrItem;
    function Find(ACol, ARow: Integer): TAddrItem;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TAddrItem read GetItem; default;
  end;

  { TAddrItem }

  TAddrItem = class
  private
    FCol: Integer;
    FRow: Integer;
    FOwner: TAddrItems;
    FAddress: Word;
    procedure SetOwner(AOwner: TAddrItems);
  public
    constructor Create(AOwner: TAddrItems);
    destructor Destroy; override;

    property Col: Integer read FCol write FCol;
    property Row: Integer read FRow write FRow;
    property Address: Word read FAddress write FAddress;
  end;

implementation

{ TAddrItems }

destructor TAddrItems.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TAddrItems.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TAddrItems.GetCount: Integer;
begin
  if FList = nil then
    Result := 0
  else
    Result := FList.Count;
end;

function TAddrItems.GetItem(Index: Integer): TAddrItem;
begin
  Result := FList[Index];
end;

procedure TAddrItems.InsertItem(AItem: TAddrItem);
begin
  if FList = nil then FList := TList.Create;
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TAddrItems.RemoveItem(AItem: TAddrItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
  if FList.Count = 0 then
  begin
    FList.Free;
    FList := nil;
  end;
end;

function TAddrItems.Add: TAddrItem;
begin
  Result := TAddrItem.Create(Self);
end;

function TAddrItems.Find(ACol, ARow: Integer): TAddrItem;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if (Result.Col = ACol)and(Result.Row = ARow) then Exit;
  end;
  Result := nil;
end;

{ TAddrItem }

constructor TAddrItem.Create(AOwner: TAddrItems);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TAddrItem.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TAddrItem.SetOwner(AOwner: TAddrItems);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

end.
