{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      # warpzone Server
      "weatherwax" = {
        user ="root";
        hostname = "192.168.0.200";
      };
      "weatherwax-remote" = {
        user ="root";
        hostname = "192.168.0.200";
        proxyJump = "root@wz-web";
      };
      "ogg" = {
        user ="root";
        hostname = "192.168.0.201";
      };
      "ogg-remote" = {
        user ="root";
        hostname = "192.168.0.201";
        proxyJump = "root@wz-web";
      };
      "carrot" = {
        user ="root";
        hostname = "192.168.0.202";
      };
      "carrot-remote" = {
        user ="root";
        hostname = "192.168.0.202";
        proxyJump = "root@wz-web";
      };
      "dhcpdns" = {
        user = "root";
        hostname = "10.0.0.2";
      };
      "dhcpdns-remote" = {
        user = "root";
        hostname = "10.0.0.2";
        proxyJump = "root@ogg-remote";
      };
      "tiffany" = {
        hostname = "159.69.57.15";
        user = "root";
      };
      "wz-web" = {
        hostname = "159.69.57.51";
        user = "root";
      };
      "verwaltung" = {
        hostname = "195.201.179.60";
        user = "root";
      };
      "wz-test" = {
        user ="root";
        hostname = "159.69.57.56";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}