{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      jczornik-gli = nixpkgs.lib.nixosSystem {
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./hosts/gli-laptop/configuration.nix

          # {
          #   wayland.windowManager.hyprland = {
          #     enable = true;
          #     # set the flake package
          #     package =
          #       inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          #     portalPackage =
          #       inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
          #   };
          # }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.jczornik = import ./home.nix;
          }
        ];
      };
    };
  };
}
