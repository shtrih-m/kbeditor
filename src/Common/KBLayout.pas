unit KBLayout;

interface

uses
  // VCL
  Windows, Messages, Classes, SysUtils, Graphics, Clipbrd,
  // This
  GridType, Utils, Keyboard, LogMessage, LogFile, AppSettings,
  StringUtils;

type
  TKey = class;
  TMSR = class;
  TKeys = class;
  TLayer = class;
  TLayers = class;
  TKeyList = class;
  TKeyLock = class;
  TKBLayout = class;
  TKeyGroup = class;
  TMSRTrack = class;            
  TMSRTracks = class;           
  TKeyGroups = class;           
  TKeyPosition = class;         
  TScrollWheel = class;         
  TWheelItem = class;           //
  TNotes = class;               
  TNote = class;
  TIButtonKey = class;
  TIButtonKeys = class;
  TIButton = class;
  TScanCode = class;
  TScanCodes = class;
  TKeyPicture = class;
  TPressCodes = class;
  TKBLayoutLink = class;

  TCodeType = (ctMake, ctBreak, ctRaw);

  { TKeyboardRec }

  TKeyType = (
    ktNone,
    ktMacros,           
    ktGoUp,             
    ktGoDown,           
    ktGo1,              
    ktGo2,              
    ktGo3,              
    ktGo4,              
    ktTemp1,            
    ktTemp2,            
    ktTemp3,            
    ktTemp4             
    );

  { TCheckResult }

  TCheckResult = record
    ErrCount: Integer;
  end;

  { TFindResult }

  TFindResult = record
    MatchCount: Integer;
  end;

  { TMComponent }

  TMComponent = class(TComponent)
  private
    FID: Integer;
    FCaption: string;
    FIsModified: Boolean;
    FOnChange: TNotifyEvent;
    FUpdateLockCount: Integer;

    function GetPath: string;
    function GetCount: Integer;
    function GetItem(Index: Integer): TMComponent;
    function AddPathSeparator(const S: string): string;
  protected
    procedure Changed; virtual;
    function CheckItem(var CheckResult: TCheckResult): Boolean; virtual;
    procedure FindData(const Data: string; var FR: TFindResult); virtual;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure ReplaceData(const Data, ReplaceTo: string; var FR: TFindResult); virtual;
  public
    constructor Create(AOwner: TComponent); override;

    procedure EndUpdate;
    procedure BeginUpdate;
    procedure Modified;
    procedure NotifyModified;
    procedure Clear; virtual;
    procedure ClearModified;
    function CheckData: Boolean;
    function GetCaption: string; virtual;
    function Find(const Data: string): Integer;
    function ItemByID(AID: Integer): TMComponent;
    function Replace(const Data, ReplaceTo: string): Integer;

    property ID: Integer read FID;
    property Path: string read GetPath;
    property Count: Integer read GetCount;
    property IsModified: Boolean read FIsModified;
    property Caption: string read GetCaption write FCaption;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Items[Index: Integer]: TMComponent read GetItem; default;
  end;

  { TKBLayouts }

  TKBLayouts = class(TComponent)
  private
    function GetCount: Integer;
    function GetItem(Index: Integer): TKBLayout;
  public
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TKBLayout read GetItem; default;
  end;

  TKBLayoutEvent = (leChanged);

  { TKBLayout }

  TKBLayout = class(TMComponent)
  private
    FLinks: TList;
    FLayers: TLayers;
    FFileName: string;
    FKeyCount: Integer;
    FSelection: TGridRect;
    FKeyGroups: TKeyGroups;
    FSelectedKeys: TKeyList;
    FKeyboard: TKeyboard;
    FDeviceVersion: Word;
    FLayerIndex: Integer;

    procedure DoDeleteKey(Key: TKey);
    procedure SetSelection(const Value: TGridRect);
    procedure SetLayers(const Value: TLayers);
    procedure SetKeyGroups(const Value: TKeyGroups);
    function GetHasMSRTrack1: Boolean;
    function GetHasMSRTrack2: Boolean;
    function GetHasMSRTrack3: Boolean;
    function GetColCount: Integer;
    function GetRowCount: Integer;
    function GetKeyboardID: Integer;
    function GetHasKey: Boolean;
    function GetHasMSR: Boolean;
    procedure SetKeyboard(Value: TKeyboard);
    function IsKeySelected(Key: TKey): Boolean;
    procedure CheckCanGroup;
    function GetSelectionText: string;
    function GetPicture: TPicture;
    procedure CreateKeys(Keys: TKeys; AKeyboard: TKeyboard);
    function GetKeyboard: TKeyboard;
    procedure SetDeviceVersion(const Value: Word);
    procedure RemoveLink(Link: TKBLayoutLink);
    procedure AddLink(Link: TKBLayoutLink);
    procedure SetLayerIndex(const Value: Integer);
  public
    FileVersion: Word;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Changed; override;
    procedure ResetKeys;
    procedure GroupKeys;
    procedure SelectAll;
    procedure UpdateKeys;
    procedure UngroupKeys;
    procedure UpdateLayout;
    procedure Clear; override;
    procedure ClearSelection;
    procedure DeleteSelection;
    function GetLayer: TLayer;
    function CanSave: Boolean;
    function CanPaste: Boolean;
    function CanGroup: Boolean;
    function CanUngroup: Boolean;
    procedure UpdateSelectedKeys;
    procedure SelectKey(Key: TKey);
    procedure SetKey(SrcKey, DstKey: TKey);
    procedure Saved(const AFileName: string);
    function GetGroup(ACol, ARow: Integer): TKeyGroup;
    procedure Assign(Source: TPersistent); override;
    procedure SetKeyType(Col, Row: Integer; Value: TKeyType);
    function CanSelect(Col, Row: Integer): Boolean;
    procedure SelectItem(ItemID: Integer);
    function IsSingleSelection: Boolean;

    property Layer: TLayer read GetLayer;
    property HasKey: Boolean read GetHasKey;
    property HasMSR: Boolean read GetHasMSR;
    property FileName: string read FFileName;
    property Picture: TPicture read GetPicture;
    property ColCount: Integer read GetColCount;
    property RowCount: Integer read GetRowCount;
    property KeyboardID: Integer read GetKeyboardID;
    property SelectedKeys: TKeyList read FSelectedKeys;
    property HasMSRTrack1: Boolean read GetHasMSRTrack1;
    property HasMSRTrack2: Boolean read GetHasMSRTrack2;
    property HasMSRTrack3: Boolean read GetHasMSRTrack3;
    property SelectionText: string read GetSelectionText;
    property Selection: TGridRect read FSelection write SetSelection;
    property Keyboard: TKeyboard read GetKeyboard write SetKeyboard;
    property DeviceVersion: Word read FDeviceVersion write SetDeviceVersion;
    property LayerIndex: Integer read FLayerIndex write SetLayerIndex;
    property KeyCount: Integer read FKeyCount write FKeyCount;
  published
    property Layers: TLayers read FLayers write SetLayers;
    property KeyGroups: TKeyGroups read FKeyGroups write SetKeyGroups;
  end;

  { TKBLayoutLink }

  TKBLayoutLink = class
  private
    FLayout: TKBLayout;
    FOnChange: TNotifyEvent;

    procedure Changed;
    procedure SetLayout(const ALayout: TKBLayout);
  public
    destructor Destroy; override;

    property Layout: TKBLayout read FLayout write SetLayout;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TLayers }

  TLayers = class(TMComponent)
  private
    function Add: TLayer;
    function GetCount: Integer;
    function GetItem(Index: Integer): TLayer;
    procedure CheckLayerCount(Value: Integer);
  public
    procedure Clear; override;
    procedure SetCount(Value: Integer);
    function ValidIndex(Index: Integer): Boolean;
    procedure Assign(Source: TPersistent); override;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TLayer read GetItem; default;
  end;

  { TLayer }

  TLayer = class(TMComponent)
  private
    FMSR: TMSR;                 
    FKeys: TKeys;               
    FKeyLock: TKeyLock;         
    FIButton: TIButton;         
    FScrollWheel: TScrollWheel;

    procedure SetIButton(const Value: TIButton);
    procedure SetKeyLock(const Value: TKeyLock);
    procedure SetKeys(const Value: TKeys);
    procedure SetMSR(const Value: TMSR);
    procedure SetScrollWheel(const Value: TScrollWheel);
    function GetIndex: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    function GetKey(ACol, ARow: Integer): TKey;
    function FindKey(ACol, ARow: Integer): TKey;

    property Index: Integer read GetIndex;
    property MSR: TMSR read FMSR write SetMSR;
    property Keys: TKeys read FKeys write SetKeys;
    property KeyLock: TKeyLock read FKeyLock write SetKeyLock;
    property IButton: TIButton read FIButton write SetIButton;
    property ScrollWheel: TScrollWheel read FScrollWheel write SetScrollWheel;
  end;

  { TKeys }

  TKeys = class(TMComponent)
  private
    function GetCount: Integer;
    function GetItem(Index: Integer): TKey;
  public
    procedure Clear; override;
    function Add: TKey; overload;
    procedure CopyKeysByNumbers(SrcKeys: TKeys);
    function FindItem(ACol, ARow: Integer): TKey;
    function ItemByNumber(Number: Integer): TKey;
    procedure Assign(Source: TPersistent); override;
    function Add(ACol, ARow, ANumber: Integer): TKey; overload;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TKey read GetItem; default;
  end;

  { TKey }

  TKey = class(TMComponent)
  private
    FText: string;
    FCol: Integer;
    FRow: Integer;
    FNotes: TNotes;                     
    FNumber: Integer;
    FPressed: Boolean;
    FMasterKey: TKey;
    FKeyType: TKeyType;
    FRepeatKey: Boolean;                
    FPicture: TKeyPicture;
    FPressCodes: TScanCodes;            
    FReleaseCodes: TScanCodes;          
    FLayerIndex: Integer;               
    FAddress: Word;

    procedure SetNotes(const Value: TNotes);
    procedure SetNumber(const Value: Integer);
    procedure SetKeyType(const Value: TKeyType);
    procedure SetPicture(const Value: TKeyPicture);
    procedure SetPressCodes(const Value: TScanCodes);
    procedure SetReleaseCodes(const Value: TScanCodes);
  protected
    function CheckItem(var CheckResult: TCheckResult): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Clear; override;
    function GetCaption: string; override;
    procedure AssignKey(Source: TPersistent);
    procedure Assign(Source: TPersistent); override;
    function InSelection(Selection: TGridRect): Boolean;
    property LayerIndex: Integer read FLayerIndex write FLayerIndex;
    class function GetKeyCaption(ACol, ARow: Integer): string;
  published
    property Col: Integer read FCol write FCol;
    property Row: Integer read FRow write FRow;
    property Text: string read FText write FText;
    property Notes: TNotes read FNotes write SetNotes;
    property Address: Word read FAddress write FAddress;
    property Number: Integer read FNumber write SetNumber;
    property Pressed: Boolean read FPressed write FPressed;
    property KeyType: TKeyType read FKeyType write SetKeyType;
    property MasterKey: TKey read FMasterKey write FMasterKey;
    property Picture: TKeyPicture read FPicture write SetPicture;
    property RepeatKey: Boolean read FRepeatKey write FRepeatKey;
    property PressCodes: TScanCodes read FPressCodes write SetPressCodes;
    property ReleaseCodes: TScanCodes read FReleaseCodes write SetReleaseCodes;
  end;

  { TKeyGroups }

  TKeyGroups = class(TMComponent)
  private
    function GetCount: Integer;
    function GetItem(Index: Integer): TKeyGroup;
  public
    function Add: TKeyGroup;
    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;
    function GetGroup(ACol, ARow: Integer): TKeyGroup;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TKeyGroup read GetItem; default;
  end;

  { TKeyGroup }

  TKeyGroup = class(TMComponent)
  private
    FRect: TGridRect;
  public
    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;
    function Intersect(const ARect: TGridRect): Boolean;
    function PointInRect(ACol, ARow: Integer): Boolean;
  published
    property Top: Longint read FRect.Top;
    property Left: Longint read FRect.Left;
    property Rect: TGridRect read FRect write FRect;
  end;

  { TMSR }

  TMSR = class(TMComponent)
  private
    FNotes: TNotes;
    FSendEnter: Boolean;
    FLockOnErr: Boolean;
    FTracks: TMSRTracks;
    FLightIndication: Boolean;
    FAddress: Word;

    procedure SetNotes(const Value: TNotes);
    procedure SetTracks(const Value: TMSRTracks);
  public
    constructor Create(AOwner: TComponent); override;

    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Notes: TNotes read FNotes write SetNotes;
    property Address: Word read FAddress write FAddress;
    property Tracks: TMSRTracks read FTracks write SetTracks;
    property SendEnter: Boolean read FSendEnter write FSendEnter;
    property LockOnErr: Boolean read FLockOnErr write FLockOnErr;
    property LightIndication: Boolean read FLightIndication write FLightIndication;
  end;

  { TMSRTracks }

  TMSRTracks = class(TMComponent)
  private
    function GetCount: Integer;
    function GetItem(Index: Integer): TMSRTrack;
  public
    procedure Clear; override;
    function Add: TMSRTrack;
    procedure Assign(Source: TPersistent); override;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TMSRTrack read GetItem; default;
  end;

  { TMSRTrack }

  TMSRTrack = class(TMComponent)
  private
    FEnabled: Boolean;
    FPrefix: TScanCodes;
    FSuffix: TScanCodes;

    procedure SetPrefix(const Value: TScanCodes);
    procedure SetSuffix(const Value: TScanCodes);
  protected
    function CheckItem(var CheckResult: TCheckResult): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Clear; override;
    procedure Assign(Source: Tpersistent); override;
  published
    property Enabled: Boolean read FEnabled write FEnabled;
    property Prefix: TScanCodes read FPrefix write SetPrefix;
    property Suffix: TScanCodes read FSuffix write SetSuffix;
  end;

  { TKeyLock }

  TKeyLock = class(TMComponent)
  private
    FAddress: Word;
    function GetCount: Integer;
    function GetItem(Index: Integer): TKeyPosition;
  public
    procedure Clear; override;
    function IsEmpty: Boolean;
    function Add: TKeyPosition;
    procedure SetCount(Value: Integer);
    procedure Assign(Source: TPersistent); override;

    property Count: Integer read GetCount;
    property Address: Word read FAddress write FAddress;
    property Items[Index: Integer]: TKeyPosition read GetItem; default;
  end;

  { TPosType }

  TPosType = (
    ptMacros,
    ptGo1,              
    ptGo2,              
    ptGo3,
    ptGo4);

  { TKeyPosition }

  TKeyPosition = class(TMComponent)
  private
    FNotes: TNotes;
    FPosType: TPosType;
    FCodes: TScanCodes;
    FLockEnabled: Boolean;
    FNcrEmulation: Boolean;
    FNixdorfEmulation: Boolean;

    procedure SetNotes(const Value: TNotes);
    procedure SetCodes(const Value: TScanCodes);
  protected
    function CheckItem(var CheckResult: TCheckResult): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
    function IsEmpty: Boolean;
  published
    property Notes: TNotes read FNotes write SetNotes;
    property Codes: TScanCodes read FCodes write SetCodes;
    property PosType: TPosType read FPosType write FPosType;
    property LockEnabled: Boolean read FLockEnabled write FLockEnabled;
    property NcrEmulation: Boolean read FNcrEmulation write FNcrEmulation;
    property NixdorfEmulation: Boolean read FNixdorfEmulation write FNixdorfEmulation;
  end;

  { TKeyList }

  TKeyList = class(TList)
  private
    function GetItem(Index: Integer): TKey;
  public
    property Items[Index: Integer]: TKey read GetItem; default;
  end;

  { TWheelItem }

  TWheelItem = class(TMComponent)
  private
    FNotes: TNotes;
    FCodes: TScanCodes;
    procedure SetNotes(const Value: TNotes);
    procedure SetCodes(const Value: TScanCodes);
  protected
    function CheckItem(var CheckResult: TCheckResult): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Clear; override;
    function IsEmpty: Boolean;
    procedure Assign(Source: TPersistent); override;
  published
    property Notes: TNotes read FNotes write SetNotes;
    property Codes: TScanCodes read FCodes write SetCodes;
  end;

  { TScrollWheel }

  TScrollWheel = class(TMComponent)
  private
    FAddress: Word;
    FScrollUp: TWheelItem;
    FScrollDown: TWheelItem;
    FSingleClick: TWheelItem;
    FDoubleClick: TWheelItem;

    procedure SetScrollUp(const Value: TWheelItem);
    procedure SetScrollDown(const Value: TWheelItem);
    procedure SetDoubleClick(const Value: TWheelItem);
    procedure SetSingleClick(const Value: TWheelItem);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear; override;
    function IsEmpty: Boolean;

    procedure Assign(Source: TPersistent); override;
  published
    property Address: Word read FAddress write FAddress;
    property ScrollUp: TWheelItem read FScrollUp write SetScrollUp;
    property ScrollDown: TWheelItem read FScrollDown write SetScrollDown;
    property SingleClick: TWheelItem read FSingleClick write SetSingleClick;
    property DoubleClick: TWheelItem read FDoubleClick write SetDoubleClick;
  end;

  { TNotes }

  TNotes = class(TMComponent)
  private
    function GetAsText: string;
    function GetItem(Index: Integer): TNote;
    function NameToNote(const NoteName: string; var Note: Byte): Boolean;
    procedure TextToNotes(const Text: string);
  public
    function Add: TNote;
    procedure Clear; override;
    function IsEmpty: Boolean;
    procedure SetAsText(const Text: string);
    procedure Assign(Source: TPersistent); override;

    property AsText: string read GetAsText write SetAsText;
    property Items[Index: Integer]: TNote read GetItem; default;
  published
    NotesClass: TNote;
  end;

  { TNote }

  TNote = class(TMComponent)
  private
    FNote: Byte;
    FVolume: Byte;
    FInterval: Byte;
    function GetDisplayText: string;
    procedure SetInterval(const Value: Byte);
    procedure SetNote(const Value: Byte);
    procedure SetVolume(const Value: Byte);
  public
    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;

    property DisplayText: string read GetDisplayText;
  published
    property Note: Byte read FNote write SetNote;
    property Volume: Byte read FVolume write SetVolume;
    property Interval: Byte read FInterval write SetInterval;
  end;

  TIButtonKeyType = (
    ctNone,
    ctGo1,              
    ctGo2,              
    ctGo3,              
    ctGo4);

  { TIButton }

  TIButton = class(TMComponent)
  private
    FNotes: TNotes;
    FSendCode: Boolean;
    FPrefix: TScanCodes;
    FSuffix: TScanCodes;
    FDefKey: TIButtonKey;
    FRegKeys: TIButtonKeys;
    FAddress: Word;

    procedure SetNotes(const Value: TNotes);
    procedure SetPrefix(const Value: TScanCodes);
    procedure SetSuffix(const Value: TScanCodes);
    procedure SetDefKey(const Value: TIButtonKey);
    procedure SetRegKeys(const Value: TIButtonKeys);
  protected
    function CheckItem(var CheckResult: TCheckResult): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Clear; override;
    function IsEmpty: Boolean;
    procedure Assign(Source: TPersistent); override;
  published
    property Notes: TNotes read FNotes write SetNotes;
    property Address: Word read FAddress write FAddress;
    property Prefix: TScanCodes read FPrefix write SetPrefix;
    property Suffix: TScanCodes read FSuffix write SetSuffix;
    property SendCode: Boolean read FSendCode write FSendCode;
    property RegKeys: TIButtonKeys read FRegKeys write SetRegKeys;
    property DefKey: TIButtonKey read FDefKey write SetDefKey;
  end;

  { TIButtonKeys }

  TIButtonKeys = class(TMComponent)
  private
    FMaxCount: Integer;

    function GetCount: Integer;
    function GetItem(Index: Integer): TIButtonKey;
    function ItemByHexNumber(const Value: string): TIButtonKey;
  public
    procedure Clear; override;
    function IsEmpty: Boolean;
    function Add: TIButtonKey;
    function AddItem: TIButtonKey;
    function ValidIndex(Index: Integer): Boolean;
    procedure Assign(Source: TPersistent); override;
    function IsFreeHexNumber(const Value: string): Boolean;
    function ItemByNumber(const ANumber: string): TIButtonKey;

    property Count: Integer read GetCount;
    property MaxCount: Integer read FMaxCount write FMaxCount;
    property Items[Index: Integer]: TIButtonKey read GetItem; default;
  end;

  { TIButtonKey }

  TIButtonKey = class(TMComponent)
  private
    FNotes: TNotes;
    FNumber: string;
    FCodes: TScanCodes;
    FRegistered: Boolean;
    FCodeType: TIButtonKeyType;
    function GetDisplayText: string;
    function GetNumberAsHex: string;
    procedure SetNotes(const Value: TNotes);
    procedure SetNumber(const Value: string);
    procedure CheckNumber(const Value: string);
    procedure SetCodes(const Value: TScanCodes);
    procedure SetNumberAsHex(const Value: string);
  protected
    function CheckItem(var CheckResult: TCheckResult): Boolean; override;
  public
    Address: Word;
    constructor Create(AOwner: TComponent); override;

    procedure Delete;
    procedure Clear; override;
    function IsEmpty: Boolean;
    function CanDelete: Boolean;
    procedure Assign(Source: TPersistent); override;
    property DisplayText: string read GetDisplayText;
    property NumberAsHex: string read GetNumberAsHex write SetNumberAsHex;
  published
    property Notes: TNotes read FNotes write SetNotes;
    property Number: string read FNumber write SetNumber;
    property Codes: TScanCodes read FCodes write SetCodes;
    property Registered: Boolean read FRegistered write FRegistered;
    property CodeType: TIButtonKeyType read FCodeType write FCodeType;
  end;

  EDataError = class(Exception);
  TKeyOption = (koMake, koBreak, koRepeat);
  TKeyOptions = set of TKeyOption;

  { TScanCodes }

  TScanCodes = class(TMComponent)
  private
    FText: string;
    FMaxCount: Integer;
    FDisplayText: string;

    function GetCount: Integer;
    function GetAsText: string;
    function GetSimpleText: string;
    function IsDataCorrect: Boolean;
    procedure CheckCode(const Code: string);
    procedure SetAsText(const Value: string);
    procedure TextToScanCode(const S: string);
    procedure TextToScanCodes(const Value: string);
    function GetItem(Index: Integer): TScanCode;
    function ItemByCode(const Value: string): TScanCode;
    function ItemByScanCode(const Value: string): TScanCode;
    function CheckBreakBeforeMake(var CheckResult: TCheckResult): Boolean;
    function CheckMakeWithoutBreak(var CheckResult: TCheckResult): Boolean;
    function GetLayoutID: Integer;
    function GetOwnerID: Integer;
    procedure SetDisplayText(const Value: string);
    procedure UpdateScanCodes(const Value: string);
    function Find(const Text: string; CodeType: TCodeType): TScanCode;
    procedure SetSimpleText(const Value: string);
  protected
    procedure ReplaceData(const Data, ReplaceTo: string; var FR: TFindResult); override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Clear; override;
    function Add: TScanCode;
    function IsEmpty: Boolean;
    procedure AddCode(Code: Word);
    function GetBinaryData: string;
    procedure AddItems(Items: TScanCodes);
    procedure FromString(const Str: string);
    procedure SetBinaryData(const S: string);
    procedure AddCodes(ScanCodes: TScanCodes);
    procedure Assign(Source: TPersistent); override;
    procedure CheckScanCodesText(const Value: string);
    function AddRawCode(const Code: string): TScanCode;
    procedure FindData(const Data: string; var FR: TFindResult); override;
    function CheckScancodes(var CheckResult: TCheckResult): Boolean;

    property Count: Integer read GetCount;
    property Text: string read FText write FText;
    property AsText: string read GetAsText write SetAsText;
    property MaxCount: Integer read FMaxCount write FMaxCount;
    property Items[Index: Integer]: TScanCode read GetItem; default;
    property SimpleText: string read GetSimpleText write SetSimpleText;
    property DisplayText: string read FDisplayText write SetDisplayText;
  published
    ScanCodeClass: TScanCode;
  end;

  { TScanCode }

  TScanCode = class(TMComponent)
  private
    FText: string;
    FCode: string;
    FScanCode: string;
    FMakeCode: string;
    FBreakCode: string;
    FCodeType: TCodeType;

    function CodeTypeText: string;
    function GetDisplayText: string;
    function SetData(var Data: string): Boolean;
    procedure SetCode(const Value: string);
  public
    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;

    property DisplayText: string read GetDisplayText;
    property MakeCode: string read FMakeCode write FMakeCode;
    property BreakCode: string read FBreakCode write FBreakCode;
  published
    property Text: string read FText write FText;
    property Code: string read FCode write SetCode;
    property ScanCode: string read FScanCode write FScanCode;
    property CodeType: TCodeType read FCodeType write FCodeType;
  end;

  TCodeTable = class;

  { TCodeTables }

  TCodeTables = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TCodeTable;
    function AddItem(const Text: string): TCodeTable;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure SetDefaults;
    function Add: TCodeTable;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCodeTable read GetItem; default;
  end;

  { TCodeTable }

  TCodeTable = class
  private
    FText: string;              
    FScanCode: TScanCode;       
    FScanCodes: TScanCodes;
    FMaxCodeLength: Integer;    
    function GetMaxCodeLength: Integer;
    function ItemByScanCode(const Value: string; CodeType: TCodeType): TScanCode;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromCodeTables(CodeTables: TCodeTables);
    procedure Add(const AText, AScanCode, AMakeCode, ABreakCode: string);
    function ItemByName(const Value: string; CodeType: TCodeType): TScanCode;
    function FromMessage(const Msg: TMsg; Options: TKeyOptions = [koMake, koBreak]): TScanCode;

    property Text: string read FText write FText;
    property ScanCodes: TScanCodes read FScanCodes;
    property MaxCodeLength: Integer read FMaxCodeLength;
  end;

  { TKeyPicture }

  TKeyPicture = class(TMComponent)
  private
    FText: string;                      
    FTextFont: TFont;
    FPicture: TPicture;
    FLoadError: Boolean;
    FLoadErrorText: string;
    FVerticalText: Boolean;
    FBackgroundColor: TColor;           

    function GetData: string;
    function GetHasData: Boolean;
    procedure SetData(Value: string);
    procedure SetTextFont(Value: TFont);
    procedure SetPicture(const Value: TPicture);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetText(const Value: string);
    procedure SetVerticalText(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;

    property HasData: Boolean read GetHasData;
    property LoadError: Boolean read FLoadError;

    property Text: string read FText write SetText;     
    property Data: string read GetData write SetData;
    property LoadErrorText: string read FLoadErrorText;
    property TextFont: TFont read FTextFont write SetTextFont;
    property VerticalText: Boolean read FVerticalText write SetVerticalText;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
  published
    property Picture: TPicture read FPicture write SetPicture;
  end;

    { TPressCodes }

  TPressCodes = class(TScanCodes)
  protected
    function CheckItem(var CheckResult: TCheckResult): Boolean; override;
  end;

  { TReleaseCodes }

  TReleaseCodes = class(TScanCodes)
  protected
    function CheckItem(var CheckResult: TCheckResult): Boolean; override;
  end;

implementation

uses
  KeyboardManager; { !!! }


resourcestring
  MsgLayer              = 'Layer';
  MsgKey                = 'Button';
  MsgKeys               = 'Buttons';
  MsgGroupIntersection  = 'Groups intersection';
  MsgNotes              = 'Sound';
  MsgPicture            = 'Picture';
  MsgPressCodes         = 'Press scancodes';
  MsgReleaseCodes       = 'Release scancodes';
  MsgInvalidLayerCount  = 'Invalid layer count: %d';
  MsgMSRCaption         = 'Magnetic stripe reader';
  MsgKeyLockCaption     = 'Keylock';
  MsgIButtonCaption     = 'IButton reader';
  MsgScrollWheelCaption = 'Scroll wheel';
  MsgNotesCaption       = 'Sound';
  MsgTrackCaption       = 'Track';
  MsgPrefixCaption      = 'Prefix';
  MsgSuffixCaption      = 'Suffix';
  MsgKeyPosCount        = 'Maximum keylock position number is 8';
  MsgPosition           = 'Position';
  MsgAlphabeticEnglish  = 'English alphabetical';
  MsgNumbers            = 'Numbers';
  MsgSymbols            = 'Symbols';
  MsgControlKeys        = 'Control scancodes';
  MsgACPI               = 'ACPI scancodes';
  MsgMultimedia         = 'Multimedia';
  MsgEmptyCode          = 'Button code must have value';
  MsgInvalidCodeType    = 'Invalid CodeType value';
  MsgScanCodeLength     = 'Scancodes length must be less than %d bytes';
  MsgKeyExists          = 'IButton key with code %s already exists!';
  MsgCannotDeleteRegisteredKey = 'Registered IButton key cannot be deleted';
  MsgUnregistered       = 'Unregistered';
  MsgMaxElementCount    = 'Maximum element number: %d';
  MsgNoteCount          = 'Maximum notes count is 256';
  MsgInvalidNoteFormat  = 'Invalid notes format';
  MsgReleaseBeforePress = '%s Scancode %s: Release scancode is before press scancode';
  MsgNoReleaseScancode  = '%s Scancode %s: No release scancode defined';
  MsgTextFound          = '%s. String %s found';
  MsgTextReplaced       = '%s. String %s Replaced for %s';
  MsgScancodeNotFound   = 'Scancode "%s" not found';
  MsgInvalidCode        = 'Invalid code, "%s"';


function StreamToString(Stream: TStream): string;
begin
  Result := '';
  if Stream.Size > 0 then
  begin
    Stream.Position := 0;
    SetLength(Result, Stream.Size);
    Stream.ReadBuffer(Result[1], Stream.Size);
  end;
end;

{ TMComponent }

constructor TMComponent.Create(AOwner: TComponent);
const
  LastID: Integer = 0;
begin
  inherited Create(AOwner);
  Inc(LastID); FID := LastID;
end;

procedure TMComponent.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TMComponent.NotifyModified;
begin
  if FUpdateLockCount = 0 then
  begin
    Changed;
    if Owner is TMComponent then
      (Owner as TMComponent).Modified;
  end;
end;

procedure TMComponent.Modified;
begin
  FIsModified := True;
  NotifyModified;
end;

procedure TMComponent.Clear;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].Clear;
end;

