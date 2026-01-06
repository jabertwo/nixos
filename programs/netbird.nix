{ config, pkgs, ... }:
{
  services.netbird = {
    enable = true;
    tunnels = {
      home = {
        environment = {
          NB_MANAGEMENT_URL = "https://netbird.enteentelos.com/";
          NB_ADMIN_URL = "https://netbird.enteentelos.com/";
        };
      };
    };
  };
}