{ config, pkgs, nixos-hardware, ... }:
{
  # Bootloader Settimgs
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Systemd-Boot
  boot.loader.systemd-boot = { 
    enable = true;
    editor = false;
    consoleMode = "max";
  };
  
  networking.hostName = "jabertwo-zen";

  environment.systemPackages = with pkgs; [
    tpm2-tss
  ];

  # Enable fingerint support
  services.fprintd.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = false;
}