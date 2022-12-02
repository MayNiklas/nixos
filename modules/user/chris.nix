{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.user.chris;
in
{

  options.mayniklas.user.chris = {
    enable = mkEnableOption "activate user chris";
  };

  config = mkIf cfg.enable {
    users.users.chris = {
      isNormalUser = true;
      home = "/home/chris";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [
        (pkgs.fetchurl {
          url = "https://github.com/nonchris.keys";
          sha256 =
            "sha256:0lhvhdrzp2vphqhkcgl34xzn0sill6w7mgq8xh1akm1z1rsvd9v4";
        })
      ];
    };
    nix.settings.allowed-users = [ "chris" ];
  };
}
