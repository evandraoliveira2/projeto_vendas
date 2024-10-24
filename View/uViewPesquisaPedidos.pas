unit uViewPesquisaPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uViewPesquisa, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Generics.Collections,
  uEntityPedidos,
  uControllerPedidos,
  uControllerPesquisaPedidos;

type
  TViewPesquisaPedidos = class(TViewPesquisa)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FEntityPedidos: TEntityPedidos;
    FControllerPesquisaPedidos: TControllerPesquisaPedidos;
    procedure Pesquisar(Sender: TObject); override;
    procedure Selecionar; override;
  public
    { Public declarations }

    property EntityPedidos: TEntityPedidos read FEntityPedidos write FEntityPedidos;
  end;

var
  ViewPesquisaPedidos: TViewPesquisaPedidos;

implementation

{$R *.dfm}

{ TViewPesquisaPedidos }

procedure TViewPesquisaPedidos.FormCreate(Sender: TObject);
var
  MsgError: string;
begin
  inherited;
  Caption := 'Pesquisa de Pedidos';
  lblDescricao.Visible := False;
  edtDescricao.Visible := False;

  FControllerPesquisaPedidos := TControllerPesquisaPedidos.Create;
  FEntityPedidos := TEntityPedidos.Create;

  FControllerPesquisaPedidos.CriarDataSet(cdsTabela, MsgError);

  if MsgError <> '' then
  begin
    MessageDlg(MsgError, mtError, [mbOk], 0);
    Exit;
  end;
end;

procedure TViewPesquisaPedidos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(FControllerPesquisaPedidos);
end;

procedure TViewPesquisaPedidos.Pesquisar(Sender: TObject);
var
  FEntityPedidosParam: TEntityPedidos;
  FListaPedidos: TObjectList<TEntityPedidos>;
  FControllerPedidos: TControllerPedidos;
  MsgError: string;
begin
  inherited;

  FListaPedidos := TObjectList<TEntityPedidos>.Create(true);
  FEntityPedidosParam := TEntityPedidos.Create;

  FEntityPedidosParam.Numero := Codigo;

  if Sender <> nil then
    FEntityPedidosParam.Numero := StrToInt(edtCodigo.Text);

  FControllerPedidos := TControllerPedidos.Create;

  try
    if not FControllerPedidos.Select(FEntityPedidosParam, FListaPedidos, MsgError) then
    begin
      MessageDlg('Erro ao pesquisar Pedidos: ' + MsgError, mtError, [mbOk], 0);
      Exit;
    end;

    MsgError := '';
    FControllerPesquisaPedidos.CarregarTabela(cdsTabela, FListaPedidos, MsgError);

    if MsgError <> '' then
    begin
      MessageDlg(MsgError, mtError, [mbOk], 0);
      Exit;
    end;
  finally
    FreeAndNil(FListaPedidos);
    FreeAndNil(FControllerPedidos);
  end;
end;

procedure TViewPesquisaPedidos.Selecionar;

begin
  inherited;
  EntityPedidos.Numero := cdsTabela.FieldByName('NUMERO').AsInteger;
  EntityPedidos.Data_Emissao := cdsTabela.FieldByName('DATA_EMISSAO').AsDateTime;
  EntityPedidos.Codigo_Cliente := cdsTabela.FieldByName('CODIGO_CLIENTE').AsInteger;
  EntityPedidos.Nome_Cliente := cdsTabela.FieldByName('NOME_CLIENTE').AsString;
  EntityPedidos.Valor_Total := cdsTabela.FieldByName('VALOR_TOTAL').AsFloat;

  ModalResult := mrOk;
end;

end.
