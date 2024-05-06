# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.home-manager
    ../common
    ./hardware-beast.nix
  ];

  networking = {
    hostName = "beast";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 8080];
      allowedUDPPorts = [8080];
    };
  };

  users.users.eon = {
    # TODO(Bob): if I ever decide on SSH for beast.
    openssh.authorizedKeys.keys = [];
    extraGroups = ["wheel" "networkmanager"];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    forceFullCompositionPipeline = true;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };
  
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
    };
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  networking.networkmanager.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
  };

  services = {
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      videoDrivers = [ "nvidia" ];
    };
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode"];})
    ];
    fontconfig = {
      defaultFonts = {
        monospace = ["FiraCode"];
      };
    };
  };
  
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      eon = import ../../home-manager/users/eon.nix;
    };
  };

  programs = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    fuse-overlayfs
    hyprpaper
  ];

  programs = {
    # dconf.enable = true;
    # kdeconnect.enable = true;
    firefox = {
      enable = true;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}

