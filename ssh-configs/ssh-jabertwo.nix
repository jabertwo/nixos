{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "de-fsn-pve01" = {
        user = "root";
        hostname = "144.76.201.171";
        port = 666;
      };
      "de-ms-wd1-pi01" = {
        user = "jabertwo";
        hostname = "212.3.68.122";
        port = 666;
      };
      "de-fsn-pve01-docker00" = {
        user = "jabertwo";
        hostname = "144.76.201.171";
        port = 667;
      };
      "de-fsn-pve01-docker01" = {
        user = "jabertwo";
        hostname = "144.76.201.154";
        port = 668;
      };
      "de-ms-pve02" = {
        hostname = "80.244.212.152";
        port = 666;
      };
      "de-ms-pve02-docker00" = {
        hostname = "10.1.11.100";
        port = 22;
        proxyJump = "root@80.244.212.152:666";
      };
      "de-fsn-pve01-jabertwo00" = {
        user = "jabertwo";
        hostname = "144.76.201.152";
        port = 666;
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