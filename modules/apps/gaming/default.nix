{ pkgs, lib, ... }:
let
  starparseDesktop = pkgs.makeDesktopItem {
    name = "starparse";
    exec = "starparse";
    desktopName = "StarParse";
    comment = "SWTOR Combat Parser";
    categories = [ "Game" ];
    icon = "starparse";
  };

  starparse-src = pkgs.fetchFromGitHub {
    owner = "Sinrai";
    repo = "StarParse";
    rev = "master";
    hash = "sha256-tT4vPVrlHsttRF1DjFVIQHWDZUu1647hhGb5HpHiQ3s=";
  };

  starparse-deps = pkgs.stdenv.mkDerivation {
    name = "starparse-deps";
    src = starparse-src;
    nativeBuildInputs = [ pkgs.maven pkgs.jdk ];
    buildPhase = ''
      mvn -B dependency:go-offline -Dmaven.repo.local=$out
    '';
    dontInstall = true;
    outputHash = "sha256-WMrZiEo8sfGpQ/fkmLxpPlIaQLwmmZ/H4dossiLTiio=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  starparse = pkgs.stdenv.mkDerivation {
    pname = "starparse";
    version = "1.1";
    src = starparse-src;
    nativeBuildInputs = [ pkgs.maven pkgs.jdk pkgs.makeWrapper ];
    buildPhase = ''
      cp -r ${starparse-deps} $TMPDIR/m2repo
      chmod -R u+w $TMPDIR/m2repo
      mvn -B package dependency:copy-dependencies -DskipTests \
        -DoutputDirectory=target/libs \
        -DincludeScope=runtime \
        -Dmaven.repo.local=$TMPDIR/m2repo
    '';
    installPhase = ''
      runHook preInstall
      install -Dm644 starparse-client/target/starparse-client-1.1.jar \
        $out/share/starparse/starparse.jar
      mkdir -p $out/share/starparse/libs
      cp starparse-client/target/libs/*.jar $out/share/starparse/libs/
      mkdir -p $out/share/starparse/javafx
      mv $out/share/starparse/libs/javafx-*.jar $out/share/starparse/javafx/
      install -Dm644 starparse-client/src/main/resources/img/Star-Wars-The-Old-Republic-8-icon.png \
        $out/share/icons/hicolor/128x128/apps/starparse.png
      install -Dm644 ${starparseDesktop}/share/applications/starparse.desktop \
        $out/share/applications/starparse.desktop
      makeWrapper ${pkgs.jre}/bin/java $out/bin/starparse \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
          pkgs.libGL pkgs.glib pkgs.gtk3 pkgs.gtk2
          pkgs.xorg.libX11 pkgs.xorg.libXtst pkgs.xorg.libXxf86vm
          pkgs.zlib pkgs.freetype pkgs.fontconfig
          pkgs.cairo pkgs.harfbuzz pkgs.pango pkgs.gdk-pixbuf
          pkgs.alsa-lib pkgs.at-spi2-core pkgs.ffmpeg
        ]}" \
        --add-flags "--module-path $out/share/starparse/javafx" \
        --add-flags "--add-modules javafx.controls,javafx.fxml,javafx.graphics,javafx.media" \
        --add-flags "-cp $out/share/starparse/starparse.jar:$out/share/starparse/libs/*" \
        --add-flags "com.ixale.starparse.gui.Main"
      runHook postInstall
    '';
  };

  baras = pkgs.appimageTools.wrapType2 {
    pname = "baras";
    version = "2026.5.13";
    src = pkgs.fetchurl {
      url = "https://github.com/baras-app/baras/releases/download/v2026.5.13/BARAS_2026.5.13_amd64.AppImage";
      hash = "sha256-DZkWtTia8mbdT48xAmVf/HNeVSOTPaiJPnn9d4k5s+E=";
    };
    extraInstallCommands =
      let
        icon = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/baras-app/baras/master/app/src-tauri/icons/128x128.png";
          hash = "sha256-dl2+oXYY650AA9oI/5bYUpOYp2iJ3jIkGD8BQjAy/WY=";
        };
        desktop = pkgs.makeDesktopItem {
          name = "baras";
          exec = "baras";
          desktopName = "BARAS";
          comment = "SWTOR Combat Parser";
          categories = [ "Game" ];
          icon = "baras";
        };
      in
      ''
        install -Dm644 ${desktop}/share/applications/baras.desktop $out/share/applications/baras.desktop
        install -Dm644 ${icon} $out/share/icons/hicolor/128x128/apps/baras.png
      '';
  };
in {
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
    wine
    baras
    starparse
  ];

  home-manager.sharedModules = [
    ({ lib, ... }: {
      home.file.".config/antimicrox/standard4arrowkeys.gamecontroller.amgp".source = ./standard4arrowkeys.gamecontroller.amgp;

      home.activation.antimicroxSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        _cfg="$HOME/.config/antimicrox/antimicrox_settings.ini"
        if [ ! -f "$_cfg" ] || [ -L "$_cfg" ]; then
          rm -f "$_cfg"
          cat > "$_cfg" << 'EOF'
[General]
DisplayNames=0
LastProfileDir=/home/charlie/.config/antimicrox

[Controllers]
Controller03002a52de000000545700001101000022222356ConfigFile1=/home/charlie/.config/antimicrox/standard4arrowkeys.gamecontroller.amgp
Controller03002a52de000000545700001101000022222356LastSelected=/home/charlie/.config/antimicrox/standard4arrowkeys.gamecontroller.amgp
EOF
        fi
      '';
    })
  ];
}
