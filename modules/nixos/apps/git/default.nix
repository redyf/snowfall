{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.git;
in {
  options.apps.git = with types; {
    enable = mkBoolOpt false "Enable or disable git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Redyf";
      userEmail = "mateusalvespereira7@gmail.com";
      extraConfig = {
        init = {defaultBranch = "main";};
        core.editor = "nvim";
        pull.rebase = false;
      };
    };
  };
}
