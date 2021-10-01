object fmIButton: TfmIButton
  Left = 840
  Top = 626
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1058#1077#1089#1090' '#1089#1095#1080#1090#1099#1074#1072#1090#1077#1083#1103' IButton'
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
    Width = 267
    Height = 26
    Caption = 
      #1055#1088#1080#1083#1086#1078#1080#1090#1077' '#1082#1083#1102#1095' '#1082' '#1089#1095#1080#1090#1099#1074#1072#1090#1077#1083#1102' IButton.'#13#10#1058#1077#1089#1090' '#1089#1095#1080#1090#1072#1077#1090#1089#1103' '#1087#1088#1086#1081#1076#1077#1085#1085#1099#1084 +
      ', '#1077#1089#1083#1080'  '#1076#1072#1085#1085#1099#1077' '#1089#1095#1080#1090#1072#1085#1099'.'
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
