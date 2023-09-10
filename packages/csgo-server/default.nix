{ stdenv
, writeShellScriptBin
, steamPackages
, steam-run
, ...
}:
let
  csgo-server-skript = writeShellScriptBin "csgo-server" ''
    echo "Downloading and installing SteamCMD"
    ${steamPackages.steamcmd}/bin/steamcmd --help

    echo "Downloading and installing CS:GO Server"
    ${steamPackages.steamcmd}/bin/steamcmd +login anonymous +app_update 740 +quit

    # change to the csgo server directory
    cd ~/.local/share/Steam/Steamapps/common/Counter-Strike\ Global\ Offensive\ Beta\ -\ Dedicated\ Server/

    # both methods work
    ./srcds_run -game csgo -debug -help
    ${steam-run}/bin/steam-run ./srcds_run -game csgo -debug -help

    # both methods do not work currently
    # ./srcds_run -game csgo -console -usercon +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2 -debug
    # ${steam-run}/bin/steam-run ./srcds_run -game csgo -console -usercon +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2
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
