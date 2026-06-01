{ DE ? null, lib, ... }:
{
  imports = [
    ./core
  ] ++ lib.optionals (DE != null) [
    ./apps
    ./hardware
    ./virt
    ./${DE}
  ];
}