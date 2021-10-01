object fmModel: TfmModel
  Left = 840
  Top = 517
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1084#1086#1076#1077#1083#1080' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099
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
  object lblModel: TLabel
    Left = 8
    Top = 8
    Width = 49
    Height = 13
    AutoSize = False
    Caption = #1052#1086#1076#1077#1083#1100':'
  end
  object ListBox: TListBox
    Left = 8
    Top = 24
    Width = 417
    Height = 145
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 18
    TabOrder = 0
  end
  object chbShowAllModels: TCheckBox
    Left = 8
    Top = 176
    Width = 225
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1084#1086#1076#1077#1083#1080
    TabOrder = 1
    OnClick = chbShowAllModelsClick
  end
  object JvFormStorage1: TJvFormStorage
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'chbShowAllModels.Checked')
    StoredValues = <>
    Left = 248
    Top = 176
  end
end
