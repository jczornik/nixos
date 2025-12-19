{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland.url = "github:hyprwm/Hyprland/refs/tags/v0.52.0";

    # hy3 = {
    #   url = "github:outfoxxed/hy3/refs/tags/hl0.52.0";
    #   inputs.hyprland.follows = "hyprland";
    # };

    stylix.url = "github:nix-community/stylix";
  };

  outputs = inputs@{ nixpkgs, home-manager, stylix, ... }: {
    nixosConfigurations = {
      jczornik-gli = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/gli-laptop/configuration.nix
          stylix.nixosModules.stylix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.jczornik = import ./home.nix;
          }
        ];
      };
      jczornik-personal = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/jczornik-personal/configuration.nix

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
