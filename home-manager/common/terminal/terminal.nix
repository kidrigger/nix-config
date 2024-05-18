{ pkgs, ... }: {
  home.packages = with pkgs; [
    ## terminal apps
    du-dust
    eza
    ripgrep
    bottom
    # bacon
    broot
    # mprocs
    # gitui
    tokei
    ouch
    # gitoxide
    tree
    neofetch

    #nix
    nil
  ];

  programs = {
    bat = {
      enable = true;
      config = { theme = "TwoDark"; };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zellij = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        theme = "catppuccin-mocha";
        default_shell = "nu";
        default_layout = "compact";
        pane_frames = false;
        ui = { pane_frames = { rounded_corners = true; }; };
      };
    };

    carapace = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = "base16_transparent";
        editor = {
          cursorline = true;
          bufferline = "multiple";
          indent-guides.render = true;
          completion-replace = true;
          color-modes = true;
          file-picker = { hidden = false; };
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
        window = { opacity = 0.9; };
        shell = {
          program = "zsh";
          args = [ "-l" "-c" "zellij" ];
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
        colors = {
          bright = {
            black = "#585b70";
            blue = "#89b4fa";
            cyan = "#94e2d5";
            green = "#a6e3a1";
            magenta = "#f5c2e7";
            red = "#f38ba8";
            white = "#a6adc8";
            yellow = "#f9e2af";
          };
          cursor = {
            cursor = "#f5e0dc";
            text = "#1e1e2e";
          };
          dim = {
            black = "#45475a";
            blue = "#89b4fa";
            cyan = "#94e2d5";
            green = "#a6e3a1";
            magenta = "#f5c2e7";
            red = "#f38ba8";
            white = "#bac2de";
            yellow = "#f9e2af";
          };
          footer_bar = {
            background = "#a6adc8";
            foreground = "#1e1e2e";
          };
          hints = {
            end = {
              background = "#a6adc8";
              foreground = "#1e1e2e";
            };
            start = {
              background = "#f9e2af";
              foreground = "#1e1e2e";
            };
          };
          indexed_colors = [
            {
              color = "#fab387";
              index = 16;
            }
            {
              color = "#f5e0dc";
              index = 17;
            }
          ];
          normal = {
            black = "#45475a";
            blue = "#89b4fa";
            cyan = "#94e2d5";
            green = "#a6e3a1";
            magenta = "#f5c2e7";
            red = "#f38ba8";
            white = "#bac2de";
            yellow = "#f9e2af";
          };
          primary = {
            background = "#1e1e2e";
            bright_foreground = "#cdd6f4";
            dim_foreground = "#7f849c";
            foreground = "#cdd6f4";
          };
          search = {
            focused_match = {
              background = "#a6e3a1";
              foreground = "#1e1e2e";
            };
            matches = {
              background = "#a6adc8";
              foreground = "#1e1e2e";
            };
          };
          selection = {
            background = "#f5e0dc";
            text = "#1e1e2e";
          };
          vi_mode_cursor = {
            cursor = "#b4befe";
            text = "#1e1e2e";
          };
        };

      };
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
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
    nushell = {
      enable = true;
      configFile.source = ./nushell.nu;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = pkgs.lib.importTOML ./starship.toml;
    };
  };
}
