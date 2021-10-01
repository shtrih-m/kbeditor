{ *************************************

        DIFx API
        Driver Installation Framework
        for Applications
        Copyright (c) Microsoft Corporation

        Header File Translation from difxapi.h

        08/2007 - Mario Werner (mario@108bits.de)

************************************* }

unit difxapi;

interface

uses
  Windows;

{ $DEFINE UNICODE}

const
        SETUP_API_DLL_NAME              = 'difxapi.dll';
        _DIFXAPI_VERSION_               = $0200;
        APPLICATION_ERROR_MASK          = $20000000;
        ERROR_SEVERITY_ERROR            = $C0000000;

//
// DIFX specific ERROR CODES
// We have bit 29 set, which is reserved for application-defined error codes and
// does not conflict with system error codes.
//

        ERROR_DEPENDENT_APPLICATIONS_EXIST      = APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $300;
        ERROR_NO_DEVICE_ID                      = APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $301;

//
//  The driver package is not currently in the driver store
//

        ERROR_DRIVER_PACKAGE_NOT_IN_STORE       = APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $302;
        ERROR_MISSING_FILE                      = APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $303;

//
// Catalog referenced in the INF is invalid or could not be found
//
        ERROR_INVALID_CATALOG_DATA		= APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $304;

//
// Other error codes
//
        ERROR_NO_SUCH_DEVINST			= $E000020B;
        ERROR_SIGNATURE_OSATTRIBUTE_MISMATCH	= $E0000244;

//
// Define the FLAGS
//

//
// Flag: DRIVER_PACKAGE_REPAIR
//
// Preinstall: if the driver store entry already exists, overwrite it.
// Install: overwrites existing driver store entry and reinstall driver
//
        DRIVER_PACKAGE_REPAIR			= $00000001;

//
// Flag: DRIVER_PACKAGE_SILENT
//
// The system will not pop-up any UI to user, for example, signing UI.
// Instead, in cases where a UI would be required to continue the install,
// the function will fail silently and return an appropriate error code.
//
	DRIVER_PACKAGE_SILENT			= $00000002;

//
// Flag: DRIVER_PACKAGE_FORCE
//
// Install:  Forces an install even if the driver to be installed is not better
//           than the current one.
// Uninstall: Forces an uninstall disregarding the App to driver reference count.
//
	DRIVER_PACKAGE_FORCE			= $00000004;

//
// Flag: DRIVER_PACKAGE_ONLY_IF_DEVICE_PRESENT
//
// Preinstall/Install: only preinstalls/installs the driver package if there is
//                     a device present.
//
	DRIVER_PACKAGE_ONLY_IF_DEVICE_PRESENT	= $00000008;

//
// Flag: DRIVER_PACKAGE_LEGACY_MODE
//
// By default, DFXLIB requires all driver packages to be signed and that all files referenced
// in the INF for copying to be present. Driver Packages who need this flag to install won't install
// on the latest version of Windows.
// Unsigned driver packages are accepted, but might be blocked by the OS itself or the unsigned
// driver dialog might pop-up, depending on the policy settings of the given OS.
//
	DRIVER_PACKAGE_LEGACY_MODE		= $00000010;

//
// Flag: DRIVER_PACKAGE_DELETE_FILES
//
// Uninstall: Makes a BEST EFFORT to delete all files that were copied during install
// as described by the INF file. Before deleting, the file will be binary compared to
// the file in the driver store. Still, this file could still be needed by another
// program on the machine. If you decide to use this flag, make sure you understand
// how your files will be used.
//
	DRIVER_PACKAGE_DELETE_FILES		= $00000020;

type
(*
typedef struct
{
    PWSTR pApplicationId;
    PWSTR pDisplayName;
    PWSTR pProductName;
    PWSTR pMfgName;
} INSTALLERINFO_W, * PINSTALLERINFO_W;
*)
        INSTALLERINFO_W = packed record
                pApplicationId,
                pDisplayName,
                pProductName,
                pMfgName: PWideChar;
        end;

// typedef const PINSTALLERINFO_W PCINSTALLERINFO_W;
        PINSTALLERINFO_W = ^INSTALLERINFO_W;
        PCINSTALLERINFO_W = PINSTALLERINFO_W;

