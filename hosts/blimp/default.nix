{ inputs, ... }:
{
  imports = [
    inputs.home-manager-stable.nixosModules.home-manager
    ../common.nix
    ./gce.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  networking.hostName = "blimp";

  # Use compression to use RAM as swap when possible. zswap keeps
  # swapped-out pages compressed in RAM and only spills to the disk
  # swapfile when that pool fills (zswap requires a swap device).
  boot.zswap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # MiB
    }
  ];

  users.users.kevin = {
    isNormalUser = true;
    # Run user services (claude-rc, codex-rc) at boot and keep them alive after logout.
    linger = true;
    description = "Kevin";
    extraGroups = [
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3fdsGuwFp0H4cBBvLmUDxs972Si7oc/PV0fGQufpLw kevin@ipad"
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBL7VJFlygTWUtu2pujRnKpJyeLPYchNcfpVUL/3rA3+JOKwn7f1ZNDUhK9bvDiNy6Af2nLRjBWYNZzEn9epXLukAAAAEc3NoOg== kevin@sullvn"
    ];
  };

  programs.mosh.enable = true;
  programs.ssh.startAgent = true;

  # Tailscale. Host firewall stays off (GCE module default) — GCP's
  # VPC firewall is the gatekeeper. One-time `tailscale up` to auth.
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--operator=kevin" ];
  };

  virtualisation.docker.enable = true;

  nix.gc.dates = "weekly";

  security.sudo.wheelNeedsPassword = false;

  home-manager.users.kevin = ./home.nix;

  # Fresh 26.05 install — stateVersion marks first install of THIS
  # machine and should not be carried over from lab.
  system.stateVersion = "26.05";
}
