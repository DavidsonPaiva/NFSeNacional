unit Controller.NFSE;

interface

uses
  System.SysUtils,
  System.Classes,
  Entity.Config,
  Entity.Data,
  Entity.Servico,
  Entity.Prestador,
  Entity.Tomador;

type
  IControllerNFSE = interface
    ['{06FD3211-69E5-43AF-A390-BEF904F3C5A3}']
    function Config(AValue: INFSeConfig): IControllerNFSE;
    function Data(AValue: INFSeData): IControllerNFSE;
    function Servico(AValue: INFSeServico): IControllerNFSE;
    function Tomador(AValue: INFSeTomador): IControllerNFSE;
    function Prestador(AValue: INFSePrestador): IControllerNFSE;
    procedure Send;
  end;

  TControllerNFSE = class(TInterfacedObject, IControllerNFSE)
  private
    FConfig   : INFSeConfig;
    FData     : INFSeData;
    FServico  : INFSeServico;
    FTomador  : INFSeTomador;
    FPrestador: INFSePrestador;
  protected
    function Config(AValue: INFSeConfig): IControllerNFSE;
    function Data(AValue: INFSeData): IControllerNFSE;
    function Servico(AValue: INFSeServico): IControllerNFSE;
    function Tomador(AValue: INFSeTomador): IControllerNFSE;
    function Prestador(AValue: INFSePrestador): IControllerNFSE;
    procedure Send;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IControllerNFSE;
  end;

implementation

{ TControllerNFSE }

uses
  Model.NFSE;

constructor TControllerNFSE.Create;
begin
end;

destructor TControllerNFSE.Destroy;
begin
  inherited;
end;

class function TControllerNFSE.New: IControllerNFSE;
begin
  Result := Self.Create;
end;

function TControllerNFSE.Config(AValue: INFSeConfig): IControllerNFSE;
begin
  Result  := Self;
  FConfig := AValue;
end;

function TControllerNFSE.Data(AValue: INFSeData): IControllerNFSE;
begin
  Result := Self;
  FData  := AValue;
end;

function TControllerNFSE.Servico(AValue: INFSeServico): IControllerNFSE;
begin
  Result   := Self;
  FServico := AValue;
end;

function TControllerNFSE.Prestador(AValue: INFSePrestador): IControllerNFSE;
begin
  Result     := Self;
  FPrestador := AValue;
end;

function TControllerNFSE.Tomador(AValue: INFSeTomador): IControllerNFSE;
begin
  Result   := Self;
  FTomador := AValue;
end;

procedure TControllerNFSE.Send;
begin
  if not Assigned(FConfig) then
    raise Exception.Create('Config não atribuída no Controller.');

  FConfig.Validate;

  if not Assigned(FData) then
    raise Exception.Create('Data não atribuída no Controller.');

  FData.Validate;

  if not Assigned(FServico) then
    raise Exception.Create('Serviço não atribuído no Controller.');

  FServico.Validate;

  if not Assigned(FPrestador) then
    raise Exception.Create('Prestador não atribuído no Controller.');

  FPrestador.Validate;

  if not Assigned(FTomador) then
    raise Exception.Create('Tomador não atribuído no Controller.');

  FTomador.Validate;

  TModelNFSE.New
    .Config(FConfig)
    .Data(FData)
    .Servico(FServico)
    .Prestador(FPrestador)
    .Tomador(FTomador)
    .Enviar;
end;

end.
