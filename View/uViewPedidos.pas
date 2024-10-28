unit uViewPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.ImageList,
  Vcl.ImgList, Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls, Vcl.ToolWin, Datasnap.DBClient,
  System.Generics.Collections,
  uControllerPedidos,
  uControllerPedidosProdutos,
  uEntityPedidos,
  uEntityPedidosProdutos;

type
  TModo = (tm_Insert, tm_Edit, tm_None);

type
  TViewPedidos = class(TForm)
    pnlBotoesRodape: TPanel;
    grbBotoes: TGroupBox;
    btnSalvar: TBitBtn;
    pnlBotoesCabecalho: TPanel;
    Image: TImageList;
    tbBotoesCabecalho: TToolBar;
    btnPesquisar: TToolButton;
    separator1: TToolButton;
    btnInserirPedido: TToolButton;
    pnlRodape: TPanel;
    grbRodape: TGroupBox;
    lblTotal: TLabel;
    lblValorTotal: TLabel;
    separator2: TToolButton;
    pnlGeral: TPanel;
    pnlPedidos: TPanel;
    grbPedidos: TGroupBox;
    lblNumeroPedido: TLabel;
    lblData_Emissao: TLabel;
    lblCliente: TLabel;
    edtNumero_Pedido: TEdit;
    edtData_Emissao: TDateTimePicker;
    edtCodigo_Cliente: TEdit;
    edtNome_Cliente: TEdit;
    btnPesqCliente: TBitBtn;
    pnlPedidosProdutos: TPanel;
    grbPedidosProdutos: TGroupBox;
    lblProduto: TLabel;
    lblQuantidade: TLabel;
    lblValorUnitario: TLabel;
    edtCodigo_Produto: TEdit;
    edtDescricao_Produto: TEdit;
    edtQuantidade: TEdit;
    edtValor_Unitario: TEdit;
    gridPedidosProdutos: TDBGrid;
    btnPesqProdutos: TBitBtn;
    btnAdicionar: TBitBtn;
    dsPedidosProdutos: TDataSource;
    cdsPedidosProdutos: TClientDataSet;
    btnCancelar: TBitBtn;
    btnEditarPedido: TToolButton;
    ToolButton1: TToolButton;
    btnExcluirPedido: TToolButton;
    procedure btnPesqClienteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodigo_ClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigo_ProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnInserirPedidoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPesqProdutosClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure edtValor_UnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure edtValor_UnitarioExit(Sender: TObject);
    procedure edtCodigo_ClienteExit(Sender: TObject);
    procedure edtCodigo_ProdutoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridPedidosProdutosKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelarClick(Sender: TObject);
    procedure gridPedidosProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnEditarPedidoClick(Sender: TObject);
    procedure btnExcluirPedidoClick(Sender: TObject);
    procedure gridPedidosProdutosDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
  private
    FModoPedidos: TModo;
    FModoPedidosProdutos: TModo;
    FControllerPedidos: TControllerPedidos;
    FControllerPedidosProdutos: TControllerPedidosProdutos;
    procedure ConectarBanco;
    procedure PesquisarPedidos;
    procedure ControleBotoes(Opcao:Integer);
    procedure LimparPedidos;
    procedure LimparPedidosProdutos;
    function GravarPedidos: boolean;
    procedure PopularEntityPedidos(AEntityPedidos: TEntityPedidos);
    procedure PopularEntityPedidosProdutos(AEntityPedidosProdutos: TEntityPedidosProdutos);
    procedure AlterarPedidoProduto;
    procedure InserirPedidoProduto;
    procedure PopularControlesPedidosProdutos;
    procedure PopularListaPedidosProdutos(
      AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewPedidos: TViewPedidos;

implementation

uses
  uUtils,
  uControllerConexao,
  uViewPesquisaClientes,
  uViewPesquisaPedidos,
  uViewPesquisaProdutos;

{$R *.dfm}

procedure TViewPedidos.edtCodigo_ClienteExit(Sender: TObject);
var
  MsgError: string;
begin
  if (edtCodigo_Cliente.Text <> '') and (StrToInt(edtCodigo_Cliente.Text) > 0) then
    ControleBotoes(5)
  else
  begin
    edtNome_Cliente.Text := '';

    if not (FControllerPedidosProdutos.LimparCds(cdsPedidosProdutos, MsgError)) then
    begin
      MessageDlg(MsgError, mtError, [mbOk], 0);
      Exit;
    end;

    LimparPedidosProdutos;

    ControleBotoes(6);
  end;
end;

procedure TViewPedidos.edtCodigo_ClienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnPesqClienteClick(Sender)
  else
    Key := TUtils.SomenteNumeros(Key);
end;

procedure TViewPedidos.edtCodigo_ProdutoExit(Sender: TObject);
begin
  if (edtCodigo_Produto.Text = '') or (StrToInt(edtCodigo_Produto.Text) = 0) then
    edtDescricao_Produto.Text := '';
end;

procedure TViewPedidos.edtCodigo_ProdutoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnPesqProdutosClick(Sender)
  else
    Key := TUtils.SomenteNumeros(Key);
end;

procedure TViewPedidos.edtQuantidadeExit(Sender: TObject);
begin
  if trim(edtQuantidade.Text) = '' then
    edtQuantidade.Text := '0';
end;

procedure TViewPedidos.edtQuantidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    edtValor_Unitario.SetFocus
  else
    Key := TUtils.SomenteNumeros(Key);
end;

procedure TViewPedidos.edtValor_UnitarioExit(Sender: TObject);
begin
  if trim(edtValor_Unitario.Text) = '' then
    edtValor_Unitario.Text := '0';
end;

procedure TViewPedidos.edtValor_UnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnAdicionar.SetFocus
  else
    Key := TUtils.SomenteNumerosDecimais(Key);
end;

procedure TViewPedidos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FControllerPedidos);
  FreeAndNil(FControllerPedidosProdutos);
