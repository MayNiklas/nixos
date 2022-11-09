{ pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #   environment.systemPackages =
  #     [ pkgs.vim
  #     ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
}
