unit Model.NFSE;

interface

uses
  Data.DB,
  Vcl.StdCtrls,
  System.Math,
  System.Classes,
  System.StrUtils,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  Types.NFSE,
  ACBrBase,
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.FilesIO,
  ACBrUtil.Strings,
  ACBrDFe,
  ACBrDFeReport,
  ACBrXmlBase,
  ACBrNFSeX,
  ACBrDFeSSL,
  ACBrNFSeXNotasFiscais,
  ACBrDFe.Conversao,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXConversao,
  ACBrNFSeXWebserviceBase,
  ACBrNFSeXDANFSeClass,
  ACBrNFSeXDANFSeRLClass,
  Entity.Config,
  Entity.Data,
  Entity.Servico,
  Entity.Prestador,
  Entity.Tomador,
  Entity.ReformaTributaria;

type
  IModelNFSE = interface
    ['{937885AB-8FBC-4EA5-BE21-4F0317DF3B84}']
    function Config(AValue: INFSeConfig): IModelNFSE;
    function Data(AValue: INFSeData): IModelNFSE;
    function Servico(AValue: INFSeServico): IModelNFSE;
    function Tomador(AValue: INFSeTomador): IModelNFSE;
    function Prestador(AValue: INFSePrestador): IModelNFSE;
    function ReformaTributaria(AValue: INFSeReformaTrib): IModelNFSE;
    function Enviar(APrint: Boolean = True): TModelResult;
  end;

  TModelNFSE = class(TInterfacedObject, IModelNFSE)
  private
    FDanfse: TACBrNFSeXDANFSeRL;
  protected
    FNFSE       : TACBrNFSeX;
    FConfig     : INFSeConfig;
    FData       : INFSeData;
    FServico    : INFSeServico;
    FTomador    : INFSeTomador;
    FPrestador  : INFSePrestador;
    FReformaTrib: INFSeReformaTrib;

    procedure loadComponent; virtual;
    procedure setData; virtual;
    function checkResponse(AMetodo: TMetodo; ANumRPS: Integer): string; virtual;
    procedure executeIssuance; virtual;
    procedure executePrint; virtual;

    function Config(AValue: INFSeConfig): IModelNFSE;
    function Data(AValue: INFSeData): IModelNFSE;
    function Servico(AValue: INFSeServico): IModelNFSE;
    function Tomador(AValue: INFSeTomador): IModelNFSE;
    function Prestador(AValue: INFSePrestador): IModelNFSE;
    function ReformaTributaria(AValue: INFSeReformaTrib): IModelNFSE;
    function Enviar(APrint: Boolean = True): TModelResult; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class function New: IModelNFSE;
  end;

implementation

{ TModelNFSE }

constructor TModelNFSE.Create;
begin
  FDanfse         := TACBrNFSeXDANFSeRL.Create(Nil);
  FDanfse.Sistema := 'PaivaSystem';

  FNFSE        := TACBrNFSeX.Create(Nil);
  FNFSE.danfse := FDanfse;
end;

destructor TModelNFSE.Destroy;
begin
  FDanfse.Free;
  FNFSE.Free;
  inherited;
end;

class function TModelNFSE.New: IModelNFSE;
begin
  Result := Self.Create;
end;

function TModelNFSE.Config(AValue: INFSeConfig): IModelNFSE;
begin
  Result  := Self;
  FConfig := AValue;
end;

function TModelNFSE.Data(AValue: INFSeData): IModelNFSE;
begin
  Result := Self;
  FData  := AValue;
end;

function TModelNFSE.Prestador(AValue: INFSePrestador): IModelNFSE;
begin
  Result     := Self;
  FPrestador := AValue;
end;

function TModelNFSE.ReformaTributaria(AValue: INFSeReformaTrib): IModelNFSE;
begin
  Result       := Self;
  FReformaTrib := AValue;
end;

function TModelNFSE.Tomador(AValue: INFSeTomador): IModelNFSE;
begin
  Result   := Self;
  FTomador := AValue;
end;

function TModelNFSE.Servico(AValue: INFSeServico): IModelNFSE;
begin
  Result   := Self;
  FServico := AValue;
end;