end;

procedure TViewPedidos.FormCreate(Sender: TObject);
var
  MsgError: string;
begin
  Caption := 'Pedidos de Vendas';

  FControllerPedidos := TControllerPedidos.Create;
  FControllerPedidosProdutos := TControllerPedidosProdutos.Create;

  FControllerPedidosProdutos.CriarDataSet(cdsPedidosProdutos, MsgError);

  if cdsPedidosProdutos = nil then
  begin
    MessageDlg(MsgError, mtError, [mbOk], 0);
    Exit;
  end;

  TUtils.AjustarColunas(gridPedidosProdutos);
end;

procedure TViewPedidos.FormShow(Sender: TObject);
begin
  ConectarBanco;
  LimparPedidos;
  LimparPedidosProdutos;
  FModoPedidos := tm_None;
  ControleBotoes(1);
end;

procedure TViewPedidos.btnAdicionarClick(Sender: TObject);
var
  FEntityPedidosProdutos: TEntityPedidosProdutos;
  MsgError: string;
begin
  if (edtCodigo_Produto.Text = '') or (StrToInt(edtCodigo_Produto.Text) = 0) then
  begin
    MessageDlg('É necessário informar o produto', mtInformation, [mbOk], 0);
    edtCodigo_Produto.SetFocus;
    Exit;
  end;

  if StrToInt(edtQuantidade.Text) <= 0 then
  begin
    MessageDlg('É necessário informar a quantidade', mtInformation, [mbOk], 0);
    edtQuantidade.SetFocus;
    Exit;
  end;

  if StrToFloat(edtValor_Unitario.Text) <= 0 then
  begin
    MessageDlg('É necessário informar o Valor Unitário', mtInformation, [mbOk], 0);
    edtValor_Unitario.SetFocus;
    Exit;
  end;

  if FModoPedidosProdutos = tm_Edit then
  begin
    AlterarPedidoProduto;
    edtCodigo_Produto.Enabled := true;
    btnPesqProdutos.Enabled := true;
    edtDescricao_Produto.Enabled := true;

    FModoPedidosProdutos := tm_Insert;
  end
  else if FModoPedidosProdutos = tm_Insert then
    InserirPedidoProduto;

  edtCodigo_Produto.Enabled := true;
  btnPesqProdutos.Enabled := true;
  edtDescricao_Produto.Enabled := true;

  LimparPedidosProdutos;
  TUtils.AjustarColunas(gridPedidosProdutos);
  edtCodigo_Produto.SetFocus;
