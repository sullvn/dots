{
  programs.git = {
    enable = true;

    lfs = {
      enable = true;
    };

    # userName/userEmail/extraConfig merged into `settings` (HM 26.05)
    settings = {
      user.name = "Kevin Sullivan";
      user.email = "kevin@sull.vn";
      merge.conflictStyle = "zdiff3";
    };
  };

  # delta is its own module now (was programs.git.delta)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      syntax-theme = "zenburn";
      dark = true;
      navigate = true;
      side-by-side = true;
    };
  };
}
