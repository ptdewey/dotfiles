{ pkgs }:

pkgs.buildGoModule rec {
  pname = "blueprinter";
  version = "latest";

  src = pkgs.fetchFromGitHub {
    owner = "ptdewey";
    repo = "blueprinter";
    rev = "6656c54ecacf02ed439bca5616081782570b30ce";
    sha256 = "0z7ga70yzqppgwj0ss3pk750m15m1n9s2hy2zzvgwny48fkl4x6l";
  };

  vendorHash = null;
}
