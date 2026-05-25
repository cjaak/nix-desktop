{ ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # ---- Host-specific config ----
  system.stateVersion = "25.11";
}
