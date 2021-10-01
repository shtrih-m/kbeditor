[Setup]
AppName="KBTest"
AppVerName="KBTest_${version2}"
DefaultDirName= {pf}\Штрих-М\KBTest_${version2}
DefaultGroupName=Штрих-М\KBTest_${version2}
UninstallDisplayIcon= {app}\Uninstall.exe
AllowNoIcons=Yes
OutputDir="."
AppVersion=${version2}
AppPublisher=ШТРИХ-М
AppPublisherURL=http://www.shtrih-m.ru
AppSupportURL=http://www.shtrih-m.ru
AppUpdatesURL=http://www.shtrih-m.ru
AppComments=Торговое оборудование от производителя, автоматизация торговли
AppContact=т. (495) 787-6090
AppReadmeFile=History.txt
AppCopyright="Copyright © 2008 ШТРИХ-М  ©®™"
;Версия
VersionInfoCompany="ШТРИХ-М"
VersionInfoDescription="Тест клавиатуры"
VersionInfoTextVersion="${version}"
VersionInfoVersion=${version}
WizardImageFile=KBTest.bmp
[Languages]
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
[Files]
; История версий
Source: "History.txt"; DestDir: "{app}";
;KBTest
Source: "..\..\Bin\KBTest.exe"; DestDir: "{app}"; Flags: ignoreversion;
Source: "..\..\Bin\KBTest.rus"; DestDir: "{app}"; Flags: ignoreversion; Languages: ru;
; раскладки
Source: "Data\*"; DestDir: "{app}\Data\"; Excludes: ".svn"; Flags: recursesubdirs
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
[Icons]
Name: "{group}\История версий"; Filename: "{app}\History.txt"; WorkingDir: "{app}";
Name: "{group}\Тест клавиатуры"; Filename: "{app}\KBTest.exe"; WorkingDir: "{app}";
Name: "{group}\Удалить"; Filename: "{uninstallexe}"
[UninstallDelete]
Type: files; Name: "{app}\KBTest.xml";
[UninstallRun]
; удаление драйвера для NT/2000
Filename: "{app}\KBTest.exe"; Parameters: "/uninstall"; StatusMsg: "Удаление драйвера клавиатуры PS/2..."; MinVersion: 0,4.0;
[Run]
; открыть приложение
Filename: "{app}\KBTest.exe"; Description: "Открыть приложение"; Flags: postinstall nowait skipifsilent skipifdoesntexist;
[UninstallDelete]
Type: files; Name: "{app}\*.ini"







