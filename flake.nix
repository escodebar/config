{
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    home-manager,
    nix-darwin,
    nixpkgs,
  }: let
    configuration = {
      lib,
      pkgs,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        alejandra
        curl
        docker
        fasd
        fd
        powerline
        ranger
        ripgrep
        tree
        vim-configured
      ];
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.hostPlatform = "aarch64-darwin";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      programs.tmux = {
        enable = true;
        extraConfig =
          ''
            source ${pkgs.powerline}/share/tmux/powerline.conf
          ''
          + lib.readFile ./configs/tmuxrc;
      };
      users.users.escodebar.home = /Users/escodebar;
    };
    overlays = let
      vim-overlay = final: prev: let
        python = prev.pkgs.python312.withPackages (ps: with ps; [powerline]);
        vim-powerline = prev.pkgs.vimUtils.buildVimPlugin {
          name = "powerline";
          namePrefix = "vim-";
          src = "${prev.pkgs.python312Packages.powerline}/share/vim";
        };
      in {
        vim-configured =
          (prev.pkgs.vim-full.override {
            python3 = python;
            wrapPythonDrv = true;
          })
          .customize {
            name = "vim";
            vimrcConfig = {
              customRC = prev.lib.readFile ./configs/vimrc;
              packages = {
                vim-configured = with prev.pkgs;
                with vimPlugins; {
                  start = [
                    editorconfig-vim
                    fzf-vim
                    syntastic
                    vim-colors-solarized
                    vim-fugitive
                    vim-powerline
                    vim-prettier
                    vim-sensible
                  ];
                };
              };
            };
          };
      };
    in {
      nixpkgs.overlays = [
        vim-overlay
      ];
    };
  in {
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        overlays
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.escodebar = import ./home-manager/escodebar.nix;
        }
      ];
    };
  };
}