end;

procedure TViewPedidos.btnCancelarClick(Sender: TObject);
begin
  FModoPedidos := tm_None;
  ControleBotoes(1);
end;

procedure TViewPedidos.btnEditarPedidoClick(Sender: TObject);
begin
  FModoPedidos := tm_Edit;
  ControleBotoes(3);
  edtCodigo_Cliente.SetFocus;
end;

procedure TViewPedidos.btnExcluirPedidoClick(Sender: TObject);
var
  MsgError: string;
begin
  if MessageDlg('Confirma a exclusão do pedido e todos os seus produtos?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if not FControllerPedidos.Delete(StrToInt(edtNumero_Pedido.Text), MsgError) then
    begin
      MessageDlg(MsgError, mtInformation, [mbOk], 0);
      Exit;
    end;

    MessageDlg('Pedido excluído com sucesso.', mtInformation, [mbYes], 0);

    LimparPedidos;
    LimparPedidosProdutos;
    ControleBotoes(1);
  end;
end;

procedure TViewPedidos.btnInserirPedidoClick(Sender: TObject);
begin
  LimparPedidos;
  LimparPedidosProdutos;
  FModoPedidos := tm_Insert;
  ControleBotoes(2);
  edtData_Emissao.Date := Date;
  edtCodigo_Cliente.SetFocus;
end;

procedure TViewPedidos.btnPesqClienteClick(Sender: TObject);
var
  FViewPesquisaClientes: TViewPesquisaClientes;
begin
  FViewPesquisaClientes := TViewPesquisaClientes.Create(Self);

  try
    FViewPesquisaClientes.Codigo := 0;

    if (trim(edtCodigo_Cliente.Text) <> '') and (StrToInt(trim(edtCodigo_Cliente.Text)) > 0)  then
      FViewPesquisaClientes.Codigo := StrToInt(edtCodigo_Cliente.Text);

    if FViewPesquisaClientes.ShowModal = mrOk then
    begin
      edtCodigo_Cliente.Text := IntToStr(FViewPesquisaClientes.EntityClientes.Codigo);
      edtNome_Cliente.Text := FViewPesquisaClientes.EntityClientes.Nome;

      edtCodigo_ClienteExit(Sender);

      if pnlPedidosProdutos.Enabled then
        edtCodigo_Produto.SetFocus;
    end;
  finally
    FreeAndNil(FViewPesquisaClientes);
  end;
end;

procedure TViewPedidos.btnPesqProdutosClick(Sender: TObject);
var
  FViewPesquisaProdutos: TViewPesquisaProdutos;
begin
  FViewPesquisaProdutos := TViewPesquisaProdutos.Create(Self);

  try
    FViewPesquisaProdutos.Codigo := 0;

    if (trim(edtCodigo_Produto.Text) <> '') and (StrToInt(trim(edtCodigo_Produto.Text)) > 0)  then
      FViewPesquisaProdutos.Codigo := StrToInt(edtCodigo_Produto.Text);

    if FViewPesquisaProdutos.ShowModal = mrOk then
    begin
      edtCodigo_Produto.Text := IntToStr(FViewPesquisaProdutos.EntityProdutos.Codigo);
      edtDescricao_Produto.Text := FViewPesquisaProdutos.EntityProdutos.Descricao;
      edtValor_Unitario.Text := FloatToStr(FViewPesquisaProdutos.EntityProdutos.Valor_Unitario);

      edtQuantidade.SetFocus;
    end;
  finally
    FreeAndNil(FViewPesquisaProdutos);
  end;
end;

procedure TViewPedidos.btnPesquisarClick(Sender: TObject);
begin
  PesquisarPedidos;
end;

procedure TViewPedidos.btnSalvarClick(Sender: TObject);
var
  Numero_Pedido: Integer;
  MsgError: string;
begin
  if (edtCodigo_Cliente.Text = '') or (StrToInt(edtCodigo_Cliente.Text) = 0) then
  begin
    MessageDlg('É necessário informar o cliente.', mtInformation, [mbOk], 0);
    edtCodigo_Cliente.SetFocus;
    Exit;
  end;

  if cdsPedidosProdutos.RecordCount = 0 then
  begin
    MessageDlg('É necessário informar os produtos.', mtInformation, [mbOk], 0);
    edtCodigo_Produto.SetFocus;
    Exit;
  end;

  if GravarPedidos then
    MessageDlg('Pedido gravado com sucesso.', mtInformation, [mbOk], 0);

  ControleBotoes(1);
end;

procedure TViewPedidos.ConectarBanco;
begin
  try
    if not FileExists(ExtractFilePath(Application.ExeName) + 'config.ini') then
      raise Exception.Create('Arquivo de configuração config.ini não encontrado.');

    TControllerConexao.getInstance(ExtractFilePath(Application.ExeName)).daoConexao.getConexao.Connected := true;
  except on E: Exception do
    begin
      MessageDlg('Erro ao conectar no banco de dados: ' + E.Message, mtError, [mbOk], 0);
      Close;
    end;
  end;
end;

procedure TViewPedidos.PesquisarPedidos;
var
  FViewPesquisaPedidos: TViewPesquisaPedidos;
  FListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>;
  MsgError: string;
begin
  FViewPesquisaPedidos := TViewPesquisaPedidos.Create(Self);
  FListaPedidosProdutos := TObjectList<TEntityPedidosProdutos>.Create;

  try
    FViewPesquisaPedidos.Codigo := 0;

    if FViewPesquisaPedidos.ShowModal = mrOk then
    begin
      edtNumero_Pedido.Text := IntToStr(FViewPesquisaPedidos.EntityPedidos.Numero);
      edtData_Emissao.DateTime := FViewPesquisaPedidos.EntityPedidos.Data_Emissao;
      edtCodigo_Cliente.Text := IntToStr(FViewPesquisaPedidos.EntityPedidos.Codigo_Cliente);
      edtNome_Cliente.Text := FViewPesquisaPedidos.EntityPedidos.Nome_Cliente;
      lblValorTotal.Caption := FormatFloat('########0.00', FViewPesquisaPedidos.EntityPedidos.Valor_Total);

      if not FControllerPedidos.SelectPedidosProdutos(FViewPesquisaPedidos.EntityPedidos.Numero, FListaPedidosProdutos, MsgError) then
      begin
        MessageDlg(MsgError, mtError, [mbOk], 0);
        Exit;
      end;

      MsgError := '';

      if cdsPedidosProdutos.RecordCount > 0 then
      begin
        if not FControllerPedidosProdutos.LimparCds(cdsPedidosProdutos, MsgError) then
        begin
          MessageDlg(MsgError, mtError, [mbOk], 0);
          Exit;
        end;
      end;

      MsgError := '';

      if not FControllerPedidosProdutos.InserirCdsLista(cdsPedidosProdutos, FListaPedidosProdutos, MsgError) then
      begin
        MessageDlg(MsgError, mtError, [mbOk], 0);
        Exit;
      end;

      FModoPedidos := tm_None;
      TUtils.AjustarColunas(gridPedidosProdutos);
      ControleBotoes(4);
    end;
  finally
    FreeAndNil(FListaPedidosProdutos);
    FreeAndNil(FViewPesquisaPedidos);
  end;
end;

procedure TViewPedidos.LimparPedidos;
begin
  TUtils.Limpar(grbPedidos);
  edtNumero_Pedido.Text := '0';
  edtCodigo_Cliente.Text := '0';
  lblValorTotal.Caption := '0';
end;

procedure TViewPedidos.LimparPedidosProdutos;
begin
  TUtils.Limpar(grbPedidosProdutos);
  edtCodigo_Produto.Text := '0';
  edtQuantidade.Text := '0';
  edtValor_Unitario.Text := '0,00';
end;

procedure TViewPedidos.ControleBotoes(Opcao:Integer);
var
  MsgError: string;
begin
  case Opcao of
  1: begin //OnShow, Cancelar, Salvar ou Excluir
       btnPesquisar.Visible := true;
       separator1.Visible := true;
       btnInserirPedido.Enabled := true;
       btnEditarPedido.Enabled := false;
       btnExcluirPedido.Enabled := false;
       pnlGeral.Enabled := false;
       btnCancelar.Enabled := false;
       btnSalvar.Enabled := false;

       LimparPedidos;
       LimparPedidosProdutos;

       if not (FControllerPedidosProdutos.LimparCds(cdsPedidosProdutos, MsgError)) then
       begin
         MessageDlg(MsgError, mtError, [mbOk], 0);
         Exit;
       end;
     end;
  2: begin //Inserir
       btnPesquisar.Visible := false;
       separator1.Visible := false;
       btnInserirPedido.Enabled := false;
       btnEditarPedido.Enabled := false;
       btnExcluirPedido.Enabled := false;
       pnlGeral.Enabled := true;
       btnCancelar.Enabled := true;
       btnSalvar.Enabled := true;

       LimparPedidos;
       LimparPedidosProdutos;

       if not (FControllerPedidosProdutos.LimparCds(cdsPedidosProdutos, MsgError)) then
       begin
         MessageDlg(MsgError, mtError, [mbOk], 0);
         Exit;
       end;
     end;
  3: begin //Editar
       btnPesquisar.Visible := false;
       separator1.Visible := false;
       btnInserirPedido.Enabled := false;
       btnEditarPedido.Enabled := false;
       btnExcluirPedido.Enabled := false;
       pnlGeral.Enabled := true;
       btnCancelar.Enabled := true;
       btnSalvar.Enabled := true;
     end;
  4: begin //Pesquisar
       btnPesquisar.Visible := true;
       separator1.Visible := true;
       btnInserirPedido.Enabled := true;
       btnEditarPedido.Enabled := true;
       btnExcluirPedido.Enabled := true;
       pnlGeral.Enabled := false;
       btnCancelar.Enabled := false;
       btnSalvar.Enabled := false;
     end;
  5: begin
       pnlPedidosProdutos.Enabled := true;
     end;
  6: begin
       pnlPedidosProdutos.Enabled := false;
     end;
  end;
end;

function TViewPedidos.GravarPedidos: boolean;
var
  FEntityPedidos: TEntityPedidos;
  FListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>;
  MsgError: string;
begin
  Result := true;

  FEntityPedidos := TEntityPedidos.Create;
  FListaPedidosProdutos := TObjectList<TEntityPedidosProdutos>.Create(true);

  cdsPedidosProdutos.DisableControls;

  try
    PopularEntityPedidos(FEntityPedidos);
    PopularListaPedidosProdutos(FListaPedidosProdutos);

    if FModoPedidos = tm_Insert then
    begin
      FEntityPedidos.Numero := FControllerPedidos.Insert(FEntityPedidos, FListaPedidosProdutos, MsgError);

      if FEntityPedidos.Numero = 0 then
      begin
        Result := false;
        MessageDlg(MsgError, mtError, [mbOk], 0);
        Exit;
      end
    end
    else if FModoPedidos = tm_Edit then
    begin
      FEntityPedidos.Numero := StrToInt(edtNumero_Pedido.Text);

      if not FControllerPedidos.Update(FEntityPedidos, FListaPedidosProdutos, MsgError) then
      begin
        Result := false;
        MessageDlg(MsgError, mtError, [mbOk], 0);
        Exit;
      end
    end;
  finally
    FModoPedidos := tm_None;
    cdsPedidosProdutos.First;
    cdsPedidosProdutos.EnableControls;
    FreeAndNil(FEntityPedidos);
    FreeAndNil(FListaPedidosProdutos);
  end;
end;

procedure TViewPedidos.gridPedidosProdutosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (TDBGrid(Sender).DataSource.DataSet.RecordCount > 0) and (Column.Field.DataType = ftFloat) then
    TDBGrid(Sender).Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, FormatFloat('###,###,##0.00', Column.Field.AsFloat));
