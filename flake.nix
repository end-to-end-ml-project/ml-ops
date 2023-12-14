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
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [];
            };

          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [
                    # linuxPackages.nvidia_x11
                    # cudaPackages.cudnn_8_8_0
                    # cudaPackages.cudatoolkit
                  ];

                  languages.python = {
                    enable = true;
                    # version = "3.10.6";
                    package = pkgs.python310.withPackages(ps: with ps; [tkinter]);
                    poetry = {
                      enable = true;
                      activate.enable = true;
                      install.enable = true;
                    };

                  };


                  enterShell = ''
                    # export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
                    # solves "ImportError: libstdc++.so.6: cannot open shared object file: No such file or directory"
                    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH;

                    # nvidia stuff
                    # export LD_LIBRARY_PATH=${pkgs.libGL}/lib:$LD_LIBRARY_PATH
                    # export LD_LIBRARY_PATH=${pkgs.libGLU}/lib:$LD_LIBRARY_PATH
                    # export LD_LIBRARY_PATH=${pkgs.freeglut}/lib:$LD_LIBRARY_PATH
                    # export LD_LIBRARY_PATH=${pkgs.xorg.libX11}/lib:$LD_LIBRARY_PATH
                    export LD_LIBRARY_PATH=${pkgs.cudaPackages.cudnn_8_8_0}/lib:$LD_LIBRARY_PATH
                    # export LD_LIBRARY_PATH=${pkgs.cudaPackages.cudatoolkit.lib}/lib:$LD_LIBRARY_PATH

                  '';
                }
              ];
            };
          });
    };
}
