object fmCstKey: TfmCstKey
  Left = 968
  Top = 766
  BorderStyle = bsDialog
  Caption = 'New key'
  ClientHeight = 96
  ClientWidth = 304
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
  object lblCode: TLabel
    Left = 8
    Top = 20
    Width = 75
    Height = 13
    Caption = 'Scancode, hex:'
  end
  object Bevel: TBevel
    Left = 8
    Top = 56
    Width = 289
    Height = 17
    Shape = bsTopLine
  end
  object edtCode: TEdit
    Left = 112
    Top = 16
    Width = 185
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object btnOK: TButton
    Left = 144
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 224
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
