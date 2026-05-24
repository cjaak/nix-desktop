{ DE, ... }:
{
  imports = [
    ./apps
    ./core
    ./hardware
    ./virt
    ./${DE}
  ];
}