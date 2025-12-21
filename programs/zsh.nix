{ pkgs, ... }:
{
  home-manager.users.jabertwo = {
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

      initContent = ''
        if [ -z "$TMUX" ] && [ -n "$PS1" ] && [ "$TERM" != "screen-256color" ] && [ "$TERM" != "screen" ]; then
          tmux attach -t main || tmux new -s main
        fi
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
  };
}