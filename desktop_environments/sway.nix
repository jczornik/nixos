{ config, lib, pkgs, ... }:

{
  options.custom.desktop.sway.enable =
    lib.mkEnableOption "Sway Wayland Compositor";

  config = lib.mkIf config.custom.desktop.niri.enable {
    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
      config = rec {
        modifier = "Mod4";
        terminal = "alacritty";
        startup = [
          # Launch Firefox on start
          #{command = "firefox";}
        ];
        input = { "*" = { xkb_layout = "pl"; }; };
        workspaceOutputAssign = [
          {
            workspace = "1";
            output = "*M28U*";
          }
          {
            workspace = "2";
            output = "*M28U*";
          }
          {
            workspace = "3";
            output = "*M28U*";
          }
          {
            workspace = "4";
            output = "*M28U*";
          }
          {
            workspace = "5";
            output = "*M28U*";
          }
          {
            workspace = "6";
            output = "*M28U*";
          }

          # Assign the rest (7-10) to the laptop screen
          {
            workspace = "7";
            output = "eDP-1";
          }
          {
            workspace = "8";
            output = "eDP-1";
          }
          {
            workspace = "9";
            output = "eDP-1";
          }
          {
            workspace = "10";
            output = "eDP-1";
          }
        ];
        keybindings =
          let modifier = config.wayland.windowManager.sway.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+d" = "exec rofi -show combi";
            "${modifier}+Shift+b" =
              "exec google-chrome-stable --ozone-platform-hint=auto --ignore-gpu-blocklist --enable-gpu-rasterization --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,VaapiIgnoreDriverChecks --disable-features=UseChromeOSDirectVideoDecoder";
            "${modifier}+Shift+e" = "exec emacsclient -c";
            "${modifier}+Shift+o" = "exec swaylock -f";
            "${modifier}+Shift+p" = ''
              exec sh -c "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"'';
          };
      };
    };

    programs.swaylock.enable = true;
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
        {
          timeout = 600;
          command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
        }
      ];
      events = [{
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }];
    };
    services.kanshi = {
      enable = true;
      systemdTarget = "sway-session.target"; # This is the magic line

      settings = [
        {
          profile.name = "home-office";
          profile.outputs = [
            {
              criteria = "*M28U*";
              mode = "2560x1440@59.95Hz";
              position = "0,0";
            }
            {
              criteria = "eDP-1";
              # mode = "1920x1080@60.00000";
              position = "2560,0";
            }
          ];
          profile.exec = [
            "${pkgs.sway}/bin/swaymsg 'workspace 1, move workspace to output *M28U*'"
            "${pkgs.sway}/bin/swaymsg 'workspace 2, move workspace to output *M28U*'"
            "${pkgs.sway}/bin/swaymsg 'workspace 3, move workspace to output *M28U*'"
            "${pkgs.sway}/bin/swaymsg 'workspace 4, move workspace to output *M28U*'"
            "${pkgs.sway}/bin/swaymsg 'workspace 5, move workspace to output *M28U*'"
            "${pkgs.sway}/bin/swaymsg 'workspace 6, move workspace to output *M28U*'"
            "${pkgs.sway}/bin/swaymsg 'workspace 7, move workspace to output eDP-1'"
            "${pkgs.sway}/bin/swaymsg 'workspace 8, move workspace to output eDP-1'"
            "${pkgs.sway}/bin/swaymsg 'workspace 9, move workspace to output eDP-1'"
            "${pkgs.sway}/bin/swaymsg 'workspace 10, move workspace to output eDP-1'"
          ];
        }
        {
          profile.name = "mobile";
          profile.outputs = [{ criteria = "eDP-1"; }];
        }
      ];
    };
  };
}
