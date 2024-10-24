unit uViewPesquisaClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uViewPesquisa, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Generics.Collections,
  uControllerPesquisaClientes,
  uControllerClientes,
  uEntityClientes;

type
  TViewPesquisaClientes = class(TViewPesquisa)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FControllerPesquisaClientes: TControllerPesquisaClientes;
    FEntityClientes: TEntityClientes;
    procedure Pesquisar(Sender: TObject); override;
    procedure Selecionar; override;
  public
    { Public declarations }
    property EntityClientes: TEntityClientes read FEntityClientes write FEntityClientes;
  end;
var
  ViewPesquisaClientes: TViewPesquisaClientes;

implementation

{$R *.dfm}

{ TViewPesquisa1 }

procedure TViewPesquisaClientes.FormCreate(Sender: TObject);
var
  MsgError: string;
begin
  inherited;

  Caption := 'Pesquisa de Clientes';
  lblDescricao.Caption := 'Nome:';


  FEntityClientes := TEntityClientes.Create;

  FControllerPesquisaClientes.CriarDataSet(cdsTabela, MsgError);

  if MsgError <> '' then
  begin
    MessageDlg(MsgError, mtError, [mbOk], 0);
    Exit;
  end;
end;

procedure TViewPesquisaClientes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(FControllerPesquisaClientes);
end;

procedure TViewPesquisaClientes.Pesquisar(Sender: TObject);
var
  FEntityClientesParam: TEntityClientes;
  FListaClientes: TObjectList<TEntityClientes>;
  MsgError: string;
  FControllerClientes: TControllerClientes;
begin
  inherited;

  FListaClientes := TObjectList<TEntityClientes>.Create(true);

  FEntityClientesParam := TEntityClientes.Create;

  FEntityClientesParam.Codigo := Codigo;
  FEntityClientesParam.Nome := '';

  if Sender <> nil then
  begin
    FEntityClientesParam.Codigo := StrToInt(edtCodigo.Text);

    if trim(edtDescricao.Text) <> '' then
      FEntityClientesParam.Nome := edtDescricao.Text;
  end;

  FControllerClientes := TControllerClientes.Create;

  try
    if not FControllerClientes.Select(FEntityClientesParam, FListaClientes, MsgError) then
    begin
      MessageDlg('Erro ao pesquisar clientes: ' + MsgError, mtError, [mbOk], 0);
      Exit;
    end;

    MsgError := '';
    FControllerPesquisaClientes.CarregarTabela(cdsTabela, FListaClientes, MsgError);

    if MsgError <> '' then
    begin
      MessageDlg(MsgError, mtError, [mbOk], 0);
      Exit;
    end;
  finally
    FreeAndNil(FListaClientes);
    FreeAndNil(FControllerClientes);
  end;
end;

procedure TViewPesquisaClientes.Selecionar;
begin
  inherited;

  if cdsTabela.RecordCount > 0 then
  begin
    EntityClientes.Codigo := cdsTabela.FieldByName('CODIGO').AsInteger;
    EntityClientes.Nome := cdsTabela.FieldByName('NOME').AsString;
  end;

  ModalResult := mrOk;
end;

end.
