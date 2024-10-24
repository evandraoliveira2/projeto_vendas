unit uViewPesquisaProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uViewPesquisa, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Generics.Collections,
  uControllerProdutos,
  uControllerPesquisaProdutos,
  uEntityProdutos;

type
  TViewPesquisaProdutos = class(TViewPesquisa)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FControllerPesquisaProdutos: TControllerPesquisaProdutos;
    FEntityProdutos: TEntityProdutos;
    procedure Pesquisar(Sender: TObject); override;
    procedure Selecionar; override;
  public
    { Public declarations }
    property EntityProdutos: TEntityProdutos read FEntityProdutos write FEntityProdutos;
  end;

var
  ViewPesquisaProdutos: TViewPesquisaProdutos;

implementation

{$R *.dfm}

{ TViewPesquisaProdutos }

procedure TViewPesquisaProdutos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(FControllerPesquisaProdutos);
end;

procedure TViewPesquisaProdutos.FormCreate(Sender: TObject);
var
  MsgError: string;
begin
  inherited;

  Caption := 'Pesquisa de Produtos';

  EntityProdutos := TEntityProdutos.Create;
  FControllerPesquisaProdutos := TControllerPesquisaProdutos.Create;

  FControllerPesquisaProdutos.CriarDataSet(cdsTabela, MsgError);

  if MsgError <> '' then
  begin
    MessageDlg(MsgError, mtError, [mbOk], 0);
    Exit;
  end;
end;

procedure TViewPesquisaProdutos.Pesquisar(Sender: TObject);
var
  FEntityProdutosParam: TEntityProdutos;
  FListaProdutos: TObjectList<TEntityProdutos>;
  MsgError: string;
  FControllerProdutos: TControllerProdutos;
begin
  inherited;

  FListaProdutos := TObjectList<TEntityProdutos>.Create(true);
  FEntityProdutosParam := TEntityProdutos.Create;

  FEntityProdutosParam.Codigo := Codigo;
  FEntityProdutosParam.Descricao := '';

  if Sender <> nil then
  begin
    FEntityProdutosParam.Codigo := StrToInt(edtCodigo.Text);

    if trim(edtDescricao.Text) <> '' then
      FEntityProdutosParam.Descricao := edtDescricao.Text;
  end;

  FControllerProdutos := TControllerProdutos.Create;

  try
    if not FControllerProdutos.Select(FEntityProdutosParam, FListaProdutos, MsgError) then
    begin
      MessageDlg(MsgError, mtError, [mbOk], 0);
      Exit;
    end;

    MsgError := '';
    FControllerPesquisaProdutos.CarregarTabela(cdsTabela, FListaProdutos, MsgError);

    if MsgError <> '' then
    begin
      MessageDlg(MsgError, mtError, [mbOk], 0);
      Exit;
    end;
  finally
    FreeAndNil(FListaProdutos);
    FreeAndNil(FControllerProdutos);
  end;
end;

procedure TViewPesquisaProdutos.Selecionar;
begin
  inherited;
  EntityProdutos.Codigo := cdsTabela.FieldByName('CODIGO').AsInteger;
  EntityProdutos.Descricao := cdsTabela.FieldByName('DESCRICAO').AsString;
  EntityProdutos.Valor_Unitario := cdsTabela.FieldByName('VALOR_UNITARIO').AsFloat;

  ModalResult := mrOk;
end;

end.
