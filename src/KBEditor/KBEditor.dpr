program KBEditor;

{%ToDo 'KBEditor.todo'}

uses
  Forms,
  SysUtils,
  Windows,
  AppSettings in '..\Common\AppSettings.pas',
  Grids2 in '..\Common\Grids2.pas',
  GridType in '..\Common\GridType.pas',
  Keyboard in '..\Common\Keyboard.pas',
  KeyboardTypes in '..\Common\KeyboardTypes.pas',
  KeyboardManager in '..\Common\KeyboardManager.pas',
  KeyGrid in '..\Common\KeyGrid.pas',
  KBLayout in '..\Common\KBLayout.pas',
  ModuleLoader in '..\Common\ModuleLoader.pas',
  Utils in '..\Common\Utils.pas',
  InitialCheck in '..\Common\InitialCheck.pas',
  untVInfo in '..\Common\untVInfo.pas',
  ErrorReport in '..\Common\ErrorReport.pas',
  DriverUtils in '..\Common\DriverUtils.pas',
  LayoutFormat in '..\Common\LayoutFormat.pas',
  Preview in '..\Common\Preview.pas',
  EMFLayout in '..\Common\EMFLayout.pas',
  Page in '..\Common\Page.pas',
  DockableForm in '..\Common\DockableForm.pas',
  PS2Keyboard in '..\Common\PS2Keyboard.pas',
  HidKeyboard in '..\Common\HidKeyboard.pas',
  KeyboardDevice in '..\Common\KeyboardDevice.pas',
  Scanf in '..\Common\Scanf.pas',
  HelpFile in '..\Common\HelpFile.pas',
  uProgress in '..\Common\uProgress.pas',
  KBLayoutPrint in '..\Common\KBLayoutPrint.pas',
  fmuTest in 'FMU\fmuTest.pas' {fmTest},
  fmuAbout in 'FMU\fmuAbout.pas' {fmAbout},
  fmuCstKey in 'FMU\fmuCstKey.pas' {fmCstKey},
  fmuDoc in 'FMU\fmuDoc.pas' {fmDoc},
  fmuInfo in 'FMU\fmuInfo.pas' {fmInfo},
  fmuMain in 'FMU\fmuMain.pas' {fmMain},
  fmuMSR in 'FMU\fmuMSR.pas' {fmMSR},
  fmuNotes in 'FMU\fmuNotes.pas' {fmNotes},
  fmuCodes in 'FMU\fmuCodes.pas' {fmCodes},
  fmuStdKey in 'FMU\fmuStdKey.pas' {fmStdKey},
  fmuKeyboard in 'FMU\fmuKeyboard.pas' {fmKeyboard},
  fmuSettings in 'FMU\fmuSettings.pas' {fmSettings},
  fmuProgress in 'FMU\fmuProgress.pas' {fmProgress},
  fmuDevices in 'FMU\fmuDevices.pas' {fmDevices},
  fmuError in 'FMU\fmuError.pas' {fmError},
  fmuFind in 'FMU\fmuFind.pas' {fmFind},
  fmuPreview in 'FMU\fmuPreview.pas' {fmPreview},
  fmuReplace in 'FMU\fmuReplace.pas' {fmReplace},
  fmuLog in 'FMU\fmuLog.pas' {fmLog},
  fmuKey in 'FMU\fmuKey.pas' {fmKeyDlg},
  fmuKeyLock in 'FMU\fmuKeyLock.pas' {fmKeyLock},
  fmuIButton in 'FMU\fmuIButton.pas' {fmIButton},
  fmuScrollWheel in 'FMU\fmuScrollWheel.pas' {fmScrollWheel},
  fmuIButtonKey in 'FMU\fmuIButtonKey.pas' {fmIButtonKey},
  MainDockForm in 'FMU\MainDockForm.pas' {MainDockForm},
  fmuPicture in 'FMU\fmuPicture.pas' {fmPicture},
  KeyboardController in '..\Common\KeyboardController.pas',
  DeviceError in '..\Common\DeviceError.pas',
  LayoutReader in '..\Common\LayoutReader.pas',
  XmlCodeTables in '..\Common\XmlCodeTables.pas',
  XMLLayoutEng in '..\Common\XMLLayoutEng.pas',
  msxml in '..\Common\MSXML.pas',
  xmlKeyboard in '..\Common\xmlKeyboard.pas',
  xmlParser in '..\Common\XmlParser.pas',
  KeyEditor in '..\Common\KeyEditor.pas',
  NotifyThread in '..\Common\NotifyThread.pas',
  fmuMessageWindow in 'FMU\fmuMessageWindow.pas' {fmMessageWindow},
  DebugUtils in '..\Common\DebugUtils.pas',
  SizeableForm in '..\Common\SizeableForm.pas',
  BinLayout13 in '..\Common\BinLayout13.pas',
  BinStream in '..\Common\BinStream.pas',
  HttpGet in '..\Common\HTTPGet.pas',
  VirtualKeys in '..\Common\VirtualKeys.pas',
  ChangeNotifier in '..\Common\ChangeNotifier.pas',
  FileUtils in '..\Common\FileUtils.pas',
  DeviceInfoSet in '..\Common\DeviceInfoSet.pas',
  WorkItem in '..\Common\WorkItem.pas',
  BinLayout30 in '..\Common\BinLayout30.pas',
  BinLayout28 in '..\Common\BinLayout28.pas',
  XMLLayoutRus in '..\Common\XMLLayoutRus.pas',
  XmlLayout in '..\Common\XMLLayout.pas',
  AppTypes in '..\Common\AppTypes.pas',
  OperationThread in '..\Common\OperationThread.pas',
  OperationInterface in '..\Common\OperationInterface.pas',
  LogFile in '..\Common\LogFile.pas',
  ReadLayoutOperation in '..\Common\ReadLayoutOperation.pas',
  ReadFirmwareFileOperation in '..\Common\ReadFirmwareFileOperation.pas',
  WriteLayoutOperation in '..\Common\WriteLayoutOperation.pas',
  ReadMemoryFileOperation in '..\Common\ReadMemoryFileOperation.pas',
  WriteFirmwareFileOperation in '..\Common\WriteFirmwareFileOperation.pas',
  WriteMemoryFileOperation in '..\Common\WriteMemoryFileOperation.pas',
  LogMessage in '..\Common\LogMessage.pas',
  KeyPictureEditor in '..\Common\KeyPictureEditor.pas',
  LayoutMessage in '..\Common\LayoutMessage.pas',
  Semaphore in '..\Common\Semaphore.pas',
  StringUtils in '..\Common\StringUtils.pas',
  AppMessages in '..\Common\AppMessages.pas',
  KeyboardFrame in '..\Common\KeyboardFrame.pas',
  dmuData in 'FMU\dmuData.pas' {dmData: TDataModule},
  ActiveLayout in '..\Common\ActiveLayout.pas',
  KeyboardReport in '..\Common\KeyboardReport.pas',
  MockKeyboardDriver in '..\Common\MockKeyboardDriver.pas',
  KeyboardDriver in '..\Common\KeyboardDriver.pas',
  fmuUpdates in 'FMU\fmuUpdates.pas' {fmUpdates};

