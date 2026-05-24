{ pkgs, username, ... }: {
  services.xserver = {
    enable = true;
    windowManager.awesome.enable = true;
    displayManager.lightdm.enable = true;
  };
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
      mangohud
      feh
      pamixer
      xorg.xprop
    ];
  };

  environment.systemPackages = with pkgs; [
    eww
    xfce.thunar
    xfce.tumbler
    xfce.thunar-volman
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
