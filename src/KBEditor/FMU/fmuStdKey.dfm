object fmStdKey: TfmStdKey
  Left = 930
  Top = 543
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Key editor'
  ClientHeight = 220
  ClientWidth = 342
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
  object lblKeySet: TLabel
    Left = 8
    Top = 4
    Width = 42
    Height = 13
    Caption = 'Codeset:'
  end
  object lblKey: TLabel
    Left = 168
    Top = 4
    Width = 21
    Height = 13
    Caption = 'Key:'
  end
  object Bevel: TBevel
    Left = 8
    Top = 184
    Width = 329
    Height = 9
    Shape = bsTopLine
  end
  object lbKey: TListBox
    Left = 8
    Top = 23
    Width = 153
    Height = 154
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbKeyClick
  end
  object lbScanCode: TListBox
    Left = 168
    Top = 23
    Width = 169
    Height = 154
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = OKClick
  end
  object btnOK: TButton
    Left = 184
    Top = 192
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = OKClick
  end
  object btnCancel: TButton
    Left = 264
    Top = 192
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
