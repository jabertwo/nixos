{ pkgs, ... }:
{
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [
            ddterm.extensionUuid
            dash-to-dock.extensionUuid
          ];
        };
        "org/gnome/desktop/wm/preferences" = {
          "button-layout" = ":minimize,maximize,close";
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
}