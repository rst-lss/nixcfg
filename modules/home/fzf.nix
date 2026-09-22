{
  config,
  pkgs,
  lib,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
  mediaDir = "/run/media/${config.home.username}";
  searchPaths = "$HOME" + lib.optionalString isLinux " ${mediaDir}";
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;

    changeDirWidgetCommand = "fd --type d --hidden --exclude .git . $HOME";
    defaultCommand = "fd --type f --hidden --exclude .git . ${searchPaths} 2>/dev/null";
    fileWidgetCommand = "fd --type f --hidden --exclude .git . ${searchPaths} 2>/dev/null";
    defaultOptions = ["--ansi"];
  };
}
