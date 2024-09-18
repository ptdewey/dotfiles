{ pkgs }:

pkgs.buildGoModule rec {
  pname = "blueprinter";
  version = "latest";

  src = pkgs.fetchFromGitHub {
    owner = "ptdewey";
    repo = "blueprinter";
    rev = "5d77d58e44a9dbbaa1b242338760c7dcc74c036a";
    sha256 = "0sk34gbf6f6va2xnvl766v5m7khjgi7fx0s6css7drrw0dj9li8k";
  };

  vendorHash = null;
}
