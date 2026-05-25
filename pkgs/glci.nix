{
  lib,
  fetchFromGitLab,
  buildGoModule,
}:

let
  version = "0.5.0";
in
buildGoModule {
  pname = "glci";
  inherit version;

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "ci-cd/runner-tools/glci";
    rev = "v${version}";
    hash = "sha256-s3zMBHbW2cExZz2WZWLVkH/H5VYN5UFTspZSvV+7E54=";
  };

  vendorHash = "sha256-SNZsHlCazqtnV41qWWxQ8q8GNsCN65IZOMJmLHT/N8U=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X gitlab.com/gitlab-org/ci-cd/runner-tools/glci/pkg/version.Commit=v${version}"
  ];

  meta = with lib; {
    description = "Run GitLab CI/CD pipelines locally";
    homepage = "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci";
    changelog = "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci/-/releases/v${version}";
    license = licenses.mit;
    mainProgram = "glci";
    maintainers = with maintainers; [ atimofeev ];
  };
}
