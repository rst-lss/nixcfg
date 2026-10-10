{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = [
    (pkgs.lutris.override {
      steamSupport = false;
      extraPkgs = p: [
        p.wineWow64Packages.stable
        p.winetricks
        p.umu-launcher
      ];
    })
    pkgs.protonup-qt
    pkgs.vulkan-tools
  ];
}
