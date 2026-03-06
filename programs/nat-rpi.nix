{ conf, ... }:
{
  networking.nat = {
    enable = true;
    
    # The interface with internet access (Untagged Native VLAN 210)
    externalInterface = "end0"; 
    
    # The interface(s) that need internet access masqueraded 
    internalInterfaces = [ "vlan555" ];
  };

  networking.firewall.trustedInterfaces = [ "vlan555" ];
}