object fmCodes: TfmCodes
  Left = 627
  Top = 594
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Scancodes'
  ClientHeight = 332
  ClientWidth = 327
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
    Top = 296
    Width = 313
    Height = 17
    Shape = bsTopLine
  end
  object lblInfo: TLabel
    Left = 8
    Top = 232
    Width = 184
    Height = 13
    Caption = 'To add "TAB" key use "Select" button'
  end
  object LabelHint: TLabel
    Left = 8
    Top = 248
    Width = 256
    Height = 13
    Caption = '"+" press key scancodes, "-" - release key scancodes'
  end
  object btnOK: TButton
    Left = 168
    Top = 304
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 248
    Top = 304
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object btnSelect: TButton
    Left = 248
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Select...'
    TabOrder = 2
    OnClick = btnSelectClick
  end
  object btnClear: TButton
    Left = 248
    Top = 8
    Width = 73
    Height = 25
    Caption = 'Clear'
    TabOrder = 1
    OnClick = btnClearClick
  end
  object btnSet: TButton
    Left = 248
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Add...'
    TabOrder = 3
    OnClick = btnSetClick
  end
  object Memo: TMemo
    Left = 8
    Top = 8
    Width = 233
    Height = 217
    TabOrder = 0
    OnEnter = MemoEnter
    OnExit = MemoExit
    OnKeyDown = MemoKeyDown
    OnKeyPress = MemoKeyPress
  end
end
