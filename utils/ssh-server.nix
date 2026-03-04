{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    
    # Secure defaults
    settings = {
      # Disable password authentication to force key-based logins
      PasswordAuthentication = false; 
      
      # Prevent direct root logins
      PermitRootLogin = "no";
    };
  };

  # Ensure the firewall allows incoming SSH connections
  networking.firewall.allowedTCPPorts = [ 22 ];
}