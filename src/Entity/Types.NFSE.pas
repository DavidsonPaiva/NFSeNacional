unit Types.NFSE;

interface

type
  TModelResult = record
    Sucesso: Boolean;
    MensagemLog: string;
    NumeroNota: string;
    ChaveAcesso: string;
    Protocolo: string;
    LinkNota: string;
    NomeArquivoXML: string;
    PDFBBase64: string;
  end;

implementation

end.
