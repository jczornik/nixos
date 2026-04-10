let assignWorkspaces = import "./assignWorkspaces.nix";
in { config, lib, pkgs, inputs, stylix, ... }:

{
  imports = [
    ./desktop_environments/niri.nix
    # ./desktop_environments/sway.nix
  ];

  home.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    EDITOR = "emacsclient -c";
    LIBVA_DRIVER_NAME = "iHD";
  };
  home.packages = with pkgs; [
    alacritty
    git
    nixfmt-classic
    xfce.thunar
    unzip
    google-chrome
    ncdu
    remmina
    freerdp
    dig
    grim
    slurp
    wl-clipboard
    btop
    fd
    nodejs_24
    brightnessctl
    python3
    dunst
    direnv
    nushell
    carapace
    starship
    zoxide
    jq
    copilot-language-server
  ];

  custom.desktop.niri.enable = true;

  gtk.gtk4.theme = null;

  services.dunst.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "None";
    };
  };

  programs.btop = { enable = true; };

  # programs.direnv = {
  #   enable = true;

  # };

  fonts.fontconfig.enable = true;
  programs.bash.enable = true;

  programs = {
    # 1. Enable Carapace with automatic integration
    carapace = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };

    # 2. Use the native Direnv module (replaces your manual hook)
    direnv = {
      enable = true;
      enableNushellIntegration =
        true; # Automatically handles the hook/env loading
      enableBashIntegration = true;
      nix-direnv.enable = true; # Highly recommended for caching
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
  };

  programs.nushell = {
    enable = true;
    # 3. Use specific updates instead of replacing the whole $env.config
    extraConfig = ''
      $env.config.show_banner = false

      $env.config.completions.case_sensitive = false
      $env.config.completions.quick = true
      $env.config.completions.partial = true
      $env.config.completions.algorithm = "fuzzy"

      $env.config.completions.external = {
        enable: true
        max_results: 100
        # Do NOT manually set 'completer' here.
        # The carapace.enableNushellIntegration handles the bridge automatically.
      }
    '';

    plugins = [ pkgs.nushellPlugins.gstat ];
  };

  home.pointerCursor = {
    # gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
    size = 20;
  };

  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    location = "center";
    theme = "gruvbox-dark-hard";
  };

  stylix.targets.emacs.enable = false;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  services.emacs = {
    enable = true;
    startWithUserSession = true;
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
