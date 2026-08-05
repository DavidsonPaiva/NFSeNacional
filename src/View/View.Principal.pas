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
  ACBrDFe.Conversao,
  ACBrNFSeXDANFSeClass,
  ACBrNFSeXDANFSeRLClass,
  Entity.Config,
  Entity.Data,
  Entity.Servico,
  Entity.Prestador,
  Entity.Tomador,
  Entity.ReformaTributaria,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxContainer,
  cxEdit,
  dxSkinsCore,
  dxSkinBasic,
  dxSkinBlack,
  dxSkinBlue,
  dxSkinBlueprint,
  dxSkinCaramel,
  dxSkinCoffee,
  dxSkinDarkroom,
  dxSkinDarkSide,
  dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle,
  dxSkinFoggy,
  dxSkinGlassOceans,
  dxSkinHighContrast,
  dxSkiniMaginary,
  dxSkinLilian,
  dxSkinLiquidSky,
  dxSkinLondonLiquidSky,
  dxSkinMcSkin,
  dxSkinMetropolis,
  dxSkinMetropolisDark,
  dxSkinMoneyTwins,
  dxSkinOffice2007Black,
  dxSkinOffice2007Blue,
  dxSkinOffice2007Green,
  dxSkinOffice2007Pink,
  dxSkinOffice2007Silver,
  dxSkinOffice2010Black,
  dxSkinOffice2010Blue,
  dxSkinOffice2010Silver,
  dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray,
  dxSkinOffice2013White,
  dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark,
  dxSkinOffice2019Black,
  dxSkinOffice2019Colorful,
  dxSkinOffice2019DarkGray,
  dxSkinOffice2019White,
  dxSkinPumpkin,
  dxSkinSeven,
  dxSkinSevenClassic,
  dxSkinSharp,
  dxSkinSharpPlus,
  dxSkinSilver,
  dxSkinSpringtime,
  dxSkinStardust,
  dxSkinSummer2008,
  dxSkinTheAsphaltWorld,
  dxSkinTheBezier,
  dxSkinsDefaultPainters,
  dxSkinValentine,
  dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light,
  dxSkinVS2010,
  dxSkinWhiteprint,
  dxSkinXmas2008Blue,
  cxGroupBox,
  Vcl.ExtCtrls,
  Vcl.Mask,
  Vcl.ComCtrls,
  dxBarBuiltInMenu,
  cxPC,
  cxTextEdit,
  cxMaskEdit,
  cxDropDownEdit,
  cxCalc,
  dxGDIPlusClasses;

