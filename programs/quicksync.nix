{ pkgs, ... }:
let
  quicksync4linux = pkgs.python3Packages.buildPythonApplication {
    pname = "QuickSync4Linux";
    version = "2024-05-24";

    src = pkgs.fetchFromGitHub {
      owner = "schorschii";
      repo = "QuickSync4Linux";
      rev = "master";
      hash = "sha256-MWHd6rTv5qGEeRtDZnL6Q0+Jl+iAZzTz+H/iMT7ZRLs="; 
    };

    pyproject = true;

    # Hatchling wird benötigt, da der Fehler "Backend 'hatchling.build' is not available" meldet
    build-system = with pkgs.python3Packages; [
      hatchling
    ];

    propagatedBuildInputs = with pkgs.python3Packages; [ 
      pyserial 
    ];

    # Da das Repo eventuell keine sauberen Tests hat, schalten wir sie aus
    doCheck = false; 

    # Falls der Build immer noch meckert, dass er die ausführbare Datei nicht findet:
    meta = with pkgs.lib; {
      description = "Gigaset QuickSync implementation for Linux";
      homepage = "https://github.com/schorschii/QuickSync4Linux";
      license = licenses.gpl3Only;
      mainProgram = "quicksync4linux";
    };
  };
  quicksync-wrapper = pkgs.writeShellScriptBin "quicksync-dialer-wrapper" ''
      # %1 ist die URL, z.B. tel:012345
      DEVICE="/dev/rfcomm0"
      # Wir entfernen "tel:" und rufen das eigentliche Programm auf
      NUMBER=$(echo "$1" | sed 's/tel://g' | sed 's/ //g')
      ${quicksync4linux}/bin/quicksync -d "$DEVICE" dial "$NUMBER"
    '';
  
  # Die passende Desktop-Datei dazu
  quicksync-desktop = pkgs.makeDesktopItem {
    name = "quicksync-dialer";
    desktopName = "QuickSync4Linux Dialer";
    exec = "${quicksync-wrapper}/bin/quicksync-dialer-wrapper %u";
    icon = "phone";
    terminal = false;
    mimeTypes = [ "x-scheme-handler/tel" ];
  };
in
{
  services.udev.extraRules = ''
    KERNEL=="rfcomm[0-9]*", GROUP="dialout", MODE="0666"
  '';

  environment.systemPackages = [ 
    quicksync4linux 
    quicksync-wrapper
    quicksync-desktop 
  ];

  xdg.mime.defaultApplications = {
    "x-scheme-handler/tel" = "quicksync-dialer.desktop";
  };
  systemd.services.gigaset-bluetooth = {
    description = "Bind Gigaset Bluetooth RFCOMM";
    after = [ "bluetooth.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/rfcomm bind 0 7C:2F:80:4A:18:AE";
      ExecStop = "${pkgs.bluez}/bin/rfcomm release 0";
      RemainAfterExit = true;
      Restart = "on-failure";
    };
  };
}