{ hostName, username,... }: {
   networking = {
      networkmanager = {
        enable = true;
      };
      inherit hostName;
    };
    users.users.${username} = {
      extraGroups = [ "networkmanager" ];
    };
}
