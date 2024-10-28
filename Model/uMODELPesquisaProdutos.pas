unit uMODELPesquisaProdutos;

interface

uses
  DBClient, DB, SysUtils,
  System.Generics.Collections,
  uEntityProdutos;

type
  TMODELPesquisaProdutos = class
    private
    public
      constructor Create;
      destructor Destroy;

      procedure CriarDataSet(AcdsPesqProdutos: TClientDataSet; var MsgError: string);
      procedure CarregarTabela(AcdsPesqProdutos: TClientDataSet; AListaProdutos: TObjectList<TEntityProdutos>; var MsgError: string);
  end;

implementation

{ TMODELPesquisaProdutos }

constructor TMODELPesquisaProdutos.Create;
begin
  inherited;
end;

destructor TMODELPesquisaProdutos.Destroy;
begin
  inherited;
end;

procedure TMODELPesquisaProdutos.CriarDataSet(AcdsPesqProdutos: TClientDataSet; var MsgError: string);
begin
  try
    AcdsPesqProdutos.FieldDefs.Add('CODIGO', ftInteger, 0, False);
    AcdsPesqProdutos.FieldDefs.Add('DESCRICAO', ftString, 100, False);
    AcdsPesqProdutos.FieldDefs.Add('VALOR_UNITARIO', ftFloat, 0, False);

    AcdsPesqProdutos.CreateDataSet;

    AcdsPesqProdutos.IndexFieldNames := 'CODIGO';
    AcdsPesqProdutos.Fields.FindField('CODIGO').DisplayLabel := 'Código';
    AcdsPesqProdutos.Fields.FindField('DESCRICAO').DisplayLabel := 'Descrição';
    AcdsPesqProdutos.Fields.FindField('VALOR_UNITARIO').DisplayLabel := 'Valor Unitário R$';
  except on E: Exception do
    begin
      MsgError := 'Erro ao criar tabela de pesquisa de produtos: ' + E.Message;
      Exit;
    end;
  end;
end;

procedure TMODELPesquisaProdutos.CarregarTabela(AcdsPesqProdutos: TClientDataSet; AListaProdutos: TObjectList<TEntityProdutos>; var MsgError: string);
var
  i: Integer;
begin
  try
    if not Assigned(AListaProdutos) then
      raise Exception.Create('Lista de Produtos não foi criada');

    for i:=0 to AListaProdutos.Count - 1 do
    begin
      AcdsPesqProdutos.Insert;
        AcdsPesqProdutos.FieldByName('CODIGO').AsInteger := AListaProdutos[i].Codigo;
        AcdsPesqProdutos.FieldByName('DESCRICAO').AsString := AListaProdutos[i].Descricao;
        AcdsPesqProdutos.FieldByName('VALOR_UNITARIO').AsFloat := AListaProdutos[i].Valor_Unitario;
      AcdsPesqProdutos.Post;
    end;
  except on E: Exception do
    begin
      MsgError := 'Erro ao carregar tabela: ' + E.Message;
      Exit;
    end;
  end;
end;

end.
