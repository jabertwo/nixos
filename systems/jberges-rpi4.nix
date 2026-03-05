# ./systems/rpi4.nix

{ config, pkgs, ... }:

{
  # --- BOOTLOADER ---
  # The Pi uses U-Boot, so we disable standard GRUB/systemd-boot
  # and use the extlinux-compatible builder.
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  nix.settings.trusted-users = [ "root" "@wheel" ];

  # Load proprietary firmware for Wi-Fi/Bluetooth
  hardware.enableRedistributableFirmware = true;

  # --- NETWORKING ---
  networking.hostName = "jberges-rpi4";

  # --- PI-SPECIFIC PACKAGES ---
  environment.systemPackages = with pkgs; [
    libraspberrypi # Provides `vcgencmd` for checking temps, throttling, etc.
  ];
}