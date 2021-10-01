;============================================================================
;                         K E Y B O A R D   C O N S T
;============================================================================

I8042_PHYSICAL_BASE             EQU     60h
I8042_DATA_REGISTER_OFFSET      EQU      0h
I8042_COMMAND_REGISTER_OFFSET   EQU      4h
I8042_STATUS_REGISTER_OFFSET    EQU      4h

; Define commands to the 8042 controller.
I8042_READ_CONTROLLER_COMMAND_BYTE      EQU     020h
I8042_WRITE_CONTROLLER_COMMAND_BYTE     EQU     060h
I8042_DISABLE_MOUSE_DEVICE              EQU     0A7h
I8042_ENABLE_MOUSE_DEVICE               EQU     0A8h
I8042_DISABLE_KEYBOARD_DEVICE           EQU     0ADh
I8042_ENABLE_KEYBOARD_DEVICE            EQU     0AEh

ACKNOWLEDGE                             EQU     0FAh
RESEND                                  EQU     0FEh

KBD_CMD_BLOCK_ON                        EQU     0F5h
KBD_CMD_BLOCK_OFF                       EQU     0F4h
KBD_CMD_SET_TYPEMATIC                   EQU     0F3h

;============================================================================
;                                T I M E O U T
;============================================================================

TIMEOUT_READ_BYTE               EQU      300
TIMEOUT_READ_CADR               EQU     1200
TIMEOUT_WAIT_STATUS_OK          EQU      300
RESEND_ITERATIONS               EQU        3

;============================================================================
;                                  M A C R O
;============================================================================

;----------------------------------------------------------------------------
; DPrintf - Защищенная Debug_Printf
;----------------------------------------------------------------------------

DPrintf                 MACRO   fmt, args, dl
IFDEF   DEBUG
                        pushfd
                        pushad

                        Debug_Printf    fmt, <args>, dl

                        popad
                        popfd
ENDIF
                        ENDM

;----------------------------------------------------------------------------
; WRITE_PORT_UCHAR - Запись байта в порт
;----------------------------------------------------------------------------

WRITE_PORT_UCHAR        MACRO   Port, Byte
                        push    eax

                        mov     al, Byte
                        out     Port, al

                        pop     eax
                        ENDM

;----------------------------------------------------------------------------
; READ_PORT_UCHAR - Чтение байта из порта
;----------------------------------------------------------------------------

READ_PORT_UCHAR         MACRO   Port, Byte
                        push    eax

                        in      al, Port
                        mov     Byte, al

                        pop     eax
                        ENDM

;----------------------------------------------------------------------------
; READ_PORT_AL - Чтение байта из порта в регистр AL
;----------------------------------------------------------------------------

READ_PORT_AL            MACRO   Port
                        in      al, Port
                        ENDM

;============================================================================
;                             P R O T O T Y P E S
;============================================================================

WriteCommandByte        PROTO   NEAR STDCALL,                           \
                                CommandByte:BYTE

KbdWriteData            PROTO   NEAR STDCALL,                           \
                                lpvInBuffer:DWORD,                      \
                                cbInBuffer:DWORD

ReadCommandByte         PROTO   NEAR STDCALL,                           \
                                pDrvData:DWORD

ReadCadr                PROTO   NEAR STDCALL,                           \
                                pDrvData:DWORD,                         \
                                lpvInBuffer:DWORD,                      \
                                cbInBuffer:DWORD

EnableKeyboard          PROTO   NEAR STDCALL

DisableKeyboard         PROTO   NEAR STDCALL

KbdBlock                PROTO   NEAR STDCALL,                           \
                                pDrvData:DWORD,                         \
                                fBlock:DWORD
EnableMouse             PROTO   NEAR STDCALL
DisableMouse            PROTO   NEAR STDCALL

