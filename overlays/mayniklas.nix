inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
self: super: {
  mayniklas = {
    darknet = super.pkgs.callPackage ../packages/darknet { };
    drone-gen = super.pkgs.callPackage ../packages/drone-gen { };
    gen-module = super.pkgs.callPackage ../packages/gen-module { };
    mtu-check = super.pkgs.callPackage ../packages/mtu-check { };
    preview-update = super.pkgs.callPackage ../packages/preview-update { };
    s3uploader = super.pkgs.callPackage ../packages/s3uploader { };
    set-performance = super.pkgs.callPackage ../packages/set-performance { };
    vs-fix = super.pkgs.callPackage ../packages/vs-fix { };
  };
}
