{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.virtualization.kvm;
in {
  options.virtualization.kvm = with types; {
    enable = mkBoolOpt false "Enable virtualization";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      virt-manager
    ];
    virtualisation = {
      # Enables docker in rootless mode
      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
      libvirtd.enable = true;
    };
  };
}
