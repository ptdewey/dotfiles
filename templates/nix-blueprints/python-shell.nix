{
  inputs = {
      nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };
  outputs = { nixpkgs, ... }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems(pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          python3
          (with pkgs.python3Packages; [
            pandas
          ])
        ];

        shellHook = ''
          export PIP_PREFIX=$(pwd)/_build/pip_packages
          export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
          export PATH="$PIP_PREFIX/bin:$PATH"
          unset SOURCE_DATE_EPOCH
        '';
      };
    });
  };
}
