_: {
  programs.fd = {
    enable = true;
    ignores = [
      ".git/"
      ".cache/"
      "Applications/"
      "Library/"
    ];
  };
}
