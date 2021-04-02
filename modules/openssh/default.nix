{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.openssh;
in {

  options.mayniklas.openssh = {
    enable = mkEnableOption "activate openssh" // { default = true; };
  };

  config = mkIf cfg.enable {

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      startWhenNeeded = true;
      challengeResponseAuthentication = false;

    };

  };
}