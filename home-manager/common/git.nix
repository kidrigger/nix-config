{...}: {
programs.git = {
  enable = true;
  difftastic.enable = true;
  extraConfig = {
    init = { defaultBranch = "canon"; };
    help = { autocorrect = "immediate"; };
  };
  aliases = {
    co = "checkout";
    st = "status";
    b = "branch";     };
  };
}
