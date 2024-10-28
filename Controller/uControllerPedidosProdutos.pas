unit uControllerPedidosProdutos;

interface

uses
  DBClient, DB, SysUtils,
  System.Generics.Collections,
  uEntityPedidosProdutos;

type
  TControllerPedidosProdutos = class
    private
    public
      constructor Create;
      destructor Destroy;

    function CriarDataSet(AcdsPedidos_Produtos: TClientDataSet; var MsgError: string): TClientDataSet;
    function InserirCds(AcdsPedidos_Produtos: TClientDataSet; AEntityPedidosProdutos: TEntityPedidosProdutos; var MsgError: string): boolean;
    function LimparCds(AcdsPedidos_Produtos: TClientDataSet; var MsgError: string): boolean;
    function AlterarCds(AcdsPedidos_Produtos: TClientDataSet; AEntityPedidosProdutos: TEntityPedidosProdutos; var MsgError: string): boolean;
    function InserirCdsLista(AcdsPedidos_Produtos: TClientDataSet; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
end;

implementation

uses
  uMODELPedidosProdutos;

{ TControllerPedidosProdutos }

constructor TControllerPedidosProdutos.Create;
begin
  inherited;
end;

destructor TControllerPedidosProdutos.Destroy;
begin
  inherited;
end;

function TControllerPedidosProdutos.CriarDataSet(AcdsPedidos_Produtos: TClientDataSet; var MsgError: string): TClientDataSet;
var
  FMODELPedidosProdutos: TMODELPedidosProdutos;
begin
  FMODELPedidosProdutos := TMODELPedidosProdutos.Create;

  try
    FMODELPedidosProdutos.CriarDataSet(AcdsPedidos_Produtos, MsgError);
  finally
    FreeAndNil(FMODELPedidosProdutos);
  end;
end;

function TControllerPedidosProdutos.InserirCds(AcdsPedidos_Produtos: TClientDataSet; AEntityPedidosProdutos: TEntityPedidosProdutos; var MsgError: string): boolean;
var
  FMODELPedidosProdutos: TMODELPedidosProdutos;
begin
  FMODELPedidosProdutos := TMODELPedidosProdutos.Create;

  try
    Result := FMODELPedidosProdutos.Inserir(AcdsPedidos_Produtos, AEntityPedidosProdutos, MsgError);
  finally
    FreeAndNil(FMODELPedidosProdutos);
  end;
end;

function TControllerPedidosProdutos.InserirCdsLista(AcdsPedidos_Produtos: TClientDataSet; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
var
  FMODELPedidosProdutos: TMODELPedidosProdutos;
begin
  FMODELPedidosProdutos := TMODELPedidosProdutos.Create;

  try
    Result := FMODELPedidosProdutos.InserirLista(AcdsPedidos_Produtos, AListaPedidosProdutos, MsgError);
  finally
    FreeAndNil(FMODELPedidosProdutos);
  end;
end;

function TControllerPedidosProdutos.AlterarCds(AcdsPedidos_Produtos: TClientDataSet; AEntityPedidosProdutos: TEntityPedidosProdutos; var MsgError: string): boolean;
var
  FMODELPedidosProdutos: TMODELPedidosProdutos;
begin
  FMODELPedidosProdutos := TMODELPedidosProdutos.Create;

  try
    Result := FMODELPedidosProdutos.Alterar(AcdsPedidos_Produtos, AEntityPedidosProdutos, MsgError);
  finally
    FreeAndNil(FMODELPedidosProdutos);
  end;
end;

function TControllerPedidosProdutos.LimparCds(AcdsPedidos_Produtos: TClientDataSet; var MsgError: string): boolean;
var
  FMODELPedidosProdutos: TMODELPedidosProdutos;
begin
  FMODELPedidosProdutos := TMODELPedidosProdutos.Create;

  try
    Result := FMODELPedidosProdutos.LimparCds(AcdsPedidos_Produtos, MsgError);
  finally
    FreeAndNil(FMODELPedidosProdutos);
  end;
end;

end.
