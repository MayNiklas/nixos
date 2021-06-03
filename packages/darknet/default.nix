{ lib, stdenv, pkgs, ... }:
stdenv.mkDerivation rec {
  pname = "darknet";
  version = "a3714d0a2bf92c3dea84c4bea65b2b0c64dbc6b1";

  src = fetchGit {
    url = "https://github.com/pjreddie/darknet";
    rev = version;
  };

  buildInputs = with pkgs; [
    autoconf
    cudatoolkit
    linuxPackages.nvidia_x11
    gcc
    pkg-config
    (opencv3.override (old: { enableGtk2 = true; }))
    gtk2-x11
  ];

  makeFlags = [ "GPU=1" "OPENCV=1" ];

  shellHook = ''
    export CUDA_PATH=${pkgs.cudatoolkit}
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';

  installPhase = ''
    install -Dm755 darknet -t $out/bin
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Convolutional Neural Networks";
    longDescription = ''
      Darknet is an open source neural network framework written in C and CUDA.
      It is fast, easy to install, and supports CPU and GPU computation.
    '';

    homepage = "https://pjreddie.com/darknet/";
    changelog = "https://github.com/pjreddie/darknet/commits/master";
    license = licenses.mit;
    maintainers = [ maintainers.MayNiklas ];
    platforms = platforms.all;
  };
}
