{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake .";
      upgrade = "nix flake update --commit-lock-file";
      ip="ip -c";
      ipa="ip -c -br a | grep -v UNKNOWN";
      q="exit";
      ls="ls --color=tty";
      bc="bc -l";
    };
    initContent = ''
      if [ -z "$TMUX" ] && [ -n "$PS1" ] && [ "$TERM" != "screen-256color" ] && [ "$TERM" != "screen" ]; then
        tmux attach -t main || tmux new -s main
      fi
      fastfetch
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "nmap"
        "man"
        "safe-paste"
        "sudo"
        "systemd"
      ];
      theme = "candy";
    };
  };
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        percent = {
          type = 9;
        };
      };
      modules = [
        "os"
        "host"
        "kernel"
        "uptime"
        "de"
        "cpu"
        "memory"
        "swap"
        "disk"
        "battery"
        "localIP"
        "publicIP"
      ];
    };
  };
}
