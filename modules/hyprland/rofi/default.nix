{ username, pkgs, ... }: {
  home-manager.users.${username} = { pkgs, ... }: {
    home.packages = [ pkgs.papirus-icon-theme ];
    xdg.configFile."rofi/config.rasi".source = ./config.rasi;
    xdg.configFile."rofi/clipboard.rasi".source = ./clipboard.rasi;
  };
}
