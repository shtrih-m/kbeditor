unit fmuMain;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, ImgList, ToolWin, StdCtrls, ExtCtrls, Buttons,
  ClipBrd, Registry, ShellApi,
  // JVCL
  JvComponentBase, JvFormPlacement,
  // Toolbar 2000
  TB2Item, TB2Dock, TB2Toolbar, TB2MRU, TB2ExtItems, TB2MDI, TB2ToolWindow,
  // This
  dmuData, KBLayout, fmuKey, fmuAbout, fmuTest, KeyboardDriver, fmuKeyboard,
  fmuSettings, fmuDoc, Utils, fmuInfo, fmuProgress, KeyboardManager, fmuMSR,
  fmuKeyLock, fmuDevices, ActnList, Keyboard, untVInfo, ErrorReport, DriverUtils,
  fmuPicture, fmuPreview, NMHttp, fmuMessageWindow, DockableForm,
  MainDockForm, fmuFind, fmuReplace, fmuIButton, HelpFile, uProgress, Scanf,
  AppSettings, LogFile, ChangeNotifier, WorkItem,
  DebugUtils, fmuScrollWheel, PS2Keyboard, OperationThread,
  OperationInterface, ReadLayoutOperation, WriteLayoutOperation,
  WriteFirmwareFileOperation, WriteMemoryFileOperation, ReadMemoryFileOperation,
  ReadFirmwareFileOperation, LogMessage, FileUtils, KeyboardDevice,
  KeyboardTypes, KeyboardReport, fmuUpdates;

const
  WM_SENDREQUEST = WM_USER + 1;
  ProgressTimeout = 0;

