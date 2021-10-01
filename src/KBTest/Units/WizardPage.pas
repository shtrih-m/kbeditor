unit WizardPage;

interface

Uses
  // VCL
  Windows, SysUtils, Classes,
  // This
  SizeableForm;

type
  TWizardPage = class;

  { TWizardPages }

  TWizardPages = class
  private
    FList: TList;
    function GetCount: Integer;
    procedure InsertItem(AItem: TWizardPage);
    procedure RemoveItem(AItem: TWizardPage);
    function GetItem(Index: Integer): TWizardPage;
    function GetItemIndex(AItem: TWizardPage): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TWizardPage read GetItem; default;
  end;

  { TWizardPage }

  TWizardPage = class(TSizeableForm)
  private
    FOwner: TWizardPages;
    function GetIndex: Integer;
  public
    ActionText: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Stop; virtual;
    procedure Start; virtual;
    procedure Cancel; virtual;
    function IsValid: Boolean; virtual;
    procedure SetOwner(AOwner: TWizardPages);

    property Index: Integer read GetIndex;
  end;
  TWizardPageClass = class of TWizardPage;

implementation

{ TWizardPages }

constructor TWizardPages.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TWizardPages.Destroy;
begin
  while Count > 0 do
    Items[0].Free;
  FList.Free;
  inherited Destroy;
end;

function TWizardPages.GetCount: Integer;
begin
  if FList = nil then
    Result := 0
  else
    Result := FList.Count;
end;

function TWizardPages.GetItem(Index: Integer): TWizardPage;
begin
  Result := FList[Index];
end;

function TWizardPages.GetItemIndex(AItem: TWizardPage): Integer;
begin
  Result := FList.IndexOf(AItem);
end;

procedure TWizardPages.InsertItem(AItem: TWizardPage);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TWizardPages.RemoveItem(AItem: TWizardPage);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

{ TWizardPage }

constructor TWizardPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ActionText := 'Для продолжения нажмите кнопку "Далее"';
end;

destructor TWizardPage.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TWizardPage.SetOwner(AOwner: TWizardPages);
begin
  if FOwner <> nil then FOwner.RemoveItem(Self);
  if AOwner <> nil then AOwner.InsertItem(Self);
end;

function TWizardPage.GetIndex: Integer;
begin
  Result := FOwner.GetItemIndex(Self);
end;

procedure TWizardPage.Start;
begin

end;

procedure TWizardPage.Stop;
begin

end;

procedure TWizardPage.Cancel;
begin

end;

function TWizardPage.IsValid: Boolean;
begin
  Result := True;
end;

end.

