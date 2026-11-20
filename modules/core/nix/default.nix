{ pkgs, username, nur, nixpkgs-unstable, system, DE ? null, lib, ... }: {

  nixpkgs.overlays = lib.optionals (DE != null) [
    (final: prev: {
      nur = import nur { nurpkgs = prev; pkgs = prev; };
      bambu-studio =
        let
          base = (import nixpkgs-unstable { inherit system; config.allowUnfree = true; }).bambu-studio;
        in
        prev.symlinkJoin {
          name = "bambu-studio-nvidia-wayland";
          paths = [ base ];
          nativeBuildInputs = [ prev.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/bambu-studio \
              --set __GLX_VENDOR_LIBRARY_NAME mesa \
              --set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json \
              --set MESA_LOADER_DRIVER_OVERRIDE zink \
              --set GALLIUM_DRIVER zink
          '';
        };
    })
  ];

  boot.loader.systemd-boot.configurationLimit = 5;

  # Enable Flakes and nix-commands, enable removing channels
    nix = {
      #package = pkgs.nixVersions.nix_2_21;
      nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };




    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;

      users.${username} = {
        home.homeDirectory = "/home/${username}";
        home.stateVersion = "25.11";
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
}
