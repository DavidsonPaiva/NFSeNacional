unit Entity.Tomador;

interface

uses
  System.SysUtils,
  ACBrUtil.Strings;

type
  INFSeTomador = interface
    ['{0CB69410-6175-4023-B4BE-37985BAE3067}']
    function CNPJ(AValue: string): INFSeTomador; overload;
    function CNPJ: string; overload;

    function RazaoSocial(AValue: string): INFSeTomador; overload;
    function RazaoSocial: string; overload;

    function Endereco(AValue: string): INFSeTomador; overload;
    function Endereco: string; overload;

    function Numero(AValue: string): INFSeTomador; overload;
    function Numero: string; overload;

    function Complemento(AValue: string): INFSeTomador; overload;
    function Complemento: string; overload;

    function Bairro(AValue: string): INFSeTomador; overload;
    function Bairro: string; overload;

    function CodigoMunicipioIBGE(AValue: Integer): INFSeTomador; overload;
    function CodigoMunicipioIBGE: Integer; overload;

    function UF(AValue: string): INFSeTomador; overload;
    function UF: string; overload;

    function CEP(AValue: string): INFSeTomador; overload;
    function CEP: string; overload;

    function Telefone(AValue: string): INFSeTomador; overload;
    function Telefone: string; overload;

    function Email(AValue: string): INFSeTomador; overload;
    function Email: string; overload;

    procedure Clear;
  end;

  TNFSeTomador = class(TInterfacedObject, INFSeTomador)
  private
    FCNPJ               : string;
    FRazaoSocial        : string;
    FEndereco           : string;
    FNumero             : string;
    FComplemento        : string;
    FBairro             : string;
    FCodigoMunicipioIBGE: Integer;
    FUF                 : string;
    FCEP                : string;
    FTelefone           : string;
    FEmail              : string;
  public
    function CNPJ(AValue: string): INFSeTomador; overload;
    function CNPJ: string; overload;

    function RazaoSocial(AValue: string): INFSeTomador; overload;
    function RazaoSocial: string; overload;

    function Endereco(AValue: string): INFSeTomador; overload;
    function Endereco: string; overload;

    function Numero(AValue: string): INFSeTomador; overload;
    function Numero: string; overload;

    function Complemento(AValue: string): INFSeTomador; overload;
    function Complemento: string; overload;

    function Bairro(AValue: string): INFSeTomador; overload;
    function Bairro: string; overload;

    function CodigoMunicipioIBGE(AValue: Integer): INFSeTomador; overload;
    function CodigoMunicipioIBGE: Integer; overload;

    function UF(AValue: string): INFSeTomador; overload;
    function UF: string; overload;

    function CEP(AValue: string): INFSeTomador; overload;
    function CEP: string; overload;

    function Telefone(AValue: string): INFSeTomador; overload;
    function Telefone: string; overload;

    function Email(AValue: string): INFSeTomador; overload;
    function Email: string; overload;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
    class function New: INFSeTomador;
  end;

implementation

{ TNFSeTomador }

constructor TNFSeTomador.Create;
begin
  Clear;
end;

destructor TNFSeTomador.Destroy;
begin
  inherited;
end;

class function TNFSeTomador.New: INFSeTomador;
begin
  Result := Self.Create;
end;

procedure TNFSeTomador.Clear;
begin
  FCNPJ                := '';
  FRazaoSocial         := '';
  FEndereco            := '';
  FNumero              := '';
  FComplemento         := '';
  FBairro              := '';
  FCodigoMunicipioIBGE := 4115200;
  FCEP                 := '';
  FTelefone            := '';
  FEmail               := '';
  FUF                  := '';
end;

function TNFSeTomador.CNPJ(AValue: string): INFSeTomador;
begin
  Result := Self;
  FCNPJ  := AValue;
end;

function TNFSeTomador.RazaoSocial(AValue: string): INFSeTomador;
begin
  Result       := Self;
  FRazaoSocial := AValue;
end;

function TNFSeTomador.Endereco(AValue: string): INFSeTomador;
begin
  Result    := Self;
  FEndereco := AValue;
end;

function TNFSeTomador.Numero(AValue: string): INFSeTomador;
begin
  Result  := Self;
  FNumero := AValue;
end;

function TNFSeTomador.Complemento(AValue: string): INFSeTomador;
begin
  Result       := Self;
  FComplemento := AValue;
end;

function TNFSeTomador.Bairro(AValue: string): INFSeTomador;
begin
  Result  := Self;
  FBairro := AValue;
end;

function TNFSeTomador.CodigoMunicipioIBGE(AValue: Integer): INFSeTomador;
begin
  Result               := Self;
  FCodigoMunicipioIBGE := AValue;
end;

function TNFSeTomador.UF(AValue: string): INFSeTomador;
begin
  Result := Self;
  FUF    := AValue;
end;

function TNFSeTomador.CEP(AValue: string): INFSeTomador;
begin
  Result := Self;
  FCEP   := AValue;
end;

function TNFSeTomador.Telefone(AValue: string): INFSeTomador;
begin
  Result    := Self;
  FTelefone := AValue;
end;

function TNFSeTomador.Email(AValue: string): INFSeTomador;
begin
  Result := Self;
  FEmail := AValue;
end;

function TNFSeTomador.CNPJ: string;
begin
  Result := OnlyNumber(FCNPJ);
end;

function TNFSeTomador.RazaoSocial: string;
begin
  Result := FRazaoSocial.Trim.ToUpper;
end;

function TNFSeTomador.Endereco: string;
begin
  Result := FEndereco.Trim.ToUpper;
end;

function TNFSeTomador.Numero: string;
begin
  Result := FNumero.Trim.ToUpper;
end;

function TNFSeTomador.Complemento: string;
begin
  Result := FComplemento.Trim.ToUpper;
end;

function TNFSeTomador.Bairro: string;
begin
  Result := FBairro.Trim.ToUpper;
end;

function TNFSeTomador.CodigoMunicipioIBGE: Integer;
begin
  Result := FCodigoMunicipioIBGE;
end;

function TNFSeTomador.UF: string;
begin
  Result := FUF.Trim.ToUpper;
end;

function TNFSeTomador.CEP: string;
begin
  Result := OnlyNumber(FCEP);
end;

function TNFSeTomador.Telefone: string;
begin
  Result := OnlyNumber(FTelefone);
end;

function TNFSeTomador.Email: string;
begin
  Result := FEmail.Trim.ToLower;
end;

end.
