unit uMODELPedidosProdutos;

interface

uses
  DBClient, DB, SysUtils,
  System.Generics.Collections,
  uEntityPedidosProdutos;

type
  TMODELPedidosProdutos = class
    private
    public
      constructor Create;
      destructor Destroy;

      function CriarDataSet(AcdsPedidos_Produtos: TClientDataSet; var MsgError: string): boolean;
      function Inserir(AcdsPedidos_Produtos: TClientDataSet; AEntityPedidosProdutos: TEntityPedidosProdutos; var MsgError: string): boolean;
      function InserirLista(AcdsPedidos_Produtos: TClientDataSet; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
      function Alterar(AcdsPedidos_Produtos: TClientDataSet; AEntityPedidosProdutos: TEntityPedidosProdutos; var MsgError: string): boolean;
      function LimparCds(AcdsPedidos_Produtos: TClientDataSet; var MsgError: string): boolean;
  end;

implementation

{ TMODELPedidosProdutos }

constructor TMODELPedidosProdutos.Create;
begin
  inherited;
end;

destructor TMODELPedidosProdutos.Destroy;
begin
  inherited;
end;

function TMODELPedidosProdutos.CriarDataSet(AcdsPedidos_Produtos: TClientDataSet; var MsgError: string): boolean;
begin
  if not Assigned(AcdsPedidos_Produtos) then
  begin
    MsgError := 'cdsPedidos_Produtos não foi criado.';
    Exit;
  end;

  try
    AcdsPedidos_Produtos.FieldDefs.Add('CODIGO_PRODUTO', ftInteger, 0, False);
    AcdsPedidos_Produtos.FieldDefs.Add('DESCRICAO_PRODUTO', ftString, 100, False);
    AcdsPedidos_Produtos.FieldDefs.Add('QUANTIDADE', ftInteger, 0, False);
    AcdsPedidos_Produtos.FieldDefs.Add('VALOR_UNITARIO', ftFloat, 0, False);
    AcdsPedidos_Produtos.FieldDefs.Add('VALOR_TOTAL', ftFloat, 0, False);

    AcdsPedidos_Produtos.CreateDataSet;

    AcdsPedidos_Produtos.Fields.FindField('CODIGO_PRODUTO').DisplayLabel := 'Cód. Produto';
    AcdsPedidos_Produtos.Fields.FindField('DESCRICAO_PRODUTO').DisplayLabel := 'Produto';
    AcdsPedidos_Produtos.Fields.FindField('QUANTIDADE').DisplayLabel := 'Qtd';
    AcdsPedidos_Produtos.Fields.FindField('VALOR_UNITARIO').DisplayLabel := 'Vl. Unitário R$';
    AcdsPedidos_Produtos.Fields.FindField('VALOR_TOTAL').DisplayLabel := 'Vl. Total R$';

    Result := true;
  except on E: Exception do
    begin
      Result := false;
      MsgError := 'Erro ao criar tabela de Pedidos Produtos: ' + E.Message;
      Exit;
    end;
  end;
end;

function TMODELPedidosProdutos.Inserir(AcdsPedidos_Produtos: TClientDataSet; AEntityPedidosProdutos: TEntityPedidosProdutos; var MsgError: string): boolean;
begin
  if not Assigned(AcdsPedidos_Produtos) then
  begin
    MsgError := 'cdsPedidos_Produtos não foi criado.';
    Exit;
  end;

  if not Assigned(AEntityPedidosProdutos) then
  begin
    MsgError := 'EntityPedidoProdutos não foi criado.';
    Exit;
  end;

  try
    AcdsPedidos_Produtos.Insert;
      AcdsPedidos_Produtos.FieldByName('CODIGO_PRODUTO').AsInteger := AEntityPedidosProdutos.Codigo_Produto;
      AcdsPedidos_Produtos.FieldByName('DESCRICAO_PRODUTO').AsString := AEntityPedidosProdutos.Descricao_Produto;
      AcdsPedidos_Produtos.FieldByName('QUANTIDADE').AsFloat := AEntityPedidosProdutos.Quantidade;
      AcdsPedidos_Produtos.FieldByName('VALOR_UNITARIO').AsFloat := AEntityPedidosProdutos.Valor_Unitario;
      AcdsPedidos_Produtos.FieldByName('VALOR_TOTAL').AsFloat := AEntityPedidosProdutos.Valor_Total;
    AcdsPedidos_Produtos.Post;

    Result := true;
  except on E: Exception do
    begin
      Result := false;
      MsgError := 'Erro ao Inserir Produtos: ' + E.Message;
      Exit;
    end;
  end;
end;

function TMODELPedidosProdutos.InserirLista(AcdsPedidos_Produtos: TClientDataSet; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
var
  i: Integer;
begin
  if not Assigned(AcdsPedidos_Produtos) then
  begin
    MsgError := 'cdsPedidos_Produtos não foi criado.';
    Exit;
  end;

  if not Assigned(AListaPedidosProdutos) then
  begin
    MsgError := 'ListaPedidosProdutos não foi criada.';
    Exit;
  end;

  try
    AcdsPedidos_Produtos.DisableControls;

    for i:=0 to AListaPedidosProdutos.Count - 1 do
    begin
      AcdsPedidos_Produtos.Insert;
        AcdsPedidos_Produtos.FieldByName('CODIGO_PRODUTO').AsInteger := AListaPedidosProdutos[i].Codigo_Produto;
        AcdsPedidos_Produtos.FieldByName('DESCRICAO_PRODUTO').AsString := AListaPedidosProdutos[i].Descricao_Produto;
        AcdsPedidos_Produtos.FieldByName('QUANTIDADE').AsFloat := AListaPedidosProdutos[i].Quantidade;
        AcdsPedidos_Produtos.FieldByName('VALOR_UNITARIO').AsFloat := AListaPedidosProdutos[i].Valor_Unitario;
        AcdsPedidos_Produtos.FieldByName('VALOR_TOTAL').AsFloat := AListaPedidosProdutos[i].Valor_Total;
      AcdsPedidos_Produtos.Post;
    end;

    AcdsPedidos_Produtos.First;
    AcdsPedidos_Produtos.EnableControls;
    Result := true;
  except on E: Exception do
    begin
      Result := false;
      MsgError := 'Erro ao Inserir Produtos: ' + E.Message;
      AcdsPedidos_Produtos.EnableControls;
      Exit;
    end;
  end;
end;

function TMODELPedidosProdutos.Alterar(AcdsPedidos_Produtos: TClientDataSet; AEntityPedidosProdutos: TEntityPedidosProdutos; var MsgError: string): boolean;
begin
  if not Assigned(AcdsPedidos_Produtos) then
  begin
    MsgError := 'cdsPedidos_Produtos não foi criado.';
    Exit;
  end;

  if not Assigned(AEntityPedidosProdutos) then
  begin
    MsgError := 'EntityPedidoProdutos não foi criado.';
    Exit;
  end;

  try
    AcdsPedidos_Produtos.Edit;
      AcdsPedidos_Produtos.FieldByName('CODIGO_PRODUTO').AsInteger := AEntityPedidosProdutos.Codigo_Produto;
      AcdsPedidos_Produtos.FieldByName('DESCRICAO_PRODUTO').AsString := AEntityPedidosProdutos.Descricao_Produto;
      AcdsPedidos_Produtos.FieldByName('QUANTIDADE').AsFloat := AEntityPedidosProdutos.Quantidade;
      AcdsPedidos_Produtos.FieldByName('VALOR_UNITARIO').AsFloat := AEntityPedidosProdutos.Valor_Unitario;
      AcdsPedidos_Produtos.FieldByName('VALOR_TOTAL').AsFloat := AEntityPedidosProdutos.Valor_Total;
    AcdsPedidos_Produtos.Post;

    Result := true;
  except on E: Exception do
    begin
      Result := false;
      MsgError := 'Erro ao Alterar Produtos: ' + E.Message;
      Exit;
    end;
  end;
end;

function TMODELPedidosProdutos.LimparCds(AcdsPedidos_Produtos: TClientDataSet; var MsgError: string): boolean;
begin
  if not Assigned(AcdsPedidos_Produtos) then
  begin
    MsgError := 'cdsPedidos_Produtos não foi criado.';
    Exit;
  end;

  try
    AcdsPedidos_Produtos.DisableControls;

    if AcdsPedidos_Produtos.RecordCount > 0 then
    begin
      AcdsPedidos_Produtos.First;

      while not AcdsPedidos_Produtos.Eof do
        AcdsPedidos_Produtos.Delete;
    end;

    AcdsPedidos_Produtos.EnableControls;
    Result := true;
  except on E: Exception do
    begin
      Result := false;
      MsgError := 'Erro ao Limpar Cds: ' + E.Message;
      Exit;
    end;
  end;
end;

end.
