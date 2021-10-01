object fmProgress: TfmProgress
  Left = 379
  Top = 187
  Width = 360
  Height = 162
  Caption = 'fmProgress'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TProgressBar
    Left = 16
    Top = 24
    Width = 241
    Height = 17
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 272
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
  end
  object Button2: TButton
    Left = 272
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
  end
  object StepTimer: TTimer
    Interval = 2000
    Left = 16
    Top = 72
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 48
    Top = 72
  end
end
