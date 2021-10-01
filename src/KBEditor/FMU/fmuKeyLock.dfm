object fmKeyLock: TfmKeyLock
  Left = 858
  Top = 664
  BorderStyle = bsDialog
  Caption = 'Keyboard keylock'
  ClientHeight = 262
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000BBBBBBBBBBBBB000BBBBBBBBBBBBB000BBBBBBBBBBBBB000FF
    FFFFFFFFFFF000FF4FF4F4FF4FF000FF4FF4F44F4FF000FF44F4F44F4FF00FFF
    FFFFFFFFFFF00FCCCCCCCCCCCCC00FCCCCCCCCCCCCC00FCCCCCCCCCCCCC00FFF
    FFFFF00000000FFFFFFFF000000004444444400000000000000000000000C000
    0000C0000000C0000000C0000000C0000000C0000000C0000000000000000000
    0000000000000000000000000000003F0000003F0000003F0000003F0000}
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 80
    Height = 13
    Caption = 'Keylock position:'
  end
  object lblCodes: TLabel
    Left = 120
    Top = 76
    Width = 57
    Height = 13
    Caption = 'Scancodes:'
  end
  object lblNotes: TLabel
    Left = 120
    Top = 116
    Width = 31
    Height = 13
    Caption = 'Notes:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 224
    Width = 401
    Height = 17
    Shape = bsTopLine
  end
  object lblKeyFunc: TLabel
    Left = 120
    Top = 28
    Width = 33
    Height = 13
    Caption = 'Action:'
  end
  object btnOK: TButton
    Left = 256
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 10
  end
  object btnCancel: TButton
    Left = 336
    Top = 232
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object lbPosition: TListBox
    Left = 8
    Top = 24
    Width = 105
    Height = 193
    ItemHeight = 13
    Items.Strings = (
      'Position 1'
      'Position 2'
      'Position 3')
    TabOrder = 0
    OnClick = lbPositionClick
  end
  object edtCodes: TEdit
    Left = 184
    Top = 72
    Width = 193
    Height = 21
    PopupMenu = pmPress
    TabOrder = 2
  end
  object btnCodes: TButton
    Left = 384
    Top = 72
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = btnCodesClick
  end
  object edtNotes: TEdit
    Left = 184
    Top = 112
    Width = 161
    Height = 21
    TabOrder = 4
  end
  object btnPlay: TBitBtn
    Left = 355
    Top = 112
    Width = 25
    Height = 25
    TabOrder = 5
    OnClick = btnPlayClick
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDD00DDD
      DDDDDDDDDD0307DDDDDDDDDDD030887DDDD7DDDD0377FF7DD77DDDD03B08FF7D
      7DDDD003BF08FF7DDDDD037BFB00FF7DDDDD3B8FBF070F7D77773B8BFB080F7D
      DDDD3F8FBF00FF7DDDDDD33BFB08FF7D7DDDDDD3BF08FF7DD77DDDDD3B778F7D
      DDD7DDDDD3B088DDDDDDDDDDDD3707DDDDDDDDDDDDD00DDDDDDD}
  end
  object btnNotes: TButton
    Left = 384
    Top = 112
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 6
    OnClick = btnNotesClick
  end
  object chbLockEnabled: TCheckBox
    Left = 160
    Top = 144
    Width = 217
    Height = 17
    Caption = 'Enable keyboard lock'
    TabOrder = 7
  end
  object cbPosType: TComboBox
    Left = 184
    Top = 24
    Width = 225
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbPosTypeChange
    Items.Strings = (
      'Macros'
      'Switch to layer 1'
      'Switch to layer 2'
      'Switch to layer 3'
      'Switch to layer 4')
  end
  object chbNCREmulation: TCheckBox
    Left = 160
    Top = 168
    Width = 209
    Height = 17
    Caption = 'Enable NCR keyboard emulation'
    TabOrder = 8
  end
  object chbNixdorfEmulation: TCheckBox
    Left = 160
    Top = 192
    Width = 249
    Height = 17
    Caption = 'Enable Wincor Nixdorf keylock emulation'
    TabOrder = 9
  end
  object pmPress: TPopupMenu
    Left = 80
    Top = 192
    object pmiCut: TMenuItem
      Bitmap.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888844888888888888848848844888888884884848848888888488484884
        8888888844484884888888888848444888888888884048888888888888808888
        8888888888000888888888888808088888888888800800888888888880888088
        8888888880888088888888888088808888888888888888888888}
      Caption = 'Cut'
      ImageIndex = 0
      ShortCut = 16472
      OnClick = pmiCutClick
    end
    object pmiCopy: TMenuItem
      Bitmap.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888888844444444488888884FFFFFFF488888884F0000
        0F480000004FFFFFFF480FFFFF4F00000F480F00004FFFFFFF480FFFFF4F00F4
        44480F00004FFFF4F4880FFFFF4FFFF448880F00F044444488880FFFF0F08888
        88880FFFF0088888888800000088888888888888888888888888}
      Caption = 'Copy'
      ImageIndex = 1
      ShortCut = 16451
      OnClick = pmiCopyClick
    end
    object pmiPaste: TMenuItem
      Bitmap.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        888888888844444444448000004FFFFFFFF40737374F444444F40373734FFFFF
        FFF40737374F444F44440373734FFFFF4F480737374FFFFF4488037373444444
        408807373737373730880370000000077088077088888807308803730B00B073
        7088800000BB0000088888888000088888888888888888888888}
      Caption = 'Paste'
      ImageIndex = 2
      ShortCut = 16470
      OnClick = pmiPasteClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object AllCodes: TMenuItem
      Caption = 'Add press ans release codes'
      OnClick = AllCodesClick
    end
    object PressCodes: TMenuItem
      Caption = 'Add press codes'
      OnClick = PressCodesClick
    end
    object ReleaseCodes: TMenuItem
      Caption = 'Add release codes'
      OnClick = ReleaseCodesClick
    end
  end
end
