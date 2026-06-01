{ lib, pkgs, ... }:
let merge = lib.foldr (a: b: a // b) { };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles = {
      default = {
        id = 0;
        name = "Default";
        isDefault = true;
        settings = merge [
        (import ./settings.nix)
        (import ./browser-features.nix)
        ];
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          multi-account-containers
          privacy-redirect
          clearurls
          torrent-control
          return-youtube-dislikes
          vimium
        ];
        };
        "94fhoo6r.default" = {
          id = 1;
          name = "DefaultOld";
          isDefault = false;
        };
      };
    };
  }
