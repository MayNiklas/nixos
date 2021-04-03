{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/mayniklas.keys";
        sha256 = "180458fg6i6sbqmyz18rb1hsq4226zdivqz86x9dwkv02fqvkygw";
      })
    ];
  };
}
