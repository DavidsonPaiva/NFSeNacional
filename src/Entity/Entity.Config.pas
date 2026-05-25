unit Entity.Config;

interface

uses
  System.SysUtils,
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  ACBrNFSeXConversao,
  ACBrDFe.Conversao;

type
  TNFSeConfig = class
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
    property CertificadoDigital : string read FCertificadoDigital write FCertificadoDigital;
    property PathResposta       : string read FPathResposta write FPathResposta;
    property PathSchemas        : string read FPathSchemas write FPathSchemas;
    property Ambiente           : TAcbrTipoAmbiente read FAmbiente write FAmbiente;
    property CaminhoLogoEmpresa : string read FCaminhoLogoEmpresa write FCaminhoLogoEmpresa;
    property CaminhoLogoPref    : string read FCaminhoLogoPref write FCaminhoLogoPref;
    property CodigoMunicipioIBGE: Integer read FCodigoMunicipioIBGE write FCodigoMunicipioIBGE;
    property NomePrefeitura     : string read FNomePrefeitura write FNomePrefeitura;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TNFSeConfig }

procedure TNFSeConfig.Clear;
begin
  FCertificadoDigital  := '';
  FPathResposta        := '';
  FPathSchemas         := '';
  FAmbiente            := TAcbrTipoAmbiente.taProducao;
  FCaminhoLogoPref     := '';
  FCodigoMunicipioIBGE := 4115200;
  FNomePrefeitura      := 'Prefeitura Municipal de Maringá';
end;

constructor TNFSeConfig.Create;
begin
  FCodigoMunicipioIBGE := 4115200;
  FNomePrefeitura      := 'Prefeitura Municipal de Maringá';
end;

destructor TNFSeConfig.Destroy;
begin

  inherited;
end;

end.
