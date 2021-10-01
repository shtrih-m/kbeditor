SMKBDDRV_DYNAMIC                EQU     1

;============================================================================
;                                V E R S I O N
;============================================================================

SMKBDDRV_MAJOR_VERSION          EQU     1
SMKBDDRV_MINOR_VERSION          EQU     0

MAKEVERSION                     MACRO   Name, b1, b2, b3, b4
Name                            EQU     (b1 SHL 24) + (b2 SHL 16) + (b3 SHL 8) + b4
                                ENDM

MAKEVERSION                     DRIVER_VERSION,         SMKBDDRV_MAJOR_VERSION, \
                                                        SMKBDDRV_MINOR_VERSION, \
                                                        0,                      \
                                                        1

;============================================================================
;                            E R R O R   C O D E S
;============================================================================

SMKBDDRV_ERROR_SUCCESS          EQU      0
SMKBDDRV_ERROR_UNKNOWN_CMD      EQU     -1
SMKBDDRV_ERROR_HOOK             EQU      1
SMKBDDRV_ERROR_PARAM            EQU      2
SMKBDDRV_ERROR_RESEND           EQU      3
SMKBDDRV_ERROR_TIMEOUT          EQU      4
SMKBDDRV_ERROR_BUFFER_TOO_SMALL EQU      5

;============================================================================
;                              C T L   C O D E S
;============================================================================

FILE_DEVICE_KEYBOARD            EQU     0000000bh
METHOD_BUFFERED                 EQU     00000000h
FILE_ANY_ACCESS                 EQU     00000000h

CTL_CODE                        MACRO   CodeName, DeviceType, Function, Method, Access
CodeName                        EQU     ((DeviceType) shl 16) + \
                                        ((Access) shl 14)     + \
                                        ((Function) shl 2)    + \
                                        (Method)
                                ENDM

CTL_CODE                        IOCTL_WRITE_DATA,       FILE_DEVICE_KEYBOARD, \
                                                        2048,                 \
                                                        METHOD_BUFFERED,      \
                                                        FILE_ANY_ACCESS

CTL_CODE                        IOCTL_SEND_DATA,        FILE_DEVICE_KEYBOARD, \
                                                        2049,                 \
                                                        METHOD_BUFFERED,      \
                                                        FILE_ANY_ACCESS

CTL_CODE                        IOCTL_GET_VERSION       FILE_DEVICE_KEYBOARD, \
                                                        2050,                 \
                                                        METHOD_BUFFERED,      \
                                                        FILE_ANY_ACCESS
