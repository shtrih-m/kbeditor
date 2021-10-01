object fmShorting: TfmShorting
  Left = 977
  Top = 790
  AutoScroll = False
  Caption = #1058#1077#1089#1090' '#1079#1072#1084#1099#1082#1072#1085#1080#1103' '#1089#1090#1088#1086#1082' '#1080' '#1089#1090#1086#1083#1073#1094#1086#1074' '
  ClientHeight = 136
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    295
    136)
  PixelsPerInch = 96
  TextHeight = 13
  object lblResult: TLabel
    Left = 32
    Top = 112
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
    Top = 112
    Width = 17
    Height = 17
    Anchors = [akLeft, akBottom]
    Brush.Color = clSilver
    Shape = stCircle
  end
  object Memo: TMemo
    Left = 8
    Top = 8
    Width = 273
    Height = 97
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
end
