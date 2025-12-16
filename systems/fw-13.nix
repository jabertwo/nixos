{ config, pkgs, ... }:
{
  nixos-hardware.nixosModules.framework-13-7040-amd
  # Enable fingerint support
  services.fprintd.enable = true;
}