{ config, pkgs, lib, ... }:

let
  forticlient-raw = pkgs.stdenv.mkDerivation {
    pname = "forticlient-raw";
    version = "7.2.12";
    src = pkgs.fetchurl {
      url = "https://ems.webdiscount.net:10443/installers/Default/WD-Intern-Linux/FortiClient_7.2.12.deb";
      sha256 = "sha256-o9wjXRHD/IMseVZ20BXP+aal2ofM7BNYBkDIAVvYK9U=";
    };
    nativeBuildInputs = [ pkgs.binutils ];
    unpackPhase = ''
      ar x $src
      tar -xzf data.tar.gz
    '';
    installPhase = ''
      mkdir -p $out/opt/forticlient
      cp -ra opt/forticlient/* $out/opt/forticlient/
      chmod -R +w $out/opt/forticlient
      find $out/opt/forticlient -type f -exec chmod +x {} +
    '';
  };

  forticlient-vpn = pkgs.buildFHSEnv {
    name = "forticlient";
    
    targetPkgs = pkgs: (with pkgs; [
      glibc gcc.cc.lib zlib openssl libsecret gtk3 nss nspr
      atk at-spi2-atk cups dbus expat fontconfig freetype
      gdk-pixbuf glib pango xorg.libX11 xorg.libXcomposite
      xorg.libXcursor xorg.libXdamage xorg.libXext xorg.libXfixes
      xorg.libXi xorg.libXrandr xorg.libXrender xorg.libXScrnSaver
      xorg.libXtst mesa libappindicator-gtk3 libdbusmenu-gtk3
      webkitgtk_4_1 libGL libthai libdrm cairo libgbm libxcb alsa-lib 
      libuuid libxkbcommon wayland systemd shadow
    ]) ++ [ forticlient-raw ];

    unshareNet = false;
    unshareIpc = false;
    unsharePid = false;
    unshareUser = false; # Required for UID/MachineID file operations

    runScript = "bash";

    extraBindMounts = [
      "/var/lib/forticlient"
      "/etc/forticlient"
      "/run/dbus"
      "/run/user/${toString config.users.users.jabertwo.uid}/bus"
      "/tmp"
    ];

    extraInstallCommands = ''
      ln -s $out/bin/forticlient $out/bin/forticlient-gui
      cat > $out/bin/forticlient-daemon <<EOF
#!${pkgs.bash}/bin/bash
exec $out/bin/forticlient /opt/forticlient/fctsched
EOF
      chmod +x $out/bin/forticlient-daemon
    '';

    profile = ''
      export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-data-schemas:$XDG_DATA_DIRS
      export LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib:$LD_LIBRARY_PATH
      
      if [ "$#" -gt 0 ]; then
        if [ -f "$1" ]; then
          exec "$@"
        else
          exec /opt/forticlient/forticlient-cli "$@"
        fi
      else
        exec /opt/forticlient/forticlient-cli
      fi
    '';
  };

in {
  environment.systemPackages = [ forticlient-vpn ];

  # Merged rules to create all necessary host directories
  systemd.tmpfiles.rules = [
    "d /var/lib/forticlient 0755 root root -"
    "d /etc/forticlient 0755 root root -"
  ];

  systemd.services.forticlient-daemon = {
    description = "FortiClient Scheduler Daemon";
    after = [ "network.target" "dbus.service" ];
    requires = [ "dbus.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${forticlient-vpn}/bin/forticlient-daemon";
      Type = "simple";
      User = "root";
      Restart = "always";
      RestartSec = "3";
      
      # Match the directory structure the binary expects
      RuntimeDirectory = "forticlient";
      StateDirectory = "forticlient";
      WorkingDirectory = "/var/lib/forticlient";
    };
  };
}