{
  lib,
  pkgs,
  revision,
  ...
}: let
in {
  environment.variables = {
    EDITOR = "vim";
  };
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  system.configurationRevision = revision;
  system.stateVersion = 4;
  programs.tmux = {
    enable = true;
    extraConfig =
      ''
        source ${pkgs.powerline}/share/tmux/powerline.conf
      ''
      + lib.readFile ./configs/tmuxrc;
  };
}
