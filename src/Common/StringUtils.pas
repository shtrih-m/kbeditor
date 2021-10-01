unit StringUtils;

interface

uses
  // VCL
  Classes;
  
procedure Split(const Line, Separator: string; Lines: TStrings);

implementation

procedure Split(const Line, Separator: string; Lines: TStrings);
var
  S: string;
  S1: string;
  P: Integer;
begin
  Lines.Clear;
  S := Line;
  repeat
    P := Pos(Separator, S);
    if P <> 0 then
    begin
      S1 := Copy(S, 1, P-1);
      S := Copy(S, P + Length(Separator), Length(S));
      if S1 <> '' then Lines.Add(S1);
    end else
    begin
      if S <> '' then
        Lines.Add(S);
      Break;
    end;
  until false;
end;


end.
