{ config, lib, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers

    protontricks.enable = true;
  };

  environment.systemPackages = with pkgs; [
    steam
    protonplus
    protonup-qt
    protontricks
    winetricks
  ];
}