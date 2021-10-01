;============================================================================
;                                  C O N S T
;============================================================================

;===> Состояния автомата <===
MODE_READ_NOTHING               EQU     0
MODE_READ_ALL                   EQU     1
MODE_READ_CMDBYTE               EQU     2
MODE_READ_CADR                  EQU     3

STATE_READBYTE_BEGIN            EQU     0
STATE_READBYTE_END              EQU     1

STATE_READCADR_STX              EQU     0
STATE_READCADR_LENGTH           EQU     1
STATE_READCADR_DATA             EQU     2

;===> Константы <===
STX                             EQU     2

;============================================================================
;                                  T Y P E S
;============================================================================

TBuffer                 STRUCT
Data                    db      258 dup (?)
Count                   dd      ?
TBuffer                 ENDS

TDrvData                STRUCT

;===> Состояние автомата <===
ModeRead                dd      ?       ;Режим чтения
StateReadByte           dd      ?       ;Состояние чтения байта в кадре
StateReadCadr           dd      ?       ;Состояние чтения кадра
NeedRead                dd      ?       ;Нужно прочитать (исп. в FilterProc)

;===> Выходные параметры <===
State                   dd      ?       ;Состояние по окончанию чтения
fReadEnd                dd      ?       ;Флаг окончания чтения
Buffer                  TBuffer <>      ;Буфер с прочитанными данными
TDrvData                ENDS

;============================================================================
;                             P R O T O T Y P E S
;============================================================================

FilterProc              PROTO   NEAR STDCALL,                           \
                                ReadByte:BYTE

ioWriteData             PROTO   NEAR STDCALL,                           \
                                lpvInBuffer:DWORD,                      \
                                cbInBuffer:DWORD

ioSendData              PROTO   NEAR STDCALL,                           \
                                lpvInBuffer:DWORD,                      \
                                cbInBuffer:DWORD,                       \
                                lpvOutBuffer:DWORD,                     \
                                cbOutBuffer:DWORD,                      \
                                lpcbBytesReturned:DWORD

ioGetVersion            PROTO   NEAR STDCALL,                           \
                                lpvOutBuffer:DWORD,                     \
                                cbOutBuffer:DWORD,                      \
                                lpcbBytesReturned:DWORD
