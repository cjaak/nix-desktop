{ ... }: {
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
    (import ./thunar)
  ];

  environment = {
      systemPackages = with pkgs; [
        eww
        xfce.thunar
        xfce.tumbler
        xfce.thunar-volman
      ];
    };

  services.gnome = {
      gnome-keyring.enable = true;
    };


}
