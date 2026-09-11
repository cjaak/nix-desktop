{ pkgs, lib, username, system, deploy-rs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.11";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "console";
    networkmanager.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = username;
    desktopSession = "gamescope-wayland";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwCrkUq76rnolIfL8eApseG7rlmxCWDlqPx2Xti/fYH chwiegand@proton.me"
  ];

  programs.fish.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    htop
    deploy-rs.packages.${system}.default
  ];
}