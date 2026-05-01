{ config, pkgs, ... }:

{
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  # Enable I2C hardware support
  hardware.i2c.enable = true;
  
  # Load the required kernel modules
  boot.kernelModules = [ 
    "i2c-dev" 
    "i2c-piix4" # Use "i2c-piix4" for AMD motherboards, or "i2c-i801" for Intel motherboards
  ];
}