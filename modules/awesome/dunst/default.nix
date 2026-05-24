{ pkgs, ... }: {
  home.packages = [ pkgs.dunst ];
  home.file.".config/dunst/dunstrc".source = ./dunstrc;
}
