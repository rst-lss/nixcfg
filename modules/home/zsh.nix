{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history.path = "${config.xdg.dataHome}/zsh/history";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    sessionVariables = {
      EDITOR = "nvim";
      CDPATH = "$HOME/git";
    };

    completionInit = ''
      autoload -Uz compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
    '';

    envExtra = ''
      ${pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
        if [ -x /opt/homebrew/bin/brew ]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      ''}
      export PATH="$HOME/.local/bin:$PATH"
    '';

    initContent = ''
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey '^X^E' edit-command-line

      zvm_after_init() {
        bindkey '^R' fzf-history-widget
      }

      tmux() {
        if [[ $# -eq 0 ]]; then
          command tmux new-session -A -s base
        else
          command tmux "$@"
        fi
      }

      if [[ -z "$TMUX" && "$TERM" != "linux" && "$TERM" != "dumb" ]]; then
        tmux
      fi
    '';

    shellAliases = {
      v = "nvim";

      proxyon = ''export http_proxy=http://127.0.0.1:10808 https_proxy=http://127.0.0.1:10808 all_proxy=http://127.0.0.1:10808 && echo "Proxy enabled"'';
      proxyoff = ''unset http_proxy https_proxy all_proxy && echo "Proxy disabled"'';

      xdgninja = "nix run github:b3nj5m1n/xdg-ninja";
    };

    siteFunctions = {
      push-kb = ''
        (cd ~/doc/kb \
          && git add -A \
          && git commit -m "Manual backup on $(date '+%Y-%m-%d %H:%M:%S')" \
          && git push)
      '';
      pull-kb = ''
        (cd ~/doc/kb && git pull --rebase --autostash)
      '';
      check-kb = ''
        (cd ~/doc/kb && git status)
      '';
    };

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };
}
