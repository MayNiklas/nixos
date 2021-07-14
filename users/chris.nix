{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    home = "/home/chris";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/nonchris.keys";
        sha256 = "sha256:0lhvhdrzp2vphqhkcgl34xzn0sill6w7mgq8xh1akm1z1rsvd9v4";
      })
    ];
  };

  nix.allowedUsers = [ "chris" ];
}