procedure TModelNFSE.loadComponent;
begin
  FNFSE.NotasFiscais.Clear;

  FNFSE.Configuracoes.Certificados.NumeroSerie := FConfig.CertificadoDigital;

  FNFSE.Configuracoes.Geral.SSLCryptLib   := TSSLCryptLib.cryWinCrypt;
  FNFSE.Configuracoes.Geral.SSLHttpLib    := TSSLHttpLib.httpWinHttp;
  FNFSE.Configuracoes.Geral.SSLLib        := TSSLLib.libWinCrypt;
  FNFSE.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib.xsLibXml2;

  FNFSE.SSL.DescarregarCertificado;

  FNFSE.Configuracoes.Geral.ConsultaLoteAposEnvio := True;
  FNFSE.Configuracoes.Geral.ConsultaAposCancelar  := True;
  FNFSE.Configuracoes.Geral.ExibirErroSchema      := True;
  FNFSE.Configuracoes.Geral.RetirarAcentos        := True;
  FNFSE.Configuracoes.Geral.RetirarEspacos        := True;

  FNFSE.Configuracoes.Arquivos.AdicionarLiteral := True;
  FNFSE.Configuracoes.Arquivos.EmissaoPathNFSe  := True;
  FNFSE.Configuracoes.Arquivos.PathCan          := FConfig.PathResposta;
  FNFSE.Configuracoes.Arquivos.PathNFSe         := FConfig.PathResposta;
  FNFSE.Configuracoes.Arquivos.PathSchemas      := FConfig.PathSchemas;
  FNFSE.Configuracoes.Arquivos.PathSalvar       := FConfig.PathResposta;
  FNFSE.Configuracoes.Arquivos.Salvar           := True;

  FNFSE.Configuracoes.Geral.Salvar           := True;
  FNFSE.Configuracoes.Geral.CodigoMunicipio  := 4115200; // <- Veja que isso está fixado na base, trataremos abaixo.
  FNFSE.Configuracoes.WebServices.Ambiente   := FConfig.Ambiente;
  FNFSE.Configuracoes.WebServices.Visualizar := False;

  FNFSE.Configuracoes.Geral.Emitente.CNPJ      := FPrestador.CNPJ;
  FNFSE.Configuracoes.Geral.Emitente.InscMun   := FPrestador.InscricaoMunicipal;
  FNFSE.Configuracoes.Geral.Emitente.RazSocial := FPrestador.RazaoSocial;

  if FNFSE.danfse <> nil then
  begin
    FNFSE.danfse.TipoDANFSE     := tpPadraoNacional;
    FNFSE.danfse.Logo           := FConfig.CaminhoLogoPref;
    FNFSE.danfse.Prestador.Logo := FConfig.CaminhoLogoEmpresa;
    FNFSE.danfse.Prefeitura     := FConfig.NomePrefeitura;
    FNFSE.danfse.MostraPreview  := False;

    FNFSE.danfse.MargemDireita  := 5;
    FNFSE.danfse.MargemEsquerda := 5;
    FNFSE.danfse.MargemSuperior := 5;
    FNFSE.danfse.MargemInferior := 5;

    FNFSE.danfse.ImprimeCanhoto         := True;
    FNFSE.danfse.CasasDecimais.Aliquota := 2;
  end;
end;

procedure TModelNFSE.setData;
const
  C_CODIGO_PAIS = 1058;
  C_NOME_PAIS   = 'BRASIL';
var
  lNota: TNotaFiscal;
