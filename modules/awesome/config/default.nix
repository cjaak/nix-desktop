{ ... }: {
  home.file = {
    ".config/awesome/rc.lua".source = ./rc.lua;
    ".scripts/startup.sh" = {
      source = ./startup.sh;
      executable = true;
    };
    ".scripts/screenlayout/default.sh" = {
      source = ./screenlayout.sh;
      executable = true;
    };
  };
}
