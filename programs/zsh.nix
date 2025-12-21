{ pkgs, ... }:
{
  home-manager.users.jabertwo = {
    home.packages = [
      pkgs.oh-my-zsh
    ];
    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake .";
        ip="ip -c";
        ipa="ip -c -br a | grep -v UNKNOWN";
        q="exit";
        ls="ls --color=tty";
        bc="bc -l";
      };
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ nmap man safe-paste sudo systemd ];
      theme = "candy";
    };
  };
}