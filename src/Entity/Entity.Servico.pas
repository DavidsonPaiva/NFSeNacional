unit Entity.Servico;

interface

uses
  System.SysUtils,
  ACBrUtil.Strings,
  ACBrNFSeXConversao;

type
  INFSeServico = interface
    ['{677E5470-E322-44D4-9631-78316A7C7C40}']
    function IssRetido(AValue: TnfseSituacaoTributaria): INFSeServico; overload;
    function IssRetido: TnfseSituacaoTributaria; overload;

    function BaseCalculo(AValue: Double): INFSeServico; overload;
    function BaseCalculo: Double; overload;

    function Aliquota(AValue: Double): INFSeServico; overload;
    function Aliquota: Double; overload;

    function Valor(AValue: Double): INFSeServico; overload;
    function Valor: Double; overload;

    function CodigoTribNac(AValue: string): INFSeServico; overload;
    function CodigoTribNac: string; overload;

    function CodigoTribMun(AValue: string): INFSeServico; overload;
    function CodigoTribMun: string; overload;

    function CNAE(AValue: string): INFSeServico; overload;
    function CNAE: string; overload;

    function CodigoNBS(AValue: string): INFSeServico; overload;
    function CodigoNBS: string; overload;

    function Discriminacao(AValue: string): INFSeServico; overload;
    function Discriminacao: string; overload;

    procedure Clear;
  end;

  TNFSeServico = class(TInterfacedObject, INFSeServico)
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
  public
    function IssRetido(AValue: TnfseSituacaoTributaria): INFSeServico; overload;
    function IssRetido: TnfseSituacaoTributaria; overload;

    function BaseCalculo(AValue: Double): INFSeServico; overload;
    function BaseCalculo: Double; overload;

    function Aliquota(AValue: Double): INFSeServico; overload;
    function Aliquota: Double; overload;

    function Valor(AValue: Double): INFSeServico; overload;
    function Valor: Double; overload;

    function CodigoTribNac(AValue: string): INFSeServico; overload;
    function CodigoTribNac: string; overload;

    function CodigoTribMun(AValue: string): INFSeServico; overload;
    function CodigoTribMun: string; overload;

    function CNAE(AValue: string): INFSeServico; overload;
    function CNAE: string; overload;

    function CodigoNBS(AValue: string): INFSeServico; overload;
    function CodigoNBS: string; overload;

    function Discriminacao(AValue: string): INFSeServico; overload;
    function Discriminacao: string; overload;

    procedure Clear;

    constructor Create;
    destructor Destroy; override;
    class function New: INFSeServico;
  end;

implementation

{ TNFSeServico }

constructor TNFSeServico.Create;
begin
  Clear;
end;

destructor TNFSeServico.Destroy;
begin
  inherited;
end;

class function TNFSeServico.New: INFSeServico;
begin
  Result := Self.Create;
end;

procedure TNFSeServico.Clear;
begin
  FIssRetido     := TnfseSituacaoTributaria.stNormal;
  FBaseCalculo   := 0;
  FAliquota      := 0;
  FValor         := 0;
  FCodigoTribNac := '010501';
  FCodigoTribMun := '001';
  FCNAE          := '6203100';
  FCodigoNBS     := '111032200';
  FDiscriminacao := 'SERVICO';
end;

function TNFSeServico.IssRetido(AValue: TnfseSituacaoTributaria): INFSeServico;
begin
  Result     := Self;
  FIssRetido := AValue;
end;

function TNFSeServico.BaseCalculo(AValue: Double): INFSeServico;
begin
  Result       := Self;
  FBaseCalculo := AValue;
end;

function TNFSeServico.Aliquota(AValue: Double): INFSeServico;
begin
  Result    := Self;
  FAliquota := AValue;
end;

function TNFSeServico.Valor(AValue: Double): INFSeServico;
begin
  Result := Self;
  FValor := AValue;
end;

function TNFSeServico.CodigoTribNac(AValue: string): INFSeServico;
begin
  Result         := Self;
  FCodigoTribNac := AValue;
end;

function TNFSeServico.CodigoTribMun(AValue: string): INFSeServico;
begin
  Result         := Self;
  FCodigoTribMun := AValue;
end;

function TNFSeServico.CNAE(AValue: string): INFSeServico;
begin
  Result := Self;
  FCNAE  := AValue;
end;

function TNFSeServico.CodigoNBS(AValue: string): INFSeServico;
begin
  Result     := Self;
  FCodigoNBS := AValue;
end;

function TNFSeServico.Discriminacao(AValue: string): INFSeServico;
begin
  Result         := Self;
  FDiscriminacao := AValue;
end;

function TNFSeServico.IssRetido: TnfseSituacaoTributaria;
begin
  Result := FIssRetido;
end;

function TNFSeServico.BaseCalculo: Double;
begin
  Result := FBaseCalculo;
end;

function TNFSeServico.Aliquota: Double;
begin
  Result := FAliquota;
end;

function TNFSeServico.Valor: Double;
begin
  Result := FValor;
end;

function TNFSeServico.CodigoTribNac: string;
begin
  Result := OnlyNumber(FCodigoTribNac);
end;

function TNFSeServico.CodigoTribMun: string;
begin
  Result := OnlyNumber(FCodigoTribMun);
end;

function TNFSeServico.CNAE: string;
begin
  Result := OnlyNumber(FCNAE);
end;

function TNFSeServico.CodigoNBS: string;
begin
  Result := OnlyNumber(FCodigoNBS);
end;

function TNFSeServico.Discriminacao: string;
begin
  Result := FDiscriminacao.Trim.ToUpper;
end;

end.
