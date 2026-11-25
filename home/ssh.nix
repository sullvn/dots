{
  programs.ssh = {
    enable = true;
    # HM is dropping its implicit ssh_config defaults; opting out
    # silences the warning. Anything you relied on from those
    # defaults belongs under settings."*".
    enableDefaultConfig = false;
    settings."github.com" = {
      User = "git";
      IdentitiesOnly = true;
    };
  };
}
