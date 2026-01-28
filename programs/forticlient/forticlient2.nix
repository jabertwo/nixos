{ pkgs ? import <nixpkgs> {} }:

let
  runtimeTools = with pkgs; [
    ppp iproute2 nettools iptables util-linux
  ];

  runtimeLibs = with pkgs; [
    gtk2 libnotify libdrm mesa
    libuuid libgcc libsecret glib systemd sqlite nss nspr alsa-lib
    gtk3 gdk-pixbuf cairo pango atk
    xorg.libX11 xorg.libxcb xorg.libXi xorg.libXcursor xorg.libXdamage
    xorg.libXrandr xorg.libXcomposite xorg.libXext xorg.libXfixes
    xorg.libXScrnSaver libxkbcommon wayland
  ];

in pkgs.stdenv.mkDerivation rec {
  pname = "forticlient";
  version = "7.2.12";

  src = pkgs.fetchurl {
    url = "https://ems.webdiscount.net:10443/installers/Default/WD-Intern-Linux/FortiClient_7.2.12.deb";
    hash = "sha256-o9wjXRHD/IMseVZ20BXP+aal2ofM7BNYBkDIAVvYK9U=";
  };

  nativeBuildInputs = with pkgs; [ autoPatchelfHook dpkg makeWrapper ];
  buildInputs = runtimeLibs;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share
    mkdir -p $out/etc/forticlient

    # 1. Move files to lib
    mv opt/forticlient $out/lib/

    # 2. FORCE PERMISSIONS
    chmod -R 755 $out/lib/forticlient

    # 3. Create Wrappers
    
    # Helper function
    wrap_binary() {
        if [ -f "$1" ]; then
            echo "Wrapping $1 to $out/bin/$2"
            makeWrapper "$1" "$out/bin/$2" \
                --prefix PATH : ${pkgs.lib.makeBinPath runtimeTools}
        else
            echo "WARNING: Could not find binary: $1"
        fi
    }

    # A. SCHEDULER & CONTROL (Found in root)
    wrap_binary "$out/lib/forticlient/fctsched" "fctsched"
    wrap_binary "$out/lib/forticlient/epctrl"   "epctrl"

    # B. CLI (Handle dash vs underscore)
    if [ -f "$out/lib/forticlient/forticlient-cli" ]; then
        wrap_binary "$out/lib/forticlient/forticlient-cli" "forticlient_cli"
    elif [ -f "$out/lib/forticlient/forticlient_cli" ]; then
        wrap_binary "$out/lib/forticlient/forticlient_cli" "forticlient_cli"
    fi

    # C. GUI (Handle deep nesting in 7.2.12)
    # Check deep path first, then root path
    if [ -f "$out/lib/forticlient/gui/FortiClient-linux-x64/FortiClient" ]; then
        wrap_binary "$out/lib/forticlient/gui/FortiClient-linux-x64/FortiClient" "forticlient"
    elif [ -f "$out/lib/forticlient/FortiClient" ]; then
        wrap_binary "$out/lib/forticlient/FortiClient" "forticlient"
    elif [ -f "$out/lib/forticlient/forticlient" ]; then
        wrap_binary "$out/lib/forticlient/forticlient" "forticlient"
    fi
  '';

  dontWrapGApps = true;
}