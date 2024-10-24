unit uDAOProdutos;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.DApt, FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Stan.Async,
  FireDAC.Phys.MySQL, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, System.SysUtils, Windows,
  System.Generics.Collections, uEntityProdutos, uControllerConexao;

type
  TDAOProdutos = class
  private
  public
    constructor Create;
    destructor Destroy;

    function Select(AEntityProdutosParam: TEntityProdutos; AListaProdutos: TObjectList<TEntityProdutos>; var MsgError: string): boolean;
  end;

implementation

uses
  uUtils;

{ TDAOProdutos }

constructor TDAOProdutos.Create;
begin
  inherited;
end;

destructor TDAOProdutos.Destroy;
begin
  inherited;
end;

function TDAOProdutos.Select(AEntityProdutosParam: TEntityProdutos; AListaProdutos: TObjectList<TEntityProdutos>; var MsgError: string): boolean;
var
  FFDQuery: TFDQuery;
  EntityProdutos: TEntityProdutos;
  Sql, sFiltro: string;
begin
  Sql := '';
  sFiltro := '';

  try
    Sql := 'Select CODIGO, ' +
           '       DESCRICAO, ' +
           '       VL_UNITARIO ' +
           '  from PRODUTOS ';

    if AEntityProdutosParam.Codigo > 0 then
      sFiltro := 'where CODIGO = ' + IntToStr(AEntityProdutosParam.Codigo);

    if trim(AEntityProdutosParam.Descricao) <> '' then
    begin
      sFiltro := sFiltro + TUtils.RetornarFiltro(sFiltro);
      sFiltro := sFiltro + ' NOME LIKE ' + QuotedStr('%' + AEntityProdutosParam.Descricao + '%');
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
          EntityProdutos := TEntityProdutos.Create;
          EntityProdutos.Codigo := FFDQuery.FieldByName('CODIGO').AsInteger;
          EntityProdutos.Descricao := FFDQuery.FieldByName('DESCRICAO').AsString;
          EntityProdutos.Valor_Unitario := FFDQuery.FieldByName('VL_UNITARIO').AsFloat;

          AListaProdutos.Add(EntityProdutos);

          FFDQuery.Next;
        end;
      end;

      Result := true;
    except on E: Exception do
      begin
        Result := False;
        MsgError := 'Erro ao pesquisar produtos: ' + E.Message;
      end;
    end;
  finally
    FreeAndNil(FFDQuery);
  end;
end;

end.
