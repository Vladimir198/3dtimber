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
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnPaint = FormPaint
  OnResize = FormResize
  DesignSize = (
    880
    505)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 0
    Width = 185
    Height = 504
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
      DesignSize = (
        665
        142)
      object ListView1: TListView
        Left = 3
        Top = 3
        Width = 270
        Height = 129
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1072' z'
          end
          item
            Alignment = taCenter
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1086#1095#1077#1082
          end>
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListView1Click
      end
      object ListView2: TListView
        Left = 279
        Top = 3
        Width = 386
        Height = 126
        Anchors = [akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'x'
          end
          item
            Caption = 'y'
          end>
        TabOrder = 1
        ViewStyle = vsReport
      end
    end
  end
  object btnOrto: TButton
    Left = 831
    Top = 344
    Width = 41
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1088#1090#1086
    TabOrder = 2
    OnClick = btnOrtoClick
  end
  object btnPerspec: TButton
    Left = 742
    Top = 344
    Width = 83
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1055#1077#1088#1089#1087#1077#1082#1090#1080#1074#1072
    TabOrder = 3
    OnClick = btnPerspecClick
  end
  object btnFill: TButton
    Left = 653
    Top = 344
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1087#1086#1083#1085#1077#1085
    TabOrder = 4
    OnClick = btnFillClick
  end
  object btnLine: TButton
    Left = 572
    Top = 344
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1077#1090#1082#1072
    TabOrder = 5
    OnClick = btnLineClick
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