type
  { TfmMain }

  TfmMain = class(TMainDockForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ImageList: TImageList;
    tbMenu: TTBToolbar;
    miFile: TTBSubmenuItem;
    miLayoutNew: TTBItem;
    miLayoutOpen: TTBItem;
    N2: TTBSeparatorItem;
    miLayoutSave: TTBItem;
    miLayoutSaveAs: TTBItem;
    miLayoutClose: TTBItem;
    miLayoutCloseAll: TTBItem;
    N1: TTBSeparatorItem;
    miExit: TTBItem;
    miKey: TTBSubmenuItem;
    miEditCut: TTBItem;
    miCopy: TTBItem;
    miEditPaste: TTBItem;
    miEditSelectAll: TTBItem;
    miKeyboard: TTBSubmenuItem;
    miDeviceInfo: TTBItem;
    miView: TTBSubmenuItem;
    miHelp: TTBSubmenuItem;
    miSep: TTBSeparatorItem;
    miAbout: TTBItem;
    TopDock: TTBDock;
    BottomDock: TTBDock;
    LeftDock: TTBDock;
    RightDock: TTBDock;
    tbDevice: TTBToolbar;
    tbLayoutInfo: TTBItem;
    tbLayoutWrite: TTBItem;
    miLayoutWrite: TTBItem;
    miLayoutRead: TTBItem;
    TBSeparatorItem3: TTBSeparatorItem;
    tbLayoutRead: TTBItem;
    TBSeparatorItem4: TTBSeparatorItem;
    tbWriteMemory: TTBItem;
    tbDeviceReadMemory: TTBItem;
    tbWriteProgram: TTBItem;
    miCascade: TTBItem;
    miTileH: TTBItem;
    miTileV: TTBItem;
    miEditClearAll: TTBItem;
    TBSeparatorItem6: TTBSeparatorItem;
    TBSeparatorItem7: TTBSeparatorItem;
    miEditGroup: TTBItem;
    miEditUngroup: TTBItem;
    tbViewMode: TTBToolbar;
    tbLayer1: TTBItem;
    tbLayer2: TTBItem;
    tbLayer3: TTBItem;
    tbLayer4: TTBItem;
    miWindow: TTBSubmenuItem;
    TBSubmenuItem1: TTBSubmenuItem;
    miLayer0: TTBItem;
    miLayer1: TTBItem;
    miLayer2: TTBItem;
    miLayer3: TTBItem;
    TBSubmenuItem2: TTBSubmenuItem;
    miToolbarStandard: TTBItem;
    miToolbarDevice: TTBItem;
    miToolbarViewMode: TTBItem;
    MRUList: TTBMRUList;
    miEditMSR: TTBItem;
    miEditKeyLock: TTBItem;
    TBSeparatorItem5: TTBSeparatorItem;
    miEditLayoutProp: TTBItem;
    TBMRUListItem: TTBMRUListItem;
    miMRUTopSeparator: TTBSeparatorItem;
    TBMDIHandler1: TTBMDIHandler;
    tbTest: TTBItem;
    miTest: TTBItem;
    ActionList: TActionList;
    actDeviceWriteLayout: TAction;
    actDeviceReadLayout: TAction;
    actDeviceReadInfo: TAction;
    actDeviceTest: TAction;
    actLayer1: TAction;
    actLayer2: TAction;
    actLayer3: TAction;
    actLayer4: TAction;
    actLayoutNew: TAction;
    actLayoutOpen: TAction;
    actLayoutSave: TAction;
    actEditCut: TAction;
    actEditCopy: TAction;
    actEditPaste: TAction;
    actLayoutSaveAs: TAction;
    actLayoutClose: TAction;
    actLayoutCloseAll: TAction;
    actEditSelectAll: TAction;
    actEditClear: TAction;
    actEditGroup: TAction;
    actEditUngroup: TAction;
    actEditMSR: TAction;
    actEditKeylock: TAction;
    actLayoutModel: TAction;
    actEditKeyProp: TAction;
    actDeviceReadMemory: TAction;
    actDeviceWriteMemory: TAction;
    actDeviceWriteProgram: TAction;
    actHelpAbout: TAction;
    actWindowTileVert: TAction;
    actWindowTileHor: TAction;
    actWindowCascade: TAction;
    TBSeparatorItem8: TTBSeparatorItem;
    miSettings: TTBSubmenuItem;
    TBSeparatorItem9: TTBSeparatorItem;
    miAppSettings: TTBItem;
    miDevices: TTBItem;
    actCheckLayout: TAction;
    TBItem2: TTBItem;
    TBSeparatorItem10: TTBSeparatorItem;
    miInstallDrv: TTBItem;
    miUninstallDrv: TTBItem;
    TBSeparatorItem11: TTBSeparatorItem;
    miWork: TTBItem;
    miLoader: TTBItem;
    miCaption: TTBItem;
    TBSeparatorItem12: TTBSeparatorItem;
    miFind: TTBItem;
    actEditFind: TAction;
    TBSubmenuItem3: TTBSubmenuItem;
    miViewPicture: TTBItem;
    miViewLayout: TTBItem;
    actViewLayout: TAction;
    actViewPicture: TAction;
    TBSeparatorItem13: TTBSeparatorItem;
    miPrint: TTBItem;
    PrintDialog: TPrintDialog;
    actPrint: TAction;
    miPreview: TTBItem;
    actPrintPreview: TAction;
    actViewSimple: TAction;
    TBItem7: TTBItem;
    miUpdate: TTBItem;
    TBSeparatorItem15: TTBSeparatorItem;
    miMessageWindow: TTBItem;
    PopupMenu: TTBPopupMenu;
    miMessages: TTBItem;
    actEditReplace: TAction;
    miReplace: TTBItem;
    miDoc: TTBItem;
    actEditIButtons: TAction;
    tbReadProgram: TTBItem;
    actDeviceReadProgram: TAction;
    TBItem8: TTBItem;
    actFillTestLayout: TAction;
    tbLayout: TTBToolbar;
    tbEditGroup: TTBItem;
    tbUngroup: TTBItem;
    tbKeyProps: TTBItem;
    tbMSR: TTBItem;
    tbKeyLock: TTBItem;
    tbIButton: TTBItem;
    TBSeparatorItem16: TTBSeparatorItem;
    tbModel: TTBItem;
    TBItem1: TTBItem;
    actLayer0: TAction;
    tbEditKeyProp: TTBItem;
    actMessageWindow: TAction;
    actToolbarLayout: TAction;
    miToolbarLayout: TTBItem;
    actToolbarStandard: TAction;
    actToolbarDevice: TAction;
    actToolbarViewMode: TAction;
    TBItem4: TTBItem;
    TBItem6: TTBItem;
    TBItem3: TTBItem;
    TBSeparatorItem2: TTBSeparatorItem;
    TBControlItem1: TTBControlItem;
    Label1: TLabel;
    TBControlItem2: TTBControlItem;
    cbDevices: TComboBox;
    btnRefresh: TTBItem;
    TBSeparatorItem17: TTBSeparatorItem;
    tbStandard: TTBToolbar;
    tbLayoutNew: TTBItem;
    tbLayoutOpen: TTBItem;
    tbLayoutSave: TTBItem;
    TBSeparatorItem1: TTBSeparatorItem;
    tbEditCut: TTBItem;
    tbEditCopy: TTBItem;
    tbEditPaste: TTBItem;
    tbEditFind: TTBItem;
    tbEditReplace: TTBItem;
    TBSeparatorItem14: TTBSeparatorItem;
    TBItem5: TTBItem;
    tbScrollWheel: TTBItem;
    actScrollWheel: TAction;
    TBItem9: TTBItem;
    JvFormStorage: TJvFormStorage;
    Timer: TTimer;
    actShowLoaderInfo: TAction;
    miLoaderInfo: TTBItem;

    procedure UpdateDevices;
    function GetViewMode: TViewMode;
    procedure SetViewMode(const Value: TViewMode);
    procedure FormCreate(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure MRUListClick(Sender: TObject; const Filename: String);
    procedure MRUListChange(Sender: TObject);
    procedure actDeviceWriteLayoutExecute(Sender: TObject);
    procedure actDeviceReadLayoutExecute(Sender: TObject);
    procedure actDeviceReadInfoExecute(Sender: TObject);
    procedure actDeviceTestExecute(Sender: TObject);
    procedure LayersExecute(Sender: TObject);
    procedure ViewsExecute(Sender: TObject);
    procedure PrintPreviewExecute(Sender: TObject);
    procedure actLayoutNewExecute(Sender: TObject);
    procedure actLayoutOpenExecute(Sender: TObject);
    procedure actEditCutExecute(Sender: TObject);
    procedure actEditCopyExecute(Sender: TObject);
    procedure actEditPasteExecute(Sender: TObject);
    procedure actLayoutSaveAsExecute(Sender: TObject);
    procedure actLayoutCloseExecute(Sender: TObject);
    procedure actLayoutCloseAllExecute(Sender: TObject);
    procedure actEditSelectAllExecute(Sender: TObject);
    procedure actEditClearExecute(Sender: TObject);
    procedure actEditGroupExecute(Sender: TObject);
    procedure actEditUngroupExecute(Sender: TObject);
    procedure actEditMSRExecute(Sender: TObject);
    procedure actEditKeylockExecute(Sender: TObject);
    procedure actLayoutModelExecute(Sender: TObject);
    procedure actEditKeyPropExecute(Sender: TObject);
    procedure actDeviceWriteMemoryExecute(Sender: TObject);
    procedure actDeviceWriteProgramExecute(Sender: TObject);
    procedure actHelpAboutExecute(Sender: TObject);
    procedure actWindowTileVertExecute(Sender: TObject);
    procedure actWindowTileHorExecute(Sender: TObject);
    procedure actWindowCascadeExecute(Sender: TObject);
    procedure actLayoutSaveExecute(Sender: TObject);
    procedure actDeviceReadMemoryExecute(Sender: TObject);
    procedure miAppSettingsClick(Sender: TObject);
    procedure miDevicesClick(Sender: TObject);
    procedure actCheckLayoutExecute(Sender: TObject);
    procedure miInstallDrvClick(Sender: TObject);
    procedure miUninstallDrvClick(Sender: TObject);
    procedure miLoaderClick(Sender: TObject);
    procedure miWorkClick(Sender: TObject);
    procedure miCaptionClick(Sender: TObject);
    procedure actEditFindExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure miUpdateClick(Sender: TObject);
    procedure SendRequest(var Msg: TMessage); message WM_SENDREQUEST;
    procedure miMessagesClick(Sender: TObject);
    procedure cbDevicesChange(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure actEditReplaceExecute(Sender: TObject);
    procedure miDocClick(Sender: TObject);
    procedure actEditIButtonsExecute(Sender: TObject);
    procedure actDeviceReadProgramExecute(Sender: TObject);
    procedure actFillTestLayoutExecute(Sender: TObject);
    procedure actMessageWindowExecute(Sender: TObject);
    procedure StorageRestorePlacement(Sender: TObject);
    procedure actToolbarLayoutExecute(Sender: TObject);
    procedure actToolbarStandardExecute(Sender: TObject);
    procedure actToolbarDeviceExecute(Sender: TObject);
    procedure tbStandardClose(Sender: TObject);
    procedure tbViewModeClose(Sender: TObject);
    procedure actToolbarViewModeExecute(Sender: TObject);
    procedure tbLayoutClose(Sender: TObject);
    procedure tbDeviceClose(Sender: TObject);
    procedure actScrollWheelExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actShowLoaderInfoExecute(Sender: TObject);
  private
    FActiveDoc: TfmDoc;
    FLink: TKBLayoutLink;
    FHelpProcess: TProcess;

    procedure UpdatePage;
    procedure DisableEvents;
    function GetLayout: TKBLayout;
    function GetActiveDoc: TfmDoc;
    procedure SetMessageWindowView;
    function HasActiveDoc: Boolean;
    function CreateDocument: TfmDoc;
    function GetHelpFileName: string;
    procedure ShowDocument(Doc: TfmDoc);
    function CheckCorrectLayout: Boolean;
    procedure SetLayout(Value: TKBLayout);
    procedure DocActivate(Sender: TObject);
    function CheckFirmwareVersion: Boolean;
    function UpdateDeviceFirmware: Boolean;
    procedure EnableActions(Value: Boolean);
    procedure DocDeactivate(Sender: TObject);
    procedure LayoutChanged(Sender: TObject);
    procedure SetCaptionMode(Value: Boolean);
    procedure SetActiveDoc(const Value: TfmDoc);
    procedure AppException(Sender: TObject; E: Exception);
    procedure OpenFile(FilterIndex: Integer; const FileName: string);
    procedure PreviewClose(Sender: TObject; var Action: TCloseAction);
    procedure AddMRUItem(const FileName: string; FilterIndex: Integer);
    procedure OperationCompleted(Sender: TObject; Operation: IOperation);
    procedure ReadLayoutCompleted(Sender: TObject; Operation: IOperation);
    procedure StartOperation(Operation: IOperation; Proc: TOperationEvent);

    property Layout: TKBLayout read GetLayout write SetLayout;
    property ViewMode: TViewMode read GetViewMode write SetViewMode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure CreateDoc(Layout: TKBLayout);
    procedure ShowDockPanel(APanel: TPanel; MakeVisible: Boolean; Client: TControl); override;

    property ActiveDoc: TfmDoc read GetActiveDoc write SetActiveDoc;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

resourcestring
  MsgNoErrors           = 'No errors';
  MsgDriverVersion      = 'PS/2 driver version : ';
  MsgAppVersion         = 'Firmware version    : ';
  MsgNoActiveDoc        = 'No active document';
  MsgDriverNotInstalled = 'PS/2 driver is not installed.';
  MsgDriverNotLoaded    = 'PS/2 driver is installed, but not loaded.';
  MsgContinueInstall    = 'Connect keyboard, install driver and reboot your PC. Continue?';
  MsgNoLayout           = 'No active layout';

{ TfmMain }

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLink := TKBLayoutLink.Create;
  FLink.OnChange := LayoutChanged;
  FHelpProcess := TProcess.Create(Self);
  Application.OnException := AppException;
  Font := Settings.Font;
  SetMessageWindowView;
end;

destructor TfmMain.Destroy;
begin
  DisableEvents;

  Manager.DisableNotifications;
  Settings.DockPanelHeight := PanelHeight;
  Settings.MessageFormDocked := FormDocked;
  Settings.SaveSettings;
  Application.OnException := nil;
  FreeWorkThread;
  FLink.Free;
  inherited Destroy;
  FreeManager;
  FreeProgress;
  FreeLogMessages;
  FreeSettings;
end;

procedure TfmMain.DisableEvents;
var
  i: Integer;
  Form: TForm;
begin
  for i := MDIChildCount-1 downto 0 do
  begin
    Form := MDIChildren[I];
    if Form is TfmDoc then
    begin
      Form.OnActivate := nil;
      Form.OnDestroy := nil;
    end;
  end;
end;

function TfmMain.GetViewMode: TViewMode;
begin
  Result := Settings.ViewMode;
end;

procedure TfmMain.SetViewMode(const Value: TViewMode);
begin
  if Value <> Settings.ViewMode then
  begin
    Settings.ViewMode := Value;
    Manager.UpdateDocuments;
  end;
end;

procedure TfmMain.LayoutChanged(Sender: TObject);
begin
  UpdatePage;
end;

function TfmMain.GetActiveDoc: TfmDoc;
begin
  Result := FActiveDoc;
  if Result = nil then
    raise Exception.Create(MsgNoActiveDoc);
end;

function TfmMain.HasActiveDoc: Boolean;
begin
  Result := FActiveDoc <> nil;
end;

procedure TfmMain.SetActiveDoc(const Value: TfmDoc);
begin
  if Value <> FActiveDoc then
  begin
    FActiveDoc := Value;
    if FActiveDoc = nil then
    begin
      Layout := nil;
    end else
    begin
      Layout := FActiveDoc.Layout;
    end;
    UpdatePage;
  end;
end;

procedure TfmMain.SetLayout(Value: TKBLayout);
begin
  FLink.Layout := Value;
  fmKeyDlg.Layout := Value;
  fmPicture.Layout := Value;
end;

function TfmMain.GetLayout: TKBLayout;
begin
  Result := FLink.Layout;
  if Result = nil then
    raise Exception.Create(MsgNoLayout);
end;

procedure TfmMain.SetMessageWindowView;
begin
  fmMessageWindow := TfmMessageWindow.Create(Application);

  FormDocked := Settings.MessageFormDocked;
  if Settings.MessageFormDocked then
  begin
    PanelHeight := Settings.DockPanelHeight;
    fmMessageWindow.HostDockSite := BottomDockPanel;
    HSplitter.Visible := True;
    fmMessageWindow.Visible := True;
  end else
  begin
    PanelHeight := 1;
    BottomDockPanel.Height := 1;
    HSplitter.Visible := False;
    fmMessageWindow.Visible := False;
  end;
end;

procedure TfmMain.AppException(Sender: TObject; E: Exception);
begin
  Logger.Error('AppException: ' + E.Message);
  try
    if E is EKeyboardException then
    begin
      Application.ShowException(E);
    end else
    begin
      if not ReportError(E) then
        Application.ShowException(E);
    end;
  except
    on E: Exception do
    begin
      if not ReportError(E) then
        Application.ShowException(E);
    end;
  end;
end;

procedure TfmMain.AddMRUItem(const FileName: string; FilterIndex: Integer);
begin
  MRUList.Add(FileName);
end;

procedure TfmMain.OpenFile(FilterIndex: Integer; const FileName: string);
var
  Doc: TfmDoc;
begin
  AddMRUItem(FileName, FilterIndex);
  Doc := CreateDocument;
  Doc.Caption := ExtractFileName(FileName);
  Manager.LoadFromFile(Doc.Layout, FilterIndex, FileName);
  ShowDocument(Doc);
  UpdatePage;
end;

procedure TfmMain.ShowDocument(Doc: TfmDoc);
begin
  Doc.UpdatePage;
  Doc.FormStyle := fsMDIChild;
  UpdatePage;
end;

procedure TfmMain.DocActivate(Sender: TObject);
begin
  ActiveDoc := Sender as TfmDoc;
end;

procedure TfmMain.DocDeactivate(Sender: TObject);
begin
  ActiveDoc := nil;
end;

function TfmMain.CreateDocument: TfmDoc;
begin
  Result := TfmDoc.Create(Self);
  Result.OnActivate := DocActivate;
  Result.OnDestroy := DocDeactivate;
end;

procedure TfmMain.UpdateDevices;
begin
  Manager.UpdateDevices;
  Manager.GetDeviceNames(cbDevices.Items);
  cbDevices.ItemIndex := cbDevices.Items.IndexOfObject(TObject(Manager.DeviceID));
  cbDevices.Enabled := cbDevices.Items.Count > 1;
end;

procedure TfmMain.SetCaptionMode(Value: Boolean);
var
  i: Integer;
  Toolbar: TTBToolbar;
begin
  for i := 0 to ComponentCount-1 do
  begin
    if Components[i] is TTBToolbar then
    begin
      Toolbar := Components[i] as TTBToolbar;
      if Value then
        Toolbar.Options := Toolbar.Options + [tboImageAboveCaption]
      else
        Toolbar.Options := Toolbar.Options - [tboImageAboveCaption];
    end;
  end;
end;

procedure TfmMain.UpdatePage;
var
  FHasActiveDoc: Boolean;
begin
  FHasActiveDoc := HasActiveDoc;
  actLayoutSave.Enabled := FHasActiveDoc and Layout.CanSave;
  actLayoutSaveAs.Enabled := FHasActiveDoc;
  actLayoutClose.Enabled := FHasActiveDoc;
  actLayoutCloseAll.Enabled := FHasActiveDoc;
  actPrint.Enabled := FHasActiveDoc;
  actEditCut.Enabled := FHasActiveDoc;
  actEditCopy.Enabled := FHasActiveDoc;
  actEditPaste.Enabled := FHasActiveDoc and Layout.CanPaste;
  actEditReplace.Enabled := FHasActiveDoc;
  actEditFind.Enabled := FHasActiveDoc;
  actEditSelectAll.Enabled := FHasActiveDoc;
  actEditClear.Enabled := FHasActiveDoc;
  actEditGroup.Enabled := FHasActiveDoc and Layout.CanGroup;
  actEditUngroup.Enabled := FHasActiveDoc and Layout.CanUnGroup;
  actEditKeyLock.Enabled := FHasActiveDoc;
  actEditIButtons.Enabled := FHasActiveDoc;
  actSCrollWheel.Enabled := FHasActiveDoc;

  actLayoutModel.Enabled := FHasActiveDoc;
  actEditKeyProp.Enabled := FHasActiveDoc;
  actEditMSR.Enabled := FHasActiveDoc and Layout.HasMSR;
  actCheckLayout.Enabled := FHasActiveDoc;
  // Device
  actDeviceWriteLayout.Enabled := FHasActiveDoc;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    miInstallDrv.Enabled := True;
    miUninstallDrv.Enabled := True;
  end else
  begin
    miInstallDrv.Enabled := False;
    miUninstallDrv.Enabled := False;
  end;
  // Window
  actWindowTileVert.Enabled := FHasActiveDoc;
  actWindowTileHor.Enabled := FHasActiveDoc;
  actWindowCascade.Enabled := FHasActiveDoc;
  // View
  actLayer0.Enabled := FHasActiveDoc;
  actLayer1.Enabled := FHasActiveDoc;
  actLayer2.Enabled := FHasActiveDoc and (Layout.Layers.Count > 1);
  actLayer3.Enabled := FHasActiveDoc and (Layout.Layers.Count > 2);
  actLayer4.Enabled := FHasActiveDoc and (Layout.Layers.Count > 3);
  actViewLayout.Enabled := FHasActiveDoc;
  actViewPicture.Enabled := FHasActiveDoc;
  actViewSimple.Enabled := FHasActiveDoc;
  actPrintPreview.Enabled := FHasActiveDoc and (ViewMode <> vmLayout);
  actViewLayout.Checked := FHasActiveDoc and (ViewMode = vmLayout);
  actViewPicture.Checked := FHasActiveDoc and (ViewMode = vmPicture);
  actViewSimple.Checked := FHasActiveDoc and (ViewMode = vmSimple);
  actLayer0.Checked := FHasActiveDoc and (Layout.LayerIndex = -1);
  actLayer1.Checked := FHasActiveDoc and (Layout.LayerIndex = 0);
  actLayer2.Checked := FHasActiveDoc and (Layout.LayerIndex = 1);
  actLayer3.Checked := FHasActiveDoc and (Layout.LayerIndex = 2);
  actLayer4.Checked := FHasActiveDoc and (Layout.LayerIndex = 3);
  //
  actToolbarDevice.Checked := tbDevice.Visible;
  actToolbarLayout.Checked := tbLayout.Visible;
  actToolbarStandard.Checked := tbStandard.Visible;
  actToolbarViewMode.Checked := tbViewMode.Visible;

  //
  actMessageWindow.Checked := fmMessageWindow.Visible;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Caption := Caption + ' ' + GetFileVersionInfoStr;
  UpdateDevices;
  UpdatePage;

  if Settings.CheckUpdateOnLoad then
    PostMessage(Handle, WM_SENDREQUEST, 0,0);
end;

procedure TfmMain.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.MRUListClick(Sender: TObject; const Filename: String);
var
  FilterIndex: Integer;
begin
  FilterIndex := Integer(MRUList.Items.Objects[0]);
  OpenFile(FilterIndex, FileName);
end;

procedure TfmMain.MRUListChange(Sender: TObject);
begin
  miMRUTopSeparator.Visible := MRUList.Items.Count > 0;
end;

procedure TfmMain.EnableActions(Value: Boolean);
begin
  actDeviceWriteLayout.Enabled := Value;
  actDeviceReadLayout.Enabled := Value;
  actDeviceReadInfo.Enabled := Value;
  actDeviceTest.Enabled := Value;
  actLayer1.Enabled := Value;
  actLayer2.Enabled := Value;
  actLayer3.Enabled := Value;
  actLayer4.Enabled := Value;
  actLayoutNew.Enabled := Value;
  actLayoutOpen.Enabled := Value;
  actLayoutSave.Enabled := Value;
  actEditCut.Enabled := Value;
  actEditCopy.Enabled := Value;
  actEditPaste.Enabled := Value;
  actLayoutSaveAs.Enabled := Value;
  actLayoutClose.Enabled := Value;
  actLayoutCloseAll.Enabled := Value;
  actEditSelectAll.Enabled := Value;
  actEditClear.Enabled := Value;
  actEditGroup.Enabled := Value;
  actEditUngroup.Enabled := Value;
  actEditMSR.Enabled := Value;
  actEditKeylock.Enabled := Value;
  actLayoutModel.Enabled := Value;
  actEditKeyProp.Enabled := Value;
  actDeviceReadMemory.Enabled := Value;
  actDeviceWriteMemory.Enabled := Value;
  actDeviceWriteProgram.Enabled := Value;
  actHelpAbout.Enabled := Value;
  actWindowTileVert.Enabled := Value;
  actWindowTileHor.Enabled := Value;
  actWindowCascade.Enabled := Value;
  actCheckLayout.Enabled := Value;
  actEditFind.Enabled := Value;
  actViewLayout.Enabled := Value;
  actViewPicture.Enabled := Value;
  actPrint.Enabled := Value;
  actPrintPreview.Enabled := Value;
  actViewSimple.Enabled := Value;
  actEditReplace.Enabled := Value;
  actEditIButtons.Enabled := Value;
  actDeviceReadProgram.Enabled := Value;
  actFillTestLayout.Enabled := Value;
  actLayer0.Enabled := Value;
  actMessageWindow.Enabled := Value;
  actToolbarLayout.Enabled := Value;
  actToolbarStandard.Enabled := Value;
  actToolbarDevice.Enabled := Value;
  actToolbarViewMode.Enabled := Value;
  actScrollWheel.Enabled := Value;
end;

procedure TfmMain.ReadLayoutCompleted(Sender: TObject; Operation: IOperation);
var
  Layout: TKBLayout;
begin
  if WorkThread.Succeeded then
  begin
    Layout := (Operation as ILayoutOperation).GetLayout;
    CreateDoc(Layout);
    Layout.Free;
  end;
  OperationCompleted(Sender, Operation);
end;

procedure TfmMain.OperationCompleted(Sender: TObject; Operation: IOperation);
begin
  fmProgress.Close;
  Timer.Enabled := False;
  if WorkThread.Failed then
    MessageBox(Handle, PChar(WorkThread.ErrorMessage), PCHar(Application.Title), MB_ICONERROR);

  EnableActions(True);
  UpdatePage;
end;

procedure TfmMain.StartOperation(Operation: IOperation; Proc: TOperationEvent);
begin
  Progress.Clear;
  WorkThread.OnCompleted := Proc;
  WorkThread.Start(Operation);

  EnableActions(False);
  fmProgress.ClearPage;
  Timer.Enabled := True;
end;

///////////////////////////////////////////////////////////////////////////////
// Update device firmware

function TfmMain.UpdateDeviceFirmware: Boolean;
var
  OpenDialog: TOpenDialog;
  DeviceInfo: TDeviceInfo;
begin
  OpenDialog := TOpenDialog.Create(Application);
  try
    DeviceInfo := Manager.Driver.GetDeviceInfo;
    OpenDialog.Filter := OpenPrgFilter;
    OpenDialog.FileName := Manager.Keyboards.ItemByID(DeviceInfo.Model).FWFileName;
    OpenDialog.InitialDir := GetModulePath + 'Data\Programs';
    Result := OpenDialog.Execute;
    if Result then
    begin
      StartOperation(TWriteFirmwareFileOperation.Create(OpenDialog.FileName),
        OperationCompleted);
    end;
  finally
    OpenDialog.Free;
  end;
end;

//////////////////////////////////////////////////////////////////////////////
//  Checking keyboard firmware version
//  Checking minimal layout version

function TfmMain.CheckFirmwareVersion: Boolean;
var
  DeviceInfo: TDeviceInfo;
  DeviceStatus: TDeviceStatus;
begin
  Result := True;
  DeviceStatus := Manager.Driver.GetProgramStatus;
  if DeviceStatus.CRCOK then
  begin
    DeviceInfo := Manager.Driver.GetProgramInfo;
    if (
     (DeviceInfo.MajorVersion = 2)and
     (DeviceInfo.MinorVersion < 8)) or
     (DeviceInfo.MajorVersion < 2) then
    begin
      Result := MessageBox(Handle, pChar(MsgUpdatePrompt),
        PChar(MsgAttention), MB_ICONEXCLAMATION or MB_YESNO) = ID_YES;
      if Result then
        Result := UpdateDeviceFirmware;
    end;
  end;
end;

function TfmMain.CheckCorrectLayout: Boolean;
begin
  Result := Layout.CheckData;
  if not Result then
  begin
    Result := MessageBox(Handle, PChar(MsgLayoutInvalidCodes),
      PChar(MsgAttention), MB_ICONEXCLAMATION or MB_YESNO) = ID_YES;
  end;
end;

procedure TfmMain.actDeviceWriteLayoutExecute(Sender: TObject);
begin
  if Settings.SaveBeforeUpload then
    actLayoutSaveExecute(Sender);

  if CheckCorrectLayout and CheckFirmwareVersion then
    StartOperation(TWriteLayoutOperation.Create(Layout), OperationCompleted);
end;

procedure TfmMain.actDeviceReadLayoutExecute(Sender: TObject);
var
  Operation: IOperation;
begin
  Operation := TReadLayoutOperation.Create(Manager.CreateLayout);
  StartOperation(Operation, ReadLayoutCompleted);
end;

procedure TfmMain.actDeviceReadInfoExecute(Sender: TObject);
begin
  fmInfo.ReadApplicationReport;
end;

procedure TfmMain.actShowLoaderInfoExecute(Sender: TObject);
begin
  fmInfo.ReadLoaderReport;
end;

procedure TfmMain.actDeviceTestExecute(Sender: TObject);
begin
  fmTest.Show;
end;

procedure TfmMain.LayersExecute(Sender: TObject);
var
  LayerIndex: Integer;
begin
  LayerIndex := (Sender as TComponent).Tag-1;
  Layout.LayerIndex := LayerIndex;
  Settings.LayerIndex := LayerIndex;

  actLayer0.Checked := LayerIndex = -1;
  actLayer1.Checked := LayerIndex = 0;
  actLayer2.Checked := LayerIndex = 1;
  actLayer3.Checked := LayerIndex = 2;
  actLayer4.Checked := LayerIndex = 3;
end;

procedure TfmMain.actLayoutNewExecute(Sender: TObject);
begin
  ShowDocument(CreateDocument);
end;

procedure TfmMain.actLayoutOpenExecute(Sender: TObject);
begin
  OpenDialog.InitialDir := Manager.InitialDir;
  OpenDialog.FileName := Manager.InitialFileName;
  OpenDialog.Filter := Manager.GetOpenFilter;
  if OpenDialog.Execute then
    OpenFile(OpenDialog.FilterIndex-1, OpenDialog.FileName);
end;

procedure TfmMain.actLayoutSaveAsExecute(Sender: TObject);
begin
  SaveDialog.InitialDir := Manager.InitialDir;
  SaveDialog.FileName := Manager.InitialFileName;
  SaveDialog.Filter := Manager.GetSaveFilter;
  if Layout.FileName <> '' then
    SaveDialog.FileName := GetFileName(Layout.FileName)
  else
    SaveDialog.FileName := ActiveDoc.Caption;

  if SaveDialog.Execute then
  begin
    Manager.SaveToFile(Layout, SaveDialog.FilterIndex-1, SaveDialog.FileName);
    ActiveDoc.Caption := ExtractFileName(SaveDialog.FileName);
    Layout.ClearModified;
    AddMRUItem(SaveDialog.FileName, SaveDialog.FilterIndex);
  end;
end;

procedure TfmMain.actEditCutExecute(Sender: TObject);
begin
  ActiveDoc.CutSelection;
end;

procedure TfmMain.actEditCopyExecute(Sender: TObject);
begin
  ActiveDoc.CopySelection;
end;

procedure TfmMain.actEditPasteExecute(Sender: TObject);
begin
  Manager.PasteSelection(Layout);
end;

procedure TfmMain.actLayoutCloseExecute(Sender: TObject);
begin
  ActiveDoc.Close;
end;

procedure TfmMain.actLayoutCloseAllExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := MDIChildCount-1 downto 0 do
    MDIChildren[I].Close;
end;

procedure TfmMain.actEditSelectAllExecute(Sender: TObject);
begin
  Layout.SelectAll;
end;

procedure TfmMain.actEditClearExecute(Sender: TObject);
begin
  Layout.DeleteSelection;
end;

procedure TfmMain.actEditGroupExecute(Sender: TObject);
begin
  ActiveDoc.GroupKeys;
end;

procedure TfmMain.actEditUngroupExecute(Sender: TObject);
begin
  ActiveDoc.UngroupKeys;
end;

procedure TfmMain.actEditMSRExecute(Sender: TObject);
begin
  ShowMSRDlg(Layout.Layer.MSR);
end;

procedure TfmMain.actEditKeylockExecute(Sender: TObject);
begin
  ShowKeyLockDlg(Layout.Layer.Keylock);
end;

procedure TfmMain.actLayoutModelExecute(Sender: TObject);
begin
  ShowKeyboardDlg(Layout);
end;

procedure TfmMain.actEditKeyPropExecute(Sender: TObject);
begin
  ActiveDoc.ShowKeyProps;
end;

procedure TfmMain.actDeviceWriteMemoryExecute(Sender: TObject);
begin
  OpenDialog.InitialDir := Manager.InitialDir;
  OpenDialog.FileName := Manager.InitialFileName;
  OpenDialog.Filter := OpenBinFilter;
  OpenDialog.DefaultExt := 'bin';
  if OpenDialog.Execute then
  begin
    StartOperation(TWriteMemoryFileOperation.Create(OpenDialog.FileName),
      OperationCompleted);
  end;
end;

procedure TfmMain.actDeviceReadMemoryExecute(Sender: TObject);
begin
  SaveDialog.InitialDir := Manager.InitialDir;
  SaveDialog.FileName := Manager.InitialFileName;
  SaveDialog.Filter := SaveBinFilter;
  SaveDialog.DefaultExt := 'bin';
  if SaveDialog.Execute then
  begin
    StartOperation(TReadMemoryFileOperation.Create(SaveDialog.FileName),
      OperationCompleted);
  end;
end;

procedure TfmMain.actDeviceWriteProgramExecute(Sender: TObject);
begin
  OpenDialog.InitialDir := Manager.InitialDir;
  OpenDialog.Filter := OpenPrgTxtFilter;
  OpenDialog.DefaultExt := 'prg';
  if OpenDialog.Execute then
  begin
    StartOperation(TWriteFirmwareFileOperation.Create(OpenDialog.FileName),
      OperationCompleted);
  end;
end;

procedure TfmMain.actWindowTileVertExecute(Sender: TObject);
begin
  TileMode := tbVertical;
  Tile;
end;

procedure TfmMain.actWindowTileHorExecute(Sender: TObject);
begin                                   
  TileMode := tbHorizontal;
  Tile;
end;

procedure TfmMain.actWindowCascadeExecute(Sender: TObject);
begin
  Cascade;
end;

// About

procedure TfmMain.actHelpAboutExecute(Sender: TObject);
var
  PrgVersion: string;
  DrvVersion: string;
begin
  PrgVersion := MsgAppVersion + GetFileVersionInfoStr;
  DrvVersion := MsgDriverVersion + Manager.PS2Keyboard.GetDriverVersion;
  fmAbout.UpdatePage(Application.Title, [PrgVersion, DrvVersion]);
  fmAbout.ShowModal;
end;

procedure TfmMain.actLayoutSaveExecute(Sender: TObject);
begin
  if Layout.FileName = '' then
  begin
    actLayoutSaveAsExecute(Sender);
  end else
  begin
    Manager.SaveToFile(Layout, SaveDialog.FilterIndex-1,
      Layout.FileName);
    Layout.ClearModified;
  end;
  UpdatePage;
end;

procedure TfmMain.miAppSettingsClick(Sender: TObject);
begin
  ShowSettingsDlg;
end;

procedure TfmMain.miDevicesClick(Sender: TObject);
begin
  fmDevices.UpdatePage;
  fmDevices.ShowModal;
end;

procedure TfmMain.actCheckLayoutExecute(Sender: TObject);
begin
  fmMessageWindow.Clear;
  if Layout.CheckData then
  begin
    MessageBox(Handle, PChar(MsgNoErrors), PChar(Application.Title), MB_ICONINFORMATION);
  end else
    fmMessageWindow.ShowWindow(self);
end;

procedure TfmMain.miInstallDrvClick(Sender: TObject);
var
  Params: TDriverParams;
begin
  Params.MainWindow := Handle;
  Params.IsSilent := False;
  Params.ExeFileName := Application.ExeName;
  InstallDriver(Params);
end;

procedure TfmMain.miUninstallDrvClick(Sender: TObject);
var
  Params: TDriverParams;
begin
  Params.MainWindow := Handle;
  Params.IsSilent := False;
  Params.ExeFileName := Application.ExeName;
  UninstallDriver(Params);
end;

procedure TfmMain.miLoaderClick(Sender: TObject);
begin
  Manager.Driver.SetMode(amLoader, dmData);
end;

procedure TfmMain.miWorkClick(Sender: TObject);
begin
  Manager.Driver.SetMode(amProg, dmData);
end;

procedure TfmMain.miCaptionClick(Sender: TObject);
begin
  miCaption.Checked := not miCaption.Checked;
  SetCaptionMode(miCaption.Checked);
end;

procedure TfmMain.actEditFindExecute(Sender: TObject);
begin
  ShowFindDlg(Layout);
end;

procedure TfmMain.ViewsExecute(Sender: TObject);
begin
  ViewMode := TViewMode((Sender as TComponent).Tag);
  actViewLayout.Checked := ViewMode = vmLayout;
  actViewPicture.Checked := ViewMode = vmPicture;
  actViewSimple.Checked := ViewMode = vmSimple;
  if ViewMode = vmPicture then
    actPrintPreview.Enabled := True
  else
    actPrintPreview.Enabled := False;
end;

procedure TfmMain.actPrintExecute(Sender: TObject);
begin
  if PrintDialog.Execute then
    ActiveDoc.Print;
end;

procedure TfmMain.PrintPreviewExecute(Sender: TObject);
var
  fmPreview: TfmPreview;
begin
  fmPreview := TfmPreview.CreateForm(Self, Layout);
  fmPreview.OnClose := PreviewClose;
  fmPreview.Left := Left;
  fmPreview.Top := Top;
  fmPreview.Width := Width;                         
  fmPreview.Height := Height;
  fmPreview.Visible := True;
  fmPreview.WindowState := WindowState;

  Visible := False;
end;

procedure TfmMain.PreviewClose(Sender: TObject; var Action: TCloseAction);
var
  fmPreview: TfmPreview;
begin
  fmPreview := Sender as TfmPreview;
  Left := fmPreview.Left;
  Top := fmPreview.Top;
  Width := fmPreview.Width;
  Height := fmPreview.Height;
  Visible := True;
  WindowState := fmPreview.WindowState;
  Action := caFree;
end;

procedure TfmMain.miUpdateClick(Sender: TObject);
begin
  fmUpdates.CheckForUpdates(SoftUpdatePath, False);
end;

procedure TfmMain.SendRequest(var Msg: TMessage);
begin
  fmUpdates.CheckForUpdates(SoftUpdatePath, True); { !!! }
end;

procedure TfmMain.miMessagesClick(Sender: TObject);
begin
  fmMessageWindow.ShowWindow(self);
end;

procedure TfmMain.cbDevicesChange(Sender: TObject);
begin
  Manager.DeviceID := Integer(cbDevices.Items.Objects[cbDevices.ItemIndex]);
end;

procedure TfmMain.btnRefreshClick(Sender: TObject);
begin
  btnRefresh.Enabled := False;
  try
    UpdateDevices;
  finally
    btnRefresh.Enabled := True;
  end;
end;

procedure TfmMain.actEditReplaceExecute(Sender: TObject);
begin
  ShowReplaceDlg(Layout);
end;

function TfmMain.GetHelpFileName: string;
begin
  Result := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0))) + 'Doc\KBEditor.chm';
