{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../home/rstlss
  ];

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "dirty";

  system.primaryUser = "rstlss";

  networking.hostName = "rstlss-macbook";
  networking.computerName = "rstlss-macbook";
  time.timeZone = "Asia/Tehran";

  users.users.rstlss = {
    home = "/Users/rstlss";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nix.enable = false;

  system.stateVersion = 5;
}
