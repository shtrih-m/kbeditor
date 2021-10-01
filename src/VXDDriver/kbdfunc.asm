.386p

;============================================================================
;                               I N C L U D E S
;============================================================================

.xlist
                        include vmm.inc
                        include basedef.inc
                        include regdef.inc
                        include regstr.inc
                        include debug.inc
.list
                        include KbdFunc.inc
                        include Filter.inc
                        include SMKBDDRV.inc
                        include MixFunc.inc

;============================================================================
;                            P U B L I C   D A T A
;============================================================================

VXD_LOCKED_DATA_SEG

RegPath                 db              'Control Panel\Keyboard', 0
RegDelayName            db              'KeyboardDelay', 0
RegSpeedName            db              'KeyboardSpeed', 0

TypematicTable          db              1Fh, 1Fh, 1Fh, 1Ah, 17h, 14h, 12h, 11h
                        db              0Fh, 0Dh, 0Ch, 0Bh, 0Ah, 09h, 09h, 08h
                        db              07h, 06h, 06h, 05h, 04h, 04h, 03h, 03h
                        db              02h, 02h, 01h, 01h, 01h, 00h, 00h, 00h

VXD_LOCKED_DATA_ENDS

;============================================================================
;                              M A I N   C O D E
;============================================================================

VXD_LOCKED_CODE_SEG

;----------------------------------------------------------------------------
; KbdWaitStatusWrite - Ожидание готовности к записи (*)
; OUT:
;   EAX - TRUE  - ok
;       - FALSE - error (timeout)
;----------------------------------------------------------------------------

KbdWaitStatusWrite      PROC    NEAR STDCALL PUBLIC

                        push    esi
                        VMMCall Get_System_Time
                        mov     esi, eax
                        .REPEAT
                            READ_PORT_AL    I8042_PHYSICAL_BASE+I8042_STATUS_REGISTER_OFFSET
                            and     al, 02h
                            .IF  (al == 0)
                                mov     eax, TRUE
                                pop     esi
                                ret
                            .ENDIF

                            VMMCall Get_System_Time
                            sub     eax, esi
                        .UNTIL  (eax >= TIMEOUT_WAIT_STATUS_OK)

                        DPrintf 'KbdWaitStatusWrite: Timeout'
                        mov     eax, FALSE
                        pop     esi
                        ret
KbdWaitStatusWrite      ENDP

;----------------------------------------------------------------------------
; KbdWriteByte - запись байта в порт (*)
;----------------------------------------------------------------------------

KbdWriteByte            PROC    NEAR STDCALL PUBLIC,                    \
                                WriteByte:BYTE

IFDEF   DEBUG
                        push    eax
                        xor     eax, eax
                        mov     al, WriteByte
                        DPrintf '-> 0x%02X', <eax>
                        pop     eax
ENDIF
                        INVOKE  KbdWaitStatusWrite
                        WRITE_PORT_UCHAR    I8042_PHYSICAL_BASE+I8042_DATA_REGISTER_OFFSET, WriteByte
                        ret
KbdWriteByte            ENDP

;----------------------------------------------------------------------------
; KbdWriteCmd - Запись команды контроллера клавиатуры (*)
;----------------------------------------------------------------------------

KbdWriteCmd             PROC    NEAR STDCALL PUBLIC,                    \
                                Cmd:BYTE

IFDEF   DEBUG
                        push    eax
                        xor     eax, eax
                        mov     al, Cmd
                        DPrintf '-> 0x%02X (Cmd)', <eax>
                        pop     eax
ENDIF
                        INVOKE  KbdWaitStatusWrite
                        WRITE_PORT_UCHAR    I8042_PHYSICAL_BASE+I8042_COMMAND_REGISTER_OFFSET, Cmd
                        ret
KbdWriteCmd             ENDP

;----------------------------------------------------------------------------
; WriteCommandByte - Запись командного байта клавиатуры (*)
;----------------------------------------------------------------------------

WriteCommandByte        PROC    NEAR STDCALL PUBLIC,                    \
                                CommandByte:BYTE

                        INVOKE  KbdWriteCmd,    I8042_WRITE_CONTROLLER_COMMAND_BYTE
                        INVOKE  KbdWriteByte,   CommandByte
                        ret
WriteCommandByte        ENDP

;----------------------------------------------------------------------------
; KbdWriteData - Запись данных в клавиатуру (*)
;----------------------------------------------------------------------------

KbdWriteData            PROC    NEAR STDCALL PUBLIC,                    \
                                lpvInBuffer:DWORD,                      \
                                cbInBuffer:DWORD

                        push    esi
                        push    ebx

                        xor     esi, esi
                        mov     ebx, lpvInBuffer
                        .WHILE  (esi < cbInBuffer)
                            INVOKE  KbdWriteByte,   BYTE PTR [ebx+esi]
                            inc     esi
                        .ENDW

                        pop     ebx
                        pop     esi
                        ret
KbdWriteData            ENDP

