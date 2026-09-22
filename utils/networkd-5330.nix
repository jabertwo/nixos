{ config, pkgs, ... }:
{
    networking.useDHCP = false;
    networking.useNetworkd = true;

    systemd.network = {
        enable = true;

        netdevs = {
            "30-vlan205" = {
                netdevConfig = {
                    Name = "vlan205";
                    Kind = "vlan";
                };
                vlanConfig.Id = 205;
            };
        };

        networks = {
            "10-labor" = {
                matchConfig.PermanentMACAddress = "2c:16:db:ac:91:0e";

                vlan = [ "vlan205" ];

                linkConfig.ActivationPolicy = "always-up";
                networkConfig.DHCP = "ipv4";
            };

            "20-vlan205-wlan" = {
                matchConfig.Name = "vlan205";
                networkConfig.DHCP = "ipv4";
            };
        };
    };
}