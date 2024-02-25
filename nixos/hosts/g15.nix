# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.home-manager.nixosModules.home-manager

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../common

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-g15.nix
  ];

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking = {
    hostName = "equiomax-g15";
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 8096 8080];
      allowedUDPPorts = [8080 51820];
    };
  };

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    forceFullCompositionPipeline = true;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
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
      equiomax = import ../../home-manager/users/equiomax.nix;
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.

  services = {
    xserver.videoDrivers = ["nvidia"];

    asusd = {
      enable = true;
      enableUserService = true;
    };

    supergfxd.enable = true;

    caddy = {
      enable = true;
      virtualHosts."jellyfin.eqmx.in".extraConfig = ''
        reverse_proxy 127.0.0.1:8096
      '';
      virtualHosts."calibre.eqmx.in".extraConfig = ''
        reverse_proxy 127.0.0.1:8080
      '';
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  # chaotic.hdr.enable = true;

  environment.systemPackages = with pkgs; [
    spotify-adblock
    jellyfin
    jellyfin-web
    filelight
    thunderbird
    wineWowPackages.staging
    winetricks
    (lutris.override {
      extraLibraries = pkgs: [
      ];
      extraPkgs = pkgs: [
      ];
    })
    (retroarch.override {
      cores = with libretro; [
      mgba
      ];
    })
    croc
    calibre
    dwarfs
    fuse-overlayfs
    unar
    proton-ge-custom
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
