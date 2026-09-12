{ ... }:

{
  services.snapper = {
    configs = {
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "rstlss" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
      };

      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "rstlss" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
      };
    };
  };
}
