{ config, lib, pkgs, stylix, ... }:

{
  options.custom.desktop.niri.enable =
    lib.mkEnableOption "Niri Wayland Compositor";

  config = lib.mkIf config.custom.desktop.niri.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        prefer-no-csd = true;

        spawn-at-startup = [
          { command = [ "${pkgs.waybar}/bin/waybar" ]; }
          {
            command = [
              "${pkgs.swaybg}/bin/swaybg"
              "-m"
              "fill"
              "-i"
              "${config.stylix.image}"
            ];
          }
          { command = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" ]; }
        ];

        input.keyboard.xkb = { layout = "pl"; };

        binds = {
          # Programs
          "Mod+Shift+e".action.spawn = [ "emacsclient" "-c" ];
          "Mod+Shift+b".action.spawn = [
            "google-chrome-stable"
            "--ozone-platform-hint=auto"
            "--ignore-gpu-blocklist"
            "--enable-gpu-rasterization"
            "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,VaapiIgnoreDriverChecks"
            "--disable-features=UseChromeOSDirectVideoDecoder"
            "--ozone-platform=wayland"
          ];
          "Mod+Return".action.spawn = "alacritty";
          "Mod+d".action.spawn = [ "rofi" "-show" "combi" ];
          "Mod+Shift+Q".action.close-window = [ ];

          # Movement
          "Mod+h".action.focus-column-left = [ ];
          "Mod+l".action.focus-column-right = [ ];
          "Mod+j".action.focus-window-or-workspace-down = [ ];
          "Mod+k".action.focus-window-or-workspace-up = [ ];
          "Mod+f".action.fullscreen-window = [ ];

          "Mod+Shift+h".action.move-column-left = [ ];
          "Mod+Shift+l".action.move-column-right = [ ];
          "Mod+Shift+j".action.move-window-down-or-to-workspace-down = [ ];
          "Mod+Shift+k".action.move-window-up-or-to-workspace-up = [ ];
          "Mod+w".action.toggle-column-tabbed-display = [ ];
          "Mod+Shift+Comma".action.consume-window-into-column = [ ];
          "Mod+Shift+Period".action.expel-window-from-column = [ ];

          "Mod+BracketRight".action.focus-monitor-right = [ ];
          "Mod+BracketLeft".action.focus-monitor-left = [ ];
          "Mod+Shift+BracketRight".action.move-column-to-monitor-right = [ ];
          "Mod+Shift+BracketLeft".action.move-column-to-monitor-left = [ ];

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+m".action.maximize-column = [ ];

          # Workspaces
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;

          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;
          "Mod+Shift+6".action.move-column-to-workspace = 6;
          "Mod+Shift+7".action.move-column-to-workspace = 7;
          "Mod+Shift+8".action.move-column-to-workspace = 8;
          "Mod+Shift+9".action.move-column-to-workspace = 9;

          "Mod+Escape".action.toggle-overview = [ ];
        };

        outputs = let cfg = config.programs.niri.settings.outputs;
        in {
          "eDP-1" = {
            enable = true;
            mode.width = 3840;
            mode.height = 2160;
            mode.refresh = 60.0;
            position.x = 2560;
            position.y = 0;
          };
          "GIGA-BYTE TECHNOLOGY CO., LTD. M28U 21430B002974" = {
            enable = true;
            mode.width = 2560;
            mode.height = 1440;
            mode.refresh = 59.951;
            position.x = 0;
            position.y = 0;
            scale = 1;
          };
        };

        window-rules = [{
          matches = [{ app-id = "^emacs$"; }];
          default-column-width = { proportion = 0.8; };
        }];
      };
    };

    stylix.targets.waybar = {
      enable = true;
      addCss = true;
      # font = "emoji";
    };

    programs.waybar = {
      enable = true;
      style = ''
        * {
          font-family: "Ubuntu Mono", "Font Awesome 6 Free", sans-serif;
          font-size: 10pt;
        }

        #workspaces button {
          font-family: "Ubuntu Mono", "Font Awesome 6 Free", sans-serif;
          font-size: 30pt;
        }
        #workspaces button {
          padding: 1pt 5pt;
        }
      '';
      settings = [{
        height = 30;
        layer = "top";
        position = "top";
        tray = { spacing = 10; };
        modules-center = [ "niri/window" ];
        modules-left = [ "niri/workspaces" ];
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
        # "niri/workspaces" = {
        #   all-outputs = true;
        #   persistent-workspaces = {
        #     "1" = [ ];
        #     "2" = [ ];
        #     "3" = [ ];
        #     "4" = "4";
        #     "5" = "5";
        #     "6" = "6";
        #     "7" = "7";
        #     "8" = "8";
        #     "9" = [ ];
        #     "10" = [ ];
        #   };
        #   format = "{icon}";
        #   format-icons = {
        #     "1" = "";
        #     "2" = "";
        #     "3" = "";
        #     "9" = "";
        #     "10" = "";
        #   };
        # };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
      }];
    };

    home.packages = with pkgs; [
      pkgs.swaybg
      pkgs.xwayland-satellite
    ];

  };
}
