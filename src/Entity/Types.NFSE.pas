unit Types.NFSE;

interface

type
  TModelResult = record
    Sucesso: Boolean;
    RPS: Integer;
    Serie: Integer;
    Lote: Integer;
    MensagemLog: string;
    NumeroNota: string;
    ChaveAcesso: string;
    Protocolo: string;
    LinkNota: string;
    XML: string;
    NomeArquivoXML: string;
    PDFBBase64: string;
  end;

implementation

end.
