{
  flake.overlays.zen4 = _: _: {
    localSystem = {
      gcc.arch = "znver4";
      gcc.tune = "znver4";
      system = "x86_64-linux";
    };
  };
}
