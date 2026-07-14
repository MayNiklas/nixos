{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.user.nik;
in
{

  options.mayniklas.user.nik = { enable = mkEnableOption "activate user nik"; };

  config = mkIf cfg.enable {
    users.users.nik = {
      isNormalUser = true;
      home = "/home/nik";
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [
        (pkgs.fetchurl {
          url = "https://github.com/mayniklas.keys";
          hash = "sha256-xxBytuV1e0Vv5AOVLMVh4zPe3JRYNvRrF/LHykfk064=";
        })
      ];
    };
    nix.settings = { allowed-users = [ "nik" ]; trusted-users = [ "nik" ]; };
  };
}
