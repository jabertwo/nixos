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
      
      # Allow Agent forwarding
      AllowAgentForwarding = "yes";
    };
  };

  # Ensure the firewall allows incoming SSH connections
  networking.firewall.allowedTCPPorts = [ 22 ];
}
