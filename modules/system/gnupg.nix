{
  flake.modules.nixos.gnupg = { pkgs, ... }: {
    services.pcscd.enable = true;
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-emacs;
      enableSSHSupport = true;
    };
  };
}
