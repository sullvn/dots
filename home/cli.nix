{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    pkgs.hexyl
    pkgs.jq
    pkgs.xh
    pkgs.yazi
  ];

  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza.enable = true;

  programs.fd.enable = true;

  programs.fzf.enable = true;

  programs.ripgrep.enable = true;
}
