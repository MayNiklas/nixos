{ lib, stdenv, fetchurl, unzip, autoPatchelfHook, ... }:

stdenv.mkDerivation rec {
  pname = "owncast";
  version = "0.0.8";

  src = fetchurl {
    url =
      "https://github.com/owncast/${pname}/releases/download/v${version}/${pname}-${version}-linux-64bit.zip";
    sha256 = "sha256-5A/qYmJL12suoUq6sQrOHxmmcXlfKwsWEkTs0fb0wUk=";
  };
  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp owncast "$out"/bin/owncast
  '';

  meta = with lib; {
    description =
      "Owncast is a self-hosted live video and web chat server for use with existing popular broadcasting software.";
    homepage = "https://owncast.online/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ mayniklas ];
  };
}
