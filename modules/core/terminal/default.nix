{ pkgs, username, ... }: {
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
    playerctl
    ripgrep
    todoist-electron
    unzip
    vhs
    zoxide
    zip
    unzip
    gcc
    python3
    python3Packages.pip
    ffmpeg
    cron
    file
    wget
    openssl
    nodejs
  ];

  home-manager.sharedModules = [
    (import ./wezterm)
    (import ./starship)
    (import ./tmux)
    (import ./nvim)
    (import ./yazi)
    ({ ... }: {
      programs.git = {
        enable = true;
        settings.user = {
          name = username;
          email = "chwiegand@proton.me";
        };
      };
    })
  ];
}
