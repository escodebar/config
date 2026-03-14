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
        curl
        docker
        entr
        fasd
        fd
        lynx
        powerline
        ranger
        ripgrep
        tree
        vscode
      ];
      environment.variables = {
        FZF_DEFAULT_COMMAND = "fd --type f";
      };
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      users.users.escodebar.home = /Users/escodebar;
    };
    overlays = {
      nixpkgs.overlays = [
        alacritty-theme.overlays.default
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
