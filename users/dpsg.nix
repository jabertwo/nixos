{ config, pkgs, ... }:
{
  users.users.dpsg = {
    isNormalUser = true;
    description = "dpsg";
    extraGroups = [ ];
    shell = pkgs.zsh;
    initialHashedPassword = "$y$j9T$8I0Efeo.w0npiApaPby.o/$woYJ1JAFPBcdZfVwzlRP0okMtR9dwkTbqIym3SpU429";
  };

  programs.zsh.enable = true;
  programs.firefox.enable = true;

  home-manager.users.dpsg = { pkgs, ...}: {
    imports = [
      ../programs/zsh.nix
      ../programs/gnome/gnome-settings.nix
      ../programs/tmux/tmux.nix
    ];
    home.stateVersion = "25.11";
  };

  # Make vim the default editor
  environment.variables.EDITOR = "vim";
}