{ config, pkgs, ... }:
{
  # For mount.cifs, required unless domain name resolution is not needed.
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/home/jberges/AD/W" = {
    device = "//10.240.252.3/webdiscount";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/home/jberges/.smb-secrets,uid=1000,gid=100"];
  };
  fileSystems."/home/jberges/AD/K" = {
    device = "//10.240.252.3/kunden";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/home/jberges/.smb-secrets,uid=1000,gid=100"];
  };
  fileSystems."/home/jberges/AD/L" = {
    device = "//10.240.252.3/lieferanten";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/home/jberges/.smb-secrets,uid=1000,gid=100"];
  };
  fileSystems."/home/jberges/AD/S" = {
    device = "//10.240.252.3/software";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/home/jberges/.smb-secrets,uid=1000,gid=100"];
  };
  fileSystems."/home/jberges/AD/H" = {
    device = "//10.240.252.3/jberges";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/home/jberges/.smb-secrets,uid=1000,gid=100"];
  };
}