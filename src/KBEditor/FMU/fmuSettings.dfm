object fmSettings: TfmSettings
  Left = 761
  Top = 600
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 326
  ClientWidth = 511
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    511
    326)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 352
    Top = 296
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 432
    Top = 296
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 497
    Height = 281
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Bevel1: TBevel
        Left = 8
        Top = 144
        Width = 281
        Height = 81
        Shape = bsFrame
      end
      object lblModel: TLabel
        Left = 8
        Top = 20
        Width = 128
        Height = 13
        Caption = 'Keyboard model by default:'
      end
      object lblPortType: TLabel
        Left = 16
        Top = 160
        Width = 32
        Height = 13
        Caption = 'Model:'
      end
      object cbKeyboard: TComboBox
        Left = 8
        Top = 40
        Width = 281
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object chbSave: TCheckBox
        Left = 8
        Top = 96
        Width = 281
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Save layout before loading to device'
        TabOrder = 1
      end
      object chbUpdate: TCheckBox
        Left = 8
        Top = 120
        Width = 281
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Check update on startup'
        TabOrder = 2
      end
      object cbDevices: TComboBox
        Left = 16
        Top = 185
        Width = 233
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
      end
      object btnRefresh: TBitBtn
        Left = 256
        Top = 182
        Width = 25
        Height = 26
        Hint = 'Update device list'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = btnRefreshClick
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          0800000000000001000000000000000000000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A6000020400000206000002080000020A0000020C0000020E000004000000040
          20000040400000406000004080000040A0000040C0000040E000006000000060
          20000060400000606000006080000060A0000060C0000060E000008000000080
          20000080400000806000008080000080A0000080C0000080E00000A0000000A0
          200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
          200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
          200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
          20004000400040006000400080004000A0004000C0004000E000402000004020
          20004020400040206000402080004020A0004020C0004020E000404000004040
          20004040400040406000404080004040A0004040C0004040E000406000004060
          20004060400040606000406080004060A0004060C0004060E000408000004080
          20004080400040806000408080004080A0004080C0004080E00040A0000040A0
          200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
          200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
          200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
          20008000400080006000800080008000A0008000C0008000E000802000008020
          20008020400080206000802080008020A0008020C0008020E000804000008040
          20008040400080406000804080008040A0008040C0008040E000806000008060
          20008060400080606000806080008060A0008060C0008060E000808000008080
          20008080400080806000808080008080A0008080C0008080E00080A0000080A0
          200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
          200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
          200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
          2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
          2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
          2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
          2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
          2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
          2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
          2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FD0000000000
          0000000000000000F7F7FD00FFFFFFFFFFFFFFFFFFFFFF00F7F7FD00FFFFFFFF
          FF02FFFFFFFFFF00F7F7FD00FFFFFFFF0202FFFFFFFFFF00F7F7FD00FFFFFF02
          02020202FFFFFF00F7F7FD00FFFFFFFF0202FFFF02FFFF00F7F7FD00FFFFFFFF
          FF02FFFF02FFFF00F7F7FD00FFFF02FFFFFFFFFF02FFFF00F7F7FD00FFFF02FF
          FF02FFFFFFFFFF00F7F7FD00FFFF02FFFF0202FFFFFFFF00F7F7FD00FFFFFF02
          02020202FFFFFF00F7F7FD00FFFFFFFFFF0202FFFFFFFF00F7FDFD00FFFFFFFF
          FF02FFFF00000000FDFDFD00FFFFFFFFFFFFFFFF00FF00FDFDFDFD00FFFFFFFF
          FFFFFFFF0000FDFDFDFDFD00000000000000000000FDFDFDFDFD}
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Font'
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 76
        Height = 13
        Caption = 'Application font:'
      end
      object Label2: TLabel
        Left = 8
        Top = 64
        Width = 26
        Height = 13
        Caption = 'View:'
      end
      object btnFont: TButton
        Left = 280
        Top = 32
        Width = 25
        Height = 25
        Caption = '...'
        TabOrder = 1
        OnClick = btnFontClick
      end
      object pnlPreview: TPanel
        Left = 8
        Top = 80
        Width = 297
        Height = 97
        BevelOuter = bvLowered
        Caption = 'AaBbYyZz'
        TabOrder = 2
      end
      object edtFont: TEdit
        Left = 8
        Top = 34
        Width = 257
        Height = 21
        AutoSize = False
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
    end
    object tsLog: TTabSheet
      Caption = 'Log file'
      ImageIndex = 2
      DesignSize = (
        489
        253)
      object lblFileName: TLabel
        Left = 24
        Top = 56
        Width = 48
        Height = 13
        Caption = 'File name:'
      end
      object chbLogEnabled: TCheckBox
        Left = 8
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Log enabled'
        TabOrder = 0
      end
      object edtLogFileName: TEdit
        Left = 96
        Top = 56
        Width = 353
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object btnFileName: TButton
        Left = 456
        Top = 56
        Width = 25
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 2
        OnClick = btnFileNameClick
      end
      object btnDefaults: TButton
        Left = 392
        Top = 216
        Width = 91
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Deaults'
        TabOrder = 3
        OnClick = btnDefaultsClick
      end
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 8
    Top = 296
  end
  object OpenDialog: TOpenDialog
    Filter = 'Log files (*.log)|*.log|All files (*.*)|*.*'
    Left = 40
    Top = 296
  end
end
