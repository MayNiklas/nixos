{ config, pkgs, lib, ... }: {
  services.xserver = {
    screenSection = ''
      Option         "metamodes" "DP-2: 3440x1440_120 +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNCCompatible=On}, DP-0: 1920x1200_60 +0+240 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };
}
