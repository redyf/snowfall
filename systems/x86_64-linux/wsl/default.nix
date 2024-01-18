{ inputs
, lib
, pkgs
, config
, modulesPath
, ...
}: with lib;
with lib.custom;
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  suites = {
    wsl = enabled;
  };

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "red";
    startMenuLaunchers = true;
    nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  # Change systemd stop job timeout in NixOS configuration (Default = 90s)
  systemd = {
    services.NetworkManager-wait-online.enable = false;
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };

  system.stateVersion = "22.05";
}

