{ conf,pkgs, ... }:
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

  # --- Simple Kea Lease Web Viewer ---

  # 1. Open port 8080 on the internal VLAN
  networking.firewall.interfaces."vlan555".allowedTCPPorts = [ 8080 ];
  # (Also open it on end0 if you want to access it from VLAN 210)
  networking.firewall.interfaces."end0".allowedTCPPorts = [ 8080 ];

  # 2. Create the micro web-server service
  systemd.services.kea-lease-viewer = {
    description = "Simple Web UI for Kea DHCP Leases";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "kea-dhcp4-server.service" ];
    
    script = ''
      ${pkgs.python3}/bin/python3 -c '
      import csv, http.server, socketserver, datetime
      
      html = """
      <html><head>
        <title>Kea DHCP Leases</title>
        <style>
          body { font-family: sans-serif; background: #1e1e2e; color: #cdd6f4; padding: 20px; }
          table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #181825; }
          th, td { border: 1px solid #45475a; padding: 12px; text-align: left; }
          th { background: #313244; color: #89b4fa; }
        </style>
      </head><body>
      <h2>Active DHCP Leases (VLAN 555)</h2>
      <table><tr><th>IP Address</th><th>MAC Address</th><th>Hostname</th><th>Expires (Local Time)</th></tr>
      {rows}
      </table></body></html>
      """
      
      class Handler(http.server.SimpleHTTPRequestHandler):
          def do_GET(self):
              self.send_response(200)
              self.send_header("Content-type", "text/html")
              self.end_headers()
              
              leases = {}
              try:
                  with open("/var/lib/kea/dhcp4.leases", "r") as f:
                      reader = csv.reader(f)
                      next(reader, None) # Skip the header
                      for row in reader:
                          if len(row) >= 10:
                              # Kea appends updates, so dict assignment naturally keeps only the latest state
                              leases[row[0]] = row
                              
                  rows = ""
                  for ip, row in leases.items():
                      state = row[9]
                      # State 0 means the lease is currently active. 
                      # (We ignore state 1/2 which are declined/released)
                      if state == "0":
                          mac = row[1]
                          hostname = row[8] if row[8] else "<i>Unknown</i>"
                          
                          # Convert Unix timestamp to local time
                          expire_ts = int(row[4])
                          expire_time = datetime.datetime.fromtimestamp(expire_ts).strftime("%Y-%m-%d %H:%M:%S")
                          
                          rows += f"<tr><td>{ip}</td><td>{mac}</td><td>{hostname}</td><td>{expire_time}</td></tr>"
                          
              except Exception as e:
                  rows = f"<tr><td colspan=\"4\">Could not read leases: {e}</td></tr>"
              
              self.wfile.write(html.replace("{rows}", rows).encode("utf-8"))
      
      # We allow reuse of the address so the service restarts cleanly
      class ReusableTCPServer(socketserver.TCPServer):
          allow_reuse_address = True

      with ReusableTCPServer(("", 8080), Handler) as httpd:
          print("Serving Kea leases on port 8080")
          httpd.serve_forever()
      '
    '';
  };
}