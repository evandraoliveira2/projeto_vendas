unit uDAOClientes;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.DApt, FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Stan.Async,
  FireDAC.Phys.MySQL, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, System.SysUtils, Windows,
  System.Generics.Collections, uEntityClientes, uControllerConexao;

type
  TDAOClientes = class
  private
  public
    constructor Create;
    destructor Destroy;

    function Select(AEntityClientesParam: TEntityClientes; AListaClientes: TObjectList<TEntityClientes>; var MsgError: string): boolean;
  end;
implementation

uses
  uUtils;

{ TDAOClientes }

constructor TDAOClientes.Create;
begin
  inherited;
end;

destructor TDAOClientes.Destroy;
begin
  inherited;
end;

function TDAOClientes.Select(AEntityClientesParam: TEntityClientes; AListaClientes: TObjectList<TEntityClientes>; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  EntityClientes: TEntityClientes;
  Sql, sFiltro: string;
begin
  Sql := '';
  sFiltro := '';

  try
    Sql := 'Select CODIGO, ' +
           '       NOME, ' +
           '       CIDADE, ' +
           '       UF ' +
           '  from CLIENTES ';

    if AEntityClientesParam.Codigo > 0 then
      sFiltro := 'where CODIGO = ' + QuotedStr(IntToStr(AEntityClientesParam.Codigo));

    if trim(AEntityClientesParam.Nome) <> '' then
    begin
      sFiltro := sFiltro + TUtils.RetornarFiltro(sFiltro);
      sFiltro := sFiltro + ' NOME LIKE ' + QuotedStr('%' + AEntityClientesParam.Nome + '%');
    end;

    FFDQuery := TControllerConexao.getInstance().daoConexao.CriarQuery;

    try
      FFDQuery.Sql.Add(Sql + sFiltro);
      FFDQuery.Open;

      if FFDQuery.RecordCount > 0 then
      begin
        FFDQuery.First;

        while not FFDQuery.Eof do
        begin
          EntityClientes := TEntityClientes.Create;
          EntityClientes.Codigo := FFDQuery.FieldByName('CODIGO').AsInteger;

          EntityClientes.Nome := FFDQuery.FieldByName('NOME').AsString;
          EntityClientes.Cidade := FFDQuery.FieldByName('CIDADE').AsString;
          EntityClientes.UF := FFDQuery.FieldByName('UF').AsString;

          AListaClientes.Add(EntityClientes);

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