;----------------------------------------------------------------------------
; StartRead - Начать чтение (*)
; IN:
;   pDrvData - Адрес DrvData
;       Mode - Режим чтения
;----------------------------------------------------------------------------

StartRead               PROC    NEAR STDCALL PUBLIC,                    \
                                pDrvData:DWORD,                         \
                                Mode:DWORD

                        push    eax
                        push    esi

                        mov     esi, pDrvData
                        mov     eax, Mode
                        mov     [esi].ModeRead, eax
                        mov     [esi].StateReadByte, STATE_READBYTE_BEGIN
                        mov     [esi].StateReadCadr, STATE_READCADR_STX
                        mov     [esi].fReadEnd, FALSE
                        mov     [esi].Buffer.Count, 0

                        pop     esi
                        pop     eax
                        ret
StartRead               ENDP

;----------------------------------------------------------------------------
; StopRead - Закончить чтение (*)
; IN:
;   pDrvData - Адрес DrvData
;       Mode - Режим чтения
; OUT:
;   EAX - Код ошибки (SMKBDDRV_ERROR_SUCCESS - ошибок нет)
;----------------------------------------------------------------------------

StopRead                PROC    NEAR STDCALL PUBLIC,                    \
                                pDrvData:DWORD,                         \
                                Mode:DWORD
LOCAL                           Timeout:DWORD

                        push    edi
                        push    esi

                        mov     esi, pDrvData
                        mov     eax, [esi].ModeRead

                        .IF  (eax == MODE_READ_CMDBYTE)
                            mov     Timeout, TIMEOUT_READ_BYTE
                        .ELSEIF  (eax == MODE_READ_CADR)
                            mov     Timeout, TIMEOUT_READ_CADR
                        .ELSE
                            mov     Timeout, 0
                        .ENDIF

                        VMMCall Get_System_Time
                        mov     edi, eax

                        .REPEAT
                            .IF  ([esi].fReadEnd)
                                mov     eax, [esi].State
                                pop     esi
                                pop     edi
                                ret
                            .ENDIF

                            VMMCall Get_System_Time
                            sub     eax, edi
                        .UNTIL  (eax >= Timeout)

                        DPrintf 'StopRead: Timeout'
                        mov     [esi].ModeRead, MODE_READ_ALL
                        mov     eax, SMKBDDRV_ERROR_TIMEOUT
                        pop     esi
                        pop     edi
                        ret
StopRead                ENDP

;----------------------------------------------------------------------------
; ReadCommandByte - Чтение командного байта из клавиатуры (*)
; Командный байт передается в буфере
; IN:
;   pDrvData - Адрес DrvData
; OUT:
;   EAX - Код ошибки (SMKBDDRV_ERROR_SUCCESS - ошибок нет)
;----------------------------------------------------------------------------

ReadCommandByte         PROC    NEAR STDCALL PUBLIC,                    \
                                pDrvData:DWORD
LOCAL                           i_resend:DWORD

                        mov     i_resend, 0
                        .REPEAT
                            INVOKE  StartRead,      pDrvData,               \
                                                    MODE_READ_CMDBYTE
                            INVOKE  KbdWriteCmd,    I8042_READ_CONTROLLER_COMMAND_BYTE
                            INVOKE  StopRead,       pDrvData,               \
                                                    MODE_READ_CMDBYTE

                            .IF  (eax != SMKBDDRV_ERROR_RESEND)
                                ret
                            .ENDIF

                            inc     i_resend
                        .UNTIL  (i_resend >= RESEND_ITERATIONS)
                        ret
ReadCommandByte         ENDP

;----------------------------------------------------------------------------
; ReadCadr - Чтение кадра из клавиатуры (*)
; Кадр передается в буфере
; IN:
;      pDrvData - Адрес DrvData
;   lpvInBuffer - Адрес буфера с данными
;    cbInBuffer - Размер буфера
; OUT:
;   EAX - Код ошибки (SMKBDDRV_ERROR_SUCCESS - ошибок нет)
;----------------------------------------------------------------------------

ReadCadr                PROC    NEAR STDCALL PUBLIC,                    \
                                pDrvData:DWORD,                         \
                                lpvInBuffer:DWORD,                      \
                                cbInBuffer:DWORD
LOCAL                           i_resend:DWORD

                        mov     i_resend, 0
                        .REPEAT
                            INVOKE  StartRead,      pDrvData,               \
                                                    MODE_READ_CADR
                            INVOKE  KbdWriteData,   lpvInBuffer,            \
                                                    cbInBuffer
                            INVOKE  StopRead,       pDrvData,               \
                                                    MODE_READ_CADR

                            .IF  (eax != SMKBDDRV_ERROR_RESEND)
                                ret
                            .ENDIF

                            inc     i_resend
                        .UNTIL  (i_resend >= RESEND_ITERATIONS)
                        ret
ReadCadr                ENDP

;----------------------------------------------------------------------------
; RestoreTypematic - Восстанавливает настройки клавиатуры (*)
;----------------------------------------------------------------------------

