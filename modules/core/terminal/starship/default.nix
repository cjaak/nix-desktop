{pkgs, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      format = "[ ](bright-white)[ ](bold fg:black bg:bright-white)[](bg:yellow fg:bright-white)$nodejs$python[](fg:yellow bg:green)$git_branch$git_status[](fg:green bg:blue)$directory[](fg:blue)$fill[](fg:#d65d0e)$username[ ](fg:yellow bg:#d65d0e)$hostname[](fg:bright-white bg:yellow)$time[ ](fg:bright-white)\n$character";

      fill = {
        symbol = "-";
        style = "fg:bright-black";
      };

      nodejs = {
        style = "fg:black bg:yellow";
        symbol = "󰎙 ";
        format = "[$symbol($version)]($style)";
      };

      python = {
        style = "fg:black bg:yellow";
        format = "[$symbol$pyenv_prefix($version )(($virtualenv) )]($style)";
        symbol = "  ";
        pyenv_version_name = false;
      };

      character = {
        success_symbol = "[  ](bold green)";
        error_symbol = "[  ](bold red)";
      };

      directory = {
        style = "fg:black bg:blue";
        format = "[$path]($style)";
        truncation_length = 5;
        truncation_symbol = "󰉒 /";
        home_symbol = "  ";
        truncate_to_repo = false;
      };

      directory.substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
      };

      git_branch = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol $branch](fg:black bg:green)]($style)";
      };

      git_status = {
        style = "bg:green";
        format = "[[ ($all_status $ahead_behind)](fg:black bg:green)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R"; # 24-hour format for time
        format = "[  $time](fg:black bg:bright-white)"; # Nix fix here
      };

      hostname = {
        ssh_only = true;
        format = "[󰌘 ](fg:black bg:yellow)[$ssh_symbol](fg:black bg:yellow)";
        trim_at = "";
        disabled = false;
      };

      username = {
        format = "[ $user](bg:#d65d0e fg:black)";
        disabled = false;
        show_always = true;
      };
    };
  };
}