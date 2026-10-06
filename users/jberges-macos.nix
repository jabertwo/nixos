{ config, pkgs, ... }:
{
  home.username = "jberges";
  home.homeDirectory = "/Users/jberges";
  home.stateVersion = "25.11";

  imports = [
    ../programs/tmux/tmux.nix
    ../ssh-configs/ssh-jabertwo.nix
    ../ssh-configs/ssh-warpzone.nix
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "darwin-rebuild switch --flake .";
      upgrade = "nix flake update --commit-lock-file";
      q = "exit";
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
