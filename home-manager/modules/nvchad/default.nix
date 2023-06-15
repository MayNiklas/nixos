# https://github.com/azuwis/nix-config/blob/master/modules/common/nvchad/home.nix

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.neovim.nvchad;
in
{
  options = {
    programs.neovim.nvchad = {
      enable = mkEnableOption "NvChad";

      lazyPlugins = mkOption {
        type = with types; listOf package;
        default = with pkgs.vimPlugins; [
          base46
          cmp-buffer
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          cmp_luasnip
          comment-nvim
          friendly-snippets
          gitsigns-nvim
          indent-blankline-nvim
          luasnip
          nvchad-extensions
          nvchad-ui
          nvim-autopairs
          nvim-cmp
          nvim-colorizer-lua
          nvim-lspconfig
          nvim-tree-lua
          nvim-treesitter
          nvim-web-devicons
          nvterm
          telescope-nvim
          which-key-nvim
        ];
        description = ''
          List of neovim plugins required by NvChad, available to lazy.nvim
          local plugins search path. Normally you don't need to change this
          option.
        '';
      };

      extraLazyPlugins = mkOption {
        type = with types; listOf package;
        default = [ ];
        example = literalExpression ''
          with pkgs.vimPlugins; [
            neogit
            null-ls-nvim
          ]
        '';
        description = ''
          List of extra neovim plugins to install, available to lazy.nvim local
          plugins search path.

          If you follow <link xlink:href="https://nvchad.com/docs/config/plugins"/>
          to setup additional plugins, you can use this option to avoid
          lazy.nvim downloading them.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."nvim/lazyPlugins".source = pkgs.vimUtils.packDir {
      lazyPlugins = {
        start = cfg.lazyPlugins ++ cfg.extraLazyPlugins;
      };
    };

    programs.neovim =
      let
        nvchad = pkgs.vimPlugins.nvchad.overrideAttrs (old: {
          patches = [
            (pkgs.fetchpatch {
              # Fix default mappings not loaded if chadrc.lua does not exist
              # https://github.com/NvChad/NvChad/pull/2037
              url = "https://github.com/NvChad/NvChad/commit/583828d1a69d385587f7d214f59c354ba7dd02a1.diff";
              sha256 = "sha256-gmVmbP1TO3+OAgXft/l3xvoEGj93t/ksmLWsAkJS6Bk=";
            })
            ./nvchad.patch
          ];
          postPatch = ''
            substituteInPlace lua/plugins/init.lua \
            --replace '"NvChad/extensions"' '"NvChad/nvchad-extensions"' \
            --replace '"NvChad/ui"' '"NvChad/nvchad-ui"' \
            --replace '"L3MON4D3/LuaSnip"' '"L3MON4D3/luasnip"' \
            --replace '"numToStr/Comment.nvim"' '"numToStr/comment.nvim"'
          '';
        });
      in
      {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          base46
          lazy-nvim
          nvchad
        ];
        extraLuaConfig = ''
          dofile("${nvchad}/init.lua")
        '';
      };
  };
}
