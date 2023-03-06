{ stdenv
, writeShellScriptBin

, tmux
, nixos-rebuild
, ...
}:
let

  # build system script
  build-system-in-tmux-skript = writeShellScriptBin "build-system-in-tmux" ''
    ${nixos-rebuild}/bin/nixos-rebuild build --flake 'github:mayniklas/nixos'
  '';

  # execute build system script in tmux session
  build-system-skript = writeShellScriptBin "build-system" ''
    # make sure tmux session 'build-system' is running
    ${tmux}/bin/tmux has-session -t build-system || ${tmux}/bin/tmux new-session -d -s build-system

    # run nixos-rebuild build in tmux session 'build-system'
    ${tmux}/bin/tmux send-keys -t build-system "${build-system-in-tmux-skript}/bin/build-system-in-tmux" C-m
  '';

in
stdenv.mkDerivation
{

  pname = "build-system";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${build-system-skript} $out
  '';
}
