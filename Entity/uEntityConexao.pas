unit uEntityConexao;

interface

type
  TEntityConexao = class
    private
      FDriverID: string;
      FServer: string;
      FPort: string;
      FDatabase: string;
      FUser_Name: string;
      FPassword: string;
    public
      constructor Create;
      destructor Destroy;

      property DriverID: string read FDriverID write FDriverID;
      property Server: string read FServer write FServer;
      property Port: string read FPort write FPort;
      property Database: string read FDatabase write FDatabase;
      property User_Name: string read FUser_Name write FUser_Name;
      property Password: string read FPassword write FPassword;
  end;

implementation

{ TEntityConexao }

constructor TEntityConexao.Create;
begin
  inherited;
end;

destructor TEntityConexao.Destroy;
begin
  inherited;
end;

end.
