{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [
    gamescope
    mangohud
    antimicrox
    bottles
    lutris
  ];

  home-manager.sharedModules = [
    ({ ... }: {
      home.file.".config/antimicrox/antimicrox_settings.ini".source = ./antimicrox_settings.ini;
      home.file.".config/antimicrox/standard4arrowkeys.gamecontroller.amgp".source = ./standard4arrowkeys.gamecontroller.amgp;
    })
  ];
}
