unit uEntityClientes;

interface

type
  TEntityClientes = class
    private
      FCodigo: Integer;
      FNome: string;
      FCidade: string;
      FUF: string;
    public
      constructor Create;
      destructor Destroy;

      property Codigo: Integer read FCodigo write FCodigo;
      property Nome: string read FNome write FNome;
      property Cidade: string read FCidade write FCidade;
      property UF: string read FUF write FUF;
  end;

implementation

{ TEntityClientes }

constructor TEntityClientes.Create;
begin
  inherited;
end;

destructor TEntityClientes.Destroy;
begin
  inherited;
end;

end.
