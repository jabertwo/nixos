{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.tio
  ];
}