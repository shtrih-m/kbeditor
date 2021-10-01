unit GridType;

interface

uses
  // VCL
  Windows;

type
  TGridCoord = record
    X: Longint;
    Y: Longint;
  end;

  TGridRect = record
    case Integer of
      0: (Left, Top, Right, Bottom: Longint);
      1: (TopLeft, BottomRight: TGridCoord);
  end;

function CompareGridRect(V1, V2: TGridRect): Boolean;
function GridRectIntersect(const Rect1, Rect2: TGridRect): Boolean;
function PointInRect(const Rect: TGridRect; const Point: TGridCoord): Boolean;

implementation

function CompareGridRect(V1, V2: TGridRect): Boolean;
begin
  Result :=
    (V1.Left = V2.Left) and
    (V1.Top = V2.Top) and
    (V1.Right = V2.Right) and
    (V1.Bottom = V2.Bottom);
end;

function PointInRect(const Rect: TGridRect; const Point: TGridCoord): Boolean;
begin
  Result :=
    (Point.x >= Rect.Left)and(Point.X <= Rect.Right)and
    (Point.y >= Rect.Top)and(Point.y <= Rect.Bottom);
end;

function GridRectIntersect(const Rect1, Rect2: TGridRect): Boolean;
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

  Result := PointInRect(Rect2, TopLeft) or PointInRect(Rect2, TopRight) or
    PointInRect(Rect2, BottomLeft) or PointInRect(Rect2, BottomRight);
end;

end.

