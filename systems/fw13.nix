{ config, pkgs, lib, inputs, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.framework-13-7040-amd
    inputs.lanzaboote.nixosModules.lanzaboote
  ];


  # Bootloader Settimgs
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Systemd-Boot
  #  boot.loader.systemd-boot = { 
  #    enable = true;
  #    editor = false;
  #    consoleMode = "max";
  #  };

  # Silent boot
  boot.consoleLogLevel = 3;
  boot.plymouth.enable = true;

  networking.hostName = "jabertwo-fw13";

  environment.systemPackages = with pkgs; [
    tpm2-tss
    sbctl
  ];

  # Secure boot
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Enable fingerint support
  services.fprintd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # warpzone CA
  security.pki.certificates = [ ''Warpzone internal CA
-----BEGIN CERTIFICATE-----
MIIFBDCCAuygAwIBAgIUJt6dSah3Lpsy3zenka2t+OEOO6AwDQYJKoZIhvcNAQEL
BQAwGjEYMBYGA1UEAwwPd2FycHpvbmUubGFuIENBMB4XDTIzMDIyMTIxNDQ0OVoX
DTMzMDIxODIxNDQ0OVowGjEYMBYGA1UEAwwPd2FycHpvbmUubGFuIENBMIICIjAN
BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5hXLG/f8q2zVdtmrDeFHz/NYgd37
Rtv6Pl1fLd1z3E1JvwSNF/s0Qv9kXyK6RQfaO/5AqzRQTkwiR7pZ7aS5WPjPK3yL
vJBVfnwKqFlu3QIfwWc81kY2K3jDnXujeaKFmLFh8UIc6IZQPmM+CzV+1yY44bE4
gdF9vblilMdq5dnqZUnpiXWeFx7AUsOHYr/Ee4/HvudpSpC5gBIMVti0qqCgkhMi
tKdymFQ02seLR1P7J0LbUdCq8GZ4yQ6LvDLrpDj5KZuGAWL7fp9tF/GSOhDcNGPV
kACqzgftkqg+3Nomz31QwIvW0mz+y6n1mkm2Yg6H/h4XzOahbQkXb0YsHkFNFIS4
0W64WgfDrIBs/FvfVxWSSINWEMWrZtKcYEMN2LmlioK4SGO7KrNmnd9MuSkZHLzM
Xb240ixnrLTTpc4CzlXT78Z0C0fsZG8nJvuM++l/L+LSf0PXSephNsw3we4iTkQB
UZBPcGSkdd9Ba131JFyqm49x7u/Xv7Pv9OLmrrkzHcU4wZ7wl5CCFdtDxNq/ATkt
PBkI/1qlIf7aKCUVz0sl1rpFXKcYIcYHMjLPjbBtkEp2jr4d0YDtkr4iGqSypbJG
HSiBY4ncaMnrOAlhJhn/fbl6bp3Ty5JB/q3PjS0a5Ark4LM34MsJlTHVGjbA5lOA
/rxXERzkzUBF7icCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgIEMA8GA1UdEwEB/wQF
MAMBAf8wHQYDVR0OBBYEFGj0ueBuUflIhRe3vmKcOqesGSrpMA0GCSqGSIb3DQEB
CwUAA4ICAQAohHr/je7DsMzPyABL+gxIVQO+lvH3NAJCilC4bSVfJVK3u6TwK8k1
uBFZ7HFT75PQCVmtnVcGwlwdHjILJXlbyKNhQngayuSbyV3ewXKtcJhAkepRKwlS
cKKp6J23BzvM6tHA8NlCnepaACvXQWHsfj1IeRXsYpoqSsDi6S1R5kdtUB3CiUDN
xOI5HKCnQ49lchVkzRXWeRpCEBw7/XZU5hSbLhnPCq2sUcv1YTWK1FTX2nFWW1mJ
Q2CMfYg9ulCL4pEMfzUAzZAKlAAiQSdg9XUftizJN7E4PiiHxwNF3jNUKakVVrNa
wm/m6nEKkAiXwI6wAjICMvE4inFWixLthMhUER8XGI0s2sZIqhRdkzoIX1KjdfDY
xeIr6jSK/evUNPeC4C2HqO6w9sXWvTPMfhcIdcft1hHG9oQeaLekI+PHP9FDVEYt
FlMwqZqITRNZvcmiUgyVdPBe5dCrwccEtpmHWh57SdhcsZaEiEw6u+MWCrFSDdbO
WjYdQR9h/EgWoUlzw49G5jo874uI/qMiB7TatRGGjDtztFjg69O3brH+y9yhRFaj
i0hZhNAPEXhwMaokGxI40B78QmVnWmDcrQ/fn0lhZeI79VLv1mmhPi9C4v1/Gm80
/RiTDO0scPgtDhazoZV69CcV2+Dnyx9Z1FkXMX8mNzTBhH40KVUkFg==
-----END CERTIFICATE-----
  ''];

}