object Form1: TForm1
  Left = 0
  Top = 0
  Caption = '3D '#1041#1088#1077#1074#1085#1086
  ClientHeight = 505
  ClientWidth = 880
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  DesignSize = (
    880
    505)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 0
    Width = 185
    Height = 515
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object PageControl1: TPageControl
    Left = 202
    Top = 348
    Width = 673
    Height = 170
    ActivePage = TabSheet2
    Align = alCustom
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1064#1072#1087#1082#1072
      ExplicitHeight = 151
      DesignSize = (
        665
        142)
      object Memo1: TMemo
        Left = -4
        Top = -4
        Width = 673
        Height = 155
        Anchors = [akLeft, akTop, akRight, akBottom]
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1077#1095#1077#1085#1080#1103
      ImageIndex = 1
      ExplicitHeight = 151
      object ListView1: TListView
        Left = 3
        Top = 3
        Width = 260
        Height = 129
        Columns = <
          item
            Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1072' z'
          end
          item
            Alignment = taCenter
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1086#1095#1077#1082
          end>
        TabOrder = 0
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
