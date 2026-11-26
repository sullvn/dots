{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ../../home
    ./aerospace.nix
    ./ghostty.nix
  ];

  home.packages = [ pkgs.mosh ];

  programs.gh = {
    enable = true;
    # Avoid using read-only gh tokens for pushes, which would fail
    gitCredentialHelper.enable = false;
    settings.git_protocol = "ssh";
  };

  programs.ssh.settings = {
    "*".SecurityKeyProvider = "/usr/lib/ssh-keychain.dylib";
    blimp = {
      IdentityFile = "~/.ssh/id_ecdsa_sk_rk_blimp";
      IdentitiesOnly = true;
    };
    "github.com".IdentityFile = "~/.ssh/id_ecdsa_sk_rk_github";
  };

  home.stateVersion = "26.11";
}
