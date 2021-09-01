{ lib, fetchFromGitHub, buildPythonApplication, python38Packages, pkgs
, setuptools, ... }:
with python38Packages;
buildPythonApplication rec {

  pname = "verification-listener";
  version = "1.0.1";

  pythonPath = [ setuptools ];
  propagatedBuildInputs = [ discordpy ];

  src = fetchFromGitHub {
    owner = "info-Bonn";
    repo = "verification-listener";
    rev = "v${version}";
    sha256 = "sha256-TAQvum6iwsyuUivISnK5BaEMULpazl2hl8MCQJ65Xx8=";
  };

  doCheck = false;

  meta = with lib; {
    description =
      "Single-guild discord-bot to give roles to a member accepting your servers rules. Also sending a neat little welcome message to the user.";
    homepage = "https://overviewer.org/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ mayniklas ];
  };
}
