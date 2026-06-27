unit Model.NFSE.CampoGrande;

interface

uses
  Model.NFSE;

type
  TModelNFSECampoGrande = class(TModelNFSE)
  protected
    procedure setData; override;
  end;

implementation

uses
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXConversao,
  System.SysUtils;

{ TModelNFSECampoGrande }

procedure TModelNFSECampoGrande.setData;
var
  lNota: TNotaFiscal;
begin
  inherited;

  lNota := FNFSE.NotasFiscais.Items[0];

  // Exemplo: Campo Grande pode exigir alguma tag de incentivo fiscal ou regime diferente
  // lNota.NFSE.RegimeEspecialTributacao := retMicroempresaMunicipal;
  // lNota.NFSE.IncentivadorCultural     := snNao;
end;

end.
