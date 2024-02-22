# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ../common
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-run"
          "steam-original"
          "discord-canary"
        ];

      # permittedInsecurePackages = [
      #   "electron-25.9.0"
      # ];
    };
  };

  accounts.email.accounts = {
    gmail = {
      primary = true;
      address = "aschauhan017@gmail.com";
      thunderbird.enable = true;
      realName = "Amit Chauhan";
    };

    bitsgmail = {
      primary = false;
      address = "f20180196g@alumni.bits-pilani.ac.in";
      thunderbird.enable = true;
      realName = "Amit Chauhan";
    };
  };

  # TODO: Set your username
  home = {
    username = "equiomax";
    homeDirectory = "/home/equiomax";
    packages = with pkgs; [
      # productivity
      logseq
      discord-canary
      docker-compose
      qbittorrent
      bitwarden
      foliate
      lapce

      # gaming
      mangohud
      prismlauncher
      superTuxKart

      # langs
      rust-analyzer
      libclang
    ];
  };

  home.sessionVariables.EDITOR = "hx";
  # Add stuff for your user as you see fit:

  programs = {
    mpv.enable = true;
    git = {
      userName = "Amit Chauhan";
      userEmail = "aschauhan@tutanota.com";
    };
    home-manager.enable = true;
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
