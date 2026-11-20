{ username, ... }: {
  home-manager.users.${username} = { ... }: {
    xdg.configFile."swaync/config.json".source = ./config.json;
    xdg.configFile."swaync/style.css".source = ./style.css;
    xdg.configFile."swaync/style".source = ./style;
  };
}
