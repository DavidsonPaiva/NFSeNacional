unit Entity.Prestador;

interface

uses
  System.SysUtils,
  ACBrUtil.Strings;

type
  INFSePrestador = interface
    ['{D08B1CDB-77A8-4C46-B939-F1C7B8C5AF6A}']
    function CNPJ(AValue: string): INFSePrestador; overload;
    function CNPJ: string; overload;

    function InscricaoMunicipal(AValue: string): INFSePrestador; overload;
    function InscricaoMunicipal: string; overload;

    function RazaoSocial(AValue: string): INFSePrestador; overload;
    function RazaoSocial: string; overload;

    function Endereco(AValue: string): INFSePrestador; overload;
    function Endereco: string; overload;

    function Numero(AValue: string): INFSePrestador; overload;
    function Numero: string; overload;

    function Bairro(AValue: string): INFSePrestador; overload;
    function Bairro: string; overload;

    function CEP(AValue: string): INFSePrestador; overload;
    function CEP: string; overload;

    function Telefone(AValue: string): INFSePrestador; overload;
    function Telefone: string; overload;

    function Email(AValue: string): INFSePrestador; overload;
    function Email: string; overload;

    function Cidade(AValue: string): INFSePrestador; overload;
    function Cidade: string; overload;

    function UF(AValue: string): INFSePrestador; overload;
    function UF: string; overload;

    procedure Clear;
  end;

  TNFSePrestador = class(TInterfacedObject, INFSePrestador)
  private
    FCNPJ              : string;
    FInscricaoMunicipal: string;
    FRazaoSocial       : string;
    FEndereco          : string;
    FNumero            : string;
    FBairro            : string;
    FCEP               : string;
    FTelefone          : string;
    FCidade            : string;
    FEmail             : string;
    FUF                : string;
  public
    function CNPJ(AValue: string): INFSePrestador; overload;
    function CNPJ: string; overload;

    function InscricaoMunicipal(AValue: string): INFSePrestador; overload;
    function InscricaoMunicipal: string; overload;

    function RazaoSocial(AValue: string): INFSePrestador; overload;
    function RazaoSocial: string; overload;

    function Endereco(AValue: string): INFSePrestador; overload;
    function Endereco: string; overload;

    function Numero(AValue: string): INFSePrestador; overload;
    function Numero: string; overload;

    function Bairro(AValue: string): INFSePrestador; overload;
    function Bairro: string; overload;

    function CEP(AValue: string): INFSePrestador; overload;
    function CEP: string; overload;

    function Telefone(AValue: string): INFSePrestador; overload;
    function Telefone: string; overload;

    function Email(AValue: string): INFSePrestador; overload;
    function Email: string; overload;

    function Cidade(AValue: string): INFSePrestador; overload;
    function Cidade: string; overload;

    function UF(AValue: string): INFSePrestador; overload;
    function UF: string; overload;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
    class function New: INFSePrestador;
  end;

implementation

{ TNFSePrestador }

constructor TNFSePrestador.Create;
begin
  Clear;
end;

destructor TNFSePrestador.Destroy;
begin
  inherited;
end;

class function TNFSePrestador.New: INFSePrestador;
begin
  Result := Self.Create;
end;

procedure TNFSePrestador.Clear;
begin
  FCNPJ               := '';
  FInscricaoMunicipal := '';
  FRazaoSocial        := '';
  FEndereco           := '';
  FNumero             := '';
  FBairro             := '';
  FCEP                := '';
  FTelefone           := '67992677349';
  FEmail              := 'contato@paiva.app.br';
  FCidade             := 'CAMPO GRANDE';
  FUF                 := 'MS';
end;

function TNFSePrestador.CNPJ(AValue: string): INFSePrestador;
begin
  Result := Self;
  FCNPJ  := AValue;
end;

function TNFSePrestador.InscricaoMunicipal(AValue: string): INFSePrestador;
begin
  Result              := Self;
  FInscricaoMunicipal := AValue;
end;

function TNFSePrestador.RazaoSocial(AValue: string): INFSePrestador;
begin
  Result       := Self;
  FRazaoSocial := AValue;
end;

function TNFSePrestador.Endereco(AValue: string): INFSePrestador;
begin
  Result    := Self;
  FEndereco := AValue;
end;

function TNFSePrestador.Numero(AValue: string): INFSePrestador;
begin
  Result  := Self;
  FNumero := AValue;
end;

function TNFSePrestador.Bairro(AValue: string): INFSePrestador;
begin
  Result  := Self;
  FBairro := AValue;
end;

function TNFSePrestador.CEP(AValue: string): INFSePrestador;
begin
  Result := Self;
  FCEP   := AValue;
end;

function TNFSePrestador.Telefone(AValue: string): INFSePrestador;
begin
  Result    := Self;
  FTelefone := AValue;
end;

function TNFSePrestador.Email(AValue: string): INFSePrestador;
begin
  Result := Self;
  FEmail := AValue;
end;

function TNFSePrestador.Cidade(AValue: string): INFSePrestador;
begin
  Result  := Self;
  FCidade := AValue;
end;

function TNFSePrestador.UF(AValue: string): INFSePrestador;
begin
  Result := Self;
  FUF    := AValue;
end;

function TNFSePrestador.CNPJ: string;
begin
  Result := OnlyNumber(FCNPJ);
end;

function TNFSePrestador.InscricaoMunicipal: string;
begin
  Result := OnlyNumber(FInscricaoMunicipal);
end;

function TNFSePrestador.RazaoSocial: string;
begin
  Result := FRazaoSocial.Trim.ToUpper;
end;

function TNFSePrestador.Endereco: string;
begin
  Result := FEndereco.Trim.ToUpper;
end;

function TNFSePrestador.Numero: string;
begin
  Result := FNumero.Trim.ToUpper;
end;

function TNFSePrestador.Bairro: string;
begin
  Result := FBairro.Trim.ToUpper;
end;

function TNFSePrestador.CEP: string;
begin
  Result := OnlyNumber(FCEP);
end;

function TNFSePrestador.Telefone: string;
begin
  Result := OnlyNumber(FTelefone);
end;

function TNFSePrestador.Email: string;
begin
  Result := FEmail.Trim.ToLower;
end;

function TNFSePrestador.Cidade: string;
begin
  Result := FCidade.Trim.ToUpper;
end;

function TNFSePrestador.UF: string;
begin
  Result := FUF.Trim.ToUpper;
end;

end.
