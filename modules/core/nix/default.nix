{ pkgs, username, nur, nixpkgs-unstable, system, ... }: {

  nixpkgs.overlays = [
    (final: prev: {
      nur = import nur { nurpkgs = prev; pkgs = prev; };
      bambu-studio = (import nixpkgs-unstable { inherit system; config.allowUnfree = true; }).bambu-studio;
    })
  ];

  # Enable Flakes and nix-commands, enable removing channels
    nix = {
      #package = pkgs.nixVersions.nix_2_21;
      nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };




    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;

      users.${username} = {
        # The home.stateVersion option does not have a default and must be set
        home.homeDirectory = "/home/${username}";
        home.stateVersion = "25.11";
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
}
