let assignWorkspaces = import "./assignWorkspaces.nix";
in { config, lib, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    alacritty
    git
    nixfmt-classic
    xfce.thunar
    unzip
    google-chrome
    ncdu
    remmina
    freerdp3
    dig
    grim
    slurp
    wl-clipboard
    btop
    fd
  ];

  fonts.fontconfig.enable = true;
  programs.bash.enable = true;

  programs.git = {
    enable = true;
    userName = "Janusz Czornik";
    userEmail = "jczornik@graylight-imaging.com";
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 120;
          on-timeout = "hyprlock";
        }
        {
          timeout = 180;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = { hide_cursor = true; };

      background = {
        monitor = "";
        color = "rgba(45, 45, 45, 1.0)";
      };

      label = {
        monitor = "";
        text = "Talk is cheap. Show me the code.";
        text_align =
          "center"; # center/right or any value for default left. multi-line text alignment inside label container
        color = "rgba(200, 200, 200, 1.0)";
        font_size = 25;
        rotate = 0;

        position = "0, 80";
        halign = "center";
        valign = "center";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ inputs.hy3.packages.x86_64-linux.hy3 ];
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd.enable = true;
    xwayland.enable = true;
  };

  # xdg = {
  #   portal = {
  #     enable = true;
  #     xdgOpenUsePortal = true;
  #     config = {
  #       common.default = ["hyprland"];
  #       hyprland.default = ["hyprland"];
  #     };
  #     extraPortals = [
  #       # pkgs.xdg-desktop-portal-gtk
  #       inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
  #     ];
  #   };
  # };

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    general = { layout = "hy3"; };
    bind = [
      "$mod, B, exec, google-chrome-stable"
      "$mod, E, exec, emacsclient -c"
      "$mod, return, exec, alacritty"
      "$mod SHIFT, Q, killactive,"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      "$mod, F, fullscreen, 1"
      "$mod SHIFT, F, fullscreen, 0"
      "$mod, o, exec, hyprlock"
      ''$mod SHIFT, P, exec, grim -g "$(slurp -d)" - | wl-copy''

      # Monitor
      ''
        $mod SHIFT, m, exec, hyprctl keyword monitor "eDP-1,disable" && hyprctl keyword monitor "HDMI-A-1,2560x1440@144.00Hz,0x0,1"''

      "$mod SHIFT, n, exec, hyprctl keyword monitor eDP-1,1920x1080,2560x0,1 && hyprctl keyword monitor DP-5,2560x1440@144.00Hz,0x0,1"

      "$mod, m, exec, hyprctl keyword monitor HDMI-A-1,disable && hyprctl keyword monitor eDP-1,1920x1080,0x0,1"

      "$mod, n, exec, hyprctl keyword monitor eDP-1,1920x1080,0x0,1 && hyprctl keyword monitor DP-5,disable"

      "$mod, t, exec, assignWorkspaces"

      # Select window
      "$mod, h, hy3:movefocus, l"
      "$mod, j, hy3:movefocus, d"
      "$mod, k, hy3:movefocus, u"
      "$mod, l, hy3:movefocus, r"

      # Move window
      "$mod SHIFT, h, hy3:movewindow, l"
      "$mod SHIFT, j, hy3:movewindow, d"
      "$mod SHIFT, k, hy3:movewindow, u"
      "$mod SHIFT, l, hy3:movewindow, r"

      "$mod, r, hy3:makegroup, h, ephemeral"
      "$mod, v, hy3:makegroup, v, ephemeral"
      "$mod, t, hy3:makegroup, tab, ephemeral"

      "$mod SHIFT, r, hy3:changegroup, h, ephemeral"
      "$mod SHIFT, v, hy3:changegroup, v, ephemeral"
      "$mod SHIFT, t, hy3:changegroup, tab, ephemeral"

      "$mod, d, exec, rofi -show combi"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (x:
        let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]) 10));

    bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow 2" ];

    monitor = "eDP-1, 1920x1080, 0x0, 1";
    windowrule = [
      "float,title:^(Picture in picture)$"
      "pin,title:^(Picture in picture)$"
      "size 300 200,title:^(Picture in picture)$"
      "move 100%-w-20,title:^(Picture in picture)$"
    ];
    # windowrulev2 = "forceinput, class:(Rofi)$";

    env = [
      "HYPRCURSOR_THEME,Bibata-Original-Classic"
      "HYPRCURSOR_SIZE,20"
      "XCURSOR_THEME,Bibata-Original-Classic"
      "XCURSOR_SIZE,20"
    ];

    exec-once = [
      "waybar"
      "hyprctl keyword input:kb_layout pl"
      "hyprctl setcursor Bibata-Original-Classic 20"
    ];
  };

  home.pointerCursor = {
    # gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
    size = 20;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "center";
    theme = "gruvbox-dark-hard";
  };

  programs.emacs = {
    enable = true;
  };
  home.file.".emacs.d/init.el".source = ./init.el;

  services.emacs = {
    enable = true;
    startWithUserSession = true;
  };

  programs.waybar = {
    enable = true;
    style = ''
      ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}
      * {
        font-family: "Roboto", "Font Awesome 6 Free", sans-serif;
        font-size: 13px;
      }

      #workspaces button.active {
         background-color: #64727D;
         box-shadow: inset 0 -3px #ffffff;
      }
    '';
    settings = [{
      height = 30;
      layer = "top";
      position = "top";
      tray = { spacing = 10; };
      modules-center = [ "hyprland/window" ];
      modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
      modules-right =
        [ "pulseaudio" "battery" "network" "cpu" "memory" "clock" ];
      battery = {
        format = "{capacity}% {icon}";
        format-alt = "{time} {icon}";
        format-charging = "{capacity}% ";
        format-icons = [ "" "" "" "" "" ];
        format-plugged = "{capacity}% ";
        states = {
          critical = 15;
          warning = 30;
        };
      };
      clock = {
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };
      memory = { format = "{}% "; };
      network = {
        interval = 1;
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        format-disconnected = "Disconnected ⚠";
        format-ethernet =
          "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
        format-linked = "{ifname} (No IP) ";
        format-wifi = "{essid} ({signalStrength}%) ";
      };
      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-icons = {
          car = "";
          default = [ "" "" "" ];
          handsfree = "";
          headphones = "";
          headset = "";
          phone = "";
          portable = "";
        };
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        on-click = "pavucontrol";
      };
      "hyprland/mode" = { format = ''<span style="italic">{}</span>''; };
      "hyprland/workspaces" = {
        all-outputs = true;
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = [ ];
          "10" = [ ];
        };
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "9" = "";
          "10" = "";
        };
      };
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [ "" "" "" ];
      };
    }];
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
