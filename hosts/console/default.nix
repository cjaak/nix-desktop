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

  jovian.decky-loader = {
    enable = true;
    user = username;
  };

  services.udisks2.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  security.sudo.extraRules = [{
    users = [ username ];
    commands = [
      { command = "${pkgs.systemd}/bin/systemctl start wg-quick-wg0"; options = [ "NOPASSWD" ]; }
      { command = "${pkgs.systemd}/bin/systemctl stop wg-quick-wg0";  options = [ "NOPASSWD" ]; }
    ];
  }];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  nix.settings = {
    substituters = [ "https://jovian.cachix.org" ];
    trusted-public-keys = [ "jovian.cachix.org-1:MEf8Kz4R5VC14bRqCuLtP1I3JmHqSByXjANJ/xpVNM8=" ];
  };

  home-manager.users.${username} = {
    home.enableNixpkgsReleaseCheck = false;
    home.file.".steam/steam/.cef-enable-remote-debugging".text = "";
  };

  users.users.${username} = {
    extraGroups = [ "input" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwCrkUq76rnolIfL8eApseG7rlmxCWDlqPx2Xti/fYH chwiegand@proton.me"
    ];
  };

  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [];

  networking.wg-quick.interfaces.wg0 = {
    address = [ "192.168.89.216/24" ];
    dns = [ "192.168.89.118" "192.168.89.1" "fritz.box" ];
    privateKeyFile = "/etc/wireguard/private.key";
    peers = [{
      publicKey = "MsdG5hCN1wuQ7zH/iExf23F02wpauqjeNaOUTGH2TDI=";
      presharedKeyFile = "/etc/wireguard/preshared.key";
      allowedIPs = [ "192.168.89.0/24" "0.0.0.0/0" ];
      endpoint = "dpfok4cdqpdx4xgb.myfritz.net:57167";
      persistentKeepalive = 25;
    }];
    postUp = "ip rule add to 192.168.178.0/24 table main priority 100";
    postDown = "ip rule del to 192.168.178.0/24 table main priority 100 || true";
  };

  programs.fish.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    htop
    google-chrome
    (kodi-wayland.withPackages (p: with p; [
      jellycon
      inputstream-adaptive
      inputstreamhelper
      netflix
      youtube
      sponsorblock
      joystick
      controller-topology-project
    ]))
    (writeShellScriptBin "kodi-streaming" ''
      sudo ${pkgs.systemd}/bin/systemctl start wg-quick-wg0
      ${kodi-wayland.withPackages (p: with p; [
        jellycon inputstream-adaptive inputstreamhelper netflix
        youtube sponsorblock joystick controller-topology-project
      ])}/bin/kodi
      sudo ${pkgs.systemd}/bin/systemctl stop wg-quick-wg0
    '')
    (writeShellScriptBin "nebula" ''
      exec ${google-chrome}/bin/google-chrome-stable \
        --ozone-platform=x11 \
        --use-gl=desktop \
        --app=https://nebula.tv \
        --start-fullscreen \
        --no-first-run \
        --no-default-browser-check \
        --user-data-dir="$HOME/.config/chrome-nebula"
    '')
    (writeShellScriptBin "disney-plus" ''
      sudo ${pkgs.systemd}/bin/systemctl start wg-quick-wg0
      ${google-chrome}/bin/google-chrome-stable \
        --ozone-platform=x11 \
        --use-gl=desktop \
        --app=https://www.disneyplus.com \
        --start-fullscreen \
        --no-first-run \
        --no-default-browser-check \
        --user-data-dir="$HOME/.config/chrome-disney-plus"
      sudo ${pkgs.systemd}/bin/systemctl stop wg-quick-wg0
    '')
  ];
}