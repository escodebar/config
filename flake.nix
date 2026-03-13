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
    alacritty-theme = {
      url = "github:alexghr/alacritty-theme.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    alacritty-theme,
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
        bash-language-server
        black
        curl
        docker
        entr
        fasd
        fd
        lynx
        nixd
        nodePackages.prettier
        powerline
        prettierd
        pyright
        ranger
        ripgrep
        tree
        typescript-language-server
        vim-configured
        vscode
      ];
      environment.variables = {
        EDITOR = "vim";
        FZF_DEFAULT_COMMAND = "fd --type f";
      };
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      users.users.escodebar.home = /Users/escodebar;
    };
    overlays = let
      vim-overlay = final: prev: let
        python = prev.pkgs.python312.withPackages (ps:
          with ps; [
            black
            distutils
            powerline
          ]);
        vim-black = prev.pkgs.vimUtils.buildVimPlugin {
          name = "black";
          namePrefix = "vim-";
          src = prev.pkgs.fetchFromGitHub {
            owner = "EgZvor";
            repo = "vim-black";
            rev = "main";
            sha256 = "sha256-EY0P0WfFCj5FEPj/hIMeua/1HR9/ZO1l0MbMTtgU9FM=";
          };
        };
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
                    vim-black
                    vim-codefmt
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
        alacritty-theme.overlays.default
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
