{ pkgs, ... }:

let
  # A small utility that intercepts socket creation and binds it to a specific interface
  bindfs = pkgs.writeShellScriptBin "bambustudio-wifi" ''
    # 1. Dynamically locate the first wireless interface name on this machine
    WIFI_IFACE=$( ${pkgs.iproute2}/bin/ip -o link show | ${pkgs.gawk}/bin/awk -F': ' '$2 ~ /^wl/ {print $2; exit}' )

    if [ -z "$WIFI_IFACE" ]; then
      for dev in /sys/class/net/*; do
        if [ -d "$dev/wireless" ]; then
          WIFI_IFACE=$(basename "$dev")
          break
        fi
      done
    fi

    if [ -z "$WIFI_IFACE" ]; then
      echo "Error: No Wi-Fi interface detected on this machine." >&2
      exit 1
    fi

    echo "Forcing Bambu Studio traffic exclusively through: $WIFI_IFACE"

    # 2. Launch Flatpak natively using the standard Linux BINDTOdevice environment wrapper
    # We use a subshell to inject the target device directly into Flatpak's environment flags
    exec flatpak run --device=all --env=BIND_INTERFACE="$WIFI_IFACE" com.bambulab.BambuStudio "$@"
  '';

  bambustudio-wifi-desktop = pkgs.makeDesktopItem {
    name = "bambustudio-wifi";
    desktopName = "Bambu Studio (Wi-Fi Only)";
    genericName = "3D Printing Software";
    exec = "${bindfs}/bin/bambustudio-wifi %F";
    icon = "com.bambulab.BambuStudio";
    terminal = false;
    categories = [ "Graphics" "3DGraphics" "Engineering" ];
    mimeTypes = [ "model/stl" "model/3mf" "application/vnd.ms-3mf" ];
  };
in
{
  environment.systemPackages = [
    bindfs
    bambustudio-wifi-desktop
  ];
}