(*
typedef struct
{
    PSTR pApplicationId;
    PSTR pDisplayName;
    PSTR pProductName;
    PSTR pMfgName;
} INSTALLERINFO_A, * PINSTALLERINFO_A;
*)
        INSTALLERINFO_A = packed record
                pApplicationId,
                pDisplayName,
                pProductName,
                pMfgName: PChar;
        end;

// typedef const PINSTALLERINFO_A PCINSTALLERINFO_A;
        PINSTALLERINFO_A = ^INSTALLERINFO_A;
        PCINSTALLERINFO_A = PINSTALLERINFO_A;

(*
#ifdef UNICODE
	typedef INSTALLERINFO_W INSTALLERINFO;
	typedef PINSTALLERINFO_W PINSTALLERINFO;
	typedef PCINSTALLERINFO_W PCINSTALLERINFO;
#else
	typedef INSTALLERINFO_A INSTALLERINFO;
	typedef PINSTALLERINFO_A PINSTALLERINFO;
	typedef PCINSTALLERINFO_A PCINSTALLERINFO;
#endif
*)
{$IFDEF UNICODE}
        INSTALLERINFO = INSTALLERINFO_W;
        PINSTALLERINFO = PINSTALLERINFO_W;
        PCINSTALLERINFO = PCINSTALLERINFO_W;
{$ELSE}
        INSTALLERINFO = INSTALLERINFO_A;
        PINSTALLERINFO = PINSTALLERINFO_A;
        PCINSTALLERINFO = PCINSTALLERINFO_A;
{$ENDIF}

(*
typedef enum
{
	DIFXAPI_SUCCESS,    // Successes
	DIFXAPI_INFO,		// Basic logging information that should always be shown
	DIFXAPI_WARNING,	// Warnings
	DIFXAPI_ERROR		// Errors
} DIFXAPI_LOG;
*)
        DIFXAPI_LOG = (DIFXAPI_SUCCESS, DIFXAPI_INFO, DIFXAPI_WARNING, DIFXAPI_ERROR);

// typedef void ( __cdecl* DIFXAPILOGCALLBACK_W)( DIFXAPI_LOG Event, DWORD Error, PCWSTR EventDescription, PVOID CallbackContext);
        DIFXAPILOGCALLBACK_W = procedure (Event: DIFXAPI_LOG; Error: DWORD; EventDescription: PWideChar; var CallbackContext: Pointer); stdcall;

// typedef void ( __cdecl* DIFXAPILOGCALLBACK_A)( DIFXAPI_LOG Event, DWORD Error, PCSTR EventDescription, PVOID CallbackContext);
        DIFXAPILOGCALLBACK_A = procedure (Event: DIFXAPI_LOG; Error: DWORD; EventDescription: PChar; var CallbackContext: Pointer); stdcall;

(*
WINDIFXAPI
DWORD
WINAPI
DriverPackagePreinstallW(
    	PCWSTR DriverPackageInfPath,
     	DWORD 	Flags
    );
*)
function DriverPackagePreinstallW (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD): DWORD; stdcall; external SETUP_API_DLL_NAME;

(*
WINDIFXAPI
DWORD
WINAPI
DriverPackagePreinstallA(
    	PCSTR DriverPackageInfPath,
     	DWORD 	Flags
    );
*)
function DriverPackagePreinstallA (
        DriverPackageInfPath: PChar;
        Flags: DWORD): DWORD; stdcall; external SETUP_API_DLL_NAME;

(*
#ifdef UNICODE
#define DriverPackagePreinstall DriverPackagePreinstallW
#else
#define DriverPackagePreinstall DriverPackagePreinstallA
#endif
*)
function DriverPackagePreinstall (
        DriverPackageInfPath: PChar;
        Flags: DWORD): DWORD; overload;
function DriverPackagePreinstall (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD): DWORD; overload;

//
// INSTALL Driver Package
//


//
// General info about the installer of the driver package
//

