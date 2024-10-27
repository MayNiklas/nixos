{ lib, stdenv, pkgs, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  pname = "darknet";
  version = "f6afaabcdf85f77e7aff2ec55c020c0e297c77f9";

  src = fetchFromGitHub {
    owner = "pjreddie";
    repo = pname;
    rev = version;
    sha256 = "sha256-Bhvbc06IeA4oNz93WiPmz9TXwxz7LQ6L8HPr8UEvzvE=";
  };

  buildInputs = with pkgs; [
    autoconf
    cudatoolkit
    linuxPackages.nvidia_x11
    gcc
    pkg-config
    (opencv.override { enableGtk2 = true; })
    gtk2-x11
  ];

  makeFlags = [
    "GPU=1"
    # for some reason, opencv stopped working (won't build with it)
    # "OPENCV=1"
  ];

  preConfigure = ''
    # uncomment line 14
    sed -i '14s/^# //' Makefile
  '';

  shellHook = ''
    export CUDA_PATH=${pkgs.cudatoolkit}
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';

  installPhase = ''
    install -Dm755 darknet -t $out/bin
  '';

  doCheck = true;

  meta = with lib; {
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
