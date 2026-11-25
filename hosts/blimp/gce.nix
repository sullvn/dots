{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/virtualisation/google-compute-image.nix")
  ];

  # ---------------------------------------------------------------
  # GCE C4A (Axion, aarch64) layer — keep this block permanently.
  # Without it, a rebuild would try to install BIOS GRUB to /dev/sda
  # (which doesn't exist on this NVMe-only Arm VM) and break boot.
  # ---------------------------------------------------------------
  virtualisation.googleComputeImage.efi = true;
  boot.loader.grub.device = lib.mkForce "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  # Arm serial console + required drivers (gVNIC net, NVMe root)
  boot.kernelParams = [ "console=ttyAMA0,115200n8" ];
  boot.kernelModules = [ "gve" ];
  boot.initrd.availableKernelModules = [ "nvme" ];

  # 26.05 OS Login PAM regression workaround (nixpkgs #476160).
  # Without this, key-based SSH for local users (kevin) is rejected.
  security.pam.services.sshd.rules.account.oslogin_login.control =
    lib.mkForce "[success=ok ignore=ignore default=ignore]";
  # ---------------------------------------------------------------
}
