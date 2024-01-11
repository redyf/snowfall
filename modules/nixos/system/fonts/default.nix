{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.fonts;
in {
  options.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    fonts = mkOpt (listOf package) [] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    environment.systemPackages = with pkgs; [font-manager];

    fonts.packages = with pkgs;
      [
        noto-fonts
        dejavu_fonts
        font-awesome
        fira-code-symbols
        powerline-symbols
        material-design-icons
        commit-mono
        (nerdfonts.override {fonts = ["IBMPlexMono" "CascadiaCode" "FiraCode" "FiraMono" "JetBrainsMono" "Ubuntu"];})
      ]
      ++ cfg.fonts;
  };
}
