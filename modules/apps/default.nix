{ ... }: {
  imports = [ ./steam ];

  home-manager.sharedModules = [
    (import ./discord)
    (import ./firefox)
    (import ./jetbrains)
    (import ./libreoffice)
    (import ./obs)
    (import ./onlyoffice)
    (import ./opencode)
    (import ./vscodium)
    ({ pkgs, ... }: {
      home.packages = with pkgs; [ mullvad-vpn vscode ];
      programs.zathura.enable = true;
    })
  ];
}
