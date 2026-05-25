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
  Entity.Data;

type
  IModelNFSE = interface
    ['{F949306E-1CDB-4A71-86B8-E735306432FE}']
    function Config(AValue: TNFSeConfig): IModelNFSE;
    function Data(AValue: TNFSeData): IModelNFSE;
    function Send: Boolean;
  end;

  TModelNFSE = class(TInterfacedObject, IModelNFSE)
  strict private
    FDanfse: TACBrNFSeXDANFSeRL;
    FNFSE  : TACBrNFSeX;

    procedure loadComponent;
    procedure setData;
    procedure checkResponse(AMetodo: TMetodo; ANumRPS: Integer);
  private
    FConfig: TNFSeConfig;
    FData  : TNFSeData;
  protected
    function Config(AValue: TNFSeConfig): IModelNFSE;
    function Data(AValue: TNFSeData): IModelNFSE;
    function Send: Boolean;
  public
    constructor Create;
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

procedure TModelNFSE.checkResponse(AMetodo: TMetodo; ANumRPS: Integer);
var
  lStream : TStringStream;
  lMemoLog: TMemo;
begin
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
              lMemoLog.Lines.Add('Data de Envio : ' + DateToStr(Data));
              lMemoLog.Lines.Add('Numero do Prot: ' + Protocolo);
              lMemoLog.Lines.Add('Numero da Nota: ' + NumeroNota);
              lMemoLog.Lines.Add('Link          : ' + Link);
              lMemoLog.Lines.Add('LinkVerificacao          : ' + LinkVerificacao);
              lMemoLog.Lines.Add('NomeArq       : ' + NomeArq);
              lMemoLog.Lines.Add('Código Verif. : ' + CodigoVerificacao);
              lMemoLog.Lines.Add('Sucesso       : ' + BoolToStr(Sucesso, True));

              if Sucesso then
              begin
                lStream := TStringStream.Create(XmlEnvio, TEncoding.UTF8);
                try
                  // PodeColocarAtualizacaoBanco
                finally
                  lStream.Free;
                end;
              end
              else
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
  finally
    lMemoLog.Free;
  end;
end;

function TModelNFSE.Config(AValue: TNFSeConfig): IModelNFSE;
begin
  Result  := Self;
  FConfig := AValue;
end;

function TModelNFSE.Data(AValue: TNFSeData): IModelNFSE;
begin
  Result := Self;
  FData  := AValue;
end;

destructor TModelNFSE.Destroy;
begin
  FDanfse.Free;
  FNFSE.Free;
  inherited;
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

  // var
  // lPathMensal := FNFSE.Configuracoes.Arquivos.GetPathNFSe(0);

  FNFSE.Configuracoes.Geral.Salvar           := True;
  FNFSE.Configuracoes.Geral.CodigoMunicipio  := 4115200; // Código de Maringá, por enquanto fica fixo...
  FNFSE.Configuracoes.WebServices.Ambiente   := FConfig.Ambiente;
  FNFSE.Configuracoes.WebServices.Visualizar := False;
  // FNFSE.Configuracoes.WebServices.ProxyHost  := '';
  // FNFSE.Configuracoes.WebServices.ProxyPort  := '';
  // FNFSE.Configuracoes.WebServices.ProxyUser  := '';
  // FNFSE.Configuracoes.WebServices.ProxyPass  := '';

  FNFSE.Configuracoes.Geral.Emitente.CNPJ      := OnlyNumber(FData.Prestador.CNPJ);
  FNFSE.Configuracoes.Geral.Emitente.InscMun   := OnlyNumber(FData.Prestador.InscricaoMunicipal);
  FNFSE.Configuracoes.Geral.Emitente.RazSocial := FData.Prestador.RazaoSocial.Trim.ToUpper;

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

class function TModelNFSE.New: IModelNFSE;
begin
  Result := Self.Create;
end;

procedure TModelNFSE.setData;
var
  lNota: TNotaFiscal;
