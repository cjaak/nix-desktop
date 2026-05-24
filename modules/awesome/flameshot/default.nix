{ pkgs, ... }: {
  home.packages = with pkgs; [ flameshot xclip ];
  home.file.".config/flameshot/flameshot.ini".text = ''
    [General]
    buttons=@Invalid()
    contrastOpacity=188
    contrastUiColor=#e3d7ac
    disabledTrayIcon=true
    drawColor=#ff0000
    drawThickness=4
    savePath=/home/charlie/Pictures
    uiColor=#5E81AC
  '';
}
