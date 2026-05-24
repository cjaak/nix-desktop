{ pkgs, username, ... }: {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings.user = {
      name = username;
      email = "chwiegand@proton.me";
    };
  };

  home.file.".wallpapers/landscape0.png".source = ../../assets/wallpaper/landscape0.png;

  programs.home-manager.enable = true;
}
