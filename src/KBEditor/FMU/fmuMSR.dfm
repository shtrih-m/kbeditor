object fmMSR: TfmMSR
  Left = 880
  Top = 520
  BorderStyle = bsDialog
  Caption = 'Magnetic stripe reader'
  ClientHeight = 406
  ClientWidth = 390
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
    000000000000000000000000000000000000000000000BBBBBBBBBBBBBB00BBB
    BBBBBBBBBBB00BBBBBBBBBBBBBB00FFFFFFFFFFFFFF00FF4FF4F4FF4FFF00FF4
    FF4F44F4FFF00FF44F4F44F4FFF00FFFFFFFFFFFFFF00CCCCCCCCCCCCCC00CCC
    CCCCCCCCCCC00CCCCCCCCCCCCCC000000000000000000000000000000000FFFF
    0000FFFF00000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000FFFF0000}
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 8
    Top = 368
    Width = 385
    Height = 17
    Shape = bsTopLine
  end
  object lblNotes: TLabel
    Left = 8
    Top = 336
    Width = 31
    Height = 13
    Caption = 'Notes:'
  end
  object gbTrack3: TGroupBox
    Left = 8
    Top = 248
    Width = 377
    Height = 81
    Caption = 'Track 3'
    TabOrder = 8
    object Label1: TLabel
      Left = 8
      Top = 28
      Width = 29
      Height = 13
      Caption = 'Prefix:'
    end
    object Label4: TLabel
      Left = 8
      Top = 52
      Width = 29
      Height = 13
      Caption = 'Suffix:'
    end
    object edtSuffix3: TEdit
      Tag = 5
      Left = 64
      Top = 48
      Width = 273
      Height = 21
      PopupMenu = pmCodes
      TabOrder = 2
    end
    object btnSuffix3: TButton
      Left = 344
      Top = 48
      Width = 23
      Height = 23
      Caption = '...'
      TabOrder = 3
      OnClick = btnSuffix3Click
    end
    object edtPrefix3: TEdit
      Tag = 2
      Left = 64
      Top = 24
      Width = 273
      Height = 21
      PopupMenu = pmCodes
      TabOrder = 0
    end
    object btnPrefix3: TButton
      Left = 344
      Top = 24
      Width = 23
      Height = 23
      Caption = '...'
      TabOrder = 1
      OnClick = btnPrefix3Click
    end
  end
  object gbTrack2: TGroupBox
    Left = 8
    Top = 168
    Width = 377
    Height = 73
    Caption = 'Track 2'
    TabOrder = 7
    object Label7: TLabel
      Left = 8
      Top = 20
      Width = 29
      Height = 13
      Caption = 'Prefix:'
    end
    object Label8: TLabel
      Left = 8
      Top = 44
      Width = 29
      Height = 13
      Caption = 'Suffix:'
    end
    object edtPrefix2: TEdit
      Tag = 1
      Left = 64
      Top = 16
      Width = 273
      Height = 21
      PopupMenu = pmCodes
      TabOrder = 0
    end
    object btnPrefix2: TButton
      Left = 344
      Top = 16
      Width = 23
      Height = 23
      Caption = '...'
      TabOrder = 1
      OnClick = btnPrefix2Click
    end
    object edtSuffix2: TEdit
      Tag = 4
      Left = 64
      Top = 40
      Width = 273
      Height = 21
      PopupMenu = pmCodes
      TabOrder = 2
    end
    object btnSuffix2: TButton
      Left = 344
      Top = 40
      Width = 23
      Height = 23
      Caption = '...'
      TabOrder = 3
      OnClick = btnSuffix2Click
    end
  end
  object gbTrack1: TGroupBox
    Left = 8
    Top = 80
    Width = 377
    Height = 81
    Caption = 'Track 1'
    TabOrder = 6
    object lblPrefix1: TLabel
      Left = 8
      Top = 28
      Width = 29
      Height = 13
      Caption = 'Prefix:'
    end
    object lblSuffix1: TLabel
      Left = 8
      Top = 52
      Width = 29
      Height = 13
      Caption = 'Suffix:'
    end
    object edtPrefix1: TEdit
      Left = 64
      Top = 24
      Width = 273
      Height = 21
      PopupMenu = pmCodes
      TabOrder = 0
    end
    object btnPrefix1: TButton
      Left = 344
      Top = 24
      Width = 23
      Height = 23
      Caption = '...'
      TabOrder = 1
      OnClick = btnPrefix1Click
    end
    object edtSuffix1: TEdit
      Tag = 3
      Left = 64
      Top = 48
      Width = 273
      Height = 21
      PopupMenu = pmCodes
      TabOrder = 2
    end
    object btnSuffix1: TButton
      Left = 344
      Top = 48
      Width = 23
      Height = 23
      Caption = '...'
      TabOrder = 3
      OnClick = btnSuffix1Click
    end
  end
  object btnOK: TButton
    Left = 232
    Top = 376
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 12
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 312
    Top = 376
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 13
  end
  object chbTrack1: TCheckBox
    Left = 16
    Top = 8
    Width = 57
    Height = 17
    Caption = 'Track 1'
    TabOrder = 0
  end
  object chbTrack2: TCheckBox
    Left = 16
    Top = 32
    Width = 57
    Height = 17
    Caption = 'Track 2'
    TabOrder = 1
  end
  object chbTrack3: TCheckBox
    Left = 16
    Top = 56
    Width = 57
    Height = 17
    Caption = 'Track 3'
    TabOrder = 2
  end
  object chbLockOnErr: TCheckBox
    Left = 136
    Top = 8
    Width = 153
    Height = 17
    Caption = 'Stop on error'
    TabOrder = 3
  end
  object chbSendEnter: TCheckBox
    Left = 136
    Top = 32
    Width = 201
    Height = 17
    Caption = 'Send ENTER after data'
    TabOrder = 4
  end
  object chbLightIndication: TCheckBox
    Left = 136
    Top = 56
    Width = 249
    Height = 17
    Caption = 'Flash leds on successful read'
    TabOrder = 5
  end
  object edtNotes: TEdit
    Left = 72
    Top = 336
    Width = 257
    Height = 21
    TabOrder = 9
  end
  object btnPlay: TBitBtn
    Left = 363
    Top = 336
    Width = 25
    Height = 25
    TabOrder = 11
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
    Left = 336
    Top = 336
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 10
    OnClick = btnNotesClick
  end
  object pmCodes: TPopupMenu
    Left = 8
    Top = 376
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
      OnClick = mpiPast1Click
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object pmiAllCodes: TMenuItem
      Caption = 'Select scancodes'
      OnClick = pmiAllCodesClick
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
