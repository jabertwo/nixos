{ config, pkgs, ... }:
{
  imports = [
    ../programs/zsh.nix
  ];

  users.users.dpsg = {
    isNormalUser = true;
    description = "dpsg";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.zsh;
    initialHashedPassword = "$y$j9T$8I0Efeo.w0npiApaPby.o/$woYJ1JAFPBcdZfVwzlRP0okMtR9dwkTbqIym3SpU429";
  };

  programs.zsh.enable = true;

  home-manager.users.dpsg = { pkgs, ...}: {
    imports = [
      ../programs/gnome/gnome-settings.nix
      ../programs/tmux/tmux.nix
    ];
    home.stateVersion = "25.11";
  };

  # Make vim the default editor
  environment.variables.EDITOR = "vim";
}