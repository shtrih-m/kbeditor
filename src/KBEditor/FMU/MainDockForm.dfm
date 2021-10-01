object MainDockForm: TMainDockForm
  Left = 599
  Top = 653
  AutoScroll = False
  ClientHeight = 266
  ClientWidth = 673
  Color = clWindow
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object HSplitter: TSplitter
    Left = 0
    Top = 265
    Width = 673
    Height = 1
    Cursor = crVSplit
    Align = alBottom
    Visible = False
  end
  object BottomDockPanel: TPanel
    Left = 0
    Top = 266
    Width = 673
    Height = 0
    Align = alBottom
    DockSite = True
    TabOrder = 0
    OnDockDrop = DockPanelDockDrop
    OnDockOver = DockPanelDockOver
    OnGetSiteInfo = DockPanelGetSiteInfo
    OnResize = BottomDockPanelResize
    OnUnDock = DockPanelUnDock
  end
  object JvFormStorage1: TJvFormStorage
    AppStorage = dmData.JvAppRegistryStorage
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'BottomDockPanel.Height')
    StoredValues = <>
    Left = 8
    Top = 8
  end
end
