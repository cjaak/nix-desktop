{ config, pkgs, lib, username, ... }:
{
  imports = [ ./nixos-server ];

  system.stateVersion = "22.11";

  email = {
    fromAddress = "server@charlie-hub.cloud";
    toAddress = "chwiegand@proton.me";
    smtpServer = "smtp.ionos.de";
    smtpUsername = "server@charlie-hub.cloud";
    smtpPasswordPath = config.age.secrets.smtpPassword.path;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  users.users = {
    root = {
      hashedPasswordFile = config.age.secrets.hashedUserPassword.path;
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwCrkUq76rnolIfL8eApseG7rlmxCWDlqPx2Xti/fYH chwiegand@proton.me" ];
    };
    ${username} = {
      uid = 1000;
      group = username;
      hashedPasswordFile = config.age.secrets.hashedUserPassword.path;
      extraGroups = [ "podman" "users" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwCrkUq76rnolIfL8eApseG7rlmxCWDlqPx2Xti/fYH chwiegand@proton.me" ];
    };
  };
  users.groups.${username}.gid = 1000;

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      PermitRootLogin = "no";
    };
    ports = [ 69 ];
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  nix.settings.experimental-features = lib.mkDefault [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ username ];

  hardware.graphics.enable = true;

  programs.fish.enable = true;
  programs.git.enable = true;
  programs.mosh.enable = true;
  programs.htop.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  security = {
    doas.enable = lib.mkDefault false;
    sudo = {
      enable = lib.mkDefault true;
      wheelNeedsPassword = lib.mkDefault false;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    iperf3
    eza
    neofetch
    (python310.withPackages(ps: with ps; [ pip ]))
    tmux
    rsync
    iotop
    ncdu
    nmap
    jq
    ripgrep
    sqlite
    lm_sensors
    jc
    moreutils
    lsof
    fatrace
    git-crypt
    bfg-repo-cleaner
  ];
}