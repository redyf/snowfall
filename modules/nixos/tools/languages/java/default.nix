{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.tools.languages.java;
in
{
  options.tools.languages.java = with types; {
    enable = mkBoolOpt false "Enable java";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        jdk8 # Java dev kit
        maven # Build automation tool for java
        spring-boot-cli
      ];
    };
}
