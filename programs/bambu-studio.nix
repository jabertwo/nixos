{ config, pkgs, ... }:

{
    environment.systemPackages = [
        pkgs.bambu-studio
    ];
}