(*
WINDIFXAPI
DWORD
WINAPI
DriverPackageInstallW(
     PCWSTR DriverPackageInfPath,
     DWORD Flags,
     PCINSTALLERINFO_W pInstallerInfo,
     BOOL * pNeedReboot
    );
*)
function DriverPackageInstallW (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_W;
        var pNeedReboot: Boolean): DWORD; stdcall; external SETUP_API_DLL_NAME;

(*        
WINDIFXAPI
DWORD
WINAPI
DriverPackageInstallA(
    	PCSTR 		DriverPackageInfPath,
    	DWORD 		Flags,
     PCINSTALLERINFO_A	pInstallerInfo,
    	BOOL * 		pNeedReboot
    );
*)
function DriverPackageInstallA (
        DriverPackageInfPath: PChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_A;
        var pNeedReboot: Boolean): DWORD; stdcall; external SETUP_API_DLL_NAME;

(*
#ifdef UNICODE
#define DriverPackageInstall DriverPackageInstallW
#else
#define DriverPackageInstall DriverPackageInstallA
#endif
*)
function DriverPackageInstall (
        DriverPackageInfPath: PChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_A;
        var pNeedReboot: Boolean): DWORD; overload;
function DriverPackageInstall (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_W;
        var pNeedReboot: Boolean): DWORD; overload;

//
// Uninstall Driver Package
//

(*
WINDIFXAPI
DWORD
WINAPI
DriverPackageUninstallW(
        PCWSTR DriverPackageInfPath,
        DWORD 	Flags,
      PCINSTALLERINFO_W pInstallerInfo,
       BOOL * pNeedReboot
    );
*)
function DriverPackageUninstallW (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_W;
        var pNeedReboot: Boolean): DWORD; stdcall; external SETUP_API_DLL_NAME;

(*
WINDIFXAPI
DWORD
WINAPI
DriverPackageUninstallA(
        PCSTR DriverPackageInfPath,
        DWORD 	Flags,
      PCINSTALLERINFO_A pInstallerInfo,
       BOOL * pNeedReboot
    );
*)
function DriverPackageUninstallA (
        DriverPackageInfPath: PChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_A;
        var pNeedReboot: Boolean): DWORD; stdcall; external SETUP_API_DLL_NAME;

(*        
#ifdef UNICODE
#define DriverPackageUninstall DriverPackageUninstallW
#else
#define DriverPackageUninstall DriverPackageUninstallA
#endif
*)
function DriverPackageUninstall (
        DriverPackageInfPath: PChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_A;
        var pNeedReboot: Boolean): DWORD; overload;
function DriverPackageUninstall (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_W;
        var pNeedReboot: Boolean): DWORD; overload;


//
// Get Driver Package path
//
(*
WINDIFXAPI
DWORD
WINAPI
DriverPackageGetPathW(
     PCWSTR DriverPackageInfPath,
    	PWSTR pDestInfPath,
     DWORD * pNumOfChars
    );
*)
function DriverPackageGetPathW (
        DriverPackageInfPath: PWideChar;
        pDestInfPath: PWideChar;
        var pNumOfChars: DWORD): DWORD; stdcall; external SETUP_API_DLL_NAME;

(*
WINDIFXAPI
DWORD
WINAPI
DriverPackageGetPathA(
     PCSTR DriverPackageInfPath,
    	PSTR pDestInfPath,
     DWORD * pNumOfChars
    );
*)
function DriverPackageGetPathA (
        DriverPackageInfPath: PChar;
        pDestInfPath: PChar;
        var pNumOfChars: DWORD): DWORD; stdcall; external SETUP_API_DLL_NAME;

(*
#ifdef UNICODE
#define DriverPackageGetPath DriverPackageGetPathW
#else
#define DriverPackageGetPath DriverPackageGetPathA
#endif
*)
function DriverPackageGetPath (
        DriverPackageInfPath: PChar;
        pDestInfPath: PChar;
        var pNumOfChars: DWORD): DWORD; overload;
function DriverPackageGetPath (
        DriverPackageInfPath: PWideChar;
        pDestInfPath: PWideChar;
        var pNumOfChars: DWORD): DWORD; overload;

