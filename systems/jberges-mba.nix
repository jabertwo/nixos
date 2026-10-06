{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  system.stateVersion = 5;
  system.primaryUser = "jberges";
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  users.users.jberges = {
    home = "/Users/jberges";
    shell = pkgs.zsh;
  };
}
