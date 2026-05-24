{
  description = "desktop config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    username = "charlie";
    hostName = "desktop";
    DE = "awesome";
  in {
    nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit system username hostName DE; };
      modules = [
        ./hosts/desktop/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit username; };
          home-manager.users.${username} = import ./users/${username}/home.nix;
          home-manager.backupFileExtension = "bak";
        }
      ];
    };
    templates.default = {
      path = ./.;
      description = "The default template for Eriim's nixflakes.";
    };
  };
}
