# ./systems/rpi4.nix

{ config, pkgs, ... }:

{
  # --- BOOTLOADER ---
  # The Pi uses U-Boot, so we disable standard GRUB/systemd-boot
  # and use the extlinux-compatible builder.
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Load proprietary firmware for Wi-Fi/Bluetooth
  hardware.enableRedistributableFirmware = true;

  # --- NETWORKING ---
  networking.hostName = "jberges-rpi4";
  
  # Assuming NetworkManager is handled in your base.nix, 
  # otherwise uncomment this:
  # networking.networkmanager.enable = true;

  # --- PI-SPECIFIC PACKAGES ---
  environment.systemPackages = with pkgs; [
    libraspberrypi # Provides `vcgencmd` for checking temps, throttling, etc.
  ];
}