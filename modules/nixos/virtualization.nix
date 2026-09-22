{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
  };

  systemd.services.docker.environment = {
    HTTP_PROXY = "http://127.0.0.1:10808";
    HTTPS_PROXY = "http://127.0.0.1:10808";
    NO_PROXY = "localhost,127.0.0.1";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
