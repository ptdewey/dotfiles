{
  description = "Dev Shells Flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { nixpkgs, ... }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system:
      ## comment for custom nixpkgs config
        function nixpkgs.legacyPackages.${system}
      );
      ## uncomment for custom nixpkgs config
      #   function (import nixpkgs {
      #   inherit system;
      #   config.allowUnfree = true;
      #   overlays = [ ];
      # }));

  in {
    devShells = forAllSystems(pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          neovim
        ];

        shellHook = ''
          export EDITOR="nvim"
        '';
      };
    });
  };
}
