.386p

;============================================================================
;                               I N C L U D E S
;============================================================================

.xlist
                        include vmm.inc
                        include vkd.inc
                        include basedef.inc
                        include vwin32.inc
                        include debug.inc
.list
                        include SMKBDDRV.inc
                        include Filter.inc
                        include kbdfunc.inc

;============================================================================
;                            P U B L I C   D A T A
;============================================================================

VXD_LOCKED_DATA_SEG

pOldHookProc            dd              NULL

VXD_LOCKED_DATA_ENDS

DECLARE_VIRTUAL_DEVICE  SMKBDDRV,               \
                        SMKBDDRV_MAJOR_VERSION, \
                        SMKBDDRV_MINOR_VERSION, \
                        SMKBDDRV_Control,       \
                        UNDEFINED_DEVICE_ID,    \
                        UNDEFINED_INIT_ORDER

;============================================================================
;                              M A I N   C O D E
;============================================================================

VXD_LOCKED_CODE_SEG

;----------------------------------------------------------------------------
; SMKBDDRV_Control
;----------------------------------------------------------------------------

BeginProc               SMKBDDRV_Control
                        Control_Dispatch SYS_DYNAMIC_DEVICE_INIT, SMKBDDRV_Device_Init
                        Control_Dispatch SYS_DYNAMIC_DEVICE_EXIT, SMKBDDRV_Device_Exit
                        Control_Dispatch W32_DEVICEIOCONTROL,     SMKBDDRV_ioctl
                        clc
                        ret
EndProc                 SMKBDDRV_Control

;----------------------------------------------------------------------------
; SMKBDDRV_ioctl
;   ecx - DWORD  dwService
;   ebx - DWORD  dwDDB
;   edx - DWORD  hDevice
;   esi - LPDIOC lpDIOCParams
;----------------------------------------------------------------------------

BeginProc               SMKBDDRV_ioctl
local                   Error:DWORD

                        pushfd
                        pushad

                        mov     eax, [esi].dwIoControlCode
                        mov     Error, SMKBDDRV_ERROR_SUCCESS

                        cmp     eax, DIOC_OPEN          ;DIOC_GETVERSION
                        je      short ioctl_DIOC_Open

                        cmp     eax, DIOC_CLOSEHANDLE
                        je      short ioctl_DIOC_CloseHandle

                        cmp     eax, IOCTL_WRITE_DATA
                        je      ioctl_DIOC_WRITE_DATA

                        cmp     eax, IOCTL_SEND_DATA
                        je      ioctl_DIOC_SEND_DATA

                        cmp     eax, IOCTL_GET_VERSION
                        je      ioctl_DIOC_GET_VERSION

                        mov     Error, SMKBDDRV_ERROR_UNKNOWN_CMD

ioctl_Error:            popad
                        popfd
                        mov     eax, Error
                        stc
                        ret
                        
ioctl_Success:          popad
                        popfd
                        mov     eax, Error
                        clc
                        ret


ioctl_DIOC_Open:        DPrintf 'DIOC_Open'
                        GetVxDServiceOrdinal eax, VKD_Filter_Keyboard_Input
                        mov     esi, OFFSET32 SMKBDDRV_HookProc
                        VMMCall Hook_Device_Service
                        jnc     short ioctl_Success
                        mov     Error, SMKBDDRV_ERROR_HOOK
                        jmp     short ioctl_Error

ioctl_DIOC_CloseHandle: DPrintf 'DIOC_CloseHandle'
                        GetVxDServiceOrdinal eax, VKD_Filter_Keyboard_Input
                        mov     esi, OFFSET32 SMKBDDRV_HookProc
                        VMMCall UnHook_Device_Service
                        jmp     short ioctl_Success


ioctl_Check_RetVal:     cmp     eax, SMKBDDRV_ERROR_SUCCESS
                        je      short ioctl_Success
                        mov     Error, eax
                        jmp     short ioctl_Error


ioctl_DIOC_WRITE_DATA:  INVOKE  ioWriteData,    [esi].lpvInBuffer,      \
                                                [esi].cbInBuffer
                        jmp     short ioctl_Check_RetVal

ioctl_DIOC_SEND_DATA:   INVOKE  ioSendData,     [esi].lpvInBuffer,      \
                                                [esi].cbInBuffer,       \
                                                [esi].lpvOutBuffer,     \
                                                [esi].cbOutBuffer,      \
                                                [esi].lpcbBytesReturned
                        jmp     short ioctl_Check_RetVal

ioctl_DIOC_GET_VERSION: INVOKE  ioGetVersion,   [esi].lpvOutBuffer,     \
                                                [esi].cbOutBuffer,      \
                                                [esi].lpcbBytesReturned
                        jmp     short ioctl_Check_RetVal
EndProc                 SMKBDDRV_ioctl

;----------------------------------------------------------------------------
; SMKBDDRV_HookProc
; IN:
;   CL - BYTE bScanCode
; OUT:
;   Carry Clear => continue processing, CL = new scan code
;   Carry set => Reject keyboard input.
;----------------------------------------------------------------------------

BeginProc               SMKBDDRV_HookProc, Hook_Proc, pOldHookProc

                        pushfd
                        pushad

                        INVOKE  FilterProc,     cl
                        cmp     eax, FALSE
                        jne     short HookProc_Continue

                        popad
                        popfd
                        stc
                        ret

HookProc_Continue:      popad
                        popfd
                        jmp     [pOldHookProc]
EndProc                 SMKBDDRV_HookProc

;----------------------------------------------------------------------------
; SMKBDDRV_Device_Exit
;----------------------------------------------------------------------------

BeginProc               SMKBDDRV_Device_Exit
                        clc
                        ret
EndProc                 SMKBDDRV_Device_Exit

VXD_LOCKED_CODE_ENDS

VXD_ICODE_SEG

;----------------------------------------------------------------------------
; SMKBDDRV_Device_Init
;----------------------------------------------------------------------------

BeginProc               SMKBDDRV_Device_Init
                        clc
                        ret
EndProc                 SMKBDDRV_Device_Init

VXD_ICODE_ENDS

                        END
