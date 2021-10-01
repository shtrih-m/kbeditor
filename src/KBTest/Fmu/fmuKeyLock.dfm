object fmKeyLock: TfmKeyLock
  Left = 840
  Top = 618
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1058#1077#1089#1090' '#1082#1083#1102#1095#1072' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099
  ClientHeight = 208
  ClientWidth = 432
  Color = clBtnFace
  Constraints.MinHeight = 231
  Constraints.MinWidth = 392
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    432
    208)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 416
    Height = 26
    Caption = 
      #1055#1086#1074#1077#1088#1085#1080#1090#1077' '#1082#1083#1102#1095' '#1074#1086' '#1074#1089#1077' '#1087#1086#1083#1086#1078#1077#1085#1080#1103#13#10#1045#1089#1083#1080' '#1087#1086#1083#1091#1095#1077#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1074' '#1082#1072#1078#1076#1086#1084' '#1087 +
      #1086#1083#1086#1078#1077#1085#1080#1080', '#1090#1086' '#1101#1090#1086#1090' '#1096#1072#1075' '#1089#1095#1080#1090#1072#1077#1090#1089#1103' '#1087#1088#1086#1081#1076#1077#1085#1085#1099#1084'.'
  end
  object lblResult: TLabel
    Left = 32
    Top = 184
    Width = 104
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1058#1077#1089#1090' '#1085#1077' '#1074#1099#1087#1086#1083#1085#1103#1083#1089#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ShapeResult: TShape
    Left = 8
    Top = 184
    Width = 17
    Height = 17
    Anchors = [akLeft, akBottom]
    Brush.Color = clSilver
    Shape = stCircle
  end
  object Memo: TMemo
    Left = 8
    Top = 40
    Width = 417
    Height = 137
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
end
