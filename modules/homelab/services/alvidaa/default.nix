{ vars, ... }:
let
  dataDir = "${vars.serviceConfigRoot}/alvidaa";
in
{
  systemd.tmpfiles.rules = [
    "d ${dataDir}/server 0775 share share - -"
    "d ${dataDir}/server/keys 0770 share share - -"
    "d ${dataDir}/server/deps 0775 share share - -"
  ];

  virtualisation.oci-containers.containers.alvidaa = {
    image = "python:3-slim";
    autoStart = true;
    # Install paho-mqtt into a persistent volume dir on first run only
    cmd = [
      "sh" "-c"
      "test -d /app/deps/paho || pip install --target /app/deps paho-mqtt -q; PYTHONPATH=/app/deps python /app/vidaa_server.py 192.168.178.85 8765"
    ];
    volumes = [
      "${dataDir}/server:/app"
    ];
    extraOptions = [
      "-l=traefik.enable=true"
      "-l=traefik.http.routers.alvidaa.rule=Host(`alvidaa.${vars.domainName}`)"
      "-l=traefik.http.services.alvidaa.loadbalancer.server.port=8765"
    ];
  };
}