{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.printers = {
    ensurePrinters = [{
      name = "HP_Color_LaserJet_MFP_M180n";
      location = "Local Network";
      deviceUri = "dnssd://HP%20Color%20LaserJet%20MFP%20M180n%20(224614)._ipp._tcp.local/?uuid=564e4334-3134-3036-3634-b00cd1224614";
      model = "everywhere";
      ppdOptions.PageSize = "A4";
    }];
    ensureDefaultPrinter = "HP_Color_LaserJet_MFP_M180n";
  };
}