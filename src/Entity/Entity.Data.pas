unit Entity.Data;

interface

uses
  System.SysUtils,
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  ACBrNFSeXConversao,
  ACBrDFe.Conversao;

type
  TNFSeDataTomador = class
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
    property CNPJ               : string read FCNPJ write FCNPJ;
    property RazaoSocial        : string read FRazaoSocial write FRazaoSocial;
    property Endereco           : string read FEndereco write FEndereco;
    property Numero             : string read FNumero write FNumero;
    property Complemento        : string read FComplemento write FComplemento;
    property Bairro             : string read FBairro write FBairro;
    property CodigoMunicipioIBGE: Integer read FCodigoMunicipioIBGE write FCodigoMunicipioIBGE;
    property UF                 : string read FUF write FUF;
    property CEP                : string read FCEP write FCEP;
    property Telefone           : string read FTelefone write FTelefone;
    property Email              : string read FEmail write FEmail;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
  end;

  TNFSeDataPrestador = class
  private
    FCNPJ              : string;
    FInscricaoMunicipal: string;
    FRazaoSocial       : string;
    FEndereco          : string;
    FNumero            : string;
    FBairro            : string;
    FCEP               : string;
    FTelefone          : string;
    FCidade            : String;
    FEmail             : string;
    FUF                : string;
  public
    property CNPJ              : string read FCNPJ write FCNPJ;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property RazaoSocial       : string read FRazaoSocial write FRazaoSocial;
    property Endereco          : string read FEndereco write FEndereco;
    property Numero            : string read FNumero write FNumero;
    property Bairro            : string read FBairro write FBairro;
    property CEP               : string read FCEP write FCEP;
    property Telefone          : string read FTelefone write FTelefone;
    property Email             : string read FEmail write FEmail;
    property Cidade            : String read FCidade write FCidade;
    property UF                : string read FUF write FUF;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
  end;

  TNFSeDataServices = class
  private
    FIssRetido    : TnfseSituacaoTributaria;
    FBaseCalculo  : Double;
    FAliquota     : Double;
    FValor        : Double;
    FCodigoTribNac: string;
    FCodigoTribMun: string;
    FCNAE         : string;
    FCodigoNBS    : string;
    FDiscriminacao: string;
    FPrestador    : TNFSeDataPrestador;
    FTomador      : TNFSeDataTomador;
  public
    property IssRetido    : TnfseSituacaoTributaria read FIssRetido write FIssRetido;
    property BaseCalculo  : Double read FBaseCalculo write FBaseCalculo;
    property Aliquota     : Double read FAliquota write FAliquota;
    property Valor        : Double read FValor write FValor;
    property CodigoTribNac: string read FCodigoTribNac write FCodigoTribNac;
    property CodigoTribMun: string read FCodigoTribMun write FCodigoTribMun;
    property CNAE         : string read FCNAE write FCNAE;
    property CodigoNBS    : string read FCodigoNBS write FCodigoNBS;
    property Discriminacao: string read FDiscriminacao write FDiscriminacao;
    property Prestador    : TNFSeDataPrestador read FPrestador write FPrestador;
    property Tomador      : TNFSeDataTomador read FTomador write FTomador;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
  end;

  TNFSeData = class
  private
    FNumeroLote              : Integer;
    FNumeroRPS               : Integer;
    FSerie                   : string;
    FCompetencia             : TDateTime;
    FNaturezaOperacao        : TnfseNaturezaOperacao;
    FRegimeEspecialTributacao: TnfseRegimeEspecialTributacao;
    FOptanteSimplesNacional  : TnfseSimNao;
    FIncentivadorCultural    : TnfseSimNao;
    FServico                 : TNFSeDataServices;

  public
    property NumeroLote              : Integer read FNumeroLote write FNumeroLote;
    property NumeroRPS               : Integer read FNumeroRPS write FNumeroRPS;
    property Serie                   : string read FSerie write FSerie;
    property Competencia             : TDateTime read FCompetencia write FCompetencia;
    property NaturezaOperacao        : TnfseNaturezaOperacao read FNaturezaOperacao write FNaturezaOperacao;
    property RegimeEspecialTributacao: TnfseRegimeEspecialTributacao read FRegimeEspecialTributacao write FRegimeEspecialTributacao;
    property OptanteSimplesNacional  : TnfseSimNao read FOptanteSimplesNacional write FOptanteSimplesNacional;
    property IncentivadorCultural    : TnfseSimNao read FIncentivadorCultural write FIncentivadorCultural;
    property Servico                 : TNFSeDataServices read FServico write FServico;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
  end;

implementation


{ TNFSeData }

procedure TNFSeData.Clear;
begin
  FNumeroLote               := 0;
  FNumeroRPS                := 0;
  FSerie                    := '';
  FCompetencia              := Date;
  FNaturezaOperacao         := TnfseNaturezaOperacao.no0; // 'Tributação no município'
  FRegimeEspecialTributacao := TnfseRegimeEspecialTributacao.retNenhum;
  FOptanteSimplesNacional   := TnfseSimNao.snNao;
  FIncentivadorCultural     := TnfseSimNao.snNao;

  FServico.Clear;
end;

constructor TNFSeData.Create;
begin
  FServico := TNFSeDataServices.Create;

  FCompetencia      := Date;
  FNaturezaOperacao := TnfseNaturezaOperacao.no0; // 'Tributação no município';
end;

destructor TNFSeData.Destroy;
begin
  FServico.Free;
  inherited;
end;

{ TNFSeDataServices }

procedure TNFSeDataServices.Clear;
begin
  FIssRetido     := TnfseSituacaoTributaria.stNormal;
  FBaseCalculo   := 0;
  FAliquota      := 0;
  FValor         := 0;
  FCodigoTribNac := '150505';
  FCodigoTribMun := '001';
  FCNAE          := '6203100';
  FCodigoNBS     := '111032200';
  FDiscriminacao := 'SERVICO';

  FPrestador.Clear;
  FTomador.Clear;
end;

constructor TNFSeDataServices.Create;
begin
  FPrestador := TNFSeDataPrestador.Create;
  FTomador   := TNFSeDataTomador.Create;

  FIssRetido     := TnfseSituacaoTributaria.stNormal;
  FBaseCalculo   := 0;
  FAliquota      := 0;
  FValor         := 0;
  FCodigoTribNac := '010501';
  FCodigoTribMun := '001';
  FCodigoNBS     := '111032200';
  FDiscriminacao := 'SERVICO';
end;

destructor TNFSeDataServices.Destroy;
begin
  FPrestador.Free;
  FTomador.Free;
  inherited;
end;

{ TNFSeDataPrestador }

procedure TNFSeDataPrestador.Clear;
begin
  FCNPJ               := '';
  FInscricaoMunicipal := '';
  FRazaoSocial        := '';
  FEndereco           := '';
  FNumero             := '';
  FBairro             := '';
  FCEP                := '';
  FTelefone           := '';
  FEmail              := '';
  FCidade             := '';
  FUF                 := '';
end;

constructor TNFSeDataPrestador.Create;
begin
end;

destructor TNFSeDataPrestador.Destroy;
begin
  inherited;
end;

{ TNFSeDataTomador }

procedure TNFSeDataTomador.Clear;
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
end;

constructor TNFSeDataTomador.Create;
begin
  FCodigoMunicipioIBGE := 4115200;
end;

destructor TNFSeDataTomador.Destroy;
begin
  inherited;
end;

end.
