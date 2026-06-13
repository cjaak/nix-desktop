{ vars, config, ... }:
let
  svcRoot = vars.serviceConfigRoot;
in {
  systemd.tmpfiles.rules = (map (x: "d ${x} 0777 share share - -") [
    "${svcRoot}/invidious"
    "${svcRoot}/invidious/db"
    "${svcRoot}/nitter"
  ]) ++ [
    "f ${svcRoot}/nitter/sessions.jsonl 0666 share share - -"
  ];

  # nitter.conf managed declaratively; redis connects via shared network namespace
  environment.etc."nitter/nitter.conf".text = ''
    [Server]
    address = "0.0.0.0"
    port = 8080
    https = false
    httpMaxConnections = 100
    staticDir = "./public"
    title = "nitter"
    hostname = "nitter.${vars.domainName}"

    [Cache]
    listMinutes = 240
    rssMinutes = 10
    redisHost = "localhost"
    redisPort = 6379
    redisPassword = ""
    redisConnections = 100
    redisMaxConnections = 1000

    [Config]
    hmacKey = "changeme"
    base64Media = false
    enableRSS = true
    enableDebug = false
    proxy = ""
    proxyAuth = ""
    tokenCount = 10

    [Preferences]
    theme = "Nitter"
    replaceTwitter = ""
    replaceYouTube = ""
    replaceReddit = ""
    proxyVideos = true
    hlsPlayback = false
    infiniteScroll = false
  '';

  systemd.services = {
    podman-invidious = {
      requires = [ "podman-invidious-db.service" ];
      after    = [ "podman-invidious-db.service" ];
    };
    podman-invidious-companion = {
      requires = [ "podman-invidious-db.service" ];
      after    = [ "podman-invidious-db.service" ];
    };
    podman-nitter = {
      requires = [ "podman-nitter-redis.service" ];
      after    = [ "podman-nitter-redis.service" ];
    };
  };

  virtualisation.oci-containers.containers = {

    # ── Redlib (Reddit) ──────────────────────────────────────────────────────
    redlib = {
      image = "quay.io/redlib/redlib:latest";
      autoStart = true;
      extraOptions = [
        "--pull=newer"
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.redlib.rule=Host(`redlib.${vars.domainName}`)"
        "-l=traefik.http.services.redlib.loadbalancer.server.port=8080"
        "-l=homepage.group=Redirects"
        "-l=homepage.name=Redlib"
        "-l=homepage.icon=reddit.svg"
        "-l=homepage.href=https://redlib.${vars.domainName}"
        "-l=homepage.description=Reddit frontend"
      ];
    };

    # ── Invidious (YouTube) ───────────────────────────────────────────────────
    # invidious-db owns the network namespace; invidious and companion join it.
    # Traefik labels live here since invidious-db owns the namespace.
    invidious-db = {
      image = "postgres:16-alpine";
      autoStart = true;
      volumes = [ "${svcRoot}/invidious/db:/var/lib/postgresql/data" ];
      environment = {
        POSTGRES_DB       = "invidious";
        POSTGRES_USER     = "invidious";
        POSTGRES_PASSWORD = "invidious";
      };
      extraOptions = [
        "--pull=newer"
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.invidious.rule=Host(`invidious.${vars.domainName}`)"
        "-l=traefik.http.routers.invidious.service=invidious"
        "-l=traefik.http.services.invidious.loadbalancer.server.port=3000"
        "-l=homepage.group=Redirects"
        "-l=homepage.name=Invidious"
        "-l=homepage.icon=invidious.svg"
        "-l=homepage.href=https://invidious.${vars.domainName}"
        "-l=homepage.description=YouTube frontend"
      ];
    };

    invidious = {
      image = "quay.io/invidious/invidious:latest";
      autoStart = true;
      volumes = [ "${config.age.secrets.invidiousConfig.path}:/invidious/config/config.yml:ro" ];
      extraOptions = [
        "--pull=newer"
        "--network=container:invidious-db"
      ];
    };

    invidious-companion = {
      image = "quay.io/invidious/invidious-companion:latest";
      autoStart = true;
      environmentFiles = [ config.age.secrets.invidiousCompanionKey.path ];
      extraOptions = [
        "--pull=newer"
        "--network=container:invidious-db"
      ];
    };

    # ── Nitter (Twitter/X) ────────────────────────────────────────────────────
    # nitter-redis owns the namespace; nitter joins it.
    # nitter.conf is managed via environment.etc above.
    nitter-redis = {
      image = "redis:alpine";
      autoStart = true;
      extraOptions = [
        "--pull=newer"
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.nitter.rule=Host(`nitter.${vars.domainName}`)"
        "-l=traefik.http.services.nitter.loadbalancer.server.port=8080"
        "-l=homepage.group=Redirects"
        "-l=homepage.name=Nitter"
        "-l=homepage.icon=twitter.svg"
        "-l=homepage.href=https://nitter.${vars.domainName}"
        "-l=homepage.description=Twitter frontend"
      ];
    };

    nitter = {
      image = "zedeus/nitter:latest";
      autoStart = true;
      volumes = [
        "/etc/nitter/nitter.conf:/src/nitter.conf:ro"
        "${svcRoot}/nitter/sessions.jsonl:/src/sessions.jsonl"
      ];
      extraOptions = [
        "--pull=newer"
        "--network=container:nitter-redis"
      ];
    };

  };
}