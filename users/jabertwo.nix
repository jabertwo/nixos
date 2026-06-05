{ config, pkgs, ... }:
{
  imports = [
    ../programs/netbird.nix
  ];

  services.flatpak.enable = true;

  users.users.jabertwo = {
    isNormalUser = true;
    description = "jabertwo";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.zsh;
    initialHashedPassword = "$y$j9T$Fpp709QJcNsbgIC/jm9Wl.$/HhQKzTLuYp94fm3JiOBLWscbG7vn2cu.HRlsIIxrl9";
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBMU/DG+S/3fGsXsQk6cTOClLH8LXFtL9IL8u6B6Pr1xC4iluZ2xoqQvsYIx5H2sX3nw6WM/VoEVP+xMxEazoOKAwB/31OazpYGG3JGuDvOVlbRVHNoxF9wn3JY9uPyI+Jg== jabertwo-home"
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBGR9N60F+0annoCi9cM+94jSxsw8KPgMf7GqKoFmxwpcDf6fd7Vc5sRQg0avnEg009D2nxihED0y2eTP2Tzn6eQQ/2LRXRfMCa+hRK99YYPUjpszH/y2bC2r/08CvcdeVA== jabertwo-mob"
    ];
  };

  programs.zsh.enable = true;
  programs.firefox.enable = true;
  
  home-manager.users.jabertwo = { pkgs, ...}: {
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
      prusa-slicer
      libreoffice
      thunderbird
      telegram-desktop
      fractal
      flatpak
      freecad
      gnome-software
      remmina
    ];
    programs.git = {
      enable = true;
      settings = {
        user.Name = "jabertwo";
        user.Email = "git@jabertwo.de";
      };
    };
    programs.vscodium = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix         # Nix language support
        ];
        userSettings = {
          "editor.fontSize" = 14;
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "window.autoDetectColorScheme" = true;
        };
      };
    };
    programs.discord = {
      enable = true;
      settings = {
        SKIP_HOST_UPDATE = true;
      };
    };
  };

  # Make vim the default editor
  environment.variables.EDITOR = "vim";
}