RestoreTypematic        PROC    NEAR STDCALL PUBLIC
LOCAL                           hKey:DWORD,                             \
                                DelayStr[REGSTR_MAX_VALUE_LENGTH]:BYTE, \
                                SpeedStr[REGSTR_MAX_VALUE_LENGTH]:BYTE, \
                                Delay:DWORD,                            \
                                Speed:DWORD,                            \
                                Tmp:DWORD,                              \
                                Cmd[2]:BYTE

                        DPrintf '-> Old keyboard param'

                        push    ebx
                        push    esi

                        lea     esi, hKey
                        VMMCall _RegOpenKey,    <HKEY_CURRENT_USER, OFFSET32 RegPath, esi>
                        .IF  (eax == ERROR_SUCCESS)
                            mov     Tmp, REGSTR_MAX_VALUE_LENGTH
                            lea     esi, DelayStr
                            lea     ebx, Tmp
                            INVOKE  RegQueryStr,    hKey,                   \
                                                    OFFSET32 RegDelayName,  \
                                                    esi,                    \
                                                    ebx
                            .IF  (eax != FALSE)
                                mov     Tmp, REGSTR_MAX_VALUE_LENGTH
                                lea     esi, SpeedStr
                                lea     ebx, Tmp
                                INVOKE  RegQueryStr,    hKey,                   \
                                                        OFFSET32 RegSpeedName,  \
                                                        esi,                    \
                                                        ebx
                                .IF  (eax != FALSE)
                                    lea     esi, DelayStr
                                    lea     ebx, Delay
                                    INVOKE  Str2Dec,    esi,                        \
                                                        ebx
                                    .IF  (eax != FALSE)
                                        lea     esi, SpeedStr
                                        lea     ebx, Speed
                                        INVOKE  Str2Dec,    esi,                        \
                                                            ebx
                                        .IF  (eax != FALSE)
                                            .IF  ((Delay >= 0) && (Delay <= 11b) && (Speed >= 0) && (Speed <= 11111b))
                                                mov     Cmd[0], KBD_CMD_SET_TYPEMATIC

                                                mov     ebx, Delay
                                                shl     bl, 5
                                                mov     esi, Speed
                                                or      bl, TypematicTable[esi]
                                                mov     Cmd[1], bl

                                                lea     esi, Cmd
                                                INVOKE  KbdWriteData,   esi,                    \
                                                                        2
                                            .ENDIF
                                        .ENDIF
                                    .ENDIF
                                .ENDIF
                            .ENDIF
                            VMMCall _RegCloseKey,   <hKey>
                        .ENDIF

                        pop     esi
                        pop     ebx
                        ret
RestoreTypematic        ENDP

;----------------------------------------------------------------------------
; Включаем мышь (*)
;----------------------------------------------------------------------------

EnableMouse             PROC    NEAR STDCALL PUBLIC

                        INVOKE  KbdWriteCmd,    I8042_ENABLE_MOUSE_DEVICE
                        ret
EnableMouse             ENDP

;----------------------------------------------------------------------------
; Включаем клавиатуру (*)
;----------------------------------------------------------------------------

EnableKeyboard          PROC    NEAR STDCALL PUBLIC

                        INVOKE  KbdWriteCmd,    I8042_ENABLE_KEYBOARD_DEVICE
                        ret
EnableKeyboard          ENDP

;----------------------------------------------------------------------------
; Отключаем мышь (*)
;----------------------------------------------------------------------------

DisableMouse            PROC    NEAR STDCALL PUBLIC

                        INVOKE  KbdWriteCmd,    I8042_DISABLE_MOUSE_DEVICE
                        ret
DisableMouse            ENDP

;----------------------------------------------------------------------------
; Отключаем клавиатуру (*)
;----------------------------------------------------------------------------

DisableKeyboard         PROC    NEAR STDCALL PUBLIC

                        INVOKE  KbdWriteCmd,    I8042_DISABLE_KEYBOARD_DEVICE
                        ret
DisableKeyboard         ENDP

;----------------------------------------------------------------------------
; KbdBlock - Блокировка клавиатуры (*)
; IN:
;   DWORD fBlock - TRUE  - установить
;                - FALSE - снять
;----------------------------------------------------------------------------

KbdBlock                PROC    NEAR STDCALL PUBLIC,                    \
                                pDrvData:DWORD,                         \
                                fBlock:DWORD
LOCAL                           Cmd:BYTE

                        push    esi
                        mov     esi, pDrvData
                        .IF  (fBlock)
                            mov     Cmd, KBD_CMD_BLOCK_ON
                            mov     [esi].ModeRead, MODE_READ_ALL                            
                        .ELSE
                            INVOKE  RestoreTypematic
                            mov     Cmd, KBD_CMD_BLOCK_OFF
                            mov     [esi].ModeRead, MODE_READ_NOTHING                            
                        .ENDIF

                        lea     esi, Cmd
                        INVOKE  KbdWriteData,   esi,                    \
                                                1
                        pop     esi
                        ret
KbdBlock                ENDP

VXD_LOCKED_CODE_ENDS

                        END
