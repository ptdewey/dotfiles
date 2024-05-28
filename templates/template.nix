{
  description = "Dev Shells Flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
  let
    system = builtins.currentSystem;
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells = {
      default = pkgs.mkShell {
        packages = with pkgs; [
          neovim
        ];

        shellHook = ''
          export EDITOR="nvim"
        '';
      };
    };
  };
}
