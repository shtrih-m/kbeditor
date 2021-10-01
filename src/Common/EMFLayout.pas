unit EMFLayout;

interface

uses
  // VCL
  Classes, Graphics, Windows,
  // This
  KBLayout, KBLayoutPrint, LayoutFormat, Utils;

type
  { TEMFLayout }

  TEMFLayout = class(TKBLayoutFormat)
  protected
    function GetFilter: string; override;
  public
    procedure SaveToStream(Layout: TKBLayout; Stream: TStream); override;
  end;

implementation

resourcestring
  MsgEMFLayoutFilter    = 'Layout in EMF format (*.emf)|*.emf';

{ TEMFLayout }

function TEMFLayout.GetFilter: string;
begin
  Result := MsgEMFLayoutFilter;
end;

procedure TEMFLayout.SaveToStream(Layout: TKBLayout; Stream: TStream);
var
  MetaFile: TMetaFile;
  Print: TKBLayoutPrint;
  Canvas: TMetaFileCanvas;
  KeyWidth, KeyHeight, KeySpaceX, KeySpaceY: Integer;
  temp: Variant;
begin
  MetaFile := TMetaFile.Create;
  Print := TKBLayoutPrint.Create;
  Canvas := TMetaFileCanvas.Create(MetaFile, 0);
  try
    temp := GetDeviceCaps(Canvas.Handle, LOGPIXELSX) * KeyWidthInInch;
    KeyWidth := Integer(temp);
    temp := GetDeviceCaps(Canvas.Handle, LOGPIXELSY) * KeyHeightInInch;
    KeyHeight := Integer(temp);
    temp := GetDeviceCaps(Canvas.Handle, LOGPIXELSX) * KeySpaceXInInch;
    KeySpaceX := Integer(temp);
    temp := GetDeviceCaps(Canvas.Handle, LOGPIXELSY) * KeySpaceYInInch;
    KeySpaceY := Integer(temp);
    Print.PrintLayout(Layout, Canvas, KeyWidth, KeyHeight, KeySpaceX, KeySpaceY, Canvas.ClipRect);
    Canvas.Free;
    Metafile.SaveToStream(Stream);
  finally
    Print.Free;
    MetaFile.Free;
  end;
end;

end.
