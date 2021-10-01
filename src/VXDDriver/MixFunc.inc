;============================================================================
;                             P R O T O T Y P E S
;============================================================================

Str2Dec                 PROTO   NEAR STDCALL,                           \
                                pStr:DWORD,                             \
                                pdwNumber:DWORD

RegQueryStr             PROTO   NEAR STDCALL,                           \
                                hKey:DWORD,                             \
                                pValueName:DWORD,                       \
                                pStr:DWORD,                             \
                                pdwSizeStr:DWORD
