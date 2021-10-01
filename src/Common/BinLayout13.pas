unit BinLayout13;

interface

uses
  // VCL
  Windows, SysUtils,
  // This
  BinLayout28, KBLayout;

type
  { TBinLayout13 }

  TBinLayout13 = class(TBinLayout28)
  public
    function GetMinVersion: Word; override;
    function GetMaxVersion: Word; override;
    function GetFilter: string; override;
  end;

implementation

resourcestring
  MsgBinLayout13 = 'KB-Editor layout (program 1.3) (*.bin)|*.bin';


function TBinLayout13.GetFilter: string;
begin
  Result := MsgBinLayout13;
end;

function TBinLayout13.GetMinVersion: Word;
begin
  Result := $100;
end;

function TBinLayout13.GetMaxVersion: Word;
begin
  Result := $1FF;
end;

end.
