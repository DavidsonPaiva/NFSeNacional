unit View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  ACBrBase,
  ACBrDFeReport,
  ACBrNFSeXDANFSeClass,
  ACBrNFSeXDANFSeRLClass;

type
  TfrmPrincipal = class(TForm)
    btnGerar: TBitBtn;
    procedure btnGerarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}


uses
  Controller.NFSE,
  Entity.Config,
  Entity.Data,
  ACBrNFSeXConversao,
  ACBrDFe.Conversao;

procedure TfrmPrincipal.btnGerarClick(Sender: TObject);
var
  lConfig: TNFSeConfig;
  lData  : TNFSeData;
begin
  lConfig := TNFSeConfig.Create; // Não precisa destruir pois o controller se encarrega disso
  lData   := TNFSeData.Create;

  lConfig.CertificadoDigital  := 'AUHUHQUHUSHUHSUA';
  lConfig.PathResposta        := 'C:\Temp';
  lConfig.PathSchemas         := 'C:\Temp\Schemas';
  lConfig.Ambiente            := taProducao;
  lConfig.CodigoMunicipioIBGE := 4115200; // Maringa/PR
  lConfig.NomePrefeitura      := 'Prefeitura Municipal de Maringá';

  lData.NumeroRPS                := 1;
  lData.Serie                    := '1';
  lData.Competencia              := Date;
  lData.NaturezaOperacao         := TnfseNaturezaOperacao.no0;
  lData.RegimeEspecialTributacao := retNenhum;
  lData.OptanteSimplesNacional   := snNao;
  lData.IncentivadorCultural     := snNao;

  lData.Servico.IssRetido     := stNormal;
  lData.Servico.BaseCalculo   := 100;
  lData.Servico.Aliquota      := 3;
  lData.Servico.Valor         := 100;
  lData.Servico.CodigoTribNac := '150505'; // https://www.gov.br/nfse/pt-br/mei-e-demais-empresas/codigos-de-tributacao-nacional-nbs
  lData.Servico.CodigoTribMun := '001';
  lData.Servico.CNAE          := '6203100';
  lData.Servico.CodigoNBS     := '111032200';
  lData.Servico.Discriminacao := 'SERVIÇO DE EMISSAO DE NOTA';

  lData.Servico.Prestador.CNPJ               := '';
  lData.Servico.Prestador.InscricaoMunicipal := '';
  lData.Servico.Prestador.RazaoSocial        := 'PAIVA SISTEMA LTDA';
  lData.Servico.Prestador.Endereco           := 'RUA CORONEL ATHOS PEREIRA DA SILVEIRA';
  lData.Servico.Prestador.Numero             := '1840';
  lData.Servico.Prestador.Bairro             := 'JD. SAO CONRADO';
  lData.Servico.Prestador.CEP                := '79093782';
  lData.Servico.Prestador.Cidade             := 'CAMPO GRANDE';
  lData.Servico.Prestador.UF                 := 'MS';
  lData.Servico.Prestador.Telefone           := '67992677349';
  lData.Servico.Prestador.Email              := 'contato@paiva.app.br';

  lData.Servico.Tomador.CNPJ                := '';
  lData.Servico.Tomador.RazaoSocial         := 'EMPRESA DESTINO';
  lData.Servico.Tomador.Endereco            := 'RUA DA EMPRESA DESTINO';
  lData.Servico.Tomador.Numero              := '100';
  lData.Servico.Tomador.Complemento         := 'SALA 22';
  lData.Servico.Tomador.Bairro              := 'BAIRRO';
  lData.Servico.Tomador.CodigoMunicipioIBGE := 4115200; // Maringa/PR
  lData.Servico.Tomador.UF                  := 'PR';
  lData.Servico.Tomador.CEP                 := '87015440';
  lData.Servico.Tomador.Telefone            := '4699999999';
  lData.Servico.Tomador.Email               := 'meucliente@email.com.br';

  TControllerNFSE.New.Config(lConfig).Data(lData).Send;
end;

end.