procedure TMComponent.ClearModified;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].ClearModified;
  FIsModified := False;
end;

procedure TMComponent.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  OwnedComponent: TComponent;
begin
  inherited GetChildren(Proc, Root);
  if Root = Self then
    for I := 0 to ComponentCount - 1 do
    begin
      OwnedComponent := Components[I];
      if not OwnedComponent.HasParent then Proc(OwnedComponent);
    end;
end;

function TMComponent.GetCount: Integer;
begin
  Result := ComponentCount;
end;

function TMComponent.GetItem(Index: Integer): TMComponent;
begin
  Result := Components[Index] as TMComponent;
end;

procedure TMComponent.BeginUpdate;
begin
  Inc(FUpdateLockCount);
end;

procedure TMComponent.EndUpdate;
begin
  Dec(FUpdateLockCount);
  if IsModified then NotifyModified;
end;

function TMComponent.CheckItem(var CheckResult: TCheckResult): Boolean;
var
  i: Integer;
begin
  Result := True;
  if CheckResult.ErrCount >= 100 then Exit;
  for i := 0 to Count-1 do
  begin
    if not Items[i].CheckItem(CheckResult) then
    begin
      Result := False;
    end;
  end;
end;

function TMComponent.CheckData: Boolean;
var
  CheckResult: TCheckResult;
