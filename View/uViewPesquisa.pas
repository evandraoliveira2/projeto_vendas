unit uViewPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Datasnap.DBClient;

type
  TViewPesquisa = class(TForm)
    pnlInformacoes: TPanel;
    cdsTabela: TClientDataSet;
    dsTabela: TDataSource;
    gridPesquisa: TDBGrid;
    grbInformacoes: TGroupBox;
    lblCodigo: TLabel;
    lblDescricao: TLabel;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    pnlRodape: TPanel;
    procedure gridPesquisaDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure edtDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure gridPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure gridPesquisaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    FCodigo: Integer;
    procedure LimparTabela;
    procedure First;
  public
    { Public declarations }
    procedure Pesquisar(Sender: TObject); virtual;
    procedure Selecionar; virtual;

    property Codigo: Integer read FCodigo write FCodigo;
  end;

var
  ViewPesquisa: TViewPesquisa;

implementation

uses
  uUtils;

{$R *.dfm}

procedure TViewPesquisa.edtCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if TEdit(Sender).Text = '' then
      TEdit(Sender).Text := '0';

    Pesquisar(Sender);
    TUtils.AjustarColunas(gridPesquisa);
    First;
  end
  else
    Key := TUtils.SomenteNumeros(Key);
end;

procedure TViewPesquisa.edtDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Pesquisar(Sender);
    TUtils.AjustarColunas(gridPesquisa);
    First;
  end;
end;

procedure TViewPesquisa.FormCreate(Sender: TObject);
begin
  FCodigo := 0;

  edtCodigo.Text := '0';
  edtDescricao.Text := '';
end;

procedure TViewPesquisa.FormShow(Sender: TObject);
begin
  cdsTabela.DisableControls;

  Pesquisar(nil);
  TUtils.AjustarColunas(gridPesquisa);
  cdsTabela.First;

  cdsTabela.EnableControls;
end;

procedure TViewPesquisa.gridPesquisaDblClick(Sender: TObject);
begin
  if cdsTabela.RecordCount = 0 then
    ModalResult := mrNo
  else
    Selecionar;
end;

procedure TViewPesquisa.gridPesquisaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (TDBGrid(Sender).DataSource.DataSet.RecordCount > 0) and (Column.Field.DataType = ftFloat) then
    TDBGrid(Sender).Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, FormatFloat('###,###,##0.00', Column.Field.AsFloat));
end;

procedure TViewPesquisa.gridPesquisaKeyPress(Sender: TObject; var Key: Char);
begin
  if cdsTabela.RecordCount = 0 then
    ModalResult := mrNo
  else
    Selecionar;
end;

procedure TViewPesquisa.Pesquisar(Sender: TObject);
begin
  inherited;

  LimparTabela;
end;

procedure TViewPesquisa.Selecionar;
begin
  inherited;
end;

procedure TViewPesquisa.LimparTabela;
begin
  if cdsTabela.RecordCount > 0 then
  begin
    cdsTabela.First;

    while not cdsTabela.Eof do
      cdsTabela.Delete;
  end;
end;

procedure TViewPesquisa.First;
begin
  if cdsTabela.RecordCount > 0 then
    cdsTabela.First;
end;

end.
