{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.tmate
  ];
}