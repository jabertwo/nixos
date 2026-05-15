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
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBMU/DG+S/3fGsXsQk6cTOClLH8LXFtL9IL8u6B6Pr1xC4iluZ2xoqQvsYIx5H2sX3nw6WM/VoEVP+xMxEazoOKAwB/31OazpYGG3JGuDvOVlbRVHNoxF9wn3JY9uPyI+Jg== jabertwo-home"
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBGR9N60F+0annoCi9cM+94jSxsw8KPgMf7GqKoFmxwpcDf6fd7Vc5sRQg0avnEg009D2nxihED0y2eTP2Tzn6eQQ/2LRXRfMCa+hRK99YYPUjpszH/y2bC2r/08CvcdeVA== jabertwo-mob"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "jberges" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  programs.zsh.enable = true;
  
  home-manager.users.jberges = { pkgs, ...}: {
    imports = [
      ../programs/zsh.nix
    ];
    home.stateVersion = "25.11";
    programs.git = {
      enable = true;
      settings = {
        user.Name = "jabertwo";
        user.Email = "git@jabertwo.de";
      };
    };
  };

  # Make vim the default editor
  environment.variables.EDITOR = "vim";
}
