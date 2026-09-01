{ config, pkgs, ... }:

{
  services.flatpak.packages = [
    "com.bambulab.BambuStudio"
  ];
}