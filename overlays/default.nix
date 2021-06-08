self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.
  darknet = super.pkgs.callPackage ../packages/darknet { };
}
