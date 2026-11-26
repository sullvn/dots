{ lib, pkgs, ... }:
let
  defaults = lib.importTOML "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/Resources/default-config.toml";
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = lib.recursiveUpdate defaults {
      gaps.inner = {
        horizontal = 12;
        vertical = 12;
      };
    };
  };
}
