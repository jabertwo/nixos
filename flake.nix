# /etc/nixos/flake.nix

{
  description = "jabertwo's NixOS configuration";

  inputs = {
    # nixpkgs stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, lanzaboote, ... }@inputs: {
    # Define a NixOS configuration named after your hostname
    nixosConfigurations = {
      jabertwo-fw13 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixos-hardware; };
        system = "x86_64-linux";
        modules = [
          ./systems/fw13-hardware.nix
          ./systems/fw13.nix
          ./utils/base.nix
          ./utils/secureboot.nix
          ./utils/silentboot.nix
          ./utils/yubikey.nix
          ./programs/gnome/gnome.nix

          ./users/jabertwo.nix
          ./users/dpsg.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }

        ];
      };
      jabertwo-zen = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixos-hardware; };
        system = "x86_64-linux";
        modules = [
          ./systems/zen-hardware.nix
          ./systems/zen.nix
          ./utils/base.nix
          ./utils/secureboot.nix
          ./utils/silentboot.nix
          ./utils/yubikey.nix
          ./programs/gnome/gnome.nix

          ./users/jabertwo.nix

          ./programs/steam.nix
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }

        ];
      };
      jberges-5330 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixos-hardware; };
        system = "x86_64-linux";
        modules = [
          ./systems/jberges-5330-hardware.nix
          ./systems/jberges-5330.nix
          ./utils/base.nix
          #./utils/secureboot.nix
          #./utils/silentboot.nix
          ./utils/yubikey.nix
          ./programs/gnome/gnome.nix

          ./users/jberges.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }

        ];
      };
 
    };
  };
}