(*
WINDIFXAPI
VOID
WINAPI
DIFXAPISetLogCallbackW(
     DIFXAPILOGCALLBACK_W LogCallback,
     PVOID CallbackContext
    );
*)
procedure DIFXAPISetLogCallbackW (
        LogCallback: DIFXAPILOGCALLBACK_W;
        var CallbackContext); stdcall; external SETUP_API_DLL_NAME;

(*
WINDIFXAPI
VOID
WINAPI
DIFXAPISetLogCallbackA(
     DIFXAPILOGCALLBACK_A LogCallback,
     PVOID CallbackContext
    );
*)
procedure DIFXAPISetLogCallbackA (
        LogCallback: DIFXAPILOGCALLBACK_A;
        var CallbackContext); stdcall; external SETUP_API_DLL_NAME;

(*
#ifdef UNICODE
    #define DIFXAPILOGCALLBACK DIFXAPILOGCALLBACK_W
    #define DIFXAPISetLogCallback DIFXAPISetLogCallbackW
#else
    #define DIFXAPILOGCALLBACK DIFXAPILOGCALLBACK_A
    #define DIFXAPISetLogCallback DIFXAPISetLogCallbackA
#endif
*)
procedure DIFXAPISetLogCallback (
        LogCallback: DIFXAPILOGCALLBACK_A;
        var CallbackContext); overload;
procedure DIFXAPISetLogCallback (
        LogCallback: DIFXAPILOGCALLBACK_W;
        var CallbackContext); overload;

implementation

function DriverPackagePreinstall (
        DriverPackageInfPath: PChar;
        Flags: DWORD): DWORD;
begin
        Result := DriverPackagePreinstallA (
                DriverPackageInfPath,
                Flags);
end;

function DriverPackagePreinstall (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD): DWORD; overload;
begin
        Result := DriverPackagePreinstallW (
                DriverPackageInfPath,
                Flags);
end;

function DriverPackageInstall (
        DriverPackageInfPath: PChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_A;
        var pNeedReboot: Boolean): DWORD;
begin
        Result := DriverPackageInstallA (
                DriverPackageInfPath,
                Flags,
                pInstallerInfo,
                pNeedReboot);
end;

function DriverPackageInstall (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_W;
        var pNeedReboot: Boolean): DWORD; overload;
begin
        Result := DriverPackageInstallW (
                DriverPackageInfPath,
                Flags,
                pInstallerInfo,
                pNeedReboot);
end;

function DriverPackageUninstall (
        DriverPackageInfPath: PChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_A;
        var pNeedReboot: Boolean): DWORD;
begin
        Result := DriverPackageUninstallA (
                DriverPackageInfPath,
                Flags,
                pInstallerInfo,
                pNeedReboot);
end;

function DriverPackageUninstall (
        DriverPackageInfPath: PWideChar;
        Flags: DWORD;
        pInstallerInfo: PCINSTALLERINFO_W;
        var pNeedReboot: Boolean): DWORD; overload;
begin
        Result := DriverPackageUninstallW (
                DriverPackageInfPath,
                Flags,
                pInstallerInfo,
                pNeedReboot);
end;

function DriverPackageGetPath (
        DriverPackageInfPath: PChar;
        pDestInfPath: PChar;
        var pNumOfChars: DWORD): DWORD;
begin
        Result := DriverPackageGetPathA (
                DriverPackageInfPath,
                pDestInfPath,
                pNumOfChars);
end;

function DriverPackageGetPath (
        DriverPackageInfPath: PWideChar;
        pDestInfPath: PWideChar;
        var pNumOfChars: DWORD): DWORD;
begin
        Result := DriverPackageGetPathW (
                DriverPackageInfPath,
                pDestInfPath,
                pNumOfChars);
end;

procedure DIFXAPISetLogCallback (
        LogCallback: DIFXAPILOGCALLBACK_A;
        var CallbackContext);
begin
        DIFXAPISetLogCallbackA (
                LogCallback,
                CallbackContext);
end;

procedure DIFXAPISetLogCallback (
        LogCallback: DIFXAPILOGCALLBACK_W;
        var CallbackContext);
begin
        DIFXAPISetLogCallbackW (
                LogCallback,
                CallbackContext);
end;

end.
