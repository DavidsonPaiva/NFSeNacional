unit Entity.ReformaTributaria;

interface

uses
  System.SysUtils,
  ACBrUtil.Strings,
  ACBrDFe.Conversao,
  ACBrNFSeXConversao;

type
  INFSeReformaTrib = interface
    ['{06257564-155E-4066-9CCD-34FFAF7203DD}']
    function IndicadorOperacao(AValue: string): INFSeReformaTrib; overload;
    function IndicadorOperacao: string; overload;

    function CST(AValue: TCSTIBSCBS): INFSeReformaTrib; overload;
    function CST: TCSTIBSCBS; overload;

    function ClassTrib(AValue: string): INFSeReformaTrib; overload;
    function ClassTrib: string; overload;

    procedure Clear;
    procedure Validate;
  end;

  TNFSeReformaTrib = class(TInterfacedObject, INFSeReformaTrib)
  private
    FIndicadorOperacao: string;
    FCST              : TCSTIBSCBS;
    FClassTrib        : string;
  public
    function IndicadorOperacao(AValue: string): INFSeReformaTrib; overload;
    function IndicadorOperacao: string; overload;

    function CST(AValue: TCSTIBSCBS): INFSeReformaTrib; overload;
    function CST: TCSTIBSCBS; overload;

    function ClassTrib(AValue: string): INFSeReformaTrib; overload;
    function ClassTrib: string; overload;

    procedure Clear;
    procedure Validate;

    constructor Create;
    destructor Destroy; override;
    class function New: INFSeReformaTrib;
  end;

implementation

{ TNFSeReformaTrib }

constructor TNFSeReformaTrib.Create;
begin
  Clear;
end;

destructor TNFSeReformaTrib.Destroy;
begin
  inherited;
end;

class function TNFSeReformaTrib.New: INFSeReformaTrib;
begin
  Result := Self.Create;
end;

function TNFSeReformaTrib.IndicadorOperacao(AValue: string): INFSeReformaTrib;
begin
  Result             := Self;
  FIndicadorOperacao := AValue;
end;

function TNFSeReformaTrib.IndicadorOperacao: string;
begin
  Result := FIndicadorOperacao;
end;

function TNFSeReformaTrib.CST(AValue: TCSTIBSCBS): INFSeReformaTrib;
begin
  Result := Self;
  FCST   := AValue;
end;

function TNFSeReformaTrib.CST: TCSTIBSCBS;
begin
  Result := FCST;
end;

function TNFSeReformaTrib.ClassTrib(AValue: string): INFSeReformaTrib;
begin
  Result     := Self;
  FClassTrib := AValue;
end;

function TNFSeReformaTrib.ClassTrib: string;
begin
  Result := FClassTrib;
end;

procedure TNFSeReformaTrib.Clear;
begin
  FIndicadorOperacao := EmptyStr;
  FCST               := cstNenhum;
  FClassTrib         := EmptyStr;
end;

procedure TNFSeReformaTrib.Validate;
begin
  if FIndicadorOperacao.Trim.IsEmpty then
    raise Exception.Create('Favor preencher o indicador da operação.');

  if FClassTrib.Trim.IsEmpty then
    raise Exception.Create('Favor preencher a classificação tributária.');

  if FCST = cstNenhum then
    raise Exception.Create('Favor preencher o CST.');
end;

end.