type
  TfrmPrincipal = class(TForm)
    gpbxConfig: TcxGroupBox;
    gpbxDados: TcxGroupBox;
    pnlCommand: TPanel;
    btnGerar: TBitBtn;
    gpbxResult: TcxGroupBox;
    edtCertificadoDigital: TLabeledEdit;
    edtPathResposta: TLabeledEdit;
    edtPathSchemas: TLabeledEdit;
    edtNomePrefeitura: TLabeledEdit;
    cbbAmbiente: TComboBox;
    edtCodigoIBGE: TLabeledEdit;
    Label1: TLabel;
    edtRPS: TLabeledEdit;
    edtSerie: TLabeledEdit;
    edtDataCompetencia: TDateTimePicker;
    Label2: TLabel;
    cbbNaturezaOperacao: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    cbbIncentivadorCultural: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cbbRegimeEspecialTrib: TComboBox;
    cbbOptanteSN: TComboBox;
    Memo: TMemo;
    cxPageControl: TcxPageControl;
    tsServico: TcxTabSheet;
    tsPrestador: TcxTabSheet;
    tsTomador: TcxTabSheet;
    Label9: TLabel;
    cbbIssRetido: TComboBox;
    edtBaseCalculo: TcxCalcEdit;
    edtAliquota: TcxCalcEdit;
    edtValor: TcxCalcEdit;
    edtCoditoTribNac: TLabeledEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtCodTribMun: TLabeledEdit;
    edtCNAE: TLabeledEdit;
    edtCodNBS: TLabeledEdit;
    edtDiscriminacaoServ: TMemo;
    Label13: TLabel;
    edtPrestCNPJ: TLabeledEdit;
    edtPrestInscMunicipal: TLabeledEdit;
    edtPrestRazao: TLabeledEdit;
    edtPrestEndereco: TLabeledEdit;
    edtPrestEnderecoNumero: TLabeledEdit;
    edtPrestBairro: TLabeledEdit;
    edtPrestCEP: TLabeledEdit;
    edtPrestCidade: TLabeledEdit;
    edtPrestUF: TLabeledEdit;
    edtPrestFone: TLabeledEdit;
    edtPrestEmail: TLabeledEdit;
    edtTomadorCNPJ: TLabeledEdit;
    edtTomadorRazao: TLabeledEdit;
    edtTomadorEndereco: TLabeledEdit;
    edtTomadorEnderecoNumero: TLabeledEdit;
    edtTomadorEnderecoComplemento: TLabeledEdit;
    edtTomadorBairro: TLabeledEdit;
    edtTomadorCEP: TLabeledEdit;
    edtTomadorFone: TLabeledEdit;
    edtTomadorEmail: TLabeledEdit;
    edtTomadorUF: TLabeledEdit;
    edtTomadorCodigoIBGE: TLabeledEdit;
    imgLogo: TImage;
    gpbxIBSCSB: TcxGroupBox;
    edtIndOper: TLabeledEdit;
    edtClassTrib: TLabeledEdit;
    cbbCSTIBSCBS: TComboBox;
    Label14: TLabel;
    procedure btnGerarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure PopularRegimeEspecial;
    procedure PopularCSTIBSCBS;
    function GetConfig: INFSeConfig;
    function GetData: INFSeData;
    function GetServico: INFSeServico;
    function GetPrestador: INFSePrestador;
    function GetTomador: INFSeTomador;
    function GetReformaTrib: INFSeReformaTrib;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}


uses
  Types.NFSE,
  Controller.NFSE,
  ACBrNFSeXConversao;

procedure TfrmPrincipal.btnGerarClick(Sender: TObject);
begin
  var
  lRetorno := TControllerNFSE.New
    .Config(GetConfig)
    .Data(GetData)
    .Servico(GetServico)
    .Prestador(GetPrestador)
    .Tomador(GetTomador)
    .ReformaTrib(GetReformaTrib)
    .Send;

  Memo.Clear;

  if lRetorno.Sucesso then
  begin
    Memo.Lines.Add('NFSe emitida com sucesso!' + sLineBreak +
        'Número da Nota: ' + lRetorno.NumeroNota + sLineBreak +
        'ChaveAcesso: ' + lRetorno.ChaveAcesso);
  end
  else
  begin
    Memo.Lines.Add('Erro ao emitir NFSe:' + sLineBreak + lRetorno.MensagemLog);
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  PopularRegimeEspecial;
  PopularCSTIBSCBS;
end;

function TfrmPrincipal.GetConfig: INFSeConfig;
begin
  Result := TNFSeConfig.New
    .CertificadoDigital(edtCertificadoDigital.Text)
    .PathResposta(edtPathResposta.Text)
    .PathSchemas(edtPathSchemas.Text)
    .Ambiente(TACBrTipoAmbiente(cbbAmbiente.ItemIndex))
    .CodigoMunicipioIBGE(StrToIntDef(edtCodigoIBGE.Text, 0))
    .NomePrefeitura(edtNomePrefeitura.Text);
end;

function TfrmPrincipal.GetData: INFSeData;
var
  lOk: Boolean;
