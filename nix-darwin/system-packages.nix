{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    direnv
    fasd
    fd
    fzf
    powerline
    ranger
    ripgrep
    tree
    vim-configured
    vscode-configured
  ];
}
