object fmIButtonKey: TfmIButtonKey
  Left = 841
  Top = 703
  BorderStyle = bsDialog
  Caption = 'IButton key'
  ClientHeight = 223
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 184
    Width = 417
    Height = 17
    Shape = bsTopLine
  end
  object lblCodes: TLabel
    Left = 8
    Top = 40
    Width = 57
    Height = 13
    Caption = 'Scancodes:'
  end
  object lblNotes: TLabel
    Left = 8
    Top = 72
    Width = 31
    Height = 13
    Caption = 'Notes:'
  end
  object lblCode: TLabel
    Left = 8
    Top = 8
    Width = 35
    Height = 13
    Caption = 'Key ID:'
  end
  object lblAction: TLabel
    Left = 8
    Top = 104
    Width = 33
    Height = 13
    Caption = 'Action:'
  end
  object btnOK: TButton
    Left = 272
    Top = 192
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 7
  end
  object btnCancel: TButton
    Left = 352
    Top = 192
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object btnCodes: TButton
    Left = 400
    Top = 40
    Width = 25
    Height = 25
    Hint = 'Select scancodes for this field'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnCodesClick
  end
  object edtCodes: TEdit
    Left = 72
    Top = 40
    Width = 321
    Height = 21
    PopupMenu = pmCodes
    TabOrder = 1
  end
  object edtNotes: TEdit
    Left = 72
    Top = 72
    Width = 289
    Height = 21
    TabOrder = 3
  end
  object btnPlayNotes: TBitBtn
    Left = 368
    Top = 72
    Width = 25
    Height = 25
    TabOrder = 4
    OnClick = btnPlayNotesClick
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
    Left = 400
    Top = 72
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 5
    OnClick = btnNotesClick
  end
  object edtCode: TEdit
    Left = 72
    Top = 8
    Width = 353
    Height = 21
    TabOrder = 0
  end
  object cbCodeType: TComboBox
    Left = 72
    Top = 104
    Width = 289
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object pmCodes: TPopupMenu
    Left = 32
    Top = 136
    object pmiCut1: TMenuItem
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
      OnClick = pmiCut1Click
    end
    object pmiCopy1: TMenuItem
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
      OnClick = pmiCopy1Click
    end
    object pmiPast1: TMenuItem
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
      OnClick = pmiPast1Click
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object pmiAllCodes1: TMenuItem
      Caption = 'Add press and release scancodes'
      OnClick = pmiAllCodes1Click
    end
    object pmiPressCodes1: TMenuItem
      Caption = 'Add press scancodes'
      OnClick = pmiPressCodes1Click
    end
    object pmiReleaseCodes1: TMenuItem
      Caption = 'Add release scancodes'
      OnClick = pmiReleaseCodes1Click
    end
  end
end
