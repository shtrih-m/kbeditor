unit MainDockForm;

interface

uses
  // VCL
  Windows, Messages, Controls, ExtCtrls, Classes, Forms,
  // JVCL
  JvComponentBase, JvFormPlacement,
  // This
  DockableForm, SizeableForm, dmuData;

type
  { TMainDockForm }

  TMainDockForm = class(TSizeableForm)
    BottomDockPanel: TPanel;
    HSplitter: TSplitter;
    JvFormStorage1: TJvFormStorage;
    procedure DockPanelDockDrop(Sender: TObject;
      Source: TDragDockObject; X, Y: Integer);
    procedure DockPanelDockOver(Sender: TObject;
      Source: TDragDockObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure DockPanelUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure DockPanelGetSiteInfo(Sender: TObject;
      DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
      var CanDock: Boolean);
    procedure BottomDockPanelResize(Sender: TObject);
  protected
    FormDocked: Boolean;
    PanelHeight: Integer;
  public
    procedure ShowDockPanel(APanel: TPanel; MakeVisible: Boolean;
      Client: TControl); virtual;
  end;

implementation

{$R *.DFM}

{TMainForm}

procedure TMainDockForm.DockPanelDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  //OnDockDrop gets called AFTER the client has actually docked,
  //so we check for DockClientCount = 1 before making the dock panel visible.
  if (Sender as TPanel).DockClientCount = 1 then
    ShowDockPanel(Sender as TPanel, True, nil);
  (Sender as TPanel).DockManager.ResetBounds(True);
  //Make DockManager repaints it's clients.
end;

procedure TMainDockForm.DockPanelDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  ARect: TRect;
begin
  Accept := Source.Control is TDockableForm;
  if Accept then
  begin
    //Modify the DockRect to preview dock area.
    ARect.TopLeft := BottomDockPanel.ClientToScreen(
      Point(0, -Self.ClientHeight div 5));
    ARect.BottomRight := BottomDockPanel.ClientToScreen(
      Point(BottomDockPanel.Width, BottomDockPanel.Height));
    Source.DockRect := ARect;
  end;
end;

procedure TMainDockForm.DockPanelUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
  //OnUnDock gets called BEFORE the client is undocked, in order to optionally
  //disallow the undock. DockClientCount is never 0 when called from this event.
  if (Sender as TPanel).DockClientCount = 1 then
    ShowDockPanel(Sender as TPanel, False, nil);
end;

procedure TMainDockForm.ShowDockPanel(APanel: TPanel; MakeVisible: Boolean; Client: TControl);
begin
  if not MakeVisible and (APanel.VisibleDockClientCount > 1) then  Exit;
  HSplitter.Visible := MakeVisible;

  if MakeVisible then
  begin
    if PanelHeight > 1 then
      APanel.Height := PanelHeight
    else
      APanel.Height := ClientHeight div 5;
      
    APanel.Visible := True;
    HSplitter.Top := ClientHeight - APanel.Height - HSplitter.Width;
    FormDocked := True;
  end else
  begin
    APanel.Height := 1;
    PanelHeight := 1;
    FormDocked := False;
  end;
  if MakeVisible and (Client <> nil) then Client.Show;
end;

procedure TMainDockForm.DockPanelGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
  //if CanDock is true, the panel will not automatically draw the preview rect.
  CanDock := DockClient is TDockableForm;
end;

procedure TMainDockForm.BottomDockPanelResize(Sender: TObject);
begin
  if HSplitter.Visible then
  begin
    PanelHeight := BottomDockPanel.Height;
  end else
  begin
    BottomDockPanel.Height := 1;
    PanelHeight := 1;
  end;
end;

end.
