{ inputs, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    user = "kevin";
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    casks = [
      "ghostty"
      "tailscale-app"
    ];
    # Cleanup removes App Store apps not listed here
    masApps = {
      Bitwarden = 1352778147;
      "Wipr 2" = 1662217862;
    };
  };
}
