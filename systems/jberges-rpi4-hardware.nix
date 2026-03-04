{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"      # USB 3.0 controller
    "usbhid"        # USB input devices
    "usb_storage"   # USB Mass Storage
    "uas"           # USB Attached SCSI (speeds up USB SSDs)
  ];
  
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # --- FILE SYSTEMS ---
  # NOTE: I highly recommend using `/dev/disk/by-uuid/...` instead of labels 
  # if you plan on plugging in multiple drives, but labels are easier for initial setup.
  # Run `lsblk -f` to get your exact UUIDs or labels after formatting.
  
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888"; 
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2178-694E";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ ];

  # Tells Nixpkgs to build/fetch packages for ARM64
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}