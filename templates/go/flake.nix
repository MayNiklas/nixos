{
  description = "A go package";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {

      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          go-project = pkgs.buildGoModule rec {
            pname = "go-project";
            version = "1.0.0";
            src = self;
            vendorSha256 = "sha256-53FtzSkFe41L7hD3vAN09tyODaQNPAFwrtpYcHbNLqI=";
            doCheck = false;
            meta = with pkgs.lib; {
              description = "go-project";
              homepage = "https://github.com/MayNiklas/go-project";
              platforms = platforms.unix;
              maintainers = with maintainers; [ mayniklas ];
            };
          };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.go-project);

    };
}
