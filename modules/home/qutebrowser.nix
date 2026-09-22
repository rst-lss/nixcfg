{
  config,
  pkgs,
  lib,
  ...
}: let
  # Official Bitwarden userscript, shipped in the qutebrowser repo itself
  # (misc/userscripts/qute-bitwarden), written by Chris Braun (cryzed),
  # same author as the well-known qute-pass script.
  #
  # NOTE: the sha256 below is a placeholder. Build once, Nix will print the
  # correct hash in the error message (or run:
  #   nix-prefetch-url https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/misc/userscripts/qute-bitwarden
  # and convert it with `nix hash to-sri --type sha256 <hash>`), then paste
  # it in below.
  qute-bitwarden = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/misc/userscripts/qute-bitwarden";
    sha256 = "sha256-oHjwIefAsjcDzVH1h+ykwFn+C0u+ALpFI2q6D6f0SiQ=";
  };
in {
  # --- Runtime dependencies for the Bitwarden userscript ---
  # bitwarden-cli  -> `bw`, the official CLI the script drives
  # keyutils       -> `keyctl`, used to cache the unlocked session key
  # wofi           -> Wayland-native dmenu-compatible picker (fits Hyprland)
  # wl-clipboard   -> lets qutebrowser/the script use the Wayland clipboard (for --totp)
  # python3 + libs -> the script's own shebang dependencies
  home.packages = with pkgs; [
    bitwarden-cli
    keyutils
    wofi
    wl-clipboard
    mpv
    yt-dlp
    (python3.withPackages (ps: with ps; [pyperclip tldextract]))
  ];

  # profile-sync-daemon: keeps the listed browsers' profiles in tmpfs and
  # periodically rsyncs them back to disk. Note this is NOT cross-browser
  # data sync (it will not share bookmarks/history/passwords between
  # Firefox and qutebrowser) - it just RAM-caches each one's own profile
  # for speed/reduced disk wear. Both are on psd's supported browser list.
  services.psd = {
    enable = true;
    browsers = ["firefox" "qutebrowser"];
  };

  xdg.configFile."qutebrowser/userscripts/qute-bitwarden" = {
    source = qute-bitwarden;
    executable = true;
  };

  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      DEFAULT = "https://www.google.com/search?q={}";
      g = "https://www.google.com/search?q={}";
      ddg = "https://duckduckgo.com/?q={}";
      gh = "https://github.com/search?q={}";
      nw = "https://nixos.wiki/index.php?search={}";
      yt = "https://www.youtube.com/results?search_query={}";
    };

    settings = {
      # --- General / keyboard-driven feel to match your Neovim+Hyprland setup ---
      auto_save.session = true;
      tabs.position = "top";
      tabs.show = "multiple";
      statusbar.show = "always";
      scrolling.smooth = true;
      completion.height = "30%";
      completion.shrink = true;

      # --- Appearance ---
      colors.webpage.darkmode.enabled = true;
      colors.webpage.preferred_color_scheme = "dark";

      # --- Content / privacy ---
      content.pdfjs = true;
      content.autoplay = false;
      content.notifications.enabled = true;
      content.geolocation = false;
      content.cookies.accept = "no-3rdparty";
      content.blocking.method = "both";
      content.blocking.adblock.lists = [
        "https://easylist.to/easylist/easylist.txt"
        "https://easylist.to/easylist/easyprivacy.txt"
      ];

      # --- Downloads ---
      # Reuses the download dir you already declared in directories.nix
      # (xdg.userDirs.download) instead of hardcoding a path here.
      downloads.location.directory = config.xdg.userDirs.download;
      downloads.location.prompt = false;

      # --- Open files/edit text fields in your existing foot+nvim setup ---
      editor.command = ["foot" "nvim" "{file}" "-c" "normal {line}G{column0}l"];
    };

    keyBindings = {
      normal = {
        # -- Bitwarden --
        # Fill username + password on the current page
        "<z><l>" = "spawn --userscript qute-bitwarden";
        # Fill login AND copy the entry's TOTP code to the clipboard
        "<z><o>" = "spawn --userscript qute-bitwarden --totp";

        # -- Precise, smaller-step j/k scrolling --
        # Default j/k ("scroll down"/"scroll up") jump by a large fraction
        # of the viewport. scroll-px moves by an exact pixel amount, which
        # combined with the faster Hyprland key-repeat (see hyprland.nix)
        # gives a smooth, fast, fine-grained scroll while held down.
        # Flip the sign of the second number if up/down feel reversed.
        "j" = "scroll-px 0 40";
        "k" = "scroll-px 0 -40";

        # -- mpv --
        # Open the current page's video in mpv (e.g. YouTube tabs)
        "<ctrl-v>" = "spawn mpv {url}";
        # Hint-pick any link on the page and open THAT in mpv instead
        ";m" = "hint links spawn mpv {hint-url}";

        # -- v2rayN proxy toggle --
        "<z><p>" = "set content.proxy http://127.0.0.1:10808";
        "<z><u>" = "set content.proxy system";
      };

      # Completion popup (colon commands + the URL bar) navigation
      command = {
        # Unbind the defaults so only Ctrl-n/Ctrl-p move the selection
        "<tab>" = null;
        "<shift-tab>" = null;
        "<ctrl-n>" = "completion-item-focus next";
        "<ctrl-p>" = "completion-item-focus prev";
        # Accept/run whatever is currently in the command line
        "<ctrl-y>" = "command-accept";
      };
    };

    extraConfig = ''
      # Anything with no declarative Home Manager option yet goes here.
    '';
  };
}
