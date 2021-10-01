{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1997, 2001 Borland Software Corporation                       }
{                                                                             }
{  �����������: 2001-04 Polaris Software                                      }
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
  SLoginError = '�� ���� �������������� � ���� ������ ''%s''';
  SMonitorActive = '�� ���� �������� ���������� � Active Monitor';
  SMissingConnection = '����������� �������� SQLConnection';
  SDatabaseOpen = '�� ���� ��������� ��� �������� ��� �������� ����������';
  SDatabaseClosed = '�� ���� ��������� ��� �������� ��� �������� ����������';
  SMissingSQLConnection = '�������� SQLConnection ��������� ��� ���� ��������';
  SConnectionNameMissing = '����������� ��� ����������';
  SEmptySQLStatement = '��� ��������� SQL ������';
  SNoParameterValue = '��� �������� ��� ��������� ''%s''';
  SNoParameterType = '��� ���� ��� ��������� ''%s''';
  SParameterTypes = ';Input;Output;Input/Output;Result';
  SDataTypes = ';String;SmallInt;Integer;Word;Boolean;Float;Currency;BCD;Date;Time;DateTime;;;;Blob;Memo;Graphic;;;;;Cursor;';
  SResultName = 'Result';
  SNoTableName = '����������� �������� TableName';
  SNoSqlStatement = '����������� ������, ��� ������� ��� ��� ���������';
  SNoDataSetField = '����������� �������� DataSetField';
  SNoCachedUpdates = '�� � ������ cached update';
  SMissingDataBaseName = '����������� �������� Database';
  SMissingDataSet = '����������� �������� DataSet';
  SMissingDriverName = '����������� �������� DriverName';
  SPrepareError = '�� ���� ��������� ������';
  SObjectNameError = '�������/��������� �� �������';
  SSQLDataSetOpen = '�� ���� ���������� ����� ����� ��� %s';
  SNoActiveTrans = '��� �������� ����������';
  SActiveTrans = '���������� ��� �������';
  SDllLoadError = '�� ���� ��������� %s';
  SDllProcLoadError = '�� ���� ����� ��������� %s';
  SConnectionEditor = '&�������� �������� ����������';
  SCommandTextEditor = '&�������� CommandText';
  SMissingDLLName = '��� DLL/Shared ���������� �� �����������';
  SMissingDriverRegFile = '���� ����������� ��������/���������� ''%s'' �� ������';
  STableNameNotFound = '�� ���� ����� TableName � CommandText';
  SNoCursor = '������ �� ��������� �� �������';
  SMetaDataOpenError = '�� ���� ������� Metadata';
  SErrorMappingError = '������ SQL: Error mapping failed';
  SStoredProcsNotSupported = '�������� ��������� �� �������������� ''%s'' ��������';
  SPackagesNotSupported = '������ �� �������������� ''%s'' ��������';
{$IFNDEF VER140}
  SDBXUNKNOWNERROR = '������ dbExpress: ����������� ��� ������ ''%s''';
  SDBXNOCONNECTION = '������ dbExpress: ���������� �� �������, ��������� �� ������ �� ����� ���� ��������';
  SDBXNOMETAOBJECT = '������ dbExpress: MetadataObject �� ������, ��������� �� ������ �� ����� ���� ��������';
  SDBXNOCOMMAND = '������ dbExpress: ������� �� �������, ��������� �� ������ �� ����� ���� ��������';
  SDBXNOCURSOR = '������ dbExpress: ������ �� ������, ��������� �� ������ �� ����� ���� ��������';
//  #define DBXERR_NONE                    0x0000
  SNOERROR = '';
//  #define DBXERR_WARNING                 0x0001
  SWARNING = '[0x0001]: ��������������';
//#define DBXERR_NOMEMORY                0x0002
  SNOMEMORY = '[0x0002]: �� ������� ������ ��� ��������';
//#define DBXERR_INVALIDFLDTYPE          0x0003
  SINVALIDFLDTYPE = '[0x0003]: �������� ��� ����';
//#define DBXERR_INVALIDHNDL             0x0004
  SINVALIDHNDL = '[0x0004]: �������� ����������';
//#define DBXERR_NOTSUPPORTED            0x0005
  SNOTSUPPORTED = '[0x0005]: �������� �� ��������������';
//#define DBXERR_INVALIDTIME             0x0006
  SINVALIDTIME = '[0x0006]: �������� �����';
//#define DBXERR_INVALIDXLATION          0x0007
  SINVALIDXLATION = '[0x0007]: �������� �������������� ������';
//#define DBXERR_OUTOFRANGE              0x0008
  SOUTOFRANGE = '[0x0008]: ��������/������� ����� �� �������';
//#define DBXERR_INVALIDPARAM            0x0009
  SINVALIDPARAM = '[0x0009]: �������� ��������';
//#define DBXERR_EOF                     0x000A
  SEOF = '[0x000A]: ��������� ��������� � EOF';
//#define DBXERR_SQLPARAMNOTSET          0x000B
  SSQLPARAMNOTSET = '������ dbExpress [0x000B]: �������� �� ����������';
//#define DBXERR_INVALIDUSRPASS          0x000C
  SINVALIDUSRPASS = '[0x000C] �������� ���/������';
//#define DBXERR_INVALIDPRECISION        0x000D
  SINVALIDPRECISION = '[0x000D]: �������� ��������';
//#define DBXERR_INVALIDLEN              0x000E
  SINVALIDLEN = '[0x000E]: �������� �����';
