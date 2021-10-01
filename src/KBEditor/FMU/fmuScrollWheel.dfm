object fmScrollWheel: TfmScrollWheel
  Left = 849
  Top = 355
  BorderStyle = bsDialog
  Caption = 'Scroll wheel'
  ClientHeight = 368
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 264
    Top = 336
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 344
    Top = 336
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object psScroll: TPageControl
    Left = 8
    Top = 8
    Width = 409
    Height = 321
    ActivePage = tsScroll
    TabOrder = 0
    object tsScroll: TTabSheet
      Caption = 'Scrolling'
      object gbScrollUp: TGroupBox
        Left = 8
        Top = 16
        Width = 385
        Height = 113
        Caption = 'Scroll up'
        TabOrder = 0
        object lblNotes1: TLabel
          Left = 8
          Top = 76
          Width = 34
          Height = 13
          Caption = 'Sound:'
        end
        object lblCodes1: TLabel
          Left = 8
          Top = 44
          Width = 57
          Height = 13
          Caption = 'Scancodes:'
        end
        object edtNotes1: TEdit
          Left = 48
          Top = 71
          Width = 257
          Height = 21
          TabOrder = 2
        end
        object edtCodes1: TEdit
          Left = 48
          Top = 40
          Width = 289
          Height = 21
          PopupMenu = pmCodes
          TabOrder = 0
        end
        object btnCodes1: TButton
          Left = 344
          Top = 40
          Width = 25
          Height = 25
          Hint = 'Select scancodes'
          Caption = '...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnCodes1Click
        end
        object btnNotes1: TButton
          Left = 344
          Top = 72
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 4
          OnClick = btnNotes1Click
        end
        object btnPlayNotes1: TBitBtn
          Left = 312
          Top = 72
          Width = 25
          Height = 25
          TabOrder = 3
          OnClick = btnPlayNotes1Click
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
      end
      object gbScrollDown: TGroupBox
        Left = 8
        Top = 144
        Width = 385
        Height = 113
        Caption = 'Scroll down'
        TabOrder = 1
        object lblCodes2: TLabel
          Left = 8
          Top = 44
          Width = 57
          Height = 13
          Caption = 'Scancodes:'
        end
        object lblNotes2: TLabel
          Left = 8
          Top = 76
          Width = 34
          Height = 13
          Caption = 'Sound:'
        end
        object edtCodes2: TEdit
          Left = 48
          Top = 40
          Width = 289
          Height = 21
          PopupMenu = pmCodes
          TabOrder = 0
        end
        object edtNotes2: TEdit
          Left = 48
          Top = 71
          Width = 257
          Height = 21
          TabOrder = 2
        end
        object btnPlayNotes2: TBitBtn
          Left = 312
          Top = 72
          Width = 25
          Height = 25
          TabOrder = 3
          OnClick = btnPlayNotes2Click
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
        object btnNotes2: TButton
          Left = 344
          Top = 72
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 4
          OnClick = btnNotes2Click
        end
        object btnCodes2: TButton
          Left = 344
          Top = 40
          Width = 25
          Height = 25
          Hint = 'Select scancodes'
          Caption = '...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnCodes2Click
        end
      end
    end
    object tsClick: TTabSheet
      Caption = 'Wheel click'
      ImageIndex = 2
      object gbSingleClick: TGroupBox
        Left = 8
        Top = 16
        Width = 385
        Height = 113
        Caption = 'Single click'
        TabOrder = 0
        object lblNotes3: TLabel
          Left = 8
          Top = 76
          Width = 34
          Height = 13
          Caption = 'Sound:'
        end
        object lblCodes3: TLabel
          Left = 8
          Top = 44
          Width = 57
          Height = 13
          Caption = 'Scancodes:'
        end
        object edtCodes3: TEdit
          Left = 48
          Top = 40
          Width = 289
          Height = 21
          PopupMenu = pmCodes
          TabOrder = 0
        end
        object edtNotes3: TEdit
          Left = 48
          Top = 71
          Width = 257
          Height = 21
          TabOrder = 2
        end
        object btnPlayNotes3: TBitBtn
          Left = 312
          Top = 72
          Width = 25
          Height = 25
          TabOrder = 3
          OnClick = btnPlayNotes3Click
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
        object btnNotes3: TButton
          Left = 344
          Top = 72
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 4
          OnClick = btnNotes3Click
        end
        object btnCodes3: TButton
          Left = 344
          Top = 40
          Width = 25
          Height = 25
          Hint = 'Select scancodes'
          Caption = '...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnCodes3Click
        end
      end
      object gbDoubleClick: TGroupBox
        Left = 8
        Top = 144
        Width = 385
        Height = 113
        Caption = 'Double click'
        TabOrder = 1
        object lblCodes4: TLabel
          Left = 8
          Top = 44
          Width = 57
          Height = 13
          Caption = 'Scancodes:'
        end
        object lblNotes4: TLabel
          Left = 8
          Top = 76
          Width = 34
          Height = 13
          Caption = 'Sound:'
        end
        object edtCodes4: TEdit
          Left = 48
          Top = 40
          Width = 289
          Height = 21
          PopupMenu = pmCodes
          TabOrder = 0
        end
        object edtNotes4: TEdit
          Left = 48
          Top = 71
          Width = 257
          Height = 21
          TabOrder = 2
        end
        object btnPlayNotes4: TBitBtn
          Left = 312
          Top = 72
          Width = 25
          Height = 25
          TabOrder = 3
          OnClick = btnPlayNotes4Click
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
        object btnNotes4: TButton
          Left = 344
          Top = 72
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 4
          OnClick = btnNotes4Click
        end
        object btnCodes4: TButton
          Left = 344
          Top = 40
          Width = 25
          Height = 25
          Hint = 'Select scancodes'
          Caption = '...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnCodes4Click
        end
      end
    end
  end
  object pmCodes: TPopupMenu
    Left = 8
    Top = 336
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
