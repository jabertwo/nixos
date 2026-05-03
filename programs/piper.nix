{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.piper
    pkgs.libratbag
  ];
  services.ratbagd.enable = true;
}