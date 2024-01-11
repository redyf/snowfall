{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.boot.bios;
in {
  options.system.boot.bios = with types; {
    enable = mkBoolOpt false "Whether or not to enable bios booting.";
    device = mkOpt str "/dev/sda" "Disk that grub will be installed to.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = ["v4l2loopback"]; # Autostart kernel modules on boot
      extraModulePackages = with config.boot.kernelPackages; [v4l2loopback]; # loopback module to make OBS virtual camera work
      kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
      supportedFilesystems = ["ntfs"];
      loader = {
        systemd-boot.enable = false;
        timeout = 10;
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

          # theme = pkgs.fetchFromGitHub {
          #   owner = "shvchk";
          #   repo = "fallout-grub-theme";
          #   rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
          #   sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
          # };
        };
      };
    };
  };
}
