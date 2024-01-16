{ options
, config
, lib
, ...
}:
with lib;
with lib.custom; let
  cfg = config.system.boot;
in
{
  options.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
    device = mkOpt str "nodev" "Disk that grub will be installed to.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [ "v4l2loopback" ]; # Autostart kernel modules on boot
      extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ]; # loopback module to make OBS virtual camera work
      kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
      supportedFilesystems = [ "ntfs" ];
      loader = {
        systemd-boot.enable = true;
        timeout = 20;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
          configurationLimit = 5;
          theme =
            pkgs.fetchFromGitHub
              {
                owner = "Lxtharia";
                repo = "minegrub-theme";
                rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
                sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
              };
        };
      };
    };
  };
}