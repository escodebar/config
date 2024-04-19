{pkgs, ...}: {
  home.stateVersion = "24.05";
  programs.autojump.enable = true;
  programs.direnv.enable = true;
  programs.eza.enable = true;
  programs.fzf.enable = true;
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        userName = "Pablo Escodebar";
        userEmail = "escodebar@gmail.com";
      };
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
    initExtra = ''
      [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
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
