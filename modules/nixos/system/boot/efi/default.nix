{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.boot.efi;
in {
  options.system.boot.efi = with types; {
    enable = mkBoolOpt false "Whether or not to enable efi booting.";
  };

  config = mkIf cfg.enable {
    # Bootloader.
    boot = {
      kernelModules = ["v4l2loopback"]; # Autostart kernel modules on boot
      extraModulePackages = with config.boot.kernelPackages; [v4l2loopback]; # loopback module to make OBS virtual camera work
      kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
      supportedFilesystems = ["ntfs"];
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
        timeout = 10;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
    };
  };
}
