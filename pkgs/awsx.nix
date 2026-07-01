{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "awsx";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "abdul-zailani";
    repo = "awsx";
    rev = "v${version}";
    hash = "sha256-wUlKPrTGhvNyiZ1qWXuCnEpUl2oPR+1+iW6l+NyFAXs=";
  };

  cargoHash = "sha256-QBUyNGWgTg9zG9oxR1OCJOir/QuflNurGtmIm6bkunM=";

  # Upstream tests fail: crate lib name mismatch (awsx vs awsx_lib)
  doCheck = false;

  meta = {
    description = "Switch AWS profile + kubectl context + region in one command";
    homepage = "https://github.com/abdul-zailani/awsx";
    changelog = "https://github.com/abdul-zailani/awsx/releases/tag/v${version}";
    mainProgram = "awsx";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.atimofeev ];
  };
}
