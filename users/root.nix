{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles =
      [ (builtins.fetchurl { url = "https://github.com/mayniklas.keys"; }) ];
  };
}
