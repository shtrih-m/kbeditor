object fmProgress: TfmProgress
  Left = 968
  Top = 553
  ActiveControl = btnCancel
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Operation progress'
  ClientHeight = 310
  ClientWidth = 304
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object lblTimeLeft: TLabel
    Left = 16
    Top = 88
    Width = 69
    Height = 13
    Caption = 'Time left, sec.:'
  end
  object lblProgress: TLabel
    Left = 16
    Top = 112
    Width = 44
    Height = 13
    Caption = 'Progress:'
  end
  object lblDataRate: TLabel
    Left = 16
    Top = 64
    Width = 50
    Height = 13
    Caption = 'Data date:'
  end
  object lblDataSent: TLabel
    Left = 16
    Top = 40
    Width = 49
    Height = 13
    Caption = 'Data sent:'
  end
  object lblDataSize: TLabel
    Left = 16
    Top = 16
    Width = 47
    Height = 13
    Caption = 'Data size:'
  end
  object lblBlockSent: TLabel
    Left = 16
    Top = 168
    Width = 58
    Height = 13
    Caption = 'Blocks sent:'
  end
  object lblBlockCount: TLabel
    Left = 16
    Top = 144
    Width = 61
    Height = 13
    Caption = 'Total blocks:'
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 216
    Width = 289
    Height = 17
    Smooth = True
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 224
    Top = 280
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Stop'
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object edtDataRate: TEdit
    Left = 144
    Top = 64
    Width = 129
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
  end
  object edtTimeLeft: TEdit
    Left = 144
    Top = 88
    Width = 129
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 4
  end
  object edtProgress: TEdit
    Left = 144
    Top = 112
    Width = 129
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 5
  end
  object edtDataSent: TEdit
    Left = 144
    Top = 40
    Width = 129
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
  object edtDataSize: TEdit
    Left = 144
    Top = 16
    Width = 129
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object edtBlockSent: TEdit
    Left = 144
    Top = 168
    Width = 129
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 7
  end
  object edtBlockCount: TEdit
    Left = 144
    Top = 144
    Width = 129
    Height = 21
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 8
  end
  object edtOperation: TEdit
    Left = 8
    Top = 248
    Width = 289
    Height = 21
    BorderStyle = bsNone
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 9
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 8
    Top = 272
  end
end
