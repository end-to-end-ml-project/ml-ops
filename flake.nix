{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    extra-substituters = [
      "https://devenv.cachix.org"
    ];
  };

  outputs = { 
    self,
    nixpkgs,
    devenv,
    systems,
    ...
  } @ inputs:

    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [
                    poetry

                    # pyenv
                    # gcc
                    # gnumake
                    # zlib
                  ];

                  languages.python = {
                    enable = true;
                    version = "3.10.6";

                    # venv = {
                      # enable = true;
                      # requirements = ''
                      #   jupyterlab
                      #   tensorflow
                      #   mlflow

                      #   virtualenv
                      # '';
                    # };

                  };


                  enterShell = ''
                    # export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
                    # solves "ImportError: libstdc++.so.6: cannot open shared object file: No such file or directory"
                    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH;
                  '';
                }
              ];
            };
          });
    };
}
