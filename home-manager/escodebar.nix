{
  config,
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "vim";
    FZF_DEFAULT_COMMAND = "fd --type f";
  };
  home.stateVersion = "24.05";
  programs.autojump.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      font = let
        family = "PragmataPro Mono Liga";
      in {
        normal = {
          inherit family;
        };
        bold = {
          inherit family;
          style = "regular";
        };
        italic = {
          inherit family;
        };
        bold_italic = {
          inherit family;
          style = "italic";
        };
        size = 14;
      };
      general.import = ["${pkgs.alacritty-theme}/solarized_light.toml"];
      terminal.shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [
          "new-session"
          "-A"
          "-D"
          "-s"
          "main"
        ];
      };
      window = {
        decorations = "None";
        startup_mode = "FullScreen";
      };
    };
  };
  programs.direnv.enable = true;
  programs.eza.enable = true;
  programs.fzf.enable = true;
  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      user.name = "Pablo Escodebar";
      user.email = "escodebar@gmail.com";
    };
  };
  programs.home-manager.enable = true;
  programs.zsh = {
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    enable = true;
    enableCompletion = true;
    history.ignoreAllDups = true;
    historySubstringSearch.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ../configs;
        file = "p10k";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "fzf-z";
        src = pkgs.zsh-z;
        file = "share/zsh-z/zsh-z.plugin.zsh";
      }
    ];
    syntaxHighlighting.enable = true;
  };
}
