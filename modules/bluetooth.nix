{ config, pkgs, lib, ... }: {

  hardware.bluetooth = { enable = true; };

  services.blueman.enable = true;
}
