{...}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "RSTLSS";
        email = "72990855+rst-lss@users.noreply.github.com";
      };

      init.defaultBranch = "main";

      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;

      core.editor = "nvim";

      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