end;

procedure TfmMain.miDocClick(Sender: TObject);
begin
  FHelpProcess.Execute(Handle, 'open', GetHelpFileName);
end;

procedure TfmMain.actEditIButtonsExecute(Sender: TObject);
begin
  ShowIButtonDlg(Layout.Layer.IButton);
end;

procedure TfmMain.actDeviceReadProgramExecute(Sender: TObject);
begin
  SaveDialog.InitialDir := Manager.InitialDir;
  SaveDialog.FileName := Manager.InitialFileName;
  SaveDialog.Filter := SavePrgFilter;
  SaveDialog.DefaultExt := 'bin';
  if SaveDialog.Execute then
  begin
    StartOperation(TReadFirmwareFileOperation.Create(SaveDialog.FileName),
      OperationCompleted);
  end;
end;

procedure TfmMain.actFillTestLayoutExecute(Sender: TObject);
begin
  Manager.CreateTestLayout(Layout);
  ViewMode := vmSimple;
end;

procedure TfmMain.CreateDoc(Layout: TKBLayout);
var
  Doc: TfmDoc;
begin
  Doc := CreateDocument;
  Doc.Layout := Layout;
  ShowDocument(Doc);
  UpdatePage;
end;

procedure TfmMain.actMessageWindowExecute(Sender: TObject);
begin
  if fmMessageWindow.Visible then
  begin
    fmMessageWindow.HideWindow(self);
    actMessageWindow.Checked := False;
  end else
  begin
    fmMessageWindow.ShowWindow(self);
    actMessageWindow.Checked := True;
  end;
