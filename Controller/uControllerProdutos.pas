unit uControllerProdutos;

interface

uses
  System.SysUtils,
  Datasnap.DBClient,
  System.Generics.Collections,
  uEntityProdutos,
  uDAOProdutos;
type
  TControllerProdutos = class
  private
  public
    constructor Create;
    destructor Destroy;

    function Select(AEntityProdutosParam: TEntityProdutos; AListaProdutos: TObjectList<TEntityProdutos>; var MsgError: string): boolean;
  end;

implementation

{ TControllerProdutos }

constructor TControllerProdutos.Create;
begin
  inherited;
end;

destructor TControllerProdutos.Destroy;
begin
  inherited;
end;

function TControllerProdutos.Select(AEntityProdutosParam: TEntityProdutos; AListaProdutos: TObjectList<TEntityProdutos>; var MsgError: string): boolean;
var
  DAOProdutos: TDAOProdutos;
begin
  DAOProdutos := TDAOProdutos.Create;

  try
    Result := DAOProdutos.Select(AEntityProdutosParam, AListaProdutos, MsgError);
  finally
    FreeAndNil(DAOProdutos);
  end;
end;

end.
