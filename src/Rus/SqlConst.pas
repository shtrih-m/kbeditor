{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1997, 2001 Borland Software Corporation                       }
{                                                                             }
{  Русификация: 2001-04 Polaris Software                                      }
{               http://polesoft.da.ru                                         }
{ *************************************************************************** }


unit SqlConst;

interface

const
  DRIVERS_KEY = 'Installed Drivers';            { Do not localize }
  CONNECTIONS_KEY = 'Installed Connections';    { Do not localize }
  DRIVERNAME_KEY = 'DriverName';                { Do not localize }
  HOSTNAME_KEY = 'HostName';                    { Do not localize }
  ROLENAME_KEY = 'RoleName';                    { Do not localize }
  DATABASENAME_KEY = 'Database';                { Do not localize }
  MAXBLOBSIZE_KEY = 'BlobSize';                 { Do not localize }          
  VENDORLIB_KEY = 'VendorLib';                  { Do not localize }
  DLLLIB_KEY = 'LibraryName';                   { Do not localize }
  GETDRIVERFUNC_KEY = 'GetDriverFunc';          { Do not localize }
  AUTOCOMMIT_KEY = 'AutoCommit';                { Do not localize }
  BLOCKINGMODE_KEY = 'BlockingMode';            { Do not localize }
  WAITONLOCKS_KEY= 'WaitOnLocks';               { Do not localize }
  COMMITRETAIN_KEY = 'CommitRetain';            { Do not localize }
  TRANSISOLATION_KEY = '%s TransIsolation';     { Do not localize }
  SQLDIALECT_KEY = 'SqlDialect';                { Do not localize }
  SQLLOCALE_CODE_KEY = 'LocaleCode';            { Do not localize }
  ERROR_RESOURCE_KEY = 'ErrorResourceFile';     { Do not localize }
  SQLSERVER_CHARSET_KEY = 'ServerCharSet';      { Do not localize }
  SREADCOMMITTED = 'readcommited';              { Do not localize }
  SREPEATREAD = 'repeatableread';               { Do not localize }
  SDIRTYREAD = 'dirtyread';                     { Do not localize }
  SDRIVERREG_SETTING = 'Driver Registry File';           { Do not localize }
  SCONNECTIONREG_SETTING = 'Connection Registry File';   { Do not localize }
  szUSERNAME         = 'USER_NAME';             { Do not localize }
  szPASSWORD         = 'PASSWORD';              { Do not localize }
  SLocaleCode        = 'LCID';                  { Do not localize }
  ROWSETSIZE_KEY     = 'RowsetSize';            { Do not localize }
{$IFNDEF VER140}
  OSAUTHENTICATION   = 'OS Authentication';     { Do not localize }
  SERVERPORT         = 'Server Port';           { Do not localize }
  MULTITRANSENABLED  = 'Multiple Transaction';  { Do not localize }
  TRIMCHAR           = 'Trim Char';             { Do not localize }
  CUSTOM_INFO        = 'Custom String';         { Do not localize }
  CONN_TIMEOUT       = 'Connection Timeout';    { Do not localize }
{$ELSE}
  OSAUTHENTICATION   = 'Os Authentication';     { Do not localize }
{$ENDIF}
{$IFDEF MSWINDOWS}
  SDriverConfigFile = 'dbxdrivers.ini';            { Do not localize }
  SConnectionConfigFile = 'dbxconnections.ini';    { Do not localize }
  SDBEXPRESSREG_SETTING = '\Software\Borland\DBExpress'; { Do not localize }
{$ENDIF}
{$IFDEF LINUX}
  SDBEXPRESSREG_USERPATH = '/.borland/';          { Do not localize }
  SDBEXPRESSREG_GLOBALPATH = '/usr/local/etc/';   { Do not localize }
  SDriverConfigFile = 'dbxdrivers';                  { Do not localize }
  SConnectionConfigFile = 'dbxconnections';          { Do not localize }
  SConfExtension = '.conf';                       { Do not localize }
{$ENDIF}

resourcestring
  SLoginError = 'Не могу присоединиться к базе данных ''%s''';
  SMonitorActive = 'Не могу изменить соединение в Active Monitor';
  SMissingConnection = 'Отсутствует свойство SQLConnection';
  SDatabaseOpen = 'Не могу выполнить эту операцию при открытом соединении';
  SDatabaseClosed = 'Не могу выполнить эту операцию при закрытом соединении';
  SMissingSQLConnection = 'Свойство SQLConnection требуется для этой операции';
  SConnectionNameMissing = 'Отсутствует имя соединения';
  SEmptySQLStatement = 'Нет доступных SQL команд';
  SNoParameterValue = 'Нет значения для параметра ''%s''';
  SNoParameterType = 'Нет типа для параметра ''%s''';
  SParameterTypes = ';Input;Output;Input/Output;Result';
  SDataTypes = ';String;SmallInt;Integer;Word;Boolean;Float;Currency;BCD;Date;Time;DateTime;;;;Blob;Memo;Graphic;;;;;Cursor;';
  SResultName = 'Result';
  SNoTableName = 'Отсутствует свойство TableName';
  SNoSqlStatement = 'Отсутствует запрос, имя таблицы или имя процедуры';
  SNoDataSetField = 'Отсутствует свойство DataSetField';
  SNoCachedUpdates = 'Не в режиме cached update';
  SMissingDataBaseName = 'Отсутствует свойство Database';
  SMissingDataSet = 'Отсутствует свойство DataSet';
  SMissingDriverName = 'Отсутствует свойство DriverName';
  SPrepareError = 'Не могу выполнить Запрос';
  SObjectNameError = 'Таблица/процедура не найдена';
  SSQLDataSetOpen = 'Не могу определить имена полей для %s';
  SNoActiveTrans = 'Нет активной транзакции';
  SActiveTrans = 'Транзакция уже активна';
  SDllLoadError = 'Не могу загрузить %s';
  SDllProcLoadError = 'Не могу найти процедуру %s';
  SConnectionEditor = '&Изменить свойства соединения';
  SCommandTextEditor = '&Изменить CommandText';
  SMissingDLLName = 'Имя DLL/Shared библиотеки не установлено';
  SMissingDriverRegFile = 'Файл регистрации драйвера/соединения ''%s'' не найден';
  STableNameNotFound = 'Не могу найти TableName в CommandText';
  SNoCursor = 'Курсор не возвращен из Запроса';
  SMetaDataOpenError = 'Не могу открыть Metadata';
  SErrorMappingError = 'Ошибка SQL: Error mapping failed';
  SStoredProcsNotSupported = 'Хранимые процедуры не поддерживаются ''%s'' сервером';
  SPackagesNotSupported = 'Пакеты не поддерживаются ''%s'' сервером';
{$IFNDEF VER140}
  SDBXUNKNOWNERROR = 'Ошибка dbExpress: Неизвестный код ошибки ''%s''';
  SDBXNOCONNECTION = 'Ошибка dbExpress: Соединение не найдено, сообщение об ошибке не может быть получено';
  SDBXNOMETAOBJECT = 'Ошибка dbExpress: MetadataObject не найден, сообщение об ошибке не может быть получено';
  SDBXNOCOMMAND = 'Ошибка dbExpress: Команда не найдена, сообщение об ошибке не может быть получено';
  SDBXNOCURSOR = 'Ошибка dbExpress: Курсор не найден, сообщение об ошибке не может быть получено';
//  #define DBXERR_NONE                    0x0000
  SNOERROR = '';
//  #define DBXERR_WARNING                 0x0001
  SWARNING = '[0x0001]: Предупреждение';
//#define DBXERR_NOMEMORY                0x0002
  SNOMEMORY = '[0x0002]: Не хватает памяти для операции';
//#define DBXERR_INVALIDFLDTYPE          0x0003
  SINVALIDFLDTYPE = '[0x0003]: Неверный тип поля';
//#define DBXERR_INVALIDHNDL             0x0004
  SINVALIDHNDL = '[0x0004]: Неверный дескриптор';
//#define DBXERR_NOTSUPPORTED            0x0005
  SNOTSUPPORTED = '[0x0005]: Операция не поддерживается';
//#define DBXERR_INVALIDTIME             0x0006
  SINVALIDTIME = '[0x0006]: Неверное время';
//#define DBXERR_INVALIDXLATION          0x0007
  SINVALIDXLATION = '[0x0007]: Неверное преобразование данных';
//#define DBXERR_OUTOFRANGE              0x0008
  SOUTOFRANGE = '[0x0008]: Параметр/колонка вышла за границы';
//#define DBXERR_INVALIDPARAM            0x0009
  SINVALIDPARAM = '[0x0009]: Неверный параметр';
//#define DBXERR_EOF                     0x000A
  SEOF = '[0x000A]: Результат находится в EOF';
//#define DBXERR_SQLPARAMNOTSET          0x000B
  SSQLPARAMNOTSET = 'Ошибка dbExpress [0x000B]: Параметр не установлен';
//#define DBXERR_INVALIDUSRPASS          0x000C
  SINVALIDUSRPASS = '[0x000C] Неверное имя/пароль';
//#define DBXERR_INVALIDPRECISION        0x000D
  SINVALIDPRECISION = '[0x000D]: Неверная точность';
//#define DBXERR_INVALIDLEN              0x000E
  SINVALIDLEN = '[0x000E]: Неверная длина';
//#define DBXERR_INVALIDTXNISOLEVEL      0x000F
  SINVALIDXISOLEVEL = '[0x000F]: Неверный Уровень Изоляции Транзакций';
//#define DBXERR_INVALIDTXNID            0x0010
  SINVALIDTXNID = '[0x0010]: Неверный ID транзакции';
//#define DBXERR_DUPLICATETXNID          0x0011
  SDUPLICATETXNID = '[0x0011]: Дубликат ID транзакции';
//#define DBXERR_DRIVERRESTRICTED        0x0012
  SDRIVERRESTRICTED = '[0x0012]: Приложение не лицензировано для использования этой возможности';
//#define DBXERR_LOCALTRANSACTIVE        0x0013
  SLOCALTRANSACTIVE = '[0x0013]: Локальная транзакция уже активна';
//#define DBXERR_MULTIPLETRANSNOTENABLED 0x0014
  SMULTIPLETRANSNOTENABLED = '[0x0014]: Несколько транзакций не доступн';
//#define DBXERR_CONNECTIONFAILED        0x0015
  SCONNECTIONFAILED = '[0x0015]: Не удалось выполнить соединение';
//#define DBXERR_DRIVERINITFAILED        0x0016
  SDRIVERINITFAILED ='[0x0016]: Не удалось инициализировать драйвер';
//#define DBXERR_OPTLOCKFAILED           0x0017
  SOPTLOCKFAILED = '[0x0017]: Не удалось выполнить оптимистическое блокирование';
//#define DBXERR_INVALIDREF              0x0018
  SINVALIDREF = '[0x0018]: Неверный REF';
//#define DBXERR_NOTABLE                 0x0019
  SNOTABLE = '[0x0019]: Таблица не найдена';
//#define DBXERR_NODATA                  0x0064
  SNODATA = '[0x0064]: Нет больше данных';
//#define DBXERR_SQLERROR                0x0065
  SSQLERROR = '[0x0065]: Ошибка SQL';

  SDBXError = 'Ошибка dbExpress: %s';
  SSQLServerError = 'Ошибка SQL сервера: %s';

{$ELSE}
  SDBXUNKNOWNERROR = 'Ошибка DBX: Не найдено сообщение для кода ошибки';
  SDBXNOCONNECTION = 'Ошибка DBX: Соединение не найдено, сообщение об ошибке не может быть получено';
  SDBXNOMETAOBJECT = 'Ошибка DBX: MetadataObject не найден, сообщение об ошибке не может быть получено';
  SDBXNOCOMMAND = 'Ошибка DBX: Команда не найдена, сообщение об ошибке не может быть получено';
  SDBXNOCURSOR = 'Ошибка DBX: Курсор не найден, сообщение об ошибке не может быть получено';
  SNOMEMORY = 'Ошибка DBX: Не хватает памяти для операции';
  SINVALIDFLDTYPE = 'Ошибка DBX: Неверный тип поля';
  SINVALIDHNDL = 'Ошибка DBX: Неверный дескриптор';
  SINVALIDTIME = 'Ошибка DBX: Неверное время';
  SNOTSUPPORTED = 'Ошибка DBX: Операция не поддерживается';
  SINVALIDXLATION = 'Ошибка DBX: Неверная трансляция';
  SINVALIDPARAM = 'Ошибка DBX: Неверный параметр';
  SOUTOFRANGE = 'Ошибка DBX: Аргумент вышел за границы';
  SSQLPARAMNOTSET = 'Ошибка DBX: Параметр не установлен';
  SEOF = 'Ошибка DBX: Результат находится в EOF';
  SINVALIDUSRPASS = 'Ошибка DBX: Неверное имя/пароль';
  SINVALIDPRECISION = 'Ошибка DBX: Неверная точность';
  SINVALIDLEN = 'Ошибка DBX: Неверная длина';
  SINVALIDXISOLEVEL = 'Ошибка DBX: Неверный Уровень Изоляции Транзакций';
  SINVALIDTXNID = 'Ошибка DBX: Неверный ID транзакции';
  SDUPLICATETXNID = 'Ошибка DBX: Дубликат ID транзакции';
  SDRIVERRESTRICTED = 'dbExpress: Приложение не лицензировано для использования этой возможности';
  SLOCALTRANSACTIVE = 'Ошибка DBX: Локальная транзакция уже активна';
{$ENDIF}
// Удалено в D8
  SMultiConnNotSupported = 'Многочисленные соединения не поддерживаются драйвером %s';

  SConfFileMoveError = 'Не могу переместить %s в %s';
  SMissingConfFile = 'Файл конфигурации %s не найден';
  SObjectViewNotTrue = 'ObjectView должен быть True для таблиц с Object полями';
  SDriverNotInConfigFile = 'Драйвер (%s) не найден в конфиг. файле (%s)';
  SObjectTypenameRequired = 'Имя типа объекта требуется как значение параметра';
  SCannotCreateFile = 'Не могу создать файл %s';
{$IFDEF LINUX}
  SCannotCreateParams = 'Предупреждение: Соединение закрыто, параметры не восстановлены';
{$ENDIF}
// used in SqlReg.pas
{$IFNDEF VER140}
  SDlgOpenCaption = 'Открыть файл протокола трассировки';
{$ENDIF}
{$IFDEF MSWINDOWS}
  SDlgFilterTxt = 'Текстовые файлы (*.txt)|*.txt|Все файлы (*.*)|*.*';
{$ENDIF}
{$IFDEF LINUX}
  SDlgFilterTxt = 'Текстовые файлы (*.txt)|Все файлы (*)';
{$ENDIF}
  SLogFileFilter = 'Файлы протокола (*.log)';
{$IFNDEF VER140}
  SCircularProvider = 'Циклические ссылки провайдеров не допускаются.';
{$ENDIF}

const

{$IFNDEF VER140}
  DbxError : array[0..19] of String = ( '', SNOMEMORY, SINVALIDFLDTYPE,
{$ELSE}
  DbxError : array[0..18] of String = ( '', SNOMEMORY, SINVALIDFLDTYPE,
{$ENDIF}
                SINVALIDHNDL, SINVALIDTIME,
                SNOTSUPPORTED, SINVALIDXLATION, SINVALIDPARAM, SOUTOFRANGE,
                SSQLPARAMNOTSET, SEOF, SINVALIDUSRPASS, SINVALIDPRECISION,
                SINVALIDLEN, SINVALIDXISOLEVEL, SINVALIDTXNID, SDUPLICATETXNID,
{$IFNDEF VER140}
                SDRIVERRESTRICTED, SLOCALTRANSACTIVE, SMULTIPLETRANSNOTENABLED );
{$ELSE}
                SDRIVERRESTRICTED, SLOCALTRANSACTIVE );
{$ENDIF}

implementation

end.
