{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nik = {
    isNormalUser = true;
    home = "/home/nik";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "180458fg6i6sbqmyz18rb1hsq4226zdivqz86x9dwkv02fqvkygw";
      })
    ];
  };

  nix.allowedUsers = [ "nik" ];
}
