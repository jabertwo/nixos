# /etc/nixos/flake.nix

{
  description = "jabertwo's NixOS configuration";

  inputs = {
    # nixpkgs stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
    # Define a NixOS configuration named after your hostname
    nixosConfigurations = {
      jabertwo-fw13 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixos-hardware; };
        system = "x86_64-linux";
        modules = [
          ./systems/fw13-hardware.nix
          ./systems/fw-13.nix
          ./utils/base.nix
          ./utils/yubikey.nix
          ./utils/gnome.nix
          ./users/jabertwo.nix
        ];
      };
    };
  };
}
