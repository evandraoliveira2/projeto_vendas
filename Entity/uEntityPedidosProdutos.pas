unit uEntityPedidosProdutos;

interface

type
  TEntityPedidosProdutos = class
    private
      FAuto_Increm: Integer;
      FNumero_Pedido: Integer;
      FCodigo_Produto: Integer;
      FDescricao_Produto: string;
      FQuantidade: Integer;
      FValor_Unitario: Double;
      FValor_Total: Double;
    public
      constructor Create;
      destructor Destroy;

      property Auto_Increm: Integer read FAuto_Increm write FAuto_Increm;
      property Numero_Pedido: Integer read FNumero_Pedido write FNumero_Pedido;
      property Codigo_Produto: Integer read FCodigo_Produto write FCodigo_Produto;
      property Descricao_Produto: string read FDescricao_Produto write FDescricao_Produto;
      property Quantidade: Integer read FQuantidade write FQuantidade;
      property Valor_Unitario: Double read FValor_Unitario write FValor_Unitario;
      property Valor_Total: Double read FValor_Total write FValor_Total;
  end;

implementation

{ TEntityPedidosProdutos }

constructor TEntityPedidosProdutos.Create;
begin
  inherited;
end;

destructor TEntityPedidosProdutos.Destroy;
begin
  inherited;
end;

end.
