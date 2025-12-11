{ config, pkgs, ... }:
{
  users.users.jabertwo = {
    isNormalUser = true;
    description = "jabertwo";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  home-manager.users.jabertwo = {
    home.stateVersion = "25.11";
    home.packages = [
      pkgs.gnomeExtensions.ddterm
      pkgs.gnomeExtensions.dash-to-dock
      pkgs.element-desktop
      pkgs.vscodium
    ];
    programs.git = {
      enable = true;
      settings = {
        user.Name = "jabertwo";
        user.Email = "git@jabertwo.de";
      };
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix         # Nix language support
        ];
        userSettings = {
          "editor.fontSize" = 14;
          "terminal.integrated.defaultProfile.linux" = "bash";
        };
      };
    };
    programs.element-desktop = {
      enable = true;
    };
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
  };
}