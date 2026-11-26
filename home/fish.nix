{
  # Suppress the "Last login" banner
  home.file.".hushlogin".text = "";

  programs.fish = {
    enable = true;
    functions.fish_greeting = "";
    shellAliases.e = "nvim";
  };

  programs.starship = {
    enable = true;
    settings = {
      gcloud.disabled = true;
      nix_shell.disabled = true;
      nodejs.disabled = true;
      package.disabled = true;
      rust.disabled = true;
    };
  };
}
