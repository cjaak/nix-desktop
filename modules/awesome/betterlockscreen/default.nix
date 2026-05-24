{ pkgs, ... }: {
  home.packages = [ pkgs.betterlockscreen ];
  home.file.".config/betterlockscreen/betterlockscreenrc".source = ./betterlockscreenrc;
}
