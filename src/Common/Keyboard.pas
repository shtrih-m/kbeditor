unit Keyboard;

interface

Uses
  // VCL
  Classes, SysUtils, Dialogs, 
  // This
  Utils;

type
  TKeyDef = class;
  TKeyDefs = class;
  TKeyboard = class;
  TKeyboardParams = class;

  { TKeyboards }

  TKeyboards = class(TComponent)
  private
    function GetCount: Integer;
    function GetItem(Index: Integer): TKeyboard;
  public
    procedure Clear;
    function Add: TKeyboard;
    procedure CheckIndex(Value : Integer);
    function ItemByID(ID: Integer): TKeyboard;
    function ValidIndex(Value: Integer): Boolean;
    function FindItemByID(ID: Integer): TKeyboard;
    function ItemByText(const Text: string): TKeyboard;
    function FindItemByText(const Text: string): TKeyboard;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TKeyboard read GetItem; default;
  end;

  { TKeyboard }

  TKeyboard = class(TComponent)
  private
    FID: Integer;               // Unique identifier, ID
    FText: string;              // Model name
    FColCount: Integer;         // Columns count
    FRowCount: Integer;         // Row count
    FPosCount: Integer;         // Key position count
    FLayerCount: Integer;       // Layer count
    FHasLeds: Boolean;          // Is keyboard has leds ?
    FHasKey: Boolean;           // Is keyboard has keys ?
    FHasMSR: Boolean;           // Is MSR istalled ?
    FHasMSRTrack1: Boolean;     // Is MSR supports track 1?
    FHasMSRTrack2: Boolean;     // Is MSR supports track 2?
    FHasMSRTrack3: Boolean;     // Is MSR supports track 3?
    FGroupName: string;         // Device group name
    FKeyDefs: TKeyDefs;         // Key definitions
    FInterfaceType: string;     // Keyboard interface type
    FParams: TKeyboardParams;   // Keyboard parameters
    FFWFileName: string;        // Program file
    FModelID: Integer;
    FKeyCount: Integer;

    function GetIndex: Integer;
    procedure SetParams(const Value: TKeyboardParams);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear;
    function IsInterfaceUSB: Boolean;
    procedure Assign(Source: TPersistent); override;

    property Index: Integer read GetIndex;
    property ID: Integer read FID write FID;
    property KeyDefs: TKeyDefs read FKeyDefs;
    property Text: string read FText write FText;
    property HasMSR: Boolean read FHasMSR write FHasMSR;
    property HasKey: Boolean read FHasKey write FHasKey;
    property ModelID: Integer read FModelID write FModelID;
    property HasLeds: Boolean read FHasLeds write FHasLeds;
    property ColCount: Integer read FColCount write FColCount;
    property RowCount: Integer read FRowCount write FRowCount;
    property PosCount: Integer read FPosCount write FPosCount;
    property KeyCount: Integer read FKeyCount write FKeyCount;
    property GroupName: string read FGroupName write FGroupName;
    property FWFileName: string read FFWFileName write FFWFileName;
    property Params: TKeyboardParams read FParams write SetParams;
    property LayerCount: Integer read FLayerCount write FLayerCount;
    property HasMSRTrack1: Boolean read FHasMSRTrack1 write FHasMSRTrack1;
    property HasMSRTrack2: Boolean read FHasMSRTrack2 write FHasMSRTrack2;
    property HasMSRTrack3: Boolean read FHasMSRTrack3 write FHasMSRTrack3;
    property InterfaceType: string read FInterfaceType write FInterfaceType;
  end;

  TKeyboardParam = class;

  { TKeyboardParams }

  TKeyboardParams = class
  private
    FList: TList;
    function GetCount: Integer;
    procedure InsertItem(AItem: TKeyboardParam);
    procedure RemoveItem(AItem: TKeyboardParam);
    function GetItem(Index: Integer): TKeyboardParam;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function Add: TKeyboardParam;
    procedure Assign(Src: TKeyboardParams);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TKeyboardParam read GetItem; default;
  end;

  { TKeyboardParam }

  TKeyboardParam = class
  private
    FText: string;
    FValue: string;
    FOwner: TKeyboardParams;
    FItems: TKeyboardParams;
    procedure SetOwner(AOwner: TKeyboardParams);
  public
    constructor Create(AOwner: TKeyboardParams);
    destructor Destroy; override;

    function IsGroup: Boolean;
    procedure Assign(Src: TKeyboardParam);

    property Items: TKeyboardParams read FItems;
    property Text: string read FText write FText;
    property Value: string read FValue write FValue;
  end;

  { TKeyDefs }

  TKeyDefs = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TKeyDef;
    procedure InsertItem(AItem: TKeyDef);
    procedure RemoveItem(AItem: TKeyDef);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add: TKeyDef;
    procedure Assign(Src: TKeyDefs);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TKeyDef read GetItem; default;
  end;

  { TKeyDef }

  TKeyDef = class
  private
    FOwner: TKeyDefs;
    FTop: Integer;
    FLeft: Integer;
    FLogicNumber: Integer;
    procedure Assign(Src: TKeyDef);
    procedure SetOwner(AOwner: TKeyDefs);
  public
    constructor Create(AOwner: TKeyDefs);
    destructor Destroy; override;

    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property LogicNumber: Integer read FLogicNumber write FLogicNumber;
  end;

