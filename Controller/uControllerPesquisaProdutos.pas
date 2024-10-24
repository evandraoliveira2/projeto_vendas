unit uControllerPesquisaProdutos;

interface

uses
  SysUtils, DBClient, DB,
  System.Generics.Collections,
  uEntityProdutos;

  type
    TControllerPesquisaProdutos = class
    private
    public
      constructor Create;
      destructor Destroy;

      procedure CriarDataSet(AcdsPesqProdutos: TClientDataSet; var MsgError: string);
      procedure CarregarTabela(AcdsPesqProdutos: TClientDataSet; AListaProdutos: TObjectList<TEntityProdutos>; var MsgError: string);
    end;

implementation

uses
  uMODELPesquisaProdutos;

{ TControllerPesquisaProdutos }

procedure TControllerPesquisaProdutos.CarregarTabela(AcdsPesqProdutos: TClientDataSet; AListaProdutos: TObjectList<TEntityProdutos>; var MsgError: string);
var
  FMODELPesquisaProdutos: TMODELPesquisaProdutos;
begin
  FMODELPesquisaProdutos := TMODELPesquisaProdutos.Create;

  try
    FMODELPesquisaProdutos.CarregarTabela(AcdsPesqProdutos, AListaProdutos, MsgError);

  finally
    FreeAndNil(FMODELPesquisaProdutos);
  end;
end;

constructor TControllerPesquisaProdutos.Create;
begin
  inherited;
end;

destructor TControllerPesquisaProdutos.Destroy;
begin
  inherited;
end;

procedure TControllerPesquisaProdutos.CriarDataSet(AcdsPesqProdutos: TClientDataSet; var MsgError: string);
var
  FMODELPesquisaProdutos: TMODELPesquisaProdutos;
begin
  FMODELPesquisaProdutos := TMODELPesquisaProdutos.Create;

  try
    FMODELPesquisaProdutos.CriarDataSet(AcdsPesqProdutos, MsgError);

  finally
    FreeAndNil(FMODELPesquisaProdutos);
  end;
end;

end.
