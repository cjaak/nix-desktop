{ pkgs, ... }: {
  home.packages = [ pkgs.picom ];
  home.file.".config/picom/picom.conf".source = ./picom.conf;
}
