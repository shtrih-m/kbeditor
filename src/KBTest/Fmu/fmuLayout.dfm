object fmLayout: TfmLayout
  Left = 803
  Top = 602
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1088#1072#1073#1086#1095#1077#1081' '#1088#1072#1089#1082#1083#1072#1076#1082#1080
  ClientHeight = 213
  ClientWidth = 415
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
    415
    213)
  PixelsPerInch = 96
  TextHeight = 13
  object lblFileName: TLabel
    Left = 8
    Top = 16
    Width = 89
    Height = 13
    Caption = #1060#1072#1081#1083' '#1088#1072#1089#1082#1083#1072#1076#1082#1080':'
  end
  object lblProgress: TLabel
    Left = 8
    Top = 72
    Width = 87
    Height = 13
    Caption = #1061#1086#1076' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103':'
  end
  object lblPercents: TLabel
    Left = 376
    Top = 72
    Width = 29
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '100 %'
  end
  object edtFileName: TEdit
    Left = 8
    Top = 32
    Width = 361
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object btnFileName: TButton
    Left = 376
    Top = 32
    Width = 29
    Height = 29
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 1
    OnClick = btnFileNameClick
  end
  object ProgressBar: TProgressBar
    Left = 112
    Top = 72
    Width = 257
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Smooth = True
    Step = 1
    TabOrder = 2
  end
  object OpenDialog: TOpenDialog
    Left = 8
    Top = 104
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 40
    Top = 104
  end
end
