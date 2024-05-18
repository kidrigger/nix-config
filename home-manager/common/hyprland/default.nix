{ pkgs, ... }: {

  home.packages = with pkgs; [ 
    material-design-icons
    hyprlock
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        width = 32;
        font = "FiraCode Nerd Font:weight=bold:size=8";
        prompt = "❯ ";
        fields = "name,generic,comment,categories,filename,keywords";
        line-height = 18;
        layer = "overlay";
        terminal = "${pkgs.alacritty}/bin/alacritty -e";
      };
      border = {
        width = 2;
        radius = 12;
      };
      dmenu = { exit-immediately-if-empty = true; };
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-match = "f38ba8ff";
        selection-text = "cdd6f4ff";
        border = "b4befeff";
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    style = builtins.readFile ./waybar-style.css;
    settings = {
      mainBar = {
        clock = {
          format-alt = "{:%Y-%m-%d}";
          on-click = "gnome-calendar";
        };
        cpu = {
          format = "{icon} {usage}%";
          format-alt = "{icon0}{icon1}{icon2}{icon3}";
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          interval = 10;
        };
        exclusive = true;
        gtk-layer-shell = null;
        "hyprland/window" = {
          max-length = 200;
          separate-outputs = true;
        };
        "hyprland/workspaces" = {
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          on-click = "bash /home/dg/.local/bin/toggleRemote";
        };
        layer = "top";
        margin-left = 20;
        margin-right = 20;
        margin-top = 10;
        memory = {
          format = "󰾆 {percentage}%";
          format-alt = "󰾅 {used}GB";
          interval = 30;
          max-length = 10;
          tooltip = true;
          tooltip-format = " {used:0.1f}GB/{total:0.1f}GB";
        };
        modules-center = [ "hyprland/window" ];
        modules-left = [ "clock" "hyprland/workspaces" "wlr/taskbar" ];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "temperature"
          "network"
          "pulseaudio"
          "custom/power"
        ];
        network = {
          format-disconnected = "";
          format-ethernet = " {ifname}";
          format-wifi = "󰖩 {essid} ({signalStrength}%)";
          max-length = 50;
          on-click = "alacritty -e 'nmtui'";
        };
        passthrough = false;
        position = "top";
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = [ "" "" "" ];
            hands-free = "";
            headphone = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = "{icon} 0%";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
        tray = {
          icon-size = 25;
          spacing = 10;
        };
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    "$mod" = "ALT";
    "$wham" = "CTRL + ALT";
    monitor = ",preferred,auto,1";
    general = {
      gaps_in = 10;
      gaps_out = 20;
    };
    decoration = { rounding = 6; };
    exec-once = [ "waybar" "emacs --fg-daemon" ];
    bind = [
      "$mod, L, exec, hyprlock"
      "$mod, Q, killactive,"
      "$wham, Q, exec, systemctl poweroff"
      "$wham, L, exec, hyprctl dispatch exit"
      "$mod, R, exec, fuzzel"
      ''$mod, E, exec, emacsclient -n -c -a ""''
      "$mod, T, exec, alacritty"
    ] ++ (builtins.concatLists (builtins.genList (x:
      let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
      in [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]) 10));
  };
}
