object fmDevice: TfmDevice
  Left = 840
  Top = 720
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1090#1080#1087#1072' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099
  ClientHeight = 206
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    432
    206)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 70
    Height = 13
    AutoSize = False
    Caption = #1059#1089#1090#1088#1086#1081#1089#1090#1074#1086':'
  end
  object lbDevice: TListBox
    Left = 8
    Top = 24
    Width = 417
    Height = 137
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 20
    TabOrder = 0
  end
  object btnUpdate: TButton
    Left = 328
    Top = 168
    Width = 97
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 1
    OnClick = btnUpdateClick
  end
end
