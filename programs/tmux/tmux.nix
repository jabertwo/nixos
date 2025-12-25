{ config, pkgs, ... }:

let
  tmuxConfDir = "${config.xdg.configHome}/tmux";
  baseConfigName = "oh-my-tmux.conf"; 
in
{
  home.packages = with pkgs; [
    perl
    gawk
    gnused
    coreutils
    git
  ];

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    
    plugins = with pkgs.tmuxPlugins; [
      cpu
    ];

    extraConfig = ''
      # Tell the script where to find the file with the embedded shell functions
      set-environment -g TMUX_CONF "${tmuxConfDir}/${baseConfigName}"
      set-environment -g TMUX_CONF_LOCAL "${tmuxConfDir}/tmux.conf.local"

      # Source the actual file
      source-file "${tmuxConfDir}/${baseConfigName}"
    '';
  };

  xdg.configFile."tmux/${baseConfigName}".text = builtins.readFile ./oh-my-tmux.conf;
  xdg.configFile."tmux/tmux.conf.local".text = builtins.readFile ./local.conf;
}