object fmFirmware: TfmFirmware
  Left = 650
  Top = 510
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
  ClientHeight = 287
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    413
    287)
  PixelsPerInch = 96
  TextHeight = 13
  object lblProgress: TLabel
    Left = 16
    Top = 120
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
  object lblInfo: TLabel
    Left = 16
    Top = 8
    Width = 376
    Height = 16
    Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1087#1086#1074#1088#1077#1078#1076#1077#1085#1072'. '#1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086'.'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblFileName: TLabel
    Left = 16
    Top = 56
    Width = 94
    Height = 13
    Caption = #1060#1072#1081#1083' '#1087#1088#1086#1075#1088#1072#1084#1084#1099':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblPercents: TLabel
    Left = 376
    Top = 120
    Width = 29
    Height = 13
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = '100 %'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ProgressBar: TProgressBar
    Left = 112
    Top = 120
    Width = 257
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Smooth = True
    Step = 1
    TabOrder = 0
  end
  object edtFileName: TEdit
    Left = 16
    Top = 80
    Width = 353
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object btnFileName: TButton
    Left = 376
    Top = 80
    Width = 29
    Height = 29
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 2
    OnClick = btnFileNameClick
  end
  object btnUpdate: TButton
    Left = 272
    Top = 152
    Width = 99
    Height = 29
    Anchors = [akTop, akRight]
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 3
    OnClick = btnUpdateClick
  end
  object OpenDialog: TOpenDialog
    Left = 8
    Top = 248
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 40
    Top = 248
  end
end
