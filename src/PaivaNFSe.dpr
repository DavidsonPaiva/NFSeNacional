program PaivaNFSe;

uses
  Vcl.Forms,
  View.Principal in 'View\View.Principal.pas' {frmPrincipal},
  Entity.Config in 'Entity\Entity.Config.pas',
  Entity.Data in 'Entity\Entity.Data.pas',
  Controller.NFSE in 'Controller\Controller.NFSE.pas',
  Model.NFSE in 'Model\Model.NFSE.pas',
  Entity.Tomador in 'Entity\Entity.Tomador.pas',
  Entity.Prestador in 'Entity\Entity.Prestador.pas',
  Entity.Servico in 'Entity\Entity.Servico.pas',
  Model.NFSE.CampoGrande in 'Model\Model.NFSE.CampoGrande.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
