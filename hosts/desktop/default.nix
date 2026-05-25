{ ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # ---- Host-specific config ----
  networking.hostName = "nixos-desktop";
  system.stateVersion = "25.11";
}
