{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    whois
    bind
    usbutils
    ansible
    ansible-lint
    mtr
    htop
    devenv
    plocate
    nmap
    inetutils
    tio
    tmate
  ];
}