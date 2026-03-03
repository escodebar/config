{
  config,
  lib,
  pkgs,
  ...
}: rec {
  home.sessionVariables = {
    EDITOR = "vim";
    FZF_DEFAULT_COMMAND = "fd --type f";
    SHELL = "${pkgs.zsh}/bin/zsh";
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
      general.import = [pkgs.alacritty-theme.solarized_light];
      terminal.shell = {
        program = home.sessionVariables.SHELL;
        args = [
          "-lc"
          "exec tmux new-session -A -s main"
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
  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "Pablo Escodebar";
      user.email = "escodebar@gmail.com";
    };
  };
  programs.home-manager.enable = true;
  programs.rbw = {
    enable = true;
    settings = {
      email = "pablo.verges@gmail.com";
      pinentry = pkgs.pinentry-tty;
    };
  };
  programs.tmux = {
    enable = true;
    extraConfig = lib.readFile ../configs/tmuxrc;
    plugins = with pkgs; [
      tmuxPlugins.tmux-powerline
    ];
    shell = "${home.sessionVariables.SHELL}";
    terminal = "alacritty";
  };
  programs.zsh = {
    autosuggestion.enable = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";
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
