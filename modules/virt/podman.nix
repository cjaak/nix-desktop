{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
    ddev
    mkcert
  ];

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
  services.dnsmasq = {
    enable = true;
    settings = {
      address = [ "/ddev.site/127.0.0.1" ];
      except-interface = [ "virbr0" ];
      bind-interfaces = true;
    };
  };

  virtualisation.podman = {
    enable = true;

    defaultNetwork.settings.dns_enabled = true;
  };
}