{$R *.RES}

begin
  Settings;
  Logger.Debug(SSeparator);
  Logger.Debug(' ÿ“–»’-Ã: KBEditor, File version: ' + GetFileVersionInfoStr);
  Logger.Debug(SSeparator);

  if CheckServiceMode then Exit;
  Application.Initialize;
  Application.Title := 'KBEditor';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfmLog, fmLog);
  Application.CreateForm(TfmKeyDlg, fmKeyDlg);
  Application.CreateForm(TfmKeyLock, fmKeyLock);
  Application.CreateForm(TfmIButton, fmIButton);
  Application.CreateForm(TfmScrollWheel, fmScrollWheel);
  Application.CreateForm(TfmIButtonKey, fmIButtonKey);
  Application.CreateForm(TfmTest, fmTest);
  Application.CreateForm(TfmCstKey, fmCstKey);
  Application.CreateForm(TfmInfo, fmInfo);
  Application.CreateForm(TfmMSR, fmMSR);
  Application.CreateForm(TfmNotes, fmNotes);
  Application.CreateForm(TfmCodes, fmCodes);
  Application.CreateForm(TfmStdKey, fmStdKey);
  Application.CreateForm(TfmSettings, fmSettings);
  Application.CreateForm(TfmDevices, fmDevices);
  Application.CreateForm(TfmFind, fmFind);
  Application.CreateForm(TfmReplace, fmReplace);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.CreateForm(TfmError, fmError);
  Application.CreateForm(TfmKeyboard, fmKeyboard);
  Application.CreateForm(TfmPicture, fmPicture);
  Application.CreateForm(TfmProgress, fmProgress);
  Application.CreateForm(TfmUpdates, fmUpdates);
  Application.Run;

  Logger.Debug('Application.Exit');
  Logger.Debug(SSeparator);
end.


