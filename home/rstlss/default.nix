{...}: {
  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.rstlss = {
    imports = [
      ../../modules/home/appearance.nix
      ../../modules/home/foot.nix
      ../../modules/home/git.nix
      ../../modules/home/hyprland.nix
      ../../modules/home/neovim
      ../../modules/home/packages.nix
      ../../modules/home/ssh.nix
      ../../modules/home/xsession.nix
      ../../modules/home/zsh.nix
      ../../modules/home/v2rayn.nix
      ../../modules/home/starship.nix
      ../../modules/home/fzf.nix
      ../../modules/home/zoxide.nix
      ../../modules/home/direnv.nix
      ../../modules/home/tmux.nix
      ../../modules/home/directories.nix
    ];

    home.username = "rstlss";
    home.homeDirectory = "/home/rstlss";

    home.stateVersion = "26.05";
  };
}
