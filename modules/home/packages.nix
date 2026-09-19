{pkgs, ...}: {
  # Cross-platform CLI tools only. Linux desktop / Wayland GUI tools live in
  # packages-linux.nix, imported only on Linux hosts.
  home.packages = with pkgs;
    [
      git
      gh
      fzf
      fd
      wget
      curl
      openssh
      tmux
      zip
      unzip
      opencode
      watchexec
      lazygit
      worktrunk
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      foot
      firefox
      wofi
      waybar
      mako
      libnotify
      telegram-desktop
      mpv
      obsidian
      calibre
      zotero
      sioyek
      nnn
      wl-clipboard
      pavucontrol
      brightnessctl
      playerctl
    ];
}
