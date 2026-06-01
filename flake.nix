{
  description = "my nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
            url = "github:ryantm/agenix";
            inputs.nixpkgs.follows = "nixpkgs";
    };
    recyclarr-configs = {
            url = "github:recyclarr/config-templates";
            flake = false;
    };
    nix-index-database = {
            url = "github:Mic92/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs, ... }@attrs:
  let
    system = "x86_64-linux";

  in {
    deploy.nodes.nixos-server = {
      hostname = "192.168.178.59";
      magicRollback = false;
      profiles.system = {
        sshUser = "charlie";
        user = "root";
        sshOpts = [ "-p" "69" ];
        remoteBuild = false;
        path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.nixos-server;
      };
    };

    nixosConfigurations = {
        nixos-desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            username = "charlie";
            hostName = "desktop";
            DE = "awesome";
           inherit system;
           } //attrs;
          modules = [./.];
       };
       nixos-server = nixpkgs.lib.nixosSystem {
         inherit system;
         specialArgs = {
           username = "charlie";
           hostName = "server";
           DE = null;
           vars = import ./hosts/server/vars.nix;
           inputs = attrs;
          inherit system;
          } //attrs;
         modules = [
            ./.
            ./modules/homelab
            ./modules/agenix
         ];
      };
    };
    templates.default = {
      path = ./.;
      description = "The default template for Eriim's nixflakes.";
    };
  };
}
