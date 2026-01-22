{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jberges@webdiscount.local";
  home.homeDirectory = "/home/jberges@webdiscount.local";

  imports = [
    ../programs/gnome/gnome-settings.nix
    ../programs/tmux/tmux.nix
    ../programs/zsh.nix
    ../ssh-configs/ssh-jabertwo.nix
    ../ssh-configs/ssh-warpzone.nix
  ];

  home.packages = [
    pkgs.vscodium
    pkgs.speedtest-cli
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

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}