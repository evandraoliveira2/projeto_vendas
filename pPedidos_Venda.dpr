program pPedidos_Venda;

uses
  Vcl.Forms,
  uControllerConexao in 'Controller\uControllerConexao.pas',
  uDAOConexao in 'DAO\uDAOConexao.pas',
  uEntityClientes in 'Entity\uEntityClientes.pas',
  uDAOClientes in 'DAO\uDAOClientes.pas',
  uControllerClientes in 'Controller\uControllerClientes.pas',
  uViewPesquisa in 'View\uViewPesquisa.pas' {ViewPesquisa},
  uViewPesquisaClientes in 'View\uViewPesquisaClientes.pas' {ViewPesquisaClientes},
  uUtils in 'Utils\uUtils.pas',
  uViewPesquisaPedidos in 'View\uViewPesquisaPedidos.pas' {ViewPesquisaPedidos},
  uEntityPedidos in 'Entity\uEntityPedidos.pas',
  uEntityProdutos in 'Entity\uEntityProdutos.pas',
  uDAOPedidos in 'DAO\uDAOPedidos.pas',
  uControllerPedidos in 'Controller\uControllerPedidos.pas',
  uViewPesquisaProdutos in 'View\uViewPesquisaProdutos.pas' {ViewPesquisaProdutos},
  uDAOProdutos in 'DAO\uDAOProdutos.pas',
  uControllerProdutos in 'Controller\uControllerProdutos.pas',
  uViewPedidos in 'View\uViewPedidos.pas' {ViewPedidos},
  uMODELPedidos in 'Model\uMODELPedidos.pas',
  uMODELPedidosProdutos in 'Model\uMODELPedidosProdutos.pas',
  uEntityPedidosProdutos in 'Entity\uEntityPedidosProdutos.pas',
  uMODELPesquisaProdutos in 'Model\uMODELPesquisaProdutos.pas',
  uControllerPesquisaProdutos in 'Controller\uControllerPesquisaProdutos.pas',
  uMODELPesquisaClientes in 'Model\uMODELPesquisaClientes.pas',
  uControllerPesquisaClientes in 'Controller\uControllerPesquisaClientes.pas',
  uMODELPesquisaPedidos in 'Model\uMODELPesquisaPedidos.pas',
  uControllerPesquisaPedidos in 'Controller\uControllerPesquisaPedidos.pas',
  uEntityConexao in 'Entity\uEntityConexao.pas',
  uControllerPedidosProdutos in 'Controller\uControllerPedidosProdutos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPedidos, ViewPedidos);
  Application.Run;
end.
