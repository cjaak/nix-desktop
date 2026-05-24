{ pkgs, ... }: {
  home.username = "charlie";
  home.homeDirectory = "/home/charlie";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    networkmanagerapplet
    arandr
    mangohud
    feh
    pamixer
    xorg.xprop
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "charlie";
      email = "chwiegand@proton.me";
    };
  };

  home.file.".wallpapers/landscape0.png".source = ../../assets/wallpaper/landscape0.png;

  programs.home-manager.enable = true;
}