begin
  FNFSE.NotasFiscais.NumeroLote := FData.NumeroLote.ToString;

  lNota               := FNFSE.NotasFiscais.New;
  lNota.NFSE.verAplic := 'PaivaSystem';

  if FNFSE.Configuracoes.WebServices.Ambiente = TACBrTipoAmbiente.taProducao then
    lNota.NFSE.Producao := snSim
  else
    lNota.NFSE.Producao := snNao;

  lNota.NFSE.IdentificacaoRps.Numero := FormatFloat('#########0', FData.NumeroRps);
  lNota.NFSE.IdentificacaoRps.Serie  := FData.Serie;
  lNota.NFSE.IdentificacaoRps.Tipo   := TTipoRPS.trRPS;

  lNota.NFSE.Competencia              := FData.Competencia;
  lNota.NFSE.DataEmissao              := Date;
  lNota.NFSE.DataEmissaoRPS           := Date;
  lNota.NFSE.NaturezaOperacao         := FData.NaturezaOperacao;
  lNota.NFSE.RegimeEspecialTributacao := FData.RegimeEspecialTributacao;
  lNota.NFSE.OptanteSimplesNacional   := FData.OptanteSimplesNacional;
  lNota.NFSE.IncentivadorCultural     := FData.IncentivadorCultural;
  lNota.NFSE.StatusRps                := srNormal;

  lNota.NFSE.Servico.Valores.ValorServicos          := FServico.Valor;
  lNota.NFSE.Servico.Valores.ValorDeducoes          := 0;
  lNota.NFSE.Servico.Valores.ValorPis               := 0;
  lNota.NFSE.Servico.Valores.ValorCofins            := 0;
  lNota.NFSE.Servico.Valores.ValorInss              := 0;
  lNota.NFSE.Servico.Valores.ValorIr                := 0;
  lNota.NFSE.Servico.Valores.ValorCsll              := 0;
  lNota.NFSE.Servico.Valores.IssRetido              := FServico.IssRetido;
  lNota.NFSE.Servico.Valores.OutrasRetencoes        := 0;
  lNota.NFSE.Servico.Valores.DescontoIncondicionado := 0;
  lNota.NFSE.Servico.Valores.DescontoCondicionado   := 0;
  lNota.NFSE.Servico.Valores.BaseCalculo            := FServico.BaseCalculo;
  lNota.NFSE.Servico.Valores.Aliquota               := FServico.Aliquota;

  if lNota.NFSE.Servico.Valores.IssRetido = stNormal then
  begin
    lNota.NFSE.Servico.Valores.ValorISS       := (FServico.BaseCalculo * (FServico.Aliquota / 100));
    lNota.NFSE.Servico.Valores.ValorIssRetido := 0;
  end
  else
  begin
    lNota.NFSE.Servico.Valores.ValorISS       := 0;
    lNota.NFSE.Servico.Valores.ValorIssRetido := (FServico.BaseCalculo * (FServico.Aliquota / 100));
  end;

  lNota.NFSE.Servico.Valores.tribFed.CST          := cst01;
  lNota.NFSE.Servico.Valores.tribFed.vBCPisCofins := lNota.NFSE.Servico.Valores.ValorServicos - lNota.NFSE.Servico.Valores.ValorDeducoes -
    lNota.NFSE.Servico.Valores.DescontoIncondicionado;

  lNota.NFSE.Servico.Valores.tribFed.pAliqPis    := FServico.AliquotaPis;
  lNota.NFSE.Servico.Valores.tribFed.pAliqCofins := FServico.AliquotaCofins;
  lNota.NFSE.Servico.Valores.tribFed.vPis        := lNota.NFSE.Servico.Valores.tribFed.vBCPisCofins * lNota.NFSE.Servico.Valores.tribFed.pAliqPis / 100;
  lNota.NFSE.Servico.Valores.tribFed.vCofins     := lNota.NFSE.Servico.Valores.tribFed.vBCPisCofins * lNota.NFSE.Servico.Valores.tribFed.pAliqCofins / 100;

  lNota.NFSE.Servico.Valores.tribFed.tpRetPisCofins := trpcNaoRetido;

  lNota.NFSE.Servico.Valores.tribMun.cPaisResult := 0;
  lNota.NFSE.Servico.Valores.tribMun.tribISSQN   := tiOperacaoTributavel;
  lNota.NFSE.Servico.Valores.tribMun.tpImunidade := timNenhum;
  lNota.NFSE.Servico.Valores.tribMun.tpRetISSQN  := trNaoRetido;

  lNota.NFSE.Servico.Valores.tribMun.pAliq := 0;

  lNota.NFSE.Servico.Valores.totTrib.indTotTrib  := indNao;
  lNota.NFSE.Servico.Valores.totTrib.vTotTribFed := 0;
  lNota.NFSE.Servico.Valores.totTrib.vTotTribEst := 0;
  lNota.NFSE.Servico.Valores.totTrib.vTotTribMun := 0;

  lNota.NFSE.Servico.Valores.totTrib.pTotTribFed := 0;
  lNota.NFSE.Servico.Valores.totTrib.pTotTribEst := 0;
  lNota.NFSE.Servico.Valores.totTrib.pTotTribMun := 0;

  lNota.NFSE.Servico.Valores.ValorLiquidoNfse := lNota.NFSE.Servico.Valores.ValorServicos - lNota.NFSE.Servico.Valores.ValorPis -
    lNota.NFSE.Servico.Valores.ValorCofins - lNota.NFSE.Servico.Valores.ValorInss - lNota.NFSE.Servico.Valores.ValorIr -
    lNota.NFSE.Servico.Valores.ValorCsll - lNota.NFSE.Servico.Valores.OutrasRetencoes - lNota.NFSE.Servico.Valores.ValorIssRetido -
    lNota.NFSE.Servico.Valores.DescontoIncondicionado - lNota.NFSE.Servico.Valores.DescontoCondicionado;

  lNota.NFSE.Servico.ItemListaServico          := FServico.CodigoTribNac;
  lNota.NFSE.Servico.CodigoTributacaoMunicipio := FServico.CodigoTribMun;

  lNota.NFSE.Servico.CodigoCnae       := FServico.CNAE;
  lNota.NFSE.Servico.CodigoNBS        := FServico.CodigoNBS;
  lNota.NFSE.Servico.Discriminacao    := FServico.Discriminacao;
  lNota.NFSE.Servico.CodigoMunicipio  := FConfig.CodigoMunicipioIBGE.ToString;
  lNota.NFSE.Servico.CodigoPais       := C_CODIGO_PAIS;
  lNota.NFSE.Servico.ExigibilidadeISS := exiExigivel;

  lNota.NFSE.Prestador.IdentificacaoPrestador.CpfCnpj := FPrestador.CNPJ;
  lNota.NFSE.Prestador.RazaoSocial                    := FPrestador.RazaoSocial;
  lNota.NFSE.Prestador.cUF                            := UFparaCodigoUF(FPrestador.UF);

  lNota.NFSE.Prestador.Endereco.CodigoMunicipio := FConfig.CodigoMunicipioIBGE.ToString;
  lNota.NFSE.Prestador.Endereco.Endereco        := FPrestador.Endereco;
  lNota.NFSE.Prestador.Endereco.Numero          := FPrestador.Numero;
  lNota.NFSE.Prestador.Endereco.Bairro          := FPrestador.Bairro;
  lNota.NFSE.Prestador.Endereco.xMunicipio      := FPrestador.Cidade;
  lNota.NFSE.Prestador.Endereco.UF              := FPrestador.UF;
  lNota.NFSE.Prestador.Endereco.CodigoPais      := C_CODIGO_PAIS;
  lNota.NFSE.Prestador.Endereco.xPais           := C_NOME_PAIS;
  lNota.NFSE.Prestador.Endereco.CEP             := FPrestador.CEP;

  lNota.NFSE.Prestador.Contato.Telefone := FPrestador.Telefone;
  lNota.NFSE.Prestador.Contato.Email    := FPrestador.Email;

  lNota.NFSE.Tomador.AtualizaTomador := snNao;

  if FConfig.CodigoMunicipioIBGE = FTomador.CodigoMunicipioIBGE then
    lNota.NFSE.Tomador.IdentificacaoTomador.Tipo := tpPJdoMunicipio
  else
    lNota.NFSE.Tomador.IdentificacaoTomador.Tipo := tpPJforaMunicipio;

  if (FTomador.UF = 'EX') then
  begin
    lNota.NFSE.Tomador.TomadorExterior                     := snSim;
    lNota.NFSE.Tomador.IdentificacaoTomador.Tipo           := tpPJforaPais;
    lNota.NFSE.Tomador.IdentificacaoTomador.DocEstrangeiro := FTomador.CNPJ;
    lNota.NFSE.Tomador.Endereco.CodigoMunicipio            := '9999999';
    lNota.NFSE.Tomador.Endereco.xMunicipio                 := 'Exterior';
  end
  else
  begin
    lNota.NFSE.Tomador.TomadorExterior              := snNao;
    lNota.NFSE.Tomador.IdentificacaoTomador.CpfCnpj := FTomador.CNPJ;
    lNota.NFSE.Tomador.RazaoSocial                  := FTomador.RazaoSocial;
    lNota.NFSE.Tomador.Endereco.CodigoMunicipio     := FTomador.CodigoMunicipioIBGE.ToString;
    lNota.NFSE.Tomador.Endereco.xMunicipio          := FTomador.Cidade;
  end;

  lNota.NFSE.Tomador.Endereco.Numero      := FTomador.Numero;
  lNota.NFSE.Tomador.Endereco.Complemento := FTomador.Complemento;
  lNota.NFSE.Tomador.Endereco.Bairro      := FTomador.Bairro;
  lNota.NFSE.Tomador.Endereco.UF          := FTomador.UF;
  lNota.NFSE.Tomador.Endereco.CEP         := FTomador.CEP;
  lNota.NFSE.Tomador.Contato.Telefone     := FTomador.Telefone;
  lNota.NFSE.Tomador.Contato.Email        := FTomador.Email;

  lNota.NFSE.IBSCBS.finNFSe  := fnfsRegular;
  lNota.NFSE.IBSCBS.indFinal := ifNao;
  lNota.NFSE.IBSCBS.cIndOp   := FReformaTrib.IndicadorOperacao;
  lNota.NFSE.IBSCBS.tpOper   := TtpOperGovNFSe.togNenhum;

  lNota.NFSE.IBSCBS.indDest := idTomadorAdquirenteDestinatarioIguais;

  lNota.NFSE.IBSCBS.Valores.trib.gIBSCBS.CST        := FReformaTrib.CST;
  lNota.NFSE.IBSCBS.Valores.trib.gIBSCBS.cClassTrib := FReformaTrib.ClassTrib;
  lNota.NFSE.IBSCBS.Valores.trib.gIBSCBS.cCredPres  := cpNenhum;

  lNota.NFSE.IBSCBS.Valores.trib.gIBSCBS.gTribRegular.CSTReg        := cstNenhum;
  lNota.NFSE.IBSCBS.Valores.trib.gIBSCBS.gTribRegular.cClassTribReg := '';
