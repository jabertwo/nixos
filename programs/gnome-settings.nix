{ pkgs, ... }:
{
  home-manager.users.jabertwo = {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [
            ddterm.extensionUuid
            dash-to-dock.extensionUuid
          ];
        };
        "org/gnome/desktop/wm/preferences" = {
          "button-layout" = ":minimize,maximize,close";
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
        "org/gnome/settings-daemon/housekeeping" = {
          donation-reminder-enabled = false;
        };
        "org/gnome/desktop/background" = {
          picture-uri =
            "file:///run/current-system/sw/share/backgrounds/gnome/map-l.svg";
          picture-uri-dark =
            "file:///run/current-system/sw/share/backgrounds/gnome/map-d.svg";
        };
        "com/github/amezin/ddterm" = {
          ddterm-toggle-hotkey = [ "F12" ];
          shortcut-find = [];
          shortcut-find-next = [];
          shortcut-find-prev = [];
          shortcut-font-scale-decrease = ["<Control>minus"];
          shortcut-font-scale-increase = ["<Control>plus"];
          shortcut-font-scale-reset = [];
          shortcut-move-tab-next = [];
          shortcut-move-tab-prev = [];
          shortcut-next-tab = [];
          shortcut-page-close = [];
          shortcut-prev-tab = [];
          shortcut-switch-to-tab-1 = [];
          shortcut-switch-to-tab-10 = [];
          shortcut-switch-to-tab-2 = [];
          shortcut-switch-to-tab-3 = [];
          shortcut-switch-to-tab-4 = [];
          shortcut-switch-to-tab-5 = [];
          shortcut-switch-to-tab-6 = [];
          shortcut-switch-to-tab-7 = [];
          shortcut-switch-to-tab-8 = [];
          shortcut-switch-to-tab-9 = [];
          shortcut-terminal-copy = ["<Shift><Control>c"];
          shortcut-terminal-paste = ["<Shift><Control>v"];
          shortcut-win-new-tab = [];
          shortcut-window-size-dec = [];
          shortcut-window-size-inc = [];
          window-maximize = false;
          window-size = 0.59986413043478259;
        };
        "org/gnome/shell/extensions/dash-to-dock" = {
          background-opacity = 0.80000000000000004;
          custom-theme-shrink = true;
          dash-max-icon-size = 48;
          dock-position = "LEFT";
          extend-height = false;
          height-fraction = 0.90000000000000002;
          hot-keys = false;
          preferred-monitor = -2;
          preferred-monitor-by-connector = "eDP-1";
        };
        "org/gnome/desktop/wm/keybindings" = {
          activate-window-menu = [];
          begin-move = [];
          begin-resize = [];
          close = ["<Alt>F4"];
          cycle-group = [];
          cycle-group-backward = [];
          cycle-panels = [];
          cycle-panels-backward = [];
          cycle-windows = [];
          cycle-windows-backward = [];
          maximize = ["<Super>Up"];
          minimize = [];
          move-to-monitor-down = [];
          move-to-monitor-left = [];
          move-to-monitor-right = [];
          move-to-monitor-up = [];
          move-to-workspace-1 = [];
          move-to-workspace-down = [];
          move-to-workspace-last = [];
          move-to-workspace-left = [];
          move-to-workspace-right = [];
          move-to-workspace-up = [];
          panel-run-dialog = ["<Alt>F2"];
          switch-applications = ["<Alt>Tab"];
          switch-applications-backward = ["<Shift><Alt>Tab"];
          switch-group = [];
          switch-group-backward = [];
          switch-input-source = [];
          switch-input-source-backward = [];
          switch-panels = [];
          switch-panels-backward = [];
          switch-to-workspace-1 = [];
          switch-to-workspace-down = [];
          switch-to-workspace-last = [];
          switch-to-workspace-left = ["<Control><Super>Left"];
          switch-to-workspace-right = ["<Control><Super>Right"];
          switch-to-workspace-up = [];
          toggle-maximized = [];
          unmaximize = [];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          control-center = ["<Super>i"];
          help = [];
          logout = [];
          magnifier = [];
          magnifier-zoom-in = [];
          magnifier-zoom-out = [];
          screenreader = [];
          screensaver = [];
        };
      };
    };
  };
}