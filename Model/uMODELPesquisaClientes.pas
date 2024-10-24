unit uMODELPesquisaClientes;

interface

uses
  DBClient, DB, SysUtils,
  System.Generics.Collections,
  uEntityClientes;

type
  TMODELPesquisaClientes = class
    private
    public
      constructor Create;
      destructor Destroy;

      procedure CriarDataSet(AcdsPesqClientes: TClientDataSet; var MsgError: string);
      procedure CarregarTabela(AcdsPesqClientes: TClientDataSet; AListaClientes: TObjectList<TEntityClientes>; var MsgError: string);
  end;

implementation

{ TMODELPesquisaClientes }

constructor TMODELPesquisaClientes.Create;
begin
  inherited;
end;

destructor TMODELPesquisaClientes.Destroy;
begin
  inherited;
end;

procedure TMODELPesquisaClientes.CriarDataSet(AcdsPesqClientes: TClientDataSet; var MsgError: string);
begin
  try
    AcdsPesqClientes.FieldDefs.Add('CODIGO', ftInteger, 0, False);
    AcdsPesqClientes.FieldDefs.Add('NOME', ftString, 100, False);

    AcdsPesqClientes.CreateDataSet;

    AcdsPesqClientes.IndexFieldNames := 'CODIGO';
    AcdsPesqClientes.Fields.FindField('CODIGO').DisplayLabel := 'Código';
    AcdsPesqClientes.Fields.FindField('NOME').DisplayLabel := 'Nome';
  except on E: Exception do
    begin
      MsgError := 'Erro ao criar tabela de pesquisa de Clientes: ' + E.Message;
      Exit;
    end;
  end;
end;

procedure TMODELPesquisaClientes.CarregarTabela(AcdsPesqClientes: TClientDataSet; AListaClientes: TObjectList<TEntityClientes>; var MsgError: string);
var
  i: Integer;
begin
  try
    if not Assigned(AListaClientes) then
      raise Exception.Create('Lista de Clientes não foi criada');

    for i:=0 to AListaClientes.Count - 1 do
    begin
      AcdsPesqClientes.Insert;
        AcdsPesqClientes.FieldByName('CODIGO').AsInteger := AListaClientes[i].Codigo;
        AcdsPesqClientes.FieldByName('NOME').AsString := AListaClientes[i].Nome;
      AcdsPesqClientes.Post;
    end;
  except on E: Exception do
    begin
      MsgError := 'Erro ao carregar tabela: ' + E.Message;
      Exit;
    end;
  end;
end;

end.
