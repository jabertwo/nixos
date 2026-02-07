{ config, pkgs, ... }:
let
  plymouth-theme-windows-xp = pkgs.stdenv.mkDerivation {
    pname = "plymouth-theme-windows-xp";
    version = "1.0";

    # We use Liftu's repo which includes the assets and 1080p scaling
    src = pkgs.fetchFromGitHub {
      owner = "Liftu";
      repo = "WindozeXP-1080-Plymouth-theme";
      rev = "master"; 
      sha256 = "sha256-3qCIB2mTlTCLHMQ6u9/3xN9Hgz+L5MrdVMcyUy5HDVs=";
    };

    installPhase = ''
      # 1. Define the target directory
      targetDir="$out/share/plymouth/themes/windows-xp"
      mkdir -p $targetDir
      
      # 2. Copy ALL files from the source to the target
      cp -r * $targetDir
      cd $targetDir

      # 3. FLATTEN the directory structure (Crucial Step)
      # If the repo put files inside a sub-folder (e.g. 'theme/'), this moves them 
      # all to the main directory so Plymouth can find the images.
      find . -mindepth 2 -type f -exec mv -f {} . \; || true

      # 4. Find and Rename the Config File
      # We look for ANY file ending in .plymouth and rename it to windows-xp.plymouth
      PLYMOUTH_FILE=$(find . -maxdepth 1 -name "*.plymouth" | head -n 1)
      if [ -n "$PLYMOUTH_FILE" ]; then
        mv "$PLYMOUTH_FILE" windows-xp.plymouth
      else
        echo "Error: No .plymouth file found!" && exit 1
      fi

      # 5. Find and Rename the Script File
      # We look for ANY file ending in .script and rename it to windows-xp.script
      SCRIPT_FILE=$(find . -maxdepth 1 -name "*.script" | head -n 1)
      if [ -n "$SCRIPT_FILE" ]; then
        mv "$SCRIPT_FILE" windows-xp.script
      fi

      # 6. Patch the Configuration File
      # Now that we have normalized the filenames and locations, we update the paths.
      sed -i "s@ImageDir=.*@ImageDir=$targetDir@" windows-xp.plymouth
      sed -i "s@ScriptFile=.*@ScriptFile=$targetDir/windows-xp.script@" windows-xp.plymouth
    '';
  };

in
{
  boot.plymouth = {
    enable = true;
    theme = "windows-xp";
    themePackages = [ plymouth-theme-windows-xp ];
    extraConfig = ''
      [Daemon]
      ShowDelay=0
    '';
  };
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
}