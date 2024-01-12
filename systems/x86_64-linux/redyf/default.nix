{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Change systemd stop job timeout in NixOS configuration (Default = 90s)
  systemd = {
    services.NetworkManager-wait-online.enable = false;
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };

  # Enable programs
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
  };

  # Allow unfree packages + use overlays
  nixpkgs = {
    overlays = [
      (
        final: prev: {
          sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
            pname = "sf-mono-liga-bin";
            version = "dev";
            src = inputs.sf-mono-liga-src;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };
          monolisa = prev.stdenvNoCC.mkDerivation rec {
            pname = "monolisa";
            version = "dev";
            src = inputs.monolisa;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.ttf $out/share/fonts/opentype/
            '';
          };
          berkeley = prev.stdenvNoCC.mkDerivation rec {
            pname = "berkeley";
            version = "dev";
            src = inputs.berkeley;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };
        }
      )
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      sf-mono-liga-bin
      monolisa
      berkeley
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Times, Noto Serif"];
        sansSerif = ["Helvetica Neue LT Std, Helvetica, Noto Sans"];
        monospace = ["Courier Prime, Courier, Noto Sans Mono"];
      };
    };
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    # no need to wait interfaces to have an IP to continue booting
    dhcpcd.wait = "background";
    # avoid checking if IP is already taken to boot a few seconds faster
    dhcpcd.extraConfig = "noarp";
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Enables docker in rootless mode
  virtualisation = {
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # Enables virtualization for virt-manager
    libvirtd.enable = true;
  };

  # Configure keymap in X11
  services = {
    # Enable CUPS to print documents.
    # printing.enable = true;
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      displayManager = {
        gdm.enable = true;
      };
      libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
        };
        touchpad = {
          accelProfile = "flat";
        };
      };
    };
    logmein-hamachi.enable = false;
    flatpak.enable = false;
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    playerctl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking = {
  #   firewall = {
  #   Or disable the firewall altogether.
  #     enable = false;
  #     allowedTCPPorts = [ ... ];
  #     allowedUDPPorts = [ ... ];
  #   };
  # };

  system.stateVersion = "22.11"; # Did you read the comment?
}
