{ DE ? null, lib, ... }:
let
  deList = if DE == null then []
           else if builtins.isList DE then DE
           else [ DE ];
in {
  imports = [
    ./core
  ] ++ lib.optionals (deList != []) [
    ./apps
    ./hardware
    ./virt
  ] ++ map (de: ./. + "/${de}") deList;
}