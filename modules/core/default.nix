{ DE ? null, lib, ... }: {
  imports = [
    ./nix
  ] ++ lib.optionals (DE != null) [
    ./boot/systemd
    ./terminal
  ];
}
