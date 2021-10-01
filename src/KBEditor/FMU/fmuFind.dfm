object fmFind: TfmFind
  Left = 899
  Top = 848
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Find'
  ClientHeight = 78
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 23
    Height = 13
    Caption = 'Find:'
  end
  object btnFind: TButton
    Left = 232
    Top = 48
    Width = 65
    Height = 25
    Caption = 'Find'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnFindClick
  end
  object btnCancel: TButton
    Left = 304
    Top = 48
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object cbFind: TComboBox
    Left = 72
    Top = 12
    Width = 297
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnKeyDown = cbFindKeyDown
  end
end
