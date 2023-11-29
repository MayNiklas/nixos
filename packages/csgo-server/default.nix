{ stdenv
, writeShellScriptBin
, steamPackages
, steam-run
, ...
}:
let
  csgo-server-skript = writeShellScriptBin "csgo-server" ''
    # create a directory for the server
    export server_dir="$HOME/cs2-server"
    mkdir -p $server_dir

    echo "Downloading and installing SteamCMD"
    ${steamPackages.steamcmd}/bin/steamcmd --help

    echo "Downloading and installing CS2 server"
    ${steamPackages.steamcmd}/bin/steamcmd +login anonymous +force_install_dir $server_dir +app_update 730 +quit

    # change to the csgo server directory
    cd $server_dir/game/bin/linuxsteamrt64

    ${steam-run}/bin/steam-run ./cs2 -dedicated +map de_dust2 -debug
  '';
in
stdenv.mkDerivation {
  pname = "csgo-server";
  version = "0.1.0";
  dontUnpack = true;
  installPhase = ''
    cp -r ${csgo-server-skript} $out
  '';
}
