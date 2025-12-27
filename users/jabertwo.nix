{ config, pkgs, ... }:
{
  imports = [
    ../programs/gnome-settings.nix
    ../programs/zsh.nix
    ../programs/prusa-slicer.nix
  ];

  environment.systemPackages = [
    pkgs.telegram-desktop
  ];

  users.users.jabertwo = {
    isNormalUser = true;
    description = "jabertwo";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager.users.jabertwo = { pkgs, ...}: {
    imports = [ 
      ../programs/tmux/tmux.nix
      ../programs/ssh-jabertwo.nix
    ];
    home.stateVersion = "25.11";
    home.packages = [
      pkgs.gnomeExtensions.ddterm
      pkgs.gnomeExtensions.dash-to-dock
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
  };

  # Make vim the default editor
  environment.variables.EDITOR = "vim";
}