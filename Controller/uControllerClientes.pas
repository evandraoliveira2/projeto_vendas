unit uControllerClientes;

interface

uses
  System.SysUtils,
  Datasnap.DBClient,
  System.Generics.Collections,
  uEntityClientes,
  uDAOClientes;
type
  TControllerClientes = class
  private
  public
    constructor Create;
    destructor Destroy;

    function Select(AEntityClientesParam: TEntityClientes; AListaClientes: TObjectList<TEntityClientes>; var MsgError: string): boolean;
  end;

implementation

{ TControllerClientes }

constructor TControllerClientes.Create;
begin
  inherited;
end;

destructor TControllerClientes.Destroy;
begin
  inherited;
end;

function TControllerClientes.Select(AEntityClientesParam: TEntityClientes; AListaClientes: TObjectList<TEntityClientes>; var MsgError: string): boolean;
var
  DAOClientes: TDAOClientes;
begin
  DAOClientes := TDAOClientes.Create;

  try
    Result := DAOClientes.Select(AEntityClientesParam, AListaClientes, MsgError);
  finally
    FreeAndNil(DAOClientes);
  end;
end;

end.
