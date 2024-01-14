# Build this VM with nix build  ./#nixosConfigurations.vm.config.system.build.vm
# Then run is with: ./result/bin/run-nixos-vm
# To be able to connect with ssh enable port forwarding with:
# QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-nixos-vm
# Then connect with ssh -p 2222 guest@localhost
{ lib, config, pkgs, ... }:
{
  # Internationalisation options
  i18n.defaultLocale = "pt_BR.UTF-8";
  console.keyMap = "br-abnt2";

  # Options for the screen
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      resolution = {
        x = 1280;
        y = 1024;
      };
    };
  };

  programs.zsh.enable = true;

  # A default user able to use sudo
  users = {
    users.guest = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "guest";
      group = "guest";
    };
  };
  users.groups.guest = { };

  security.sudo.wheelNeedsPassword = false;

  # X configuration
  services = {
    xserver = {
      enable = true;
      layout = "br";
      videoDrivers = [ "qxl" ];
      displayManager = {
        autoLogin.user = "guest";
      };
      desktopManager = {
        xfce = {
          enable = true;
          enableScreensaver = false;
        };
      };
    };
    # For copy/paste to work
    spice-vdagentd.enable = true;
    # Enable ssh
    sshd.enable = true;
  };


  # Included packages here
  environment.systemPackages = with pkgs; [
    firefox
    neovim
    wget
  ];

  system.stateVersion = "22.11";
}
