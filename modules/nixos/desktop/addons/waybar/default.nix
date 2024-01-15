{ options
, config
, lib
, pkgs
, inputs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.waybar;
  # Bar v1
  # waybar_config = import ./og/config.nix {inherit osConfig config lib pkgs;};
  # waybar_style = import ./og/style.nix {inherit (config) colorscheme;};
  # NixBar
  # waybar_config = import ./nixbar/config.nix {inherit osConfig config lib pkgs;};
  # waybar_style = import ./nixbar/style.nix {inherit (config) colorscheme;};
  # Tokyonight
  # waybar_config = import ./tokyonight/config.nix {inherit osConfig config lib pkgs;};
  # waybar_style = import ./tokyonight/style.nix {inherit (config) colorscheme;};
  # Catppuccin
  waybar_config = import ./catppuccin/config.nix { inherit osConfig config lib pkgs; };
  waybar_style = import ./catppuccin/style.nix { inherit (config) colorscheme; };
in
{
  options.desktop.addons.waybar = with types; {
    enable = mkBoolOpt false "Enable or disable waybar";
  };

  config = mkIf cfg.enable {
    home.extraOptions.programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = waybar_config;
      style = waybar_style;
    };
  };
}
