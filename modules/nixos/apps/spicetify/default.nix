{
  options,
  config,
  lib,
  pkgs,
  spicetify-nix,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  options.apps.spicetify-nix = with types; {
    enable = mkBoolOpt false "Enable spicetify-nix";
  };

  config = mkIf cfg.enable {
    # allow spotify to be installed if you don't have unfree enabled already
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "spotify"
      ];

    # import the flake's module for your system
    imports = [spicetify-nix.homeManagerModule];

    # configure spicetify :)
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      # enabledExtensions = with spicePkgs.extensions; [
      #   fullAppDisplay
      #   shuffle # shuffle+ (special characters are sanitized out of ext names)
      #   hidePodcasts
      # ];
    };
  };
}
