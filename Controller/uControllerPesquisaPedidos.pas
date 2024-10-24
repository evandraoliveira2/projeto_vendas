unit uControllerPesquisaPedidos;

interface

uses
  SysUtils, DBClient, DB,
  System.Generics.Collections,
  uEntityPedidos;

  type
    TControllerPesquisaPedidos = class
    private
    public
      constructor Create;
      destructor Destroy;

      procedure CriarDataSet(AcdsPesqPedidos: TClientDataSet; var MsgError: string);
      procedure CarregarTabela(AcdsPesqPedidos: TClientDataSet; AListaPedidos: TObjectList<TEntityPedidos>; var MsgError: string);
    end;

implementation

uses
  uMODELPesquisaPedidos;

{ TControllerPesquisaPedidos }

procedure TControllerPesquisaPedidos.CarregarTabela(AcdsPesqPedidos: TClientDataSet; AListaPedidos: TObjectList<TEntityPedidos>; var MsgError: string);
var
  FMODELPesquisaPedidos: TMODELPesquisaPedidos;
begin
  FMODELPesquisaPedidos := TMODELPesquisaPedidos.Create;

  try
    FMODELPesquisaPedidos.CarregarTabela(AcdsPesqPedidos, AListaPedidos, MsgError);

  finally
    FreeAndNil(FMODELPesquisaPedidos);
  end;
end;

constructor TControllerPesquisaPedidos.Create;
begin
  inherited;
end;

destructor TControllerPesquisaPedidos.Destroy;
begin
  inherited;
end;

procedure TControllerPesquisaPedidos.CriarDataSet(AcdsPesqPedidos: TClientDataSet; var MsgError: string);
var
  FMODELPesquisaPedidos: TMODELPesquisaPedidos;
begin
  FMODELPesquisaPedidos := TMODELPesquisaPedidos.Create;

  try
    FMODELPesquisaPedidos.CriarDataSet(AcdsPesqPedidos, MsgError);

  finally
    FreeAndNil(FMODELPesquisaPedidos);
  end;
end;

end.
