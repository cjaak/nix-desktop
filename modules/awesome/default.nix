{ pkgs, username, ... }: {
  services.xserver = {
    enable = true;
    windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [ luarocks luadbi-mysql ];
    };
  };

  services.libinput.mouse.middleEmulation = false;

  services.displayManager.ly = {
      enable = true;
      x11Support = true;
      settings = {
        # animation = "matrix";
        bigclock = true;
        hide_key_hints = true;
        clear_password = true;
        hide_version_string = true;
        term_reset_cmd = "${pkgs.ncurses}/bin/tput reset; ${pkgs.coreutils}/bin/printf '%b' '\\e]P0282828\\e]P7ebdbb2\\ec'";
      };
    };

  systemd.services.display-manager.serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/printf '%b' '\\e]P0282828\\e]P7ebdbb2\\ec'";

  services.gvfs.enable = true;

  home-manager.sharedModules = [
    (import ./betterlockscreen)
    (import ./config)
    (import ./dunst)
    (import ./flameshot)
    (import ./picom)
    (import ./polybar)
    (import ./rofi)
  ];

  home-manager.users.${username} = { pkgs, ... }: {
    gtk = {
      enable = true;
      cursorTheme.name = "Adwaita";
      cursorTheme.package = pkgs.adwaita-icon-theme;
    };
    home.packages = with pkgs; [
      networkmanagerapplet
      arandr
      feh
      pamixer
      xorg.xprop
      pfetch
    ];
  };

  environment.systemPackages = with pkgs; [
    luarocks
    eww
    xfce.thunar
    xfce.tumbler
    xfce.thunar-volman
    pavucontrol
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "xdph" "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
      };
    };
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
