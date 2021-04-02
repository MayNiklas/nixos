{ config, pkgs, lib, ... }: {

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [ zsh ];

  # Needed for yubikey to work
  environment.shellInit = ''
    export ZDOTDIR=$HOME/.config/zsh
  '';

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

  # Needed for zsh completion of system packages, e.g. systemd
  environment.pathsToLink = [ "/share/zsh" ];
}
