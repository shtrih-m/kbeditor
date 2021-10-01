.386p

;============================================================================
;                               I N C L U D E S
;============================================================================

.xlist
                        include vmm.inc
                        include basedef.inc
                        include regdef.inc
.list
                        include MixFunc.inc

;============================================================================
;                              M A I N   C O D E
;============================================================================

VXD_LOCKED_CODE_SEG

;----------------------------------------------------------------------------
; Str2Dec - Конвертирует ascii строку в беззнаковое десятичное число (*)
; IN:
;   DWORD pStr - Адрес строки (строка заканчивается 0)
;   DWORD pdwNumber - Адрес DWORD числа
; OUT:
;   EAX - TRUE  - Конвертирование удачное
;         FALSE - не удачное
;----------------------------------------------------------------------------

Str2Dec                 PROC    NEAR STDCALL PUBLIC,                    \
                                pStr:DWORD,                             \
                                pdwNumber:DWORD
LOCAL                           NumberBase:DWORD,                       \
                                fDigit:DWORD

                        mov     NumberBase, 10
                        mov     fDigit, FALSE

                        push    esi
                        push    edx

                        xor     eax, eax
                        mov     esi, pStr
                        .WHILE  (BYTE PTR [esi] != 0)
                            .IF  ((BYTE PTR [esi] == ' ') || (BYTE PTR [esi] == 09h))
                                .BREAK  .IF  (fDigit != FALSE)
                            .ELSE
                                .BREAK  .IF  ((BYTE PTR [esi] < '0') || (BYTE PTR [esi] > '9'))

                                mul     NumberBase
                                xor     edx, edx
                                mov     dl, [esi]
                                sub     dl, '0'
                                add     eax, edx

                                mov     fDigit, TRUE
                            .ENDIF
                            inc     esi
                        .ENDW
                        mov     esi, pdwNumber
                        mov     [esi], eax

                        pop     edx
                        pop     esi

                        mov     eax, fDigit
                        ret
Str2Dec                 ENDP

;----------------------------------------------------------------------------
; RegQueryStr - Прочитать из реестра строку
; IN:
;   DWORD hKey - Ключ реестра
;   DWORD pValueName - Адрес строки с именем параметра
;   DWORD pStr - Адрес строки, куда копируется параметр
;   DWORD pdwSizeStr - Адрес DWORD-а с размером строки
; OUT:
;   EAX - TRUE  - Прочитано успешно
;       - FALSE - не успешно
;----------------------------------------------------------------------------

RegQueryStr             PROC    NEAR STDCALL PUBLIC,                    \
                                hKey:DWORD,                             \
                                pValueName:DWORD,                       \
                                pStr:DWORD,                             \
                                pdwSizeStr:DWORD
LOCAL                           ParamType:DWORD

                        push    esi
                        lea     esi, ParamType
                        VMMCall _RegQueryValueEx,   <hKey, pValueName, NULL, esi, NULL, NULL>
                        pop     esi
                        .IF  (eax == ERROR_SUCCESS)
                            .IF  (ParamType == REG_SZ)
                                VMMCall _RegQueryValueEx,   <hKey, pValueName, NULL, NULL, pStr, pdwSizeStr>
                                .IF  (eax == ERROR_SUCCESS)
                                    mov     eax, TRUE
                                    ret
                                .ENDIF
                            .ENDIF
                        .ENDIF
                        mov     eax, FALSE
                        ret
RegQueryStr             ENDP

VXD_LOCKED_CODE_ENDS

                        END
