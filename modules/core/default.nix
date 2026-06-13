{ DE ? null, lib, ... }: {
  imports = [
    ./nix
    ./terminal
  ] ++ lib.optionals (DE != null) [
    ./boot/systemd
     ];
}
