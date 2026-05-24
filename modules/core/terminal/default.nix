{ pkgs, ... }: {
  imports = [
    ./fish
    ./fonts
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    btop
    gh
    ghostty
    mods
    nitch
    pavucontrol
    playerctl
    ripgrep
    todoist-electron
    unzip
    vhs
    zoxide
  ];

  home-manager.sharedModules = [
    (import ./wezterm)
    (import ./starship)
    (import ./tmux)
    (import ./nvim)
    (import ./yazi)
  ];
}
