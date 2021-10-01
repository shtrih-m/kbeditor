[CustomMessages]
#include "en\custom_messages.inc"
#include "ru\custom_messages_ru.inc"
[Setup]
AppName="KBEditor"
AppVerName="KBEditor ${version2}"
DefaultDirName= {pf}{cm:DefaultDirName}
DefaultGroupName= {cm:DefaultGroupName}
UninstallDisplayIcon= {app}\Uninstall.exe
AllowNoIcons=Yes
OutputDir="."
AppVersion=${version2}
AppPublisher= {cm:AppPublisher}
AppPublisherURL=http://www.shtrih-m.ru
AppSupportURL=http://www.shtrih-m.ru
AppUpdatesURL=http://www.shtrih-m.ru
AppComments= {cm:AppComments}
AppContact=(495) 787-6090
AppReadmeFile=History.txt
AppCopyright= {cm:AppCopyright}
;Версия
VersionInfoCompany= {cm:AppPublisher}
VersionInfoDescription="KBEditor"
VersionInfoTextVersion="${version}"
VersionInfoVersion=${version}
WizardImageFile=WizardImageFile.bmp
[Languages]
Name: en; MessagesFile: compiler:Default.isl;
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
[Files]
;en - documentation
Source: "en\History.txt"; DestDir: "{app}\Doc"; Languages: en;
Source: "en\KBEditor.chm"; DestDir: "{app}\Doc"; Languages: en;
;ru - documentation
Source: "ru\History.txt"; DestDir: "{app}\Doc"; Languages: ru;
Source: "ru\KBEditor.chm"; DestDir: "{app}\Doc"; Languages: ru;
; данные
Source: "..\..\Bin\KBEditor.exe"; DestDir: "{app}"; Flags: ignoreversion;
Source: "..\..\Bin\KBEditor.rus"; DestDir: "{app}"; Flags: ignoreversion; Languages: ru;
; driver 32
Source: "..\Driver\Driver32\Inst.inf"; DestDir: "{app}\Driver\Driver32"; 
Source: "..\Driver\Driver32\dpinst.exe"; DestDir: "{app}\Driver\Driver32"; 
Source: "..\Driver\Driver32\smkbddrv.cat"; DestDir: "{app}\Driver\Driver32"; MinVersion: 6.0;
Source: "..\Driver\Driver32\smkbddrv.sys"; DestDir: "{app}\Driver\Driver32"; MinVersion: 6.0;
Source: "..\DriverU\Driver32\smkbddrv.sys"; DestDir: "{app}\Driver\Driver32"; OnlyBelowVersion: 6.0;
; driver 64
Source: "..\Driver\Driver64\Inst.inf"; DestDir: "{app}\Driver\Driver64"; 
Source: "..\Driver\Driver64\dpinst.exe"; DestDir: "{app}\Driver\Driver64"; 
Source: "..\Driver\Driver64\smkbddrv.cat"; DestDir: "{app}\Driver\Driver64"; MinVersion: 6.0;
Source: "..\DriverU\Driver64\smkbddrv.sys"; DestDir: "{app}\Driver\Driver64"; OnlyBelowVersion: 6.0;

Source: "en\Data\*"; DestDir: "{app}\Data\"; Excludes: ".svn"; Flags: recursesubdirs; Languages: en;
Source: "ru\Data\*"; DestDir: "{app}\Data\"; Excludes: ".svn"; Flags: recursesubdirs; Languages: ru;
[Icons]
; ru
Name: "{group}\KBEditor"; Filename: "{app}\KBEditor.exe"; WorkingDir: "{app}"; Languages: ru;
Name: "{group}\История версий"; Filename: "{app}\Doc\History.txt"; WorkingDir: "{app}"; Languages: ru;
Name: "{group}\Удалить"; Filename: "{uninstallexe}"; Languages: ru;
; en
Name: "{group}\KBEditor"; Filename: "{app}\KBEditor.exe"; WorkingDir: "{app}"; Languages: en;
Name: "{group}\Version history"; Filename: "{app}\Doc\History.txt"; WorkingDir: "{app}"; Languages: en;
Name: "{group}\Uninstall"; Filename: "{uninstallexe}"; Languages: en;
[UninstallRun]
; Driver uninstall
Filename: "{app}\KBEditor.exe"; Parameters: "/uninstall"; StatusMsg: "Удаление драйвера для доступа к клавиатуре..."; MinVersion: 0,4.0; Flags: hidewizard; Languages: ru;
Filename: "{app}\KBEditor.exe"; Parameters: "/uninstall"; StatusMsg: "Deleteing keyboard driver..."; MinVersion: 0,4.0; Flags: hidewizard; Languages: en;
[Run]
; start application
Filename: "{app}\KBEditor.exe"; Description: "Открыть приложение"; Flags: postinstall nowait skipifsilent skipifdoesntexist; Languages: ru;
Filename: "{app}\KBEditor.exe"; Description: "Start application"; Flags: postinstall nowait skipifsilent skipifdoesntexist; Languages: en;



