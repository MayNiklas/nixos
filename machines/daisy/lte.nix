{ config, pkgs, ... }:
let
  xmm7360-pci = config.boot.kernelPackages.callPackage ./xmm7360-pci.nix { };
in
{
  boot = {
    extraModulePackages = [ xmm7360-pci ];
  };
}
