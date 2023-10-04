object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 344
  ClientWidth = 757
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 164
    Width = 105
    Height = 25
    Caption = 'Upload File'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ListView1: TListView
    Left = 8
    Top = 8
    Width = 741
    Height = 150
    Columns = <
      item
        Caption = 'File ID'
        Width = 160
      end
      item
        Caption = 'File Name'
        Width = 300
      end
      item
        Caption = 'Extension'
        Width = 70
      end>
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 280
    Top = 176
  end
  object DataSource1: TDataSource
    Left = 280
    Top = 168
  end
  object PopupMenu1: TPopupMenu
    Left = 304
    Top = 88
    object GetInfo1: TMenuItem
      Caption = 'Get Info'
      OnClick = GetInfo1Click
    end
    object Download1: TMenuItem
      Caption = 'Download'
      OnClick = Download1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object RefreshList1: TMenuItem
      Caption = 'Refresh List'
      OnClick = RefreshList1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 312
    Top = 232
  end
  object OpenDialog1: TOpenDialog
    Left = 296
    Top = 176
  end
end
