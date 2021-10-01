unit KeyboardTypes;

interface

uses
  // VCl
  Windows;

const
  DevicePacketSize = 128; // Maximum packet size
  DevicePageSize = 256; // Keyboard memory page size

  // Keyboard indicators
  KEYBOARD_SCROLL_LOCK_ON       = $01;
  KEYBOARD_NUM_LOCK_ON          = $02;
  KEYBOARD_CAPS_LOCK_ON         = $04;
  KEYBOARD_LAYER1_ON            = $08;
  KEYBOARD_LAYER2_ON            = $10;
  KEYBOARD_LAYER3_ON            = $20;
  KEYBOARD_LAYER4_ON            = $40;

  LastDeviceID: Integer = 0;

type
  // Keyboard application mode
  TAppMode = (amProg, amLoader);

  // amProgram - keyboard program
  // amLoader  - keyboard loader

  // Keyboard data mode
  TDataMode = (dmData, dmProg);

  // dmData - data
  // dmProg - program

  { TDeviceInfo }

  TDeviceInfo = record
    Version: Word;              // Program version
    VersionText: string;        // Device program version
    MajorVersion: Byte;         // Major version
    MinorVersion: Byte;         // Minor version
    MemSize: Word;              // Device memory size
    Model: Byte;                // Model
    LayerCount: Byte;           // Layer count
    PosCount: Byte;             // Key position count
    KeyCount: Integer;          // Key count
    Track1: Boolean;            // MSR supports track1
    Track2: Boolean;            // MSR supports track2
    Track3: Boolean;            // MSR supports track3
  end;

  { TDeviceStatus }

  TDeviceStatus = record
    Status: Byte;               // Status code
    CRCOK: Boolean;             // Keyboard program is correct (CRC OK)
    AppMode: TAppMode;          // Keyboard application mode
    DataMode: TDataMode;        // Keyboard data mode
    IsValidLayout: Boolean;     // Is valid layout loaded?
  end;

  { TShortingRec }

  TShortingRec = record
    Data: array [1..3] of Byte;
    Rows: array [1..16] of Boolean;
    Cols: array [1..8] of Boolean;
    RowsShorted: Integer;
    ColsShorted: Integer;
    IsShorted: Boolean;
  end;

  { IKeyboardDevice }

  IKeyboardDevice = interface
    ['{39239D59-B4DD-4003-BAB7-CB77D7A3C1AC}']

    procedure Open;
    procedure Close;
    function GetID: Integer;
    function GetName: string;
    function GetIndicators: Byte;
    function GetUniqueName: string;
    function GetDeviceName: string;
    procedure SetIndicators(Value: Byte);
    procedure SetDeviceName(const Value: string);
    function SendData(const TxData: string; MaxCount: Integer): string;

    property ID: Integer read GetID;
    property Name: string read GetName;
    property UniqueName: string read GetUniqueName;
    property DeviceName: string read GetDeviceName write SetDeviceName;
  end;

  { IKeyboardDriver }

  IKeyboardDriver = interface
  ['{F274F79D-4760-4118-8BB8-4FE1B7F1A059}']

    function GetIndicators: Byte;
    function GetPageSize: Integer;
    function GetPacketSize: Integer;
    function GetDeviceVersion: Word;
    function CheckShorting: Boolean;
    function GetResetDelay: Integer;
    function GetDevice: IKeyboardDevice;
    function GetWriteModeCount: Integer;
    function GetMaxFrameErrors: Integer;
    function GetMaxDeviceErrors: Integer;
    function GetWriteModeTimeout: Integer;
    function GetDeviceStatus: TDeviceStatus;
    function GetProgramStatus: TDeviceStatus;
    function ReadDeviceModel: Integer;
    function GetShorting: TShortingRec;
    function GetDeviceInfo: TDeviceInfo;
    function GetLoaderInfo: TDeviceInfo;
    function GetProgramInfo: TDeviceInfo;
    function ReadWord(Address: Word): Word;
    function IsShorted(const Data: TShortingRec): Boolean;
    function ReadMemory(Address, DataLength: Word): string;
    function CapShortingReport(DeviceInfo: TDeviceInfo): Boolean;

    procedure SetDefaults;
    procedure SetIndicators(Value: Byte);
    procedure PlayNotes(const Data: string);
    procedure WaitForKeyboard(Timeout: DWORD);
    procedure SetDataMode(DataMode: TDataMode);
    procedure SetResetDelay(const Value: Integer);
    procedure SetDevice(const Value: IKeyboardDevice);
    procedure SetWriteModeCount(const Value: Integer);
    procedure SetMaxFrameErrors(const Value: Integer);
    procedure SetMaxDeviceErrors(const Value: Integer);
    procedure SetWriteModeTimeout(const Value: Integer);
    procedure WritePage(Address: Word; const S: string);
    procedure SetMode(AppMode: TAppMode; DataMode: TDataMode);
    procedure WritePacket(Address: Word; const Data: string);

    property PageSize: Integer read GetPageSize;
    property PacketSize: Integer read GetPacketSize;
    property Device: IKeyboardDevice read GetDevice write SetDevice;
    property ResetDelay: Integer read GetResetDelay write SetResetDelay;
    property MaxFrameErrors: Integer read GetMaxFrameErrors write SetMaxFrameErrors;
    property MaxDeviceErrors: Integer read GetMaxDeviceErrors write SetMaxDeviceErrors;
    property WriteModeCount: Integer read GetWriteModeCount write SetWriteModeCount;
    property WriteModeTimeout: Integer read GetWriteModeTimeout write SetWriteModeTimeout;
  end;

implementation

end.


