{
  disko.devices = {
    disk.main = {
      device = "/dev/sda";
      type = "disk";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };

          luks = {
            size = "100%";

            content = {
              type = "luks";
              name = "cryptroot";
              settings.allowDiscards = true;

              content = {
                type = "btrfs";
                extraArgs = ["-f"];

                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/root/.snapshots" = {};

                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/home/.snapshots" = {};

                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
