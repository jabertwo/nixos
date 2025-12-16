{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
 
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };


  # remove unnecesary gnome packages
  environment.gnome.excludePackages = (with pkgs; [
    cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gnome-characters
    gnome-music
    gnome-photos
    gnome-tour
    totem
  ]);

  # Install dconf
  programs.dconf.enable = true;
}