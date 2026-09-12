{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = false;
  };

  services.dbus.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.physlock = {
    enable = true;
    allowAnyUser = true;
    disableSysRq = true;
    lockOn = {
      suspend = true;
      hibernate = true;
    };
  };

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  security.rtkit.enable = true;

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  networking.wireless.iwd.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    terminus_font_ttf
    nerd-fonts.bigblue-terminal
    jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    pciutils
    usbutils
    lm_sensors
    smartmontools
  ];

  programs.ssh.startAgent = true;
}
