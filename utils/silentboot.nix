{ config, pkgs, ... }:
{
  # Silent boot
  boot.plymouth = {
    enable = true;
    # This ensures the splash starts as soon as the initrd is loaded
    extraConfig = ''
      [Daemon]
      ShowDelay=0
    '';
  };
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
}