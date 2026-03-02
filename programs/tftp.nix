{ pkgs, lib, ... }:

{
  services.tftpd.enable = false;

  systemd.services.atftpd = {
    description = "Atftpd TFTP Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.atftp}/bin/atftpd --daemon --no-fork --no-multicast --bind-address 0.0.0.0 --logfile - --user tftp --group tftp /srv/tftp";
      Restart = "always";
    };
  };

  systemd.tmpfiles.rules = [ "d /srv/tftp 0777 tftp tftp -" ];
  users.users.tftp = { isSystemUser = true; group = "tftp"; };
  users.groups.tftp = {};

  networking.firewall.allowedUDPPorts = [ 69 ];
}