implementation

resourcestring
  MsgInvalidKeyboardIndex = 'Invalid keyboard index';
  MsgKeyboardNotFound  = 'Keyboard description not found';

{ TKeyboards }

procedure TKeyboards.Clear;
begin
  DestroyComponents;
end;

function TKeyboards.GetCount: Integer;
begin
  Result := ComponentCount;
end;

function TKeyboards.GetItem(Index: Integer): TKeyboard;
begin
  Result := Components[Index] as TKeyboard;
end;

function TKeyboards.Add: TKeyboard;
begin
  Result := TKeyboard.Create(Self);
end;

function TKeyboards.FindItemByID(ID: Integer): TKeyboard;
var
  i: Integer;
begin
  for i := 0 to Count -1 do
  begin
    Result := Items[i];
    if Result.ID = ID then Exit;
  end;
  Result := nil;
end;

function TKeyboards.FindItemByText(const Text: string): TKeyboard;
var
  i: Integer;
begin
  for i := 0 to Count -1 do
  begin
    Result := Items[i];
    if AnsiCompareText(Result.Text, Text) = 0 then Exit;
  end;
  Result := nil;
end;

function TKeyboards.ItemByText(const Text: string): TKeyboard;
begin
  Result := FindItemByText(Text);
  if Result = nil then
    raise Exception.CreateFmt('%s, Text="%s"', [MsgKeyboardNotFound, Text]);
end;

function TKeyboards.ItemByID(ID: Integer): TKeyboard;
begin
  Result := FindItemByID(ID);
  if Result = nil then
    raise Exception.CreateFmt('%s, ID="%d"', [MsgKeyboardNotFound, ID]);
end;

{ TKeyboard }

procedure TKeyboard.Clear;
begin
  KeyDefs.Clear;
  Params.Clear;
  FText := '';
  FColCount := 0;
  FRowCount := 0;
  FPosCount := 0;
  FLayerCount := 0;
  FHasMSRTrack1 := False;
  FHasMSRTrack2 := False;
  FHasMSRTrack3 := False;
  FHasMSR := False;
end;

procedure TKeyboard.Assign(Source: TPersistent);
var
  Src: TKeyboard;
begin
  if Source is TKeyboard then
  begin
    Src := Source as TKeyboard;

    FText := Src.Text;
    FGroupName := Src.GroupName;
    FID := Src.ID;
    FColCount := Src.ColCount;
    FRowCount := Src.RowCount;
    FPosCount := Src.PosCount;
    FLayerCount := Src.LayerCount;
    FHasMSRTrack1 := Src.HasMSRTrack1;
    FHasMSRTrack2 := Src.HasMSRTrack2;
    FHasMSRTrack3 := Src.HasMSRTrack3;
    FHasMSR := Src.HasMSR;
    Params := Src.Params;
    HasLeds := Src.HasLeds;
    KeyCount := Src.KeyCount;

    KeyDefs.Assign(Src.KeyDefs);
  end else
    inherited Assign(Source);
