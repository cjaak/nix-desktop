{ config, pkgs, lib, username, ... }:
lib.mkIf (config.networking.hostName == "desktop") {

  # OpenRGB — udev rules + GUI for Zotac GPU lighting
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = pkgs.openrgb-with-all-plugins;
  };

  # i2c-dev exposes SMBus to userspace so OpenRGB can detect the GPU
  boot.kernelModules = [ "i2c-dev" ];

  # nzxt_kraken3 kernel driver blocks liquidctl from claiming the USB device directly
  boot.blacklistedKernelModules = [ "nzxt_kraken3" ];

  # liquidctl — udev rules for NZXT Kraken Elite (lighting + LCD)
  services.udev.packages = [ pkgs.liquidctl ];

  environment.systemPackages = with pkgs; [
    liquidctl
    openrgb-with-all-plugins
    usbutils
  ];

  # Initialize Kraken on every boot so it comes up in a known state
  systemd.services.liquidctl-init = {
    description = "Initialize liquidctl devices";
    after = [ "systemd-udev-settle.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.liquidctl}/bin/liquidctl initialize all";
      RemainAfterExit = true;
    };
  };

  users.users.${username}.extraGroups = [ "plugdev" ];
}