{ home-manager, username, ... }:
{
  home-manager.users.${username} = _: {
    home.file = {
      ".wallpaper".source = ./wallpaper;
    };
  };
}