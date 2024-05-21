{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    direnv
    fasd
    fd
    fzf
    powerline
    pyenv
    ranger
    ripgrep
    sops
    tree
    vault
    vim-configured
    vscode-configured
  ];
}
