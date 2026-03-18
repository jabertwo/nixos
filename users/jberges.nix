{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

  ];

  users.users.jberges = {
    isNormalUser = true;
    description = "jberges";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.zsh;
    initialHashedPassword = "$y$j9T$ULBqWjxo/xCsHsvRT2Q1C0$ss5IiThBxWa.YYk4qMAu/pEyq.DT4DY27phKC6LmGc7";
  };
  
  programs.zsh.enable = true;
  programs.firefox.enable = true;

  home-manager.users.jberges = { pkgs, ...}: {
    imports = [
      ../programs/gnome/gnome-settings.nix
      ../programs/tmux/tmux.nix
      ../programs/zsh.nix
      ../ssh-configs/ssh-jabertwo.nix
      ../ssh-configs/ssh-warpzone.nix
    ];
    home.stateVersion = "25.11";
    home.packages = with pkgs; [
      vscodium
      speedtest-cli
      libreoffice
      adoptopenjdk-icedtea-web
      telegram-desktop
      fractal
      teams-for-linux
      freecad
      dbeaver-bin
      remmina
      wireshark
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
