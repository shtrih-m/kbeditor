object fmSound: TfmSound
  Left = 614
  Top = 694
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1079#1074#1091#1082#1072
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
  OnHide = FormHide
  DesignSize = (
    424
    232)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 332
    Height = 16
    Caption = #1045#1089#1083#1080' '#1074#1099' '#1089#1083#1099#1096#1080#1090#1077' '#1079#1074#1091#1082', '#1085#1072#1078#1084#1080#1090#1077' '#1082#1085#1086#1087#1082#1091' "'#1044#1072#1083#1077#1077'"'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblInfo: TLabel
    Left = 48
    Top = 48
    Width = 184
    Height = 16
    Caption = '!!! '#1053#1077#1090' '#1089#1074#1103#1079#1080' '#1089' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1086#1084
    Color = clBtnFace
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object imgExclamation: TImage
    Left = 8
    Top = 40
    Width = 32
    Height = 32
    Anchors = [akLeft, akBottom]
    Picture.Data = {
      07544269746D617076020000424D760200000000000076000000280000002000
      0000200000000100040000000000000200000000000000000000100000000000
      0000000000000000800000800000008080008000000080008000808000008080
      8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00FFFFF7777777777777777777777777FFFFFF777777777777777777777777
      777FFFF00000000000000000000000077777F3BBBBBBBBBBBBBBBBBBBBBBBB80
      77773BBBBBBBBBBBBBBBBBBBBBBBBBB807773BBBBBBBBBBBBBBBBBBBBBBBBBBB
      07773BBBBBBBBBBBB8008BBBBBBBBBBB077F3BBBBBBBBBBBB0000BBBBBBBBBB8
      077FF3BBBBBBBBBBB0000BBBBBBBBBB077FFF3BBBBBBBBBBB8008BBBBBBBBB80
      77FFFF3BBBBBBBBBBBBBBBBBBBBBBB077FFFFF3BBBBBBBBBBB0BBBBBBBBBB807
      7FFFFFF3BBBBBBBBB808BBBBBBBBB077FFFFFFF3BBBBBBBBB303BBBBBBBB8077
      FFFFFFFF3BBBBBBBB000BBBBBBBB077FFFFFFFFF3BBBBBBB80008BBBBBB8077F
      FFFFFFFFF3BBBBBB30003BBBBBB077FFFFFFFFFFF3BBBBBB00000BBBBB8077FF
      FFFFFFFFFF3BBBBB00000BBBBB077FFFFFFFFFFFFF3BBBBB00000BBBB8077FFF
      FFFFFFFFFFF3BBBB00000BBBB077FFFFFFFFFFFFFFF3BBBB00000BBB8077FFFF
      FFFFFFFFFFFF3BBB80008BBB077FFFFFFFFFFFFFFFFF3BBBBBBBBBB8077FFFFF
      FFFFFFFFFFFFF3BBBBBBBBB077FFFFFFFFFFFFFFFFFFF3BBBBBBBB8077FFFFFF
      FFFFFFFFFFFFFF3BBBBBBB077FFFFFFFFFFFFFFFFFFFFF3BBBBBB8077FFFFFFF
      FFFFFFFFFFFFFFF3BBBBB077FFFFFFFFFFFFFFFFFFFFFFF3BBBB807FFFFFFFFF
      FFFFFFFFFFFFFFFF3BB80FFFFFFFFFFFFFFFFFFFFFFFFFFFF333FFFFFFFFFFFF
      FFFF}
    Stretch = True
    Transparent = True
    Visible = False
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 8
    Top = 120
  end
end
