_: {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "monospace:size=12";
        term = "xterm-256color";
        dpi-aware = "yes";
        bold-text-in-bright = "yes";
      };

      scrollback = {
        lines = 10000;
      };

      cursor = {
        style = "block";
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