begin
  CheckResult.ErrCount := 0;
  Result := CheckItem(CheckResult);
end;

function TMComponent.AddPathSeparator(const S: string): string;
begin
  Result := S;
  if Result <> '' then
    Result := Result + '. ';
end;

function TMComponent.GetPath: string;
begin
  Result := Caption;
  if Owner <> nil then
  begin
    if Result <> '' then
      Result := AddPathSeparator((Owner as TMComponent).Path) + Result
    else
    begin
      if Owner is TMComponent then
        Result := (Owner as TMComponent).Path
      else
        Result := '';
    end;
  end;
end;

function TMComponent.GetCaption: string;
begin
  Result := FCaption;
end;

procedure TMComponent.FindData(const Data: string; var FR: TFindResult);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].FindData(Data, FR);
end;

procedure TMComponent.ReplaceData(const Data, ReplaceTo: string; var FR: TFindResult);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].ReplaceData(Data, ReplaceTo, FR);
end;

function TMComponent.Find(const Data: string): Integer;
var
  FR: TFindResult;
begin
  FR.MatchCount := 0;
  FindData(Data, FR);
  Result := FR.MatchCount;
end;

function TMComponent.Replace(const Data, ReplaceTo: string): Integer;
var
  FR: TFindResult;
begin
  FR.MatchCount := 0;
  ReplaceData(Data, ReplaceTo, FR);
  Result := FR.MatchCount;
end;

function TMComponent.ItemByID(AID: Integer): TMComponent;
var
  i: Integer;
begin
  if AID = ID then
  begin
    Result := Self;
  end else
  begin
    Result := nil;
    for i := 0 to Count-1 do
    begin
      Result := Items[i].ItemByID(AID);
      if Result <> nil then Break;
    end;
  end;
end;

{ TKBLayout }

constructor TKBLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks := TList.Create;
  FLayers := TLayers.Create(Self);
  FKeyGroups := TKeyGroups.Create(Self);
  FSelectedKeys := TKeyList.Create;
  FileVersion := $20A;
end;

destructor TKBLayout.Destroy;
begin
  while FLinks.Count > 0 do
    RemoveLink(FLinks.Last);

  FLinks.Free;
  FSelectedKeys.Free;
  inherited Destroy;
end;

procedure TKBLayout.Clear;
begin
  Layers.Clear;
  KeyGroups.Clear;
end;

procedure TKBLayout.UpdateSelectedKeys;
var
  i: Integer;
  Keys: TKeys;
begin
  SelectedKeys.Clear;
  Keys := Layer.Keys;
  for i := 0 to Keys.Count-1 do
  begin
    if Keys[i].InSelection(Selection) then
      SelectedKeys.Add(Keys[i]);
  end;
end;

procedure TKBLayout.UpdateKeys;
var
  i: Integer;
  j: Integer;
  Key: TKey;
  Layer: TLayer;
begin
  for i := 0 to Layers.Count-1 do
  begin
    Layer := Layers[i];
    for j := 0 to Layer.Keys.Count-1 do
    begin
      Key := Layer.Keys[j];
      if Key.KeyType <> ktMacros then
      begin
        Key.PressCodes.Clear;
        Key.ReleaseCodes.Clear;
      end;
    end;
  end;
end;

procedure TKBLayout.Assign(Source: TPersistent);
var
  Src: TKBLayout;
begin
  if Source is TKBLayout then
  begin
    Src := Source as TKBLayout;

    Keyboard := Src.Keyboard;
    FFileName := Src.FileName;
    FSelection := Src.FSelection;
    Layers := Src.Layers;
    KeyGroups := Src.KeyGroups;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TKBLayout.SetKeyType(Col, Row: Integer; Value: TKeyType);
var
  Key: TKey;
  i: Integer;
begin
  for i := 0 to Layers.Count-1 do
  begin
    Key := Layers[i].FindKey(Col, Row);
    Key.KeyType := Value;
  end;
end;

procedure TKBLayout.DoDeleteKey(Key: TKey);
begin
  Key.Clear;
end;

function TKBLayout.IsKeySelected(Key: TKey): Boolean;
begin
  Result := Key.InSelection(Selection);
end;

function TKBLayout.GetGroup(ACol, ARow: Integer): TKeyGroup;
begin
  Result := KeyGroups.GetGroup(ACol, ARow);
end;

procedure TKBLayout.SetKey(SrcKey, DstKey: TKey);
begin
  DstKey.Assign(SrcKey);
  Modified;
end;

procedure TKBLayout.Saved(const AFileName: string);
begin
  ClearModified;
  FFileName := AFileName;
end;

procedure TKBLayout.CheckCanGroup;
var
  i: Integer;
begin
  for i := KeyGroups.Count-1 downto 0 do
  begin
    if KeyGroups[i].Intersect(Selection) then
      raise Exception.Create(MsgGroupIntersection);
  end;
end;

procedure TKBLayout.GroupKeys;
begin
  CheckCanGroup;
  KeyGroups.Add.FRect := Selection;
  Modified;
end;

procedure TKBLayout.UngroupKeys;
var
  i: Integer;
  Group: TKeyGroup;
  WasModified: Boolean;
begin
  WasModified := False;
  for i := KeyGroups.Count-1 downto 0 do
  begin
    Group := KeyGroups[i];
    if Group.Intersect(Selection) then
    begin
      Group.Free;
      WasModified := True;
    end;
  end;
  if WasModified then
  begin
    Modified;
  end;
end;

procedure TKBLayout.SetKeyboard(Value: TKeyboard);
begin
  if Value <> FKeyboard then
  begin
    FKeyboard := Value;
    UpdateLayout;
    Modified;
  end;
end;

procedure TKBLayout.CreateKeys(Keys: TKeys; AKeyboard: TKeyboard);
var
  i: Integer;
  TmpKeys: TKeys;
  KeyDef: TKeyDef;
begin
  TmpKeys := TKeys.Create(nil);
  try
    TmpKeys.Assign(Keys);

    Keys.Clear;
    for i := 0 to AKeyboard.KeyDefs.Count-1 do
    begin
      KeyDef := AKeyboard.KeyDefs[i];
      Keys.Add(KeyDef.Left, KeyDef.Top, KeyDef.LogicNumber);
    end;
    Keys.CopyKeysByNumbers(TmpKeys);
  finally
    TmpKeys.Free;
  end;
end;

procedure TKBLayout.UpdateLayout;
var
  i: Integer;
  Layer: TLayer;
begin
  BeginUpdate;
  try
    Layers.SetCount(Keyboard.LayerCount);
    for i := 0 to Layers.Count-1 do
    begin
      Layer := Layers[i];
      CreateKeys(Layer.Keys, Keyboard);
      Layer.KeyLock.SetCount(Keyboard.PosCount);
    end;
    UpdateSelectedKeys;
  finally
    EndUpdate;
  end;
end;

procedure TKBLayout.SetSelection(const Value: TGridRect);
begin
  if not CompareGridRect(FSelection, Value) then
  begin
    FSelection := Value;
    UpdateSelectedKeys;
    NotifyModified;
  end;
end;

function TKBLayout.IsSingleSelection: Boolean;
begin
  Result := (Selection.Left = Selection.Right)and
    (Selection.Top = Selection.Bottom);
end;

function TKBLayout.CanUngroup: Boolean;
var
  i: Integer;
  Group: TKeyGroup;
begin
  Result := False;
  for i := KeyGroups.Count-1 downto 0 do
  begin
    Group := KeyGroups[i];
    if Group.Intersect(Selection) then Result := True;
  end;
end;

procedure TKBLayout.SetLayers(const Value: TLayers);
begin
  Layers.Assign(Value);
end;

procedure TKBLayout.SetKeyGroups(const Value: TKeyGroups);
begin
  KeyGroups.Assign(Value);
end;

function TKBLayout.CanSelect(Col, Row: Integer): Boolean;
begin
  Result := (Layers.Count > 0)and
    (Layers[0].Keys.FindItem(Col, Row) <> nil);
end;

function TKBLayout.GetHasMSRTrack1: Boolean;
begin
  Result := Keyboard.HasMSRTrack1;
end;

function TKBLayout.GetHasMSRTrack2: Boolean;
begin
  Result := Keyboard.HasMSRTrack2;
end;

function TKBLayout.GetHasMSRTrack3: Boolean;
begin
  Result := Keyboard.HasMSRTrack3;
end;

function TKBLayout.GetColCount: Integer;
begin
  Result := Keyboard.ColCount;
end;

function TKBLayout.GetRowCount: Integer;
begin
  Result := Keyboard.RowCount;
end;

function TKBLayout.GetKeyboardID: Integer;
begin
  Result := Keyboard.ID;
end;

function TKBLayout.GetHasKey: Boolean;
begin
  Result := Keyboard.HasKey;
end;

function TKBLayout.GetHasMSR: Boolean;
begin
  Result := Keyboard.HasMSR;
end;                                            

function TKBLayout.CanSave: Boolean;
begin
  Result := (FileName = '') or IsModified;
end;

function TKBLayout.CanPaste: Boolean;
begin
  Result := Clipboard.HasFormat(CF_TEXT);
end;

function TKBLayout.CanGroup: Boolean;
begin
  Result :=
    (Selection.Left <> Selection.Right) or
    (Selection.Top <> Selection.Bottom);
end;

function TKBLayout.GetSelectionText: string;
begin
  Result := '';
  if (Selection.Left = Selection.Right)and(Selection.Top = Selection.Bottom) then
  begin
    Result := TKey.GetKeyCaption(Selection.Left, Selection.Top);
  end else
  begin
    Result := Format('%s (%d,%d)-(%d,%d)', [MsgKeys, Selection.Left,
      Selection.Top, Selection.Right, Selection.Bottom]);
  end;
end;

function TKBLayout.GetPicture: TPicture;
var
  Key: TKey;
  Group: TKeyGroup;
begin
  Key := Layers[0].Keys.FindItem(Selection.Left, Selection.Top);
  Group := GetGroup(Key.Col, Key.Row);
  if Group <> nil then
    Key := Layers[0].GetKey(Group.Rect.Left, Group.Rect.Top);
  Result := Key.Picture.Picture;
end;

procedure TKBLayout.SelectAll;
begin
  Selection := GridRect(1, 1, ColCount, RowCount);
end;

procedure TKBLayout.SelectKey(Key: TKey);
var
  R: TGridRect;
