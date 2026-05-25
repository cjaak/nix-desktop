{ pkgs, username, ... }: {

  system = {
      stateVersion = "25.11";
    };
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

      users.${username} = {
        # The home.stateVersion option does not have a default and must be set
        home.homeDirectory = "/home/${username}";
        home.stateVersion = "25.11";
        nixpkgs.config.allowUnfree = true;
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
}