end;

function TModelNFSE.checkResponse(AMetodo: TMetodo; ANumRPS: Integer): string;
var
  lMemoLog: TMemo;
  lSucess : Boolean;
begin
  lSucess := False;

  lMemoLog := TMemo.Create(Nil);
  try
    lMemoLog.Lines.Clear;
    Sleep(2000);
    with FNFSE.WebService do
    begin
      case AMetodo of
        tmRecepcionar, tmTeste:
          begin
            with Emite do
            begin
              lMemoLog.Lines.Add('Método Executado: ' + ModoEnvioToStr(ModoEnvio));
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Envio');
              lMemoLog.Lines.Add('Numero do Lote: ' + NumeroLote);
              lMemoLog.Lines.Add('Numero do RPS : ' + NumeroRps);
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Retorno');
              lMemoLog.Lines.Add('Data de Envio  : ' + DateToStr(Data));
              lMemoLog.Lines.Add('Numero do Prot : ' + Protocolo);
              lMemoLog.Lines.Add('Numero da Nota : ' + NumeroNota);
              lMemoLog.Lines.Add('Link           : ' + Link);
              lMemoLog.Lines.Add('LinkVerificacao: ' + LinkVerificacao);
              lMemoLog.Lines.Add('NomeArq        : ' + NomeArq);
              lMemoLog.Lines.Add('Código Verif.  : ' + CodigoVerificacao);
              lMemoLog.Lines.Add('Sucesso        : ' + BoolToStr(Sucesso, True));

              lSucess := Sucesso;

              if not Sucesso then
              begin
                if Erros.Count > 0 then
                begin
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add('Erro(s):');
                  for var I := 0 to Erros.Count - 1 do
                  begin
                    lMemoLog.Lines.Add('Código  : ' + Erros[I].Codigo);
                    lMemoLog.Lines.Add('Mensagem: ' + Erros[I].Descricao);
                    lMemoLog.Lines.Add('Correção: ' + Erros[I].Correcao);
                    lMemoLog.Lines.Add('---------');
                  end;
                end;

                if Alertas.Count > 0 then
                begin
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add('Alerta(s):');
                  for var I := 0 to Alertas.Count - 1 do
                  begin
                    lMemoLog.Lines.Add('Código  : ' + Alertas[I].Codigo);
                    lMemoLog.Lines.Add('Mensagem: ' + Alertas[I].Descricao);
                    lMemoLog.Lines.Add('Correção: ' + Alertas[I].Correcao);
                    lMemoLog.Lines.Add('---------');
                  end;
                end;

                raise Exception.Create(lMemoLog.Text);
              end;
            end;

            if FNFSE.Configuracoes.Geral.ConsultaLoteAposEnvio and (Emite.Protocolo <> '') then
            begin
              if FNFSE.Provider.ConfigGeral.ConsultaSitLote then
              begin
                with ConsultaSituacao do
                begin
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(tmConsultarSituacao));
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add('Parâmetros de Envio');
                  lMemoLog.Lines.Add('Numero do Prot: ' + Protocolo);
                  lMemoLog.Lines.Add('Numero do Lote: ' + NumeroLote);
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add('Parâmetros de Retorno');
                  lMemoLog.Lines.Add('Situação Lote : ' + Situacao);
                  lMemoLog.Lines.Add('Sucesso       : ' + BoolToStr(Sucesso, True));

                  if Erros.Count > 0 then
                  begin
                    lMemoLog.Lines.Add(' ');
                    lMemoLog.Lines.Add('Erro(s):');
                    for var I := 0 to Pred(Erros.Count) do
                    begin
                      lMemoLog.Lines.Add('Código  : ' + Erros[I].Codigo);
                      lMemoLog.Lines.Add('Mensagem: ' + Erros[I].Descricao);
                      lMemoLog.Lines.Add('Correção: ' + Erros[I].Correcao);
                      lMemoLog.Lines.Add('---------');
                    end;
                  end;

                  if Alertas.Count > 0 then
                  begin
                    lMemoLog.Lines.Add(' ');
                    lMemoLog.Lines.Add('Alerta(s):');
                    for var I := 0 to Pred(Alertas.Count) do
                    begin
                      lMemoLog.Lines.Add('Código  : ' + Alertas[I].Codigo);
                      lMemoLog.Lines.Add('Mensagem: ' + Alertas[I].Descricao);
                      lMemoLog.Lines.Add('Correção: ' + Alertas[I].Correcao);
                      lMemoLog.Lines.Add('---------');
                    end;
                  end;
                end;
              end;

              if FNFSE.Provider.ConfigGeral.ConsultaLote then
              begin
                with ConsultaLoteRps do
                begin
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(tmConsultarLote));
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add('Parâmetros de Envio');
                  lMemoLog.Lines.Add('Numero do Prot: ' + Protocolo);
                  lMemoLog.Lines.Add('Numero do Lote: ' + NumeroLote);
                  lMemoLog.Lines.Add(' ');
                  lMemoLog.Lines.Add('Parâmetros de Retorno');
                  lMemoLog.Lines.Add('Situação Lote : ' + Situacao);
                  lMemoLog.Lines.Add('Sucesso       : ' + BoolToStr(Sucesso, True));

                  if Erros.Count > 0 then
                  begin
                    lMemoLog.Lines.Add(' ');
                    lMemoLog.Lines.Add('Erro(s):');
                    for var I := 0 to Pred(Erros.Count) do
                    begin
                      lMemoLog.Lines.Add('Código  : ' + Erros[I].Codigo);
                      lMemoLog.Lines.Add('Mensagem: ' + Erros[I].Descricao);
                      lMemoLog.Lines.Add('Correção: ' + Erros[I].Correcao);
                      lMemoLog.Lines.Add('---------');
                    end;
                  end;

                  if Alertas.Count > 0 then
                  begin
                    lMemoLog.Lines.Add(' ');
                    lMemoLog.Lines.Add('Alerta(s):');
                    for var I := 0 to Pred(Alertas.Count) do
                    begin
                      lMemoLog.Lines.Add('Código  : ' + Alertas[I].Codigo);
                      lMemoLog.Lines.Add('Mensagem: ' + Alertas[I].Descricao);
                      lMemoLog.Lines.Add('Correção: ' + Alertas[I].Correcao);
                      lMemoLog.Lines.Add('---------');
                    end;
                  end;
                end;
              end;
            end;
          end;

        tmConsultarLote:
          begin
            with ConsultaLoteRps do
            begin
              lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(tmConsultarLote));
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Envio');
              lMemoLog.Lines.Add('Numero do Prot: ' + Protocolo);
              lMemoLog.Lines.Add('Numero do Lote: ' + NumeroLote);
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Retorno');
              lMemoLog.Lines.Add('Situação Lote : ' + Situacao);
              lMemoLog.Lines.Add('ID Nota       : ' + IdNota);
              lMemoLog.Lines.Add('ID Rps        : ' + idRps);
              lMemoLog.Lines.Add('Sucesso       : ' + BoolToStr(Sucesso, True));
            end;
          end;

        tmConsultarNFSePorRps:
          begin
            with ConsultaNFSeporRps do
            begin
              lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(tmConsultarNFSePorRps));
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Envio');
              lMemoLog.Lines.Add('Numero do Rps : ' + NumeroRps);
              lMemoLog.Lines.Add('Série do Rps  : ' + SerieRps);
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Retorno');
              lMemoLog.Lines.Add('Numero do Lote: ' + NumeroLote);
              lMemoLog.Lines.Add('Numero do Prot: ' + Protocolo);
              lMemoLog.Lines.Add('Situação      : ' + Situacao);
              lMemoLog.Lines.Add('Data          : ' + DateToStr(Data));
              lMemoLog.Lines.Add('Desc. Situação: ' + DescSituacao);
              lMemoLog.Lines.Add('ID Nota       : ' + IdNota);
              lMemoLog.Lines.Add('Link          : ' + Link);
              lMemoLog.Lines.Add('Sucesso       : ' + BoolToStr(Sucesso, True));
            end;
          end;

        tmConsultarNFSePorChave:
          begin
            with ConsultaNFSe do
            begin
              lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(Metodo));
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Envio');
              lMemoLog.Lines.Add('Chave da NFSe: ' + InfConsultaNFSe.ChaveNFSe);
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Retorno');
              lMemoLog.Lines.Add('Sucesso       : ' + BoolToStr(Sucesso, True));

              if FNFSE.Configuracoes.Geral.Provedor in [proPrescon] then
                lMemoLog.Lines.Add('Número NFSe   : ' + NumeroNota);
            end;
          end;

        tmConsultarLinkNFSe:
          begin
            with ConsultaLinkNFSe do
            begin
              lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(tmConsultarLinkNFSe));
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Envio');
              lMemoLog.Lines.Add('Competencia   : ' + DateToStr(InfConsultaLinkNFSe.Competencia));
              lMemoLog.Lines.Add('Numero da NFSe: ' + InfConsultaLinkNFSe.NumeroNFSe);
              lMemoLog.Lines.Add('Série da NFSe : ' + InfConsultaLinkNFSe.SerieNFSe);
              lMemoLog.Lines.Add('Numero do RPS : ' + IntToStr(InfConsultaLinkNFSe.NumeroRps));
              lMemoLog.Lines.Add('Série da NFSe : ' + InfConsultaLinkNFSe.SerieRps);

              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Retorno');
              lMemoLog.Lines.Add('Situação: ' + Situacao);
              lMemoLog.Lines.Add('Link    : ' + Link);
              lMemoLog.Lines.Add('Sucesso : ' + BoolToStr(Sucesso, True));
              lMemoLog.Lines.Add(' ');
            end;
          end;

        tmCancelarNFSe:
          begin
            with CancelaNFSe do
            begin
              lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(tmCancelarNFSe));
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Envio');
              lMemoLog.Lines.Add('Numero da NFSe: ' + InfCancelamento.NumeroNFSe);
              lMemoLog.Lines.Add('Série da NFSe : ' + InfCancelamento.SerieNFSe);
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Retorno');
              lMemoLog.Lines.Add('Situação: ' + Situacao);
              lMemoLog.Lines.Add('Link    : ' + Link);
              lMemoLog.Lines.Add('Sucesso : ' + BoolToStr(Sucesso, True));
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Retorno do Pedido de Cancelamento:');
              lMemoLog.Lines.Add('Situação : ' + RetCancelamento.Situacao);
              lMemoLog.Lines.Add('Data/Hora: ' + DateToStr(RetCancelamento.DataHora));
              lMemoLog.Lines.Add('Mensagem : ' + RetCancelamento.MsgCanc);
              lMemoLog.Lines.Add('Sucesso  : ' + RetCancelamento.Sucesso);
              lMemoLog.Lines.Add('Link     : ' + RetCancelamento.Link);
              lMemoLog.Lines.Add('Nome Arq.: ' + PathNome);
            end;

            if FNFSE.Configuracoes.Geral.ConsultaAposCancelar and FNFSE.Provider.ConfigGeral.ConsultaNFSe then
            begin
              with ConsultaNFSe do
              begin
                lMemoLog.Lines.Add(' ');
                lMemoLog.Lines.Add(' ');
                lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(Metodo));
                lMemoLog.Lines.Add('Parâmetros de Envio');
                lMemoLog.Lines.Add('Num. Ini. NFSe: ' + InfConsultaNFSe.NumeroIniNFSe);
                lMemoLog.Lines.Add('Num. Fin. NFSe: ' + InfConsultaNFSe.NumeroFinNFSe);
                lMemoLog.Lines.Add(' ');
                lMemoLog.Lines.Add('Parâmetros de Retorno');
                lMemoLog.Lines.Add('Sucesso       : ' + BoolToStr(Sucesso, True));
              end;
            end;
          end;

        tmObterDANFSE:
          begin
            with ObterDANFSE do
            begin
              lMemoLog.Lines.Add('Método Executado: ' + MetodoToStr(tmObterDANFSE));
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Envio');
              lMemoLog.Lines.Add('Chave NFSe     : ' + ChaveNFSe);
              lMemoLog.Lines.Add(' ');
              lMemoLog.Lines.Add('Parâmetros de Retorno');
              lMemoLog.Lines.Add('Sucesso: ' + BoolToStr(Sucesso, True));
            end;
          end;
      end;
    end;

    for var I := 0 to Pred(FNFSE.NotasFiscais.Count) do
    begin
      lMemoLog.Lines.Add(' ');
      lMemoLog.Lines.Add('NFS-e Numero....: ' + FNFSE.NotasFiscais.Items[I].NFSE.Numero);
      lMemoLog.Lines.Add('Cod. Verificacao: ' + FNFSE.NotasFiscais.Items[I].NFSE.CodigoVerificacao);
      lMemoLog.Lines.Add('Prestador.......: ' + FNFSE.NotasFiscais.Items[I].NFSE.Prestador.RazaoSocial);
      lMemoLog.Lines.Add('Tomador.........: ' + FNFSE.NotasFiscais.Items[I].NFSE.Tomador.RazaoSocial);
      lMemoLog.Lines.Add('Link............: ' + FNFSE.NotasFiscais.Items[I].NFSE.Link);

      if FNFSE.NotasFiscais.Items[I].NFSE.SituacaoNfse = ACBrNFSeXConversao.snCancelado then
        lMemoLog.Lines.Add('A Nota encontra-se Cancelada.');

      if FNFSE.NotasFiscais.Items[I].NomeArq <> '' then
      begin
        lMemoLog.Lines.Add('Nome do arquivo.: ' + FNFSE.NotasFiscais.Items[I].NomeArq);
        if FNFSE.Configuracoes.Arquivos.Salvar then
          lMemoLog.Lines.Add('==> Xml da nota salvo na pasta e com o nome informado acima.')
        else
          lMemoLog.Lines.Add('==> Xml da nota não salvo em disco.');
      end;
    end;

    if not lSucess then
      raise Exception.Create(lMemoLog.Text);

    Result := lMemoLog.Text;
  finally
    lMemoLog.Free;
  end;
