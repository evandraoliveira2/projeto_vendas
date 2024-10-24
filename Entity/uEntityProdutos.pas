unit uEntityProdutos;

interface

type
  TEntityProdutos = class
    private
      FCodigo: Integer;
      FDescricao: string;
      FValor_Unitario: Double;
    public
      constructor Create;
      destructor Destroy;

      property Codigo: Integer read FCodigo write FCodigo;
      property Descricao: string read FDescricao write FDescricao;
      property Valor_Unitario: Double read FValor_Unitario write FValor_Unitario;
  end;

implementation

{ TEntityProdutos }

constructor TEntityProdutos.Create;
begin
  inherited;
end;

destructor TEntityProdutos.Destroy;
begin
  inherited;
end;

end.
