{ config, pkgs, ... }:

{
  # 1. Enable the NetBird service
  services.netbird.enable = true;

  # 2. Set the Management URL globally
  # This ensures that when you type 'netbird up', it knows where to go.
  environment.variables.NB_MANAGEMENT_URL = "https://netbird.enteentelos.com";

  # 3. Optional: Open firewall ports for better peer-to-peer connectivity
  networking.firewall.allowedUDPPorts = [ 51820 ];

  # 4. Install the packages
  environment.systemPackages = with pkgs; [ 
    netbird 
    netbird-ui # Include this if you want the system tray icon
  ];
}