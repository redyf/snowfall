{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.desktop;
in
{
  options.suites.desktop = with types; {
    enable = mkBoolOpt false "Enable the desktop suite";
  };

  config = mkIf cfg.enable {
    desktop = {
      addons = {
        bemenu = enabled;
        swww = enabled;
        wezterm = enabled;
        waybar = enabled;
        xdg-portal = enabled;
      };
      hyprland = enabled;
      xfce = enabled;
      xmonad = enabled;
    };
    services.xserver = {
      enable = true;
      displayManager.gdm = enabled;
    };
  };
}
