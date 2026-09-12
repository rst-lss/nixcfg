{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      fingers
      open
      {
        plugin = tmux-fzf;
        extraConfig = ''
          set-environment -g TMUX_FZF_LAUNCH_KEY "T"
        '';
      }
      {
        plugin = gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-dir '$HOME/.local/share/tmux/resurrect'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-save-interval '15'
          set -g @continuum-restore 'off'
        '';
      }
    ];

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"
      set -g renumber-windows on
      set -g set-clipboard on

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind-key "L" run-shell "sesh last || tmux display-message -d 1000 'Only one session'"

      bind-key "R" display-popup -E -h 60% -w 60% \
        "sesh connect \"$(sesh list -i -H | fzf --tmux 60%,60% --no-sort --ansi --border-label ' sesh root ' --query '$(sesh root)')\""

      bind-key x kill-pane

      bind-key X run-shell "sesh last && tmux kill-session -t #{session_name}"
    '';
  };

  programs.sesh = {
    enable = true;
    tmuxKey = "f";
    icons = true;
  };
}
