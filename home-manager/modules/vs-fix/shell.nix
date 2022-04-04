with (import <nixpkgs> { });
pkgs.mkShell {
  buildInputs = [ nodejs-16_x ];
  shellHook = ''
    cd ~/.vscode-server/bin/
    for f in *; do
      cd $f
      rm node
      ln -s $(which node)
      cd ..
    done
    cd
    exit
  '';
}
