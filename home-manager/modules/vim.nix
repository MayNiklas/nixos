{ config, pkgs, lib, ... }: {

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      ansible-vim
      i3config-vim
      vim-better-whitespace
      vim-nix
    ];

  };

}
