unit XmlLayout;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Consts, Graphics,
  // This
  KBLayout, LayoutFormat, XMLLayoutEng, XMLLayoutRus, AppTypes, LogFile;

type
  { TXmlLayout }

  TXmlLayout = class(TKBLayoutFormat)
  private
    FXmlEng: TXmlLayoutEng;
    FXmlRus: TXmlLayoutRus;
  protected
    function GetFilter: string; override;
  public
    function GetMinVersion: Word; override;
    function GetMaxVersion: Word; override;
  public
    constructor Create(AOwner: TKBLayoutFormats); override;
    destructor Destroy; override;

    procedure SaveToStream(Layout: TKBLayout; Stream: TStream); override;
    procedure LoadFromStream(Layout: TKBLayout; Stream: TStream); override;
    procedure SaveToFile(Layout: TKBLayout; const FileName: string); override;
    procedure LoadFromFile(Layout: TKBLayout; const FileName: string); override;
  end;

  { TXmlLayout13 }

  // Save layout in KBEditor 1.3 format

  TXmlLayout13 = class(TKBLayoutFormat)
  private
    FXmlEng: TXmlLayoutEng13;
    FXmlRus: TXmlLayoutRus13;
  protected
    function GetFilter: string; override;
  public
    function GetMinVersion: Word; override;
    function GetMaxVersion: Word; override;
  public
    constructor Create(AOwner: TKBLayoutFormats); override;
    destructor Destroy; override;

    procedure SaveToStream(Layout: TKBLayout; Stream: TStream); override;
    procedure LoadFromStream(Layout: TKBLayout; Stream: TStream); override;
    procedure SaveToFile(Layout: TKBLayout; const FileName: string); override;
    procedure LoadFromFile(Layout: TKBLayout; const FileName: string); override;
  end;

implementation

{ TXmlLayout }

constructor TXmlLayout.Create(AOwner: TKBLayoutFormats);
begin
  inherited Create(AOwner);
  FXmlEng := TXmlLayoutEng.Create(nil);
  FXmlRus := TXmlLayoutRus.Create(nil);
end;

destructor TXmlLayout.Destroy;
begin
  FXmlEng.Free;
  FXmlRus.Free;
  inherited Destroy;
end;

function TXmlLayout.GetFilter: string;
begin
  Result := MsgXmlLayout;
end;

function TXmlLayout.GetMaxVersion: Word;
begin
  Result := $2FF;
end;

function TXmlLayout.GetMinVersion: Word;
begin
  Result := $200;
end;

procedure TXmlLayout.LoadFromFile(Layout: TKBLayout;
  const FileName: string);
begin
  Logger.Debug('TXmlLayout.LoadFromFile', [FileName]);

  try
    FXmlEng.LoadFromFile(Layout, FileName);
    Exit;
  except
    on E: Exception do
     Logger.Error(E.Message);
  end;
  FXmlRus.LoadFromFile(Layout, FileName);
end;

procedure TXmlLayout.LoadFromStream(Layout: TKBLayout; Stream: TStream);
begin
  Logger.Debug('TXmlLayout.LoadFromStream');
  try
    FXmlEng.LoadFromStream(Layout, Stream);
    Exit;
  except
    on E: Exception do
     Logger.Error(E.Message);
  end;
  FXmlRus.LoadFromStream(Layout, Stream);
end;

procedure TXmlLayout.SaveToFile(Layout: TKBLayout; const FileName: string);
begin
  Logger.Debug('TXmlLayout.SaveToFile', [FileName]);
  FXmlEng.SaveToFile(Layout, FileName);
end;

procedure TXmlLayout.SaveToStream(Layout: TKBLayout; Stream: TStream);
begin
  Logger.Debug('TXmlLayout.SaveToStream');
  FXmlEng.SaveToStream(Layout, Stream);
end;

{ TXmlLayout13 }

constructor TXmlLayout13.Create(AOwner: TKBLayoutFormats);
begin
  inherited Create(AOwner);
  FXmlEng := TXmlLayoutEng13.Create(nil);
  FXmlRus := TXmlLayoutRus13.Create(nil);
end;

destructor TXmlLayout13.Destroy;
begin
  FXmlEng.Free;
  FXmlRus.Free;
  inherited Destroy;
end;

function TXmlLayout13.GetFilter: string;
begin
  Result := MsgXmlLayout13;
end;

function TXmlLayout13.GetMaxVersion: Word;
begin
  Result := $1FF;
end;

function TXmlLayout13.GetMinVersion: Word;
begin
  Result := $100;
end;

procedure TXmlLayout13.LoadFromFile(Layout: TKBLayout;
  const FileName: string);
begin
  try
    FXmlEng.LoadFromFile(Layout, FileName);
    Exit;
  except
  end;
  FXmlRus.LoadFromFile(Layout, FileName);
end;

procedure TXmlLayout13.LoadFromStream(Layout: TKBLayout; Stream: TStream);
begin
  try
    FXmlEng.LoadFromStream(Layout, Stream);
    Exit;
  except
  end;
  FXmlRus.LoadFromStream(Layout, Stream);
end;

procedure TXmlLayout13.SaveToFile(Layout: TKBLayout;
  const FileName: string);
begin
  FXmlEng.SaveToFile(Layout, FileName);
end;

procedure TXmlLayout13.SaveToStream(Layout: TKBLayout; Stream: TStream);
begin
  FXmlEng.SaveToStream(Layout, Stream);
end;

end.
