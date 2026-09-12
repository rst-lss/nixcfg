{pkgs, ...}: {
  home.packages = with pkgs; [
    # gui
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

    # shell
    git
    gh
    fzf
    fd
    wget
    curl
    openssh
    tmux
    nnn
    wl-clipboard
    pavucontrol
    brightnessctl
    playerctl
    zip
    unzip
  ];
}
