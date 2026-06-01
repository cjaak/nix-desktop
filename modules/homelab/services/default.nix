{ ... }: {
  imports = [
    # Services and applications
     ./paperless-ngx
     ./traefik
     ./timetagger
     ./immich
     ./grafana
     ./qbittorrent
     ./arr
     ./jellyfin
     ./vaultwarden
     ./monitoring
     ./pingvin-share
     ./homepage
     ./nextcloud
     ./filebrowser
     ./rreading-glasses
  ];
}