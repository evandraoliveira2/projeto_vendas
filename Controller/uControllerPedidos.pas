unit uControllerPedidos;

interface

uses
  System.SysUtils,
  Datasnap.DBClient,
  System.Generics.Collections,
  uEntityPedidos,
  uEntityPedidosProdutos,
  uDAOPedidos;
type
  TControllerPedidos = class
  private
  public
    constructor Create;
    destructor Destroy;

    function Select(AEntityPedidosParam: TEntityPedidos; AListaPedidos: TObjectList<TEntityPedidos>; var MsgError: string): boolean;
    function SelectPedidosProdutos(Numero_Pedido: Integer; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
    function Insert(AEntityPedidosParam: TEntityPedidos; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): Integer;
    function Update(AEntityPedidosParam: TEntityPedidos; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
    function Delete(Numero: Integer; var MsgError: string): boolean;

  end;

implementation

{ TControllerPedidos }

constructor TControllerPedidos.Create;
begin
  inherited;
end;

destructor TControllerPedidos.Destroy;
begin
  inherited;
end;

function TControllerPedidos.Select(AEntityPedidosParam: TEntityPedidos; AListaPedidos: TObjectList<TEntityPedidos>; var MsgError: string): boolean;
var
  FDAOPedidos: TDAOPedidos;
begin
  FDAOPedidos := TDAOPedidos.Create;

  try
    Result := FDAOPedidos.Select(AEntityPedidosParam, AListaPedidos, MsgError);
  finally
    FreeAndNil(FDAOPedidos);
  end;
end;

function TControllerPedidos.SelectPedidosProdutos(Numero_Pedido: Integer; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
var
  FDAOPedidos: TDAOPedidos;
begin
  FDAOPedidos := TDAOPedidos.Create;

  try
    Result := FDAOPedidos.SelectPedidosProdutos(Numero_Pedido, AListaPedidosProdutos, MsgError);
  finally
    FreeAndNil(FDAOPedidos);
  end;
end;

function TControllerPedidos.Insert(AEntityPedidosParam: TEntityPedidos; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): Integer;
var
  FDAOPedidos: TDAOPedidos;
begin
  FDAOPedidos := TDAOPedidos.Create;

  try
    Result := FDAOPedidos.Insert(AEntityPedidosParam, AListaPedidosProdutos, MsgError);
  finally
    FreeAndNil(FDAOPedidos);
  end;
end;

function TControllerPedidos.Update(AEntityPedidosParam: TEntityPedidos; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
var
  FDAOPedidos: TDAOPedidos;
begin
  FDAOPedidos := TDAOPedidos.Create;

  try
    Result := FDAOPedidos.Update(AEntityPedidosParam, AListaPedidosProdutos, MsgError);
  finally
    FreeAndNil(FDAOPedidos);
  end;
end;

function TControllerPedidos.Delete(Numero: Integer; var MsgError: string): boolean;
var
  FDAOPedidos: TDAOPedidos;
begin
  FDAOPedidos := TDAOPedidos.Create;

  try
    Result := FDAOPedidos.Delete(Numero, MsgError);
  finally
    FreeAndNil(FDAOPedidos);
  end;
end;

end.
