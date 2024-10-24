inherited ViewPesquisaPedidos: TViewPesquisaPedidos
  Caption = 'ViewPesquisaPedidos'
  StyleElements = [seFont, seClient, seBorder]
  OnClose = FormClose
  TextHeight = 15
  inherited pnlInformacoes: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited grbInformacoes: TGroupBox
      inherited lblCodigo: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited lblDescricao: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited edtCodigo: TEdit
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited edtDescricao: TEdit
        StyleElements = [seFont, seClient, seBorder]
      end
    end
  end
  inherited pnlRodape: TPanel
    Caption = 'Duplo clique ou enter no item selecionado para selecionar'
    StyleElements = [seFont, seClient, seBorder]
  end
end
