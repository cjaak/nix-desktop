{ ... }: {
  imports = [ ./gaming ];

  home-manager.sharedModules = [
    (import ./discord)
    (import ./firefox)
    (import ./jetbrains)
    (import ./libreoffice)
    (import ./obs)
    (import ./onlyoffice)
    (import ./opencode)
    (import ./vscodium)
    (import ./blender)
    ({ pkgs, ... }: {
      home.packages = with pkgs; [ mullvad-vpn bambu-studio google-chrome freecad];
      programs.zathura.enable = true;
    })
  ];
}
