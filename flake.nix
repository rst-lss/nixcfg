{
  description = "NixOS + nix-darwin configuration for rstlss";

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

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, disko, home-manager, nix-darwin, ... }: {
    nixosConfigurations.rstlss-lab-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

      modules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager

        ./hosts/rstlss-lab-pc
      ];
    };

    darwinConfigurations.rstlss-macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      specialArgs = { inherit inputs; };

      modules = [
        home-manager.darwinModules.home-manager

        ./hosts/rstlss-macbook
      ];
    };
  };
}
