{ pkgs, ... }:
{
  home.username = "charlie";
  home.homeDirectory = "/home/charlie";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    firefox
    jetbrains.idea-community
    networkmanagerapplet
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "charlie";
      email = "chwiegand@proton.me";
    };
  };

  programs.home-manager.enable = true;
}
