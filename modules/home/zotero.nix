# linux-only
{pkgs, ...}: let
  zoteroWrapped = pkgs.writeShellScriptBin "zotero" ''
    set -euo pipefail
    data_home="''${XDG_DATA_HOME:-$HOME/.local/share}"
    mkdir -p "$data_home/zotero"

    bwrap_args=(--dev-bind / / --tmpfs "$HOME" --unshare-user --disable-userns)

    shopt -s dotglob nullglob
    for entry in "$HOME"/*; do
      name="$(basename "$entry")"
      [ "$name" = ".zotero" ] && continue
      if [ -L "$entry" ]; then
        bwrap_args+=(--symlink "$(readlink "$entry")" "$HOME/$name")
      else
        bwrap_args+=(--bind "$entry" "$HOME/$name")
      fi
    done
    shopt -u dotglob nullglob

    bwrap_args+=(--bind "$data_home/zotero" "$HOME/.zotero")

    exec ${pkgs.bubblewrap}/bin/bwrap "''${bwrap_args[@]}" ${pkgs.zotero}/bin/zotero "$@"
  '';

  zoteroShare = pkgs.runCommand "zotero-share" {} ''
    mkdir -p $out
    cp -r ${pkgs.zotero}/share $out/share
  '';
in {
  home.packages = [zoteroWrapped zoteroShare];

  xdg.desktopEntries.zotero = {
    name = "Zotero";
    genericName = "Reference Manager";
    exec = "${zoteroWrapped}/bin/zotero %U";
    icon = "zotero";
    terminal = false;
    type = "Application";
    categories = ["Office" "Education"];
    mimeType = ["x-scheme-handler/zotero"];
  };
}
