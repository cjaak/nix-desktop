{ hostName, username, system, deploy-rs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.11";

  environment.systemPackages = [ deploy-rs.packages.${system}.default ];

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
