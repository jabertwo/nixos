{ config, pkgs, ... }:
{
  services.flatpak.enable = true;

  users.users.cutemeli = {
    isNormalUser = true;
    description = "cutemeli";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.zsh;
    initialHashedPassword = "$y$j9T$/Tqz2eFq7/UY8Wm1Tj1Cw0$bPpqr9soOCNarqBxJRS8AAeuuGfBRWEa3x3RtyBpn.A";
  };

  programs.zsh.enable = true;
  programs.firefox.enable = true;
  
  home-manager.users.cutemeli = { pkgs, ...}: {
    imports = [
      ../programs/gnome/gnome-settings.nix
      ../programs/tmux/tmux.nix
      ../programs/zsh.nix
    ];
    home.stateVersion = "25.11";
    home.packages = with pkgs; [
      vscodium
      speedtest-cli
      prusa-slicer
      libreoffice
      thunderbird
      spotify
      heroic-unwrapped
      telegram-desktop
      flatpak
      gnome-software
    ];
    programs.git = {
      enable = true;
      settings = {
        user.Name = "cutemeli";
        user.Email = "git@cutemeli.de";
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
