{pkgs, ...}: let
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    entries=" Lock\n Logout\n Reboot\n Poweroff"

    selected=$(printf "%b" "$entries" | wofi --dmenu --prompt "power" --cache-file /dev/null)

    case "$selected" in
      *Lock*) physlock -d -s ;;
      *Logout*) hyprctl dispatch exit ;;
      *Reboot*) systemctl reboot ;;
      *Poweroff*) systemctl poweroff ;;
    esac
  '';
in {
  home.packages = [powermenu];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    configType = "hyprlang";

    settings = {
      "$mod" = "SUPER";

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 0;
        "col.active_border" = "rgb(00ff00)";
        "col.inactive_border" = "rgb(003300)";
        layout = "master";
      };

      decoration = {
        rounding = 0;
        shadow.enabled = false;
        blur.enabled = false;
      };

      animations.enabled = false;

      input = {
        kb_layout = "us,ir";
        kb_options = "grp:ctrl_space_toggle,caps:swapescape";
        follow_mouse = 1;

        # Hyprland's defaults (repeat_delay=600, repeat_rate=25) are what
        # cause the "laggy" feel on held-down keys (j/k in qutebrowser,
        # hjkl/Ctrl-d etc. in Neovim, and everywhere else) since this is
        # the compositor's XKB repeat setting, not an app-level one.
        # Lower delay = repeat kicks in sooner, higher rate = faster once it does.
        repeat_delay = 200;
        repeat_rate = 50;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        background_color = "rgb(000000)";
      };

      "$terminal" = "foot";
      "$menu" = "wofi --show drun";
      "$filemanager" = "foot -e nnn";
      "$powermenu" = "powermenu";

      exec-once = [
        "waybar"
        "nm-applet --indicator"
        "blueman-applet"
        "firefox"
        "foot"
        "obsidian"
        "v2rayN"
      ];

      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, RETURN, exec, firefox"
        "$mod, SPACE, exec, $menu"
        "$mod, E, exec, $filemanager"
        "$mod, Escape, exec, physlock -d -s"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod, J, workspace, 1"
        "$mod, K, workspace, 2"
        "$mod, L, workspace, 3"
        "$mod, U, workspace, 4"
        "$mod, I, workspace, 5"
        "$mod, O, workspace, 6"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod SHIFT, J, movetoworkspace, 1"
        "$mod SHIFT, K, movetoworkspace, 2"
        "$mod SHIFT, L, movetoworkspace, 3"
        "$mod SHIFT, U, movetoworkspace, 4"
        "$mod SHIFT, I, movetoworkspace, 5"
        "$mod SHIFT, O, movetoworkspace, 6"

        "$mod SHIFT, Q, killactive"
        "$mod, F, fullscreen"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspacesilent, special:magic"

        "$mod SHIFT, Escape, exec, $powermenu"
        "$mod, B, exec, blueman-manager"
      ];

      windowrule = [
        "match:class ^(firefox)$, workspace 1 silent"
        "match:class ^(foot)$, workspace 2 silent"
        "match:class ^(md.obsidian.Obsidian)$, workspace 3 silent"
        "match:class ^(calibre-gui)$, workspace 4 silent"
        "match:class ^(Zotero)$, workspace 4 silent"
        "match:class ^(sioyek)$, workspace 5 silent"
        "match:class ^(org.telegram.desktop)$, workspace 7 silent"
        "match:class ^(v2rayN)$, workspace special:magic silent"
      ];
    };
  };

  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 20;
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["network" "pulseaudio" "tray"];

        "hyprland/workspaces" = {
          format = "{id}";
          format-window-separator = "  ";
          window-rewrite-default = "{class}";
          window-rewrite = {
            "class<firefox>" = "Firefox";
            "class<foot>" = "foot";
            "class<nnn>" = "nnn";
            "class<telegram-desktop>" = "Telegram";
          };
          tooltip = true;
        };

        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
        };

        network = {
          format-wifi = "W {signalStrength}%";
          format-ethernet = "E";
          format-disconnected = "OFF";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "MUTE";
        };

        tray = {
          spacing = 6;
        };
      }
    ];

    style = ''
      * {
        font-family: "BigBlueTermPlus Nerd Font Mono";
        font-size: 14px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }
      window#waybar {
        background: #000000;
        color: #fdfdfd;
      }

      #workspaces {
        margin: 0;
        padding: 0;
      }

      #workspaces button {
        margin: 0;
        padding: 2px 4px;

        background: #003300;
        color: #000000;

        border: 0;
        border-radius: 0;
      }

      #workspaces button:hover {
        background: #003300;
        color: #000000;
      }

      #workspaces button.active {
        background: #000000;
        color: #fdfdfd;
      }

      #workspaces button.empty {
        background: #003300;
        color: #000000;
      }

      #workspaces button.active {
        background: #000000;
        color: #fdfdfd;
      }

      #window {
        margin-left: 8px;
        padding: 0 8px;

        color: #fdfdfd;
      }

      #clock,
      #network,
      #pulseaudio,
      #tray {
        margin: 0;
        padding: 0 8px;

        background: #000000;
        color: #fdfdfd;
      }
    '';
  };

  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      width = 500;
      height = 400;

      prompt = "RUN:";
      allow_images = false;

      insensitive = true;
      hide_scroll = true;

      dynamic_lines = false;
    };

    style = ''
      * {
        font-family: "BigBlueTermPlus Nerd Font Mono";
        font-size: 16px;
      }

      window {
        margin: 0px;
        border: 1px solid #00ff00;
        background-color: #000000;
      }

      #input {
        margin: 8px;
        padding: 6px 8px;

        border: 1px solid #00ff00;
        border-radius: 0;

        background-color: #000000;
        color: #00ff00;
      }

      #inner-box {
        margin: 4px;
        background-color: #000000;
      }

      #outer-box {
        margin: 4px;
        background-color: #000000;
      }

      #scroll {
        margin: 0px;
      }

      #text {
        padding: 5px;
        color: #00ff00;
      }

      #entry {
        padding: 3px;
        background-color: #000000;
      }

      #entry:selected {
        background-color: #00ff00;
      }

      #entry:selected #text {
        color: #000000;
      }
    '';
  };

  services.mako = {
    enable = true;

    settings = {
      font = "BigBlueTermPlus Nerd Font Mono 12";
      background-color = "#000000";
      text-color = "#00ff00";
      border-size = 1;
      border-color = "#00ff00";
      border-radius = 0;
      default-timeout = 5000;
      padding = "8";
      margin = "8";
      width = 400;
    };
  };
}
