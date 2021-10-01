object fmDevices: TfmDevices
  Left = 402
  Top = 639
  BorderStyle = bsDialog
  Caption = 'Device list'
  ClientHeight = 287
  ClientWidth = 432
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
  object Bevel1: TBevel
    Left = 8
    Top = 248
    Width = 417
    Height = 17
    Shape = bsTopLine
  end
  object btnOK: TButton
    Left = 352
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object ListBox: TListBox
    Left = 8
    Top = 8
    Width = 145
    Height = 225
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBoxClick
  end
  object Memo: TMemo
    Left = 160
    Top = 8
    Width = 265
    Height = 225
    Color = clMenu
    Lines.Strings = (
      'Memo')
    ReadOnly = True
    TabOrder = 2
  end
end