begin
  FNFSE.NotasFiscais.NumeroLote := FData.NumeroLote.ToString;

  lNota := FNFSE.NotasFiscais.New;

  lNota.NFSE.verAplic := 'PaivaSystem';
  if FNFSE.Configuracoes.WebServices.Ambiente = TACBrTipoAmbiente.taProducao then
    lNota.NFSE.Producao := snSim
  else
    lNota.NFSE.Producao              := snNao;
  lNota.NFSE.IdentificacaoRps.Numero := FormatFloat('#########0', FData.NumeroRps);
  lNota.NFSE.IdentificacaoRps.Serie  := FData.Serie.Trim;
  lNota.NFSE.IdentificacaoRps.Tipo   := TTipoRPS.trRPS;

  lNota.NFSE.Competencia              := FData.Competencia;
  lNota.NFSE.DataEmissao              := Date;
  lNota.NFSE.DataEmissaoRPS           := Date;
  lNota.NFSE.NaturezaOperacao         := FData.NaturezaOperacao;
  lNota.NFSE.RegimeEspecialTributacao := FData.RegimeEspecialTributacao;
  lNota.NFSE.OptanteSimplesNacional   := FData.OptanteSimplesNacional;
  lNota.NFSE.IncentivadorCultural     := FData.IncentivadorCultural;
  lNota.NFSE.StatusRps                := srNormal;

  lNota.NFSE.Servico.Valores.ValorServicos          := FData.Servico.Valor;
  lNota.NFSE.Servico.Valores.ValorDeducoes          := 0.00;
  lNota.NFSE.Servico.Valores.ValorPis               := 0.00;
  lNota.NFSE.Servico.Valores.ValorCofins            := 0.00;
  lNota.NFSE.Servico.Valores.ValorInss              := 0.00;
  lNota.NFSE.Servico.Valores.ValorIr                := 0.00;
  lNota.NFSE.Servico.Valores.ValorCsll              := 0.00;
  lNota.NFSE.Servico.Valores.IssRetido              := FData.Servico.IssRetido;
  lNota.NFSE.Servico.Valores.OutrasRetencoes        := 0.00;
  lNota.NFSE.Servico.Valores.DescontoIncondicionado := 0.00;
  lNota.NFSE.Servico.Valores.DescontoCondicionado   := 0.00;
  lNota.NFSE.Servico.Valores.BaseCalculo            := FData.Servico.BaseCalculo;
  lNota.NFSE.Servico.Valores.Aliquota               := FData.Servico.Aliquota;

  if lNota.NFSE.Servico.Valores.IssRetido = stNormal then
  begin
    lNota.NFSE.Servico.Valores.ValorISS       := (FData.Servico.BaseCalculo * (FData.Servico.Aliquota / 100));
    lNota.NFSE.Servico.Valores.ValorIssRetido := 0.00;
  end
  else
  begin
    lNota.NFSE.Servico.Valores.ValorISS       := 0.00;
    lNota.NFSE.Servico.Valores.ValorIssRetido := (FData.Servico.BaseCalculo * (FData.Servico.Aliquota / 100));
  end;

  lNota.NFSE.Servico.Valores.tribFed.CST          := cst01;
  lNota.NFSE.Servico.Valores.tribFed.vBCPisCofins := lNota.NFSE.Servico.Valores.ValorServicos - lNota.NFSE.Servico.Valores.ValorDeducoes -
    lNota.NFSE.Servico.Valores.DescontoIncondicionado;

  lNota.NFSE.Servico.Valores.tribFed.pAliqPis    := 0; // 1.65;
  lNota.NFSE.Servico.Valores.tribFed.pAliqCofins := 0; // 7.60;
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

  lNota.NFSE.Servico.ItemListaServico          := FData.Servico.CodigoTribNac;
  lNota.NFSE.Servico.CodigoTributacaoMunicipio := FData.Servico.CodigoTribMun;

  lNota.NFSE.Servico.CodigoCnae       := OnlyNumber(FData.Servico.CNAE);
  lNota.NFSE.Servico.CodigoNBS        := FData.Servico.CodigoNBS;
  lNota.NFSE.Servico.Discriminacao    := FData.Servico.Discriminacao;
  lNota.NFSE.Servico.CodigoMunicipio  := FConfig.CodigoMunicipioIBGE.ToString;
  lNota.NFSE.Servico.CodigoPais       := 1058;
  lNota.NFSE.Servico.ExigibilidadeISS := exiExigivel;

  lNota.NFSE.Prestador.IdentificacaoPrestador.CpfCnpj := OnlyNumber(FData.Prestador.CNPJ);
  // Nota.NFSE.Prestador.IdentificacaoPrestador.InscricaoMunicipal := FData.Prestador.IncricaoMunicipal;
  lNota.NFSE.Prestador.RazaoSocial := FData.Prestador.RazaoSocial.Trim.ToUpper;
  lNota.NFSE.Prestador.cUF         := UFparaCodigoUF(FData.Prestador.UF);

  lNota.NFSE.Prestador.Endereco.CodigoMunicipio := FConfig.CodigoMunicipioIBGE.ToString;
  lNota.NFSE.Prestador.Endereco.Endereco        := FData.Prestador.Endereco.Trim.ToUpper;
  lNota.NFSE.Prestador.Endereco.Numero          := FData.Prestador.Numero.Trim.ToUpper;
  lNota.NFSE.Prestador.Endereco.Bairro          := FData.Prestador.Bairro.Trim.ToUpper;
  lNota.NFSE.Prestador.Endereco.xMunicipio      := FData.Prestador.Cidade.Trim.ToUpper;
  lNota.NFSE.Prestador.Endereco.UF              := FData.Prestador.UF.Trim.ToUpper;
  lNota.NFSE.Prestador.Endereco.CodigoPais      := 1058;
  lNota.NFSE.Prestador.Endereco.xPais           := 'BRASIL';
  lNota.NFSE.Prestador.Endereco.CEP             := OnlyNumber(FData.Prestador.CEP);

  lNota.NFSE.Prestador.Contato.Telefone := OnlyNumber(FData.Prestador.Telefone);
  lNota.NFSE.Prestador.Contato.Email    := FData.Prestador.Email.Trim.ToLower;

  lNota.NFSE.Tomador.AtualizaTomador := snNao;
  lNota.NFSE.Tomador.TomadorExterior := snNao;

  lNota.NFSE.Tomador.IdentificacaoTomador.CpfCnpj := OnlyNumber(FData.Tomador.CNPJ);
  lNota.NFSE.Tomador.RazaoSocial                  := FData.Tomador.RazaoSocial.Trim.ToUpper;
  lNota.NFSE.Tomador.Endereco.Endereco            := FData.Tomador.Endereco.Trim.ToUpper;
  lNota.NFSE.Tomador.Endereco.Numero              := FData.Tomador.Numero.Trim.ToUpper;
  lNota.NFSE.Tomador.Endereco.Complemento         := FData.Tomador.Complemento.Trim.ToUpper;
  lNota.NFSE.Tomador.Endereco.Bairro              := FData.Tomador.Bairro.Trim.ToUpper;
  lNota.NFSE.Tomador.Endereco.CodigoMunicipio     := FData.Tomador.CodigoMunicipioIBGE.ToString;
  lNota.NFSE.Tomador.Endereco.UF                  := FData.Tomador.UF;
  lNota.NFSE.Tomador.Endereco.CEP                 := OnlyNumber(FData.Tomador.CEP);
  lNota.NFSE.Tomador.Contato.Telefone             := OnlyNumber(FData.Tomador.Telefone);
  lNota.NFSE.Tomador.Contato.Email                := FData.Tomador.Email.Trim.ToLower;

  // Nota.NFSE.IBSCBS.finNFSe   := fnfsRegular;
  // Nota.NFSE.IBSCBS.indFinal  := ifNao;
  // Nota.NFSE.IBSCBS.cIndOp    := '100501';
  // Nota.NFSE.IBSCBS.tpOper    := TtpOperGovNFSe.togNenhum;
  // Nota.NFSE.IBSCBS.tpEnteGov := TtpEnteGov.tcgNenhum;
  // Nota.NFSE.IBSCBS.indDest   := idTomadorAdquirenteIguais;
  //
  // Nota.NFSE.IBSCBS.dest.CNPJCPF :=   Nota.NFSE.Tomador.IdentificacaoTomador.CpfCnpj;
  // Nota.NFSE.IBSCBS.dest.xNome   :=   Nota.NFSE.Tomador.RazaoSocial;
  //
  // Nota.NFSE.IBSCBS.Valores.trib.gIBSCBS.CST        := cst000;
  // Nota.NFSE.IBSCBS.Valores.trib.gIBSCBS.cClassTrib := '000001';
  // Nota.NFSE.IBSCBS.Valores.trib.gIBSCBS.cCredPres  := cpNenhum;
  //
  // Nota.NFSE.IBSCBS.Valores.trib.gIBSCBS.gTribRegular.CSTReg        := cstNenhum;
  // Nota.NFSE.IBSCBS.Valores.trib.gIBSCBS.gTribRegular.cClassTribReg := '';
end;

function TModelNFSE.Send: Boolean;
begin
  loadComponent;
  setData;
  FNFSE.Emitir(FData.NumeroLote.ToString, meAutomatico, False);
  checkResponse(tmRecepcionar, FData.NumeroRps);
  FNFSE.NotasFiscais.Imprimir;
  Result := True;
end;

end.
