unit uDAOPedidos;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.DApt, FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Stan.Async,
  FireDAC.Phys.MySQL, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, System.SysUtils, System.Generics.Collections,
  uEntityPedidos,
  uControllerConexao,
  vcl.Dialogs;
type
  TDAOPedidos = class
    private
    public
    constructor Create;
    destructor Destroy;

    function Select(AEntityPedidosParam: TEntityPedidos; AListaPedidos: TObjectList<TEntityPedidos>; var MsgError: string): boolean;
    function Insert(AEntityPedidosParam: TEntityPedidos; var MsgError: string): Integer;
    function Update(AEntityPedidosParam: TEntityPedidos; var MsgError: string): boolean;
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

function TDAOPedidos.Insert(AEntityPedidosParam: TEntityPedidos; var MsgError: string): Integer;
var
  FFDQuery: TFDQuery;
  Sql: string;
begin
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

      Result := TControllerConexao.getInstance().daoConexao.getConexao.GetLastAutoGenValue('NUMERO');

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

function TDAOPedidos.Update(AEntityPedidosParam: TEntityPedidos; var MsgError: string): boolean;
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

      Sql := '';
      Sql := 'Delete from PEDIDOS_PRODUTOS where NUMERO_PEDIDO = :NUMERO_PEDIDO';

      FFDQuery.Sql.Clear;
      FFDQuery.Sql.Add(Sql);
      FFDQuery.ParamByName('NUMERO_PEDIDO').AsInteger := Numero;
      FFDQuery.ExecSql;

      Sql := '';
      Sql := 'Delete from PEDIDOS where NUMERO = :NUMERO';

      FFDQuery.Sql.Clear;
      FFDQuery.Sql.Add(Sql);
      FFDQuery.ParamByName('NUMERO').AsInteger := Numero;
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

end.
