# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, outputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.home-manager
      ../common
      ./hardware-wyvern.nix
    ];

  networking = {
    hostName = "wyvern"; # Define your hostname.
    # networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    interfaces.ens18.ipv6.addresses = [ {
      address = "2a01:e0a:de4:a0e1:16:03:1998:CE";
      prefixLength = 64;
    } ]; 
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };

  users.users.eon = {
    description = "Eon in Wyvern";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDArEhTA0Pyhmf6Ckr+kKf1nGm6KTmO4O3HFGSbtDAHA bob@lapbob"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDDX27ntWHRxlDi2WoJt1EnMOEqHKwUBjEibO/kxPMMt eon@demon"
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      eon = import ../../home-manager/users/eon-wyvern.nix;
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}

