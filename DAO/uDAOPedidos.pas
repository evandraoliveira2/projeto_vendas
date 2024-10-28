unit uDAOPedidos;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.DApt, FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Stan.Async,
  FireDAC.Phys.MySQL, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, System.SysUtils, System.Generics.Collections,
  uControllerConexao,
  vcl.Dialogs,
  uEntityPedidos,
  uEntityPedidosProdutos;
type
  TDAOPedidos = class
    private
      procedure DeletePedidosProdutos(AFDQuery: TFDQuery; Numero_Pedido: Integer);
      procedure InsertPedidosProdutos(AFDQuery: TFDQuery; Numero_Pedido: Integer; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>);
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

{ TDAOPedidos }

constructor TDAOPedidos.Create;
begin
  inherited;
end;

destructor TDAOPedidos.Destroy;
begin
  inherited;
end;

function TDAOPedidos.Select(AEntityPedidosParam: TEntityPedidos; AListaPedidos: TObjectList<TEntityPedidos>; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  EntityPedidos: TEntityPedidos;
  Sql, sFiltro: string;
begin
  Sql := '';
  sFiltro := '';

  try
    Sql := 'Select PEDIDOS.NUMERO, ' +
           '       PEDIDOS.DATA_EMISSAO, ' +
           '       PEDIDOS.CODIGO_CLIENTE, ' +
           '       CLIENTES.NOME AS NOME_CLIENTE, ' +
           '       PEDIDOS.VALOR_TOTAL ' +
           '  from PEDIDOS ' +
           ' left join CLIENTES on CLIENTES.CODIGO = PEDIDOS.CODIGO_CLIENTE';

    if AEntityPedidosParam.Numero > 0 then
      sFiltro := ' where NUMERO = ' + QuotedStr(IntToStr(AEntityPedidosParam.Numero));

    FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;

    try
      FFDQuery.Sql.Add(Sql + sFiltro);
      FFDQuery.Open;

      if FFDQuery.RecordCount > 0 then
      begin
        FFDQuery.First;

        while not FFDQuery.Eof do
        begin
          EntityPedidos := TEntityPedidos.Create;
          EntityPedidos.Numero := FFDQuery.FieldByName('NUMERO').AsInteger;
          EntityPedidos.Data_Emissao := FFDQuery.FieldByName('DATA_EMISSAO').AsDateTime;
          EntityPedidos.Codigo_Cliente := FFDQuery.FieldByName('CODIGO_CLIENTE').AsInteger;
          EntityPedidos.Nome_Cliente := FFDQuery.FieldByName('NOME_CLIENTE').AsString;
          EntityPedidos.Valor_Total := StrToFloat(FloatToStrF(FFDQuery.FieldByName('VALOR_TOTAL').AsFloat, ffFixed, 12, 2));
          AListaPedidos.Add(EntityPedidos);

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

function TDAOPedidos.Insert(AEntityPedidosParam: TEntityPedidos;  AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): Integer;
var
  FFDQuery: TFDQuery;
  Sql: string;
  Numero: Integer;
begin
  Numero := 0;

  try
    try
      FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;
      TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction;

      Sql := '';
      Sql := 'Insert Into PEDIDOS (DATA_EMISSAO, ' +
             '                     CODIGO_CLIENTE, ' +
             '                     VALOR_TOTAL) ' +
             '             values (:DATA_EMISSAO, ' +
             '                     :CODIGO_CLIENTE, ' +
             '                     :VALOR_TOTAL)';

      FFDQuery.Sql.Clear;
      FFDQuery.Sql.Add(Sql);
      FFDQuery.ParamByName('DATA_EMISSAO').AsDateTime := AEntityPedidosParam.Data_Emissao;
      FFDQuery.ParamByName('CODIGO_CLIENTE').AsInteger := AEntityPedidosParam.Codigo_Cliente;
      FFDQuery.ParamByName('VALOR_TOTAL').AsFloat := AEntityPedidosParam.Valor_Total;
      FFDQuery.ExecSql;

      Numero := TControllerConexao.getInstance().daoConexao.getConexao.GetLastAutoGenValue('NUMERO');

      InsertPedidosProdutos(FFDQuery, Numero, AListaPedidosProdutos);

      TControllerConexao.getInstance().daoConexao.getConexao.Commit;
    except on E: Exception do
      begin
        TControllerConexao.getInstance().daoConexao.getConexao.Rollback;
        Result := 0;
        MsgError := E.Message;
      end;
    end;
  finally
    FreeAndNil(FFDQuery);
  end;
end;

function TDAOPedidos.Update(AEntityPedidosParam: TEntityPedidos;  AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  Sql: string;
begin
  try
    try
      FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;
      TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction;

      Sql := '';
      Sql := 'Update PEDIDOS set CODIGO_CLIENTE = :CODIGO_CLIENTE, ' +
             '                   VALOR_TOTAL = :VALOR_TOTAL ' +
             ' where NUMERO = :NUMERO';

      FFDQuery.Sql.Clear;
      FFDQuery.Sql.Add(Sql);
      FFDQuery.ParamByName('NUMERO').AsInteger := AEntityPedidosParam.Numero;
      FFDQuery.ParamByName('CODIGO_CLIENTE').AsInteger := AEntityPedidosParam.Codigo_Cliente;
      FFDQuery.ParamByName('VALOR_TOTAL').AsFloat := AEntityPedidosParam.Valor_Total;
      FFDQuery.ExecSql;

      DeletePedidosProdutos(FFDQuery, AEntityPedidosParam.Numero);

      InsertPedidosProdutos(FFDQuery, AEntityPedidosParam.Numero, AListaPedidosProdutos);

      TControllerConexao.getInstance().daoConexao.getConexao.Commit;

      Result := true;
    except on E: Exception do
      begin
        TControllerConexao.getInstance().daoConexao.getConexao.Rollback;
        Result := False;
        MsgError := E.Message;
      end;
    end;
  finally
    FreeAndNil(FFDQuery);
  end;
end;

function TDAOPedidos.Delete(Numero: Integer; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  Sql: string;
begin
  try
    try
      FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;
      TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction;

      DeletePedidosProdutos(FFDQuery, Numero);

      Sql := '';
      Sql := 'Delete from PEDIDOS where NUMERO = :NUMERO_PEDIDO';

      FFDQuery.Sql.Clear;
      FFDQuery.Sql.Add(Sql);
      FFDQuery.ParamByName('NUMERO_PEDIDO').AsInteger := Numero;
      FFDQuery.ExecSql;

      TControllerConexao.getInstance().daoConexao.getConexao.Commit;

      Result := true;
    except on E: Exception do
      begin
        TControllerConexao.getInstance().daoConexao.getConexao.Rollback;
        Result := False;
        MsgError := E.Message;
      end;
    end;
  finally
    FreeAndNil(FFDQuery);
  end;
end;

procedure TDAOPedidos.DeletePedidosProdutos(AFDQuery: TFDQuery; Numero_Pedido: Integer);
var
  Sql: string;
begin
  Sql := 'Delete from PEDIDOS_PRODUTOS where NUMERO_PEDIDO = :NUMERO_PEDIDO';
  AFDQuery.Sql.Clear;
  AFDQuery.Sql.Add(Sql);
  AFDQuery.ParamByName('NUMERO_PEDIDO').AsInteger := Numero_Pedido;
  AFDQuery.ExecSql;
end;

procedure TDAOPedidos.InsertPedidosProdutos(AFDQuery: TFDQuery; Numero_Pedido: Integer; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>);
var
  Sql: string;
  i: Integer;
begin
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

    AFDQuery.Sql.Clear;
    AFDQuery.Sql.Add(Sql);
    AFDQuery.ParamByName('NUMERO_PEDIDO').AsInteger := Numero_Pedido;
    AFDQuery.ParamByName('CODIGO_PRODUTO').AsInteger := AListaPedidosProdutos[i].Codigo_Produto;
    AFDQuery.ParamByName('QUANTIDADE').AsInteger := AListaPedidosProdutos[i].Quantidade;
    AFDQuery.ParamByName('VALOR_UNITARIO').AsFloat := AListaPedidosProdutos[i].Valor_Unitario;
    AFDQuery.ParamByName('VALOR_TOTAL').AsFloat := AListaPedidosProdutos[i].Valor_Total;
    AFDQuery.ExecSql;
  end;
end;

function TDAOPedidos.SelectPedidosProdutos(Numero_Pedido: Integer; AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>; var MsgError: string): boolean;
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

end.
