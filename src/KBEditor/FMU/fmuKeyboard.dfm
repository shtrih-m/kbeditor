object fmKeyboard: TfmKeyboard
  Left = 889
  Top = 632
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Keyboard model'
  ClientHeight = 294
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblModel: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Model:'
  end
  object btnOK: TButton
    Left = 304
    Top = 24
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 304
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ListBox: TListBox
    Left = 8
    Top = 24
    Width = 289
    Height = 265
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = ListBoxDblClick
  end
end
