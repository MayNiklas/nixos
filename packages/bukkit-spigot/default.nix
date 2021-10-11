{ lib, stdenv, fetchurl, nixosTests, jre_headless }:
stdenv.mkDerivation rec {
  version = "1.17.1";
  pname = "bukkit-spigot";

  src = fetchurl {
    url = "https://download.getbukkit.org/spigot/spigot-${version}.jar";
    sha256 = "sha256-ww7eFD1/bhz629XI3saHBKDzfgZ3Aq80KQo26Bs3oVY=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/server.jar

    cat > $out/bin/bukkit-spigot << EOF
    #!/bin/sh
    exec ${jre_headless}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
    EOF

    chmod +x $out/bin/bukkit-spigot
  '';

  phases = "installPhase";

  meta = with lib; {
    description =
      "Bukkit is a free, open-source, software that provides the means to extend the popular Minecraft multiplayer server.";
    homepage = "https://getbukkit.org";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mayniklas ];
  };
}
