{...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;

    changeDirWidgetCommand = "fd --type d --hidden --exclude .git . $HOME";
    defaultCommand = "fd --type f --hidden --exclude .git . $HOME";
    fileWidgetCommand = "fd --type f --hidden --exclude .git . $HOME";
    defaultOptions = ["--ansi"];
  };
}