end;

constructor TKeyboard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FKeyDefs := TKeyDefs.Create;
  FParams := TKeyboardParams.Create;
  FHasKey := True;
  FHasLeds := True;
end;

destructor TKeyboard.Destroy;
begin
  FParams.Free;
  FKeyDefs.Free;
  inherited Destroy;
end;

function TKeyboard.GetIndex: Integer;
begin
  Result := ComponentIndex;
end;

function TKeyboard.IsInterfaceUSB: Boolean;
begin
  Result := AnsiCompareText(InterfaceType, 'USB') = 0;
end;

function TKeyboards.ValidIndex(Value: Integer): Boolean;
begin
  Result := (Value >= 0)and(Value < Count);
end;

procedure TKeyboards.CheckIndex(Value: Integer);
begin
  if not ValidIndex(Value) then
    raise Exception.Create(MsgInvalidKeyboardIndex);
end;

{ TKeyboardParams }

constructor TKeyboardParams.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TKeyboardParams.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TKeyboardParams.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TKeyboardParams.GetItem(Index: Integer): TKeyboardParam;
begin
  Result := FList[Index];
end;

procedure TKeyboardParams.InsertItem(AItem: TKeyboardParam);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TKeyboardParams.RemoveItem(AItem: TKeyboardParam);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TKeyboardParams.Add: TKeyboardParam;
begin
  Result := TKeyboardParam.Create(Self);
end;

procedure TKeyboardParams.Assign(Src: TKeyboardParams);
var
  i: Integer;
begin
  Clear;
  for i := 0 to Src.Count-1 do
    Add.Assign(Src[i]);
end;

procedure TKeyboardParams.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

{ TKeyboardParam }

constructor TKeyboardParam.Create(AOwner: TKeyboardParams);
begin
  inherited Create;
  FItems := TKeyboardParams.Create;
  SetOwner(AOwner);
end;

destructor TKeyboardParam.Destroy;
begin
  SetOwner(nil);
  FItems.Free;
  inherited Destroy;
end;

procedure TKeyboardParam.SetOwner(AOwner: TKeyboardParams);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TKeyboardParam.Assign(Src: TKeyboardParam);
begin
  FText := Src.Text;
  FValue := Src.Value;
end;

function TKeyboardParam.IsGroup: Boolean;
begin
  Result := Items.Count > 0;
end;

{ TKeyDefs }

constructor TKeyDefs.Create;
begin
   inherited Create;
  FList := TList.Create;
end;

destructor TKeyDefs.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TKeyDefs.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TKeyDefs.GetCount: Integer;
begin
  if FList = nil then
    Result := 0
  else
    Result := FList.Count;
end;

function TKeyDefs.GetItem(Index: Integer): TKeyDef;
begin
  Result := FList[Index];
end;

procedure TKeyDefs.InsertItem(AItem: TKeyDef);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TKeyDefs.RemoveItem(AItem: TKeyDef);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

procedure TKeyDefs.Assign(Src: TKeyDefs);
var
  i: Integer;
begin
  Clear;
  for i := 0 to Src.Count-1 do
    Add.Assign(Src[i]);
end;

function TKeyDefs.Add: TKeyDef;
begin
  Result := TKeyDef.Create(Self);
end;

{ TKeyDef }

constructor TKeyDef.Create(AOwner: TKeyDefs);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TKeyDef.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TKeyDef.SetOwner(AOwner: TKeyDefs);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TKeyDef.Assign(Src: TKeyDef);
begin
  FTop := Src.Top;
  FLeft := Src.Left;
  FLogicNumber := Src.LogicNumber;
end;

procedure TKeyboard.SetParams(const Value: TKeyboardParams);
begin
  Params.Assign(Value);
end;

end.