begin
  R.Left := Key.Col;
  R.Right := Key.Col;
  R.Top := Key.Row;
  R.Bottom := Key.Row;
  Selection := R;
end;

procedure TKBLayout.SelectItem(ItemID: Integer);
var
  Item: TMComponent;
begin
  Item := ItemByID(ItemID);
  if (Item <> nil)and(Item is TKey) then
    SelectKey(Item as TKey);
end;

procedure TKBLayout.ResetKeys;
var
  Keys: TKeys;
  i, j: Integer;
begin
  for i := 0 to Layers.Count-1 do
  begin
    Keys := Layers[i].Keys;
    for j := 0 to Keys.Count-1 do
      Keys[j].Pressed := False;
  end;
end;

procedure TKBLayout.DeleteSelection;
var
  Key: TKey;
  Keys: TKeys;
  i, j: Integer;
begin
  BeginUpdate;
  try
    for i := 0 to Layers.Count-1 do
    begin
      Keys := Layers[i].Keys;
      for j := 0 to Keys.Count-1 do
      begin
        Key := Layers[i].Keys[j];
        if IsKeySelected(Key) then
          DoDeleteKey(Key);
      end;
    end;
  finally
    EndUpdate;
  end;
end;

function TKBLayout.GetLayer: TLayer;
begin
  Result := Layers[FLayerIndex];
end;

procedure TKBLayout.ClearSelection;
begin
  FSelection.Top := 0;
  FSelection.Left := 0;
  FSelection.Right := 0;
  FSelection.Bottom := 0;
end;

function TKBLayout.GetKeyboard: TKeyboard;
begin
  if FKeyboard = nil then
    raise Exception.Create('Keyboard is not assigned');
  Result := FKeyboard;
end;

procedure TKBLayout.SetDeviceVersion(const Value: Word);
begin
  FDeviceVersion := Value;
end;

procedure TKBLayout.AddLink(Link: TKBLayoutLink);
begin
  FLinks.Add(Link);
  Link.FLayout := Self;
end;

procedure TKBLayout.RemoveLink(Link: TKBLayoutLink);
begin
  FLinks.Remove(Link);
  Link.FLayout := nil;
end;

procedure TKBLayout.Changed;
var
  i: Integer;
begin
  inherited Changed;
  for i := 0 to FLinks.Count-1 do
    TKBLayoutLink(FLinks[i]).Changed;
end;

procedure TKBLayout.SetLayerIndex(const Value: Integer);
begin
  if Value <> LayerIndex then
  begin
    FLayerIndex := Value;
    UpdateSelectedKeys;
    Changed;
  end;
end;

{ TKeys }

procedure TKeys.CopyKeysByNumbers(SrcKeys: TKeys);
var
  i: Integer;
  SrcKey: TKey;
  DstKey: TKey;
begin
  for i := 0 to Count-1 do
  begin
    DstKey := Items[i];
    SrcKey := SrcKeys.ItemByNumber(DstKey.Number);
    if SrcKey <> nil then
    begin
      DstKey.AssignKey(SrcKey)
    end;
  end;
end;

procedure TKeys.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TKeys.GetCount: Integer;
begin
  Result := ComponentCount;
end;

function TKeys.GetItem(Index: Integer): TKey;
begin
  Result := Components[Index] as TKey;
end;

function TKeys.Add(ACol, ARow, ANumber: Integer): TKey;
begin
  Result := TKey.Create(Self);
  Result.Col := ACol;
  Result.Row := ARow;
  Result.Number := ANumber;
end;

function TKeys.Add: TKey;
begin
  Result := TKey.Create(Self);
end;

function TKeys.FindItem(ACol, ARow: Integer): TKey;
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

function TKeys.ItemByNumber(Number: Integer): TKey;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    if Items[i].Number = Number then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TKeys.Assign(Source: TPersistent);
var
  i: Integer;
  Src: TKeys;
begin
  if Source is TKeys then
  begin
    Src := Source as TKeys;

    Clear;
    for i := 0 to Src.Count-1 do
      Add.Assign(Src[i]);

  end else
    inherited Assign(Source);
end;

{ TKey }

constructor TKey.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FKeyType := ktNone;
  // Notes
  FNotes := TNotes.Create(Self);
  FNotes.Caption := MsgNotes;
  // Picture
  FPicture := TKeyPicture.Create(Self);
  FPicture.Caption := MsgPicture;
  // PressCodes
  FPressCodes := TPressCodes.Create(Self);
  FPressCodes.Caption := MsgPressCodes;
  // ReleaseCodes
  FReleaseCodes := TReleaseCodes.Create(Self);
  FReleaseCodes.Caption := MsgReleaseCodes;
end;

procedure TKey.AssignKey(Source: TPersistent);
var
  Src: TKey;
begin
  if Source is TKey then
  begin
    Src := Source as TKey;

    Text := Src.Text;
    Notes := Src.Notes;
    KeyType := Src.KeyType;
    Picture := Src.Picture;
    RepeatKey := Src.RepeatKey;
    PressCodes := Src.PressCodes;
    ReleaseCodes := Src.ReleaseCodes;
  end;
end;

procedure TKey.Assign(Source: TPersistent);
var
  Src: TKey;
begin
  if Source is TKey then
  begin
    Src := Source as TKey;

    Row := Src.Row;
    Col := Src.Col;
    Number := Src.Number;
    AssignKey(Src);
  end else
    inherited Assign(Source);
end;

procedure TKey.SetNotes(const Value: TNotes);
begin
  Notes.Assign(Value);
end;

procedure TKey.SetPicture(const Value: TKeyPicture);
begin
  Picture.Assign(Value);
end;

procedure TKey.SetPressCodes(const Value: TScanCodes);
begin
  PressCodes.Assign(Value);
end;

procedure TKey.SetReleaseCodes(const Value: TScanCodes);
begin
  ReleaseCodes.Assign(Value);
end;

procedure TKey.Clear;
begin
  Text := '';
  Pressed := False;
  RepeatKey := False;
  KeyType := ktNone;
  inherited Clear;
  Modified;
end;

procedure TKey.SetKeyType(const Value: TKeyType);
begin
  FKeyType := Value;
  Modified;
end;

function TKey.InSelection(Selection: TGridRect): Boolean;
begin
  Result :=
    (Col >= Selection.Left)and(Col <= Selection.Right) and
    (Row >= Selection.Top)and(Row <= Selection.Bottom);
end;

function TKey.CheckItem(var CheckResult: TCheckResult): Boolean;
var
  ScanCodes: TScanCodes;
begin
  ScanCodes := TScanCodes.Create(Self);
  try
    ScanCodes.AddItems(PressCodes);
    ScanCodes.AddItems(ReleaseCodes);
    Result := ScanCodes.CheckScancodes(CheckResult);
  finally
    ScanCodes.Free;
  end;
end;

function TKey.GetCaption: string;
begin
  Result := GetKeyCaption(Col, Row);
end;

procedure TKey.SetNumber(const Value: Integer);
begin
  FNumber := Value;
end;

class function TKey.GetKeyCaption(ACol, ARow: Integer): string;
begin
  Result := Format('%s (%d, %d)', [MsgKey, ACol, ARow]);
end;

{ TKeyGroups }

procedure TKeyGroups.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TKeyGroups.GetCount: Integer;
begin
  Result := ComponentCount;
end;

function TKeyGroups.GetItem(Index: Integer): TKeyGroup;
begin
  Result := Components[Index] as TKeyGroup;
end;

function TKeyGroups.Add: TKeyGroup;
begin
  Result := TKeyGroup.Create(Self);
end;

