{
  description = "Jacob's darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager }: {
    darwinConfigurations."Jacobs-MacBook-Air" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./src/darwin/configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jacobranson = import ./src/home.nix;
          };
        }
      ];
    };
  };
}

