object fmMain: TfmMain
  Left = 463
  Top = 317
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1058#1077#1089#1090' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099
  ClientHeight = 405
  ClientWidth = 494
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    494
    405)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel: TBevel
    Left = 8
    Top = 355
    Width = 481
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object Bevel1: TBevel
    Left = 0
    Top = 65
    Width = 494
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object btnClose: TButton
    Left = 408
    Top = 365
    Width = 82
    Height = 29
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnNext: TButton
    Left = 304
    Top = 365
    Width = 82
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = #1044#1072#1083#1077#1077' >'
    Default = True
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnPrev: TButton
    Left = 216
    Top = 365
    Width = 82
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = '< '#1053#1072#1079#1072#1076
    Enabled = False
    TabOrder = 1
    OnClick = btnPrevClick
  end
  object pnlPage: TPanel
    Left = 0
    Top = 67
    Width = 494
    Height = 284
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 494
    Height = 65
    Align = alTop
    BevelOuter = bvLowered
    Color = clWindow
    TabOrder = 4
    DesignSize = (
      494
      65)
    object lblPage: TLabel
      Left = 16
      Top = 8
      Width = 478
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = #1054#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1084#1086#1076#1077#1083#1080' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAction: TLabel
      Left = 16
      Top = 32
      Width = 295
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1084#1086#1076#1077#1083#1100' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099' '#1080' '#1085#1072#1078#1084#1080#1090#1077' '#1082#1085#1086#1087#1082#1091' "'#1044#1072#1083#1077#1077'"'
    end
  end
end
