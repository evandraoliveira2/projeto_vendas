unit uDAOConexao;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.DApt, FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Stan.Async,
  FireDAC.Phys.MySQL, System.SysUtils, Windows,
  System.IniFiles,
  uEntityConexao;

  type
  TDAOConexao = class
  private
    FConexao: TFDConnection;
    FEntityConexao: TEntityConexao;
    procedure LerIni(FileName: string);
  public
    constructor Create(Filename: string = '');
    destructor Destroy;

    function getConexao: TFDConnection;
    function CriarQuery: TFDQuery;

  end;

implementation

{ TDAOConexao }

constructor TDAOConexao.Create(Filename: string = '');
begin
  FEntityConexao := TEntityConexao.Create;

  LerIni(Filename);

  FConexao := TFDConnection.Create(nil);
  FConexao.Params.Clear;
  FConexao.Params.Add('DriverID=' + FEntityConexao.DriverID);
  FConexao.Params.Add('Server=' + FEntityConexao.Server);
  FConexao.Params.Add('Port=' + FEntityConexao.Port);
  FConexao.Params.Add('Database=' + FEntityConexao.Database);
  FConexao.Params.Add('User_Name=' + FEntityConexao.User_Name);
  FConexao.Params.Add('Password=' + FEntityConexao.Password);
  FConexao.LoginPrompt := False;
end;

function TDAOConexao.CriarQuery: TFDQuery;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  Qry.Connection := FConexao;

  Result := Qry;
end;

destructor TDAOConexao.Destroy;
begin
  inherited;
  FreeAndNil(FConexao);
  FreeAndNil(FEntityConexao);
end;

function TDAOConexao.getConexao: TFDConnection;
begin
  Result := FConexao;
end;

procedure TDAOConexao.LerIni(Filename: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(Filename + 'config.ini');

  try
    FEntityConexao.DriverID := IniFile.ReadString('Database', 'DriverID', '');
    FEntityConexao.Server := IniFile.ReadString('Database', 'Server', '');
    FEntityConexao.Port := IniFile.ReadString('Database', 'Port', '');
    FEntityConexao.Database := IniFile.ReadString('Database', 'Database', '');
    FEntityConexao.User_Name := IniFile.ReadString('Database', 'User_Name', '');
    FEntityConexao.Password := IniFile.ReadString('Database', 'Password', '');
  finally
    FreeAndNil(IniFile);
  end;
end;

end.

