unit uMODELPesquisaPedidos;

interface

uses
  DBClient, DB, SysUtils,
  System.Generics.Collections,
  uEntityPedidos;

type
  TMODELPesquisaPedidos = class
    private
    public
      constructor Create;
      destructor Destroy;

      procedure CriarDataSet(AcdsPesqPedidos: TClientDataSet; var MsgError: string);
      procedure CarregarTabela(AcdsPesqPedidos: TClientDataSet; AListaPedidos: TObjectList<TEntityPedidos>; var MsgError: string);
  end;

implementation

{ TMODELPesquisaPedidos }

constructor TMODELPesquisaPedidos.Create;
begin
  inherited;
end;

destructor TMODELPesquisaPedidos.Destroy;
begin
  inherited;
end;

procedure TMODELPesquisaPedidos.CriarDataSet(AcdsPesqPedidos: TClientDataSet; var MsgError: string);
begin
  try
    AcdsPesqPedidos.FieldDefs.Add('NUMERO', ftInteger, 0, False);
    AcdsPesqPedidos.FieldDefs.Add('DATA_EMISSAO', ftDateTime, 0, False);
    AcdsPesqPedidos.FieldDefs.Add('CODIGO_CLIENTE', ftInteger, 0, False);
    AcdsPesqPedidos.FieldDefs.Add('NOME_CLIENTE', ftString, 100, False);
    AcdsPesqPedidos.FieldDefs.Add('VALOR_TOTAL', ftfloat, 0, False);

    AcdsPesqPedidos.CreateDataSet;

    AcdsPesqPedidos.IndexFieldNames := 'NUMERO';
    AcdsPesqPedidos.Fields.FindField('NUMERO').DisplayLabel := 'Número';
    AcdsPesqPedidos.Fields.FindField('DATA_EMISSAO').DisplayLabel := 'Data Emissão';
    AcdsPesqPedidos.Fields.FindField('CODIGO_CLIENTE').DisplayLabel := 'Código Cliente';
    AcdsPesqPedidos.Fields.FindField('NOME_CLIENTE').DisplayLabel := 'Nome Cliente';
    AcdsPesqPedidos.Fields.FindField('VALOR_TOTAL').DisplayLabel := 'Valor Total R$';
  except on E: Exception do
    begin
      MsgError := 'Erro ao criar tabela de pesquisa de Pedidos: ' + E.Message;
      Exit;
    end;
  end;
end;

procedure TMODELPesquisaPedidos.CarregarTabela(AcdsPesqPedidos: TClientDataSet; AListaPedidos: TObjectList<TEntityPedidos>; var MsgError: string);
var
  i: Integer;
begin
  try
    if not Assigned(AListaPedidos) then
      raise Exception.Create('Lista de Pedidos não foi criada');

    for i:=0 to AListaPedidos.Count - 1 do
    begin
      AcdsPesqPedidos.Insert;
        AcdsPesqPedidos.FieldByName('NUMERO').AsInteger := AListaPedidos[i].Numero;
        AcdsPesqPedidos.FieldByName('DATA_EMISSAO').AsDateTime := AListaPedidos[i].Data_Emissao;
        AcdsPesqPedidos.FieldByName('CODIGO_CLIENTE').AsInteger := AListaPedidos[i].Codigo_Cliente;
        AcdsPesqPedidos.FieldByName('NOME_CLIENTE').AsString := AListaPedidos[i].Nome_Cliente;
        AcdsPesqPedidos.FieldByName('VALOR_TOTAL').AsFloat := AListaPedidos[i].Valor_Total;
      AcdsPesqPedidos.Post;
    end;
  except on E: Exception do
    begin
      MsgError := 'Erro ao carregar tabela: ' + E.Message;
      Exit;
    end;
  end;
end;

end.