{****************************************************************************}
{
{   Find key group by row and column
{   Function return group if found or nil.
{
{****************************************************************************}

function TKeyGroups.GetGroup(ACol, ARow: Integer): TKeyGroup;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.PointInRect(ACol, ARow) then Exit;
  end;
  Result := nil;
end;

procedure TKeyGroups.Assign(Source: TPersistent);
var
  i: Integer;
  Src: TKeyGroups;
begin
  if Source is TKeyGroups then
  begin
    Src := Source as TKeyGroups;

    Clear;
    for i := 0 to Src.Count-1 do
      Add.Assign(Src[i]);
  end else
    inherited Assign(Source);
end;

{ TKeyGroup }

procedure TKeyGroup.Assign(Source: TPersistent);
var
  Src: TKeyGroup;
begin
  if Source is TKeyGroup then
  begin
    Src := Source as TKeyGroup;

    FID := Src.ID;
    FRect := Src.Rect;
  end else
    inherited Assign(Source);
end;

procedure TKeyGroup.Clear;
begin
  inherited;

end;

function TKeyGroup.Intersect(const ARect: TGridRect): Boolean;

  function IsRectIntersect(const Rect1, Rect2: TGridRect): Boolean;
  var
    TopLeft: TGridCoord;
    TopRight: TGridCoord;
    BottomLeft: TGridCoord;
    BottomRight: TGridCoord;
  begin
    TopLeft := Rect1.TopLeft;
    TopRight.x := Rect1.Right;
    TopRight.y := Rect1.Bottom;
    BottomLeft.x := Rect1.Left;
    BottomLeft.y := Rect1.Bottom;
    BottomRight := Rect1.BottomRight;

    Result := GridType.PointInRect(Rect2, TopLeft) or GridType.PointInRect(Rect2, TopRight) or
      GridType.PointInRect(Rect2, BottomLeft) or GridType.PointInRect(Rect2, BottomRight);
  end;

begin
  Result := IsRectIntersect(Rect, ARect) or IsRectIntersect(ARect, Rect);
end;

function TKeyGroup.PointInRect(ACol, ARow: Integer): Boolean;
begin
  Result := (ACol >= Rect.Left)and(ACol <= Rect.Right)and
    (ARow >= Rect.Top)and(ARow <= Rect.Bottom);
end;

{ TLayers }

function TLayers.ValidIndex(Index: Integer): Boolean;
begin
  Result := (Index >= 0)and(Index < Count);
end;

procedure TLayers.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TLayers.GetCount: Integer;
begin
  Result := ComponentCount;
end;

function TLayers.GetItem(Index: Integer): TLayer;
begin
  Result := Components[Index] as TLayer;
end;

function TLayers.Add: TLayer;
begin
  Result := TLayer.Create(Self);
  Result.Caption := Format('%s %d', [MsgLayer, Result.ComponentIndex + 1]);
end;

procedure TLayers.CheckLayerCount(Value: Integer);
begin
  if Value <= 0 then
    raise Exception.CreateFmt(MsgInvalidLayerCount, [Value]);
end;

procedure TLayers.SetCount(Value: Integer);
var
  i: Integer;
begin
  CheckLayerCount(Value);
  for i := Count to Value-1 do Add;
  for i := Count-1 downto Value do Items[i].Free;
end;

procedure TLayers.Assign(Source: TPersistent);
var
  i: Integer;
  Src: TLayers;
begin
  if Source is TLayers then
  begin
    Src := Source as TLayers;

    Clear;
    for i := 0 to Src.Count-1 do
      Add.Assign(Src[i]);
  end else
    inherited Assign(Source);
end;

{ TLayer }

constructor TLayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // MSR
  FMSR := TMSR.Create(Self);
  FMSR.Caption := MsgMSRCaption;
  // KeyLock
  FKeyLock := TKeyLock.Create(Self);
  FKeyLock.Caption := MsgKeyLockCaption;
  // Keys
  FKeys := TKeys.Create(Self);
  // IButton
  FIButton := TIButton.Create(Self);
  FIButton.Caption := MsgIButtonCaption;
  // ScrollWheel
  FScrollWheel := TScrollWheel.Create(Self);
  FScrollWheel.Caption := MsgScrollWheelCaption;
end;

procedure TLayer.Assign(Source: TPersistent);
var
  Src: TLayer;
begin
  if Source is TLayer then
  begin
    Src := Source as TLayer;

    MSR := Src.MSR;
    Keys := Src.Keys;
    KeyLock := Src.KeyLock;
    IButton := Src.IButton;
    ScrollWheel := Src.ScrollWheel;
  end else
    inherited Assign(Source);
end;

procedure TLayer.SetIButton(const Value: TIButton);
begin
  FIButton.Assign(Value);
end;

procedure TLayer.SetKeyLock(const Value: TKeyLock);
begin
  FKeyLock.Assign(Value);
end;

procedure TLayer.SetKeys(const Value: TKeys);
begin
  FKeys.Assign(Value);
end;

procedure TLayer.SetMSR(const Value: TMSR);
begin
  FMSR.Assign(Value);
end;

procedure TLayer.SetScrollWheel(const Value: TScrollWheel);
begin
  FScrollWheel.Assign(Value);
end;

function TLayer.FindKey(ACol, ARow: Integer): TKey;
begin
  Result := Keys.FindItem(ACol, ARow);
end;

function TLayer.GetKey(ACol, ARow: Integer): TKey;
begin
  Result := Keys.FindItem(ACol, ARow);
  if Result = nil then
    raise Exception.CreateFmt('%s not found.', [TKey.GetKeyCaption(ACol, ARow)]);
end;

function TLayer.GetIndex: Integer;
begin
  Result := ComponentIndex;
end;

{ TMSR }

constructor TMSR.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  // Notes
  FNotes := TNotes.Create(Self);
  FNotes.Caption := MsgNotesCaption;
  // Tracks
  FTracks := TMSRTracks.Create(Self);
  FLightIndication := True;
  // Tracks
  for i := 1 to 3 do
    FTracks.Add.Caption := Format('%s %d', [MsgTrackCaption, i]);
end;

procedure TMSR.Clear;
begin
  Tracks[0].Clear;
  Tracks[1].Clear;
  Tracks[2].Clear;
  Notes.Clear;
  SendEnter := False;
  LockOnErr := True;
end;

procedure TMSR.Assign(Source: TPersistent);
var
  Src: TMSR;
begin
  if Source is TMSR then
  begin
    Src := Source as TMSR;

    Notes := Src.Notes;
    Tracks := Src.Tracks;
    SendEnter := Src.SendEnter;
    LockOnErr := Src.LockOnErr;
    LightIndication := Src.LightIndication;
  end else
    inherited Assign(Source);
end;

procedure TMSR.SetNotes(const Value: TNotes);
begin
  Notes.Assign(Value);
end;

procedure TMSR.SetTracks(const Value: TMSRTracks);
begin
  Tracks.Assign(Value);
end;

{ TMSRTracks }

function TMSRTracks.Add: TMSRTrack;
begin
  Result := TMSRTrack.Create(Self);
end;

procedure TMSRTracks.Assign(Source: TPersistent);
var
  i: Integer;
  Src: TMSRTracks;
begin
  if Source is TMSRTracks then
  begin
    Src := Source as TMSRTracks;

    Clear;
    for i := 0 to Src.Count-1 do
      Add.Assign(Src[i]);
  end else
    inherited Assign(Source);
end;

procedure TMSRTracks.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TMSRTracks.GetCount: Integer;
begin
  Result := ComponentCount;
end;

function TMSRTracks.GetItem(Index: Integer): TMSRTrack;
begin
  Result := Components[Index] as TMSRTrack;
end;

{ TMSRTrack }

constructor TMSRTrack.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  // Prefix
  FPrefix := TScanCodes.Create(Self);
  FPrefix.Caption := MsgPrefixCaption;
  // Suffix
  FSuffix := TScanCodes.Create(Self);
  FSuffix.Caption := MsgSuffixCaption;
end;

procedure TMSRTrack.Clear;
begin
  Prefix.Clear;
  Suffix.Clear;
  FEnabled := True;
end;

procedure TMSRTrack.Assign(Source: Tpersistent);
var
  Src: TMSRTrack;
begin
  if Source is TMSRTrack then
  begin
    Src := Source as TMSRTrack;

    Enabled := Src.Enabled;
    Prefix := Src.Prefix;
    Suffix := Src.Suffix;
  end else
    inherited Assign(Source);
end;

procedure TMSRTrack.SetPrefix(const Value: TScanCodes);
begin
  Prefix.Assign(Value);
end;

procedure TMSRTrack.SetSuffix(const Value: TScanCodes);
begin
  Suffix.Assign(Value);
end;

function TMSRTrack.CheckItem(var CheckResult: TCheckResult): Boolean;
var
  B1,  B2: Boolean;
begin
  B1 := Prefix.CheckScancodes(CheckResult);
  B2 := Suffix.CheckScancodes(CheckResult);
  Result := B1 and B2;
end;

{ TKeyLock }

procedure TKeyLock.Clear;
begin
  DestroyComponents;
end;

function TKeyLock.IsEmpty: Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to Count-1 do
  begin
    Result := Items[i].IsEmpty;
    if not Result then Exit;
  end;
end;

function TKeyLock.GetCount: Integer;
begin
  Result := ComponentCount;
end;

function TKeyLock.GetItem(Index: Integer): TKeyPosition;
begin
  Result := Components[Index] as TKeyPosition;
end;

function TKeyLock.Add: TKeyPosition;
begin
  if Count = 8 then
    raise Exception.Create(MsgKeyPosCount);
  Result := TKeyPosition.Create(Self);
end;

procedure TKeyLock.SetCount(Value: Integer);
var
  i: Integer;
begin
  for i := Count to Value-1 do Add;
  for i := Count-1 downto Value do Items[i].Free;
end;

procedure TKeyLock.Assign(Source: TPersistent);
var
  i: Integer;
  Src: TKeyLock;
begin
  if Source is TKeyLock then
  begin
    Src := Source as TKeyLock;

    Clear;
    for i := 0 to Src.Count-1 do
      Add.Assign(Src[i]);
  end else
    inherited Assign(Source);
end;

{ TKeyPosition }

constructor TKeyPosition.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNotes := TNotes.Create(Self);
  FCodes := TScanCodes.Create(Self);
  Caption := Format('%s %d', [MsgPosition, ComponentIndex]);
end;

procedure TKeyPosition.Assign(Source: TPersistent);
var
  Src: TKeyPosition;
begin
  if Source is TKeyPosition then
  begin
    Src := Source as TKeyPosition;

    Notes := Src.Notes;
    Codes := Src.Codes;
    PosType := Src.PosType;
    LockEnabled := Src.LockEnabled;
    NcrEmulation := Src.NcrEmulation;
    NixdorfEmulation := Src.NixdorfEmulation;
  end else
    inherited Assign(Source);
end;

procedure TKeyPosition.SetCodes(const Value: TScanCodes);
begin
  Codes.Assign(Value);
end;

procedure TKeyPosition.SetNotes(const Value: TNotes);
begin
  Notes.Assign(Value);
end;

procedure TKeyPosition.Clear;
begin
  Notes.Clear;
  Codes.Clear;
  FPosType := ptMacros;
  FLockEnabled := False;
  FNcrEmulation := False;
  FNixdorfEmulation := False;
end;

function TKeyPosition.IsEmpty: Boolean;
begin
  Result :=
    Notes.IsEmpty and
    Codes.IsEmpty and
    (PosType = ptMacros) and
    (LockEnabled = False) and
    (NcrEmulation = False) and
    (NixdorfEmulation = False);
end;

function TKeyPosition.CheckItem(var CheckResult: TCheckResult): Boolean;
begin
  Result := Codes.CheckScancodes(CheckResult);
end;

{ TKeyList }

function TKeyList.GetItem(Index: Integer): TKey;
begin
  Result := inherited Items[Index];
end;

{ TWheelItem }

constructor TWheelItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNotes := TNotes.Create(Self);
  FCodes := TScanCodes.Create(Self);
end;

procedure TWheelItem.Assign(Source: TPersistent);
var
  Src: TWheelItem;
begin
  if Source is TWheelItem then
  begin
    Src := Source as TWheelItem;

    Codes := Src.Codes;
    Notes := Src.Notes;
  end
  else inherited Assign(Source);
end;

procedure TWheelItem.SetCodes(const Value: TScanCodes);
begin
  Codes.Assign(Value);
end;

procedure TWheelItem.SetNotes(const Value: TNotes);
begin
  Notes.Assign(Value);
end;

procedure TWheelItem.Clear;
begin
  Notes.Clear;
  Codes.Clear;
end;

function TWheelItem.IsEmpty: Boolean;
begin
  Result := Notes.IsEmpty and Codes.IsEmpty;
end;

function TWheelItem.CheckItem(var CheckResult: TCheckResult): Boolean;
begin
  Result := Codes.CheckScancodes(CheckResult);
end;

{ TScrollWheel }

constructor TScrollWheel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScrollUp := TWheelItem.Create(Self);
  FScrollDown := TWheelItem.Create(Self);
  FSingleClick := TWheelItem.Create(Self);
  FDoubleClick := TWheelItem.Create(Self);
end;

procedure TScrollWheel.Assign(Source: TPersistent);
var
  Src: TScrollWheel;
begin
  if Source is TScrollWheel then
  begin
    Src := Source as TScrollWheel;

    ScrollUp := Src.ScrollUp;
    ScrollDown := Src.ScrollDown;
    SingleClick := Src.SingleClick;
    DoubleClick := Src.DoubleClick;
  end
  else inherited Assign(Source);
end;

procedure TScrollWheel.SetDoubleClick(const Value: TWheelItem);
begin
  DoubleClick.Assign(Value);
end;

procedure TScrollWheel.SetScrollDown(const Value: TWheelItem);
begin
  ScrollDown.Assign(Value);
end;

procedure TScrollWheel.SetScrollUp(const Value: TWheelItem);
begin
  ScrollUp.Assign(Value);
end;

procedure TScrollWheel.SetSingleClick(const Value: TWheelItem);
begin
  SingleClick.Assign(Value);
end;

const
  

  NoteNames: array [0..72] of string = ('P',
  'C_0','Cis_0','D_0','Dis_0','E_0','F_0','Fis_0','G_0','Gis_0','A_0','Ais_0', 'B_0',
  'C0','Cis0','D0','Dis0','E0','F0','Fis0','G0','Gis0','A0','Ais0', 'B0',
  'C1','Cis1','D1','Dis1','E1','F1','Fis1','G1','Gis1','A1','Ais1', 'B1',
  'C2','Cis2','D2','Dis2','E2','F2','Fis2','G2','Gis2','A2','Ais2', 'B2',
  'C3','Cis3','D3','Dis3','E3','F3','Fis3','G3','Gis3','A3','Ais3', 'B3',
  'C4','Cis4','D4','Dis4','E4','F4','Fis4','G4','Gis4','A4','Ais4', 'B4'
  );

function GetStr(var Data: string; var S: string): Boolean;
var
  P: Integer;
begin
  P := Pos(';', Data);
  Result := (P > 0)or(Length(Data) > 0);
  if P > 0 then
  begin
    S := Copy(Data, 1, P-1);
    Data := Copy(Data, P+1, Length(Data));
  end else
  begin
    S := Data;
    Data := '';
  end;
  if not Result then
    raise Exception.Create(MsgInvalidNoteFormat);
end;

function NoteToName(Note: Byte): string;
begin
  Result := '';
  if Note <= High(NoteNames) then
    Result := NoteNames[Note];
end;

procedure TScrollWheel.Clear;
begin
  Address := 0;
  ScrollUp.Clear;
  ScrollDown.Clear;
  SingleClick.Clear;
  DoubleClick.Clear;
end;

function TScrollWheel.IsEmpty: Boolean;
begin
  Result :=
    ScrollUp.IsEmpty and
    ScrollDown.IsEmpty and
    SingleClick.IsEmpty and
    DoubleClick.IsEmpty;
end;

{ TNotes }

function TNotes.GetItem(Index: Integer): TNote;
begin
  Result := Components[Index] as TNote;
end;

function TNotes.Add: TNote;
begin
  if Count = 256 then
    raise Exception.Create(MsgNoteCount);
  Result := TNote.Create(Self);
end;

function TNotes.GetAsText: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count-1 do
  begin
    Result := Result + Items[i].DisplayText;
    if i <> Count-1 then Result := Result + ';';
  end;
end;

procedure TNotes.SetAsText(const Text: string);
begin
  if AsText <> Text then
  begin
    TextToNotes(Text);
  end;
end;

procedure TNotes.TextToNotes(const Text: string);
var
  Data: string;
  SNote: string;
  SInterval: string;
  Note: TNote;
  SVolume: string;
  NoteValue: Byte;
begin
  Clear;
  Data := Text;
  while (Data <> '')and(Data <> ';') do
  begin

    GetStr(Data, SNote);
    GetStr(Data, SInterval);
    GetStr(Data, SVolume);

    if NameToNote(SNote, NoteValue) then
    begin
      Note := Add;
      Note.Note := NoteValue;
      Note.Interval := StrToInt(SInterval);
      Note.Volume := StrToInt(SVolume);
    end;
  end;
end;

function TNotes.NameToNote(const NoteName: string; var Note: Byte): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := Low(NoteNames) to High(NoteNames) do
  begin
    if NoteNames[i] = NoteName then
    begin
      Note := i;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TNotes.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

procedure TNotes.Assign(Source: TPersistent);
var
  i: Integer;
  Src: TNotes;
begin
  if Source is TNotes then
  begin
    Src := Source as TNotes;

    Clear;
    for i := 0 to Src.Count-1 do
      Add.Assign(Src[i]);
  end else
    inherited Assign(Source);
end;

function TNotes.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

{ TNote }

procedure TNote.Assign(Source: TPersistent);
var
  Src: TNote;
begin
  if Source is TNote then
  begin
    Src := Source as TNote;

    Note := Src.Note;
    Volume := Src.Volume;
    Interval := Src.Interval;
  end
  else inherited Assign(Source);
end;

procedure TNote.Clear;
begin
  inherited Clear;
  Note := 0;
  Volume := 0;
  Interval := 0;
end;

function TNote.GetDisplayText: string;
begin
  Result := Format('%s;%d;%d', [NoteToName(Note), Interval, Volume]);
end;

procedure TNote.SetInterval(const Value: Byte);
begin
  FInterval := Value;
  Modified;
end;

procedure TNote.SetNote(const Value: Byte);
begin
  FNote := Value;
  Modified;
end;

procedure TNote.SetVolume(const Value: Byte);
begin
  FVolume := Value;
  Modified;
end;

function StrToHex(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + IntToHex(Ord(S[i]), 2);
end;

{ TIButton }

constructor TIButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSendCode := True;
  FNotes := TNotes.Create(Self);
  FPrefix := TScanCodes.Create(Self);
  FSuffix := TScanCodes.Create(Self);
  FDefKey := TIButtonKey.Create(Self);
  FDefKey.FRegistered := False;

  FRegKeys := TIButtonKeys.Create(Self);
end;

procedure TIButton.SetRegKeys(const Value: TIButtonKeys);
begin
  RegKeys.Assign(Value);
end;

procedure TIButton.SetDefKey(const Value: TIButtonKey);
begin
  DefKey.Assign(Value);
end;

procedure TIButton.Assign(Source: TPersistent);
var
  Src: TIButton;
begin
  if Source is TIButton then
  begin
    Src := Source as TIButton;

    Notes := Src.Notes;
    DefKey := Src.DefKey;
    Prefix := Src.Prefix;
    Suffix := Src.Suffix;
    RegKeys := Src.RegKeys;
    SendCode := Src.SendCode;
  end else
    inherited Assign(Source);
end;

procedure TIButton.SetNotes(const Value: TNotes);
begin
  Notes.Assign(Value);
end;

procedure TIButton.SetPrefix(const Value: TScanCodes);
begin
  Prefix.Assign(Value);
end;

procedure TIButton.SetSuffix(const Value: TScanCodes);
begin
  Suffix.Assign(Value);
end;

procedure TIButton.Clear;
begin
  inherited Clear;
  Notes.Clear;
  Prefix.Clear;
  Suffix.Clear;
  DefKey.Clear;
  RegKeys.Clear;
  SendCode := False;
end;

function TIButton.IsEmpty: Boolean;
begin
  Result :=
    Notes.IsEmpty and
    Prefix.IsEmpty and
    Suffix.IsEmpty and
    DefKey.IsEmpty and
    RegKeys.IsEmpty;
end;

function TIButton.CheckItem(var CheckResult: TCheckResult): Boolean;
begin
  Result := Prefix.CheckScancodes(CheckResult);
  if not Result then Exit;

  Result := Suffix.CheckScancodes(CheckResult);
end;

{ TIButtonKeys }

function TIButtonKeys.Add: TIButtonKey;
begin
  Result := TIButtonKey.Create(Self);
end;

function TIButtonKeys.GetItem(Index: Integer): TIButtonKey;
begin
  Result := Components[Index] as TIButtonKey;
end;

function TIButtonKeys.AddItem: TIButtonKey;
begin
  if (Count = MaxCount)and(MaxCount <> 0) then
    raise Exception.CreateFmt(MsgMaxElementCount, [MaxCount]);

  Result := Add;
end;

function TIButtonKeys.ItemByNumber(const ANumber: string): TIButtonKey;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if (Result.Number = ANumber)and Result.Registered then Exit;
  end;
  Result := nil;
end;

function TIButtonKeys.ValidIndex(Index: Integer): Boolean;
begin
  Result := (Index >= 0)and(Index < Count);
end;

function TIButtonKeys.GetCount: Integer;
begin
  Result := ComponentCount;
end;

procedure TIButtonKeys.Assign(Source: TPersistent);
var
  i: Integer;
  Src: TIButtonKeys;
begin
  if Source is TIButtonKeys then
  begin
    Src := Source as TIButtonKeys;

    Clear;
    for i := 0 to Src.Count-1 do
      Add.Assign(Src[i]);
  end else
    inherited Assign(Source);
end;

function TIButtonKeys.ItemByHexNumber(const Value: string): TIButtonKey;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.NumberAsHex = Value then Exit;
  end;
  Result := nil;
end;

function TIButtonKeys.IsFreeHexNumber(const Value: string): Boolean;
begin
  Result := ItemByHexNumber(Value) <> nil;
end;

procedure TIButtonKeys.Clear;
begin
  DestroyComponents;
  inherited Clear;
end;

function TIButtonKeys.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

{ TIButtonKey }

constructor TIButtonKey.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNotes := TNotes.Create(Self);
  FCodes := TScanCodes.Create(Self);
  FRegistered := True;
end;

procedure TIButtonKey.Assign(Source: TPersistent);
var
  Src: TIButtonKey;
begin
  if Source is TIButtonKey then
  begin
    Src := Source as TIButtonKey;

    Notes := Src.Notes;
    Codes := Src.Codes;
    Number := Src.Number;
    CodeType := Src.CodeType;
    Registered := Src.Registered;
  end
  else inherited Assign(Source);
end;

procedure TIButtonKey.Clear;
begin
  Number := '';
  Registered := False;
  inherited Clear;
end;

function TIButtonKey.IsEmpty: Boolean;
begin
  Result := (Number = '') and (not Registered) and Codes.IsEmpty;
end;

function TIButtonKey.GetDisplayText: string;
begin
  if Registered then Result := NumberAsHex
  else Result := MsgUnregistered;
end;

function TIButtonKey.CanDelete: Boolean;
begin
  Result := Registered;
end;

procedure TIButtonKey.Delete;
begin
  if Registered then Free else
  raise Exception.Create(MsgCannotDeleteRegisteredKey);
end;

procedure TIButtonKey.SetCodes(const Value: TScanCodes);
begin
  Codes.Assign(Value);
end;

procedure TIButtonKey.SetNotes(const Value: TNotes);
begin
  Notes.Assign(Value);
end;

function TIButtonKey.GetNumberAsHex: string;
begin
  Result := StrToHex(Number);
end;

procedure TIButtonKey.SetNumberAsHex(const Value: string);
begin
  Number := HexToStr(Value);
end;

procedure TIButtonKey.CheckNumber(const Value: string);
var
  Item: TIButtonKey;
  Items: TIButtonKeys;
begin
  if (Owner <> nil)and(Owner is TIButtonKeys) then
  begin
    Items := Owner as TIButtonKeys;
    Item := Items.ItemByNumber(Value);
    if (Item <> nil)and(Item <> Self) then
      raise EParserError.CreateFmt(MsgKeyExists, [Item.NumberAsHex]);
  end;
end;

procedure TIButtonKey.SetNumber(const Value: string);
begin
  if Value <> Number then
  begin
    CheckNumber(Value);
    FNumber := Value;
  end;
end;

function ScanCodeToHex(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + IntToHex(Ord(S[i]), 2);
end;

function GetBreakCode(const Code: string): string;
var
  i: Integer;
  E0Found: Boolean;
begin
  Result := '';
  E0Found := False;
  for i := 1 to Length(Code) do
  begin
    Result := Result + Code[i];
    if Code[i] = #$E0 then
    begin
      E0Found := True;
      Result := Result + #$F0;
    end;
  end;
  if not E0Found then
    Result := #$F0 + Result;
end;

function TIButtonKey.CheckItem(var CheckResult: TCheckResult): Boolean;
begin
  Result := Codes.CheckScancodes(CheckResult);
end;

{ TScanCodes }

constructor TScanCodes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxCount := $FF;
end;

function TScanCodes.Add: TScanCode;
begin
  Result := TScanCode.Create(Self);
end;

function TScanCodes.GetItem(Index: Integer): TScanCode;
begin
  Result := Components[Index] as TScanCode;
end;

procedure TScanCodes.Assign(Source: TPersistent);
var
  i: Integer;
  Src: TScanCodes;
begin
  if Source is TScanCodes then
  begin
    Src := Source as TScanCodes;

    Clear;
    for i := 0 to Src.Count-1 do
      Add.Assign(Src[i]);
  end else
    inherited Assign(Source);
end;

function TScanCodes.AddRawCode(const Code: string): TScanCode;
begin
  Result := Add;
  Result.Code := Code;
  Result.CodeType := ctRaw;
  Result.Text := ScanCodeToHex(Code);
end;

procedure TScanCodes.TextToScanCode(const S: string);
var
  SC: TScanCode;
  ScanCodeName: string;
begin
  if Length(S) = 0 then Exit;
  ScanCodeName := Copy(S, 2, Length(S));

  case S[1] of
    '+':
    begin
      SC := Manager.CodeTable.ItemByName(ScanCodeName, ctMake);
      Add.Assign(SC);
    end;
    '-':
    begin
      SC := Manager.CodeTable.ItemByName(ScanCodeName, ctBreak);
      Add.Assign(SC);
    end;
  else
    raise Exception.CreateFmt(MsgInvalidCode, [S]);
  end;
end;

procedure TScanCodes.FromString(const Str: string);
var
  i: Integer;
  FormatStr: string;
begin
  FormatStr := '';
  for i := 1 to Length(Str) do
  begin
    FormatStr := FormatStr + '+' + Str[i] + ' -' + Str[i] + ' ';
  end;
  AsText := FormatStr;
end;

procedure TScanCodes.AddCode(Code: Word);
var
  Data: string;
begin
  if Hi(Code) > 0 then
    Data := Chr(Hi(Code));
  if Lo(Code) > 0 then
    Data := Data + Chr(Lo(Code));
  SetBinaryData(Data);
end;

function TScanCode.SetData(var Data: string): Boolean;
var
  i: Integer;
  ACode: string;
  Count: Integer;
  ScanCode: TScanCode;
begin
  Result := False;
  if Length(Data) = 0 then Exit;

  Count := Min(Length(Data), Manager.CodeTable.MaxCodeLength);
  for i := 1 to Count do
  begin
    ACode := Copy(Data, 1, i);
    ScanCode := Manager.CodeTable.ScanCodes.ItemByCode(ACode);
    if ScanCode <> nil then
    begin
      Assign(ScanCode);
      Data := Copy(Data, i+1, Length(Data));
      Result := True;
      Exit;
    end;
  end;
  // Raw
  Result := True;
  CodeType := ctRaw;
  Code := Data;
  Text := StrToHex(Data);
end;

procedure TScanCodes.SetBinaryData(const S: string);
var
  Data: string;
  ScanCode: TScanCode;
  TmpScanCode: TScanCode;
begin
  Data := S;
  ScanCode := TScanCode.Create(nil);
  try
    while ScanCode.SetData(Data) do
    begin
      TmpScanCode := Add;
      TmpScanCode.Assign(ScanCode);
    end;
  finally
    ScanCode.Free;
  end;
end;

function TScanCodes.GetBinaryData: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count-1 do
    Result := Result + Items[i].Code;
end;

function TScanCodes.GetOwnerID: Integer;
begin
  Result := ID;
  if (Owner <> nil)and(Owner is TMComponent) then
    Result := (Owner as TMComponent).ID;
end;

function TScanCodes.GetLayoutID: Integer;
var
  AOwner: TComponent;
begin
  Result := 0;
  AOwner := Owner;
  while AOwner <> nil do
  begin
    if AOwner is TKBLayout then
    begin
      Result := (AOwner as TKBLayout).ID;
      Exit;
    end;
    AOwner := AOwner.Owner;
  end;
end;

function TScanCodes.CheckBreakBeforeMake(var CheckResult: TCheckResult): Boolean;
var
  S: string;
  i: Integer;
  sc: TScanCode;
  Codes: TScanCodes;
  ScanCode: TScanCode;
begin
  Result := True;
  Codes := TScanCodes.Create(nil);
  try
    for i := 0 to Count-1 do
    begin
      ScanCode := Items[i];

      if ScanCode.CodeType = ctMake then
        Codes.Add.Assign(ScanCode);

      if ScanCode.CodeType = ctBreak then
      begin
        sc := Codes.ItemByScanCode(ScanCode.ScanCode);
        if sc = nil then
        begin
          Inc(CheckResult.ErrCount);
          S := Format(MsgReleaseBeforePress,
            [AddPathSeparator(Path), ScanCode.DisplayText]);
          LogMessages.Add(S, GetLayoutID, GetOwnerID);
          Result := False;
        end;
        sc.Free;
      end;
    end;
  finally
    Codes.Free;
  end;
end;

function TScanCodes.CheckMakeWithoutBreak(var CheckResult: TCheckResult): Boolean;
var
  S: string;
  i: Integer;
  Codes: TScanCodes;
  ScanCode: TScanCode;
begin
  Result := True;
  Codes := TScanCodes.Create(nil);
  try
    for i := 0 to Count-1 do
    begin
      ScanCode := Items[i];

      if ScanCode.CodeType = ctMake then
        Codes.Add.Assign(ScanCode);

      if ScanCode.CodeType = ctBreak then
      begin
        Codes.ItemByScanCode(ScanCode.ScanCode).Free;
      end;
    end;

    for i := 0 to Codes.Count-1 do
    begin
      Inc(CheckResult.ErrCount);
      S := Format(MsgNoReleaseScancode,
        [AddPathSeparator(Path), Codes[i].DisplayText]);
      LogMessages.Add(S, GetLayoutID, GetOwnerID);
      Result := False;
    end;
  finally
    Codes.Free;
  end;
end;

function TScanCodes.CheckScancodes(var CheckResult: TCheckResult): Boolean;
begin
  Result := CheckMakeWithoutBreak(CheckResult);
  if not Result then
  begin
    Exit;
  end;

  Result := CheckBreakBeforeMake(CheckResult);
  if not Result then
  begin
    Exit;
  end;
end;

function TScanCodes.IsDataCorrect: Boolean;
var
  i: Integer;
  sc: TScanCode;
  Codes: TScanCodes;
  ScanCode: TScanCode;
  TmpScanCode: TScanCode;
begin
  Result := False;
  Codes := TScanCodes.Create(nil);
  try
    for i := 0 to Count-1 do
    begin
      ScanCode := Items[i];
      if ScanCode.CodeType = ctMake then
      begin
        sc := Codes.ItemByScanCode(ScanCode.ScanCode);
        if sc = nil then
        begin
          TmpScanCode := Codes.Add;
          TmpScanCode.Assign(ScanCode);
        end else
        begin
          
          if sc.CodeType = ctMake then Exit;
        end;
      end;
      if ScanCode.CodeType = ctBreak then
      begin
        sc := Codes.ItemByScanCode(ScanCode.ScanCode);
        if sc = nil then
        begin
          
          Exit;
        end else
        begin
          if sc.CodeType = ctMake then
            sc.Free;
        end;
      end;
    end;
    
    if Codes.Count > 0 then Exit;
  finally
    Codes.Free;
  end;
  Result := True;
end;

function TScanCodes.ItemByScanCode(const Value: string): TScanCode;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.ScanCode = Value then Exit;
  end;
  Result := nil;
end;

function TScanCodes.ItemByCode(const Value: string): TScanCode;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.Code = Value then Exit;
  end;
  Result := nil;
end;

function TScanCodes.GetSimpleText: string;
var
  i: Integer;
  Code1: TScanCode;
  Code2: TScanCode;
  Codes: TScanCodes;
  ResultString: string;
begin
  Result := AsText;
  if Result = '' then Exit;
  if not IsDataCorrect then Exit;

  Code2 := nil;
  ResultString := '';
  Codes := TScanCodes.Create(nil);
  try
    for i := 0 to Count-1 do
    begin
      Code1 := Items[i];
      if i < Count-1 then Code2 := Items[i+1];
      if Code1.CodeType = ctRaw then
      begin
        Exit;
      end;

      if Code1.CodeType = ctMake then
      begin
        Codes.Add.Assign(Code1);
        ResultString := ResultString + Code1.Text;
        if (Code2 <> nil)and(Code2.CodeType = ctMake) then
          ResultString := ResultString + '+';
      end;
      if Code1.CodeType = ctBreak then
      begin
        if Codes.Count > 0 then
        begin
          if AnsiCompareStr(Code1.Text, Codes[Codes.Count-1].Text) = 0 then
          begin
            Codes[Codes.Count-1].Free;
          end else
          begin
            Exit;
          end;
        end;

        if Codes.Count = 0 then
          ResultString := ResultString;
      end;
    end;
    Result := TrimRight(ResultString);
  finally
    Codes.Free;
  end;
end;

procedure TScanCodes.Clear;
begin
  DestroyComponents;
  Modified;
end;

function TScanCodes.GetCount: Integer;
begin
  Result := ComponentCount;
end;

procedure TScanCodes.AddCodes(ScanCodes: TScanCodes);
var
  i: Integer;
begin
  for i := 0 to ScanCodes.Count-1 do
    Add.Assign(ScanCodes[i]);
end;

function TScanCodes.GetAsText: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count-1 do
  begin
    if Result <> '' then Result := Result + ' ';
    Result := Result + Items[i].DisplayText;
  end;
end;


procedure TScanCodes.CheckScanCodesText(const Value: string);
var
  Codes: TScanCodes;
begin
  Codes := TScanCodes.Create(nil);
  try
    Codes.TextToScanCodes(Value);
  finally
    Codes.Free;
  end;
end;

procedure TScanCodes.SetAsText(const Value: string);
begin
  if Value <> AsText then
  begin
    CheckScanCodesText(Value);
    TextToScanCodes(Value);
  end;
end;

procedure TScanCodes.TextToScanCodes(const Value: string);
var
  i: Integer;
  Items: TStrings;
begin
  Clear;
  Items := TStringList.Create;
  try
    Split(Value, ' ', Items);
    for i := 0 to Items.Count-1 do
    begin
      TextToScanCode(Items[i]);
    end;
  finally
    Items.Free;
  end;
end;

procedure TScanCodes.CheckCode(const Code: string);
begin
  if MaxCount <> 0 then
  begin
    if Length(GetBinaryData) + Length(Code) > MaxCount then
      raise Exception.CreateFmt(MsgScanCodeLength, [MaxCount]);
  end;
end;

procedure TScanCodes.AddItems(Items: TScanCodes);
var
  i: Integer;
begin
  for i := 0 to Items.Count-1 do
    Add.Assign(Items[i]);
end;

procedure TScanCodes.SetDisplayText(const Value: string);
begin
  FDisplayText := Value;
  UpdateScanCodes(Value);
end;

function TScanCodes.Find(const Text: string; CodeType: TCodeType): TScanCode;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if (AnsiCompareText(Result.Text, Text) = 0)and(Result.CodeType = CodeType) then
      Exit;
  end;
  Result := nil;
end;

procedure TScanCodes.UpdateScanCodes(const Value: string);

  procedure AddScanCode(const KeyText: string; CodeType: TCodeType);
  var
    ScanCode: TScanCode;
  begin
    ScanCode := Manager.CodeTable.ScanCodes.Find(KeyText, CodeType);
    if ScanCode <> nil then Add.Assign(ScanCode);
  end;

var
  B: Boolean;
  i: Integer;
  Scan: UINT;
  VkKey: UINT;
  ScanCode: TScanCode;
  ShiftState: Shortint;
  VirtualKeyCode: Shortint;
  IsAltPressed: Boolean;        // ALT key is pressed
  IsShiftPressed: Boolean;      // SHIFT key is pressed
  IsControlPressed: Boolean;    // CONTROL key is pressed
begin
  Clear;
  IsAltPressed := False;
  IsShiftPressed := False;
  IsControlPressed := False;

  for i := 1 to Length(Value) do
  begin
    VkKey := VkKeyScan(Value[i]);
    ShiftState := Shortint(Hi(VkKey));
    VirtualKeyCode := Shortint(Lo(VkKey));
    if (ShiftState <> -1)and(VirtualKeyCode <> -1) then
    begin
      // Shift
      B := TestBit(ShiftState, 0);
      if B <> IsShiftPressed then
      begin
        if B then AddScanCode('LShift', ctMake)
        else AddScanCode('LShift', ctBreak);
        IsShiftPressed := B;
      end;
      // Control
      B := TestBit(ShiftState, 1);
      if B <> IsControlPressed then
      begin
        if B then AddScanCode('LCtrl', ctMake)
        else AddScanCode('LCtrl', ctBreak);
        IsControlPressed := B;
      end;
      // Alt
      B := TestBit(ShiftState, 1);
      if B <> IsAltPressed then
      begin
        if B then AddScanCode('LAlt', ctMake)
        else AddScanCode('LAlt', ctBreak);
        IsAltPressed := B;
      end;
      Scan := MapVirtualKey(Lo(VkKey), 0);
      
      ScanCode := Manager.CodeTable.ItemByScanCode(Chr(Scan), ctMake);
      if ScanCode <> nil then Add.Assign(ScanCode);
      
      ScanCode := Manager.CodeTable.ItemByScanCode(Chr(Scan), ctBreak);
      if ScanCode <> nil then Add.Assign(ScanCode);
    end;
  end;
  
  if IsShiftPressed then
    AddScanCode('LShift', ctBreak);
  if IsControlPressed then
    AddScanCode('LCtrl', ctBreak);
  if IsAltPressed then
    AddScanCode('LAlt', ctBreak);
end;

procedure TScanCodes.SetSimpleText(const Value: string);
var
  S: string;
  i: Integer;
  SC: TScanCode;
  CodeName: string;
begin
  Clear;
  S := UpperCase(Value);
  for i := 1 to Length(S) do
  begin
    CodeName := S[i];
    if CodeName = ' ' then CodeName := 'SPACE';
    // Make
    SC := Manager.CodeTable.ItemByName(CodeName, ctMake);
    if SC <> nil then Add.Assign(SC);
    // Break
    SC := Manager.CodeTable.ItemByName(CodeName, ctBreak);
    if SC <> nil then Add.Assign(SC);
  end;
end;

function TScanCodes.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

{ TScanCode }

procedure TScanCode.Assign(Source: TPersistent);
var
  Src: TScanCode;
begin
  if Source is TScanCode then
  begin
    Src := Source as TScanCode;

    Text := Src.Text;
    Code := Src.Code;
    CodeType := Src.CodeType;
    ScanCode := Src.ScanCode;
    MakeCode := Src.MakeCode;
    BreakCode := Src.BreakCode;
  end else
    inherited Assign(Source);
end;

function TScanCode.CodeTypeText: string;
begin
  case CodeType of
    ctMake  : Result := '+';
    ctBreak : Result := '-';
    ctRaw   : Result := '';
  else
    raise Exception.Create(MsgInvalidCodeType);
  end;
end;

function TScanCode.GetDisplayText: string;
begin
  Result := CodeTypeText + Text;
end;

procedure TScanCode.SetCode(const Value: string);
begin
  if Value <> Code then
  begin
    if Value = '' then
      raise Exception.Create(MsgEmptyCode);

    { !!! }
    if Owner <> nil then
      (Owner as TScanCodes).CheckCode(Value);
    FCode := Value;
  end;
end;

procedure TScanCode.Clear;
begin
  inherited Clear;
  Text := '';
  Code := '';
  ScanCode := '';
  CodeType := ctMake;
end;

procedure TScanCodes.FindData(const Data: string; var FR: TFindResult);
var
  S: string;
begin
  if AnsiPos(AnsiUpperCase(Data), AnsiUpperCase(AsText)) > 0 then
  begin
    S := Format(MsgTextFound, [Path, Data]);
    LogMessages.Add(S, GetLayoutID, GetOwnerID);
    Inc(FR.MatchCount);
  end;
end;

procedure TScanCodes.ReplaceData(const Data, ReplaceTo: string; var FR: TFindResult);
var
  S: string;
  ScancodeText: string;
begin
  ScancodeText := AsText;
  if AnsiPos(AnsiUpperCase(Data), AnsiUpperCase(ScancodeText)) > 0 then
  begin
    S := StringReplace(ScancodeText, Data, ReplaceTo, [rfReplaceAll, rfIgnoreCase]);
    if S <> ScancodeText then
    begin
      AsText := S;
      S := Format(MsgTextReplaced, [Path, Data, ReplaceTo]);
      LogMessages.Add(S, GetLayoutID, GetOwnerID);
      Inc(FR.MatchCount);
    end;
  end;
end;

{ TCodeTables }

constructor TCodeTables.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TCodeTables.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TCodeTables.Clear;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].Free;
  FList.Clear;
end;

function TCodeTables.GetCount: Integer;
begin
  if FList = nil then Result := 0
  else Result := FList.Count;
end;

function TCodeTables.GetItem(Index: Integer): TCodeTable;
begin
  Result := FList[Index];
end;

function TCodeTables.Add: TCodeTable;
begin
  Result := TCodeTable.Create;
  FList.Add(Result);
end;

function TCodeTables.AddItem(const Text: string): TCodeTable;
begin
  Result := TCodeTable.Create;
  FList.Add(Result);
  Result.Text := Text;
end;

procedure TCodeTables.SetDefaults;
var
  CodeTable: TCodeTable;
begin
  Clear;
  // Alphabetic english
  CodeTable := AddItem(MsgAlphabeticEnglish);
  CodeTable.Add('A', #$1E, #$1C, #$F0#$1C);
  CodeTable.Add('B', #$30, #$32, #$F0#$32);
  CodeTable.Add('C', #$2E, #$21, #$F0#$21);
  CodeTable.Add('D', #$20, #$23, #$F0#$23);
  CodeTable.Add('E', #$12, #$24, #$F0#$24);
  CodeTable.Add('F', #$21, #$2B, #$F0#$2B);
  CodeTable.Add('G', #$22, #$34, #$F0#$34);
  CodeTable.Add('H', #$23, #$33, #$F0#$33);
  CodeTable.Add('I', #$17, #$43, #$F0#$43);
  CodeTable.Add('J', #$24, #$3B, #$F0#$3B);
  CodeTable.Add('K', #$25, #$42, #$F0#$42);
  CodeTable.Add('L', #$26, #$4B, #$F0#$4B);
  CodeTable.Add('M', #$32, #$3A, #$F0#$3A);
  CodeTable.Add('N', #$31, #$31, #$F0#$31);
  CodeTable.Add('O', #$18, #$44, #$F0#$44);
  CodeTable.Add('P', #$19, #$4D, #$F0#$4D);
  CodeTable.Add('Q', #$10, #$15, #$F0#$15);
  CodeTable.Add('R', #$13, #$2D, #$F0#$2D);
  CodeTable.Add('S', #$1F, #$1B, #$F0#$1B);
  CodeTable.Add('T', #$14, #$2C, #$F0#$2C);
  CodeTable.Add('U', #$16, #$3C, #$F0#$3C);
  CodeTable.Add('V', #$2F, #$2A, #$F0#$2A);
  CodeTable.Add('W', #$11, #$1D, #$F0#$1D);
  CodeTable.Add('X', #$2D, #$22, #$F0#$22);
  CodeTable.Add('Y', #$15, #$35, #$F0#$35);
  CodeTable.Add('Z', #$2C, #$1A, #$F0#$1A);
  // Numbers
  CodeTable := AddItem(MsgNumbers);
  CodeTable.Add('0', #$0B, #$45, #$F0#$45);
  CodeTable.Add('1', #$02, #$16, #$F0#$16);
  CodeTable.Add('2', #$03, #$1E, #$F0#$1E);
  CodeTable.Add('3', #$04, #$26, #$F0#$26);
  CodeTable.Add('4', #$05, #$25, #$F0#$25);
  CodeTable.Add('5', #$06, #$2E, #$F0#$2E);
  CodeTable.Add('6', #$07, #$36, #$F0#$36);
  CodeTable.Add('7', #$08, #$3D, #$F0#$3D);
  CodeTable.Add('8', #$09, #$3E, #$F0#$3E);
  CodeTable.Add('9', #$0A, #$46, #$F0#$46);
  // Symbols
  CodeTable := AddItem(MsgSymbols);
  CodeTable.Add('`',  #$29, #$0E, #$F0#$0E);
  CodeTable.Add('-',  #$0C, #$4E, #$F0#$4E);
  CodeTable.Add('=',  #$0D, #$55, #$F0#$55);
  CodeTable.Add('\',  #$2B, #$5D, #$F0#$5D);
  CodeTable.Add('[',  #$1A, #$54, #$F0#$54);
  CodeTable.Add(']',  #$1B, #$5B, #$F0#$5B);
  CodeTable.Add(';',  #$27, #$4C, #$F0#$4C);
  CodeTable.Add('''', #$28, #$52, #$F0#$52);
  CodeTable.Add(',',  #$33, #$41, #$F0#$41);
  CodeTable.Add('.',  #$34, #$49, #$F0#$49);
  CodeTable.Add('/',  #$35, #$4A, #$F0#$4A);
  // Control keys
  CodeTable := AddItem(MsgControlKeys);
  CodeTable.Add('Backspace', #$0E, #$66, #$F0#$66);
  CodeTable.Add('Space',     #$39, #$29, #$F0#$29);
  CodeTable.Add('TAB',       #$0F, #$0D, #$F0#$0D);
  CodeTable.Add('CAPS',      #$3A, #$58, #$F0#$58);
  CodeTable.Add('LShift',    #$2A, #$12, #$F0#$12);
  CodeTable.Add('RShift',    #$36, #$59, #$F0#$59);
  CodeTable.Add('LCtrl',     #$1D, #$14, #$F0#$14);
  CodeTable.Add('RCtrl',     #$E0#$1D, #$E0#$14, #$E0#$F0#$14);
  CodeTable.Add('LWin',      #$E0#$5B, #$E0#$1F, #$E0#$F0#$1F);
  CodeTable.Add('LAlt',      #$38, #$11, #$F0#$11);
  CodeTable.Add('RWin',      #$E0#$5C, #$E0#$27, #$E0#$F0#$27);
  CodeTable.Add('RAlt',      #$E0#$38, #$E0#$11, #$E0#$F0#$11);
  CodeTable.Add('APPS',      #$E0#$5D, #$E0#$2F, #$E0#$F0#$2F);
  CodeTable.Add('ENTER',     #$1C, #$5A, #$F0#$5A);
  CodeTable.Add('ESC',       #$01, #$76, #$F0#$76);
  CodeTable.Add('F1',        #$3B, #$05, #$F0#$05);
  CodeTable.Add('F2',        #$3C, #$06, #$F0#$06);
  CodeTable.Add('F3',        #$3D, #$04, #$F0#$04);
  CodeTable.Add('F4',        #$3E, #$0C, #$F0#$0C);
  CodeTable.Add('F5',        #$3F, #$03, #$F0#$03);
  CodeTable.Add('F6',        #$40, #$0B, #$F0#$0B);
  CodeTable.Add('F7',        #$41, #$83, #$F0#$83);
  CodeTable.Add('F8',        #$42, #$0A, #$F0#$0A);
  CodeTable.Add('F9',        #$43, #$01, #$F0#$01);
  CodeTable.Add('F10',       #$44, #$09, #$F0#$09);
  CodeTable.Add('F11',       #$57, #$78, #$F0#$78);
  CodeTable.Add('F12',       #$58, #$07, #$F0#$07);
  CodeTable.Add('Scroll',    #$46, #$7E, #$F0#$7E);
  CodeTable.Add('INSERT',    #$E0#$52,  #$E0#$70, #$E0#$F0#$70);
  CodeTable.Add('HOME',      #$E0#$47,  #$E0#$6C, #$E0#$F0#$6C);
  CodeTable.Add('PageUp',    #$E0#$49, #$E0#$7D, #$E0#$F0#$7D);
  CodeTable.Add('DELETE',    #$E0#$53, #$E0#$71, #$E0#$F0#$71);
  CodeTable.Add('END',       #$E0#$4F, #$E0#$69, #$E0#$F0#$69);
  CodeTable.Add('Pagedown',  #$E0#$51, #$E0#$7A, #$E0#$F0#$7A);
  CodeTable.Add('Up',        #$E0#$48, #$E0#$75, #$E0#$F0#$75);
  CodeTable.Add('Down',      #$E0#$50, #$E0#$72, #$E0#$F0#$72);
  CodeTable.Add('Left',      #$E0#$4B, #$E0#$6B, #$E0#$F0#$6B);
  CodeTable.Add('Right',     #$E0#$4D, #$E0#$74, #$E0#$F0#$74);
  CodeTable.Add('PrintScrn', #$E0#$37, #$E0#$12#$E0#$7C, #$E0#$F0#$7C#$E0#$F0#$12);
  CodeTable.Add('Pause/Break', #$45, #$E1#$14#$77, #$E1#$F0#$14#$F0#$77);
  // Keypad
  CodeTable := AddItem('Keypad');
  CodeTable.Add('NumLock', #$E0#$45, #$77, #$F0#$77);
  CodeTable.Add('</>',     #$E0#$35, #$E0#$4A, #$E0#$F0#$4A);
  CodeTable.Add('<*>',     #$37, #$7C, #$F0#$7C);
  CodeTable.Add('<->',     #$4A, #$7B, #$F0#$7B);
  CodeTable.Add('<+>',     #$4E, #$79, #$F0#$79);
  CodeTable.Add('<Enter>', #$E0#$1C, #$E0#$5A, #$E0#$F0#$5A);
  CodeTable.Add('<.>',     #$53, #$71, #$F0#$71);
  CodeTable.Add('<0>',     #$52, #$70, #$F0#$70);
  CodeTable.Add('<1>',     #$4F, #$69, #$F0#$69);
  CodeTable.Add('<2>',     #$50, #$72, #$F0#$72);
  CodeTable.Add('<3>',     #$51, #$7A, #$F0#$7A);
  CodeTable.Add('<4>',     #$4B, #$6B, #$F0#$6B);
  CodeTable.Add('<5>',     #$4C, #$73, #$F0#$73);
  CodeTable.Add('<6>',     #$4D, #$74, #$F0#$74);
  CodeTable.Add('<7>',     #$47, #$6C, #$F0#$6C);
  CodeTable.Add('<8>',     #$48, #$75, #$F0#$75);
  CodeTable.Add('<9>',     #$49, #$7D, #$F0#$7D);
  // ACPI
  CodeTable := AddItem(MsgACPI);
  CodeTable.Add('Power', #$E0#$5E, #$E0#$37, #$E0#$F0#$37);
  CodeTable.Add('Sleep', #$E0#$5F, #$E0#$3F, #$E0#$F0#$3F);
  CodeTable.Add('Wake',  #$E0#$63, #$E0#$5E, #$E0#$F0#$5E);
  // Multimedia
  CodeTable := AddItem(MsgMultimedia);
  CodeTable.Add('NextTrack', #$E0#$19, #$E0#$4D, #$E0#$F0#$4D);
  CodeTable.Add('PreviousTrack', #$E0#$10, #$E0#$15, #$E0#$F0#$15);
  CodeTable.Add('Stop', #$E0#$24, #$E0#$3B, #$E0#$F0#$3B);
  CodeTable.Add('Play/Pause', #$E0#$22, #$E0#$34, #$E0#$F0#$34);
  CodeTable.Add('Mute', #$E0#$20, #$E0#$23, #$E0#$F0#$23);
  CodeTable.Add('VolumeUp', #$E0#$30,  #$E0#$32, #$E0#$F0#$32);
  CodeTable.Add('VolumeDown', #$E0#$2E, #$E0#$21, #$E0#$F0#$21);
  CodeTable.Add('MediaSelect', #$E0#$6D,  #$E0#$50, #$E0#$F0#$50);
  CodeTable.Add('E-Mail', #$E0#$6C, #$E0#$48, #$E0#$F0#$48);
  CodeTable.Add('Calculator', #$E0#$21, #$E0#$2B, #$E0#$F0#$2B);
  CodeTable.Add('MyComputer', #$E0#$6B,  #$E0#$40, #$E0#$F0#$40);
  // WWW
  CodeTable := AddItem('WWW');
  CodeTable.Add('WWWSearch', #$E0#$65, #$E0#$10, #$E0#$F0#$10);
  CodeTable.Add('WWWHome', #$E0#$32,  #$E0#$3A, #$E0#$F0#$3A);
  CodeTable.Add('WWWBack', #$E0#$6A, #$E0#$38, #$E0#$F0#$38);
  CodeTable.Add('WWWForward', #$E0#$69,  #$E0#$30, #$E0#$F0#$30);
  CodeTable.Add('WWWStop', #$E0#$68, #$E0#$28, #$E0#$F0#$28);
  CodeTable.Add('WWWRefresh', #$E0#$67, #$E0#$20, #$E0#$F0#$20);
  CodeTable.Add('WWWFavorites', #$E0#$66, #$E0#$18, #$E0#$F0#$18);
end;

{ TCodeTable }

constructor TCodeTable.Create;
begin
  inherited Create;
  FScanCode := TScanCode.Create(nil);
  FScanCodes := TScanCodes.Create(nil);
  FScanCodes.MaxCount := 0;
end;

destructor TCodeTable.Destroy;
begin
  FScanCode.Free;
  FScanCodes.Free;
  inherited Destroy;
end;

procedure TCodeTable.LoadFromCodeTables(CodeTables: TCodeTables);
var
  i: Integer;
begin
  ScanCodes.Clear;
  for i := 0 to CodeTables.Count-1 do
    ScanCodes.AddCodes(CodeTables[i].ScanCodes);
  FMaxCodeLength := GetMaxCodeLength;
end;

function TCodeTable.ItemByName(const Value: string;
  CodeType: TCodeType): TScanCode;
var
  i: Integer;
begin
  for i := 0 to ScanCodes.Count-1 do
  begin
    Result := scanCodes[i];
    if (Result.CodeType = CodeType) and
      (AnsiCompareText(Result.Text, Value) = 0) then Exit;
  end;
  raise Exception.CreateFmt(MsgScancodeNotFound, [Value]);
end;

function TCodeTable.ItemByScanCode(const Value: string; CodeType: TCodeType): TScanCode;
var
  i: Integer;
begin
  for i := 0 to ScanCodes.Count-1 do
  begin
    Result := ScanCodes[i];
    if (Result.ScanCode = Value)and(Result.CodeType = CodeType) then Exit;
  end;
  Result := nil;
end;

///////////////////////////////////////////////////////////////////////////////
//

//
///////////////////////////////////////////////////////////////////////////////

function TCodeTable.FromMessage(const Msg: TMsg; Options: TKeyOptions): TScanCode;
var
  Code: Word;
  ScanCode: string;
  IsKeyUp: Boolean;
  IsKeyDown: Boolean;
  CodeType: TCodeType;
begin
  Result := nil;
  try
    IsKeyUp := (Msg.message = WM_KEYUP) or (Msg.message = WM_SYSKEYUP);
    IsKeyDown := (Msg.message = WM_KEYDOWN)or(Msg.message = WM_SYSKEYDOWN);
    if (not IsKeyUp) and (not IsKeyDown) then Exit;

    if IsKeyUp and (not(koBreak in Options)) then Exit;
    if IsKeyDown and (not(koMake in Options)) then Exit;
    
    if (IsKeyDown and TestBit(Msg.lParam, 30))and (not(koRepeat in Options)) then Exit;

    if not((Msg.lParam and $FFFF)=1) then Exit;

    Code := Msg.lParam shr 16;
    ScanCode := Chr(Lo(Code));
    if TestBit(Hi(Code), 0) then
      ScanCode := #$E0 + ScanCode;

    if IsKeyDown then CodeType := ctMake
    else CodeType := ctBreak;
    Result := Manager.CodeTable.ItemByScanCode(ScanCode, CodeType);

    if Result = nil then
    begin
      Result := FScanCode;
      Result.ScanCode := ScanCode;
      Result.CodeType := CodeType;
      Result.Text := StrToHex(ScanCode);
    end;
  except
    { !!! }
  end;
end;

function TCodeTable.GetMaxCodeLength: Integer;
var
  i: Integer;
  CodeLength: Integer;
begin
  Result := 0;
  for i := 0 to ScanCodes.Count-1 do
  begin
    CodeLength := Length(ScanCodes[i].Code);
    if CodeLength > Result then Result := CodeLength;
  end;
end;

procedure TCodeTable.Add(const AText, AScanCode, AMakeCode, ABreakCode: string);
var
  ScanCode: TScanCode;
begin
  // Make
  ScanCode := ScanCodes.Add;
  ScanCode.Text := AText;
  ScanCode.Code := AMakeCode;
  ScanCode.MakeCode := AMakeCode;
  ScanCode.BreakCode := ABreakCode;
  ScanCode.CodeType := ctMake;
  ScanCode.ScanCode := AScanCode;
  // Break
  ScanCode := ScanCodes.Add;
  ScanCode.Text := AText;
  ScanCode.Code := ABreakCode;
  ScanCode.MakeCode := AMakeCode;
  ScanCode.BreakCode := ABreakCode;
  ScanCode.CodeType := ctBreak;
  ScanCode.ScanCode := AScanCode;
end;

{ TKeyPicture }

constructor TKeyPicture.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextFont := TFont.Create;
  FPicture := TPicture.Create;
  FBackgroundColor := clWhite;
end;

destructor TKeyPicture.Destroy;
begin
  FPicture.Free;
  FTextFont.Free;
  inherited Destroy;
end;

procedure TKeyPicture.Clear;
begin
  FText := '';
  Picture.Assign(nil);
  FLoadError := False;
  FLoadErrorText := '';
  FVerticalText := False;
  FBackgroundColor := clWhite;
end;

procedure TKeyPicture.Assign(Source: TPersistent);
var
  Src: TKeyPicture;
begin
  if Source is TKeyPicture then
  begin
    Src := Source as TKeyPicture;

    Text := Src.Text;
    Data := Src.Data;
    Picture := Src.Picture;
    TextFont := Src.TextFont;
    VerticalText := Src.VerticalText;
    BackgroundColor := Src.BackgroundColor;
  end else
    inherited Assign(Source);
end;

function TKeyPicture.GetData: string;
var
  Stream: TMemoryStream;
begin
  Result := '';
  Stream := TMemoryStream.Create;
  try
    Stream.WriteComponent(Self);
    if Stream.Size > 0 then
    begin
      Stream.Position := 0;
      SetLength(Result, Stream.Size);
      Stream.ReadBuffer(Result[1], Stream.Size);
      Result := StrToBin(Result);
    end;
  finally
    Stream.Free;
  end;
end;

procedure TKeyPicture.SetData(Value: string);
var
  Stream: TMemoryStream;
begin
  Value := HexToStr(Value);
  if Length(Value) = 0 then Exit;

  Stream := TMemoryStream.Create;
  try
    Stream.WriteBuffer(Value[1], Length(Value));
    Stream.Position := 0;
    Stream.ReadComponent(Self);

    if Picture.Graphic <> nil then
      Picture.Graphic.Transparent := True;
  finally
    Stream.Free;
  end;
end;

procedure TKeyPicture.SetTextFont(Value: TFont);
begin
  TextFont.Assign(Value);
  Modified;
end;

procedure TKeyPicture.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
  Modified;
end;

function TKeyPicture.GetHasData: Boolean;
begin
  Result := (Picture.Graphic <> nil)and(not Picture.Graphic.Empty);
end;

procedure TKeyPicture.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  Modified;
end;

procedure TKeyPicture.SetText(const Value: string);
begin
  FText := Value;
  Modified;
end;

procedure TKeyPicture.SetVerticalText(const Value: Boolean);
begin
  FVerticalText := Value;
  Modified;
end;

{ TPressCodes }

function TPressCodes.CheckItem(var CheckResult: TCheckResult): Boolean;
begin
  Result := CheckBreakBeforeMake(CheckResult);
end;

{ TReleaseCodes }

function TReleaseCodes.CheckItem(var CheckResult: TCheckResult): Boolean;
begin
  Result := CheckMakeWithoutBreak(CheckResult);
end;

{ TKBLayouts }

function TKBLayouts.GetCount: Integer;
begin
  Result := ComponentCount;
end;

function TKBLayouts.GetItem(Index: Integer): TKBLayout;
begin
  Result := Components[Index] as TKBLayout;
end;

{ TKBLayoutLink }

destructor TKBLayoutLink.Destroy;
begin
  SetLayout(nil);
  inherited Destroy;
end;

procedure TKBLayoutLink.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TKBLayoutLink.SetLayout(const ALayout: TKBLayout);
begin
  if ALayout <> Layout then
  begin
    if FLayout <> nil then FLayout.RemoveLink(Self);
    if ALayout <> nil then ALayout.AddLink(Self);
  end;
end;

end.
