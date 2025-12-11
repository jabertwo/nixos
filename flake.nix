# /etc/nixos/flake.nix

{
  description = "NixOS configuration for Framework 13 (AMD 7040)";

  inputs = {
    # nixpkgs stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }: {
    # Define a NixOS configuration named after your hostname
    nixosConfigurations = {
      jabertwo-fw13 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./configuration.nix
          ./hardware-configuration.nix
          #./users/jabertwo.nix
        ];
      };
    };
  };
}
