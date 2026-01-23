{ config, pkgs, lib, inputs, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Use Systemd-Boot
  #  boot.loader.systemd-boot = { 
  #    enable = true;
  #    editor = false;
  #    consoleMode = "max";
  #  };

  # Bootloader Settimgs
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jberges-5330";

  environment.systemPackages = with pkgs; [
    tpm2-tss
  ];
  
  environment.etc.hosts.mode = "0700";

  # Enable fingerint support
  services.fprintd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.libinput.enable = true;
  hardware.sensor.iio.enable = true;

  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };
}
