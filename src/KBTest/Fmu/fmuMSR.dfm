object fmMSR: TfmMSR
  Left = 747
  Top = 601
  ActiveControl = Memo
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1058#1077#1089#1090' '#1089#1095#1080#1090#1099#1074#1072#1090#1077#1083#1103' '#1082#1072#1088#1090
  ClientHeight = 232
  ClientWidth = 424
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
    424
    232)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 374
    Height = 32
    Caption = 
      #1057#1095#1080#1090#1072#1081#1090#1077' '#1084#1072#1075#1085#1080#1090#1085#1091#1102' '#1082#1072#1088#1090#1091#13#10#1045#1089#1083#1080' '#1076#1072#1085#1085#1099#1077' '#1087#1086#1083#1091#1095#1077#1085#1099', '#1090#1086' '#1096#1072#1075' '#1089#1095#1080#1090#1072#1077#1090#1089#1103 +
      ' '#1087#1088#1086#1081#1076#1077#1085#1085#1099#1084'.'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblResult: TLabel
    Left = 32
    Top = 208
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
    Top = 208
    Width = 17
    Height = 17
    Anchors = [akLeft, akBottom]
    Brush.Color = clSilver
    Shape = stCircle
  end
  object Memo: TMemo
    Left = 8
    Top = 56
    Width = 409
    Height = 129
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnClear: TButton
    Left = 320
    Top = 192
    Width = 99
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 1
    OnClick = btnClearClick
  end
end
