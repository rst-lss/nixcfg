{
  config,
  pkgs,
  ...
}: let
  unisonDir = "${config.xdg.dataHome}/unison";

  ventoy =
    if pkgs.stdenv.isDarwin
    then "/Volumes/Ventoy"
    else "/run/media/${config.home.username}/Ventoy";
in {
  home.packages = [
    pkgs.unison
  ];

  home.sessionVariables.UNISON = unisonDir;

  home.file."${unisonDir}/doc:bok.prf".text = ''
    root = ${config.home.homeDirectory}
    root = ${ventoy}

    path = doc/bok
    ignore = Name .DS_Store
    fat = true
    auto = true
  '';

  home.file."${unisonDir}/doc:ppr.prf".text = ''
    root = ${config.home.homeDirectory}
    root = ${ventoy}

    path = doc/ppr
    ignore = Name .DS_Store
    fat = true
    auto = true
  '';

  home.file."${unisonDir}/doc:tmp.prf".text = ''
    root = ${config.home.homeDirectory}
    root = ${ventoy}

    path = doc/tmp
    ignore = Name .DS_Store
    fat = true
    auto = true
  '';
}
