{ pkgs, ... }:
{
  home.packages = [ pkgs.commit-mono ];

  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      # Cell widths round to whole pixels, so recheck spacing if font size changes
      font-size = 13;
      adjust-cell-width = "-5%";

      font-family = "CommitMono";
      font-feature = [
        # Ligatures <= != ===
        "ss01"

        # Arrows >-> =>
        "ss02"

        # Smart case (1:1) 2+3
        "ss03"

        # Symbol spacing ... <<
        "ss04"

        # Smart kerning (immi)
        "ss05"

        # Alt. 'g'
        "cv02"

        # Alt. 'i'
        "cv04"

        # Alt. '6', '9'
        "cv06"
      ];
      macos-icon = "xray";
      macos-titlebar-style = "hidden";
      theme = "Gleam";
      window-colorspace = "display-p3";
    };
  };
}
