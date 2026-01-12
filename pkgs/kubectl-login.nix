{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "kubectl-login";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "OpenUnison";
    repo = "openunison-cli";
    rev = "v${version}";
    hash = "sha256-l659e2NyyU5tulDOd9PWu4Kb/HnvMpHBM+lePIvPNdM=";
  };

  vendorHash = "sha256-TajdzIM7eLcO1n+HvGFuC+4dFulf2+aFVYq4duRY6UA=";

  postInstall = ''
    mv $out/bin/openunison-cli $out/bin/kubectl-login
  '';

  meta = {
    description = "kubectl plugin to automate authentication";
    homepage = "https://github.com/OpenUnison/openunison-cli";
    changelog = "https://github.com/OpenUnison/openunison-cli/releases/tag/v${version}";
    mainProgram = "kubectl-login";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.atimofeev ];
  };
}
