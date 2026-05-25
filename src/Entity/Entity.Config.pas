unit Entity.Config;

interface

uses
  System.SysUtils,
  ACBrDFe.Conversao;

type
  INFSeConfig = interface
    ['{7C5427A5-0865-409C-A3AA-45C872FDDB72}']
    function CertificadoDigital(AValue: string): INFSeConfig; overload;
    function CertificadoDigital: string; overload;

    function PathResposta(AValue: string): INFSeConfig; overload;
    function PathResposta: string; overload;

    function PathSchemas(AValue: string): INFSeConfig; overload;
    function PathSchemas: string; overload;

    function Ambiente(AValue: TAcbrTipoAmbiente): INFSeConfig; overload;
    function Ambiente: TAcbrTipoAmbiente; overload;

    function CaminhoLogoEmpresa(AValue: string): INFSeConfig; overload;
    function CaminhoLogoEmpresa: string; overload;

    function CaminhoLogoPref(AValue: string): INFSeConfig; overload;
    function CaminhoLogoPref: string; overload;

    function CodigoMunicipioIBGE(AValue: Integer): INFSeConfig; overload;
    function CodigoMunicipioIBGE: Integer; overload;

    function NomePrefeitura(AValue: string): INFSeConfig; overload;
    function NomePrefeitura: string; overload;

    procedure Clear;
  end;

  TNFSeConfig = class(TInterfacedObject, INFSeConfig)
  private
    FCertificadoDigital : string;
    FPathResposta       : string;
    FPathSchemas        : string;
    FAmbiente           : TAcbrTipoAmbiente;
    FCaminhoLogoPref    : string;
    FCodigoMunicipioIBGE: Integer;
    FNomePrefeitura     : string;
    FCaminhoLogoEmpresa : string;
  public
    function CertificadoDigital(AValue: string): INFSeConfig; overload;
    function CertificadoDigital: string; overload;

    function PathResposta(AValue: string): INFSeConfig; overload;
    function PathResposta: string; overload;

    function PathSchemas(AValue: string): INFSeConfig; overload;
    function PathSchemas: string; overload;

    function Ambiente(AValue: TAcbrTipoAmbiente): INFSeConfig; overload;
    function Ambiente: TAcbrTipoAmbiente; overload;

    function CaminhoLogoEmpresa(AValue: string): INFSeConfig; overload;
    function CaminhoLogoEmpresa: string; overload;

    function CaminhoLogoPref(AValue: string): INFSeConfig; overload;
    function CaminhoLogoPref: string; overload;

    function CodigoMunicipioIBGE(AValue: Integer): INFSeConfig; overload;
    function CodigoMunicipioIBGE: Integer; overload;

    function NomePrefeitura(AValue: string): INFSeConfig; overload;
    function NomePrefeitura: string; overload;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
    class function New: INFSeConfig;
  end;

implementation

{ TNFSeConfig }

constructor TNFSeConfig.Create;
begin
  Clear;
end;

destructor TNFSeConfig.Destroy;
begin
  inherited;
end;

class function TNFSeConfig.New: INFSeConfig;
begin
  Result := Self.Create;
end;

procedure TNFSeConfig.Clear;
begin
  FCertificadoDigital  := '';
  FPathResposta        := '';
  FPathSchemas         := '';
  FAmbiente            := TAcbrTipoAmbiente.taProducao;
  FCaminhoLogoPref     := '';
  FCaminhoLogoEmpresa  := '';
  FCodigoMunicipioIBGE := 4115200;
  FNomePrefeitura      := 'Prefeitura Municipal de Maringá';
end;

function TNFSeConfig.CertificadoDigital(AValue: string): INFSeConfig;
begin
  Result              := Self;
  FCertificadoDigital := AValue;
end;

function TNFSeConfig.PathResposta(AValue: string): INFSeConfig;
begin
  Result        := Self;
  FPathResposta := AValue;
end;

function TNFSeConfig.PathSchemas(AValue: string): INFSeConfig;
begin
  Result       := Self;
  FPathSchemas := AValue;
end;

function TNFSeConfig.Ambiente(AValue: TAcbrTipoAmbiente): INFSeConfig;
begin
  Result    := Self;
  FAmbiente := AValue;
end;

function TNFSeConfig.CaminhoLogoEmpresa(AValue: string): INFSeConfig;
begin
  Result              := Self;
  FCaminhoLogoEmpresa := AValue;
end;

function TNFSeConfig.CaminhoLogoPref(AValue: string): INFSeConfig;
begin
  Result           := Self;
  FCaminhoLogoPref := AValue;
end;

function TNFSeConfig.CodigoMunicipioIBGE(AValue: Integer): INFSeConfig;
begin
  Result               := Self;
  FCodigoMunicipioIBGE := AValue;
end;

function TNFSeConfig.NomePrefeitura(AValue: string): INFSeConfig;
begin
  Result          := Self;
  FNomePrefeitura := AValue;
end;

function TNFSeConfig.CertificadoDigital: string;
begin
  Result := FCertificadoDigital;
end;

function TNFSeConfig.PathResposta: string;
begin
  Result := FPathResposta;
end;

function TNFSeConfig.PathSchemas: string;
begin
  Result := FPathSchemas;
end;

function TNFSeConfig.Ambiente: TAcbrTipoAmbiente;
begin
  Result := FAmbiente;
end;

function TNFSeConfig.CaminhoLogoEmpresa: string;
begin
  Result := FCaminhoLogoEmpresa;
end;

function TNFSeConfig.CaminhoLogoPref: string;
begin
  Result := FCaminhoLogoPref;
end;

function TNFSeConfig.CodigoMunicipioIBGE: Integer;
begin
  Result := FCodigoMunicipioIBGE;
end;

function TNFSeConfig.NomePrefeitura: string;
begin
  Result := FNomePrefeitura;
end;

end.
