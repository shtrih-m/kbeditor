.386p

;============================================================================
;                               I N C L U D E S
;============================================================================

.xlist
                        include vmm.inc
                        include basedef.inc
                        include debug.inc
.list
                        include Filter.inc
                        include SMKBDDRV.inc
                        include KbdFunc.inc

;============================================================================
;                            P U B L I C   D A T A
;============================================================================

VXD_LOCKED_DATA_SEG

DrvData                 TDrvData        <MODE_READ_NOTHING>

VXD_LOCKED_DATA_ENDS

;============================================================================
;                              M A I N   C O D E
;============================================================================

VXD_LOCKED_CODE_SEG

;----------------------------------------------------------------------------
; FilterProc
; IN:
;   ReadByte - BYTE
; OUT:
;   EAX:  FALSE - not continue, TRUE - continue
;----------------------------------------------------------------------------

FilterProc              PROC    NEAR STDCALL PUBLIC,                    \
                                ReadByte:BYTE

IFDEF   DEBUG
                        push    eax
                        xor     eax, eax
                        mov     al, ReadByte
                        DPrintf '<- 0x%02X', <eax>
                        pop     eax
ENDIF
                        .IF  (DrvData.ModeRead == MODE_READ_NOTHING)
                            mov     eax, TRUE
                            ret
                        .ENDIF

                        push    esi
                        mov     al, ReadByte
                        mov     esi, DrvData.Buffer.Count

                        .IF  ((DrvData.ModeRead != MODE_READ_ALL) && (al == RESEND))
                            mov     DrvData.State, SMKBDDRV_ERROR_RESEND
                            mov     DrvData.ModeRead, MODE_READ_ALL
                            mov     DrvData.fReadEnd, TRUE
                        .ELSE
                            .IF  (DrvData.ModeRead == MODE_READ_CMDBYTE)
                                mov     DrvData.Buffer.Data[esi], al
                                inc     DrvData.Buffer.Count

                                mov     DrvData.State, SMKBDDRV_ERROR_SUCCESS
                                mov     DrvData.ModeRead, MODE_READ_ALL
                                mov     DrvData.fReadEnd, TRUE
                            .ELSEIF  (DrvData.ModeRead == MODE_READ_CADR)
                                .IF  (DrvData.StateReadByte == STATE_READBYTE_BEGIN)
                                    and     al, 0Fh
                                    mov     DrvData.Buffer.Data[esi], al
                                    mov     DrvData.StateReadByte, STATE_READBYTE_END
                                .ELSEIF  (DrvData.StateReadByte == STATE_READBYTE_END)
                                    shl     al, 4
                                    add     DrvData.Buffer.Data[esi], al
                                    mov     DrvData.StateReadByte, STATE_READBYTE_BEGIN

                                    .IF  (DrvData.StateReadCadr == STATE_READCADR_STX)
                                        .IF  (DrvData.Buffer.Data[esi] == STX)
                                            inc     DrvData.Buffer.Count
                                            mov     DrvData.StateReadCadr, STATE_READCADR_LENGTH
                                        .ENDIF
                                    .ELSEIF  (DrvData.StateReadCadr == STATE_READCADR_LENGTH)
                                        xor     eax, eax
                                        mov     al, DrvData.Buffer.Data[esi]
                                        inc     eax
                                        inc     DrvData.Buffer.Count
                                        add     eax, DrvData.Buffer.Count
                                        mov     DrvData.NeedRead, eax
                                        mov     DrvData.StateReadCadr, STATE_READCADR_DATA
                                    .ELSEIF  (DrvData.StateReadCadr == STATE_READCADR_DATA)
                                        inc     DrvData.Buffer.Count
                                        inc     esi
                                        .IF  (esi == DrvData.NeedRead)
                                            mov     DrvData.State, SMKBDDRV_ERROR_SUCCESS
                                            mov     DrvData.ModeRead, MODE_READ_ALL
                                            mov     DrvData.fReadEnd, TRUE
                                        .ENDIF
                                    .ENDIF
                                .ENDIF
                            .ENDIF
                        .ENDIF

                        pop     esi
                        mov     eax, FALSE
                        ret
FilterProc              ENDP

;----------------------------------------------------------------------------
; ioWriteData
; IN:
;   lpvInBuffer - DWORD
;   cbInBuffer  - DWORD
; OUT:
;   EAX:  SMKBDDRV_ERROR_SUCCESS - success, else error code
;----------------------------------------------------------------------------

