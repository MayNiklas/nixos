{ config, pkgs, ... }:
{
  home.packages = with pkgs.jetbrains; [
    jdk
    clion
    idea-ultimate
    pycharm-professional
  ];
}
