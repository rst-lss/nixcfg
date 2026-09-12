{
  description = "NixOS configuration for rstlss-lab-pc";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, disko, home-manager, ... }: {
    nixosConfigurations.rstlss-lab-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager

        ./hosts/rstlss-lab-pc
      ];
    };
  };
}
