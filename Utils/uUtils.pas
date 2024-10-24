unit uUtils;

interface

uses
  Vcl.DBGrids,
  Math,
  System.Classes,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TUtils = class
    private
    public
      class function SomenteNumeros(var Key: Char): Char;
      class function SomenteNumerosDecimais(var Key: Char): Char; static;
      class function RetornarFiltro(var Filtro: string): string; static;
      class procedure AjustarColunas(AGrid: TDBGrid);
      class procedure Limpar(Control: TWinControl); static;
    end;

implementation

{ TUtils }

class function TUtils.SomenteNumeros(var Key: Char): Char;
begin
  Result := Key;

  if not (Key in ['0'..'9', #8, '.', '-', '+']) then
    Result := #0;
end;

class function TUtils.SomenteNumerosDecimais(var Key: Char): Char;
begin
  Result := Key;

  if not (Key in ['0'..'9', ',',  #8]) then
    Key := #0;
end;

class procedure TUtils.AjustarColunas(AGrid: TDBGrid);
var
  i, Width: Integer;
begin
  Width := 0;

  for i := 0 to AGrid.Columns.Count - 1 do
  begin
    Width := 0;

    AGrid.Columns[i].Title.Alignment := taLeftJustify;
    AGrid.Columns[i].Alignment := taLeftJustify;

    AGrid.DataSource.DataSet.First;

    if AGrid.DataSource.DataSet.RecordCount > 0 then
    begin
      while not AGrid.DataSource.DataSet.Eof do
      begin
        if (AGrid.Canvas.TextWidth(AGrid.DataSource.DataSet.Fields[i].AsString)) < (AGrid.Canvas.TextWidth(AGrid.Columns[i].Title.Caption)) then
          Width := Max(Width, AGrid.Canvas.TextWidth(AGrid.Columns[i].Title.Caption))
        else
          Width := Max(Width, AGrid.Canvas.TextWidth(AGrid.DataSource.DataSet.Fields[i].AsString));

        AGrid.DataSource.DataSet.Next;
      end;

      AGrid.DataSource.DataSet.First;
    end
    else
    begin
      Width := Max(Width, AGrid.Canvas.TextWidth(AGrid.Columns[i].Title.Caption));
    end;

    AGrid.Columns[i].Width := Width + 10;
  end;
end;

class function TUtils.RetornarFiltro(var Filtro: string): string;
begin
  Result := ' and';

  if Filtro = '' then
    Result := ' where';
end;

class procedure TUtils.Limpar(Control: TWinControl);
var
  i: Integer;
begin
  for i := 0 to Control.ControlCount - 1 do
  begin
    if Control.Controls[i] is TEdit then
      (Control.Controls[i] as TEdit).Text := ''
    else if Control.Controls[i] is TDateTimePicker then
      (Control.Controls[i] as TDateTimePicker).Date := 0;
  end;
end;


end.
