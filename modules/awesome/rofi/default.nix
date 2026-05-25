{ pkgs, ... }: {
  home.packages = [ pkgs.rofi ];
  home.file = {
    ".config/rofi/config.rasi".source = ./config.rasi;
    ".config/rofi/apps.sh" = {
      source = ./apps.sh;
      executable = true;
    };
    ".config/rofi/tmux.sh" = {
      source = ./tmux.sh;
      executable = true;
    };
    ".config/rofi/window.sh" = {
      source = ./window.sh;
      executable = true;
    };
    ".config/rofi/powermenu/run.sh" = {
      source = ./powermenu/run.sh;
      executable = true;
    };
    ".config/rofi/powermenu/style.rasi".source = ./powermenu/style.rasi;
  };
}
