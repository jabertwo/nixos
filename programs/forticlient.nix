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
      mkdir -p $out/etc/pki/tls/certs
      ln -s /etc/ssl/certs/ca-bundle.crt $out/etc/pki/tls/certs/ca-bundle.crt
    '';
  };

  # Internal Launcher Script
  forticlient-internal-launcher = pkgs.writeScriptBin "forticlient-launcher" ''
    #!${pkgs.bash}/bin/bash
    
    # 1. Force GTK/Qt to find system assets
    export XDG_DATA_DIRS=/usr/share:$XDG_DATA_DIRS
    
    # 2. Critical rendering fixes
    export QT_X11_NO_MITSHM=1
    export _X11_NO_MITSHM=1
    export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt

    if [ "$1" == "scheduler" ]; then
      exec /opt/forticlient/fctsched
    elif [ "$1" == "gui" ]; then
      # --disable-zygote is often required alongside --no-sandbox to fix white screens
      exec /opt/forticlient/gui/FortiClient-linux-x64/FortiClient --no-sandbox --disable-zygote
    elif [ "$1" == "bash" ]; then
      exec /bin/bash
    else
      exec /opt/forticlient/forticlient-cli "$@"
    fi
  '';

  forticlient-vpn = pkgs.buildFHSEnv {
    name = "forticlient";
    
    targetPkgs = pkgs: (with pkgs; [
      # --- System & Network ---
      glibc gcc.cc.lib zlib openssl libsecret shadow
      nss nspr cups dbus systemd pciutils
      iproute2 iptables nettools kmod libnsl
      
      # --- UI Assets ---
      dejavu_fonts noto-fonts hicolor-icon-theme gsettings-desktop-schemas
      
      # --- Graphics & UI ---
      gtk3 glib atk at-spi2-atk cairo pango gdk-pixbuf
      libappindicator-gtk3 libdbusmenu-gtk3
      freetype fontconfig
      mesa libGL libgbm libdrm libv4l libglvnd
      
      # --- X11 / Wayland (CRITICAL FIX: libxshmfence) ---
      xorg.libX11 xorg.libXcomposite xorg.libXcursor xorg.libXdamage 
      xorg.libXext xorg.libXfixes xorg.libXi xorg.libXrandr 
      xorg.libXrender xorg.libXScrnSaver xorg.libXtst xorg.libxcb
      xorg.libxshmfence  # <--- THIS WAS MISSING
      libxkbcommon wayland
      
      # --- Audio/Video ---
      alsa-lib pipewire libpulseaudio
      
      # --- Misc ---
      expat libuuid libthai webkitgtk_4_1
    ]) ++ [ forticlient-raw forticlient-internal-launcher ];

    unshareNet = false;
    unshareIpc = false;
    unsharePid = false;
    unshareUser = false;
    runScript = "forticlient-launcher";

    extraBindMounts = [
      "/var/lib/forticlient" "/etc/forticlient" "/run/dbus" "/tmp" "/var/run" "/run" "/dev/shm"
      "/run/user/${toString config.users.users.jabertwo.uid}/bus"
    ];

    extraInstallCommands = ''
      ln -s $out/bin/forticlient $out/bin/forticlient-gui
      cat > $out/bin/forticlient-daemon-starter <<EOF
#!${pkgs.bash}/bin/bash
exec $out/bin/forticlient scheduler
EOF
      chmod +x $out/bin/forticlient-daemon-starter
    '';

    profile = ''
      export FONTCONFIG_FILE=/etc/fonts/fonts.conf
      export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-data-schemas:$XDG_DATA_DIRS
      export LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib:$LD_LIBRARY_PATH
    '';
  };

in {
  environment.systemPackages = [ forticlient-vpn ];

  systemd.tmpfiles.rules = [
    "d /var/lib/forticlient 0755 root root -"
    "d /etc/forticlient 0755 root root -"
    "d /run/forticlient 0755 root root -" 
  ];

  systemd.services.forticlient-daemon = {
    description = "FortiClient Scheduler Daemon";
    after = [ "network.target" "dbus.service" ];
    requires = [ "dbus.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${forticlient-vpn}/bin/forticlient-daemon-starter";
      Type = "simple";
      User = "root";
      Restart = "always";
      RestartSec = "3";
      UMask = "0022"; 
      PrivateTmp = false; 
      StateDirectory = "forticlient"; 
      RuntimeDirectory = "forticlient";
      WorkingDirectory = "/var/lib/forticlient";
    };
  };
}