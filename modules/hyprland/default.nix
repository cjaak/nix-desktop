{ pkgs, username, inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
in {
  imports = [
    ./rofi/default.nix
    ./swaync/default.nix
    ./wlogout/default.nix
  ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  # wayland-session.nix sets this to true, which causes AwesomeWM to
  # double-start autostart apps (nm-applet, blueman) already launched by rc.lua
  services.xserver.desktopManager.runXdgAutostartIfNone = false;
  programs.gamemode.enable = true;

  home-manager.users.${username} = { pkgs, ... }: {
    gtk = {
      enable = true;
      theme = {
        name    = "gruvbox-dark";
        package = pkgs.gruvbox-dark-gtk;
      };
      iconTheme = {
        name    = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
    home.pointerCursor = {
      name    = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size    = 24;
      gtk.enable = true;
    };
    home.sessionVariables = {
      LIBVA_DRIVER_NAME                    = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME            = "nvidia";
      WLR_NO_HARDWARE_CURSORS              = "1";
      # GBM_BACKEND=nvidia-drm is intentionally omitted: it breaks XWayland,
      # which Proton (and therefore SWTOR) requires.
      GTK_CSD                              = "0";
      QT_WAYLAND_DISABLE_WINDOWDECORATION  = "1";
    };
    xdg.configFile."hypr/hyprland-plugins.lua".text = ''
      hl.plugin.load("${inputs.hy3.packages.${system}.hy3}/lib/libhy3.so")
    '';
    xdg.configFile."hypr/hyprland.lua".source = ./config/hyprland.lua;
    xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ./waybar/style.css;
    xdg.configFile."waybar/style".source = ./waybar/style;
    xdg.configFile."waybar/modules".source = ./waybar/modules;
    xdg.configFile."waybar/scripts/calendar.sh" = {
      source      = ./waybar/scripts/calendar.sh;
      executable  = true;
    };
    home.packages = with pkgs; [
      swaynotificationcenter
      wlogout
      swww
      waypaper
      swaylock      # lock screen
      grim          # screenshot
      slurp         # region select for screenshots
      wl-clipboard  # wl-copy / wl-paste
      pkgs-unstable.waybar
    ];
  };
}