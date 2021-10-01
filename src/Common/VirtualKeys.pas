unit VirtualKeys;

interface

const

// Virtual Keys, Standard Set

  VK_LBUTTON        = $01;
  VK_RBUTTON        = $02;
  VK_CANCEL         = $03;
  VK_MBUTTON        = $04;    // NOT contiguous with L & RBUTTON
  VK_XBUTTON1       = $05;    // NOT contiguous with L & RBUTTON
  VK_XBUTTON2       = $06;    // NOT contiguous with L & RBUTTON
  VK_BACK           = $08;
  VK_TAB            = $09;
  VK_CLEAR          = $0C;
  VK_RETURN         = $0D;

  VK_SHIFT          = $10;
  VK_CONTROL        = $11;
  VK_MENU           = $12;
  VK_PAUSE          = $13;
  VK_CAPITAL        = $14;

  VK_KANA           = $15;
  VK_HANGEUL        = $15;  // old name - should be here for compatibility */
  VK_HANGUL         = $15;
  VK_JUNJA          = $17;
  VK_FINAL          = $18;
  VK_HANJA          = $19;
  VK_KANJI          = $19;

  VK_ESCAPE         = $1B;

  VK_CONVERT        = $1C;
  VK_NONCONVERT     = $1D;
  VK_ACCEPT         = $1E;
  VK_MODECHANGE     = $1F;

  VK_SPACE          = $20;
  VK_PRIOR          = $21;
  VK_NEXT           = $22;
  VK_END            = $23;
  VK_HOME           = $24;
  VK_LEFT           = $25;
  VK_UP             = $26;
  VK_RIGHT          = $27;
  VK_DOWN           = $28;
  VK_SELECT         = $29;
  VK_PRINT          = $2A;
  VK_EXECUTE        = $2B;
  VK_SNAPSHOT       = $2C;
  VK_INSERT         = $2D;
  VK_DELETE         = $2E;
  VK_HELP           = $2F;

  VK_0              = $30;
  VK_1              = $31;
  VK_2              = $32;
  VK_3              = $33;
  VK_4              = $34;
  VK_5              = $35;
  VK_6              = $36;
  VK_7              = $37;
  VK_8              = $38;
  VK_9              = $39;

  VK_A              = $41;
  VK_B              = $42;
  VK_C              = $43;
  VK_D              = $44;
  VK_E              = $45;
  VK_F              = $46;
  VK_G              = $47;
  VK_H              = $48;
  VK_I              = $49;
  VK_J              = $4A;
  VK_K              = $4B;
  VK_L              = $4C;
  VK_M              = $4D;
  VK_N              = $4E;
  VK_O              = $4F;
  VK_P              = $50;
  VK_Q              = $51;
  VK_R              = $52;
  VK_S              = $53;
  VK_T              = $54;
  VK_U              = $55;
  VK_V              = $56;
  VK_W              = $57;
  VK_X              = $58;
  VK_Y              = $59;
  VK_Z              = $5A;


  VK_LWIN           = $5B;
  VK_RWIN           = $5C;
  VK_APPS           = $5D;

  VK_SLEEP          = $5F;

  VK_NUMPAD0        = $60;
  VK_NUMPAD1        = $61;
  VK_NUMPAD2        = $62;
  VK_NUMPAD3        = $63;
  VK_NUMPAD4        = $64;
  VK_NUMPAD5        = $65;
  VK_NUMPAD6        = $66;
  VK_NUMPAD7        = $67;
  VK_NUMPAD8        = $68;
  VK_NUMPAD9        = $69;
  VK_MULTIPLY       = $6A;
  VK_ADD            = $6B;
  VK_SEPARATOR      = $6C;
  VK_SUBTRACT       = $6D;
  VK_DECIMAL        = $6E;
  VK_DIVIDE         = $6F;
  VK_F1             = $70;
  VK_F2             = $71;
  VK_F3             = $72;
  VK_F4             = $73;
  VK_F5             = $74;
  VK_F6             = $75;
  VK_F7             = $76;
  VK_F8             = $77;
  VK_F9             = $78;
  VK_F10            = $79;
  VK_F11            = $7A;
  VK_F12            = $7B;
  VK_F13            = $7C;
  VK_F14            = $7D;
  VK_F15            = $7E;
  VK_F16            = $7F;
  VK_F17            = $80;
  VK_F18            = $81;
  VK_F19            = $82;
  VK_F20            = $83;
  VK_F21            = $84;
  VK_F22            = $85;
  VK_F23            = $86;
  VK_F24            = $87;

  // $88 - $8F : unassigned

  VK_NUMLOCK        = $90;
  VK_SCROLL         = $91;

  // NEC PC-9800 kbd definitions
  VK_OEM_NEC_EQUAL  = $92;   // '=' key on numpad

  // Fujitsu/OASYS kbd definitions

  VK_OEM_FJ_JISHO   = $92;   // 'Dictionary' key
  VK_OEM_FJ_MASSHOU = $93;   // 'Unregister word' key
  VK_OEM_FJ_TOUROKU = $94;   // 'Register word' key
  VK_OEM_FJ_LOYA    = $95;   // 'Left OYAYUBI' key
  VK_OEM_FJ_ROYA    = $96;   // 'Right OYAYUBI' key

  // $97 - $9F : unassigned

