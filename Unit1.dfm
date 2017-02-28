object Form1: TForm1
  Left = 0
  Top = 0
  Caption = '3D '#1041#1088#1077#1074#1085#1086
  ClientHeight = 523
  ClientWidth = 880
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 185
    Height = 483
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object PageControl1: TPageControl
    Left = 199
    Top = 336
    Width = 673
    Height = 179
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1064#1072#1087#1082#1072
      object Memo1: TMemo
        Left = -4
        Top = -4
        Width = 673
        Height = 155
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1077#1095#1077#1085#1080#1103
      ImageIndex = 1
      object DBGrid1: TDBGrid
        Left = -8
        Top = -4
        Width = 313
        Height = 155
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            Title.Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1072' z'
            Width = 119
            Visible = True
          end
          item
            Expanded = False
            Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1086#1095#1077#1082' '#1074' '#1089#1077#1095#1077#1085#1080#1080
            Width = 169
            Visible = True
          end>
      end
      object DBGrid2: TDBGrid
        Left = 311
        Top = 0
        Width = 354
        Height = 151
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            Title.Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1072' x'
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            Title.Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1072' y'
            Width = 97
            Visible = True
          end>
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 65528
    object N1: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1087#1082#1091
      OnClick = N1Click
    end
  end
end
