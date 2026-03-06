{ conf, ... }:
{
    # --- VLAN 555 Configuration ---
  
  # 1. Create the virtual VLAN interface on top of the physical Ethernet port
  networking.vlans = {
    vlan555 = {
      id = 555;
      interface = "end0"; # Ensure this matches your Pi's physical interface name
    };
  };

  # 2. Assign the static IP to the new VLAN interface
  networking.interfaces.vlan555.ipv4.addresses = [{
    address = "10.5.55.1";
    prefixLength = 24;
  }];

  # 3. Open the firewall for DHCP requests (UDP 67) ONLY on the VLAN interface
  networking.firewall.interfaces."vlan555".allowedUDPPorts = [ 67 ];

  # --- Kea DHCP Server Configuration ---
  
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [ "vlan555" ];
      };
      
      # Tell Kea where to save the leases so they survive reboots
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4.leases";
      };
      
      # Global lease time (e.g., 24 hours)
      valid-lifetime = 86400; 

      subnet4 = [
        {
          id = 1; # <--- CRITICAL FIX: Kea 3.x requires a subnet ID
          subnet = "10.5.55.0/24";
          pools = [ { pool = "10.5.55.100 - 10.5.55.254"; } ];
          option-data = [
            {
              name = "routers";
              data = "10.5.55.1";
            }
            {
              name = "domain-name-servers";
              data = "1.1.1.1, 8.8.8.8"; 
            }
          ];
        }
      ];
    };
  };
}