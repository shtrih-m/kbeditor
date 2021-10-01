object fmReplace: TfmReplace
  Left = 880
  Top = 809
  BorderStyle = bsDialog
  Caption = 'Find and replace'
  ClientHeight = 117
  ClientWidth = 392
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
    Top = 20
    Width = 23
    Height = 13
    Caption = 'Find:'
  end
  object Label2: TLabel
    Left = 8
    Top = 60
    Width = 55
    Height = 13
    Caption = 'Replace to:'
  end
  object cmbFindText: TComboBox
    Left = 88
    Top = 16
    Width = 297
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnKeyDown = DoReplace
  end
  object cmbReplaceText: TComboBox
    Left = 88
    Top = 56
    Width = 297
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnKeyDown = DoReplace
  end
  object btnCancel: TButton
    Left = 312
    Top = 88
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnReplace: TButton
    Left = 216
    Top = 88
    Width = 83
    Height = 25
    Caption = 'Replace all'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnReplaceClick
  end
end
