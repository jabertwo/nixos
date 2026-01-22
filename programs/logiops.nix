{ pkgs, ... }:

{
  # 1. Install the LogiOps package
  environment.systemPackages = [ pkgs.logiops ];

  # 2. Create the systemd service to run logid
  systemd.services.logiops = {
    description = "Logitech Configuration Daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid";
      Restart = "on-failure";
    };
    # Remove graphical.target and use basic.target or just multi-user
    after = [ "basic.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  # 3. Define your mouse configuration
  environment.etc."logid.cfg".text = ''
    devices: (
    {
        name: "Wireless Mouse MX Master 3";
        smartshift: { on: true; threshold: 30; };
        hires_scroll: { hires: true; invert: false; target: false; };
    
        buttons: (
            {
                cid: 0xc3;
                action = {
                    type: "Gestures";
                    gestures: (
                        { direction: "Left"; mode: "OnRelease"; action = { type: "Keypress"; keys: ["KEY_LEFTCTRL", "KEY_LEFTMETA", "KEY_LEFT"]; }; },
                        { direction: "Right"; mode: "OnRelease"; action = { type: "Keypress"; keys: ["KEY_LEFTCTRL", "KEY_LEFTMETA", "KEY_RIGHT"]; }; }
                    );
                };
            }
        );
    }
    );
  '';
}