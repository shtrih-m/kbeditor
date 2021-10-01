object fmKeyDlg: TfmKeyDlg
  Left = 840
  Top = 485
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Key'
  ClientHeight = 248
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object lblKeyFunc: TLabel
    Left = 8
    Top = 12
    Width = 53
    Height = 13
    Caption = 'Key action:'
  end
  object lblPress: TLabel
    Left = 8
    Top = 68
    Width = 77
    Height = 13
    Caption = 'On key pressed:'
  end
  object lblRelease: TLabel
    Left = 8
    Top = 100
    Width = 80
    Height = 13
    Caption = 'On key released:'
  end
  object lblSound: TLabel
    Left = 8
    Top = 188
    Width = 34
    Height = 13
    Caption = 'Sound:'
  end
  object lblText: TLabel
    Left = 8
    Top = 220
    Width = 26
    Height = 13
    Caption = 'Note:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 40
    Width = 417
    Height = 17
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 7
    Top = 168
    Width = 417
    Height = 17
    Shape = bsTopLine
  end
  object cbKeyType: TComboBox
    Left = 96
    Top = 8
    Width = 329
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbKeyTypeChange
    Items.Strings = (
      'Macro'
      'Switch to next layer'
      'Switch to previous layer'
      'Switch to layer 1'
      'Switch to layer 2'
      'Switch to layer 3'
      'Switch to layer 4'
      'Switch to layer 1 temporary'
      'Switch to layer 2 temporary'
      'Switch to layer 3 temporary'
      'Switch to layer 4 temporary')
  end
  object edtPress: TEdit
    Left = 96
    Top = 64
    Width = 297
    Height = 21
    PopupMenu = pmCodes
    TabOrder = 1
    OnExit = edtPressExit
    OnKeyDown = edtPressKeyDown
  end
  object btnPress: TButton
    Left = 400
    Top = 64
    Width = 25
    Height = 25
    Hint = 'Select scancodes for this field'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnPressClick
  end
  object btnRelease: TButton
    Left = 400
    Top = 96
    Width = 25
    Height = 25
    Hint = 'Select scancodes for this field'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btnReleaseClick
  end
  object edtRelease: TEdit
    Left = 96
    Top = 96
    Width = 297
    Height = 21
    PopupMenu = pmCodes
    TabOrder = 3
    OnExit = edtReleaseExit
    OnKeyDown = edtReleaseKeyDown
  end
  object chbRepeatKey: TCheckBox
    Left = 8
    Top = 128
    Width = 145
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Enable key repeat'
    TabOrder = 5
    OnClick = chbRepeatKeyClick
  end
  object edtNotes: TEdit
    Left = 80
    Top = 184
    Width = 281
    Height = 21
    ReadOnly = True
    TabOrder = 6
    OnChange = edtNotesChange
  end
  object btnPlay: TBitBtn
    Left = 371
    Top = 184
    Width = 25
    Height = 25
    TabOrder = 7
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
  object btnSound: TButton
    Left = 400
    Top = 184
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 8
    OnClick = btnSoundClick
  end
  object edtText: TEdit
    Left = 80
    Top = 216
    Width = 345
    Height = 21
    TabOrder = 9
    OnChange = edtTextChange
  end
  object pmCodes: TPopupMenu
    Left = 200
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
      OnClick = pmiCutClick1
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
      OnClick = pmiCopyClick1
    end
    object mpiPast1: TMenuItem
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
      OnClick = pmiPasteClick1
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object pmiAllCodes1: TMenuItem
      Caption = 'Select scancodes'
      OnClick = pmiAllCodesClick1
    end
    object pmiPressCodes: TMenuItem
      Caption = 'Select press codes'
      OnClick = pmiPressCodesClick
    end
    object pmiReleaseCodes: TMenuItem
      Caption = 'Select release codes'
      OnClick = pmiReleaseCodesClick
    end
  end
end
