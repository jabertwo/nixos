{ config, pkgs, lib, inputs, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Use Systemd-Boot
  # boot.loader.systemd-boot = { 
  #  enable = true;
  #  editor = false;
  #  consoleMode = "max";
  # };

  # Bootloader Settings
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jberges-5330";

  environment.systemPackages = with pkgs; [
    tpm2-tss
    canon-cups-ufr2
  ];
  
  environment.etc.hosts.mode = "0700";

  # Enable fingerint support
  # services.fprintd = {
  #   enable = true;
  #   package = pkgs.fprintd-tod;
  #   tod.enable = true;
  #   tod.driver = pkgs.libfprint-2-tod1-broadcom;
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.libinput.enable = true;
  hardware.sensor.iio.enable = true;

  services.thermald.enable = true;
}
