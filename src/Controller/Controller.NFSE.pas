unit Controller.NFSE;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections,
  Entity.Config,
  Entity.Data;

type
  IControllerNFSE = interface
    ['{06FD3211-69E5-43AF-A390-BEF904F3C5A3}']
    function Config(AValue: TNFSeConfig): IControllerNFSE;
    function Data(AValue: TNFSeData): IControllerNFSE;
    function Send: Boolean;
  end;

  TControllerNFSE = class(TInterfacedObject, IControllerNFSE)
  private
    FConfig: TNFSeConfig;
    FData  : TNFSeData;
  protected
    function Config(AValue: TNFSeConfig): IControllerNFSE;
    function Data(AValue: TNFSeData): IControllerNFSE;
    function Send: Boolean;
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

function TControllerNFSE.Data(AValue: TNFSeData): IControllerNFSE;
begin
  Result := Self;
  FData  := AValue;
end;

function TControllerNFSE.Config(AValue: TNFSeConfig): IControllerNFSE;
begin
  Result  := Self;
  FConfig := AValue;
end;

destructor TControllerNFSE.Destroy;
begin
  if Assigned(FConfig) then
    FConfig.Free;

  if Assigned(FData) then
    FData.Free;

  inherited;
end;

class function TControllerNFSE.New: IControllerNFSE;
begin
  Result := Self.Create;
end;

function TControllerNFSE.Send: Boolean;
begin
  if not Assigned(FConfig) then
    raise Exception.Create('Config not assigned.');

  if not Assigned(FData) then
    raise Exception.Create('Data not assigned.');

  Result := TModelNFSE.New.Config(FConfig).Data(FData).Send;
end;

end.
