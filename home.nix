{ pkgs, ... }:
{
  imports = [
    ./dots/starship/gruvbox.nix
    ./dots/wezterm/default.nix
  ];

  home.username = "charlie";
  home.homeDirectory = "/home/charlie";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    firefox
    jetbrains.idea-oss
    networkmanagerapplet
    rofi
    arandr
    claude-code
  ];

  programs.fish.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "charlie";
      email = "chwiegand@proton.me";
    };
  };

  programs.home-manager.enable = true;
}
