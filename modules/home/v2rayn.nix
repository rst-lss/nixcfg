{pkgs, ...}: let
  iranRules = rev: {
    geoip = pkgs.fetchurl {
      url = "https://github.com/Chocolate4U/Iran-v2ray-rules/releases/download/${rev}/geoip.dat";
      hash = "sha256-GsYQm+tI0AlC8QjtB8lfe3Gs7ceuJrYb0YBe5zuS92c=";
    };
    geosite = pkgs.fetchurl {
      url = "https://github.com/Chocolate4U/Iran-v2ray-rules/releases/download/${rev}/geosite.dat";
      hash = "sha256-E6QsXf82kUUbmbuC2SonIifXjRgQaqKRUmAglsAadXo=";
    };
  };
  rules = iranRules "202609110905";
in {
  home.packages = [
    pkgs.v2rayn
  ];

  xdg.dataFile = {
    "v2rayN/bin/xray/xray".source = "${pkgs.xray}/bin/xray";
    "v2rayN/bin/geoip.dat".source = rules.geoip;
    "v2rayN/bin/geosite.dat".source = rules.geosite;
  };
}