//#define DBXERR_INVALIDTXNISOLEVEL      0x000F
  SINVALIDXISOLEVEL = '[0x000F]: �������� ������� �������� ����������';
//#define DBXERR_INVALIDTXNID            0x0010
  SINVALIDTXNID = '[0x0010]: �������� ID ����������';
//#define DBXERR_DUPLICATETXNID          0x0011
  SDUPLICATETXNID = '[0x0011]: �������� ID ����������';
//#define DBXERR_DRIVERRESTRICTED        0x0012
  SDRIVERRESTRICTED = '[0x0012]: ���������� �� ������������� ��� ������������� ���� �����������';
//#define DBXERR_LOCALTRANSACTIVE        0x0013
  SLOCALTRANSACTIVE = '[0x0013]: ��������� ���������� ��� �������';
//#define DBXERR_MULTIPLETRANSNOTENABLED 0x0014
  SMULTIPLETRANSNOTENABLED = '[0x0014]: ��������� ���������� �� �������';
//#define DBXERR_CONNECTIONFAILED        0x0015
  SCONNECTIONFAILED = '[0x0015]: �� ������� ��������� ����������';
//#define DBXERR_DRIVERINITFAILED        0x0016
  SDRIVERINITFAILED ='[0x0016]: �� ������� ���������������� �������';
//#define DBXERR_OPTLOCKFAILED           0x0017
  SOPTLOCKFAILED = '[0x0017]: �� ������� ��������� ��������������� ������������';
//#define DBXERR_INVALIDREF              0x0018
  SINVALIDREF = '[0x0018]: �������� REF';
//#define DBXERR_NOTABLE                 0x0019
  SNOTABLE = '[0x0019]: ������� �� �������';
//#define DBXERR_NODATA                  0x0064
  SNODATA = '[0x0064]: ��� ������ ������';
//#define DBXERR_SQLERROR                0x0065
  SSQLERROR = '[0x0065]: ������ SQL';

  SDBXError = '������ dbExpress: %s';
  SSQLServerError = '������ SQL �������: %s';

{$ELSE}
  SDBXUNKNOWNERROR = '������ DBX: �� ������� ��������� ��� ���� ������';
  SDBXNOCONNECTION = '������ DBX: ���������� �� �������, ��������� �� ������ �� ����� ���� ��������';
  SDBXNOMETAOBJECT = '������ DBX: MetadataObject �� ������, ��������� �� ������ �� ����� ���� ��������';
  SDBXNOCOMMAND = '������ DBX: ������� �� �������, ��������� �� ������ �� ����� ���� ��������';
  SDBXNOCURSOR = '������ DBX: ������ �� ������, ��������� �� ������ �� ����� ���� ��������';
  SNOMEMORY = '������ DBX: �� ������� ������ ��� ��������';
  SINVALIDFLDTYPE = '������ DBX: �������� ��� ����';
  SINVALIDHNDL = '������ DBX: �������� ����������';
  SINVALIDTIME = '������ DBX: �������� �����';
  SNOTSUPPORTED = '������ DBX: �������� �� ��������������';
  SINVALIDXLATION = '������ DBX: �������� ����������';
  SINVALIDPARAM = '������ DBX: �������� ��������';
  SOUTOFRANGE = '������ DBX: �������� ����� �� �������';
  SSQLPARAMNOTSET = '������ DBX: �������� �� ����������';
  SEOF = '������ DBX: ��������� ��������� � EOF';
  SINVALIDUSRPASS = '������ DBX: �������� ���/������';
  SINVALIDPRECISION = '������ DBX: �������� ��������';
  SINVALIDLEN = '������ DBX: �������� �����';
  SINVALIDXISOLEVEL = '������ DBX: �������� ������� �������� ����������';
  SINVALIDTXNID = '������ DBX: �������� ID ����������';
  SDUPLICATETXNID = '������ DBX: �������� ID ����������';
  SDRIVERRESTRICTED = 'dbExpress: ���������� �� ������������� ��� ������������� ���� �����������';
  SLOCALTRANSACTIVE = '������ DBX: ��������� ���������� ��� �������';
{$ENDIF}
// ������� � D8
  SMultiConnNotSupported = '�������������� ���������� �� �������������� ��������� %s';

  SConfFileMoveError = '�� ���� ����������� %s � %s';
  SMissingConfFile = '���� ������������ %s �� ������';
  SObjectViewNotTrue = 'ObjectView ������ ���� True ��� ������ � Object ������';
  SDriverNotInConfigFile = '������� (%s) �� ������ � ������. ����� (%s)';
  SObjectTypenameRequired = '��� ���� ������� ��������� ��� �������� ���������';
  SCannotCreateFile = '�� ���� ������� ���� %s';
{$IFDEF LINUX}
  SCannotCreateParams = '��������������: ���������� �������, ��������� �� �������������';
{$ENDIF}
// used in SqlReg.pas
{$IFNDEF VER140}
  SDlgOpenCaption = '������� ���� ��������� �����������';
{$ENDIF}
{$IFDEF MSWINDOWS}
  SDlgFilterTxt = '��������� ����� (*.txt)|*.txt|��� ����� (*.*)|*.*';
{$ENDIF}
{$IFDEF LINUX}
  SDlgFilterTxt = '��������� ����� (*.txt)|��� ����� (*)';
{$ENDIF}
  SLogFileFilter = '����� ��������� (*.log)';
{$IFNDEF VER140}
  SCircularProvider = '����������� ������ ����������� �� �����������.';
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
