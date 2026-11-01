{ pkgs, username, inputs, system, ... }: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  # wayland-session.nix sets this to true, which causes AwesomeWM to
  # double-start autostart apps (nm-applet, blueman) already launched by rc.lua
  services.xserver.desktopManager.runXdgAutostartIfNone = false;

  home-manager.users.${username} = { pkgs, ... }: {
    xdg.configFile."hypr/hyprland-plugins.lua".text = ''
      hl.plugin.load("${inputs.hy3.packages.${system}.hy3}/lib/libhy3.so")
    '';
    xdg.configFile."hypr/hyprland.lua".source = ./config/hyprland.lua;
    xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ./waybar/style.css;
    home.packages = with pkgs; [
      swww          # wallpaper
      swaylock      # lock screen
      grim          # screenshot
      slurp         # region select for screenshots
      wl-clipboard  # wl-copy / wl-paste
      waybar
    ];
  };
}