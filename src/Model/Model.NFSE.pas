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

  FNFSE.Configuracoes.Geral.Emitente.CNPJ      := OnlyNumber(FData.Servico.Prestador.CNPJ);
  FNFSE.Configuracoes.Geral.Emitente.InscMun   := OnlyNumber(FData.Servico.Prestador.InscricaoMunicipal);
  FNFSE.Configuracoes.Geral.Emitente.RazSocial := FData.Servico.Prestador.RazaoSocial.Trim.ToUpper;

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
begin
  FNFSE.NotasFiscais.NumeroLote := FData.NumeroLote.ToString;

  FNFSE.NotasFiscais.New.NFSE.verAplic := 'PaivaSystem';
  if FNFSE.Configuracoes.WebServices.Ambiente = TACBrTipoAmbiente.taProducao then
    FNFSE.NotasFiscais.New.NFSE.Producao := snSim
  else
    FNFSE.NotasFiscais.New.NFSE.Producao              := snNao;
  FNFSE.NotasFiscais.New.NFSE.IdentificacaoRps.Numero := FormatFloat('#########0', FData.NumeroRps);
  FNFSE.NotasFiscais.New.NFSE.IdentificacaoRps.Serie  := FData.Serie.Trim;
  FNFSE.NotasFiscais.New.NFSE.IdentificacaoRps.Tipo   := TTipoRPS.trRPS;

  FNFSE.NotasFiscais.New.NFSE.Competencia              := FData.Competencia;
  FNFSE.NotasFiscais.New.NFSE.DataEmissao              := Date;
  FNFSE.NotasFiscais.New.NFSE.DataEmissaoRPS           := Date;
  FNFSE.NotasFiscais.New.NFSE.NaturezaOperacao         := FData.NaturezaOperacao;
  FNFSE.NotasFiscais.New.NFSE.RegimeEspecialTributacao := FData.RegimeEspecialTributacao;
  FNFSE.NotasFiscais.New.NFSE.OptanteSimplesNacional   := FData.OptanteSimplesNacional;
  FNFSE.NotasFiscais.New.NFSE.IncentivadorCultural     := FData.IncentivadorCultural;
  FNFSE.NotasFiscais.New.NFSE.StatusRps                := srNormal;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorServicos          := FData.Servico.Valor;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorDeducoes          := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorPis               := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorCofins            := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorInss              := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorIr                := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorCsll              := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.IssRetido              := FData.Servico.IssRetido;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.OutrasRetencoes        := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.DescontoIncondicionado := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.DescontoCondicionado   := 0.00;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.BaseCalculo            := FData.Servico.BaseCalculo;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.Aliquota               := FData.Servico.Aliquota;

  if FNFSE.NotasFiscais.New.NFSE.Servico.Valores.IssRetido = stNormal then
  begin
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorISS       := (FData.Servico.BaseCalculo * (FData.Servico.Aliquota / 100));
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorIssRetido := 0.00;
  end
  else
  begin
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorISS       := 0.00;
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorIssRetido := (FData.Servico.BaseCalculo * (FData.Servico.Aliquota / 100));
  end;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.CST          := cst01;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.vBCPisCofins := FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorServicos -
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorDeducoes - FNFSE.NotasFiscais.New.NFSE.Servico.Valores.DescontoIncondicionado;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.pAliqPis    := 0; // 1.65;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.pAliqCofins := 0; // 7.60;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.vPis        := FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.vBCPisCofins *
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.pAliqPis / 100;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.vCofins := FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.vBCPisCofins *
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.pAliqCofins / 100;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribFed.tpRetPisCofins := trpcNaoRetido;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribMun.cPaisResult := 0;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribMun.tribISSQN   := tiOperacaoTributavel;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribMun.tpImunidade := timNenhum;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribMun.tpRetISSQN  := trNaoRetido;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.tribMun.pAliq := 0;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.totTrib.indTotTrib  := indNao;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.totTrib.vTotTribFed := 0;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.totTrib.vTotTribEst := 0;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.totTrib.vTotTribMun := 0;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.totTrib.pTotTribFed := 0;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.totTrib.pTotTribEst := 0;
  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.totTrib.pTotTribMun := 0;

  FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorLiquidoNfse := FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorServicos -
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorPis - FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorCofins -
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorInss - FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorIr -
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorCsll - FNFSE.NotasFiscais.New.NFSE.Servico.Valores.OutrasRetencoes -
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.ValorIssRetido - FNFSE.NotasFiscais.New.NFSE.Servico.Valores.DescontoIncondicionado -
    FNFSE.NotasFiscais.New.NFSE.Servico.Valores.DescontoCondicionado;

  FNFSE.NotasFiscais.New.NFSE.Servico.ItemListaServico          := FData.Servico.CodigoTribNac;
  FNFSE.NotasFiscais.New.NFSE.Servico.CodigoTributacaoMunicipio := FData.Servico.CodigoTribMun;

  FNFSE.NotasFiscais.New.NFSE.Servico.CodigoCnae       := OnlyNumber(FData.Servico.CNAE);
  FNFSE.NotasFiscais.New.NFSE.Servico.CodigoNBS        := FData.Servico.CodigoNBS;
  FNFSE.NotasFiscais.New.NFSE.Servico.Discriminacao    := FData.Servico.Discriminacao;
  FNFSE.NotasFiscais.New.NFSE.Servico.CodigoMunicipio  := FConfig.CodigoMunicipioIBGE.ToString;
  FNFSE.NotasFiscais.New.NFSE.Servico.CodigoPais       := 1058;
  FNFSE.NotasFiscais.New.NFSE.Servico.ExigibilidadeISS := exiExigivel;

  FNFSE.NotasFiscais.New.NFSE.Prestador.IdentificacaoPrestador.CpfCnpj := OnlyNumber(FData.Servico.Prestador.CNPJ);
  // FNFSE.NotasFiscais.New.NFSE.Prestador.IdentificacaoPrestador.InscricaoMunicipal := FData.Servico.Prestador.IncricaoMunicipal;
  FNFSE.NotasFiscais.New.NFSE.Prestador.RazaoSocial := FData.Servico.Prestador.RazaoSocial.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Prestador.cUF         := UFparaCodigoUF(FData.Servico.Prestador.UF);

  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.CodigoMunicipio := FConfig.CodigoMunicipioIBGE.ToString;
  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.Endereco        := FData.Servico.Prestador.Endereco.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.Numero          := FData.Servico.Prestador.Numero.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.Bairro          := FData.Servico.Prestador.Bairro.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.xMunicipio      := FData.Servico.Prestador.Cidade.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.UF              := FData.Servico.Prestador.UF.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.CodigoPais      := 1058;
  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.xPais           := 'BRASIL';
  FNFSE.NotasFiscais.New.NFSE.Prestador.Endereco.CEP             := OnlyNumber(FData.Servico.Prestador.CEP);

  FNFSE.NotasFiscais.New.NFSE.Prestador.Contato.Telefone := OnlyNumber(FData.Servico.Prestador.Telefone);
  FNFSE.NotasFiscais.New.NFSE.Prestador.Contato.Email    := FData.Servico.Prestador.Email.Trim.ToLower;

  FNFSE.NotasFiscais.New.NFSE.Tomador.AtualizaTomador := snNao;
  FNFSE.NotasFiscais.New.NFSE.Tomador.TomadorExterior := snNao;

  FNFSE.NotasFiscais.New.NFSE.Tomador.IdentificacaoTomador.CpfCnpj := OnlyNumber(FData.Servico.Tomador.CNPJ);
  FNFSE.NotasFiscais.New.NFSE.Tomador.RazaoSocial                  := FData.Servico.Tomador.RazaoSocial.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Tomador.Endereco.Endereco            := FData.Servico.Tomador.Endereco.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Tomador.Endereco.Numero              := FData.Servico.Tomador.Numero.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Tomador.Endereco.Complemento         := FData.Servico.Tomador.Complemento.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Tomador.Endereco.Bairro              := FData.Servico.Tomador.Bairro.Trim.ToUpper;
  FNFSE.NotasFiscais.New.NFSE.Tomador.Endereco.CodigoMunicipio     := FData.Servico.Tomador.CodigoMunicipioIBGE.ToString;
  FNFSE.NotasFiscais.New.NFSE.Tomador.Endereco.UF                  := FData.Servico.Tomador.UF;
  FNFSE.NotasFiscais.New.NFSE.Tomador.Endereco.CEP                 := OnlyNumber(FData.Servico.Tomador.CEP);
  FNFSE.NotasFiscais.New.NFSE.Tomador.Contato.Telefone             := OnlyNumber(FData.Servico.Tomador.Telefone);
  FNFSE.NotasFiscais.New.NFSE.Tomador.Contato.Email                := FData.Servico.Tomador.Email.Trim.ToLower;

  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.finNFSe   := fnfsRegular;
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.indFinal  := ifNao;
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.cIndOp    := '100501';
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.tpOper    := TtpOperGovNFSe.togNenhum;
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.tpEnteGov := TtpEnteGov.tcgNenhum;
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.indDest   := idTomadorAdquirenteIguais;
  //
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.dest.CNPJCPF :=   FNFSE.NotasFiscais.New.NFSE.Tomador.IdentificacaoTomador.CpfCnpj;
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.dest.xNome   :=   FNFSE.NotasFiscais.New.NFSE.Tomador.RazaoSocial;
  //
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.Valores.trib.gIBSCBS.CST        := cst000;
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.Valores.trib.gIBSCBS.cClassTrib := '000001';
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.Valores.trib.gIBSCBS.cCredPres  := cpNenhum;
  //
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.Valores.trib.gIBSCBS.gTribRegular.CSTReg        := cstNenhum;
  // FNFSE.NotasFiscais.New.NFSE.IBSCBS.Valores.trib.gIBSCBS.gTribRegular.cClassTribReg := '';
end;

function TModelNFSE.Send: Boolean;
begin
  loadComponent;
  setData;
  FNFSE.Emitir(FData.NumeroLote.ToString, meAutomatico, False);
  checkResponse(tmRecepcionar, FData.NumeroRps);
  Result := True;
end;

end.
