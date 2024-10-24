unit uEntityPedidos;

interface

type
  TEntityPedidos = class
    private
      FNumero: Integer;
      FData_Emissao: TDateTime;
      FCodigo_Cliente: Integer;
      FNome_Cliente: string;
      FValor_Total: Double;
    public
      constructor Create;
      destructor Destroy;

      property Numero: Integer read FNumero write FNumero;
      property Data_Emissao: TDateTime read FData_Emissao write FData_Emissao;
      property Codigo_Cliente: Integer read FCodigo_Cliente write FCodigo_Cliente;
      property Nome_Cliente: string read FNome_Cliente write FNome_Cliente;
      property Valor_Total: Double read FValor_Total write FValor_Total;
  end;

implementation

{ TEntityPedidos }

constructor TEntityPedidos.Create;
begin
  inherited;
end;

destructor TEntityPedidos.Destroy;
begin
  inherited;
end;

end.
