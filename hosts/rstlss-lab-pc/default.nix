{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./disko.nix

    ../../modules/nixos/desktop.nix
    ../../modules/nixos/snapshots.nix
    ../../modules/nixos/virtualization.nix
    ../../modules/nixos/automount.nix
    ../../home/rstlss
  ];

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "dirty";

  networking.hostName = "rstlss-lab-pc";
  time.timeZone = "Asia/Tehran";

  users.users.rstlss = {
    isNormalUser = true;
    description = "rstlss";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "docker"
    ];
    initialPassword = "rstlss";
  };

  programs.zsh.enable = true;

  services.getty.autologinUser = null;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  zramSwap.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.use-xdg-base-directories = true;

  system.stateVersion = "26.05";
}
