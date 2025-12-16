{ config, pkgs, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.framework-13-7040-amd
  ];


  # Bootloader Settimgs
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Systemd-Boot
  boot.loader.systemd-boot = { 
    enable = true;
    editor = false;
    consoleMode = "max";
  };

  # Silent boot
  boot.consoleLogLevel = 3;
  boot.plymouth.enable = true;

  networking.hostName = "jabertwo-fw13";

  # Enable fingerint support
  services.fprintd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
}