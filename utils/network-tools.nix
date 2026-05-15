{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    whois
    bind
    mtr
    nmap
    inetutils
    tio
    tmate
  ];
}