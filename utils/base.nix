{ config, pkgs, ... }:
{
  system.autoUpgrade = {
    enable = true;
    operation = "boot";
    dates = "hourly";
    allowReboot = false;
  };
  # Garbage collection 
  nix.settings.auto-optimise-store = true;
  nix.gc = { 
    automatic = true;
    dates = "hourly";
    options = "--delete-older-than +10";
  };
}