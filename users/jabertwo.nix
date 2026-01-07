{ config, pkgs, ... }:
{
  imports = [
    # ../programs/quicksync.nix
    ../programs/netbird.nix
  ];

  environment.systemPackages = with pkgs; [
    telegram-desktop
    fractal
  ];

  users.users.jabertwo = {
    isNormalUser = true;
    description = "jabertwo";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.zsh;
    initialHashedPassword = "$y$j9T$Fpp709QJcNsbgIC/jm9Wl.$/HhQKzTLuYp94fm3JiOBLWscbG7vn2cu.HRlsIIxrl9";
  };

  programs.zsh.enable = true;

  home-manager.users.jabertwo = { pkgs, ...}: {
    imports = [
      ../programs/gnome/gnome-settings.nix
      ../programs/tmux/tmux.nix
      ../programs/zsh.nix
      ../ssh-configs/ssh-jabertwo.nix
      ../ssh-configs/ssh-warpzone.nix
    ];
    home.stateVersion = "25.11";
    home.packages = [
      pkgs.vscodium
      pkgs.speedtest-cli
      pkgs.prusa-slicer
      pkgs.libreoffice
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
          "terminal.integrated.defaultProfile.linux" = "zsh";
        };
      };
    };

  };

  # Make vim the default editor
  environment.variables.EDITOR = "vim";
}