(*
 * VK_L* & VK_R* - left and right Alt, Ctrl and Shift virtual keys.
 * Used only as parameters to GetAsyncKeyState() and GetKeyState().
 * No other API or message will distinguish left and right keys in this way.
*)

  VK_LSHIFT         = $A0;
  VK_RSHIFT         = $A1;
  VK_LCONTROL       = $A2;
  VK_RCONTROL       = $A3;
  VK_LMENU          = $A4;
  VK_RMENU          = $A5;

  VK_BROWSER_BACK        = $A6;
  VK_BROWSER_FORWARD     = $A7;
  VK_BROWSER_REFRESH     = $A8;
  VK_BROWSER_STOP        = $A9;
  VK_BROWSER_SEARCH      = $AA;
  VK_BROWSER_FAVORITES   = $AB;
  VK_BROWSER_HOME        = $AC;

  VK_VOLUME_MUTE         = $AD;
  VK_VOLUME_DOWN         = $AE;
  VK_VOLUME_UP           = $AF;
  VK_MEDIA_NEXT_TRACK    = $B0;
  VK_MEDIA_PREV_TRACK    = $B1;
  VK_MEDIA_STOP          = $B2;
  VK_MEDIA_PLAY_PAUSE    = $B3;
  VK_LAUNCH_MAIL         = $B4;
  VK_LAUNCH_MEDIA_SELECT = $B5;
  VK_LAUNCH_APP1         = $B6;
  VK_LAUNCH_APP2         = $B7;

 // $B8 - $B9 : reserved

  VK_OEM_1          = $BA;   // ';:' for US
  VK_OEM_PLUS       = $BB;   // '+' any country
  VK_OEM_COMMA      = $BC;   // ',' any country
  VK_OEM_MINUS      = $BD;   // '-' any country
  VK_OEM_PERIOD     = $BE;   // '.' any country
  VK_OEM_2          = $BF;   // '/?' for US
  VK_OEM_3          = $C0;   // '`~' for US

  // $C1 - $D7 : reserved
  // $D8 - $DA : unassigned

  VK_OEM_4          = $DB;  //  '[{' for US
  VK_OEM_5          = $DC;  //  '\|' for US
  VK_OEM_6          = $DD;  //  ']}' for US
  VK_OEM_7          = $DE;  //  ''"' for US
  VK_OEM_8          = $DF;

  // $E0 : reserved

  // Various extended or enhanced keyboards

  VK_OEM_AX         = $E1;  //  'AX' key on Japanese AX kbd
  VK_OEM_102        = $E2;  //  "<>" or "\|" on RT 102-key kbd.
  VK_ICO_HELP       = $E3;  //  Help key on ICO
  VK_ICO_00         = $E4;  //  00 key on ICO
  VK_PROCESSKEY     = $E5;
  VK_ICO_CLEAR      = $E6;
  VK_PACKET         = $E7;

  // $E8 : unassigned

  // Nokia/Ericsson definitions

  VK_OEM_RESET      = $E9;
  VK_OEM_JUMP       = $EA;
  VK_OEM_PA1        = $EB;
  VK_OEM_PA2        = $EC;
  VK_OEM_PA3        = $ED;
  VK_OEM_WSCTRL     = $EE;
  VK_OEM_CUSEL      = $EF;
  VK_OEM_ATTN       = $F0;
  VK_OEM_FINISH     = $F1;
  VK_OEM_COPY       = $F2;
  VK_OEM_AUTO       = $F3;
  VK_OEM_ENLW       = $F4;
  VK_OEM_BACKTAB    = $F5;

  VK_ATTN           = $F6;
  VK_CRSEL          = $F7;
  VK_EXSEL          = $F8;
  VK_EREOF          = $F9;
  VK_PLAY           = $FA;
  VK_ZOOM           = $FB;
  VK_NONAME         = $FC;
  VK_PA1            = $FD;
  VK_OEM_CLEAR      = $FE;

 // $FF : reserved

implementation

end.
