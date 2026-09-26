{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.rstlss = {
      imports =
        [
          ../../modules/home/git.nix
          ../../modules/home/neovim
          ../../modules/home/packages.nix
          ../../modules/home/ssh.nix
          ../../modules/home/zsh.nix
          ../../modules/home/starship.nix
          ../../modules/home/fzf.nix
          ../../modules/home/zoxide.nix
          ../../modules/home/direnv.nix
          ../../modules/home/tmux.nix
          ../../modules/home/directories.nix
          ../../modules/home/unison.nix
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          ../../modules/home/appearance.nix
          ../../modules/home/foot.nix
          ../../modules/home/hyprland.nix
          ../../modules/home/xsession.nix
          ../../modules/home/v2rayn.nix
          ../../modules/home/udiskie.nix
        ];

      home = {
        username = "rstlss";
        homeDirectory =
          if pkgs.stdenv.isDarwin
          then "/Users/rstlss"
          else "/home/rstlss";
        stateVersion = "26.05";
      };
    };
  };
}
