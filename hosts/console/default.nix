{ pkgs, lib, username, ... }: {
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

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/3a4832d5-1b9e-44b1-9b6c-bbfbf42305f9";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
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

  nix.settings = {
    substituters = [ "https://jovian.cachix.org" ];
    trusted-public-keys = [ "jovian.cachix.org-1:MEf8Kz4R5VC14bRqCuLtP1I3JmHqSByXjANJ/xpVNM8=" ];
  };

  home-manager.users.${username}.home.enableNixpkgsReleaseCheck = false;

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwCrkUq76rnolIfL8eApseG7rlmxCWDlqPx2Xti/fYH chwiegand@proton.me"
  ];

  programs.fish.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    htop
  ];
}