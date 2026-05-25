{ pkgs, ... }: {
  home.packages = [ pkgs.polybar ];
  home.file = {
    ".config/polybar/config.ini".source = ./config.ini;
    ".config/polybar/colors.ini".source = ./colors.ini;
    ".config/polybar/cpu.ini".source = ./cpu.ini;
    ".config/polybar/gpu.ini".source = ./gpu.ini;
    ".config/polybar/network.ini".source = ./network.ini;
    ".config/polybar/system.ini".source = ./system.ini;
    ".config/polybar/utils.ini".source = ./utils.ini;
    ".config/polybar/launch.sh" = {
      source = ./launch.sh;
      executable = true;
    };
    ".config/polybar/scripts/workspaces.sh" = {
      source = ./scripts/workspaces.sh;
      executable = true;
    };
    ".config/polybar/scripts/switch-workspace.sh" = {
      source = ./scripts/switch-workspace.sh;
      executable = true;
    };
    ".config/polybar/scripts/dunst.sh" = {
      source = ./scripts/dunst.sh;
      executable = true;
    };
    ".config/polybar/scripts/nix.sh" = {
      source = ./scripts/nix.sh;
      executable = true;
    };
    ".config/polybar/scripts/ufw.sh" = {
      source = ./scripts/ufw.sh;
      executable = true;
    };
  };
}
