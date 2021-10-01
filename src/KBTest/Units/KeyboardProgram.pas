unit KeyboardProgram;

interface

Uses
  // VCL
  Classes;

type
  TKeyboardProgram = class;

  { TKeyboardProgramRec }

  TKeyboardProgramRec = record
    ModelID: Integer;
    FileName: string;
  end;

  { TKeyboardPrograms }

  TKeyboardPrograms = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TKeyboardProgram;
    procedure InsertItem(AItem: TKeyboardProgram);
    procedure RemoveItem(AItem: TKeyboardProgram);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function ItemByModel(Model: Integer): TKeyboardProgram;
    function Add(const AData: TKeyboardProgramRec): TKeyboardProgram;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TKeyboardProgram read GetItem; default;
  end;

  { TKeyboardProgram }

  TKeyboardProgram = class
  private
    FOwner: TKeyboardPrograms;
    FData: TKeyboardProgramRec;
    procedure SetOwner(AOwner: TKeyboardPrograms);
  public
    constructor Create(AOwner: TKeyboardPrograms; const AData: TKeyboardProgramRec);
    destructor Destroy; override;

    property ModelID: Integer read FData.ModelID;
    property FileName: string read FData.FileName;
  end;

implementation

{ TKeyboardPrograms }

constructor TKeyboardPrograms.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TKeyboardPrograms.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TKeyboardPrograms.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TKeyboardPrograms.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TKeyboardPrograms.GetItem(Index: Integer): TKeyboardProgram;
begin
  Result := FList[Index];
end;

procedure TKeyboardPrograms.InsertItem(AItem: TKeyboardProgram);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TKeyboardPrograms.RemoveItem(AItem: TKeyboardProgram);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TKeyboardPrograms.Add(
  const AData: TKeyboardProgramRec): TKeyboardProgram;
begin
  Result := TKeyboardProgram.Create(Self, AData);
end;

function TKeyboardPrograms.ItemByModel(Model: Integer): TKeyboardProgram;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := items[i];
    if Result.ModelID = Model then Exit;
  end;
  Result := nil;
end;

{ TKeyboardProgram }

constructor TKeyboardProgram.Create(AOwner: TKeyboardPrograms;
  const AData: TKeyboardProgramRec);
begin
  inherited Create;
  FData := AData;
  SetOwner(AOwner);
end;

destructor TKeyboardProgram.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TKeyboardProgram.SetOwner(AOwner: TKeyboardPrograms);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
