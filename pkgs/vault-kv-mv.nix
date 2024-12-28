{ lib, fetchFromGitHub, buildGoModule }:

let version = "0.0.8";
in buildGoModule {
  pname = "vault-kv-mv";
  inherit version;

  src = fetchFromGitHub {
    owner = "xbglowx";
    repo = "vault-kv-mv";
    rev = "v${version}";
    hash = "sha256-ZxPRpKGPzICZeG7zgnNe+MM8mMowhaR/ouunWHqhnRw=";
  };

  vendorHash = "sha256-Y+B7QBCzKBCcqDOegkhX+fHASb0eudIpzlZY0JwAYN4=";

  meta = with lib; {
    homepage = "https://github.com/xbglowx/vault-kv-mv";
    description = "Easily move Hashicorp Vault keys to different paths";
    license = licenses.mpl20;
    maintainers = with maintainers; [ atimofeev ];
  };
}
