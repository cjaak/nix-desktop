{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/hardware
    ../../modules/apps
    ../../modules/awesome
    ../../users/charlie
  ];

  # ---- Host-specific config ----
  networking.hostName = "nixos-desktop";
  time.timeZone = "Europe/Berlin";

  system.stateVersion = "25.11";
}
