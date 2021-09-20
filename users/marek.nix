{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marek = {
    isNormalUser = true;
    home = "/home/marek";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      (pkgs.fetchurl {
        url = "https://github.com/User12323.keys";
        sha256 = "1mpra26kk2f9f3xwnqhmgb627wngsz9i0d95niyfriikxw6g5wwj";
      })
    ];
  };

  nix.allowedUsers = [ "marek" ];
}
