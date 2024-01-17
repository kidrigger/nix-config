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
    # ./nvim.nix
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
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-run"
        "steam-original"
        "discord-canary"
      ];

      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };

  # TODO: Set your username
  home = {
    username = "equiomax";
    homeDirectory = "/home/equiomax";
    packages = with pkgs; [
      # terminal apps
      du-dust
      zellij
      yt-dlp
      ripgrep
      bottom
      macchina
      delta
      
      # productivity
      logseq
      discord-canary
      docker-compose
      qbittorrent
      bitwarden
      foliate

      # gaming
      mangohud
      prismlauncher
      superTuxKart

      # nix
      nil
            
      # langs
      rust-analyzer
      libclang
    ];
  };

  home.sessionVariables.EDITOR = "hx";
  # Add stuff for your user as you see fit:

  programs = {
    bat.enable = true;
    zoxide.enable = true;
    zellij = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  
    helix = {
      enable = true;
      settings = {
        theme = "onedark";
        editor = {
          cursorline = true;
          bufferline = "multiple";
          indent-guides.render = true;
        };
      };
    };

    vscode.enable = true;

    alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.9;
        };
        font = {
          size = 9;
        };
      };
    };


    zsh = {
      enable = true;
      enableAutosuggestions = true;
      # syntaxHighlighting.enable = true;
      plugins = [{
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
        };
      }];
    };

    bash.enable = true;

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = pkgs.lib.importTOML ./starship.toml;
    };

    mpv.enable = true;

    # Enable home-manager and git
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Amit Chauhan";
      userEmail = "aschauhan@tutanota.com";
    };
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
