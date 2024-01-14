{ options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.virtualization.kvm;
in
{
  options.virtualization.kvm = with types; {
    enable = mkBoolOpt false "Enable virtualization";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
    ];
    virtualisation = {
      vmVariant =
        {
          # following configuration is added only when building VM with build-vm
          virtualisation = {
            memorySize = 4096; # Use 2048MiB memory.
            cores = 4;
          };
        };
      # Enables docker in rootless mode
      # docker.rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
      # libvirtd.enable = true;
    };
  };
}
