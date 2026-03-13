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
      commit.gpgSign = true;
      init.defaultBranch = "main";
      signing.signByDefault = true;
      user = {
        name = "Pablo Vergés";
        email = "hello@pablo.codes";
        signingKey = "AD62A4F3DBFC7908";
      };
    };
  };
  programs.gpg.enable = true;
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    extraConfig = lib.readFile ../configs/neovim;
    extraLuaConfig = ''
      vim.lsp.enable({
        "bashls",
        "nixd",
        "pyright",
        "ts_ls",
      })

      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "K", vim.lsp.buf.hover)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    '';
    plugins = [
      {
        plugin = pkgs.vimPlugins.lualine-nvim;
        config = ''
          lua << END
          require('lualine').setup {
            options = {
              theme = 'solarized'
            }
          }
          END
        '';
      }
      {
        plugin = pkgs.vimPlugins.telescope-nvim;
        config = ''
          lua << END
          local telescope = require("telescope")
          telescope.setup({
            extensions = {
              fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
              }
            }
          })
          telescope.load_extension("fzf")
          vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files)
          END
        '';
      }
      pkgs.vimPlugins.telescope-fzf-native-nvim
      {
        plugin = pkgs.vimPlugins.solarized-nvim;
        config = ''
          lua << END
          require('solarized').set()
          END
        '';
      }
    ];
  };
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