ioWriteData             PROC    NEAR STDCALL PUBLIC,                    \
                                lpvInBuffer:DWORD,                      \
                                cbInBuffer:DWORD

                        .IF  ((lpvInBuffer == NULL) || (cbInBuffer == 0))
                            mov     eax, SMKBDDRV_ERROR_PARAM
                            ret
                        .ENDIF

                        INVOKE  KbdWriteData,   lpvInBuffer,            \
                                                cbInBuffer
                        mov     eax, SMKBDDRV_ERROR_SUCCESS
                        ret
ioWriteData             ENDP

;----------------------------------------------------------------------------
; ioSendData
; IN:
;   lpvInBuffer - DWORD
;   cbInBuffer - DWORD
;   lpvOutBuffer - DWORD
;   cbOutBuffer - DWORD
;   lpcbBytesReturned - DWORD
; OUT:
;   EAX:  SMKBDDRV_ERROR_SUCCESS - success, else error code
;----------------------------------------------------------------------------

ioSendData              PROC    NEAR STDCALL PUBLIC,                    \
                                lpvInBuffer:DWORD,                      \
                                cbInBuffer:DWORD,                       \
                                lpvOutBuffer:DWORD,                     \
                                cbOutBuffer:DWORD,                      \
                                lpcbBytesReturned:DWORD
LOCAL                           Status:DWORD,                           \
                                fCmdByteChanged:DWORD,                  \
                                CommandByte:BYTE

                        .IF  ((lpvInBuffer == NULL) || (cbInBuffer == 0) || (lpvOutBuffer == NULL) || (cbOutBuffer == 0) || (lpcbBytesReturned == NULL))
                            mov     eax, SMKBDDRV_ERROR_PARAM
                            ret
                        .ENDIF

                        DPrintf '---------------> C A D R <---------------'
                        
                        INVOKE   DisableMouse

                        INVOKE  WriteCommandByte,   025h                        
                        INVOKE  KbdBlock,   OFFSET32 DrvData,           \
                                            TRUE

                        INVOKE  ReadCadr,   OFFSET32 DrvData,   \
                                            lpvInBuffer,        \
                                            cbInBuffer
                        mov     Status, eax
                        .IF  (eax == SMKBDDRV_ERROR_SUCCESS)
                            push    ecx
                            mov     ecx, DrvData.Buffer.Count
                            .IF  (cbOutBuffer < ecx)
                                DPrintf 'ioSendData small buffer: %lu %lu', <cbOutBuffer, ecx>
                                mov     Status, SMKBDDRV_ERROR_BUFFER_TOO_SMALL
                            .ELSE
                                push    edi
                                push    esi

                                mov     esi, lpcbBytesReturned
                                mov     [esi], ecx

                                push    es
                                push    ds
                                pop     es
                                mov     esi, OFFSET32 DrvData.Buffer.Data
                                mov     edi, lpvOutBuffer
                                cld
                                rep     movsb
                                pop     es

                                pop     esi
                                pop     edi
                            .ENDIF
                            pop     ecx
                        .ENDIF
ioSendData_Exit:
                        INVOKE  WriteCommandByte,   067h
                        INVOKE  KbdBlock,   OFFSET32 DrvData,           \
                                            FALSE
                                            
                        INVOKE  EnableMouse
                        DPrintf '-----------------------------------------'

                        mov     eax, Status
                        ret
ioSendData              ENDP

;----------------------------------------------------------------------------
; ioGetVersion
; IN:
;   lpvOutBuffer - DWORD
;   cbOutBuffer - DWORD
;   lpcbBytesReturned - DWORD
; OUT:
;   EAX:  SMKBDDRV_ERROR_SUCCESS - success, else error code
;----------------------------------------------------------------------------

ioGetVersion            PROC    NEAR STDCALL PUBLIC,                    \
                                lpvOutBuffer:DWORD,                     \
                                cbOutBuffer:DWORD,                      \
                                lpcbBytesReturned:DWORD
LOCAL                           Status:DWORD

                        .IF  (cbOutBuffer < SIZE DWORD)
                            DPrintf 'ioGetVersion small buffer: %lu %lu', <cbOutBuffer, SIZE DWORD>
                            mov     Status, SMKBDDRV_ERROR_BUFFER_TOO_SMALL
                        .ELSE
                            push    esi
                            mov     esi, lpvOutBuffer
                            mov     DWORD PTR [esi], DRIVER_VERSION

                            mov     esi, lpcbBytesReturned
                            mov     DWORD PTR [esi], SIZE DWORD
                            pop     esi

                            mov     Status, SMKBDDRV_ERROR_SUCCESS
                        .ENDIF

                        mov     eax, Status
                        ret
ioGetVersion            ENDP

VXD_LOCKED_CODE_ENDS

                        END
