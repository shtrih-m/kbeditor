unit LayoutMessage;

interface

uses
  // VCL
  Classes, SyncObjs;

type
  TLayoutMessage = class;
  TLayoutMessages = class;

  { TLayoutMessages }

  TLayoutMessages = class
  private
    FList: TList;
    FLock: TCriticalSection;
    function GetCount: Integer;
    procedure InsertItem(AItem: TLayoutMessage);
    procedure RemoveItem(AItem: TLayoutMessage);
    function GetItem(Index: Integer): TLayoutMessage;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Lock;
    procedure Unlock;
    procedure Delete(Index: Integer);
    function ValidIndex(Index: Integer): Boolean;
    function Add(LayoutID, ItemID: Integer; const Text: string): TLayoutMessage;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TLayoutMessage read GetItem; default;
  end;

  { TLayoutMessage }

  TLayoutMessage = class
  private
    FID: Integer;
    FText: string;
    FItemID: Integer;
    FLayoutID: Integer;
    FOwner: TLayoutMessages;
    procedure SetOwner(AOwner: TLayoutMessages);
  public
    constructor Create(AOwner: TLayoutMessages; ALayoutID, AItemID: Integer;
      const AText: string);
    destructor Destroy; override;


    property ID: Integer read FID;
    property Text: string read FText;
    property ItemID: Integer read FItemID;
    property LayoutID: Integer read FLayoutID;
  end;

implementation

{ TLayoutMessages }

constructor TLayoutMessages.Create;
begin
  inherited Create;
  FList := TList.Create;
  FLock := TCriticalSection.Create;
end;

destructor TLayoutMessages.Destroy;
begin
  Clear;
  FList.Free;
  FLock.Free;
  inherited Destroy;
end;

function TLayoutMessages.Add(LayoutID, ItemID: Integer;
  const Text: string): TLayoutMessage;
begin
  Result := TLayoutMessage.Create(Self, LayoutID, ItemID, Text);
end;

function TLayoutMessages.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TLayoutMessages.GetItem(Index: Integer): TLayoutMessage;
begin
  Result := FList[Index];
end;

procedure TLayoutMessages.InsertItem(AItem: TLayoutMessage);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TLayoutMessages.RemoveItem(AItem: TLayoutMessage);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TLayoutMessages.ValidIndex(Index: Integer): Boolean;
begin
  Result := (Index >= 0)and(Index < Count);
end;

procedure TLayoutMessages.Clear;
begin
  while Count > 0 do
    Items[0].Free;
end;

procedure TLayoutMessages.Lock;
begin
  FLock.Enter;
end;

procedure TLayoutMessages.Unlock;
begin
  FLock.Leave;
end;

procedure TLayoutMessages.Delete(Index: Integer);
begin
  if ValidIndex(Index) then
    Items[Index].Free;
end;

{ TLayoutMessage }

constructor TLayoutMessage.Create(AOwner: TLayoutMessages;
  ALayoutID, AItemID: Integer; const AText: string);
const
  LastID: Integer = 0;
begin
  inherited Create;
  Inc(LastID); FID := LastID;
  FLayoutID := ALayoutID;
  FItemID := AItemID;
  FText := AText;
  SetOwner(AOwner);
end;

destructor TLayoutMessage.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TLayoutMessage.SetOwner(AOwner: TLayoutMessages);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;


end.
