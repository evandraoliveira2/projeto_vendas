unit uControllerConexao;

interface

uses
  System.SysUtils,
  uDAOConexao;

type
  TControllerConexao = class
    private
      FConexao: TDAOConexao;
      constructor Create(FileName: string = '');
      destructor Destroy;
    public
      property daoConexao: TDAOConexao read FConexao write FConexao;

      class function getInstance: TControllerConexao; overload;
      class function getInstance(Filename: string): TControllerConexao; overload;
  end;

implementation

var
  instanciaDB: TControllerConexao;

{ TControllerConexao }

constructor TControllerConexao.Create(FileName: string = '');
begin
  FConexao := TDAOConexao.Create(Filename);
end;

destructor TControllerConexao.Destroy;
begin
  inherited;

  FreeAndNil(FConexao);
end;

class function TControllerConexao.getInstance: TControllerConexao;
begin
  if not Assigned(instanciaDB) then
    instanciaDB := TControllerConexao.Create;

  Result := instanciaDB;
end;

class function TControllerConexao.getInstance(Filename: string): TControllerConexao;
begin
  if not Assigned(instanciaDB) then
    instanciaDB := TControllerConexao.Create(FileName);

  Result := instanciaDB;
end;

initialization
  instanciaDB := nil;

finalization
  if Assigned(instanciaDB) then
    FreeAndNil(instanciaDB);

end.