end;

procedure TModelNFSE.executeIssuance;
begin
  FNFSE.Emitir(FData.NumeroLote.ToString, meAutomatico, False);
end;

procedure TModelNFSE.executePrint;
begin
  FNFSE.NotasFiscais.Imprimir;
end;

function TModelNFSE.Enviar(APrint: Boolean): TModelResult;
begin
  FillChar(Result, SizeOf(Result), 0);

  try
    loadComponent;
    setData;
    executeIssuance;
    Result.MensagemLog := checkResponse(tmRecepcionar, FData.NumeroRps);
    Result.Sucesso     := True;

    if FNFSE.NotasFiscais.Count > 0 then
    begin
      Result.NumeroNota     := FNFSE.NotasFiscais.Items[0].NFSE.Numero;
      Result.ChaveAcesso    := FNFSE.NotasFiscais.Items[0].NFSE.CodigoVerificacao;
      Result.Protocolo      := FNFSE.WebService.Emite.Protocolo;
      Result.LinkNota       := FNFSE.NotasFiscais.Items[0].NFSE.Link;
      Result.NomeArquivoXML := FNFSE.NotasFiscais.Items[0].NomeArq;
    end;

    if APrint then
      executePrint;
  except
    on E: Exception do
    begin
      Result.Sucesso     := False;
      Result.MensagemLog := 'Falha na emissão da NFSe: ' + E.Message;

      if FNFSE.WebService.Emite.Protocolo <> '' then
        Result.Protocolo := FNFSE.WebService.Emite.Protocolo;
    end;
  end;
end;

end.
