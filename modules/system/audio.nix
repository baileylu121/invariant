{
  flake.modules.nixos.audio = {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      extraConfig."pipewire-pulse"."50-disable-family-mic.conf" = {
        "pulse.rules" = [
          {
            matches = [
              {
                "media.class" = "Audio/Source";
                "node.description" = "Family 17h/19h/1ah HD Audio Controller Analog Stereo";
              }
            ];
            actions = {
              update-props = {
                "node.disabled" = true;
              };
            };
          }
        ];
      };
    };
  };
}
