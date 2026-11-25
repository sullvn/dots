{ inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../common.nix
    ./homebrew.nix
    ./macos.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = "sullvn";
  networking.computerName = "sullvn";

  environment.shells = [ pkgs.fish ];

  users.knownUsers = [ "kevin" ];
  users.users.kevin = {
    home = "/Users/kevin";
    uid = 501;
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    # Lets Touch ID work for sudo inside tmux
    reattach = true;
  };

  home-manager.users.kevin = ./home.nix;

  system.primaryUser = "kevin";
  system.stateVersion = 6;
}