end;

procedure TfmMain.StorageRestorePlacement(Sender: TObject);
begin
  UpdatePage;
end;

procedure TfmMain.actToolbarLayoutExecute(Sender: TObject);
begin
  tbLayout.Visible := not tbLayout.Visible;
  actToolbarLayout.Checked := tbLayout.Visible;
end;

procedure TfmMain.actToolbarStandardExecute(Sender: TObject);
begin
  tbStandard.Visible := not tbStandard.Visible;
  actToolbarStandard.Checked := tbStandard.Visible;
end;

procedure TfmMain.actToolbarDeviceExecute(Sender: TObject);
begin
  tbDevice.Visible := not tbDevice.Visible;
  actToolbarDevice.Checked := tbDevice.Visible;
end;

procedure TfmMain.actToolbarViewModeExecute(Sender: TObject);
begin
  tbViewMode.Visible := not tbViewMode.Visible;
  actToolbarViewMode.Checked := tbViewMode.Visible;
end;

procedure TfmMain.tbStandardClose(Sender: TObject);
begin
  actToolbarStandard.Checked := tbStandard.Visible;
end;

procedure TfmMain.tbViewModeClose(Sender: TObject);
begin
  actToolbarViewMode.Checked := tbViewMode.Visible;
end;

procedure TfmMain.tbLayoutClose(Sender: TObject);
begin
  actToolbarLayout.Checked := tbLayout.Visible;
end;

procedure TfmMain.tbDeviceClose(Sender: TObject);
begin
  actToolbarDevice.Checked := tbDevice.Visible;
end;

procedure TfmMain.ShowDockPanel(APanel: TPanel; MakeVisible: Boolean;
  Client: TControl);
begin
  inherited;
  actMessageWindow.Checked := False;
end;

procedure TfmMain.actScrollWheelExecute(Sender: TObject);
begin
  ShowScrollWheelDlg(Layout.Layer.ScrollWheel);
end;

procedure TfmMain.TimerTimer(Sender: TObject);
begin
  if Progress.ElapsedTickCount > ProgressTimeout then
  begin
    fmProgress.Show;
    Timer.Enabled := False;
  end;
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  fmProgress.Close;
  CanClose := True;
end;


end.
