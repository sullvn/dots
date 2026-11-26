{
  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";

    dock = {
      autohide = true;
      # AeroSpace recommends grouping windows by application in Mission Control
      expose-group-apps = true;
      orientation = "left";
      show-recents = false;
    };

    finder.ShowPathbar = true;

    # AeroSpace recommends turning off "Displays have separate Spaces"
    spaces.spans-displays = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
