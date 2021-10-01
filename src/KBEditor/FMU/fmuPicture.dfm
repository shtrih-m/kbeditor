object fmPicture: TfmPicture
  Left = 571
  Top = 590
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Picture'
  ClientHeight = 336
  ClientWidth = 335
  Color = clBtnFace
  UseDockManager = True
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object gbPicture: TGroupBox
    Left = 8
    Top = 8
    Width = 321
    Height = 169
    Caption = 'Picture'
    TabOrder = 0
    object KeyText: TPanel
      Left = 8
      Top = 24
      Width = 121
      Height = 129
      BevelOuter = bvLowered
      TabOrder = 0
      object imPreview: TImage
        Left = 1
        Top = 1
        Width = 119
        Height = 127
        Align = alClient
        Center = True
        Transparent = True
      end
    end
    object btnOpen: TButton
      Left = 232
      Top = 24
      Width = 81
      Height = 25
      Caption = 'Load...'
      TabOrder = 1
      OnClick = btnOpenClick
    end
    object btnSave: TButton
      Left = 232
      Top = 56
      Width = 81
      Height = 25
      Caption = 'Save...'
      TabOrder = 2
      OnClick = btnSaveClick
    end
    object btnClear: TButton
      Left = 232
      Top = 88
      Width = 81
      Height = 25
      Caption = 'Clear'
      TabOrder = 3
      OnClick = btnClearClick
    end
  end
  object gbText: TGroupBox
    Left = 8
    Top = 184
    Width = 321
    Height = 145
    Caption = 'Text'
    TabOrder = 1
    object Label2: TLabel
      Left = 24
      Top = 32
      Width = 24
      Height = 13
      Caption = 'Text:'
    end
    object edtText: TEdit
      Left = 64
      Top = 28
      Width = 249
      Height = 21
      TabOrder = 0
      OnChange = edtTextChange
    end
    object btnFont: TBitBtn
      Left = 232
      Top = 104
      Width = 83
      Height = 25
      Caption = 'Font...'
      TabOrder = 3
      OnClick = btnFontClick
    end
    object GroupBox1: TGroupBox
      Left = 64
      Top = 56
      Width = 161
      Height = 73
      Caption = 'Text orientation'
      TabOrder = 1
      object rbnHorizontal: TRadioButton
        Left = 16
        Top = 24
        Width = 113
        Height = 17
        Caption = 'Horizontal'
        TabOrder = 0
        OnClick = rbnHorizontalClick
      end
      object rbnVertical: TRadioButton
        Left = 16
        Top = 48
        Width = 113
        Height = 17
        Caption = 'Vertical'
        TabOrder = 1
        OnClick = rbnVerticalClick
      end
    end
    object btnColor: TButton
      Left = 232
      Top = 72
      Width = 83
      Height = 25
      Caption = 'Background...'
      TabOrder = 2
      OnClick = btnColorClick
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp|JPEG images|*.jpg'
    Left = 112
    Top = 288
  end
  object FontDialog: TFontDialog
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 80
    Top = 288
  end
  object ColorDialog: TColorDialog
    Left = 48
    Top = 288
  end
  object SaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 16
    Top = 288
  end
end
