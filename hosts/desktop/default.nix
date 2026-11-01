{ hostName, username, system, deploy-rs, agenix, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    # SteelSeries Aerox 9 Wireless (1038:185a) can't handle USB Link Power Management;
    # without this it fails to re-enumerate after libinput grabs it in Hyprland
    "usbcore.quirks=1038:185a:0x0800"
  ];

  system.stateVersion = "25.11";

  environment.systemPackages = [
    deploy-rs.packages.${system}.default
    agenix.packages.${system}.default
  ];

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = hostName;
        "security" = "user";
        "map to guest" = "Bad User";
        "guest account" = "nobody";
      };
      share = {
        "path" = "/home/${username}/Share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = username;
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d /home/${username}/Share 0775 ${username} users -"
  ];
}
