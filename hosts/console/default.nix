{ pkgs, lib, username, ... }:
let
  # Renders one GLX frame on the current DISPLAY then exec's the given command.
  # Gamescope auto-enables display when it receives a DRI3 hardware frame from
  # the XWayland window — this is how Kodi works. Browsers never trigger that
  # because they render via EGL in a GPU subprocess. This binary forces it.
  glKickstart = pkgs.stdenv.mkDerivation {
    name = "gl-kickstart";
    src = pkgs.writeText "main.c" ''
      #include <X11/Xlib.h>
      #include <X11/Xutil.h>
      #include <unistd.h>

      /* Declare GLX without glx.h to avoid header path issues */
      typedef struct __GLXcontextRec *GLXContext;
      typedef unsigned long GLXDrawable;
      #define GLX_RGBA         4
      #define GLX_DOUBLEBUFFER 5
      #define GL_COLOR_BUFFER_BIT 0x4000

      extern XVisualInfo *glXChooseVisual(Display*, int, int*);
      extern GLXContext   glXCreateContext(Display*, XVisualInfo*, GLXContext, int);
      extern int          glXMakeCurrent(Display*, GLXDrawable, GLXContext);
      extern void         glXSwapBuffers(Display*, GLXDrawable);
      extern void         glClear(unsigned int);

      int main(int argc, char **argv) {
        Display *dpy = XOpenDisplay(NULL);
        if (dpy) {
          int attrs[] = { GLX_RGBA, GLX_DOUBLEBUFFER, 0 };
          XVisualInfo *vi = glXChooseVisual(dpy, DefaultScreen(dpy), attrs);
          if (vi) {
            GLXContext ctx = glXCreateContext(dpy, vi, NULL, 1);
            if (ctx) {
              XSetWindowAttributes swa;
              swa.colormap = XCreateColormap(
                dpy, RootWindow(dpy, vi->screen), vi->visual, AllocNone);
              Window win = XCreateWindow(
                dpy, RootWindow(dpy, vi->screen),
                0, 0, 1, 1, 0, vi->depth, InputOutput, vi->visual,
                CWColormap, &swa);
              XMapWindow(dpy, win);
              XFlush(dpy);
              glXMakeCurrent(dpy, win, ctx);
              glClear(GL_COLOR_BUFFER_BIT);
              glXSwapBuffers(dpy, win);
              XSync(dpy, False);
              usleep(200000);
            }
            XFree(vi);
          }
          XCloseDisplay(dpy);
        }
        if (argc > 1) execvp(argv[1], argv + 1);
        return 0;
      }
    '';
    buildInputs = with pkgs; [ libx11 libGL ];
    unpackPhase = "true";
    buildPhase = "$CC $src -lX11 -lGL -o gl-kickstart";
    installPhase = "mkdir -p $out/bin && cp gl-kickstart $out/bin/";
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.11";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "console";
    networkmanager.enable = true;
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/3a4832d5-1b9e-44b1-9b6c-bbfbf42305f9";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = username;
    desktopSession = "gamescope-wayland";
  };

  jovian.decky-loader = {
    enable = true;
    user = username;
  };

  services.udisks2.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  security.sudo.extraRules = [{
    users = [ username ];
    commands = [
      { command = "${pkgs.systemd}/bin/systemctl start wg-quick-wg0"; options = [ "NOPASSWD" ]; }
      { command = "${pkgs.systemd}/bin/systemctl stop wg-quick-wg0";  options = [ "NOPASSWD" ]; }
    ];
  }];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  nix.settings = {
    substituters = [ "https://jovian.cachix.org" ];
    trusted-public-keys = [ "jovian.cachix.org-1:MEf8Kz4R5VC14bRqCuLtP1I3JmHqSByXjANJ/xpVNM8=" ];
  };

  home-manager.users.${username} = {
    home.enableNixpkgsReleaseCheck = false;
    home.file.".steam/steam/.cef-enable-remote-debugging".text = "";
  };

  users.users.${username} = {
    extraGroups = [ "input" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwCrkUq76rnolIfL8eApseG7rlmxCWDlqPx2Xti/fYH chwiegand@proton.me"
    ];
  };

  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [];

  networking.wg-quick.interfaces.wg0 = {
    address = [ "192.168.89.216/24" ];
    dns = [ "192.168.89.118" "192.168.89.1" "fritz.box" ];
    privateKeyFile = "/etc/wireguard/private.key";
    peers = [{
      publicKey = "MsdG5hCN1wuQ7zH/iExf23F02wpauqjeNaOUTGH2TDI=";
      presharedKeyFile = "/etc/wireguard/preshared.key";
      allowedIPs = [ "192.168.89.0/24" "0.0.0.0/0" ];
      endpoint = "dpfok4cdqpdx4xgb.myfritz.net:57167";
      persistentKeepalive = 25;
    }];
    postUp = "ip rule add to 192.168.178.0/24 table main priority 100";
    postDown = "ip rule del to 192.168.178.0/24 table main priority 100 || true";
  };

  programs.fish.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    htop
    google-chrome
    (kodi-wayland.withPackages (p: with p; [
      jellycon
      inputstream-adaptive
      inputstreamhelper
      netflix
      youtube
      sponsorblock
      joystick
      controller-topology-project
    ]))
    (writeShellScriptBin "kodi-streaming" ''
      sudo ${pkgs.systemd}/bin/systemctl start wg-quick-wg0
      ${kodi-wayland.withPackages (p: with p; [
        jellycon inputstream-adaptive inputstreamhelper netflix
        youtube sponsorblock joystick controller-topology-project
      ])}/bin/kodi
      sudo ${pkgs.systemd}/bin/systemctl stop wg-quick-wg0
    '')
    (writeShellScriptBin "nebula" ''
      exec ${glKickstart}/bin/gl-kickstart ${pkgs.firefox-bin}/bin/firefox --kiosk https://nebula.tv
    '')
    (writeShellScriptBin "disney-plus" ''
      sudo ${pkgs.systemd}/bin/systemctl start wg-quick-wg0
      ${glKickstart}/bin/gl-kickstart ${pkgs.firefox-bin}/bin/firefox --kiosk https://www.disneyplus.com
      sudo ${pkgs.systemd}/bin/systemctl stop wg-quick-wg0
    '')
  ];
}