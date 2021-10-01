object fmKeysTest: TfmKeysTest
  Left = 832
  Top = 722
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1085#1072#1078#1072#1090#1099#1093' '#1082#1085#1086#1087#1086#1082
  ClientHeight = 204
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    440
    204)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 425
    Height = 73
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      #1053#1072#1078#1084#1080#1090#1077' '#1074#1089#1077' '#1082#1085#1086#1087#1082#1080' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099'.'#13#10#1050#1085#1086#1087#1082#1080' '#1084#1086#1078#1085#1086' '#1085#1072#1078#1080#1084#1072#1090#1100' '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090 +
      #1077#1083#1100#1085#1086' '#1080#1083#1080' '#1074#1089#1077' '#1086#1076#1085#1086#1074#1088#1077#1084#1077#1085#1085#1086'.'#13#10#1044#1083#1103' '#1101#1090#1086#1075#1086' '#1084#1086#1078#1085#1086' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100', '#1085#1072#1087#1088#1080 +
      #1084#1077#1088', '#1082#1085#1080#1075#1091' '#1074' '#1090#1074#1077#1088#1076#1086#1081' '#1086#1073#1083#1086#1078#1082#1077'.'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblKeyCount_: TLabel
    Left = 16
    Top = 112
    Width = 129
    Height = 16
    AutoSize = False
    Caption = #1053#1072#1078#1072#1090#1086' '#1082#1083#1072#1074#1080#1096':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblKeyCount: TLabel
    Left = 160
    Top = 112
    Width = 145
    Height = 24
    AutoSize = False
    Caption = '0'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblResult: TLabel
    Left = 32
    Top = 176
    Width = 84
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1058#1077#1089#1090' '#1085#1077' '#1087#1088#1086#1081#1076#1077#1085
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ShapeResult: TShape
    Left = 8
    Top = 176
    Width = 17
    Height = 17
    Anchors = [akLeft, akBottom]
    Brush.Color = clSilver
    Shape = stCircle
  end
  object btnShowLayout: TButton
    Left = 320
    Top = 104
    Width = 97
    Height = 29
    Anchors = [akTop, akRight]
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 0
    OnClick = btnShowLayoutClick
  end
  object btnReset: TButton
    Left = 320
    Top = 144
    Width = 97
    Height = 29
    Anchors = [akTop, akRight]
    Caption = #1057#1073#1088#1086#1089#1080#1090#1100
    TabOrder = 1
    OnClick = btnResetClick
  end
end
