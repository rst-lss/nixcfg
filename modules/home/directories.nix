{
  config,
  lib,
  pkgs,
  ...
}: {
  # XDG-ify gtk2 config + cursor icons where supported (see #6268)
  home.preferXdgDirectories = true;

  xdg.enable = true;

  xdg.userDirs = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    createDirectories = false;
    setSessionVariables = true;

    documents = "${config.home.homeDirectory}/doc/tmp";
    download = "${config.home.homeDirectory}/tmp";
    music = "${config.home.homeDirectory}/aud/tmp";
    pictures = "${config.home.homeDirectory}/pix/tmp";
    videos = "${config.home.homeDirectory}/pix/tmp";
    desktop = "${config.home.homeDirectory}/tmp";
    templates = "${config.home.homeDirectory}/tmp";
    publicShare = "${config.home.homeDirectory}/tmp";
  };

  xresources.path = lib.mkIf pkgs.stdenv.isLinux "${config.xdg.configHome}/X11/xresources";

  home.activation.createHomeTree = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p \
      "$HOME/doc/kb" \
      "$HOME/doc/ppr" \
      "$HOME/doc/bok" \
      "$HOME/doc/tmp" \
      "$HOME/pix/pic" \
      "$HOME/pix/vid" \
      "$HOME/pix/tmp" \
      "$HOME/aud/mus" \
      "$HOME/aud/pod" \
      "$HOME/aud/tmp" \
      "$HOME/git" \
      "$HOME/tmp" \
      "${config.xdg.cacheHome}/zsh" \
      "${config.xdg.dataHome}/zsh"
  '';

  # TODO: try to remove the .icons
  home.activation.checkHomeTree = lib.mkIf pkgs.stdenv.isLinux (lib.hm.dag.entryAfter ["createHomeTree"] ''
    allowed=(
      doc pix aud git tmp
      .cache .config .local
      .nix-profile
      .ssh .icons
      .zshenv
    )

    unexpected=()
    for entry in "$HOME"/.* "$HOME"/*; do
      base=$(basename "$entry")
      [ "$base" = "." ] && continue
      [ "$base" = ".." ] && continue
      found=0
      for a in "''${allowed[@]}"; do
        [ "$base" = "$a" ] && found=1 && break
      done
      [ "$found" -eq 0 ] && unexpected+=("$base")
    done

    if [ "''${#unexpected[@]}" -gt 0 ]; then
      echo "checkHomeTree: unexpected entries in \$HOME:"
      printf '  - %s\n' "''${unexpected[@]}"
      echo "Move them into doc/pix/aud/git/tmp, or add them to the" \
           "allowlist in modules/home/directories.nix if intentional."
      exit 1
    fi
  '');
}
