{pkgs, ...}: {
  gtk.enable = true;

  gtk.colorScheme = "dark";

  /*
  gtk.font = {
    name = "BigBlueTermPlus Nerd Font Mono";
    size = 14;
    package = pkgs.nerd-fonts.bigblue-terminal;
  };
  */

  fonts.fontconfig = {
    enable = true;

    /*
    defaultFonts = {
      monospace = [ "BigBlueTermPlus Nerd Font Mono" ];
      sansSerif = [ "BigBlueTermPlus Nerd Font" ];
      serif = [ "BigBlueTermPlus Nerd Font" ];
    };
    */
  };

  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 16;

    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_SIZE = "16";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
