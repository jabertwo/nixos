{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.games.enable = false;
  services.gnome.core-apps.enable = false;
  services.gnome.gcr-ssh-agent.enable = false;
  environment.gnome.excludePackages = (
    with pkgs; [
      gnome-tour
    ]
  );

  # enable fractional scaling
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
  '';
    
  # Install needed programs
  environment.systemPackages = [
    pkgs.nautilus
    pkgs.gnome-terminal
    pkgs.gnome-text-editor
  ];
 
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Install dconf
  programs.dconf.enable = true;
}