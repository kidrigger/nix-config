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

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # packageOverrides = pkgs: {
      #   nur = import (builtins.fetchTarball {
      #     url = "https://github.com/nix-community/NUR/archive/master.tar.gz"; 
      #     sha256 = "0plki2yk02zcvyw7vynqhag6g1kl5qcicj8dvzfjx5p3p82yilkk"; }) {
      #     inherit pkgs;
      #   };
      # };
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      max-jobs = 1;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

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

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = { "vm.swappiness" = 0; };

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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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

  programs.zsh.enable = true;
  
  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    equiomax = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "Nix";
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };


  home-manager = {
    extraSpecialArgs = {inherit inputs outputs; };
    users = {
      equiomax = import ../home-manager/home.nix;
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.networkmanager.enable = true;

  services = {
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };
    
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

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
    # extraPortals = with pkgs; [
      # xdg-desktop-portal-kde
    # ];
  };

  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.virt-manager.enable = true;
  programs.kdeconnect.enable = true;
  programs.yazi.enable = true;

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };


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
     # nur.repos.nltch.spotify-adblock    #for installing spotify-adblock
    spotify-adblock
    jellyfin
    jellyfin-web
    filelight
    wineWowPackages.staging
    winetricks
    (lutris.override {
      extraLibraries = pkgs: [
        
      ];
      extraPkgs = pkgs: [
        
      ];
    })
    croc
    calibre
    dwarfs
    fuse-overlayfs
    unar
    proton-ge-custom
  ];

  environment.etc = {
  "pipewire/pipewire.conf.d/20-pulse-properties.conf".text = ''
    pulse.properties = {
      pulse.min.req = 256/48000
      pulse.min.frag = 256/48000
      pulse.min.quantum = 256/48000
    }
  '';
};

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
