unit Page;

interface

Uses
  // VCL
  Messages, Classes, SysUtils, Forms, Controls, ComObj,
  // This
  SizeableForm;

type
  TPage = class;

  { TPages }

  TPages = class
  private
    FList: TList;
    procedure Clear;
    function GetCount: Integer;
    procedure InsertItem(AItem: TPage);
    procedure RemoveItem(AItem: TPage);
    function GetItem(Index: Integer): TPage;
    function GetItemIndex(AItem: TPage): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPage read GetItem; default;
  end;

  { TPage }

  TPage = class(TSizeableForm)
  private
    FOwner: TPages;
    function GetIndex: Integer;
  public
    ActionText: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetOwner(AOwner: TPages);

    procedure UpdatePage; virtual;
    procedure UpdateObject; virtual;

    property Index: Integer read GetIndex;
  end;
  TPageClass = class of TPage;

implementation

resourcestring
  MsgNextPage   = 'Press "Next" button to continue';

{ TPages }

constructor TPages.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPages.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TPages.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TPages.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPages.GetItem(Index: Integer): TPage;
begin
  Result := FList[Index];
end;

function TPages.GetItemIndex(AItem: TPage): Integer;
begin
  Result := FList.IndexOf(AItem);
end;

procedure TPages.InsertItem(AItem: TPage);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPages.RemoveItem(AItem: TPage);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

{ TPage }

constructor TPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ActionText := MsgNextPage;
end;

destructor TPage.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TPage.SetOwner(AOwner: TPages);
begin
  if FOwner <> nil then FOwner.RemoveItem(Self);
  if AOwner <> nil then AOwner.InsertItem(Self);
end;

function TPage.GetIndex: Integer;
begin
  Result := FOwner.GetItemIndex(Self);
end;

procedure TPage.UpdatePage;
begin

end;

procedure TPage.UpdateObject;
begin

end;

end.

