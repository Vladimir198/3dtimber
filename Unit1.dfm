object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 523
  ClientWidth = 880
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 185
    Height = 483
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object Button1: TButton
    Left = 16
    Top = 1
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object TabControl1: TTabControl
    Left = 199
    Top = 352
    Width = 673
    Height = 163
    TabOrder = 2
    Tabs.Strings = (
      #1054#1073#1097#1080#1077' '#1076#1072#1085#1085#1099#1077
      #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1077#1095#1077#1085#1080#1103#1084)
    TabIndex = 0
    object DBGrid1: TDBGrid
      Left = 0
      Top = 24
      Width = 670
      Height = 136
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Edit1: TEdit
    Left = 280
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
end
