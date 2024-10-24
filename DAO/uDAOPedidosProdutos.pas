unit uDAOPedidosProdutos;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.DApt, FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Stan.Async,
  FireDAC.Phys.MySQL, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, System.SysUtils,
  System.Generics.Collections,
  uEntityPedidosProdutos,
  uControllerConexao;
type
  TDAOPedidosProdutos = class
    private
    public
    constructor Create;
    destructor Destroy;

    function Select(Numero_Pedido: Integer; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
    function Insert(AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
    function Update(AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
    function Delete(Numero_Pedido: Integer; var MsgError: string): boolean;
  end;

implementation

{ TDAOPedidosProdutos }

constructor TDAOPedidosProdutos.Create;
begin
  inherited;
end;

destructor TDAOPedidosProdutos.Destroy;
begin
  inherited;
end;

function TDAOPedidosProdutos.Select(Numero_Pedido: Integer; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  EntityPedidosProdutos: TEntityPedidosProdutos;
  Sql: string;
begin
  Sql := '';

  try
    Sql := 'Select PEDIDOS_PRODUTOS.AUTO_INCREM, ' +
           '       PEDIDOS_PRODUTOS.NUMERO_PEDIDO, ' +
           '       PEDIDOS_PRODUTOS.CODIGO_PRODUTO, ' +
           '       PRODUTOS.DESCRICAO AS DESCRICAO_PRODUTO, ' +
           '       PEDIDOS_PRODUTOS.QUANTIDADE, ' +
           '       PEDIDOS_PRODUTOS.VALOR_UNITARIO, ' +
           '       PEDIDOS_PRODUTOS.VALOR_TOTAL ' +
           '  from PEDIDOS_PRODUTOS ' +
           '  left join PRODUTOS ON PRODUTOS.CODIGO = PEDIDOS_PRODUTOS.CODIGO_PRODUTO ' +
           ' where PEDIDOS_PRODUTOS.NUMERO_PEDIDO = ' + IntToStr(Numero_Pedido);

    FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;

    try
      FFDQuery.Sql.Add(Sql);
      FFDQuery.Open;

      if FFDQuery.RecordCount > 0 then
      begin
        FFDQuery.First;

        while not FFDQuery.Eof do
        begin
          EntityPedidosProdutos := TEntityPedidosProdutos.Create;
          EntityPedidosProdutos.Auto_Increm := FFDQuery.FieldByName('AUTO_INCREM').AsInteger;
          EntityPedidosProdutos.Numero_Pedido := FFDQuery.FieldByName('NUMERO_PEDIDO').AsInteger;
          EntityPedidosProdutos.Codigo_Produto := FFDQuery.FieldByName('CODIGO_PRODUTO').AsInteger;
          EntityPedidosProdutos.Descricao_Produto := FFDQuery.FieldByName('DESCRICAO_PRODUTO').AsString;
          EntityPedidosProdutos.Quantidade := FFDQuery.FieldByName('QUANTIDADE').AsInteger;
          EntityPedidosProdutos.Valor_Unitario := StrToFloat(FloatToStrF(FFDQuery.FieldByName('VALOR_UNITARIO').AsFloat, ffFixed, 12, 2));
          EntityPedidosProdutos.Valor_Total :=  StrToFloat(FloatToStrF(FFDQuery.FieldByName('VALOR_TOTAL').AsFloat, ffFixed, 12, 2));

          AListaPedidosProdutos.Add(EntityPedidosProdutos);

          FFDQuery.Next;
        end;
      end;

      Result := true;
    except on E: Exception do
      begin
        Result := False;
        MsgError := E.Message;
      end;
    end;
  finally
    FreeAndNil(FFDQuery);
  end;
end;

function TDAOPedidosProdutos.Insert(AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  Sql: string;
  i: Integer;
begin
  try
    try
      FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;
      TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction;

      for i:=0 to AListaPedidosProdutos.count - 1 do
      begin
        Sql := '';
        Sql := 'Insert Into PEDIDOS_PRODUTOS (NUMERO_PEDIDO, ' +
               '                              CODIGO_PRODUTO, ' +
               '                              QUANTIDADE, ' +
               '                              VALOR_UNITARIO, ' +
               '                              VALOR_TOTAL) ' +
               '                      values (:NUMERO_PEDIDO, ' +
               '                              :CODIGO_PRODUTO, ' +
               '                              :QUANTIDADE, ' +
               '                              :VALOR_UNITARIO, ' +
               '                              :VALOR_TOTAL)';



        FFDQuery.Sql.Clear;
        FFDQuery.Sql.Add(Sql);
        FFDQuery.ParamByName('NUMERO_PEDIDO').AsInteger := AListaPedidosProdutos[i].Numero_Pedido;
        FFDQuery.ParamByName('CODIGO_PRODUTO').AsInteger := AListaPedidosProdutos[i].Codigo_Produto;
        FFDQuery.ParamByName('QUANTIDADE').AsInteger := AListaPedidosProdutos[i].Quantidade;
        FFDQuery.ParamByName('VALOR_UNITARIO').AsFloat := AListaPedidosProdutos[i].Valor_Unitario;
        FFDQuery.ParamByName('VALOR_TOTAL').AsFloat := AListaPedidosProdutos[i].Valor_Total;
        FFDQuery.ExecSql;
      end;

      TControllerConexao.getInstance().daoConexao.getConexao.Commit;

      Result := true;
    except on E: Exception do
      begin
        TControllerConexao.getInstance().daoConexao.getConexao.Rollback;
        Result := False;
        MsgError := 'Erro ao Inserir Pedidos Produtos: ' + E.Message;
      end;
    end;
  finally
    FreeAndNil(FFDQuery);
  end;
end;

function TDAOPedidosProdutos.Update(AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  Sql: string;
  i: Integer;
begin
  try
    try
      FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;
      TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction;

      for i:=0 to AListaPedidosProdutos.count - 1 do
      begin
        Sql := '';
        Sql := 'Update PEDIDOS_PRODUTOS set CODIGO_PRODUTO = :CODIGO_PRODUTO, ' +
               '                            QUANTIDADE = :QUANTIDADE, ' +
               '                            VALOR_UNITARIO = :VALOR_UNITARIO, ' +
               '                            VALOR_TOTAL = :VALOR_TOTAL ' +
               ' where NUMERO_PEDIDO = :NUMERO_PEDIDO';

        FFDQuery.Sql.Clear;
        FFDQuery.Sql.Add(Sql);
        FFDQuery.ParamByName('NUMERO_PEDIDO').AsInteger := AListaPedidosProdutos[i].Numero_Pedido;
        FFDQuery.ParamByName('CODIGO_PRODUTO').AsInteger := AListaPedidosProdutos[i].Codigo_Produto;
        FFDQuery.ParamByName('QUANTIDADE').AsInteger := AListaPedidosProdutos[i].Quantidade;
        FFDQuery.ParamByName('VALOR_UNITARIO').AsFloat := AListaPedidosProdutos[i].Valor_Unitario;
        FFDQuery.ParamByName('VALOR_TOTAL').AsFloat := AListaPedidosProdutos[i].Valor_Total;
        FFDQuery.ExecSql;
      end;

      TControllerConexao.getInstance().daoConexao.getConexao.Commit;

      Result := true;
    except on E: Exception do
      begin
        TControllerConexao.getInstance().daoConexao.getConexao.Rollback;
        Result := False;
        MsgError := 'Erro ao Atualizar Pedidos Produtos: ' + E.Message;
      end;
    end;
  finally
    FreeAndNil(FFDQuery);
  end;
end;

function TDAOPedidosProdutos.Delete(Numero_Pedido: Integer; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  Sql: string;
begin
  try
    try
      FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;
      TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction;

      Sql := '';
      Sql := 'Delete from PEDIDOS_PRODUTOS where NUMERO_PEDIDO = :NUMERO_PEDIDO';

      FFDQuery.Sql.Clear;
      FFDQuery.Sql.Add(Sql);
      FFDQuery.ParamByName('NUMERO_PEDIDO').AsInteger := Numero_Pedido;
      FFDQuery.ExecSql;

      TControllerConexao.getInstance().daoConexao.getConexao.Commit;

      Result := true;
    except on E: Exception do
      begin
        TControllerConexao.getInstance().daoConexao.getConexao.Rollback;
        Result := False;
        MsgError := 'Erro ao Deletar Pedidos Produtos: ' + E.Message;
      end;
    end;
  finally
    FreeAndNil(FFDQuery);
  end;
end;

end.
