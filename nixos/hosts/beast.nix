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

  # TODO Bus ID
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   powerManagement.finegrained = true;
  #   forceFullCompositionPipeline = true;
  #   open = false;
  #   nvidiaSettings = true;
  #   nvidiaPersistenced = true;
  #   prime = {
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true;
  #     };
  #     nvidiaBusId = # TODO "PCI:1:0:0";
  #   };
  # };

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

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    fuse-overlayfs
  ];

  environment.variables.EDITOR = "hx";

  system.stateVersion = "23.11"; # Did you read the comment?

}

