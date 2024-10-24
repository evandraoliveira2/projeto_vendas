unit uControllerPesquisaClientes;

interface

uses
  SysUtils, DBClient, DB,
  System.Generics.Collections,
  uEntityClientes;

  type
    TControllerPesquisaClientes = class
    private
    public
      constructor Create;
      destructor Destroy;

      procedure CriarDataSet(AcdsPesqClientes: TClientDataSet; var MsgError: string);
      procedure CarregarTabela(AcdsPesqClientes: TClientDataSet; AListaClientes: TObjectList<TEntityClientes>; var MsgError: string);
    end;

implementation

uses
  uMODELPesquisaClientes;

{ TControllerPesquisaClientes }

procedure TControllerPesquisaClientes.CarregarTabela(AcdsPesqClientes: TClientDataSet; AListaClientes: TObjectList<TEntityClientes>; var MsgError: string);
var
  FMODELPesquisaClientes: TMODELPesquisaClientes;
begin
  FMODELPesquisaClientes := TMODELPesquisaClientes.Create;

  try
    FMODELPesquisaClientes.CarregarTabela(AcdsPesqClientes, AListaClientes, MsgError);

  finally
    FreeAndNil(FMODELPesquisaClientes);
  end;
end;

constructor TControllerPesquisaClientes.Create;
begin
  inherited;
end;

destructor TControllerPesquisaClientes.Destroy;
begin
  inherited;
end;

procedure TControllerPesquisaClientes.CriarDataSet(AcdsPesqClientes: TClientDataSet; var MsgError: string);
var
  FMODELPesquisaClientes: TMODELPesquisaClientes;
begin
  FMODELPesquisaClientes := TMODELPesquisaClientes.Create;

  try
    FMODELPesquisaClientes.CriarDataSet(AcdsPesqClientes, MsgError);

  finally
    FreeAndNil(FMODELPesquisaClientes);
  end;
end;

end.
