unit Entity.Data;

interface

uses
  System.SysUtils,
  ACBrNFSeXConversao,
  ACBrDFe.Conversao;

type
  INFSeData = interface
    ['{09153998-E5FA-4800-8A9C-4003B0B30EF6}']
    function NumeroLote(AValue: Integer): INFSeData; overload;
    function NumeroLote: Integer; overload;

    function NumeroRPS(AValue: Integer): INFSeData; overload;
    function NumeroRPS: Integer; overload;

    function Serie(AValue: string): INFSeData; overload;
    function Serie: string; overload;

    function Competencia(AValue: TDateTime): INFSeData; overload;
    function Competencia: TDateTime; overload;

    function NaturezaOperacao(AValue: TnfseNaturezaOperacao): INFSeData; overload;
    function NaturezaOperacao: TnfseNaturezaOperacao; overload;

    function RegimeEspecialTributacao(AValue: TnfseRegimeEspecialTributacao): INFSeData; overload;
    function RegimeEspecialTributacao: TnfseRegimeEspecialTributacao; overload;

    function OptanteSimplesNacional(AValue: TnfseSimNao): INFSeData; overload;
    function OptanteSimplesNacional: TnfseSimNao; overload;

    function IncentivadorCultural(AValue: TnfseSimNao): INFSeData; overload;
    function IncentivadorCultural: TnfseSimNao; overload;

    procedure Clear;
  end;

  TNFSeData = class(TInterfacedObject, INFSeData)
  private
    FNumeroLote              : Integer;
    FNumeroRPS               : Integer;
    FSerie                   : string;
    FCompetencia             : TDateTime;
    FNaturezaOperacao        : TnfseNaturezaOperacao;
    FRegimeEspecialTributacao: TnfseRegimeEspecialTributacao;
    FOptanteSimplesNacional  : TnfseSimNao;
    FIncentivadorCultural    : TnfseSimNao;
  public
    function NumeroLote(AValue: Integer): INFSeData; overload;
    function NumeroLote: Integer; overload;

    function NumeroRPS(AValue: Integer): INFSeData; overload;
    function NumeroRPS: Integer; overload;

    function Serie(AValue: string): INFSeData; overload;
    function Serie: string; overload;

    function Competencia(AValue: TDateTime): INFSeData; overload;
    function Competencia: TDateTime; overload;

    function NaturezaOperacao(AValue: TnfseNaturezaOperacao): INFSeData; overload;
    function NaturezaOperacao: TnfseNaturezaOperacao; overload;

    function RegimeEspecialTributacao(AValue: TnfseRegimeEspecialTributacao): INFSeData; overload;
    function RegimeEspecialTributacao: TnfseRegimeEspecialTributacao; overload;

    function OptanteSimplesNacional(AValue: TnfseSimNao): INFSeData; overload;
    function OptanteSimplesNacional: TnfseSimNao; overload;

    function IncentivadorCultural(AValue: TnfseSimNao): INFSeData; overload;
    function IncentivadorCultural: TnfseSimNao; overload;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
    class function New: INFSeData;
  end;

implementation

{ TNFSeData }

constructor TNFSeData.Create;
begin
  Clear;
end;

destructor TNFSeData.Destroy;
begin
  inherited;
end;

class function TNFSeData.New: INFSeData;
begin
  Result := Self.Create;
end;

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
end;

function TNFSeData.NumeroLote(AValue: Integer): INFSeData;
begin
  Result      := Self;
  FNumeroLote := AValue;
end;

function TNFSeData.NumeroRPS(AValue: Integer): INFSeData;
begin
  Result     := Self;
  FNumeroRPS := AValue;
end;

function TNFSeData.Serie(AValue: string): INFSeData;
begin
  Result := Self;
  FSerie := AValue;
end;

function TNFSeData.Competencia(AValue: TDateTime): INFSeData;
begin
  Result       := Self;
  FCompetencia := AValue;
end;

function TNFSeData.NaturezaOperacao(AValue: TnfseNaturezaOperacao): INFSeData;
begin
  Result            := Self;
  FNaturezaOperacao := AValue;
end;

function TNFSeData.RegimeEspecialTributacao(AValue: TnfseRegimeEspecialTributacao): INFSeData;
begin
  Result                    := Self;
  FRegimeEspecialTributacao := AValue;
end;

function TNFSeData.OptanteSimplesNacional(AValue: TnfseSimNao): INFSeData;
begin
  Result                  := Self;
  FOptanteSimplesNacional := AValue;
end;

function TNFSeData.IncentivadorCultural(AValue: TnfseSimNao): INFSeData;
begin
  Result                := Self;
  FIncentivadorCultural := AValue;
end;

function TNFSeData.NumeroLote: Integer;
begin
  Result := FNumeroLote;
end;

function TNFSeData.NumeroRPS: Integer;
begin
  Result := FNumeroRPS;
end;

function TNFSeData.Serie: string;
begin
  Result := FSerie.Trim.ToUpper;
end;

function TNFSeData.Competencia: TDateTime;
begin
  Result := FCompetencia;
end;

function TNFSeData.NaturezaOperacao: TnfseNaturezaOperacao;
begin
  Result := FNaturezaOperacao;
end;

function TNFSeData.RegimeEspecialTributacao: TnfseRegimeEspecialTributacao;
begin
  Result := FRegimeEspecialTributacao;
end;

function TNFSeData.OptanteSimplesNacional: TnfseSimNao;
begin
  Result := FOptanteSimplesNacional;
end;

function TNFSeData.IncentivadorCultural: TnfseSimNao;
begin
  Result := FIncentivadorCultural;
end;

end.
