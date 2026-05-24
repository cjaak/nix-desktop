{ ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.font = wezterm.font('JetBrainsMono Nerd Font')
      config.font_size = 13.0

      config.color_scheme = 'GruvboxDark'

      config.enable_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true
      config.use_fancy_tab_bar = false

      config.window_padding = {
        left = 8,
        right = 8,
        top = 8,
        bottom = 8,
      }

      config.scrollback_lines = 10000

      return config
    '';
  };
}