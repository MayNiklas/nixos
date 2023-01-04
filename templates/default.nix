{
  # nix flake init --template 'github:MayNiklas/nixos'#go
  go = {
    description = "GoLang project";
    path = ./go;
  };
}