begin
  Result := TNFSeData.New
    .NumeroLote(StrToIntDef(edtRPS.Text, 0))
    .NumeroRPS(StrToIntDef(edtRPS.Text, 0))
    .Serie(edtSerie.Text)
    .Competencia(edtDataCompetencia.Date)
    .NaturezaOperacao(StrToNaturezaOperacao(lOk, cbbNaturezaOperacao.Text))
    .RegimeEspecialTributacao(TnfseRegimeEspecialTributacao(cbbRegimeEspecialTrib.ItemIndex))
    .OptanteSimplesNacional(TnfseSimNao(cbbOptanteSN.ItemIndex))
    .IncentivadorCultural(TnfseSimNao(cbbIncentivadorCultural.ItemIndex));
end;

function TfrmPrincipal.GetPrestador: INFSePrestador;
begin
  Result := TNFSePrestador.New
    .CNPJ(edtPrestCNPJ.Text)
    .InscricaoMunicipal(edtPrestInscMunicipal.Text)
    .RazaoSocial(edtPrestRazao.Text)
    .Endereco(edtPrestEndereco.Text)
    .Numero(edtPrestEnderecoNumero.Text)
    .Bairro(edtPrestBairro.Text)
    .CEP(edtPrestCEP.Text)
    .Cidade(edtPrestCidade.Text)
    .UF(edtPrestUF.Text)
    .Telefone(edtPrestFone.Text)
    .Email(edtPrestEmail.Text);
end;

function TfrmPrincipal.GetReformaTrib: INFSeReformaTrib;
begin
  Result := TNFSeReformaTrib.New
    .IndicadorOperacao(edtIndOper.Text)
    .CST(TCSTIBSCBS(cbbCSTIBSCBS.ItemIndex))
    .Classtrib(edtClassTrib.Text);
end;

function TfrmPrincipal.GetServico: INFSeServico;
begin
  Result := TNFSeServico.New
    .IssRetido(TnfseSituacaoTributaria(cbbIssRetido.ItemIndex))
    .BaseCalculo(edtBaseCalculo.Value)
    .Aliquota(edtAliquota.Value)
    .Valor(edtValor.Value)
    .CodigoTribNac(edtCoditoTribNac.Text) // https://www.gov.br/nfse/pt-br/mei-e-demais-empresas/codigos-de-tributacao-nacional-nbs
    .CodigoTribMun(edtCodTribMun.Text)
    .CNAE(edtCNAE.Text)
    .CodigoNBS(edtCodNBS.Text)
    .Discriminacao(edtDiscriminacaoServ.Text);
end;

function TfrmPrincipal.GetTomador: INFSeTomador;
begin
  Result := TNFSeTomador.New
    .CNPJ(edtTomadorCNPJ.Text)
    .RazaoSocial(edtTomadorRazao.Text)
    .Endereco(edtTomadorEndereco.Text)
    .Numero(edtTomadorEnderecoNumero.Text)
    .Complemento(edtTomadorEnderecoComplemento.Text)
    .Bairro(edtTomadorBairro.Text)
    .CodigoMunicipioIBGE(StrToIntDef(edtTomadorCodigoIBGE.Text, 0)) // Maringa/PR
    .UF(edtTomadorUF.Text)
    .CEP(edtTomadorCEP.Text)
    .Telefone(edtTomadorFone.Text)
    .Email(edtTomadorEmail.Text);
end;

procedure TfrmPrincipal.PopularRegimeEspecial;
begin
  cbbNaturezaOperacao.Clear;

  for var idx := Low(TNaturezaOperacaoArrayStrings) to High(TNaturezaOperacaoArrayStrings) do
  begin
    cbbNaturezaOperacao.Items.Add(TNaturezaOperacaoArrayStrings[idx]);
  end;

  cbbNaturezaOperacao.ItemIndex := 0;
end;

procedure TfrmPrincipal.PopularCSTIBSCBS;
begin
  cbbCSTIBSCBS.Clear;

  for var idx := Low(TCSTIBSCBSArrayStrings) to High(TCSTIBSCBSArrayStrings) do
  begin
    cbbCSTIBSCBS.Items.Add(TCSTIBSCBSArrayStrings[idx]);
  end;

  cbbCSTIBSCBS.ItemIndex := 1;
end;

end.
