{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nik = {
    isNormalUser = true;
    home = "/home/nik";
    extraGroups = [ "docker" "wheel" "audio" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keyFiles =
      [ (builtins.fetchurl { url = "https://github.com/mayniklas.keys"; }) ];
  };

  nix.allowedUsers = [ "nik" ];
}
