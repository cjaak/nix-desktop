{
  description = "desktop config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@attrs:
  let
    system = "x86_64-linux";

  in {
    nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        username = "charlie";
        hostName = "desktop";
        DE = "awesome";
       inherit system;
       } //attrs;
      modules = [./.];
    };
    templates.default = {
      path = ./.;
      description = "The default template for Eriim's nixflakes.";
    };
  };
}
