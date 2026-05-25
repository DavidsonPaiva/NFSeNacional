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
  Entity.Servico,
  Entity.Prestador,
  Entity.Tomador,
  ACBrNFSeXConversao,
  ACBrDFe.Conversao;

procedure TfrmPrincipal.btnGerarClick(Sender: TObject);
var
  lConfig   : INFSeConfig;
  lData     : INFSeData;
  lServico  : INFSeServico;
  lPrestador: INFSePrestador;
  lTomador  : INFSeTomador;
begin

  lConfig := TNFSeConfig.New
    .CertificadoDigital('AUHUHQUHUSHUHSUA')
    .PathResposta('C:\Temp')
    .PathSchemas('C:\Temp\Schemas')
    .Ambiente(taProducao)
    .CodigoMunicipioIBGE(4115200) // Maringa/PR
    .NomePrefeitura('Prefeitura Municipal de Maringá');

  lData := TNFSeData.New
    .NumeroRPS(1)
    .Serie('1')
    .Competencia(Date)
    .NaturezaOperacao(TnfseNaturezaOperacao.no0)
    .RegimeEspecialTributacao(retNenhum)
    .OptanteSimplesNacional(snNao)
    .IncentivadorCultural(snNao);

  lServico := TNFSeServico.New
    .IssRetido(stNormal)
    .BaseCalculo(100)
    .Aliquota(3)
    .Valor(100)
    .CodigoTribNac('150505') // https://www.gov.br/nfse/pt-br/mei-e-demais-empresas/codigos-de-tributacao-nacional-nbs
    .CodigoTribMun('001')
    .CNAE('6203100')
    .CodigoNBS('111032200')
    .Discriminacao('SERVIÇO DE EMISSAO DE NOTA');

  lPrestador := TNFSePrestador.New
    .CNPJ('')
    .InscricaoMunicipal('')
    .RazaoSocial('PAIVA SISTEMA LTDA')
    .Endereco('RUA CORONEL ATHOS PEREIRA DA SILVEIRA')
    .Numero('1840')
    .Bairro('JD. SAO CONRADO')
    .CEP('79093782')
    .Cidade('CAMPO GRANDE')
    .UF('MS')
    .Telefone('67992677349')
    .Email('contato@paiva.app.br');

  lTomador := TNFSeTomador.New
    .CNPJ('')
    .RazaoSocial('EMPRESA DESTINO')
    .Endereco('RUA DA EMPRESA DESTINO')
    .Numero('100')
    .Complemento('SALA 22')
    .Bairro('BAIRRO')
    .CodigoMunicipioIBGE(4115200) // Maringa/PR
    .UF('PR')
    .CEP('87015440')
    .Telefone('4699999999')
    .Email('meucliente@email.com.br');

  TControllerNFSE.New
    .Config(lConfig)
    .Data(lData)
    .Servico(lServico)
    .Prestador(lPrestador)
    .Tomador(lTomador)
    .Send;
end;

end.
