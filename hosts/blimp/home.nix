{ inputs, ... }:
{
  imports = [
    inputs.nixvim-stable.homeModules.nixvim
    ../../home
    ./remote-control.nix
  ];

  programs.ssh = {
    # matchBlocks -> settings (HM 26.05 rename)
    settings = {
      "*".AddKeysToAgent = "yes";
      "github.com".IdentityFile = "~/.ssh/id_ed25519";
    };
  };

  # Fresh home on a fresh 26.05 machine.
  home.stateVersion = "26.05";
}