end;

procedure TViewPedidos.gridPedidosProdutosKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if MessageDlg('Tem certeza que deseja excluir este registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      cdsPedidosProdutos.Delete;
  end;
end;

procedure TViewPedidos.gridPedidosProdutosKeyPress(Sender: TObject;
  var Key: Char);
var
  FEntityPedidosProdutos: TEntityPedidosProdutos;
  MsgError: string;
begin
  if Key = #13 then
  begin
    FModoPedidosProdutos := tm_Edit;
    PopularControlesPedidosProdutos;    
    edtCodigo_Produto.Enabled := false;
    btnPesqProdutos.Enabled := false;
    edtDescricao_Produto.Enabled := false;
    edtQuantidade.SetFocus;
  end;
end;

procedure TViewPedidos.PopularEntityPedidos(AEntityPedidos: TEntityPedidos);
begin
  if not Assigned(AEntityPedidos) then
  begin
    MessageDlg('EntityPedidos não foi criada.', mtError, [mbOk], 0);
    Exit;
  end;

  try
    AEntityPedidos.Data_Emissao := edtData_Emissao.DateTime;
    AEntityPedidos.Codigo_Cliente := StrtoInt(edtCodigo_Cliente.Text);
    AEntityPedidos.Valor_Total := StrToFloat(lblValorTotal.Caption);
  except on E:Exception do
    begin
      MessageDlg('Erro ao popular EntityPedidos: ' + E.Message, mtError, [mbOk], 0);
      Exit;
    end;
  end;
end;

procedure TViewPedidos.PopularEntityPedidosProdutos(AEntityPedidosProdutos: TEntityPedidosProdutos);
begin
  if not Assigned(AEntityPedidosProdutos) then
  begin
    MessageDlg('EntityPedidoProdutos não foi criado.', mtError, [mbOk], 0);
    Exit;
  end;

  try
    AEntityPedidosProdutos.Codigo_Produto := StrToInt(edtCodigo_Produto.Text);
    AEntityPedidosProdutos.Descricao_Produto := edtDescricao_Produto.Text;
    AEntityPedidosProdutos.Quantidade := StrToInt(edtQuantidade.Text);
    AEntityPedidosProdutos.Valor_Unitario := StrToFloat(edtValor_Unitario.Text);

    AEntityPedidosProdutos.Valor_Total := 0;
    AEntityPedidosProdutos.Valor_Total := StrToInt(edtQuantidade.Text) * StrToFloat(edtValor_Unitario.Text);
  except on E: Exception do
    begin
      MessageDlg('Erro ao popular EntityPedidosProdutos: ' + E.Message, mtError, [mbOk], 0);
      Exit;
    end;
  end;
end;

procedure TViewPedidos.PopularListaPedidosProdutos(AListaPedidosProdutos: TObjectList<TEntityPedidosProdutos>);
var
  FEntityPedidosProdutos: TEntityPedidosProdutos;
begin
  cdsPedidosProdutos.First;

  while not cdsPedidosProdutos.Eof do
  begin
    FEntityPedidosProdutos := TEntityPedidosProdutos.Create;
    FEntityPedidosProdutos.Codigo_Produto := cdsPedidosProdutos.FieldByName('CODIGO_PRODUTO').AsInteger;
    FEntityPedidosProdutos.Quantidade := cdsPedidosProdutos.FieldByName('QUANTIDADE').AsInteger;
    FEntityPedidosProdutos.Valor_Unitario := cdsPedidosProdutos.FieldByName('VALOR_UNITARIO').AsFloat;
    FEntityPedidosProdutos.Valor_Total := cdsPedidosProdutos.FieldByName('VALOR_TOTAL').AsFloat;
    AListaPedidosProdutos.Add(FEntityPedidosProdutos);

    cdsPedidosProdutos.Next;
  end;
end;

procedure TViewPedidos.AlterarPedidoProduto;
var
  FEntityPedidosProdutos: TEntityPedidosProdutos;
  MsgError: string;
begin
  if (cdsPedidosProdutos.Active) and (cdsPedidosProdutos.RecordCount > 0) then
  begin
    FEntityPedidosProdutos := TEntityPedidosProdutos.Create;

    try
      PopularEntityPedidosProdutos(FEntityPedidosProdutos);

      if not FControllerPedidosProdutos.AlterarCds(cdsPedidosProdutos, FEntityPedidosProdutos, MsgError) then
      begin
        MessageDlg(MsgError, mtError, [mbOk], 0);
        Exit;
      end;

      lblValorTotal.Caption := FormatFloat('###,###,##0.00', (StrToFloat(lblValorTotal.Caption) + FEntityPedidosProdutos.Valor_Total));
    finally
      FreeAndNil(FEntityPedidosProdutos);
    end;
  end;
end;

procedure TViewPedidos.InserirPedidoProduto;
var
  FEntityPedidosProdutos: TEntityPedidosProdutos;
  MsgError: string;
begin
  FEntityPedidosProdutos := TEntityPedidosProdutos.Create;

  try
    PopularEntityPedidosProdutos(FEntityPedidosProdutos);

    if not (FControllerPedidosProdutos.InserirCds(cdsPedidosProdutos, FEntityPedidosProdutos, MsgError)) then
    begin
      MessageDlg(MsgError, mtError, [mbOk], 0);
      Exit;
    end;

    lblValorTotal.Caption := FormatFloat('###,###,##0.00', (StrToFloat(lblValorTotal.Caption) + FEntityPedidosProdutos.Valor_Total));
  finally
    FreeAndNil(FEntityPedidosProdutos);
  end;
end;

procedure TViewPedidos.PopularControlesPedidosProdutos;
begin
  if (not cdsPedidosProdutos.Active) and (cdsPedidosProdutos.RecordCount > 0) then
  begin
    MessageDlg('Não existem pedidos de produtos cadastrados.', mtError, [mbOk], 0);
    Exit;
  end;

  try
    edtCodigo_Produto.Text := IntToStr(cdsPedidosProdutos.FieldByName('CODIGO_PRODUTO').AsInteger);
    edtDescricao_Produto.Text := cdsPedidosProdutos.FieldByName('DESCRICAO_PRODUTO').AsString;
    edtQuantidade.Text := IntToStr(cdsPedidosProdutos.FieldByName('QUANTIDADE').AsInteger);
    edtValor_Unitario.Text := FloatToStr(cdsPedidosProdutos.FieldByName('VALOR_UNITARIO').AsFloat);
    except on E: Exception do
    begin
      MessageDlg('Erro ao popular Controles de Pedidos Produtos: ' + E.Message, mtError, [mbOk], 0);
      Exit;
    end;
 end;
end;

end.
