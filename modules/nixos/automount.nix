{pkgs, ...}: {
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    udisks2
    exfatprogs
    ntfs3g
  ];
}
