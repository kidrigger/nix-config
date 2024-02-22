{pkgs, ...}: {
  home.packages = with pkgs; [
    # terminal apps
    du-dust
    ripgrep
    bottom
    macchina
    bacon
    broot
    mprocs
    gitui
    tokei
    eza
    ouch
    gitoxide

    #nix
    nil
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
      };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    yazi = {
      enable = true;
      enableNushellIntegration = true;
    };

    zellij = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        theme = "one-dark";
        default_shell = "nu";
        ui = {
          pane_frames = {
            rounded_corners = true;
          };
        };
        themes = {
          one-dark = {
            fg = "#DCDFE4";
            bg = "#282C34";
            yellow = "#E5C07B";
            blue = "#61AFEF";
            red = "#E33F4C";
            magenta = "#C678DD";
            green = "#98C379";
            orange = "#D8854C";
            cyan = "#56B6C2";
            white = "#E9E1FE";
            black = "#1B1D23";
          };
        };
      };
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = "onedark";
        editor = {
          cursorline = true;
          bufferline = "multiple";
          indent-guides.render = true;
          completion-replace = true;
          color-modes = true;
          file-picker = {
            hidden = false;
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };
      };
    };

    # thunderbird.enable = true;

    alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.9;
        };
        font = {
          normal = {
            family = "FiraCode Nerd Font";
            style = "Retina";
          };
          bold = {
            family = "FiraCode Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "FiraCode Nerd Font";
            style = "Italic";
          };
          size = 9;
        };
      };
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma-continuum";
            repo = "fast-syntax-highlighting";
            rev = "v1.55";
            sha256 = "DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
          };
        }
      ];
    };

    bash.enable = true;
    nushell.enable = true;

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = pkgs.lib.importTOML ./starship.toml;
    };

    # Enable home-manager and git
    git = {
      enable = true;
      difftastic.enable = true;
    };
  };
}
