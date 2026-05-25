program PaivaNFSe;

uses
  Vcl.Forms,
  View.Principal in 'View\View.Principal.pas' {frmPrincipal},
  Entity.Config in 'Entity\Entity.Config.pas',
  Entity.Data in 'Entity\Entity.Data.pas',
  Controller.NFSE in 'Controller\Controller.NFSE.pas',
  Model.NFSE in 'Model\Model.NFSE.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
