object fmMain: TfmMain
  Left = 545
  Top = 257
  Width = 384
  Height = 176
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'DPInst.exe test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 104
    Width = 362
    Height = 25
    Shape = bsTopLine
  end
  object btnInstallDriver: TButton
    Left = 272
    Top = 16
    Width = 99
    Height = 25
    Caption = 'Install driver'
    TabOrder = 0
    OnClick = btnInstallDriverClick
  end
  object btnUninstallDriver: TButton
    Left = 272
    Top = 48
    Width = 99
    Height = 25
    Caption = 'Uninstall driver'
    TabOrder = 1
    OnClick = btnUninstallDriverClick
  end
  object btnClose: TButton
    Left = 272
    Top = 112
    Width = 97
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
end
