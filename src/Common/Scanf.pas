unit Scanf;

interface

uses
  // VCL
  SysUtils;

function Sscanf(const s: string; const fmt : string;
  const Pointers : array of Pointer) : Integer;

implementation

{ Sscanf parses an input string. The parameters ...
    s - input string to parse
    fmt - 'C' scanf-like format string to control parsing
      %d - convert a Long Integer
      %f - convert an Extended Float
      %s - convert a string (delimited by spaces)
      other char - increment s pointer past "other char"
      space - does nothing
    Pointers - array of pointers to have values assigned

    result - number of variables actually assigned

    for example with ...
      Sscanf('Name. Bill   Time. 7:32.77   Age. 8',
             '. %s . %d:%f . %d', [@Name, @hrs, @min, @age]);

    You get ...
      Name = Bill  hrs = 7  min = 32.77  age = 8                }

function Sscanf(const s: string; const fmt : string;
                      const Pointers : array of Pointer) : Integer;
var
  i,j,n,m : integer;
  s1      : string;
  L       : LongInt;
  X       : Extended;

  function GetInt : Integer;
  begin
    s1 := '';
    while (s[n] = ' ')  and (Length(s) > n) do inc(n);
    while (s[n] in ['0'..'9', '+', '-'])
      and (Length(s) >= n) do begin
      s1 := s1+s[n];
      inc(n);
    end;
    Result := Length(s1);
  end;

  function GetFloat : Integer;
  begin
    s1 := '';
    while (s[n] = ' ')  and (Length(s) > n) do inc(n);
    while (s[n] in ['0'..'9', '+', '-', '.', 'e', 'E'])
      and (Length(s) >= n) do begin
      s1 := s1+s[n];
      inc(n);
    end;
    Result := Length(s1);
  end;

  function GetString : Integer;
  begin
    s1 := '';
    while (s[n] = ' ')  and (Length(s) > n) do inc(n);
    while (s[n] <> ' ') and (Length(s) >= n) do
    begin
      s1 := s1+s[n];
      inc(n);
    end;
    Result := Length(s1);
  end;

  function ScanStr(c : Char) : Boolean;
  begin
    while (s[n] <> c) and (Length(s) > n) do inc(n);
    inc(n);

    If (n <= Length(s)) then Result := True
    else Result := False;
  end;

  function GetFmt : Integer;
  begin
    Result := -1;

    while (TRUE) do begin
      while (fmt[m] = ' ') and (Length(fmt) > m) do inc(m);
      if (m >= Length(fmt)) then break;

      if (fmt[m] = '%') then begin
        inc(m);
        case fmt[m] of
          'd': Result := vtInteger;
          'f': Result := vtExtended;
          's': Result := vtString;
        end;
        inc(m);
        break;
      end;

      if (ScanStr(fmt[m]) = False) then break;
      inc(m);
    end;
  end;

begin
  n := 1;
  m := 1;
  Result := 0;

  for i := 0 to High(Pointers) do begin
    j := GetFmt;

    case j of
      vtInteger : begin
        if GetInt > 0 then begin
          L := StrToInt(s1);
          Move(L, Pointers[i]^, SizeOf(LongInt));
          inc(Result);
        end
        else break;
      end;

      vtExtended : begin
        if GetFloat > 0 then begin
          X := StrToFloat(s1);
          Move(X, Pointers[i]^, SizeOf(Extended));
          inc(Result);
        end
        else break;
      end;

      vtString : begin
        if GetString > 0 then begin
          Move(s1, Pointers[i]^, Length(s1)+1);
          inc(Result);
        end
        else break;
      end;

      else break;
    end;
  end;
end;

end.


