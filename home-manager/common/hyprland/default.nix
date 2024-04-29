{pkgs, ...}: {

  home.packages = with pkgs; [
    material-design-icons
    hyprlock
  ];

  programs = {
    wofi.enable = true;
    waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          modules-left = [
            "hyprland/workspaces"
            "hyprland/mode"
#            "wlr/taskbar"
          ];
          modules-center = [
            "hyprland/window"
          ];
          modules-right = [
            # "mpd"
            # "idle_inhibitor"
            # "pulseaudio"
            # "network"
            # "power-profiles-daemon"
            "cpu"
            "memory"
            "temperature"
            # "backlight"
            # "keyboard-state"
            "hyprland/language"
            "battery"
            "clock"
            # "tray"
          ];
        };
        "wlr/taskbar" = {
          format = "{icon}";
        };
      };
      style = builtins.readFile ./dpgrahams-style.css;
    };
  };
  
  wayland.windowManager.hyprland.settings = {
    "$mod" = "ALT";
    "$wham" = "CTRL + ALT + SUPER";
    monitor=",preferred,auto,1";
    general = {
      gaps_in = 15;
      gaps_out = 20;
    };
    decoration = {
      rounding = 6;
    };
    bind =
    [
      "$mod, L, exec, hyprlock"
      "$wham, Q, exec, systemctl poweroff"
      "$wham, L, exec, hyprctl dispatch exit"
      "$mod, R, exec, wofi --show drun"
      "$mod, T, exec, alacritty"
    ]
    ++ (
      builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x +1)}"
        ]
      )
      10)
    );
  };
}
