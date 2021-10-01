object fmTestLayout: TfmTestLayout
  Left = 630
  Top = 466
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1090#1077#1089#1090#1086#1074#1086#1081' '#1088#1072#1089#1082#1083#1072#1076#1082#1080
  ClientHeight = 225
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  DesignSize = (
    398
    225)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPercents: TLabel
    Left = 350
    Top = 56
    Width = 41
    Height = 13
    Anchors = [akTop, akRight]
    AutoSize = False
  end
  object lblInfo2: TLabel
    Left = 8
    Top = 8
    Width = 381
    Height = 13
    Caption = 
      #1044#1083#1103' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1099' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1077#1089#1090#1086#1074#1091#1102' '#1088#1072#1089#1082#1083#1072 +
      #1076#1082#1091
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblProgress: TLabel
    Left = 8
    Top = 56
    Width = 87
    Height = 13
    Caption = #1061#1086#1076' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ProgressBar: TProgressBar
    Left = 104
    Top = 56
    Width = 241
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Smooth = True
    Step = 1
    TabOrder = 0
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 8
    Top = 88
  end
end
