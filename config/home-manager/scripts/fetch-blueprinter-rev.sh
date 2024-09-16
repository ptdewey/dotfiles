#!/bin/bash

# Define repository details and file to update
REPO_OWNER="ptdewey"
REPO_NAME="blueprinter"
REV_FILE="packages/blueprinter.nix"

# Fetch the latest commit hash from the main branch
LATEST_REV=$(git ls-remote https://github.com/$REPO_OWNER/$REPO_NAME refs/heads/main | awk '{print $1}')

# Fetch the source and calculate the SHA256 hash
PREFETCH_OUTPUT=$(nix-prefetch-git https://github.com/$REPO_OWNER/$REPO_NAME --rev $LATEST_REV)
SHA256=$(echo "$PREFETCH_OUTPUT" | jq -r .sha256)

# Create or update the Nix file with the latest rev
cat <<EOF > $REV_FILE
{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "$REPO_NAME";
  version = "latest";

  src = pkgs.fetchFromGitHub {
    owner = "$REPO_OWNER";
    repo = "$REPO_NAME";
    rev = "$LATEST_REV";
    sha256 = "$SHA256";
  };

  nativeBuildInputs = [ pkgs.go ];
  buildInputs = [ pkgs.go ];

  buildPhase = ''
    export HOME=\$(pwd)
    export GOPATH=\$HOME/go
    mkdir -p \$GOPATH
    mkdir -p \$out
    cd \$src
    go build -o \$out/blueprinter
  '';

  installPhase = ''
    export HOME=\$(pwd)
    mkdir -p \$out/bin
    mv \$out/blueprinter \$out/bin/
  '';
}
EOF

echo "Updated to latest commit: $LATEST_REV"