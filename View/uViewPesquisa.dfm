object ViewPesquisa: TViewPesquisa
  Left = 0
  Top = 0
  Hint = 'Pesquisar Clientes'
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pesquisa'
  ClientHeight = 343
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object pnlInformacoes: TPanel
    Left = 0
    Top = 0
    Width = 465
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object grbInformacoes: TGroupBox
      Left = 0
      Top = 0
      Width = 465
      Height = 56
      Align = alClient
      Caption = 'Informa'#231#245'es de Pesquisa'
      TabOrder = 0
      object lblCodigo: TLabel
        Left = 7
        Top = 27
        Width = 42
        Height = 15
        Alignment = taRightJustify
        Caption = 'C'#243'digo:'
      end
      object lblDescricao: TLabel
        Left = 123
        Top = 27
        Width = 54
        Height = 15
        Alignment = taRightJustify
        Caption = 'Descri'#231#227'o:'
      end
      object edtCodigo: TEdit
        Left = 55
        Top = 24
        Width = 59
        Height = 23
        Hint = 'Pressione enter para pesquisar'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnKeyPress = edtCodigoKeyPress
      end
      object edtDescricao: TEdit
        Left = 183
        Top = 24
        Width = 277
        Height = 23
        Hint = 'Pressione enter para pesquisar'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnKeyPress = edtDescricaoKeyPress
      end
    end
  end
  object gridPesquisa: TDBGrid
    Left = 0
    Top = 56
    Width = 465
    Height = 264
    Align = alClient
    DataSource = dsTabela
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDrawColumnCell = gridPesquisaDrawColumnCell
    OnDblClick = gridPesquisaDblClick
    OnKeyPress = gridPesquisaKeyPress
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 320
    Width = 465
    Height = 23
    Align = alBottom
    BevelEdges = []
    BevelOuter = bvNone
    Caption = 'Duplo clique ou enter para selecionar'
    TabOrder = 2
  end
  object cdsTabela: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 296
    Top = 184
  end
  object dsTabela: TDataSource
    DataSet = cdsTabela
    Left = 240
    Top = 184
  end
end
